""
" @section Introduction, intro
" @plugin(name) is a diary and calendar extension plugin for vim. It provides
" a collection of functions and commands that can be used to create, edit and,
" curate diary/log entries. 
"
" the directories and files found recursively under the directory set in the
" global variable `g:calendar_diary` , which is the same variable as that used
" by [calendar-vim](https:///github.com/mattn/calendar-vim). It does not rely
" on any external programs and does not interfere with any external program,
" such as cal, etc.  Nevertheless, the diary functionality provided by
" calendar-vim is not reduplicated by this plugin. this plugin works best when
" the directory structure of `g:calendar_diary` is as follows:
" >
"   ├── 2019
"   │   └── 11
"   │       ├── 09.md
"   │       └── 20.md
"   ├── 2020
"   │   └── 05
"   │       ├── 01.md
"   │       ├── 04.md
" <
" This tree structure is provided by default by the calendar-vim diary functions.
" @plugin(name( will only provide limited functionality if the directory structure
" does not include a date-aligned directory structure as outlined above.
" **Therefore it is recommended to use this plugin together with calendar-vim.**
"
" @subsection help
"           see 'README.md' and 'doc/ephemeris.txt'
" @subsection thanks
"           mattn <https://github.com/mattn/calendar-vim>

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
