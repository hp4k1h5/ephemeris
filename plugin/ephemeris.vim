""
" @section Introduction, intro
" @plugin(name) is a diary and calendar extension plugin for vim. It provides
" a collection of functions and commands that can be used to create, edit, and
" curate diary/log entries. 
"
" The diary is defined by the directories and files found recursively under
" the directory set in the global variable @setting(g:calendar_diary), which
" is the same variable as that used by mattn's calendar-vim
" <https:///github.com/mattn/calendar-vim>. @plugin(name) does not rely on any
" external programs and does not interfere with any external program, such as
" cal, etc. Nevertheless, the diary functionality provided by calendar-vim is
" not entirely reduplicated by this plugin. This plugin works best when the
" directory structure of @setting(g:calendar_diary) is as follows:
" >
"   ├── 2019
"   │   └── 09
"   │       ├── 16.md
"   │   └── 12
"   │       └── 20.md
"   ├── 2020
"   │   └── 05
"   │       ├── 01.md
"   │       ├── 04.md
" <
" This tree structure is provided by default by @plugin(name) as well as the
" diary functions provided by calendar-vim. @plugin(name) will only provide
" limited functionality if the directory structure does not include a
" date-aligned directory structure as outlined above. This directory structure
" is provided by default by @plugin(name) functions as well as by
" calendar-vim's diary functions.
"
" @subsection help
"           see 'README.md' and 'doc/ephemeris.txt'
"
" @subsection thanks
"           mattn <https://github.com/mattn/calendar-vim>

if &compatible
  finish
endif

" commands
""
" Create '.md' diary index of all '.md' files found under the
" @setting(g:calendar_diary) directory, and open in a vertical split.
command! -nargs=* EphemerisCreateIndex call ephemeris#ind#create_index(<f-args>)
command! -nargs=* EphemerisGotoIndex call ephemeris#ind#goto_index(<f-args>)
command! -nargs=* EphemerisCopyTodos call ephemeris#lst#copy_todos(<f-args>)
command! -nargs=* EphemerisFilterTasks call ephemeris#lst#filter_tasks(<f-args>)
command! -nargs=* EphemerisToggleTask call ephemeris#lst#toggle_task(<f-args>)
