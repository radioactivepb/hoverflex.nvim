local M = {}

local utils = require("hoverflex.utils")

M._dynamic_called = false
M._dynamic_augroup = nil

M._dynamic_bufnr = nil
M._dynamic_winnr = nil

M._dynamic_destroy = function()
	if M._dynamic_bufnr and vim.api.nvim_buf_is_valid(M._dynamic_bufnr) then
		vim.api.nvim_buf_delete(M._dynamic_bufnr, { force = true })
	end
	M._dynamic_bufnr = nil
	M._dynamic_winnr = nil
end

M._dynamic_update = function()
	if not M._dynamic_winnr or not vim.api.nvim_win_is_valid(M._dynamic_winnr) then
		M._dynamic_destroy()
		return
	end

	local hover_name = vim.fn.expand("<cword>")
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local line_count = vim.api.nvim_buf_line_count(bufnr)
	local current_line = vim.api.nvim_buf_get_lines(bufnr, cursor_pos[1] - 1, cursor_pos[1], false)[1] or ""
	if cursor_pos[1] < 1 or cursor_pos[1] > line_count or cursor_pos[2] < 0 or cursor_pos[2] > #current_line then
		return
	end


	vim.lsp.buf_request(0, "textDocument/hover", vim.lsp.util.make_position_params(), function(err, result)
		if err or not result or not result.contents then
			return
		end
		local lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
		vim.api.nvim_set_option_value("modifiable", true, { buf = M._dynamic_bufnr })
		vim.api.nvim_buf_set_name(M._dynamic_bufnr, hover_name)
		vim.api.nvim_buf_set_var(M._dynamic_bufnr, "hoverflex.nvim", true)
		vim.api.nvim_buf_set_lines(M._dynamic_bufnr, 0, -1, false, lines)
		vim.api.nvim_set_option_value("modifiable", false, { buf = M._dynamic_bufnr })
	end)
end

M._dynamic_create = function(hover_type, stay_focused)
	if M._dynamic_winnr and vim.api.nvim_win_is_valid(M._dynamic_winnr) then
		M._dynamic_destroy()
		return
	end

	local current = utils._get_current()
	local hover_name = vim.fn.expand("<cword>")
	utils._close(vim.fn.bufnr(hover_name))
	utils._set_current(current)

	M._dynamic_bufnr = vim.api.nvim_create_buf(false, true)

	if hover_type == "vsplit" then
		vim.cmd("vsplit")
	elseif hover_type == "hsplit" then
		vim.cmd("split")
	end

	M._dynamic_winnr = vim.api.nvim_get_current_win()

	vim.api.nvim_set_current_buf(M._dynamic_bufnr)

	vim.api.nvim_buf_set_name(M._dynamic_bufnr, hover_name)
	vim.api.nvim_set_option_value("modifiable", false, { buf = M._dynamic_bufnr })
	vim.api.nvim_set_option_value("filetype", "markdown", { buf = M._dynamic_bufnr })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = M._dynamic_bufnr })
	vim.api.nvim_buf_set_var(M._dynamic_bufnr, "hoverflex.nvim", true)
	vim.api.nvim_buf_set_var(M._dynamic_bufnr, "hoverflex.dynamic", true)

	vim.schedule(function()
		vim.api.nvim_set_current_win(current.win)
		M._dynamic_update()
		vim.api.nvim_set_current_win(M._dynamic_winnr)
		if stay_focused then
			vim.api.nvim_set_current_win(current.win)
		end
	end)
end

M._dynamic_setup = function()
	if M._dynamic_called then
		return
	else
		M._dynamic_called = true
	end
	M._dynamic_augroup = vim.api.nvim_create_augroup("hoverflex.nvim", { clear = true })
	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		pattern = "*",
		callback = function()
			M._dynamic_update()
		end,
	})
end

return M
