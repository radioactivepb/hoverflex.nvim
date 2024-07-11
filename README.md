# 💪 HoverFlex.nvim
A Neovim plugin to open hover docs in a focused, persistent, and non-distracting way.

Open hover docs in a new buffer, tab, or split so you can refer back to them quickly!

Dynamic splits allow you to open a split that will follow the documentation under your cursor!

- [Features](#features)
 
- [Installation](#installation)

- [Options](#options)

- [Functions](#functions)

## Features
- **Multiple views for hover docs**
    + *Tabs/Buffers*: Open hover docs in a separate tab/buffer
    + *Splits*: Open hover docs in a split window
    + *Dynamic Splits*: Open hover docs in a split window that updates documentation on the fly
- **Selective focus options**
    + *Normal Mode*: Open hoverflex and switch focus to the hoverflex buffer/tab/split
    + *Stay Mode*: Open hoverflex and stay focused on your current buffer/tab/split
- **Smart close capability**
    + *Close the current hoverflex buffer/tab/split*
    + *Close all hoverflex buffers/tabs/splits*
    + *Hover docs on an item that already exists get closed automatically*

## Installation
Minimal Lazy.nvim example (no keybinds, up to you to call the functions by hand)
```lua
{
    "radioactivepb/hoverflex.nvim"
}
```
Lazy.nvim example with default opts (uses default keybinds, see [Options](#options) for details)
```lua
{
    "radioactivepb/hoverflex.nvim",
    opts = {}
}
```
## Options
Many options are available for easy keybindings
```lua
{
    "radioactivepb/hoverflex.nvim",
    -- All displayed options are the defaults
    opts = {
        -- By default, any keybinds you do not pass to opts.keybinds will be instantiated
        -- using their default keys (below) unless disable_default_keybinds is set to true
        disable_default_keybinds = false,
        -- All the keybinds displayed below are the default keybinds
        keybinds = {
            -- Open hover docs in a new tab and switch to it
            tab = "<leader>ht",
            -- Open hover docs in a new tab and stay where you're at
            tab_stay = "<leader>hT",
            -- Open hover docs in a new buffer and switch to it
            buffer = "<leader>hb",
            -- Open hover docs in a new buffer and stay where you're at
            buffer_stay = "<leader>hB",
            -- Open hover docs in a new horizontal split and switch to it
            hsplit = "<leader>hs",
            -- Open hover docs in a new horizontal split and stay where you're at
            hsplit_stay = "<leader>hS",
            -- Open dynamic hover docs in a new horizontal split and switch to it
            hsplit_dynamic = "<leader>hds",
            -- Open dynamic hover docs in a new horizontal split and stay where you're at
            hsplit_dynamic_stay = "<leader>hdS",
            -- Open hover docs in a new vertical split and switch to it
            vsplit = "<leader>hv",
            -- Open hover docs in a new vertical split and stay where you're at
            vsplit_stay = "<leader>hV",
            -- Open dynamic hover docs in a new vertical split and switch to it
            vsplit_dynamic = "<leader>hdv",
            -- Open dynamic hover docs in a new vertical split and stay where you're at
            vsplit_dynamic_stay = "<leader>hdV",
            -- Close currently focused hoverflex buffer/tab/split
            -- or any currently open dynamic split
            close = "<leader>hq",
            -- Close all hoverflex related buffers/tabs/dynamic splits/splits
            close_all = "<leader>hQ",
        },
    }
}
```
For example, let's say you only want to use the "buffer" and "close_all" keybinds
```lua
{
    "radioactivepb/hoverflex.nvim",
    opts = {
        disable_default_keybinds = true,
        keybinds = {
            buffer = "<leader>hb",
            close_all = "<leader>hq",
        },
    }
}
```

Or maybe you only want to use the dynamic split capability

(This takes advantage of the fact that calling a dynamic split twice acts as a toggle)
```lua
{
    "radioactivepb/hoverflex.nvim",
    opts = {
        disable_default_keybinds = true,
        keybinds = {
            hsplit_dynamic_stay = "<leader>hs",
        },
    }
}
```



## Functions
```lua
-- Open hover docs in a new tab and switch to it
require("hoverflex").tab()

-- Open hover docs in a new tab without switching to it
require("hoverflex").tab_stay()

-- Open hover docs in a new buffer and switch to it
require("hoverflex").buffer()

-- Open hover docs in a new buffer without switching to it
require("hoverflex").buffer_stay()

-- Open hover docs in a new vertical split and switch to it
require("hoverflex").vsplit()

-- Open hover docs in a new vertical split without switching to it
require("hoverflex").vsplit_stay()

-- Open hover docs in a new horizontal split and switch to it
require("hoverflex").hsplit()

-- Open hover docs in a new horizontal split without switching to it
require("hoverflex").hsplit_stay()

-- Open dynamic hover docs in a new horizontal split and switch to it
-- Also acts as a toggle, so calling when a dynamic split is open will close any dynamic split 
require("hoverflex").hsplit_dynamic()

-- Open dynamic hover docs in a new horizontal split without switching to it
-- Also acts as a toggle, so calling when a dynamic split is open will close any dynamic split 
require("hoverflex").hsplit_dynamic_stay()

-- Open dynamic hover docs in a new vertical split and switch to it
-- Also acts as a toggle, so calling when a dynamic split is open will close any dynamic split 
require("hoverflex").vsplit_dynamic()

-- Open dynamic hover docs in a new vertical split without switching to it
-- Also acts as a toggle, so calling when a dynamic split is open will close any dynamic split 
require("hoverflex").vsplit_dynamic_stay()

-- Close focused hoverflex.nvim tab/buffer/split
-- Also closes any currently existing dynamic split
require("hoverflex").close()

-- Close all hoverflex.nvim tabs/buffers/splits
-- Also closes any currently existing dynamic split
require("hoverflex").close_all()
```
