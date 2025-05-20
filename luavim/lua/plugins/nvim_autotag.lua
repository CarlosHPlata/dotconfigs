return {
  {
    "windwp/nvim-ts-autotag",
    lazy = true,
    ft = { "html", "xml", "javascriptreact", "typescriptreact", "vue", "svelte", "astro" },
    config = function ()
      require('nvim-ts-autotag').setup()
    end
  }
}
