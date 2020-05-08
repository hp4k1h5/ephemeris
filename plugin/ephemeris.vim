"=============================================================================
" What Is This: ephemeris 
" File: ephemeris.vim
" Author: bob <robertwalks@gmail.com>
" Last Change: Fri May  8 16:40:34 2020
" Version: 0.1
" Help: see README.md and doc/ephemeris.txt
" Thanks:
"     vim-calendar [ mattn/vim-calendar ](https://github.com/mattn/calendar-vim)
" ChangeLog:
"     0.1  : init (2020/05/08)
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
