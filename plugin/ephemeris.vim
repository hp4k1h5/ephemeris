"=============================================================================
" What Is This: ephemeris 
" File: ephemeris.vim
" Author: bob <robertwalks@gmail.com>
" Last Change: Wed May 13 11:41:03 2020
" Version: 0.2
" Help: see README.md and doc/ephemeris.txt
" Thanks:
"     vim-calendar [ mattn/vim-calendar ](https://github.com/mattn/calendar-vim)
" ChangeLog:
"     0.2  : fix  (2020/05/13)
"     0.1  : init (2020/05/08)
"     0.0  : init (2020/05/06)

if &compatible
  finish
endif

"*****************************************************************
"* ephemeris commands
"*****************************************************************

""
" @public
" Creates and displays a new markdown index of all diary entries in
" `g:calendar_diary` at `g:calendar_diary/index.md`. Can be called from
" anywhere
command! -nargs=* EphemerisCreateIndex call
ephemeris#ind#create_index(<f-args>) command! -nargs=* EphemerisGotoIndex call
ephemeris#ind#goto_index(<f-args>) command! -nargs=* EphemerisCopyTodos call
ephemeris#lst#copy_todos(<f-args>) command! -nargs=* EphemerisFilterTasks call
ephemeris#lst#filter_tasks(<f-args>) command! -nargs=* EphemerisToggleTask
call ephemeris#lst#toggle_task(<f-args>)
