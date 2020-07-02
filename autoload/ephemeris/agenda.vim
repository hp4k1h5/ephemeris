
function! ephemeris#agenda#gather_date(...)

  if a:0 != 1
    let date = strftime('%Y/%m/%d')
  else 
    let date = a:1
  endif

  let str = "grep -E '\(".date.")(:{2}.+)?' "
        \ .ephemeris#var#get_g_diary().'/**/*.md'
  let events = system(str)
  echom events
endfunction
