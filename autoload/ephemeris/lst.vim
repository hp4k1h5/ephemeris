" vim:tabstop=2:shiftwidth=2:expandtab:textwidth=99
" ephemeris autoload plugin file
" Description: everything concerning lists and checkboxes
" list manipulators borrowed largely from https://github.com/vimwiki/vimwiki/blob/autoload/vimwiki/lst.vim
" Home: https://github.com/HP4k1h5/ephemeris/


" ---------------------------------------------------------
" list, task, todo utility functions
" ---------------------------------------------------------

function! ephemeris#lst#copy_todos()
  " create today's path and .md entry file if necessary
  let l:today = expand(g:calendar_diary)."/".strftime("%Y/%m/%d")
  if !filereadable(l:today.".md")
    echom "creating today's diary entry"
    call mkdir(g:calendar_diary."".strftime("%Y/%m"), "p")
    execute "badd ".l:today.".md"
  endif

  " get/set todo regex
  if !exists('g:ephemeris_todos')
    let g:ephemeris_todos = "### TODOs"
  endif

  " look back through a year's worth of potential diary entries
  let l:dp = 1
  while l:dp < 365 
    let l:prev = substitute(system("date -v -".l:dp."d '+%Y/%m/%d'"), "\n", "", "g")
    let l:fn = expand(g:calendar_diary)."/".l:prev.".md"
    if filereadable(l:fn)
      " if file contains a todo, extract list and dump in today's entry
      " TODO: currently TODO lists need to end the file, a smarter function
      "     : will only grab `-` etc lines up to a natural end, 
      "     : e.g. 3 consecutive newlines
      let l:todostart = system("grep -n '".g:ephemeris_todos."' ".l:fn)
      if len(l:todostart)
        let l:todostart = split(l:todostart, ":")[0]
        " add buff, dump todo list, open latest entry, exit loop
        execute "badd ".l:fn
        execute "silent! ".bufnr(l:fn)." bufdo! ".l:todostart.",$ w! >> ".l:today.".md"
        execute "silent! b ".l:today.".md"
        break
      endif
    endif
    let l:dp+=1
  endwhile
endfunction

function! ephemeris#lst#filter_tasks()
  let l:i = 1
  let l:skip = 0

  for line in getbufline('%', 1, '$')
    " skip deleted nested items
    if l:skip > 0
      let l:skip -= 1
      continue
    endif

    " delete completed items
    if stridx(line, '- [x]') > -1
      call cursor(l:i, 1)
      execute l:i.'d'
      " delete nested items underneath completed blocks
      while l:i <= line('$') && stridx(getline(l:i), '- [') == -1
        execute l:i.'d'
        let l:skip += 1
      endwhile
    else
      let l:i += 1
    endif
  endfor
endfunction
" multiline pcre for similar `\- \[.].|[\s]+(?=(\- \[.]|\Z))` 

" task helpers
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
