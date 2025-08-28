-- ~/.config/nvim/lua/my_winbar.lua
local M = {}

function M.get()
	local buf = vim.api.nvim_get_current_buf()
	local bufname = vim.api.nvim_buf_get_name(buf)

	-- Skip for certain filetypes
	local filetype = vim.bo[buf].filetype
	if filetype == "help" or filetype == "terminal" or filetype == "NvimTree" or bufname == "" then
		return ""
	end

	-- Get filename with icon using mini.icons
	local filename = vim.fn.fnamemodify(bufname, ":t")
	if filename == "" then
		filename = "[No Name]"
	end

	-- Get file icon using mini.icons
	local has_mini_icons, mini_icons = pcall(require, "mini.icons")
	local icon = ""
	if has_mini_icons then
		local file_icon, icon_hl, _ = mini_icons.get("file", filename)
		if file_icon then
			icon = "%#" .. icon_hl .. "#" .. file_icon .. " %*"
		end
	end

	-- Check if modified
	local modified = vim.bo[buf].modified and "%#WinBarModified# ●%*" or ""

	-- Get diagnostics with better formatting
	local diagnostics = vim.diagnostic.get(buf)
	local error_count = 0
	local warn_count = 0
	local info_count = 0
	local hint_count = 0
	local highest_severity = nil

	for _, diagnostic in ipairs(diagnostics) do
		if diagnostic.severity == vim.diagnostic.severity.ERROR then
			error_count = error_count + 1
			highest_severity = "error"
		elseif diagnostic.severity == vim.diagnostic.severity.WARN then
			warn_count = warn_count + 1
			if highest_severity ~= "error" then
				highest_severity = "warn"
			end
		elseif diagnostic.severity == vim.diagnostic.severity.INFO then
			info_count = info_count + 1
			if not highest_severity or highest_severity == "hint" then
				highest_severity = "info"
			end
		elseif diagnostic.severity == vim.diagnostic.severity.HINT then
			hint_count = hint_count + 1
			if not highest_severity then
				highest_severity = "hint"
			end
		end
	end

	-- Choose filename highlight based on severity
	local filename_hl = "WinBarFilename"
	if highest_severity == "error" then
		filename_hl = "WinBarFilenameError"
	elseif highest_severity == "warn" then
		filename_hl = "WinBarFilenameWarn"
	elseif highest_severity == "info" then
		filename_hl = "WinBarFilenameInfo"
	elseif highest_severity == "hint" then
		filename_hl = "WinBarFilenameHint"
	end

	-- Build diagnostic string with colors
	local diag_str = ""
	if error_count > 0 then
		diag_str = diag_str .. "%#WinBarError# " .. error_count .. "%*"
	end
	if warn_count > 0 then
		diag_str = diag_str .. "%#WinBarWarn# " .. warn_count .. "%*"
	end
	if info_count > 0 then
		diag_str = diag_str .. "%#WinBarInfo# " .. info_count .. "%*"
	end
	if hint_count > 0 then
		diag_str = diag_str .. "%#WinBarHint# " .. hint_count .. "%*"
	end

	-- Add some padding and separators
	local separator = diag_str ~= "" and " │ " or ""

	return " " .. icon .. "%#" .. filename_hl .. "#" .. filename .. "%*" .. modified .. separator .. diag_str .. " "
end

-- Set up highlight groups
function M.setup_highlights()
	vim.api.nvim_set_hl(0, "WinBarFilename", { fg = "#abb2bf", bold = true })
	vim.api.nvim_set_hl(0, "WinBarFilenameError", { fg = "#e06c75", bold = true })
	vim.api.nvim_set_hl(0, "WinBarFilenameWarn", { fg = "#e5c07b", bold = true })
	vim.api.nvim_set_hl(0, "WinBarFilenameInfo", { fg = "#61afef", bold = true })
	vim.api.nvim_set_hl(0, "WinBarFilenameHint", { fg = "#56b6c2", bold = true })
	vim.api.nvim_set_hl(0, "WinBarModified", { fg = "#98be65", bold = true })
	vim.api.nvim_set_hl(0, "WinBarError", { fg = "#e06c75", bold = true })
	vim.api.nvim_set_hl(0, "WinBarWarn", { fg = "#e5c07b", bold = true })
	vim.api.nvim_set_hl(0, "WinBarInfo", { fg = "#61afef", bold = true })
	vim.api.nvim_set_hl(0, "WinBarHint", { fg = "#56b6c2", bold = true })
end

return M
