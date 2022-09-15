local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins

  -- Appearance
  use "Mofiqul/vscode.nvim"
  use "vim-airline/vim-airline"
  use "vim-airline/vim-airline-themes"
  use "kyazdani42/nvim-web-devicons"
  use "morhetz/gruvbox"

  -- Tree
  use "kyazdani42/nvim-tree.lua"

  -- Git
  use "tpope/vim-fugitive"
  use "tpope/vim-rhubarb"
  use {
    'lewis6991/gitsigns.nvim',
    tag = "release",
  }

  -- Workspace
  use "nvim-telescope/telescope.nvim"
  use 'nvim-telescope/telescope-media-files.nvim'
  use "goolord/alpha-nvim"
  use {
    "akinsho/bufferline.nvim",
    tag = "v2.6.0",
  }
  use "ahmedkhalf/project.nvim"
  use "editorconfig/editorconfig-vim"

  -- Completion
  use {
    "neoclide/coc.nvim",
    branch = "release",
  }

  -- Treesitter
  use "nvim-treesitter/nvim-treesitter"
  use "nvim-treesitter/playground"

  -- Coding
  use "mg979/vim-visual-multi"
  use "preservim/nerdcommenter"
  use {
    "kkoomen/vim-doge",
    run = ":call doge#install()"
  }
  use "AndrewRadev/tagalong.vim"

  use "github/copilot.vim"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)


