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

local function in_valid_headers(text)
  for idx, header in ipairs(valid_headers) do
    if text == header then
      table.remove(valid_headers, idx)
      return true
    end
  end

  return false
end

local function get_root(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, lang)
  local tree = parser:parse()[1]
  return tree:root()
end

local function get_target_file()
  -- local bufnr = vim.api.nvim_get_current_buf()
  local bufnr = 3
  if vim.bo[bufnr].filetype ~= 'org' then
    error('Tangle can only be performed on an org file')
  end

  local root = get_root(bufnr)
  local valid_level = 3

  local target_file = ''
  for id, node in directive_query:iter_captures(root, bufnr, 0, -1) do
    local text = vim.treesitter.get_node_text(node, bufnr)
    if vim.tbl_isempty(valid_headers) and valid_level == 0 then
      target_file = text
      break
    end
    if in_valid_headers(text) then
      valid_level = valid_level - 1
    end
  end

  if target_file == '' then
    error('No target file found from Org headers')
  end
  return target_file
end

local function create_file(target)
  local target_filetype = vim.filetype.match({ filename = target })
  vim.print(target_filetype)
end

create_file(get_target_file())

-- local M = {}
--
-- M.tangle = function()
--   local target = get_target_file()
-- end
--
-- return M
