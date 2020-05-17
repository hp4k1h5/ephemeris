" vim:tabstop=2:shiftwidth=2:expandtab:textwidth=80
" Filename: autoload/fun/var.vim
" Description: everything concerning global vars 
" Home: https://github.com/HP4k1h5/ephemeris/
" Purpose: handle global variables


""
" @public
" helper function to get expanded dirpath of g:calendar_diary Since there is no
" default, if there is no variable set at g:calendar_diary, this function will
" throw an error that calling functions should handle
function! ephemeris#fun#var#get_calendar_diary()
  " get calendar_diary directory 
  if !exists('g:calendar_diary')
    throw 'g:calendar_diary NOT found; please set g:calendar_diary in you vimrc'
          \ .'\n `:let g:calendar_diary="~/diary"`'
  endif
  return expand(g:calendar_diary)
endfunction


""
" @public
" helper function to get/set state of g:ephemeris_todos
function! ephemeris#fun#var#get_set_g_todos()
  " get/set todo regex
  if !exists('g:ephemeris_todos')
    ""
    " marker to indicate the beginning of the list of task items to be copied
    " over to current day's diary entry. see @function(ephemeris#lst#copy_todos)
    "
    " default: TODOs
    let g:ephemeris_todos = 'TODOs'
  endif
  return g:ephemeris_todos
endfunction
