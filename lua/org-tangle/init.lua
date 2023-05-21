local lang = 'org'
local valid_headers = { 'header-args', ':tangle' }

local directive_query = vim.treesitter.query.parse(
  lang,
  [[
(directive
  name: (expr) @name (#eq? @name "PROPERTY"))
  ]]
)

local function get_block_query(filetype)
  return vim.treesitter.query.parse(
    lang,
    string.format('(block parameter: (expr) @x (#match? @x "%s"))', filetype)
  )
end

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

local function get_target_file(bufnr, root)
  if vim.bo[bufnr].filetype ~= 'org' then
    error('Tangle can only be performed on an org file')
  end

  local target_file = ''
  for id, node in directive_query:iter_captures(root, bufnr, 0, -1) do
    node = node:next_named_sibling()

    for header in node:iter_children() do
      local text = vim.treesitter.get_node_text(header, bufnr)
      if vim.tbl_isempty(valid_headers) then
        target_file = text
        break
      end
      check_valid_headers(text)
    end
  end

  if target_file == '' then
    error('No target file found from Org headers')
  end
  return target_file
end

local function create_file(target, bufnr, root)
  local target_filetype = vim.filetype.match({ filename = target })
  local block_query = get_block_query(target_filetype)
  local parent_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  local target_filepath = table.concat({ parent_dir, target }, '/')

  local target_file = io.open(target_filepath, 'w')
  for _, node in block_query:iter_captures(root, bufnr, 0, -1) do
    local text = vim.treesitter.get_node_text(node:next_named_sibling(), bufnr)
    target_file:write(text, '\n\n')
  end

  target_file:flush()
  target_file:close()
end

local M = {}

M.tangle = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local root = get_root(bufnr)

  local target = get_target_file(bufnr, root)
  create_file(target, bufnr, root)
end

M.setup = function(_)
  vim.keymap.set('n', '<leader>oe', require('org-tangle').tangle, { desc = 'Org Tangle' })
end

return M
-- lua vim.keymap.set('n', '<leader>r', ':update | luafile ~/playground/projects/org-tangle.nvim/lua/org-tangle/init.lua<cr>')
