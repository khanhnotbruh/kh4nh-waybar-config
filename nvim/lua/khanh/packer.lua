vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

    ---------------------------------------------------------------------------
    -- Core & Packer
    ---------------------------------------------------------------------------
    use 'wbthomason/packer.nvim'

    use {
        'ahmedkhalf/project.nvim',
        config = function()
            require("project_nvim").setup {
                -- optional settings
                detection_methods = { "pattern", "lsp" },
                patterns = { ".git", "package.json", "Makefile" },
            }
        end
    }


    ---------------------------------------------------------------------------
    -- UI / Theme / Statusline / Popup UI
    ---------------------------------------------------------------------------
    use {"catppuccin/nvim", as = "catppuccin" }
    use {"Mofiqul/dracula.nvim",as="dracula"}
    use {"tanvirtin/monokai.nvim",as="monokai"}
    use {"EdenEast/nightfox.nvim",as="nightfox"}
    use {"ellisonleao/gruvbox.nvim",as="gruvbox"}
    use {"folke/tokyonight.nvim",as="tokyonight"}

    use {
        "nvim-lualine/lualine.nvim",
        requires = { "nvim-tree/nvim-web-devicons" },
    }
    use {
        "folke/noice.nvim",
        requires = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        }
    }
    use {
        "folke/snacks.nvim",
    }
    use "folke/twilight.nvim"


    ---------------------------------------------------------------------------
    -- Navigation
    ---------------------------------------------------------------------------
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        requires = { 'nvim-lua/plenary.nvim' }
    }

    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        }
    }

    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { "nvim-lua/plenary.nvim" },
    }

    use "mbbill/undotree"
    use "tpope/vim-fugitive"

    ---------------------------------------------------------------------------
    -- LSP + Completion + Snippets
    ---------------------------------------------------------------------------
    use "neovim/nvim-lspconfig"
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp"

    use "L3MON4D3/LuaSnip"
    use "saadparwaiz1/cmp_luasnip"

    use "lewis6991/hover.nvim"

    ---------------------------------------------------------------------------
    --misc 
    ---------------------------------------------------------------------------
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    }
    use {
        "windwp/nvim-autopairs",
        config = function()
            require('nvim-autopairs').setup({
                map_enter = true,
                enable_check_bracket_line = true,
                check_ts = true,
            })
        end
    }
end)

