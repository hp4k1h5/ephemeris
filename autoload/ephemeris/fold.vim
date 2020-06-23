""
" expression copied from Jezen Thomas' [blog](https://jezenthomas.com/folding-paragraphs-in-vim/)
function! ephemeris#fold#list()
  set fde=getline(v:lnum)=~'^\\s*$'&&getline(v:lnum+1)=~'\\S'?'<1':1
  set fdm=expr
endfunction
