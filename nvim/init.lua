vim.loader.enable()

-- 全体設定(autocmdを含む)
require("settings")
-- プラグインの設定
require("plugins")
-- プラグイン関連以外のキーマップ
require("keymaps")

-- 起動元がvscode以外の場合
if not require("utils").is_vscode() then
  -- カラースキーマの設定
  vim.cmd.colorscheme("vscode")
end
