local M = {}

-- Store the last opened note path
M.last_note_path = nil
M.last_note_title = nil

M.get_root_dir = function(opts)
	opts = opts or {}
	-- Default to ~/Neovim-notes if not provided
	local default_path = vim.fn.expand("$HOME/neovim-notes")
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

-- Create a larger floating window
function M.create_float(title)
	local width = vim.o.columns
	local height = vim.o.lines
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		border = { " ", " ", " ", " ", " ", " ", " ", " " },
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
	-- Store current note path and title
	M.last_note_path = file_path
	M.last_note_title = vim.fn.fnamemodify(file_path, ":t:r")

	-- Save and quit
	vim.keymap.set("n", "q", function()
		if vim.bo[buf].modified then
			vim.cmd("write!")
			vim.notify("Note saved: " .. file_path)
		end
		vim.api.nvim_buf_delete(buf, { force = true })
	end, { buffer = buf })

	-- Quick save
	vim.keymap.set("n", "<C-s>", function()
		vim.cmd("write!")
		vim.notify("Note saved: " .. file_path)
	end, { buffer = buf })

	-- Create autocmd to clean up keymaps when leaving buffer
	local group = vim.api.nvim_create_augroup("NeovimNotes" .. buf, { clear = true })
	vim.api.nvim_create_autocmd("BufLeave", {
		group = group,
		buffer = buf,
		callback = function()
			vim.keymap.del("n", "q", { buffer = buf })
			vim.keymap.del("n", "<C-s>", { buffer = buf })
		end,
	})
end

-- Create or open scratch note
function M.scratch_note()
	local root_dir = M.get_root_dir()
	local scratch_dir = root_dir .. "/scratch"
	if vim.fn.isdirectory(scratch_dir) == 0 then
		vim.fn.mkdir(scratch_dir, "p")
	end

	local date = os.date("%Y-%m-%d")
	local file_path = scratch_dir .. "/scratch_" .. date .. ".md"

	local buf, win = M.create_float("Scratch Note: " .. date)
	vim.api.nvim_buf_set_name(buf, file_path)

	-- If file exists, read it
	if vim.fn.filereadable(file_path) == 1 then
		vim.cmd("read " .. vim.fn.fnameescape(file_path))
		vim.api.nvim_buf_set_lines(buf, 0, 1, false, {})
	else
		-- Create new scratch note template
		local initial_content = {
			"# Scratch Notes - " .. date,
			"",
			"## Quick Notes",
			"",
			"## Ideas",
			"",
			"## Links",
			"",
		}
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, initial_content)
	end

	M.setup_buffer(buf, file_path)
end

-- Create or open todo file
function M.todo()
	local root_dir = M.get_root_dir()
	M.ensure_dir_exists()
	local todo_path = root_dir .. "/TODO.md"

	local buf, win = M.create_float("TODO List")
	vim.api.nvim_buf_set_name(buf, todo_path)

	-- If todo file exists, read it
	if vim.fn.filereadable(todo_path) == 1 then
		vim.cmd("read " .. vim.fn.fnameescape(todo_path))
		vim.api.nvim_buf_set_lines(buf, 0, 1, false, {})
	else
		-- Create new todo template
		local initial_content = {
			"# TODO List",
			"",
			"## High Priority",
			"",
			"## In Progress",
			"",
			"## Backlog",
			"",
			"## Completed",
			"",
		}
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, initial_content)
	end

	M.setup_buffer(buf, todo_path)
end

-- Toggle between current buffer and last note
function M.toggle_last_note()
	if M.last_note_path and vim.fn.filereadable(M.last_note_path) == 1 then
		local buf, win = M.create_float(M.last_note_title)
		vim.api.nvim_buf_set_name(buf, M.last_note_path)
		vim.cmd("read " .. vim.fn.fnameescape(M.last_note_path))
		vim.api.nvim_buf_set_lines(buf, 0, 1, false, {})
		M.setup_buffer(buf, M.last_note_path)
	else
		vim.notify("No previous note available")
	end
end

-- Your existing new_note and find_notes functions remain the same
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
	local root_dir = M.get_root_dir()
	local lang_dirs = vim.fn.glob(root_dir .. "/*", false, true)
	local languages = {}
	for _, path in ipairs(lang_dirs) do
		if vim.fn.isdirectory(path) == 1 then
			table.insert(languages, vim.fn.fnamemodify(path, ":t"))
		end
	end

	vim.ui.select(languages, {
		prompt = "Select language:",
	}, function(lang)
		if not lang then
			return
		end
		local lang_path = root_dir .. "/" .. lang
		local files = vim.fn.glob(lang_path .. "/*.md", false, true)
		local file_names = {}
		for _, path in ipairs(files) do
			table.insert(file_names, vim.fn.fnamemodify(path, ":t"))
		end

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

-- Git integration functions
function M.git_commit_all()
	local root_dir = M.get_root_dir()

	-- Prompt for commit message
	vim.ui.input({ prompt = "Commit message: " }, function(message)
		if not message then
			vim.notify("Commit cancelled", vim.log.levels.WARN)
			return
		end

		-- Change to root directory
		local current_dir = vim.fn.getcwd()
		vim.cmd("cd " .. vim.fn.fnameescape(root_dir))

		-- Add all changes
		vim.fn.jobstart({ "git", "add", "." }, {
			on_exit = function(_, exit_code)
				if exit_code ~= 0 then
					vim.notify("Failed to stage changes", vim.log.levels.ERROR)
					vim.cmd("cd " .. vim.fn.fnameescape(current_dir))
					return
				end

				-- Commit changes
				vim.fn.jobstart({ "git", "commit", "-m", message }, {
					on_exit = function(_, commit_exit_code)
						if commit_exit_code ~= 0 then
							vim.notify("Failed to commit changes", vim.log.levels.ERROR)
						else
							vim.notify("Changes committed successfully", vim.log.levels.INFO)
						end
						vim.cmd("cd " .. vim.fn.fnameescape(current_dir))
					end,
				})
			end,
		})
	end)
end

function M.git_push()
	local root_dir = M.get_root_dir()
	local current_dir = vim.fn.getcwd()

	-- Change to root directory
	vim.cmd("cd " .. vim.fn.fnameescape(root_dir))

	-- Collect stdout for error checking
	local output = {}
	local stderr = {}

	-- Push changes
	local push_job = vim.fn.jobstart({ "git", "push" }, {
		on_stdout = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(output, line)
					end
				end
			end
		end,
		on_stderr = function(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(stderr, line)
					end
				end
			end
		end,
		on_exit = function(_, exit_code)
			-- Change back to original directory first
			vim.cmd("cd " .. vim.fn.fnameescape(current_dir))

			-- If we have stderr output, it might be an error
			if #stderr > 0 then
				-- Check if it's actually an error or just git's progress messages
				local is_error = false
				for _, line in ipairs(stderr) do
					-- Git sends progress to stderr, check for actual error indicators
					if line:match("^error: ") or line:match("^fatal: ") then
						is_error = true
						break
					end
				end

				if is_error then
					vim.notify("Failed to push changes:\n" .. table.concat(stderr, "\n"), vim.log.levels.ERROR)
					return
				end
			end

			-- If we get here, it was successful
			vim.notify("Changes pushed successfully", vim.log.levels.INFO)
		end,
	})
end

function M.git_status()
	local root_dir = M.get_root_dir()
	local current_dir = vim.fn.getcwd()

	-- Change to root directory
	vim.cmd("cd " .. vim.fn.fnameescape(root_dir))

	-- Create buffer for status
	local buf, win = M.create_float("Git Status")

	-- Run git status
	vim.fn.jobstart({ "git", "status" }, {
		on_stdout = function(_, data)
			if data then
				vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
			end
		end,
		on_exit = function()
			vim.cmd("cd " .. vim.fn.fnameescape(current_dir))
			-- Make buffer read-only
			vim.bo[buf].modifiable = false
			-- Add 'q' mapping to close the window
			vim.keymap.set("n", "q", function()
				vim.api.nvim_win_close(win, true)
			end, { buffer = buf })
		end,
	})
end

return M
