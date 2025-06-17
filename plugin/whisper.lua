
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'yaml',
  callback = function(args)
    local bufnr = args.buf
    -- Wait for the yaml-language-server to start
    local clients = vim.lsp.get_clients({ name = 'yamlls', bufnr = bufnr })
    if #clients > 0 then
      -- If the server is already running, call init()
      require('whisper').init(bufnr)
    else
      -- If the server is not running, wait for it to start
      vim.api.nvim_create_autocmd('LspAttach', {
        once = true,
        buffer = bufnr,
        callback = function(lsp_args)
          local client = vim.lsp.get_client_by_id(lsp_args.data.client_id)
          if client and client.name == 'yamlls' then
            require('whisper').init(bufnr)
          end
        end,
      })
    end
  end,
})
