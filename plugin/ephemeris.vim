"=============================================================================
" What Is This: ephemeris 
" File: ephemeris.vim
" Author: bob <robertwalks@gmail.com>
" Last Change: Wed May  6 16:38:14 2020
" Version: 0.0
" Thanks:
" TODO: replace with links
"     vim-calendar 
"     vimwiki
" ChangeLog:
"     0.0  : init (2020/05/06)

if &compatible
  finish
endif

"*****************************************************************
"* ephemeris commands
"*****************************************************************

command! -nargs=* EphemerisCreateIndex call ephemeris#ind#create_index(<f-args>)
command! -nargs=* EphemerisGotoIndex call ephemeris#ind#goto_index(<f-args>)
command! -nargs=* EphemerisCopyTODOs call ephemeris#lst#copy_todos(<f-args>)
command! -nargs=* EphemerisFilterTasks call ephemeris#lst#filter_tasks(<f-args>)

" command! -nargs=* Ephemeris call ephemeris#lst#ech0(<f-args>)
" if !get(g:, 'calendar_no_mappings', 0)
"   if !hasmapto('<Plug>CalendarV')
"     nmap <unique> <Leader>cal <Plug>CalendarV
"   endif
"   if !hasmapto('<Plug>CalendarH')
"     nmap <unique> <Leader>caL <Plug>CalendarH
"   endif
" endif
" nnoremap <silent> <Plug>CalendarV :cal calendar#show(0)<CR>
