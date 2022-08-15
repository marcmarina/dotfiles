-- Keymap helper
local function mapkey(mode, key, action)
  vim.api.nvim_set_keymap(mode, key, action, {
    noremap = true,
    silent = true,
  })
end

return mapkey
