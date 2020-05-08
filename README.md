# ephemeris

> a diary plugin/Calendar extension for vim

this plugin extends some of the functionality provided by the
[mattn/vim-calendar](https://github.com/mattn/calendar-vim) plugin's diary
function. the calendar plugin itself is not required but this plugin reuses one
of it's global variables `g:calendar_diary` without interfering with
`calendar-vim`.  

**see [doc/ephemeris.txt](doc/ephemeris.txt) for additional help**

## functionalities

- create **index** of diary entries
  - index access/refresh
- smart **checkbox** list item management
  - filter/sort/aggregate/calculate
  - copy last set of TODO's / `- [ ]` to current day's diary entry

### required

set the root directory for your diary entries `g:calendar_diary` in your
`.vimrc` i.e.

```vim
let g:calendar_diary = '~/diary'
```

### optional

```vim
let g:ephemeris_todos = '=== TASK LIST ==='
```

## installation

should work with your preferred vim plugin manager.  
e.g. add

```vim
Plug 'HP4k1h5/ephemeris'
Plug 'mattn/calendar-vim' " recommended
```

to your `.vimrc` and run

```vim
:source $MYVIMRC | PlugInstall
```

in command-line mode (see `:help cmdline`)

### optional but helpful

- [vim-calendar /https://github.com/mattn/calendar-vim](https://github.com/mattn/calendar-vim)
- [markdown-preview](https://github.com/iamcco/markdown-preview.nvim) or your
  preferred markdown preview / syntax highlighter tool

### functions

**see [doc/ephemeris.txt](doc/ephemeris.txt) for additional help**

```vim
:EphemerisCreateIndex
```

- creates an index of all diary entries found in
  `g:calendar_diary` and opens a vertical split with
  the markdown-compatible index.

```vim
:EphemerisGotoIndex
```

- opens the index of all diary entries if it exists.found at `:echom expand(g:calendar_diary)."/index.md"`

```vim
:EphemerisCopyTodos
```

- copies the last set of `TODOs:` and appends them to
  the current day's diary entry.

```vim
:EphemerisFilterTasks
```

- filters **out** all completed tasks and their non-task oriented list items
  and text blocks

#### example mappings

```vim
nmap <leader> eci :call EphemerisCreateIndex<CR>
nmap <leader> egi :call EphemerisGotoIndex<CR>
nmap <leader> ect :call EphemerisCopyTodos<CR>
nmap <leader> eft :call EphemerisFilterTasks<CR>
```
