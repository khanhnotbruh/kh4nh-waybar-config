vim.g.lspconfig_silent_deprecation = true

local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local on_attach = function(client, bufnr)
    if vim.bo[bufnr].filetype == "neo-tree" then
        return
    end
    local ns = vim.api.nvim_create_namespace("lua_ls")
    vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            border = "rounded",
            source = "always",
        },
    }, ns)
end



-- Diagnostic Signs
local signs = {
    Error = "",
    Warn  = "",
    Info  = "",
    Hint  = "",
}
for type, icon in pairs(signs) do
    vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "", numhl = "" })
end

-- Servers list
local servers = {
    "lua_ls",
    "pyright",
    "rust_analyzer",
    "clangd",
    "qmlls",
}
-- Setup loop
for _, server in ipairs(servers) do
    if server == "qmlls" then
        lspconfig.qmlls.setup {
            cmd = { "/usr/lib/qt6/bin/qmlls" },
            filetypes = { "qml", "qtquick" },
            root_dir = require("lspconfig.util").root_pattern("qmlls.ini", ".git", "."),
        }

    else
        lspconfig[server].setup({
            on_attach = on_attach,
            capabilities = capabilities,
        })
    end
end

