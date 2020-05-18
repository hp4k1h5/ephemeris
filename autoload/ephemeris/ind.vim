" vim:tabstop=2:shiftwidth=2:expandtab:textwidth=80
" Filename: autoload/ind.vim
" Description: everything concerning the diary index
" Home: https://github.com/HP4k1h5/ephemeris/
" Purpose: diary index utility functions 

""
" @setting g:calendar_diary
" diary directory. 
"   ex .vimrc setting: `let g:calendar_diary = ~/diary`. No default.
"   @plugin(name) reuses this variable and the contents of the directory without
"   interfering with mattn/calendar-vim's functionalities.

""
" @public
" Find or create, and go to diary index file. Index located at
" @setting(g:calendar_diary)/index.md
function! ephemeris#ind#goto_index()
  " find/create and goto index
  let l:ifn = expand(g:calendar_diary).'/index.md'
  if expand('%') !=# l:ifn
    let l:wn = bufwinnr(l:ifn)
    if bufexists(l:ifn) && l:wn > -1
        execute l:wn.'wincmd w'
      else
        execute 'vsplit '.l:ifn
    endif
  endif

  " be in calendar_diary dir
    execute 'cd '.expand(g:calendar_diary)
endfunction

""
" @public
" Create an index of diary entries found recursively under the
" @setting(g:calendar_diary) directory at @setting(g:calendar_diary)/index.md,
" and open the index in a vertical split. Entries are formatted as markdown
" links.
function! ephemeris#ind#create_index()
  " be in diary/index.md
  call ephemeris#ind#goto_index()
  " clear buffer 
  execute 'normal! ggdG'
  " consider `execute 'silent! bufdo! bdelete!'`
  " see
  " [vroom](https://github.com/google/vroom/blob/c8d593f10f77ed565df66a91b69cd79bc3e6bddd/examples/basics.vroom#L29)

  " add headers 
  call append(0, '# Diary Entries')
  call append('$', '**found in '.expand(g:calendar_diary).'/**')
  call append('$', '[toc]')
  " add entries
  " TODO: add custom sort
  for item in glob('**/*', 0, 1)
    if item ==# 'index.md'
      continue
    endif
    let l:l = split(item, '/')
    if len(l:l) == 1
      let item = '### '.item
    elseif len(l:l) == 2
      let item = '##### '.item
    else
      let item =  '- ['.item.']('.item.')'
    endif
      call append('$', item)
  endfor

  execute 'w'
endfunction

" simple remap to dump text
" noremap <leader>dci    ggdGi## Diary Entries<CR><C-r>=glob('**/*')<CR><ESC>:w<CR>
