# README

> a diary plugin/Calendar extension for vim

this plugin extends some of the functionality provided by the
[mattn/calendar-vim](https://github.com/mattn/calendar-vim) plugin's
diary function. the calendar plugin itself is not required but this
plugin reuses one of it's global variables `g:calendar_diary` without
interfering with `calendar-vim`.

![diary index and markdown side-by-side](img/side-by-side.png)

**see [doc/ephemeris.txt](doc/ephemeris.txt) for additional help**

version information available at [ vim.org
](https://www.vim.org/scripts/script.php?script_id=5879)

---------------------------------------------
#### functionalities

- create **index** of diary entries
  - index access/refresh
- smart **checkbox** list item management
  - filter/sort/aggregate/calculate
  - copy last set of TODO's / `- [ ]` to current day's diary entry

### ! required

set the root directory for your diary entries `g:calendar_diary` in your
`.vimrc` i.e.

```vim
let g:calendar_diary = '~/diary'
```

###### optional

set the string for `EphemerisToggleTask` to look for.
  default is `TODOs`. Everything below the marker in the most recent diary
  entry is copied and appended into the current day's entry.

```vim
let g:ephemeris_todos = '=== TASK LIST ==='
```

---------------------------------------------
#### installation

should work with your preferred vim plugin manager. e.g. add

```vim
Plug 'HP4k1h5/ephemeris'
Plug 'mattn/calendar-vim' " recommended
```

to your `.vimrc` and run

```vim
:source $MYVIMRC | PlugInstall
```

in command-line mode (see `:help cmdline`)

##### optional-but-helpful
- [vim-calendar
    /https://github.com/mattn/calendar-vim](https://github.com/mattn/calendar-vim)
- [markdown-preview](https://github.com/iamcco/markdown-preview.nvim)
    or your preferred markdown preview / syntax highlighter tool

---------------------------------------------
### usage

Call any of ephemeris' commands from anywhere.  Using `:EphemerisFilterTasks`
will operate on the currently active buffer. Otherwise all functions are
buffer agnostic and should work anywhere. see functions below...

#### functions

**see [doc/ephemeris.txt](doc/ephemeris.txt) for additional help**

```vim
:EphemerisCreateIndex
```

- creates an index of all diary entries found in `g:calendar_diary`
    and opens a vertical split with the markdown-compatible index. Be
    sure to set `g:calendar_diary` as there is no default.

```vim
:EphemerisGotoIndex
```

- opens the index of all diary entries if it exists.found at
    `:echom expand(g:calendar_diary)."/index.md"`

```vim
:EphemerisCopyTodos
```

- copies the last set of `TODOs:` and appends them to the current
    day's diary entry; will look through dates in the preceding 365 days, and
    use the most recent entry containing the `g:ephemeris_todos` string.  

```vim
:EphemerisFilterTasks
```

- filters out **completed** tasks and their non-task oriented list
    items and text blocks

**:EphemerisFilterTasks** diagram

```md
*------------------------------------*
| TODOs (before)                     |
|- [x] complete task 1               |
|- [ ] incomplete task 2             |
|  - [x] complete task 2a            |
|  - additional info that is not a   |    run in command-line mode
| task will be preserved if the      |  *---------------------*
| task is incomplete                 |--|:EphemerisFilterTasks|
|- [x] complete task 3               |  *---------------------*
|  - [ ] incomplete task 3a          |              |
|- [x] complete task 4               |              |
|  - but removed otherwise           |              |
|  - [ ] incomplete task 4a also     |              |
|   this will get preserved          |              |
*------------------------------------*              V
            *----------------------------------------------*
            | TODOs  (after)                               |
            |- [ ] incomplete task 2                       |
            |- [ ] incomplete task 3a                      |
            |- [ ] incomplete task 4a also                 |
            |  this will get preserved                     |
            *----------------------------------------------*
```

#### example-mappings

```vim
nmap <leader>eci :EphemerisCreateIndex<CR>
nmap <leader>egi :EphemerisGotoIndex<CR>
nmap <leader>ect :EphemerisCopyTodos<CR>
nmap <leader>eft :EphemerisFilterTasks<CR>
nmap <leader>et  :EphemerisToggleTask<CR>
```

##### consider

```vim
" keeps index properly sized
au BufEnter g:calendar_diary :vertical resize 38
```
