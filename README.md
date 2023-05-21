# org-tangle.nvim

The org-tangle.nvim plugin is a tool that enables tangling Org source blocks written in Lua within Neovim. This plugin seamlessly integrates with Neovim's Lua environment and provides a straightforward way to extract and save Lua code from Org files.

## Features

- Tangle Org source blocks written in Lua.
- Efficient extraction of source code from Org files.
- Smooth integration with Neovim's Lua environment.

## Requirements

- Neovim 0.5 or above.
- Treesitter and org parser installed

## Installation

To install the plugin, utilize your preferred plugin manager. For example, using [lazy.nvim](https://github.com/folke/lazy.nvim). Add the following line to your Neovim configuration file:

```lua
{
  "Jobin-Nelson/telescope-projects",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {},
}
```

## Usage

1. Open an Org file in Neovim that contains some source blocks and the tangle target file in the headers like.

```org
#+TITLE: FOO
#+AUTHOR: Foo bar
#+EMAIL: foo@bar.com
#+STARTUP: overview
#+PROPERTY: header-args :tangle foo.bar

* Baz
```

2. To tangle the above file perform the following keypress `<leader>oe`

Executing this keypress will tangle the source code and save it as a separate target file. By default, the tangling process utilizes the filename in the `PROPERTY` directive of the Org file

## Configuration

At the moment there is no way to configure the plugin as I built it for me. If such needs arises I'll add more configuration

## License

This plugin is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Contributing

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please create a new issue or submit a pull request on the GitHub repository.
