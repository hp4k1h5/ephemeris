" helper function to get/set state of @setting(g:ephemeris_diary). If
" g:ephemeris_diary is not found an error is thrown. errors should be handled
" by calling functions. Returns a string containing the expanded
" g:ephemeris_diary directory path
function! ephemeris#var#get_g_diary()
  " if g:ephemeris_diary does not exist, throw an error message indicating that
  " the global variable must be set
  if !exists('g:ephemeris_diary')
    throw 'required global variable `g:ephemeris_diary` has not been set'
          \ .'... set with `:let g:ephemeris_diary="~/diary"`'
  endif

  ""
  " @setting g:ephemeris_diary
  " Directory path for diary. All functions that rely on this variable/directory
  " are dependent on it having the following directory structure:
  " >
  "     ├── 2019
  "     │   └── 09
  "     │       ├── 16.md
  "     │   └── 12
  "     │       └── 20.md
  "     ├── 2020
  "     │   └── 05
  "     │       ├── 01.md
  "     │       ├── 04.md
  " <
  " files that do not conform to the `g:ephemeris_diary/YYYY/MM/DD.md` format,
  " will not be available to date reliant functions such as
  " @function(ephemeris#lst#copy_todos)
  "
  " Default: { No default! } must be set by user
  "
  " Example: `:let g:ephemeris_diary = '~/diary'`

  return expand(g:ephemeris_diary)
endfunction


" Helper function to get/set state of 'g:ephemeris_todos'. Returns a string of
" the marker
function! ephemeris#var#get_set_g_todos()
  " get/set todo regex
  if !exists('g:ephemeris_todos')
    ""
    " marker to indicate the beginning and end of the list of task items to be
    " copied over to current day's diary entry. see
    " @function(EphemerisCopyTodos). Also serves as a delimiter for
    " @function(EphemerisFilterTasks)
    "
    " Default: `TODOs`
    "
    " Example: `:let g:ephemeris_todos = '===TASK LIST==='`
    let g:ephemeris_todos = 'TODOs'
  endif

  return g:ephemeris_todos
endfunction

function! ephemeris#var#get_g_toggle_list()

  "" 
  " @setting g:ephemeris_toggle_list
  " Accepts a list of strings that g:ephemeris_toggle_block will iterate over.
  " Mind that not all of these will be properly interpreted by standard
  " markdown interpreters, which may only accept, if they accept them, the
  " default values.
  " Example: `:let g:ephemeris_toggle_list = '🌑🌘🌗🌖🌕'`  
  "
  " Example: `:let g:ephemeris_toggle_list = '.oO'`
  "
  " Default: `' x`, when split produces: `- [ ]` and `- [x]`
  let g:ephemeris_toggle_list = get(g:, 'ephemeris_toggle_list', 
        \ ' x')
  return split(g:ephemeris_toggle_list, '\zs')
endfunction
