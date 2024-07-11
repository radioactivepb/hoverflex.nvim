local M = {}

local utils = require("hoverflex.utils")

M._hover = function(hover_type, stay_focused)
	local params = vim.lsp.util.make_position_params()
	local current = utils._get_current()

	local handler = function(err, result)
		if err or not result or not result.contents then
			return
		end

		local contents = result.contents
		if type(contents) == "table" and contents.kind then
			contents = contents.value
		elseif type(contents) == "table" then
			contents = table.concat(contents, "\n")
		end

		local hfs_buf = vim.api.nvim_create_buf(true, true)
		vim.api.nvim_buf_set_lines(hfs_buf, 0, -1, false, vim.split(contents, "\n"))

		local hover_name = vim.fn.expand("<cword>")

		utils._close(vim.fn.bufnr(hover_name))
		utils._set_current(current)

		vim.api.nvim_buf_set_name(hfs_buf, hover_name)
		vim.api.nvim_set_option_value("modifiable", false, { buf = hfs_buf })
		vim.api.nvim_set_option_value("filetype", "markdown", { buf = hfs_buf })
		vim.api.nvim_buf_set_var(hfs_buf, "hoverflex.nvim", true)
		vim.api.nvim_buf_set_var(hfs_buf, "hoverflex.static", true)

		if hover_type == "tab" then
			vim.cmd("tabnew")
			local new_win = vim.api.nvim_get_current_win()
			vim.api.nvim_win_set_buf(new_win, hfs_buf)
		elseif hover_type == "buffer" then
			vim.api.nvim_set_current_buf(hfs_buf)
		elseif hover_type == "vsplit" then
			vim.cmd("vsplit")
			vim.api.nvim_set_current_buf(hfs_buf)
		elseif hover_type == "hsplit" then
			vim.cmd("split")
			vim.api.nvim_set_current_buf(hfs_buf)
		end

		if stay_focused then
			if hover_type == "tab" then
				vim.api.nvim_set_current_tabpage(current.tab)
			elseif hover_type == "buffer" then
				vim.api.nvim_set_current_buf(current.buf)
			elseif hover_type == "vsplit" or hover_type == "hsplit" then
				vim.api.nvim_set_current_win(current.win)
			end
		end
	end

	vim.lsp.buf_request(0, "textDocument/hover", params, handler)
end

return M
