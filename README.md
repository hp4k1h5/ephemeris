## ephemeris

##### a diary plugin/Calendar extension for vim

this plugin extends some of the functionality provided by the [ mattn/vim-calendar ](https://github.com/mattn/calendar-vim) plugin's diary function. the calendar plugin itself is not required but this plugin reuses one of it's global variables `g:calendar_diary` without interfering with `calendar-vim`.

#### functionalities

- create **index** of diary entries
  - index access/refresh
- smart **checkbox** list item management
  - filter/sort/aggregate/calculate
  - copy last set of TODO's / `- [ ]` to current day's diary entry

### required

set the root directory for your diary entries `g:calendar_diary` in your `.vimrc` i.e.

```vimscript
let g:calendar_diary = '~/diary'
```

## installation

should work with your preferred vim plugin manager.  
e.g. add

```vimscript
Plug 'HP4k1h5/ephemeris'
```

to your `.vimrc` and run

```
:source $MYVIMRC | PlugInstall`
```

in command-line mode (see `:help cmdline`)

###### optional but helpful

- [ vim-calendar / https://github.com/mattn/calendar-vim ](https://github.com/mattn/calendar-vim)
- [ markdown-preview ](https://github.com/iamcco/markdown-preview.nvim) or your preferred markdown preview / syntax highlighter tool

#### functions

```vimscript
:EphemerisCreateIndex()
:EphemerisGotoIndex()
:EphemerisCopyTodos()
```

#### example mappings

```vimscript
nnoremap <leader> eci :EphemerisCreateIndex()<CR>
nnoremap <leader> egi :EphemerisGotoIndex()<CR>
nnoremap <leader> ect :EphemerisCopyTodos()<CR>
```
