local M = {}

M.get_root_dir = function(opts)
	opts = opts or {}
	-- Default to ~/prog-notes if not provided
	local default_path = vim.fn.expand("$HOME/prog-notes")
	return opts.notes_dir and vim.fn.expand(opts.notes_dir) or default_path
end

function M.ensure_dir_exists()
	local root_dir = M.get_root_dir()
	if vim.fn.isdirectory(root_dir) == 0 then
		vim.fn.mkdir(root_dir, "p")
	end
end

function M.ensure_lang_dir_exists(lang)
	local root_dir = M.get_root_dir()
	local lang_dir = root_dir .. "/" .. lang
	if vim.fn.isdirectory(lang_dir) == 0 then
		vim.fn.mkdir(lang_dir, "p")
	end
	return lang_dir
end

function M.create_float(title)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)

	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = title and (" " .. title .. " ") or nil,
		title_pos = "center",
	})

	vim.bo[buf].filetype = "markdown"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].buftype = "" -- Allow writing to the buffer

	return buf, win
end

-- Setup buffer keymaps and autocmds
function M.setup_buffer(buf, file_path)
	-- Add keymaps
	vim.keymap.set("n", "<C-y>", function()
		vim.cmd("write!")
		vim.notify("Note saved: " .. file_path)
	end, { buffer = buf })

	vim.keymap.set("n", "q", function()
		vim.api.nvim_buf_delete(buf, { force = true })
	end, { buffer = buf })

	-- Create autocmd to clean up keymaps when leaving buffer
	local group = vim.api.nvim_create_augroup("ProgNotes" .. buf, { clear = true })
	vim.api.nvim_create_autocmd("BufLeave", {
		group = group,
		buffer = buf,
		callback = function()
			vim.keymap.del("n", "<C-y>", { buffer = buf })
			vim.keymap.del("n", "q", { buffer = buf })
		end,
	})
end

function M.new_note()
	vim.ui.input({ prompt = "Language: " }, function(lang)
		if not lang then
			return
		end

		vim.ui.input({ prompt = "Note Name: " }, function(name)
			if not name then
				return
			end

			local lang_dir = M.ensure_lang_dir_exists(lang)
			local file_path = lang_dir .. "/" .. name .. ".md"

			local buf, win = M.create_float("New Note: " .. name)
			vim.api.nvim_buf_set_name(buf, file_path)

			local initial_content = {
				"# " .. name,
				"",
				"## Description",
				"",
				"## Code",
				"",
				"```" .. lang,
				"",
				"```",
			}
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, initial_content)
			M.setup_buffer(buf, file_path)
		end)
	end)
end

function M.find_notes()
	-- Get list of language directories
  local root_dir = M.get_root_dir()
	local lang_dirs = vim.fn.glob(root_dir .. "/*", false, true)

	-- Filter to only show directories
	local languages = {}
	for _, path in ipairs(lang_dirs) do
		if vim.fn.isdirectory(path) == 1 then
			table.insert(languages, vim.fn.fnamemodify(path, ":t"))
		end
	end

	-- Show language selection
	vim.ui.select(languages, {
		prompt = "Select language:",
	}, function(lang)
		if not lang then
			return
		end

		-- Get files in selected language directory
		local lang_path = root_dir .. "/" .. lang
		local files = vim.fn.glob(lang_path .. "/*.md", false, true)

		-- Create file list with just filenames
		local file_names = {}
		for _, path in ipairs(files) do
			table.insert(file_names, vim.fn.fnamemodify(path, ":t"))
		end

		-- Show file selection
		vim.ui.select(file_names, {
			prompt = "Select note:",
		}, function(file)
			if not file then
				return
			end

			local file_path = lang_path .. "/" .. file
			local buf, win = M.create_float(file)

			vim.api.nvim_buf_set_name(buf, file_path)
			vim.cmd("read " .. vim.fn.fnameescape(file_path))
			vim.api.nvim_buf_set_lines(buf, 0, 1, false, {})

			M.setup_buffer(buf, file_path)
		end)
	end)
end

return M
