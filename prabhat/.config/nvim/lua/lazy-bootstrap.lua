-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Ocaml setup

-- Get the opam share directory path
local opam_share_cmd = vim.fn.system 'opam var share'
-- Trim whitespace/newline from the command output
local opam_share_path = vim.fn.trim(opam_share_cmd)

-- Optional: Add related OCaml plugins if installed via opam
local ocp_indent_path = opam_share_path .. '/ocp-indent/vim'
if vim.fn.isdirectory(ocp_indent_path) == 1 then
  vim.opt.rtp:prepend(ocp_indent_path)
  -- print("Added ocp-indent Vim plugin to runtimepath.")
end

-- vim: ts=2 sts=2 sw=2 et
