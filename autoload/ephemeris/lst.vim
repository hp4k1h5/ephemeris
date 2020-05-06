" vim:tabstop=2:shiftwidth=2:expandtab:textwidth=99
" ephemeris autoload plugin file
" Description: everything concerning lists and checkboxes
" borrowed largely from https://github.com/vimwiki/vimwiki/blob/autoload/vimwiki/lst.vim
" Home: https://github.com/HP4k1h5/ephemeris/


" ---------------------------------------------------------
" incrementation functions for the various kinds of numbers
" ---------------------------------------------------------

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

function ephemeris#lst#ech0()
  echo "ech0"
  echom "ech0"
endfunction
