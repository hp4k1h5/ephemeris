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
  let cp = getcurpos()

  let i = cp[1]
  while i >= 0
    let line = getline(i)
        if match(line, '^ *-') > -1 && line !~ '- [\(x\| \)\](.*)'
      return i
    endif
    let i -= 1
  endwhile
  return -1
endfunction


""
" @public 
" Copy TODOs from last set of TODOs going back up to 10 years. Your
" @setting(g:ephemeris_diary) directory must  be organized in a
" `.../YYYY/MM/DD.md` hierarchy, in order for this function to know which set of
" TODOs are _most recent_. TODOs are defined by the string set in
" @setting(g:ephemeris_todos). Default is 'TODOs'. Everything below that marker,
" until 2 consecutive newlines, an incomplete task, or a subsequent
" g:ephemeris_todos marker, is copied to the current day's diary entry. It will
" open today's diary entry in a split.
function! ephemeris#lst#copy_todos()

  " create today's path and .md entry file if necessary
  try
    " get diary_dir
    let diary_dir = ephemeris#var#get_g_diary()
    " get today's diary entry filepath
    let today = ephemeris#fs#get_set_date(0)
  catch 
    execute 'silent! echoerr v:exception'
    return
  endtry
  
  " get/set g:ephemeris_todos
  call ephemeris#var#get_set_g_todos()

  " look back through a year's worth of potential diary entries
  let dp = 1
  while dp < 365 * 2 "10
    let prev = substitute(
          \ system('date -v -'.dp."d '+%Y/%m/%d'"),
          \ '\n', '', 'g')
    let fn = diary_dir.'/'.prev.'.md'

    if filereadable(fn)
      " if file contains a todo, extract list and dump in today's entry
      " TODO: currently TODO lists need to end the file, a smarter function
      "     : will only grab `-` etc lines up to a natural end, 
      "     : e.g. 3 consecutive newlines
      let todo_start = system('grep -n "'.g:ephemeris_todos.'" '.fn)
      if len(todo_start)
        " get line number of g:ephemeris_todos string
        let todo_start = split(todo_start, ':')[0]
        " add buff, dump todo list, open latest entry, exit loop
        execute 'badd '.fn
        execute 'silent! '.bufnr(fn).' bufdo! '.todo_start.',$ w! >> '.today
        execute 'silent! b '.today
        break
      endif
    endif

    " go back one day further
    let dp+=1
  endwhile
endfunction


""
" @public 
" Filter out completed tasks and their associated blocks in the current buffer.
" i.e., if you have a set of tasks like,
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
  let a1 = get(a:, '1')
  let a2 = get(a:, '2')

  if a1
    try 
      let diary = ephemeris#var#get_g_diary()
      let archive = diary.'/.cache/archive.md'
    catch
      execute 'silent! echoerr '.v:exception
      return
    endtry

    " create file if not exists
    call ephemeris#fs#create_fp(archive)
    " echo date to archive
    call system('echo "## ::"$(date +"%Y/%m/%d")"::" >> '.archive)
    " add to buffers
    execute 'badd '.archive
  endif

  " get/set ephemeris_todos, if no setting is provided, the default is set
  call ephemeris#var#get_set_g_todos()
  
  let i = 1
  let skip = 0
  let completed_count = 0
  let incomplete_count = 0
  " getbufline will check '$' on each iteration, and not overrun EOF though
  " lines may be deleted and final buffer length may be less than original
  " buffer length
  for line in getbufline('%', 1, '$')

    " skip deleted nested items, skip is accumulated inside while loop
    if skip > 0
      let skip -= 1
      continue
    endif

    " delete completed items, i.e. lines containing `- [x]` and associated
    " sub-blocks. on stridx >-1, check again for url after list item see
    " https://github.com/HP4k1h5/ephemeris/issues/13
    if stridx(line, '- [x]') > -1 && line !~ '- [\(x\| \)\](.*)'
      " add to count
      let completed_count += 1

      " add completed task to archive
      if a1
          execute 'silent! '.i.'w! >> '.archive
      endif

      " delete task line
      execute i.'d'

      " delete nested items underneath completed tasks
      " stop on any task item, g:ephemeris_todos, or 2 blank lines
      while i <= line('$') 
            \ && getline(i) !~ '^ *- \['
            \ && stridx(getline(i), g:ephemeris_todos) == -1
            \ && join(getline(i, i+1), '') !~ '^$' 

        " add subblock to archive
        if a1
          execute i.'w! >> '.archive
        endif

        " delete line
        execute i.'d'

        " for each line of sub-block, add one to skip counter
        let skip += 1
      endwhile

    else
      " count incomplete tasks
      if stridx(line, '- [ ]') > -1 && line !~ '- [ \](.*)'
        let incomplete_count += 1
      endif
      " continue iterating over the buffer lines
      let i += 1
    endif
  endfor

  if a1
    " add newline
    call system('echo "" >> '.archive)
    " save all
    execute 'silent! wa!'
  endif 

  " append the todos marker to prevent copy_todos from grabbing counts
  if a2
    call append('$', '##### filter summary: '.g:ephemeris_todos)
    let out_message = a1 ? 'moved to archive' : 'deleted'
    call append('$', '<< '.completed_count.' tasks '.out_message)
    call append('$', '>> '.incomplete_count. ' tasks remaining')
  endif
endfunction

""
" @public
" Toggle state of task on the line under the cursor through
" @public(g:ephemeris_cb_types).
" If 'g:ephemeris_toggle_block' is true, the function will toggle the parent
" task of the current block.
"
" Returns 0
function! ephemeris#lst#toggle_task()

  " check for toggle_block
  if ephemeris#var#get_g_toggle_block()
    let n = ephemeris#lst#find_task()
    if n == -1
      let n = line('.')
    endif
  else
    let n = line('.')
  endif
  let l = getline(n)

  let current_box = ''
  let box_i = 0
  let box_options = ephemeris#var#get_g_toggle_list()
  for o in box_options
    if stridx(l, o) > -1
      let current_box = o
      let box_i += 1
      break 
    endif
     let box_i += 1
  endfor
 
  let next_box = box_options[float2nr(fmod(box_i, len(box_options)))]
  echom next_box.'NB'
  call setline(n, substitute(l, escape(current_box, '['), next_box, ''))
endfunction
