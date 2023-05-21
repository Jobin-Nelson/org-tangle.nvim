local treesitter_ok, treesitter = pcall(require, 'treesitter')

if not treesitter_ok then
  error('This plugin requires nvim-treesitter/nvim-treesitter')
end

local M = {}

return M
