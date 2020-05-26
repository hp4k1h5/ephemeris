" vim:tabstop=2:shiftwidth=2:expandtab:textwidth=80
" Filename: autoload/fun/var.vim
" Description: filesystem and var helper functions
" Home: https://github.com/HP4k1h5/ephemeris/


""
" @public
" Creates a dirpath and/or file at the expanded {filepath}. If the filepath
" ends in a '/', only the dirpath is created. Can be used idempotently.
function! ephemeris#fs#create_fp(filepath)

  " check if dir or file terminator
  if a:filepath[-1:] !=# '/'
    let l:split_path = split(a:filepath, '/')
    let l:filename = l:split_path[-1:][0] 
    let l:dirpath = join(l:split_path[:-2], '/')
  else
    let l:dirpath = a:filepath
  endif

  call mkdir(expand(l:dirpath), 'p')

  if exists('l:filename')
    execute 'silent! ! touch '.expand(a:filepath)
  endif
endfunction


""
" @public
" Creates a diary entry buffer for the current day, and, if necessary, the
" required `g:ephemeris_diary/YYYY/MM/...` directory path. See
" @setting(g:ephemeris_diary)
"
" Returns a string containing the current day's diary entry filepath
" TODO: elseif focus l:today
function! ephemeris#fs#get_set_today()
  try
    let l:diary_dir = ephemeris#fs#get_g_diary()
  catch
    throw v:exception
  endtry

  let l:month_path = l:diary_dir.'/'.strftime('%Y/%m')
  let l:today = l:month_path.strftime('/%d').'.md'
  if !filereadable(l:today)
    execute 'silent! echom "creating today s diary entry"'
    call mkdir(l:month_path, 'p')
    execute 'badd '.l:today
  endif

  return l:today
endfunction


""
" @public
" helper function to get/set state of @setting(g:ephemeris_diary) if
" g:ephemeris_diary is not found an error is thrown errors should be handled by
" calling functions
"
" Returns a string containing the expanded g:ephemeris_diary directory path
function! ephemeris#fs#get_g_diary()

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
  " Example: 
  " :let g:ephemeris_diary = '~/diary'

  return expand(g:ephemeris_diary)
endfunction


""
" @public
" helper function to get/set state of g:ephemeris_todos
function! ephemeris#fs#get_set_g_todos()
  " get/set todo regex
  if !exists('g:ephemeris_todos')
    ""
    " marker to indicate the beginning of the list of task items to be copied
    " over to current day's diary entry. see @function(ephemeris#lst#copy_todos)
    "
    " default: TODOs
    let g:ephemeris_todos = 'TODOs'
  endif
  return g:ephemeris_todos
endfunction
