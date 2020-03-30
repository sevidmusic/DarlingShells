" vim-plug stuff
call plug#begin('~/.vim/darlingVimPlugins')

" To add a plugin:
" 1. Add a Plug statement for the plugin to .vimrc
" Plug DEV/REPO
" Note: The plugin is indicated by the end of the repositories git url.
"       So a plugin from https://www.github.com/sevidmusic/plugin would
"       be indicated by:
"       Plug 'sevidmusic/plugin'
" 2. Once Plug statement is added to .vimrc, restart vim.
" 3. Once vim has restarted, use the PlugInstall command, this
"    will look at the .vimrc and will install any plugins not
"    yet installed.
" 4. Restart vim.
" 5. Once vim has restarted, run PlugUpdate and PlugUpgrade to make
"    sure all plugins are up to date
" 6. (optional) Run PlugClean to do any necessary cleanup.
"
" Example Plug: Plug 'foo/bar' would fetch https://github.com/foo/bar

" Supertab: Allows tab to be used for autocompletion @see https://github.com/ervandew/supertab
Plug 'ervandew/supertab'

" Improved php omni-completion @see https://github.com/shawncplus/phpcomplete.vim
Plug 'shawncplus/phpcomplete.vim'

" Nerd tree file navigator
Plug 'scrooloose/nerdtree'

" Syntax highlighting for NERDTree
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Needed for nerdtree-syntax-highliting to work
Plug 'ryanoasis/vim-devicons'

" Smooth scroll
Plug 'terryma/vim-smooth-scroll'

" Adds a tag navigator, specifically shows variables, functions, etc. for
" current file
Plug 'majutsushi/tagbar'

" Displays color preview of hex colors
Plug 'gko/vim-coloresque'

" Addes selectable color schemes to vim "
Plug 'flazz/vim-colorschemes'

" Easy color switching for the colorschemes plugin
" Commands:
"   F8                next scheme
"   Shift-F8          previous scheme
"   Alt-F8            random scheme
" Set the list of color schemes used by the above (default is 'all'):
"   :SetColors all              (all $VIMRUNTIME/colors/*.vim)
"   :SetColors my               (names built into script)
"   :SetColors blue slate ron   (these schemes)
"   :SetColors                  (display current scheme names)
" Set the current color scheme based on time of day:
"   :SetColors now
Plug 'felixhummel/setcolors.vim'

" Cool toolbar/statusline thats shows useful info such as current mode,
" branch/vcs info, file name, file type, current position, etc.
Plug 'vim-airline/vim-airline'

" Next Plug...

call plug#end()
" end vim-plug stuffg

" Tell vim to always use a 256 color mode, this helps insure colors
" display properly even when vim is used in color limited terminals.
" The vim-colorschemes plugin for instance will work better if vim
" uses a 256 color mode.
set t_Co=256

" Search file system recursivly for all file related tasks
" Provides tab-complete for all file-related tasks
" For more info @see
" https://www.youtube.com/watch?v=XA2WjJbmmoM&list=PLMlf7rmy7J0d--uivqAgQQH9LAwXa-1WL&index=10&t=706s
" about 15 minutes into video...
set path+=**

" Display all matching files when we tab complete
"" For more info @see
" https://www.youtube.com/watch?v=XA2WjJbmmoM&list=PLMlf7rmy7J0d--uivqAgQQH9LAwXa-1WL&index=10&t=706s
" about 15 minutes into video...
set wildmenu

" The set path and set widemenu configurations above allow the following:
" - Can hit tab when using :find search partial matches
" - Cas use * to make search fuzzy, e.g., *.txt would locate all files
"   with extension .txt
"   Hint: Another useful hint from the video is that you can use
"         :b to autocomplete any open buffer. For instance if you
"         have 2 files open, foo.txt, and bar.txt, and foo.txt is
"         the currently shown buffer, you can do :b ba<tab> and
"         vim will autocomplete to :b bar.txt

" Allow supertab plugin to let tabs trigger omnicompletion
let g:SuperTabDefaultCompletionType=""

" Tell vim to use ctags for PHP autocompletion
set tags=~/Code/DarlingCmsRedesign/php.tags

" Turn on line numbers
set nu

" Show the ruler which displays information about the current position int he
" document. Specifically this rules shows the line number, the character
" index, and the current position in the document represented by a percentage.
set ruler

" Underline the current line
set cursorline

" Show column marker at 80 characters
highlight ColorColumn ctermbg=green
call matchadd('colorColumn', '\%81v', 100)

" Use relative line numbers
set relativenumber

" Tabs
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

" Automatically remove trailing spaces fromm files on save
" NOT WORKING: DEBUG ASAP:
" autocmd BufWritePre * %s/\s\+$//ee
" Alternate version of above from
" https://stackoverflow.com/questions/12535183/how-to-set-two-autocmd-bufwritepre-in-vimrc
" Abouve was not working...
augroup prewrites
   autocmd!
    autocmd BufWritePre,FileWritePre * :%s/\s\+$//e | %s/\r$//e
augroup END

" Always split bottom then right
set splitbelow splitright

" Make sure wildmode autocompletion shows everything
set wildmode=longest,list,full

" END OF FILE "

" Vim smooth scrill plugin settings / mappings
" Smooth_scroll#up and smooth_scroll#down both take the following 3 parameters.
" Distance: This is the total number of lines you
" want to scroll
" Duration: This is how long you want each frame of the scrolling
" animation to last in milliseconds. Each frame will take at least this amount
" of time. It could take more if Vim's scrolling itself is slow
" Speed: This is how many lines to scroll during each frame of the scrolling
" animation
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>

" Force lines to NOT wrap "
set nowrap

