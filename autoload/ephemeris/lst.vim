" vim:tabstop=2:shiftwidth=2:expandtab:textwidth=99
" ephemeris autoload plugin file
" Description: everything concerning lists and checkboxes
" list manipulators borrowed largely from https://github.com/vimwiki/vimwiki/blob/autoload/vimwiki/lst.vim
" Home: https://github.com/HP4k1h5/ephemeris/


" ---------------------------------------------------------
" incrementation functions for the various kinds of numbers
" ---------------------------------------------------------

" TODO: vvvvvvvv fix this vvvvvvvv
" grep for todos in a project and add to TODO list
" nnoremap <leader>cg     :silent execute "grep! -R " . shellescape(expand("<cWORD>")) . " ~/code/diary/"<cr>:copen<cr>

function! ephemeris#lst#copy_todos()
  " create today's path and .md entry file if necessary
  let l:today = expand(g:calendar_diary)."/".strftime("%Y/%m/%d")
  if !filereadable(l:today.".md")
    echom "creating today's diary entry"
    call mkdir(g:calendar_diary."".strftime("%Y/%m"), "p")
    execute "badd ".l:today.".md"
  endif

  let l:dp = 1
  " look back through a year's worth of potential diary entries
  while l:dp < 365 
    let l:prev = substitute(system("date -v -".l:dp."d '+%Y/%m/%d'"), "\n", "", "g")
    let l:fn = expand(g:calendar_diary)."/".l:prev.".md"
    if filereadable(l:fn)
      " if file contains a todo, extract list and dump in today's entry
      " TODO: currently TODO lists need to end the file, a smarter function
      "     : will only grab `-` etc lines up to a natural end, 
      "     : e.g. 3 consecutive newlines
      let l:todostart = system("grep -n '### TODO:' ".l:fn)
      if l:todostart != -1
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

" - [ ] so...
" - [x] so...
function! ephemeris#lst#filter_tasks()
  let l:lines = getbufline('%', 1, '$') 
  let l:i = 1
  for line in l:lines
    if stridx(line, '- [x]') == 2
      call cursor(l:i, 1)
      echom l:i
      " redir => l:out
      "   execute 'normal! dai'
      " redir END
      return 0
    endif
    let l:i += 1
  endfor
endfunction

" execute l:i.'delete'
" let l:all_tasks = system(
" \ 'pcregrep -M --color  "\- \[.].|[\s]+(?=(\- \[.]|\Z))" '
" \ .expand('%')
" \ )
" let l:inc_tasks = split(l:inc_tasks, '^@')
" for task in l:inc_tasks
"   if stridx()

" lvimgrep! /- \[ \]/ %:p
" lopen
" let l:todostart = system("grep -n '- [.:?]' ".g:calendar_diary)

function! s:increment_1(value)
  return eval(a:value) + 1
endfunction

function! s:increment_A(value)
  let list_of_chars = split(a:value, '.\zs')
  let done = 0
  for idx in reverse(range(len(list_of_chars)))
    let cur_num = char2nr(list_of_chars[idx])
    if cur_num < 90
      let list_of_chars[idx] = nr2char(cur_num + 1)
      let done = 1
      break
    else
      let list_of_chars[idx] = 'A'
    endif
  endfor
  if !done
    call insert(list_of_chars, 'A')
  endif
  return join(list_of_chars, '')
endfunction
