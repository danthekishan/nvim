-- Utility functions for LSP reference replacements
local M = {}

-- UI related utilities
local UI = {}

function UI.notify(msg, level)
	vim.notify(msg, level or vim.log.levels.INFO)
end

function UI.create_floating_window(config)
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, config)

	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].modifiable = true
	vim.wo[win].cursorline = true

	return { buf = buf, win = win }
end

function UI.setup_windows()
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)

	return {
		references = {
			relative = "editor",
			width = width,
			height = math.floor(height / 2),
			row = 2,
			col = math.floor((vim.o.columns - width) / 2),
			style = "minimal",
			border = "rounded",
			title = " References (Space to select, j/k to move, ctrl-y to replace) ",
		},
		selection = {
			relative = "editor",
			width = width,
			height = math.floor(height / 2) - 2,
			row = math.floor(height / 2) + 4,
			col = math.floor((vim.o.columns - width) / 2),
			style = "minimal",
			border = "rounded",
			title = " Selected for replacement ",
		},
	}
end

function UI.prompt_for_replacement(word, preview, callback)
	local prompt = preview and string.format("Preview replacing '%s' with: ", word)
		or string.format("Replace '%s' with: ", word)

	vim.ui.input({
		prompt = prompt,
		default = word,
	}, function(input)
		if not input or input == "" then
			UI.notify(preview and "Preview cancelled" or "Replace cancelled")
			return
		end
		callback(input)
	end)
end

-- Reference handling utilities
local References = {}

function References.format_reference(item)
	local filename = vim.fn.fnamemodify(item.filename, ":~:.")
	local line_content = vim.fn.readfile(item.filename)[item.lnum]
	return string.format("%s:%d - %s", filename, item.lnum, line_content)
end

function References.parse_reference_line(line_content)
	local filename, lnum = line_content:match("^(.+):(%d+)")
	if filename and lnum then
		return {
			filename = vim.fn.expand(filename),
			lnum = tonumber(lnum),
		}
	end
	return nil
end

-- Preview handling utilities
local Preview = {}

function Preview.show_changes(items, word, replacement)
	if #items == 0 then
		return
	end

	-- Set quickfix list
	vim.fn.setqflist(items)
	vim.cmd("copen")

	-- Clear existing matches
	vim.fn.clearmatches()

	-- Add highlighting for the word to be replaced
	for _, item in ipairs(items) do
		local bufnr = vim.fn.bufadd(item.filename)
		if bufnr then
			vim.fn.bufload(bufnr)
			-- Add match highlight
			vim.fn.matchadd("Search", "\\<" .. vim.fn.escape(word, "\\") .. "\\>")
		end
	end

	UI.notify(string.format("Preview: Would replace '%s' with '%s' in %d locations", word, replacement, #items))
end

-- Replacement handling utilities
local Replacement = {}

function Replacement.execute(items, word, replacement, confirm)
	if #items == 0 then
		return
	end

	-- Store current position and window
	local cur_win = vim.api.nvim_get_current_win()
	local cur_pos = vim.fn.getpos(".")
	local cur_buf = vim.api.nvim_get_current_buf()

	-- Set quickfix list if not already set
	vim.fn.setqflist(items)

	local success, err = pcall(function()
		local escaped_word = vim.fn.escape(word, "/\\")
		local escaped_replacement = vim.fn.escape(replacement, "/\\")
		local cmd = string.format(
			"cfdo %%s/\\<%s\\>/%s/%s | update",
			escaped_word,
			escaped_replacement,
			confirm and "gce" or "ge"
		)
		vim.cmd(cmd)
	end)

	-- Safely restore position and window
	pcall(function()
		-- Only restore if the window and buffer still exist
		if vim.api.nvim_win_is_valid(cur_win) and vim.api.nvim_buf_is_valid(cur_buf) then
			vim.api.nvim_set_current_win(cur_win)
			if vim.api.nvim_win_get_buf(cur_win) == cur_buf then
				vim.fn.setpos(".", cur_pos)
			end
		end
	end)

	if success then
		UI.notify(string.format("Replaced all occurrences of '%s' with '%s'", word, replacement))
	else
		UI.notify(string.format("Error during replacement: %s", err), vim.log.levels.ERROR)
	end

	-- Close quickfix window if it was opened for preview
	if not confirm then
		vim.cmd("cclose")
	end
end

-- Interactive replace window manager
local InteractiveReplace = {}

function InteractiveReplace.new(word, references)
	local self = setmetatable({}, { __index = InteractiveReplace })
	self.word = word
	self.references = references
	self.selected_lines = {}
	self.ns_id = vim.api.nvim_create_namespace("LSPReferenceReplace")
	return self
end

function InteractiveReplace:setup()
	local windows = UI.setup_windows()

	self.refs_win = UI.create_floating_window(windows.references)
	self.sel_win = UI.create_floating_window(windows.selection)

	-- Format and set content
	local formatted_refs = vim.tbl_map(References.format_reference, self.references)
	vim.api.nvim_buf_set_lines(self.refs_win.buf, 0, -1, false, formatted_refs)

	self:setup_keymaps()
	self:setup_autocmds()
	vim.api.nvim_set_current_win(self.refs_win.win)
end

function InteractiveReplace:update_highlights()
	vim.api.nvim_buf_clear_namespace(self.refs_win.buf, self.ns_id, 0, -1)
	for line_num, _ in pairs(self.selected_lines) do
		vim.api.nvim_buf_add_highlight(self.refs_win.buf, self.ns_id, "Search", line_num - 1, 0, -1)
	end
end

function InteractiveReplace:close_windows()
	pcall(vim.api.nvim_win_close, self.sel_win.win, true)
	pcall(vim.api.nvim_win_close, self.refs_win.win, true)
end

function InteractiveReplace:handle_line_selection()
	local current_line = vim.api.nvim_win_get_cursor(self.refs_win.win)[1]
	local line_content = vim.api.nvim_buf_get_lines(self.refs_win.buf, current_line - 1, current_line, false)[1]

	if self.selected_lines[current_line] then
		self.selected_lines[current_line] = nil
	else
		self.selected_lines[current_line] = line_content
	end

	-- Update selection window
	local selected_content = vim.tbl_values(self.selected_lines)
	vim.api.nvim_buf_set_lines(self.sel_win.buf, 0, -1, false, selected_content)

	self:update_highlights()
end

function InteractiveReplace:handle_replacement()
	if vim.tbl_count(self.selected_lines) == 0 then
		UI.notify("No lines selected for replacement", vim.log.levels.WARN)
		return
	end

	UI.prompt_for_replacement(self.word, false, function(input)
		-- Create a list of items to replace from selected lines
		local items_to_replace = {}
		for _, line_content in pairs(self.selected_lines) do
			local ref = References.parse_reference_line(line_content)
			if ref then
				table.insert(items_to_replace, ref)
			end
		end

		Replacement.execute(items_to_replace, self.word, input, false)
		self:close_windows()
	end)
end

function InteractiveReplace:setup_keymaps()
	-- Close windows with q
	local function map(mode, key, fn, opts)
		opts = vim.tbl_extend("force", { buffer = self.refs_win.buf, nowait = true }, opts or {})
		vim.keymap.set(mode, key, fn, opts)
	end

	map("n", "q", function()
		self:close_windows()
	end)
	vim.keymap.set("n", "q", function()
		self:close_windows()
	end, {
		buffer = self.sel_win.buf,
		nowait = true,
	})

	-- Space to select/deselect line
	map("n", "<Space>", function()
		self:handle_line_selection()
	end)

	-- Select all references
	map("n", "<C-a>", function()
		local line_count = vim.api.nvim_buf_line_count(self.refs_win.buf)
		for line = 1, line_count do
			local line_content = vim.api.nvim_buf_get_lines(self.refs_win.buf, line - 1, line, false)[1]
			self.selected_lines[line] = line_content
		end
		self:update_highlights()
		local selected_content = vim.tbl_values(self.selected_lines)
		vim.api.nvim_buf_set_lines(self.sel_win.buf, 0, -1, false, selected_content)
	end)

	-- Confirm and replace
	map("n", "<C-y>", function()
		self:handle_replacement()
	end)
end

function InteractiveReplace:setup_autocmds()
	local cleanup_group = vim.api.nvim_create_augroup("LSPReferenceReplace", { clear = true })
	local resize_group = vim.api.nvim_create_augroup("LSPReferenceReplaceResize", { clear = true })
	vim.api.nvim_create_autocmd("BufLeave", {
		group = cleanup_group,
		buffer = self.refs_win.buf,
		callback = function()
			self:close_windows()
		end,
		once = true,
	})

	vim.api.nvim_create_autocmd("VimResized", {
		group = resize_group,
		callback = function()
			if not vim.api.nvim_win_is_valid(self.refs_win.win) or self.refs_win.win == nil then
				return
			end

			local updated = UI.setup_windows()

			vim.api.nvim_win_set_config(self.refs_win.win, updated.references)
			vim.api.nvim_win_set_config(self.sel_win.win, updated.selection)
		end,
		once = true,
	})
end

-- Main M functions
function M.get_search_word()
	if vim.fn.mode() == "v" then
		local start_pos = vim.fn.getpos("'<")
		local end_pos = vim.fn.getpos("'>")
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

		local text =
			vim.api.nvim_buf_get_text(0, start_pos[2] - 1, start_pos[3] - 1, end_pos[2] - 1, end_pos[3] - 1, {})[1]
		return text
	end
	return vim.fn.expand("<cword>")
end

function M.replace_references(opts)
	opts = opts or {}
	local word = M.get_search_word()

	vim.lsp.buf.references(nil, {
		on_list = function(options)
			if not options or #options.items == 0 then
				UI.notify(string.format("No references found for '%s'", word), vim.log.levels.WARN)
				return
			end

			UI.notify(string.format("Found %d references for '%s'", #options.items, word))

			if opts.preview_only then
				UI.prompt_for_replacement(word, true, function(input)
					Preview.show_changes(options.items, word, input)
				end)
			else
				UI.prompt_for_replacement(word, false, function(input)
					Replacement.execute(options.items, word, input, opts.confirm)
				end)
			end
		end,
	})
end

function M.interactive_replace()
	local word = vim.fn.expand("<cword>")

	vim.lsp.buf.references(nil, {
		on_list = function(options)
			if not options or #options.items == 0 then
				UI.notify("No references found", vim.log.levels.WARN)
				return
			end

			local interactive = InteractiveReplace.new(word, options.items)
			interactive:setup()
		end,
	})
end

return M
