" vim:tabstop=2:shiftwidth=2:expandtab:textwidth=80
" Filename: plugin/ephemeris.vim
" Description: docs and commands
" Home: https://github.com/HP4k1h5/ephemeris/

""
" @section Introduction, intro
" @plugin(name) is a diary and calendar extension plugin for vim. It provides
" a collection of functions and commands that can be used to create, edit, and
" curate diary/log entries. 
"
" The diary is defined by the directories and files found recursively under the
" directory set in the global variable @setting(g:ephemeris_diary).
" @plugin(name) does not rely on any external programs and does not interfere
"with any external program, such as cal, etc. This plugin works best when the
"directory structure of @setting(g:ephemeris_diary) is YYYY/MM/DD.md, as
"follows:
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
" This tree structure is provided by default by @plugin(name) functions. This
" plugin will only provide limited functionality if the directory structure does
" not include a date-aligned directory structure as outlined above.
"
" @subsection help
"           see 'README.md' and 'doc/ephemeris.txt'
"
" @subsection thanks
"           mattn <https://github.com/mattn/calendar-vim>
"             - for a great plugin and the inspiration to make some helper functions
"
"           junegunn <https://github.com/junegunn/vader.vim
"             - for the testing suite
"

" COMMANDS
""
" Create markdown diary index of all '.md' files found under the
" @setting(g:ephemeris_diary) directory, and go to vertical split.  Calls
" @function(ephemeris#ind#create_index)
command! -nargs=* EphemerisCreateIndex call ephemeris#ind#create_index(<f-args>)

""
" Open diary index in a vertical split or focus diary index buffer. Index is
" found at @setting(g:ephemeris_diary)/index.md. Calls
" @function(ephemeris#ind#goto_index)
command! -nargs=* EphemerisGotoIndex call ephemeris#ind#goto_index(<f-args>)

""
" Look backwards through previous entries for last @setting(g:ephemeris_todos)
" marker, as defined by the tasks found below the string.  Calls
" @function(ephemeris#lst#copy_todos) 
command! -nargs=* EphemerisCopyTodos call ephemeris#lst#copy_todos(<f-args>)

""
" Delete completed tasks, e.g. list items containing `- [x]`, and all associated
" subblocks until the next incomplete task, e.g. list items containing `- [ ]`,
" a @setting(g:ephemeris_todos) marker, 2 newlines, or EOF. See example in
" @function(ephemeris#lst#filter_tasks).
command! -nargs=* EphemerisFilterTasks call ephemeris#lst#filter_tasks(<f-args>)

""
" Toggles the state of a task between 
" >
"   - [ ] incomplete
"     and
"   - [x] complete 
" <
" when the cursor is on a line containing a task. will not affect the state of
" any other tasks. Calls @function(ephemeris#lst#toggle_task)
command! -nargs=* EphemerisToggleTask call ephemeris#lst#toggle_task(<f-args>)
