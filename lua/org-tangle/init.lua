local ts_utils = require('nvim-treesitter.ts_utils')
local lang = 'org'
local valid_headers = { 'PROPERTY', 'header-args', ':tangle' }

local directive_query = vim.treesitter.query.parse(
  lang,
  [[
(directive
  (expr) @name (#eq? @name "PROPERTY")
  (value
    (expr) @x))
  ]]
)

local block_query = vim.treesitter.query.parse(
  lang,
  [[
(block
  parameter: (expr) @x (#match? @x "lisp"))
  ]]
)

local function check_valid_headers(text)
  for idx, header in ipairs(valid_headers) do
    if text == header then
      table.remove(valid_headers, idx)
      return
    end
  end
end

local function get_root(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, lang)
  local tree = parser:parse()[1]
  return tree:root()
end

local function get_target_file()
  -- local bufnr = vim.api.nvim_get_current_buf()
  local bufnr = 4
  if vim.bo[bufnr].filetype ~= 'org' then
    error('Tangle can only be performed on an org file')
  end

  local root = get_root(bufnr)

  local target_file = ''
  for id, node in directive_query:iter_captures(root, bufnr, 0, -1) do
    local text = vim.treesitter.get_node_text(node, bufnr)
    if vim.tbl_isempty(valid_headers) then
      target_file = text
      break
    end
    check_valid_headers(text)
  end

  if target_file == '' then
    error('No target file found from Org headers')
  end
  vim.print(target_file)
  return target_file
end

local function create_file(target)
  local target_filetype = vim.filetype.match({ filename = target })
  local bufnr = 4
  local root = get_root(bufnr)

  local changes = {}
  for id, node in block_query:iter_captures(root, bufnr, 0, -1) do
    local text = vim.treesitter.get_node_text(node:next_named_sibling(), bufnr)
    table.insert(changes, text)
  end
end

create_file(get_target_file())

-- local M = {}
--
-- M.tangle = function()
--   local target = get_target_file()
-- end
--
-- return M
-- lua vim.keymap.set('n', '<leader>r', ':luafile ~/playground/projects/org-tangle.nvim/lua/org-tangle/init.lua<cr>')
