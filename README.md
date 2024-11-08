# 🚀 MinNvim

This repository contains my personal Neovim configuration, designed for an efficient and powerful editing experience.

## 📁 Structure

```
├── README.md
├── init.lua
├── lazy-lock.json
└── lua
    ├── config
    │   ├── lazy.lua
    │   ├── remap.lua
    │   ├── set.lua
    │   └── snippets.lua
    └── plugins/
```

## 🔑 Key Features

- 📦 **Package Manager**: [Lazy.nvim](https://github.com/folke/lazy.nvim)
- 🎨 **Colorscheme**: [Rose Pine](https://github.com/rose-pine/neovim)
- ⌨️ **Leader Key**: Space

## ⚙️ Configuration Highlights

- 🛠️ Core Settings (`lua/config/set.lua`): Vim sets for tabs, appearance, and general behavior
- 🗺️ Key Mappings (`lua/config/remap.lua`): Custom keybindings for enhanced productivity
- 🧩 Plugin Management (`lua/config/lazy.lua`): Lazy.nvim initialization and plugin loading
- ✂️ Snippets (`lua/config/snippets.lua`): Custom snippet definitions

## 🧩 Plugins (`lua/plugins/`)

- 💬 **Comment**: Easy code commenting
    - `gcc` - un/comment line
    - `gc` - un/comment line (visual mode)
- 🧠 **Completions**: Auto-completion setup
    - `Ctrl+n` - next
    - `Ctrl+p` - prev
    - `Ctrl+y` - select
    - `Ctrl+l` - snippet next
- 📝 **Editor**: General editor enhancements
- 🎣 **Harpoon**: Quick file navigation
    - `ga` - add
    - `gh` - open
- 📏 **Indentscope**: Visual indentation guides
- 🌐 **LSP Config**: Language Server Protocol setup
- 🧩 **LuaSnip**: Snippet engine
- 📂 **Oil**: Minimalist file explorer
    - `Space+e` - oil.nvim bases explorer
    - Oil
        - hjkl - move
        - l - select
        - o/O - open file vertically or horizontally
- 🔭 **Telescope**: Fuzzy finder
    - `Space+ff` - find
    - `Space+fr` - resume find
    - `Space+fl` - grep
    - `Space+fb` - find buffers
- 🌳 **Treesitter**: Syntax highlighting and code navigation
- 🖼️ **UI**: User interface improvements
- 🔑 **Which Key**: Keybinding helper

## ⌨️ Key Bindings

- `<leader>`: Open which-key
- `<Tab>` / `<S-Tab>`: Navigate between tabs
- `[b` / `]b`: Cycle through buffers
- `<C-d>` / `<C-u>`: Scroll down/up (centered)
- `-` / `|`: Split horizontally/vertically
- `<leader>e`: Open file explorer
- `ga`: Add file to Harpoon
- `gh`: Toggle Harpoon telescope
- `<leader>b`: Buffer-related commands
- `<leader>f`: Find (Telescope) commands
- `<leader>l`: LSP-related commands
- `<leader>s`: Various shortcuts (replace, yank, delete, etc.)
- `<leader>x`: Extra commands (Todo, Noice, Lazy, Mason)

## 🌐 LSP Features

- 🔍 Diagnostics viewing with Telescope and Trouble
- 🛠️ Code actions
- 🏷️ Symbol navigation
- 📦 Import organization

## 🔧 Additional Features

- 🔭 Integration with Telescope for enhanced searching
- 🪝 Custom autocmds for file-specific settings
- ✂️ LuaSnip for advanced snippet functionality
- 🔑 Which Key for discoverable keybindings

## 💾 Installation

1. Backup your existing Neovim configuration
```bash
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}
```
2. Clone this repository into your Neovim configuration directory (`~/.config/nvim`)
3. Launch Neovim to automatically install plugins

## 💡 Tips and Tricks

### 🧠 Pure Neovim

#### 🚶‍♂️ Movements
- `h`, `j`, `k`, `l`: Basic left, down, up, right movements
- `w`, `b`, `e`: Word navigation
- `0`, `$`: Start/end of line
- `gg`, `G`: First/last line of document
- `{`, `}`: Jump between paragraphs
- `Ctrl-u`, `Ctrl-d`: Move half a screen up/down
- `%`: Jump to matching parenthesis or bracket

#### 🔍 Searching
- `/pattern`, `?pattern`: Search forward/backward
- `n`, `N`: Next/previous search result
- `*`, `#`: Search word under cursor forward/backward

#### 🎯 Find and Till
- `f{char}`, `F{char}`: Find next/previous occurrence of {char}
- `t{char}`, `T{char}`: Till before/after occurrence of {char}
- `;`, `,`: Repeat last f, F, t, or T movement

#### 🎭 Text Objects (prefix with a/c/d/y/v)
- `iw`, `aw`: Inner word, a word
- `is`, `as`: Inner sentence, a sentence
- `ip`, `ap`: Inner paragraph, a paragraph

#### ✏️ Editing
- `c`: Change (delete and enter insert mode)
- `d`: Delete
- `y`: Yank (copy)
- `p`, `P`: Put (paste) after/before cursor
- `r`: Replace single character
- `~`: Toggle case of character under cursor

#### 🔄 Search and Replace
- `:s/foo/bar/g`: Replace foo with bar on current line
- `:%s/foo/bar/g`: Replace in entire file
- `:%s/foo/bar/gc`: Replace in entire file with confirmations

### 🧩 With Plugins

#### 🔭 Telescope
- `<leader>ff`: Find files
- `<leader>fg`: Live grep
- `<leader>fb`: Buffers
- `<leader>fh`: Help tags

#### 🎣 Harpoon
- `<leader>a`: Add file to Harpoon
- `<C-e>`: Toggle quick menu

#### 🔑 Which Key
- `<leader>`: Show available keybindings

#### 🌐 LSP
- `gd`: Go to definition
- `gr`: Go to references
- `gi`: Go to implementation
- `K`: Hover documentation
- `<leader>ca`: Code action
- `<leader>rn`: Rename

#### 🌳 Treesitter
- Improved syntax highlighting
- Incremental selection: `gnn`, `grn`, `grc`, `grm`

#### 💬 Comment.nvim
- `gcc`: Toggle line comment
- `gbc`: Toggle block comment

#### ✂️ LuaSnip
- `<C-k>`: Expand snippet
- `<C-j>`: Jump to next snippet placeholder
- `<C-k>`: Jump to previous snippet placeholder

#### 📋 Registers
- `:reg`: Shows registers
- `"0p`: Get content from register 0 and paste it

### 🔀 Combined Operations

- `ciw`: Change inner word
- `ct,`: Change until next comma
- `d2j`: Delete 2 lines down
- `y$`: Yank to end of line
- `di"`: Delete inside quotes
- `ca"`: Change around quotes
- `>ap`: Indent a paragraph
- `gUaw`: Uppercase a word
- `=G`: Auto-indent to end of file
- `!ipjq`: Format paragraph with 'jq'

#### 🔄 Search and Replace Workflow
`* | ciw | n | .`: Change occurrences one by one

#### 🎭 Text Object Operations
- `vip`: Select inner paragraph
- `yip`: Yank inner paragraph
- `cip`: Change inner paragraph

#### 🚀 Advanced Examples
- `f"ci"`: Find next quote and change contents
- `%v$y`: Jump to matching brace, select to end of line, and yank
- `ggVG=`: Go to top, select all, auto-indent

### 🎥 Macros

#### 📹 Recording a Macro
1. `q{a-z}`: Start recording (e.g., `qa`)
2. Perform commands
3. `q`: Stop recording

#### ▶️ Playing a Macro
- `@{a-z}`: Play macro (e.g., `@a`)
- `@@`: Repeat last played macro

#### 🔁 Repeating Macros
- `{number}@{a-z}`: Play macro multiple times (e.g., `5@a`)

#### ✏️ Editing Macros
1. `"ap`: Paste contents of macro 'a'
2. Edit the macro
3. `"ay$`: Yank edited macro back to register 'a'

#### 💡 Tips for Effective Macro Use
- Start and end in consistent positions
- Use relative movements
- Test before wide application
- Macros can include any commands, movements, or even other macros

### 🌍 Project-wide Search and Replace
1. 🔍 Live grep
2. 📋 Ctrl+Q to add to quickfix list
3. 🔄 `:cfdo %s/find/replace/g | update | bd`
