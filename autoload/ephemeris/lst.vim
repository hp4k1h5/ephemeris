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
    " get today's diary entry filepath
    let l:today = ephemeris#fs#get_set_date(0)
  catch 
    execute 'silent! echom v:exception'
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
    let l:fn = expand(g:ephemeris_diary).'/'.l:prev.'.md'

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
" Filter out completed tasks and their associated blocks in the current buffer.
" If {archive} is true, filtered tasks will be moved to
" 'g:ephemeris_diary'/.cache/archive.md
" i.e., if you have a set of tasks like,
" >
"   - [ ] ephemeris docs
"     -[x] `.md`
"       - more list items but not tasks
"         and a nested block of text
"         with a few lines
"     -[ ] `txt`
"   - [x] export autocommands
" <
" and you run `:EphemerisFilterTasks` in the command-line mode, you will be left
" with
" >
"   - [ ] ephemeris docs
"     -[ ] `txt`
" <
function! ephemeris#lst#filter_tasks(archive)

  if a:archive
    try 
      let l:diary = ephemeris#var#get_g_diary()
      let l:archive = l:diary.'/.cache/archive.md'
    catch
      execute 'silent! echoerr '.v:exception
      return
    endtry
    call ephemeris#fs#create_fp(l:archive)
    execute 'badd '.l:archive
  endif

  " get/set ephemeris_todos, if no setting is provided, the default is set
  call ephemeris#var#get_set_g_todos()
  
  let l:i = 1
  let l:skip = 0
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
      call cursor(l:i, 1)
      " add to archive
      if a:archive
          execute 'silent! '.l:i.'w >> '.l:archive
      endif
      execute l:i.'d'
      " delete nested items underneath completed blocks
      " stop on any task item, g:ephemeris_todos, or 2 blank lines
      while l:i <= line('$') 
            \ && stridx(getline(l:i), '- [') == -1 
            \ && stridx(getline(l:i), g:ephemeris_todos) == -1
            \ && join(getline(l:i, l:i+1), '') !~ '^$' 
        " add to archive
        if a:archive
          execute 'silent! '.l:i.'w >> '.l:archive
        endif
        execute l:i.'d'
        " for each line of sub-block, add one to skip counter
        let l:skip += 1
      endwhile

    else
      " continue iterating over the buffer lines
      let l:i += 1
    endif
  endfor
endfunction

" TODO: move to BACKLOG somewhere
" multiline pcre for similar `\- \[.].|[\s]+(?=(\- \[.]|\Z))` 


""
" @public
" Toggle state of task on the line under the cursor between
" >
"   - [ ] incomplete, and
"   - [x] complete
" <
" whether or not there is a checkbox return 0
function! ephemeris#lst#toggle_task()

  let l:n = line('.')
  let l:l = getline('.')
  let l:c = '- [x]'
  let l:u = '- [ ]'
  if stridx(l:l, l:u) > -1
    call setline(l:n, substitute(l:l, escape(l:u, '['), l:c, ''))
  elseif stridx(l:l, l:c) > -1 
    call setline(l:n, substitute(l:l, escape(l:c, '['), l:u, ''))
  endif
endfunction
