"=============================================================================
" What Is This: ephemeris 
" File: ephemeris.vim
" Author: bob <robertwalks@gmail.com>
" Last Change: Wed May  6 16:38:14 2020
" Version: 2.9
" Thanks:
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
command! -nargs=* Ephemeris call ephemeris#lst#ech0(<f-args>)
" if !get(g:, 'calendar_no_mappings', 0)
"   if !hasmapto('<Plug>CalendarV')
"     nmap <unique> <Leader>cal <Plug>CalendarV
"   endif
"   if !hasmapto('<Plug>CalendarH')
"     nmap <unique> <Leader>caL <Plug>CalendarH
"   endif
" endif
" nnoremap <silent> <Plug>CalendarV :cal calendar#show(0)<CR>

