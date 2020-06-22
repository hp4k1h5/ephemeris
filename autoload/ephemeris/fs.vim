" vim:tabstop=2:shiftwidth=2:expandtab:textwidth=80
" Filename: autoload/fun/var.vim
" Description: filesystem and var helper functions
" Home: https://github.com/HP4k1h5/ephemeris/


""
" @public
" Creates a dirpath and/or file at the expanded {filepath}. If the filepath ends
" in a '/', only the dirpath is created. Will not overwrite existing files or
" directories.
function! ephemeris#fs#create_fp(filepath)

  " check if dir or file terminator
  if a:filepath[-1:] !=# '/'
    " path, pattern, keepempty true for leading /
    let l:split_path = split(a:filepath, '/', 1)
    let l:filename = expand(l:split_path[-1:][0])
    let l:dirpath = join(l:split_path[:-2], '/')
  else
    let l:dirpath = expand(a:filepath)
  endif

  call mkdir(l:dirpath, 'p')

  if exists('l:filename')
    execute 'silent! ! touch '.a:filepath
  endif
endfunction


""
" @public
" Creates a diary entry buffer for {date} and, if necessary, the intermediate
" `g:ephemeris_diary/YYYY/MM/...` directory path. Date must be in YYYY/MM/DD
" format in order to work with other ephemeris functions. If {date} is 0, it
" will return today's date. See @setting(g:ephemeris_diary)
"
" Returns a string containing the date's diary entry filepath
function! ephemeris#fs#get_set_date(date)

  if a:date == 0
    let l:date = strftime('%Y/%m/%d').'.md'
  else
    let l:date = a:date.'.md'
  endif

  try
    let l:diary_dir = ephemeris#var#get_g_diary()
  catch
    throw v:exception
  endtry

  " create file and add to buffer list
  let l:date_path = l:diary_dir.'/'.l:date
  call ephemeris#fs#create_fp(l:date_path)
  execute 'badd '.l:date_path

  return l:date_path
endfunction
