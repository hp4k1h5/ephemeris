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
