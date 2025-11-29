local map=vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-----------------------------------------------------
-- navigation
-----------------------------------------------------

map("v","i","c",{ noremap = true })

-----------------------------------------------------
--indent
-----------------------------------------------------
vim.api.nvim_set_keymap("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<S-Tab>", "<gv", { noremap = true, silent = true })
-----------------------------------------------------
-- text tools
-----------------------------------------------------
map("v","J",":m '>+1<CR>gv=gv")
map("v","K",":m '>-2<CR>gv=gv")
map("v", "<C-c>", ':%y+<CR>', { noremap = true, silent = true })
map("x","<leader>p","\"_dP")
function GoLeftOrWrap()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local current_line_text = vim.api.nvim_get_current_line()
  -- Is the cursor at col 0 or at the first non-whitespace?
  local before_cursor = current_line_text:sub(1, col)
  if col == 0 or before_cursor:match("^%s*$") then
    -- Not top of buffer?
    if line > 1 then
      local prev_line_text = vim.api.nvim_buf_get_lines(0, line-2, line-1, false)[1]
      vim.api.nvim_win_set_cursor(0, {line-1, #prev_line_text})
    end
  else
    vim.cmd("normal! h")
  end
end
map('n', 'h', GoLeftOrWrap, { noremap = true, silent = true })
map('n', '<Left>', GoLeftOrWrap, { noremap = true, silent = true })
-----------------------------------------------------
-- Buffer navigation buffer :a
-----------------------------------------------------
map("n", "<leader>ah", ":bprevious<CR>", { noremap = true, silent = true })
map("n", "<leader>al", ":bnext<CR>", { noremap = true, silent = true })
map("n", "<leader>ad", ":bdelete<CR>", { noremap = true, silent = true })
map("n", "<leader>ap", "<C-w>p", { silent = true })
-----------------------------------------------------
--err log key:l
-----------------------------------------------------
map("n", "<leader>lo", function()
  vim.diagnostic.setloclist()
  vim.cmd("lopen")
end, { noremap = true, silent = true })

map("n","<leader>lc", function ()
    vim.cmd("lclose")
end, { noremap = true, silent = true })
-----------------------------------------------------------------
--terminal key:`
-----------------------------------------------------------------
-- Open terminal in horizontal split
map("n", "<leader>`oh", ":split | terminal<CR>", { noremap = true, silent = true })
-- Open terminal in vertical split
map("n", "<leader>`ov", ":vsplit | terminal<CR>", { noremap = true, silent = true })

map("n","<leader>`c",function ()
    local bufs = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(bufs) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
            if vim.bo[bufnr].buftype == 'terminal' then
                pcall(vim.cmd, 'bd!' .. bufnr)
            end
        end
    end
end, { noremap = true, silent = true })

-----------------------------------------------------
-- Neo-tree key:e
------------------------------------------------------
local ok_tree, neotree = pcall(require, "neo-tree")
if ok_tree then
    map("n", "<leader>ef", ":Neotree reveal_force_cwd<CR>", { silent = true })
    map("n", "<leader>eo", ":Neotree toggle<CR>", { silent = true })

    neotree.setup({
        window = {
            mappings = {
                ["<Tab>"] = "expand_all_nodes",
                ["<S-Tab>"] = "close_all_nodes",

                ["o"] = "toggle_node",
                ["<cr>"]="open",

                ["a"] = { "add", config = { show_path = "relative" } },
                ["d"] = { "add_directory", config = { show_path = "relative" } },

                ["D"] = "delete",
                ["r"] = "rename",
            },
        },
    })
end

------------------------------------------------------
-- Fugitive
------------------------------------------------------

map("n", "<leader>gs", vim.cmd.Git)

------------------------------------------------------
-- Harpoon 2 key: none
------------------------------------------------------
local ok_harpoon, harpoon = pcall(require, "harpoon")
if ok_harpoon then
    harpoon:setup()

    map("n", "<leader>a", function()
        harpoon:list():add()
        vim.notify("Buffer added to harpoon!", vim.log.levels.INFO)
    end)
    map("n", "<C-e>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
    end,{ noremap = true, silent = true })

    -- select
    map("n", "<leader>1", function() harpoon:list():select(1) end)
    map("n", "<leader>2", function() harpoon:list():select(2) end)
    map("n", "<leader>3", function() harpoon:list():select(3) end)
    map("n", "<leader>4", function() harpoon:list():select(4) end)

    -- prev / next
    map("n", "<leader>[", function() harpoon:list():prev() end)
    map("n", "<leader>]", function() harpoon:list():next() end)
end

------------------------------------------------------
-- Telescope key :s
------------------------------------------------------
local ok_telescope, builtin = pcall(require, "telescope.builtin")
if ok_telescope then
    map("n", "<leader>sf", builtin.find_files, {})
    map("n", "<leader>sg", builtin.live_grep, {})
    map("n", "<leader>sb", builtin.buffers, {})
    map("n", "<leader>sh", builtin.help_tags, {})
end

------------------------------------------------------
-- Undo Tree
------------------------------------------------------
map("n", "<leader>u", vim.cmd.UndotreeToggle)
------------------------------------------------------
-- comment,header && replace
------------------------------------------------------
function InsertHeader1()
    local comment = vim.fn.input("Comment sign: ")
    if comment == "" then
        print("No comment sign provided!")
        return
    end

    local content = vim.fn.input("Header content: ")
    if content == "" then
        print("No content provided!")
        return
    end
    local line_len =75 
    local padding = math.floor((line_len - #content - 2) / 2)
    local content_line = comment .. string.rep(" ", padding) .. content .. string.rep(" ", line_len - #content - padding - #comment) .. comment
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row, row, false, {content_line})
end

function InsertHeader2()
    -- Ask for comment sign
    local comment = vim.fn.input("Comment sign: ")
    if comment == "" then
        print("No comment sign provided!")
        return
    end

    -- Ask for header content
    local content = vim.fn.input("Header content: ")
    if content == "" then
        print("No content provided!")
        return
    end

    -- Determine line length
    local line_len = 60
    local border_line = comment:rep(1) .. string.rep("/", line_len - #comment)

    -- Create centered content line
    local padding = math.floor((line_len - #content - 2) / 2)
    local content_line = comment .. string.rep(" ", padding) .. content .. string.rep(" ", line_len - #content - padding - #comment) .. comment

    -- Insert into current buffer
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row, row, false, { border_line, content_line, border_line })
end

map("n","<leader>h2",InsertHeader2,{ noremap = true, silent = true })
map("n","<leader>h1",InsertHeader1,{ noremap = true, silent = true })


local function toggle_comment_with_prompt()
    local range = "."
    local mode = vim.fn.mode()
    if mode:find("^[vV\22]") then
        vim.cmd("normal! \27") -- Send ESC to exit visual mode
        range = "'<,'>"
    end
    local comment_prefix = vim.fn.input("Comment Prefix (Leave empty to UNCOMMENT): ")
    local escaped_prefix = vim.fn.escape(comment_prefix, "/\\")

    if comment_prefix == "" then
        -- --- UNCOMMENT LOGIC ---
        local comment_string = vim.opt_local.commentstring:get()
        if not comment_string or comment_string == "" then
             print("Warning: No commentstring defined for this filetype.")
             return
        end
        local leader = comment_string:match("^([^%%]*)%%s")
        if leader then
            local core_marker = leader:match("^(.-)%s*$")
            local escaped_marker = vim.fn.escape(core_marker, "/\\")
            -- \v : very magic
            -- ^\s* : match start of line and indentation...
            -- \zs : ...BUT start the "match to be deleted" HERE (preserves existing indentation)
            -- %s : the comment symbol
            -- \s* : optional space after the symbol
            local cmd = string.format("%s s/\\v^\\s*\\zs%s\\s*//", range, escaped_marker)
            local success, err = pcall(vim.cmd, cmd)
            if success then
                -- --- INDENTATION LOGIC ---
                if range == "'<,'>" then
                    vim.cmd("normal! gv=")
                else
                    vim.cmd("normal! ==")
                end
                print("Uncommented and re-indented.")
            elseif err and not string.match(err, "Pattern not found") then
                print("Error: " .. err)
            end
        else
            print("Warning: Could not parse comment leader.")
        end

    else
        -- --- COMMENT LOGIC ---
        local cmd = string.format("%s s/^/%s/", range, escaped_prefix)
        local success, err = pcall(vim.cmd, cmd)
        if success then
            print("Commented with: '" .. comment_prefix .. "'")
        elseif err and not string.match(err, "Interrupted") then
            print("Error: " .. err)
        end
    end
end
vim.keymap.set({"n", "v"}, "<leader>ra", toggle_comment_with_prompt, { desc = "Toggle Comment/Uncomment with Prompt" })

local function replace_word()
    local from = vim.fn.input("Replace: ")
    if from == "" then return end
    local to = vim.fn.input("With: ")

    local search_pattern = "\\V" .. vim.fn.escape(from, "/\\")
    local replace_pattern= vim.fn.escape(to, "/\\&~")
    local cmd = string.format("%%s/%s/%s/gIc", search_pattern, replace_pattern)
    local success, err = pcall(vim.cmd, cmd)
    if success then
        print("Replaced '" .. from .. "' with '" .. to .. "'")
    else
        if not string.match(err, "Interrupted") then
            print("Error: " .. err)
        end
    end
end

vim.keymap.set("n", "<leader>rw", replace_word, { desc = "Search and Replace (Literal)" })

------------------------------------------------------
-- twilight 
------------------------------------------------------
map("n","<leader>f",":Twilight<CR>")


