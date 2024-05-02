return {
    -- fzf
    {
        'junegunn/fzf',
        build = function() vim.fn['fzf#install']() end
    },
    -- lua fzf implementation
    {
        "ibhagwan/fzf-lua",
        config = function()
          vim.keymap.set("n", "<leader>cc",
            function()
              require("fzf-lua").commands({
                winopts = {
                  preview = { hidden = "hidden" }
                }
              })
            end,
          { silent = true })
        end,
    },
}
