local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

local function get_struct_name()
	local row = vim.api.nvim_win_get_cursor(0)[1]
	for r = row, 1, -1 do
		local line = vim.api.nvim_buf_get_lines(0, r - 1, r, false)[1]
		local name = line:match("const%s+(%w+)%s*=")
		if name then
			return name
		end
	end
	return "Self"
end

return {
	-- struct with init
	-- trigger: "sinit"
	s(
		"sinit",
		fmt(
			[[
const {} = struct {{
    {}: {},

    pub fn init({}: {}) @This() {{
        return .{{
            .{} = {},
        }};
    }}
}};
  ]],
			{
				i(1, "MyStruct"),
				i(2, "field"),
				i(3, "type"),
				rep(2),
				rep(3), -- reuse field/type in fn params
				rep(2),
				rep(2), -- .field = field
			}
		)
	),

	-- error union return
	-- trigger: "errfn"
	s(
		"errfn",
		fmt(
			[[
fn {}({}: {}) !{} {{
    {}
}}
  ]],
			{ i(1, "name"), i(2, "arg"), i(3, "type"), i(4, "ReturnType"), i(5) }
		)
	),

	-- comptime block
	s(
		"ctime",
		fmt(
			[[
comptime {{
    {}
}}
  ]],
			{ i(1) }
		)
	),

	-- test block
	s(
		"test",
		fmt(
			[[
test "{}" {{
    {}
}}
  ]],
			{ i(1, "description"), i(2) }
		)
	),

	-- std.debug.print
	s(
		"pr",
		fmt(
			[[
std.debug.print("{}\n", .{{{}}});
  ]],
			{ i(1, "msg"), i(2) }
		)
	),
}
