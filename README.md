# NeovimRC

Small but powerfull NeoVim runtime configuration.

## Main features

- [Syntax highlighting](https://github.com/nvim-treesitter/nvim-treesitter)
- [LSP](https://microsoft.github.io/language-server-protocol/) support
- [Snippets](https://github.com/rafamadriz/friendly-snippets) support
- [DAP](https://microsoft.github.io/debug-adapter-protocol/) support
- [Code completion](https://github.com/hrsh7th/nvim-cmp)
- [Git integration](https://github.com/tpope/vim-fugitive)

## Supported languages

- PHP
- Go (partial support)

## Installation

To install the configuration you must perform the following steps:

1. Check the requirements
2. Clone this repo to ~/.config/nvim

### Common requirements

- GNU/Linux system
- Git >= 2.0
- Neovim >= 0.10
- C compiler, libstdc++ and libxml2-dev
- [luarocks](https://luarocks.org/)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [nerd-fonts](https://github.com/ryanoasis/nerd-fonts)
- [clipboard provider](https://neovim.io/doc/user/provider.html#provider-clipboard)

### Language specific requirements

- PHP >= 8.0 (for phpactor)
- Node.js >= 16 (for php-debug-adapter)
- Go >= 1.18 (for gopls)
- [golangci-lint](https://github.com/golangci/golangci-lint)

### About clipboard providers

There are different clipboard types for Linux systems: compatible with X11 or compatible with Wayland.
You must choose the right one. For instance, use xclip for X11 and wl-clipboard for Wayland.

### How to install Nerdfonts

You can use one of the following options.

1. Download one of the patched fonts from [here](https://www.nerdfonts.com/font-downloads) and put it in
~/.local/share/fonts directory.
2. [Patch](https://github.com/ryanoasis/nerd-fonts?tab=readme-ov-file#option-9-patch-your-own-font) your own font.

If you want to know where your font is located, just execute the following command:

```sh
fc-list | grep `fc-match "$FONTNAME" | cut -d ':' -f1` # put the name of the font in $FONTNAME
```

Example:

```sh
FONTNAME='monospace' sh -c 'fc-list | grep `fc-match "$FONTNAME" | cut -d ':' -f1`'
```

## Custom shortcuts

In the following shortcuts, `<leader>` represents space character.

### General

| Binding                | Modes | Description                                                                       |
|:----------------------:|:-----:|:---------------------------------------------------------------------------------:|
| J                      |   n   | Inline several lines.                                                             |
| J                      |   v   | Move highlighted lines down.                                                      |
| K                      |   v   | Move highlighted lines up.                                                        |
| n                      |   n   | Find the next occurrence of the searched pattern.                                 |
| N                      |   n   | Find the previous occurrence of the searched pattern.                             |
| Q                      |   n   | This default key is disabled.                                                     |
| `<C-d>`                |   n   | Scroll down half the page.                                                        |
| `<C-e>`                |   n   | Open harpoon window.                                                              |
| `<C-h>`                |   n   | Jump to the first element in the Harpoon file list.                               |
| `<C-j>`                |   n   | Quickfix commands: display the previous error in the list.                        |
| `<C-k>`                |   n   | Quickfix commands: display the next error in the list.                            |
| `<C-n>`                |   n   | Jump to the third element in the Harpoon file list.                               |
| `<C-p>`                |   n   | Fuzzy search through the output of git ls-files command, respects .gitignore.     |
| `<C-s>`                |   n   | Jump to the fourth element in the Harpoon file list.                              |
| `<C-t>`                |   n   | Jump to the second element in the Harpoon file list.                              |
| `<C-u>`                |   n   | Scroll up half the page.                                                          |
| `<leader><C-h>`        |   n   | Replace the first file in the Harpoon file list by the current buffer.            |
| `<leader><C-n>`        |   n   | Replace the third file in the Harpoon file list by the current buffer.            |
| `<leader><C-s>`        |   n   | Replace the fourth file in the Harpoon file list by the current buffer.           |
| `<leader><C-t>`        |   n   | Replace the second file in the Harpoon file list by the current buffer.           |
| `<leader>a`            |   n   | Add current buffer to the Harpoon file list.                                      |
| `<leader>d`            |  n,v  | Delete selected text in void buffer.                                              |
| `<leader>j`            |   n   | Quickfix commands: same as `<C-j>`, but the location list is used. See Nvim docs. |
| `<leader>k`            |   n   | Quickfix commands: same as `<C-k>`, but the location list is used. See Nvim docs. |
| `<leader>p`            |   x   | Replace selected text with content from buffer. The buffer content do not change. |
| `<leader>pf`           |   n   | Lists files in your current working directory, respects .gitignore.               |
| `<leader>ps`           |   n   | Searches for the input in your current working directory.                         |
| `<leader>pv`           |   n   | Exit from file reading.                                                           |
| `<leader>pws`          |   n   | Searches for the word under your cursor.                                          |
| `<leader>pWs`          |   n   | Searcher for the sequence of non-blank characters under your cursor.              |
| `<leader>r`            |   n   | Remove current buffer from the Harpoon file list.                                 |
| `<leader>s`            |   n   | Replace current word.                                                             |
| `<leader>u`            |   n   | Toggle the undo-tree panel.                                                       |
| `<leader>vh`           |   n   | Lists available help tags and opens a new window with the relevant help info.     |
| `<leader>Y`            |   n   | Copy current line from Vim to global buffer (clipboard provider required).        |
| `<leader>y`            |  n,v  | Copy selected text from Vim to global buffer (clipboard provider required).       |

### LSP

| Binding                | Modes | Description                                                                       |
|:----------------------:|:-----:|:---------------------------------------------------------------------------------:|
| [d                     |   n   | Move to the next diagnostic message.                                              |
| ]d                     |   n   | Move to the previous diagnostic message.                                          |
| gd                     |   n   | Jumps to the definition of the symbol under the cursor.                           |
| K                      |   n   | Displays hover information about the symbol under the cursor in a floating window.|
| `<C-h>`                |   i   | Displays signature information about the symbol under the cursor.                 |
| `<leader>f`            |   n   | Formats a buffer using the attached language server clients.                      |
| `<leader>vca`          |   n   | Selects a code action available at the current cursor position.                   |
| `<leader>vd`           |   n   | Show diagnostics in a floating window.                                            |
| `<leader>vji`          |   n   | Lists all the implementations for the symbol under the cursor.                    |
| `<leader>vrn`          |   n   | Renames all references to the symbol under the cursor.                            |
| `<leader>vrr`          |   n   | Lists all the references to the symbol under the cursor in the quickfix window.   |
| `<leader>vws`          |   n   | Lists all symbols in the current workspace in the quickfix window.                |

