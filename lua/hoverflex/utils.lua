local M = {}

M._close = function(buf)
	if buf == -1 then
		return
	end
	require("hoverflex.dynamic")._dynamic_destroy()
	local current_buf = buf or vim.api.nvim_get_current_buf()
	local success, _ = pcall(vim.api.nvim_buf_get_var, current_buf, "hoverflex.nvim")
	if success then
		vim.api.nvim_buf_delete(current_buf, { force = true })
	end
end

M._close_all = function()
	local current_buf = vim.api.nvim_get_current_buf()
	local current_win = vim.api.nvim_get_current_win()
	local current_tab = vim.api.nvim_get_current_tabpage()

	local bufs = vim.api.nvim_list_bufs()
	for _, buf in ipairs(bufs) do
		M._close(buf)
	end

	pcall(vim.api.nvim_set_current_tab, current_tab)
	pcall(vim.api.nvim_set_current_win, current_win)
	pcall(vim.api.nvim_set_current_buf, current_buf)
end

M._get_current = function()
	local current_buf = vim.api.nvim_get_current_buf()
	local current_win = vim.api.nvim_get_current_win()
	local current_tab = vim.api.nvim_get_current_tabpage()
	return {
		buf = current_buf,
		win = current_win,
		tab = current_tab,
	}
end

M._set_current = function(current)
	vim.api.nvim_set_current_tabpage(current.tab)
	vim.api.nvim_set_current_win(current.win)
	vim.api.nvim_set_current_buf(current.buf)
end

return M
