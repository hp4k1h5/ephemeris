# vader cleanish vim +vader test script 
# {$1} first arg (required) is the dirpath of the plugin you are testing. if
# you are inside the plugin dir, you may use `./` to load the plugin. vim will
# open with a relatively clean `.vimrc` 
# [$2] second arg (optional) is the file(glob) of the Vader test(s) you wish to
# run. If no second arg is provided, vim will open with a relatively clean
# `.vimrc`
function clean_vader {
  # open vim with no commands
  if [[ -z $2 ]]; then
    vader_cmd=''
  else
  # open vim with a Vader script and dir/file path
    vader_cmd='+Vader '$2
  fi

  vim -Nu <(cat <<EOF
    filetype off  
    set rtp+=~/.vim/plugged/vader.vim
    set rtp+=$1
    filetype plugin indent on
    syntax enable
EOF
  ) $vader_cmd
}

# vader cleanish vim +vader ci/cd test script
# {$1} first arg (required) is the dirpath of the plugin you are testing. if
# you are inside the plugin dir, you may use `./` to load the plugin. vim will
# open with a relatively clean `.vimrc` 
# Returns a 0 or 1 status code depending on test success
function clean_vader_ci {
  vim -Nu <(cat <<EOF
    filetype off  
    set rtp+=~/.vim/plugged/vader.vim
    set rtp+=$1
    filetype plugin indent on
    syntax enable
EOF
) '+Vader! '$1'/test/*'
}
