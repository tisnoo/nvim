return {
  -- quick file navigation
  {
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({})
      vim.keymap.set("n", "<leader>hh", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", { silent = true })
      -- add new file (mark)
      vim.keymap.set("n", "<leader>mm", ":lua require('harpoon.mark').add_file()<CR>", { silent = true })
      vim.keymap.set("n", "<leader>1", ":lua require('harpoon.ui').nav_file(1)<CR>", { silent = true })
      vim.keymap.set("n", "<leader>2", ":lua require('harpoon.ui').nav_file(2)<CR>", { silent = true })
      vim.keymap.set("n", "<leader>3", ":lua require('harpoon.ui').nav_file(3)<CR>", { silent = true })
      vim.keymap.set("n", "<leader>4", ":lua require('harpoon.ui').nav_file(4)<CR>", { silent = true })
      vim.keymap.set("n", "<leader>5", ":lua require('harpoon.ui').nav_file(5)<CR>", { silent = true })
      vim.keymap.set("n", "<leader>6", ":lua require('harpoon.ui').nav_file(6)<CR>", { silent = true })
      vim.keymap.set("n", "<leader>7", ":lua require('harpoon.ui').nav_file(7)<CR>", { silent = true })
      vim.keymap.set("n", "<leader>8", ":lua require('harpoon.ui').nav_file(8)<CR>", { silent = true })
      vim.keymap.set("n", "<leader>9", ":lua require('harpoon.ui').nav_file(9)<CR>", { silent = true })
      vim.keymap.set("n", "<leader>0", ":lua require('harpoon.ui').nav_file(0)<CR>", { silent = true })
    end,
  },
}
