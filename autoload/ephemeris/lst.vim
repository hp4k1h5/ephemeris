" vim:tabstop=2:shiftwidth=2:expandtab:textwidth=80
" Filename: autoload/lst.vim
" Description: everything concerning lists and checkboxes
" Home: https://github.com/HP4k1h5/ephemeris/

""
" @public
"
" will find the nearest associated task looking back up the buffer 
"
" Returns the line number of the associated task or -1 if no such task is found
function! ephemeris#lst#find_task()
  let l:cp = getcurpos()

  let l:i = l:cp[1]
  while l:i >= 0
    let line = getline(l:i)
        if stridx(line, '- [') > -1 && line !~ '- [\(x\| \)\](.*)'
      return l:i
    endif
    let l:i -= 1
  endwhile
  return -1
endfunction


""
" @public 
" Copy TODOs from last set of TODOs going back up to 10 years. Your
" @setting(g:ephemeris_diary) directory must  be organized in a
" `.../YYYY/MM/DD.md` hierarchy, in order for this function to know which set of
" TODOs are _most recent_. TODOs are defined by the string set in
" @setting(g:ephemeris_todos). Default is 'TODOs'. **Everything** below that
" marker is copied to the current day's diary entry. It will open today's diary
" entry in a split. This function can be called from anywhere.
function! ephemeris#lst#copy_todos()

  " create today's path and .md entry file if necessary
  try
    " get diary_dir
    let l:diary_dir = ephemeris#var#get_g_diary()
    " get today's diary entry filepath
    let l:today = ephemeris#fs#get_set_date(0)
  catch 
    execute 'silent! echoerr v:exception'
    return
  endtry
  
  " get/set g:ephemeris_todos
  call ephemeris#var#get_set_g_todos()

  " look back through a year's worth of potential diary entries
  let l:dp = 1
  while l:dp < 365 * 2 "10
    let l:prev = substitute(
          \ system('date -v -'.l:dp."d '+%Y/%m/%d'"),
          \ '\n', '', 'g')
    let l:fn = l:diary_dir.'/'.l:prev.'.md'

    if filereadable(l:fn)
      " if file contains a todo, extract list and dump in today's entry
      " TODO: currently TODO lists need to end the file, a smarter function
      "     : will only grab `-` etc lines up to a natural end, 
      "     : e.g. 3 consecutive newlines
      let l:todo_start = system('grep -n "'.g:ephemeris_todos.'" '.l:fn)
      if len(l:todo_start)
        " get line number of g:ephemeris_todos string
        let l:todo_start = split(l:todo_start, ':')[0]
        " add buff, dump todo list, open latest entry, exit loop
        execute 'badd '.l:fn
        execute 'silent! '.bufnr(l:fn).' bufdo! '.l:todo_start.',$ w! >> '.l:today
        execute 'silent! b '.l:today
        break
      endif
    endif

    " go back one day further
    let l:dp+=1
  endwhile
endfunction


""
" @public 
" Filter out completed tasks and their associated blocks in the current buffer. i.e., if you have a set of tasks like,
" >
"   - [ ] ephemeris docs
"     -[x] `.md`
"       - more list items but not tasks
"         and a nested block of text
"         with a few lines
"     -[ ] `txt`
"       more text
"       up to two blank lines
"       
"
"       - and more items etc. 
"   - [x] export autocommands
" <
" and you run `:EphemerisFilterTasks` in the command-line mode, you will be left
" with
" >
"   - [ ] ephemeris docs
"     -[ ] `txt`
"       more text
"       up to two blank lines
"       
"
"       - and more items etc. 
" <
" If [a:1], the first parameter passed to this function, is not false, filtered
" tasks will be moved to 'g:ephemeris_diary'/.cache/archive.md. If [a:2], the
" second parameter, is not false, a task summary will be printed a the bottom of
" the current buffer. This summary will not be copied over by EphemerisCopyTodos
function! ephemeris#lst#filter_tasks(...)

  " handle optional archive param
  let l:a1 = get(a:, '1')
  let l:a2 = get(a:, '2')

  if l:a1
    try 
      let l:diary = ephemeris#var#get_g_diary()
      let l:archive = l:diary.'/.cache/archive.md'
    catch
      execute 'silent! echoerr '.v:exception
      return
    endtry

    " create file if not exists
    call ephemeris#fs#create_fp(l:archive)
    " echo date to archive
    call system('echo "## ::"$(date +"%Y/%m/%d")"::" >> '.l:archive)
    " add to buffers
    execute 'badd '.l:archive
  endif

  " get/set ephemeris_todos, if no setting is provided, the default is set
  call ephemeris#var#get_set_g_todos()
  
  let l:i = 1
  let l:skip = 0
  let l:completed_count = 0
  let l:incomplete_count = 0
  " getbufline will check '$' on each iteration, and not overrun EOF though
  " lines may be deleted and final buffer length may be less than original
  " buffer length
  for line in getbufline('%', 1, '$')

    " skip deleted nested items, skip is accumulated inside while loop
    if l:skip > 0
      let l:skip -= 1
      continue
    endif

    " delete completed items, i.e. lines containing `- [x]` and associated
    " sub-blocks. on stridx >-1, check again for url after list item see
    " https://github.com/HP4k1h5/ephemeris/issues/13
    if stridx(line, '- [x]') > -1 && line !~ '- [\(x\| \)\](.*)'
      " add to count
      let l:completed_count += 1

      " add completed task to archive
      if l:a1
          execute 'silent! '.l:i.'w! >> '.l:archive
      endif

      " delete task line
      execute l:i.'d'

      " delete nested items underneath completed tasks
      " stop on any task item, g:ephemeris_todos, or 2 blank lines
      while l:i <= line('$') 
            \ && getline(l:i) !~ '^- \['
            \ && stridx(getline(l:i), g:ephemeris_todos) == -1
            \ && join(getline(l:i, l:i+1), '') !~ '^$' 

        " add subblock to archive
        if l:a1
          execute l:i.'w! >> '.l:archive
        endif

        " delete line
        execute l:i.'d'

        " for each line of sub-block, add one to skip counter
        let l:skip += 1
      endwhile

    else
      " count incomplete tasks
      if stridx(line, '- [ ]') > -1 && line !~ '- [ \](.*)'
        let l:incomplete_count += 1
      endif
      " continue iterating over the buffer lines
      let l:i += 1
    endif
  endfor

  if l:a1
    " add newline
    call system('echo "" >> '.l:archive)
    " save all
    execute 'silent! wa!'
  endif 

  " append the todos marker to prevent copy_todos from grabbing counts
  if l:a2
    call append('$', '##### filter summary: '.g:ephemeris_todos)
    let l:out_message = l:a1 ? 'moved to archive' : 'deleted'
    call append('$', '<< '.l:completed_count.' tasks '.l:out_message)
    call append('$', '>> '.l:incomplete_count. ' tasks remaining')
  endif
endfunction

""
" @public
" Toggle state of task on the line under the cursor between
" >
"   - [ ] incomplete, and
"   - [x] complete
" <
" if 'g:ephemeris_toggle_block' is true, the function will toggle the parent
" task of the current block. 
"
" Returns 0
function! ephemeris#lst#toggle_task()

  " check for toggle_block
  if ephemeris#var#get_g_toggle_block()
    let l:n = ephemeris#lst#find_task()
  else
    let l:n = line('.')
  endif

  let l:l = getline(l:n)
  let l:c = '- [x]'
  let l:u = '- [ ]'
  if stridx(l:l, l:u) > -1
    call setline(l:n, substitute(l:l, escape(l:u, '['), l:c, ''))
  elseif stridx(l:l, l:c) > -1 
    call setline(l:n, substitute(l:l, escape(l:c, '['), l:u, ''))
  endif
endfunction
