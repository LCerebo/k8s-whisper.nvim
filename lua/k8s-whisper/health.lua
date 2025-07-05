local curl = require 'plenary.curl'
local M = {}

M.check = function()
  vim.health.start('k8s-whisper.nvim')

  -- Test schema catalog connectivity
  local schemas_catalog = 'datreeio/CRDs-catalog'
  local schema_catalog_branch = 'main'
  local github_base_api_url = 'https://api.github.com/repos'
  local github_headers = {
    Accept = 'application/vnd.github+json',
    ['X-GitHub-Api-Version'] = '2022-11-28',
  }

  local url = github_base_api_url .. '/' .. schemas_catalog .. '/git/trees/' .. schema_catalog_branch

  local ok, response = pcall(function()
    return curl.get(url, { headers = github_headers, query = { recursive = 1 } })
  end)

  if not ok then
    vim.health.error('Failed to connect to schema catalog: ' .. tostring(response))
    return
  end

  if response.status == 200 then
    vim.health.ok('Schema catalog is reachable (' .. schemas_catalog .. ')')
  else
    vim.health.error('Schema catalog returned status ' .. response.status .. ' (' .. schemas_catalog .. ')')
  end
end

return M

