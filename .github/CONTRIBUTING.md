# contributing
[toc]

thanks for using ephemeris. all contributions are welcome. whether or not you
are considering [contributing code](#code-contributions), please file an
issue. templates are not required.

please try to be respectful of other members of the community and yourself.

## Templates

### features

please file a [feature
request](https://github.com/HP4k1h5/ephemeris/issues/new?assignees=&labels=&template=feature_request.md&title=)

### bugs

im sorry. please file a [bug report](https://github.com/HP4k1h5/ephemeris/issues/new?assignees=HP4k1h5&labels=bug&template=bug_report.md&title=basic)

## code contributions

When contributing code, please:
1) file an issue and describe the bugfix or feature
2) fork this repository
3) checkout the latest version branch, which will be in the `v.X.X` format,
and should be the only version branch available. Don't hesitate to ask if it
is unclear.
4) make changes; currently using
[coc-vimlsp](https://github.com/iamcco/coc-vimlsp), for vim/vader code styles
5) add tests; currently using [vader](https://github.com/junegunn/vader.vim),
but any and all tests are welcome. See [vader tests](#vader-tests) for more
information on running the test suite.
6) add comments to your functions, and if possible, in the
[vimdoc](https://github.com/google/vimdoc) style
7) submit a merge request from your forked branch into the
latest HP4k1h5/ephemeris `v.X.X` branch.


## Vader tests
> many thanks to [junegunn](https://github.com/junegunn)
 for the [Vader](https://github.com/junegunn/vader.vim) testing plugin

To run the full set of Vader tests or a single test, I recommend using the
[cleanish_vader](../test/cleanish_vader.bash) set of scripts.
run e.g.
```bash
cd ephemeris
source test/cleanish_vader.bash
clean_vader ./ test/* # to run all tests
# or e.g.
clean_vader ./ test/fs* # to run test globs
# or e.g.
clean_vader ./ test/filter_tasks.vader # to run a single test
```

or a script like the following, mostly borrowed from the Vader readme [testing
section](https://github.com/junegunn/vader.vim#setting-up-isolated-testing-environment):
#### testing locally
```bash
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
```

### ci/cd test script
```bash
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
```
