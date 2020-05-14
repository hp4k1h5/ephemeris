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

" COMMANDS
""
" Create '.md' diary index of all '.md' files found under the
" @setting(g:calendar_diary) directory, and go to vertical split.  Calls
" @function(ephemeris#ind#create_index)
command! -nargs=* EphemerisCreateIndex call ephemeris#ind#create_index(<f-args>)

""
" Open diary index in a vertical split or focus diary index buffer. Index is
" found at @setting(g:calendar_diary)/index.md
command! -nargs=* EphemerisGotoIndex call ephemeris#ind#goto_index(<f-args>)

""
" Look backwards through previous entries for last 'TODOs' marker set in
" @setting(g:ephemeris_todos), as defined by the tasks found below the string
" default is 'TODOs'. Calls @function(ephemeris#lst#copy_todos)
command! -nargs=* EphemerisCopyTodos call ephemeris#lst#copy_todos(<f-args>)

""
" Delete completed tasks, e.g. `- [x] task A`, and all associated subblocks
" until the next incomplete task, e.g. `- [ ] task B` or EOF. See example in
" @function(ephemeris#lst#filter_tasks).
command! -nargs=* EphemerisFilterTasks call ephemeris#lst#filter_tasks(<f-args>)

""
" Toggles the state of a task between 
" >
"   - [ ] incomplete
"     and
"   - [x] complete 
" <
" will not affect the state of any other tasks. Calls
" @function(ephemeris#lst#toggle_task)
command! -nargs=* EphemerisToggleTask call ephemeris#lst#toggle_task(<f-args>)
