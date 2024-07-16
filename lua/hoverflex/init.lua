local M = {}

local hf = {
	s = require("hoverflex.static"),
	d = require("hoverflex.dynamic"),
	u = require("hoverflex.utils"),
}

M.tab = function()
	hf.s._hover("tab", false)
end

M.tab_stay = function()
	hf.s._hover("tab", true)
end

M.buffer = function()
	hf.s._hover("buffer", false)
end

M.buffer_stay = function()
	hf.s._hover("buffer", true)
end

M.vsplit = function()
	hf.s._hover("vsplit", false)
end

M.vsplit_stay = function()
	hf.s._hover("vsplit", true)
end

M.hsplit = function()
	hf.s._hover("hsplit", false)
end

M.hsplit_stay = function()
	hf.s._hover("hsplit", true)
end

M.hsplit_dynamic = function()
	hf.d._dynamic_setup()
	hf.d._dynamic_create("hsplit", false)
end

M.hsplit_dynamic_stay = function()
	hf.d._dynamic_setup()
	hf.d._dynamic_create("hsplit", true)
end

M.vsplit_dynamic = function()
	hf.d._dynamic_setup()
	hf.d._dynamic_create("vsplit", false)
end

M.vsplit_dynamic_stay = function()
	hf.d._dynamic_setup()
	hf.d._dynamic_create("vsplit", true)
end

M.close = function()
	hf.u._close()
end

M.close_all = function()
	hf.u._close_all()
end

M.setup = function(opts)
	local default_opts = {
		disable_default_keybinds = false,
		keybinds = {
			tab = "<leader>ht",
			tab_stay = "<leader>hT",
			buffer = "<leader>hb",
			buffer_stay = "<leader>hB",
			hsplit = "<leader>hs",
			hsplit_stay = "<leader>hS",
			hsplit_dynamic = "<leader>hds",
			hsplit_dynamic_stay = "<leader>hdS",
			vsplit = "<leader>hv",
			vsplit_stay = "<leader>hV",
			vsplit_dynamic = "<leader>hdv",
			vsplit_dynamic_stay = "<leader>hdV",
			close = "<leader>hq",
			close_all = "<leader>hQ",
		},
	}

	if opts.disable_default_keybinds then
		default_opts.keybinds = {}
	end

	opts = vim.tbl_deep_extend("force", default_opts, opts)

	if opts.keybinds == default_opts.keybinds then
		if package.loaded["which-key"] then
			if require("which-key").add then
				require("which-key").add({
					mode = { "n" },
					{ "<leader>h", group = "Hoverflex" },
					{ "<leader>h_", hidden = true },
					{ "<leader>hd", group = "Hoverflex Dyanmic" },
					{ "<leader>hd_", hidden = true },
				})
			end
		end
	end

	for f, keybind in pairs(opts.keybinds) do
		local func = M[tostring(f)]
		if func ~= nil then
			vim.keymap.set("n", keybind, func, { noremap = true, silent = true, desc = "HoverFlex: " .. f })
		end
	end
end

return M
