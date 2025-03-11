return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({})

    vim.keymap.set("n", "<leader>M", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "Open [M]ark window" })

    vim.keymap.set("n", "<leader>ma", function()
      harpoon:list():add()
    end, { desc = "[A]dd buffer to marks" })

    vim.keymap.set("n", "<leader>mr", function()
      harpoon:list():remove()
    end, { desc = "[R]emove buffer from marks" })

    vim.keymap.set("n", "<leader>1", function()
      harpoon:list():select(1)
    end)

    vim.keymap.set("n", "<leader>2", function()
      harpoon:list():select(2)
    end)

    vim.keymap.set("n", "<leader>3", function()
      harpoon:list():select(3)
    end)

    vim.keymap.set("n", "<leader>4", function()
      harpoon:list():select(4)
    end)
  end,
}
