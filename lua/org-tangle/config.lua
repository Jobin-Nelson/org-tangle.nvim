local treesitter_ok, treesitter = pcall(require, 'treesitter')

if not treesitter_ok then
  error('This plugin requires nvim-treesitter/nvim-treesitter')
end

local M = {}

M.setup = function()
  vim.keymap.set('n', '<leader>oe', require('org-tangle').tangle, { desc = 'Org Tangle' })
end

return M
