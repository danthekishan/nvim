local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

return {
	-- struct with impl new()
	-- trigger: "snew"
	s(
		"snew",
		fmt(
			[[
struct {} {{
    {}: {},
}}

impl {} {{
    pub fn new({}: {}) -> Self {{
        Self {{ {}: {} }}
    }}
}}
  ]],
			{
				i(1, "MyStruct"),
				i(2, "field"),
				i(3, "Type"),
				rep(1),
				rep(2),
				rep(3),
				rep(2),
				rep(2),
			}
		)
	),

	-- impl block
	s(
		"impl",
		fmt(
			[[
impl {} {{
    {}
}}
  ]],
			{ i(1, "Type"), i(2) }
		)
	),

	-- Result return fn
	s(
		"rfn",
		fmt(
			[[
fn {}({}: {}) -> Result<{}, {}> {{
    {}
}}
  ]],
			{ i(1, "name"), i(2, "arg"), i(3, "type"), i(4, "Ok"), i(5, "Err"), i(6) }
		)
	),

	-- derive macro
	s(
		"der",
		fmt(
			[[
#[derive({})]
  ]],
			{ i(1, "Debug, Clone") }
		)
	),

	-- match block
	s(
		"mat",
		fmt(
			[[
match {} {{
    {} => {},
    _ => {},
}}
  ]],
			{ i(1, "expr"), i(2, "pattern"), i(3), i(4) }
		)
	),

	-- println!
	s(
		"pr",
		fmt(
			[[
println!("{}", {});
  ]],
			{ i(1, "{}"), i(2) }
		)
	),
}
