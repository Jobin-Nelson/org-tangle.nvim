local treesitter_ok, treesitter = pcall(require, 'nvim-treesitter')

if not treesitter_ok then
  error('This plugin requires nvim-treesitter/nvim-treesitter')
end

local M = {}

M.setup = function(_)
  vim.keymap.set('n', '<leader>oe', require('org-tangle.tangle'), { desc = 'Org Tangle' })
end

return M
