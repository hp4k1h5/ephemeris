""
" @section Introduction, intro
" @plugin(name) is a diary and calendar extension plugin for vim.
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
