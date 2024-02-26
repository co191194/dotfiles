local cmd = vim.cmd
local createCmd = vim.api.nvim_create_user_command
local g = vim.g
local opt = vim.opt
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local set = vim.api.nvim_set_option_value

-- 共通の設定
local common = vim.api.nvim_create_augroup("my_common", {})
vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
  group = common,
  pattern = { "*" },
  command = "call system(['zenhan','0'])",
})

-- 個別の設定
if vim.g.vscode == 1 then
else
  -- シェルの設定
  if vim.fn.has("linux") == 1 then
    if vim.fn.executable("bash") == 1 then
      set("shell", "bash", {})
    end
  elseif vim.fn.has("win32") then
    set("shell", vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell", {})
    opt.shellcmdflag =
      "-nologo -NoProfile -ExecutionPolicy RemoteSigned -command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;$PSStyle.OutputRendering = [System.Management.Automation.OutputRendering]::PlainText;"
    set("shellredir", '2>&1 | %%{ "$_" } | Out-File -Encoding UTF8 %s; exit $LastExitCode', {})
    set("shellpipe", '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode', {})
    set("shellquote", "", {})
    set("shellxquote", "", {})
    g.python3_host_prog = "C:/Users/bigfi/AppData/Local/Programs/Python/Python312/python.exe"
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

  cmd.colorscheme("vscode")

  -- local my_setting = augroup("my_setting", {})
  -- autocmd(
  --   {"BufEnter","BufWinEnter"}, {
  --     group = my_setting,
  --     callback = function()
  --       opt.number = true
  --     end,
  --   }
  -- )

  local js = augroup("my_javascript", {})
  autocmd({ "BufEnter", "BufWinEnter" }, {
    group = js,
    pattern = { "*.js", "*.mjs", "*.cjs" },
    callback = function()
      opt.tabstop = 2
      opt.shiftwidth = 0
      opt.expandtab = true
    end,
  })

  -- 画面下部にターミナルを表示する
  createCmd("T", function(cmd)
    vim.cmd([[
        split
        wincmd j
        resize 15
        terminal
      ]])
  end, {})

  local term = augroup("my_term", {})
  autocmd({ "TermOpen" }, { group = term, command = "startinsert" })
  autocmd({ "TermEnter" }, { group = term, command = "startinsert" })
end
