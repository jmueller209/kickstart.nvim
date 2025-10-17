-- jk to exit Insert mode
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python', -- only for Python files
  callback = function()
    vim.keymap.set(
      'n',
      '<leader>r',
      function()
        vim.cmd ':w' -- save file
        vim.cmd ':!python %' -- run current file
      end,
      { buffer = true, desc = 'Run Python script' } -- buffer = true makes it local to this file
    )
  end,
})

-- Function to get PlatformIO project root
local function get_pio_root()
  local root = vim.fn.findfile('platformio.ini', '.;')
  if root == '' then
    return nil
  end
  return vim.fn.fnamemodify(root, ':h')
end

-- Define global functions once
function _G.pio_run_upload()
  local root = get_pio_root()
  if not root then
    print 'Not a PlatformIO project!'
    return
  end
  vim.cmd 'w' -- save current buffer
  vim.cmd('rightbelow vnew | vertical resize 50 | terminal platformio run --target upload -d ' .. root)
end

function _G.pio_serial_monitor()
  local root = get_pio_root()
  if not root then
    print 'Not a PlatformIO project!'
    return
  end
  vim.cmd('rightbelow vnew | vertical resize 50 | terminal platformio device monitor -d ' .. root)
end

vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('PlatformIOKeys', { clear = true }),
  callback = function()
    local root = get_pio_root()
    if root then
      -- Only define buffer-local keys if they aren't already set
      local opts = { noremap = true, silent = true }
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>rr', ':lua _G.pio_run_upload()<CR>', opts)
      vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ro', ':lua _G.pio_serial_monitor()<CR>', opts)
    end
  end,
})

vim.keymap.set('n', '<leader>fv', function()
  local file = vim.fn.expand '%:p'
  vim.cmd 'write' -- save current buffer
  vim.fn.system { 'vhdlfmt', '--write', file }
  vim.cmd 'edit' -- reload the formatted file
  print 'VHDL file formatted!'
end, { desc = 'Format VHDL file using vhdlfmt' })
