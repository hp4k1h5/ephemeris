""
"=============================================================================
" What Is This: @plugin(name)
" File: ephemeris.vim
" Author: @plugin(author)
" Last Change: 2020/05/13
" Version: 0.2
" Help: see README.md and doc/ephemeris.txt
" Thanks:
"     vim-calendar [ mattn/vim-calendar ](https://github.com/mattn/calendar-vim)
" ChangeLog:
"     0.2  : fixes (2020/05/13)
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
command! -nargs=* EphemerisCopyTodos call ephemeris#lst#copy_todos(<f-args>)
command! -nargs=* EphemerisFilterTasks call ephemeris#lst#filter_tasks(<f-args>)
command! -nargs=* EphemerisToggleTask call ephemeris#lst#toggle_task(<f-args>)
