" grep for all references to today's date in the (YYYY/MM/DD) format. Returns
" a unique dictionary of agenda items
function! ephemeris#agenda#gather_date(date)

  let str = "grep -E '\(".a:date.")(:{2}.+)?' "
        \ .ephemeris#var#get_g_diary().'/**/*.md'
  let events = system(str)

  if ! len(events)
    return
  endif

  let events = split(events, '\n')
  let matches = {}
  for event in events
    let m = matchlist(event, '^\(.\{-}:\)\(.\+\)')
    if ! len(m) | continue | endif
    let matches[m[2]] = m
  endfor

  return matches
endfunction


" Get and print day's agenda for the first parameter, {a:1}, a date string. If
" no parameter is passed the current date is used. Each agenda item will be
" printed  in the current buffer. If g:ephemeris_todos is present on the page,
" the agenda will be printed there, otherwise at the top of the buffer.
function! ephemeris#agenda#print(...)
 
  if a:0 != 1
    let date = strftime('%Y/%m/%d')
  else 
    let date = a:1
  endif

  " get agenda items
  let agenda = ephemeris#agenda#gather_date(date)

  " get marker
  let todos = ephemeris#var#get_set_g_todos()
  let start_line = system('grep -n '.todos.' '.expand('%'))
  if len(start_line)
    let line = str2nr(split(start_line, ':')[0])
  else
    let line = 0
  endif

  " print
  call append(line, ['', '## '.date.' AGENDA'])
  let line += 2
  for [k, v] in items(agenda)
    call append(line, v[1].' :: '.v[2])

    " next item
    let line += 1
  endfor
  call append(line, '')

endfunction
