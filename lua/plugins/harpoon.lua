local harpoon = require 'harpoon'

harpoon:setup()

-- Add current file to Harpoon
vim.keymap.set('n', '<leader>a', function()
  harpoon:list():add()
end, { desc = 'Harpoon: Add file' })

-- Toggle Harpoon menu
vim.keymap.set('n', '<leader>e', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Harpoon: Toggle menu' })

-- Navigate to files using numbers
vim.keymap.set('n', '<leader>1', function()
  harpoon:list():select(1)
end, { desc = 'Harpoon: Go to file 1' })

vim.keymap.set('n', '<leader>2', function()
  harpoon:list():select(2)
end, { desc = 'Harpoon: Go to file 2' })

vim.keymap.set('n', '<leader>3', function()
  harpoon:list():select(3)
end, { desc = 'Harpoon: Go to file 3' })

vim.keymap.set('n', '<leader>4', function()
  harpoon:list():select(4)
end, { desc = 'Harpoon: Go to file 4' })

-- Navigate previous/next within Harpoon list
vim.keymap.set('n', '<leader>[', function()
  harpoon:list():prev()
end, { desc = 'Harpoon: Previous file' })

vim.keymap.set('n', '<leader>]', function()
  harpoon:list():next()
end, { desc = 'Harpoon: Next file' })
