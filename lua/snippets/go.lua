local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

return {
	-- struct with constructor
	-- trigger: "snew"
	s(
		"snew",
		fmt(
			[[
type {} struct {{
    {} {}
}}

func New{}({} {}) *{} {{
    return &{}{{
        {}: {},
    }}
}}
  ]],
			{
				i(1, "MyStruct"),
				i(2, "field"),
				i(3, "type"),
				rep(1),
				rep(2),
				rep(3),
				rep(1),
				rep(1),
				rep(2),
				rep(2),
			}
		)
	),

	-- interface
	s(
		"iface",
		fmt(
			[[
type {} interface {{
    {}
}}
  ]],
			{ i(1, "MyInterface"), i(2) }
		)
	),

	-- error check
	s(
		"ife",
		fmt(
			[[
if err != nil {{
    return {}err
}}
  ]],
			{ i(1) }
		)
	),

	-- goroutine
	s(
		"gor",
		fmt(
			[[
go func() {{
    {}
}}()
  ]],
			{ i(1) }
		)
	),

	-- channel
	s(
		"ch",
		fmt(
			[[
{} := make(chan {}, {})
  ]],
			{ i(1, "ch"), i(2, "type"), i(3, "1") }
		)
	),

	-- fmt.Println
	s(
		"pr",
		fmt(
			[[
fmt.Println({})
  ]],
			{ i(1) }
		)
	),
}
