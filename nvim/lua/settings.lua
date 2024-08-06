local g = vim.g
local opt = vim.opt
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local set = vim.api.nvim_set_option_value

-- common settings
local common = vim.api.nvim_create_augroup("my_common", {})
if vim.fn.executable("zenhan.exe") == 1 then
  vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
    group = common,
    pattern = { "*" },
    command = "call system(['zenhan.exe','0'])",
  })
end

-- clipboard
set("clipboard", "unnamedplus", {})

-- vscode settings
if vim.g.vscode == 1 then
  local vscode = require("vscode")
  vim.notify = vscode.notify
else
  -- disable netrw at the very start of your init.lua
  g.loaded_netrw = 1
  g.loaded_netrwPlugin = 1

  -- shell settings
  if vim.fn.has("linux") == 1 then
    if vim.fn.executable("bash") == 1 then
      set("shell", "bash", {})
    end
  elseif vim.fn.has("win32") == 1 then
    set("shell", vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell", {})
    opt.shellcmdflag =
      "-nol -nop -ep RemoteSigned -c [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;$PSStyle.OutputRendering=[System.Management.Automation.OutputRendering]::PlainText;"
    set("shellredir", '2>&1 | %%{ "$_" } | Out-File -Encoding UTF8 %s; exit $LastExitCode', {})
    set("shellpipe", '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode', {})
    set("shellquote", "", {})
    set("shellxquote", "", {})
    g.python3_host_prog = vim.fn.expand("$USERPROFILE") .. [[\.pyenv\pyenv-win\shims\python3]]
    vim.keymap.set("n", "<M-t>", function()
      print(vim.fn.expand("$USERPROFILE") .. [[\test\test]])
    end, {})
  end

  set("laststatus", 3, {})
  set("number", true, {})
  set("helplang", "ja", {})
  set("encoding", "utf-8", {})
  opt.fileencodings = { "utf-8", "sjis", "iso-2022-jp", "euc-jp" }
  set("swapfile", false, {})
  set("tabstop", 2, {})
  set("shiftwidth", 0, {})
  set("expandtab", true, {})
  set("signcolumn", "yes:1", {})
  set("scrolloff", 5, {})
  set("inccommand", "split", {})
  set("showmode", false, {})
  opt.shortmess:append("S")
  set("winblend", 20, {})
  set("pumblend", 20, {})
  set("termguicolors", true, {})

  local term = augroup("my_term", {})
  autocmd({ "TermOpen" }, { group = term, command = "startinsert" })
  autocmd({ "TermEnter" }, { group = term, command = "startinsert" })
end
