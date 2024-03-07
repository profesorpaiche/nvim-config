# All the keymaps

Keep in mind that the leader key is <space>.

## General

Jumping is the square brakets

- (N) <leader>km - Opens this file in a separate tab
- (N) <leader>kM - Opens this file in a vertical window
- (V) = - Align indent

### Diagnostics (d)

- (N) [d - Previous diagnostic
- (N) ]d - Next diagnostic
- (N) <leader>dm - Diagnostic message

### Moving text

- (V) J - Moving line up 
- (V) K - Moving line down 

### Yanking and pasting

- (X) <leader>p - Retain copied text
- (N V) <leader>y - Copy to xsel
- (N) <leader>Y - Copy line to xsel

### Templates (,)

- (N) <leader>,Rdm - Format for Rmd and Quarto
- (N) <leader>,r - Format for R
- (N) <leader>,j - Format for Julia

### Spellcheck (s)

- (N) <leader>ss - Spanish
- (N) <leader>se - English
- (N) <leader>sa - Spanish & English
- (N) <leader>sx - None

## Comment

- (N V) gc... - Comment over ...

## Gitsigns (g)

- (N) <leader>gs - Stage buffer
- (N) <leader>gr - Reset buffer
- (N) <leader>gb - Blame line
- (N) <leader>gf - Git diff against index
- (N) <leader>gd - Toggle deleted

## Telescope (f)

- (N) <leader>fo - Find recently opened files
- (N) <leader>fb - Find buffers
- (N) <leader>f/ - Find text in current buffer (with grep)
- (N) <leader>ff - Find file
- (N) <leader>fg - Find Git files
- (N) <leader>fG - Find text in Git project
- (N) <leader>fd - Find in diagnostics
- (N) <leader>fd - Diagnostic list (Telescope)

## Treesitter (t)

- (N) <ctrl><space> - Select object
- (V) <ctrl>i - Increment selection
- (V) <ctrl>d - Decrease selection
- (N) ..af - Something around function
- (N) ..if - Something inside function
- (N) [f - Jump to start next function
- (N) ]f - Jump to start previous function

## LSP (l)

- (N) <leader>lgd - Go to definition (Telescope)
- (N) <leader>lgr - Go to references (Telescope)
- (N) <leader>lgi - Go to implementations (Telescope)
- (N) <leader>lds - Show symbols (or objects, kinda) in the document (Telescope)
- (N) <leader>lws - Show symbols (or objects, kinda) in the workspace (Telescope)
- (N) K - Show documentation
- (N) <ctrl>k - Show signature, how is used it
- (C) :Format - Format buffer according to LSP

## Which key (w)
