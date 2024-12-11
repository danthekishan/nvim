local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local llm_snippets = {
	-- Complete LLM tool method
	s(
		"llmtool",
		fmt(
			[[
/**
 * {}
 * @call {}.{}
 * @agent {}
 * @param {{{}}} {} {}
 * @returns {{{}}} {}
 * @returnSchema schema {}|{}|{}
 */
{}function {}({}) {{
    {}
}}
            ]],
			{
				i(1, "Method description"),
				i(2, "group"),
				i(3, "method"),
				c(4, {
					t("Query-External-Agent"),
					t("Search-External-Agent"),
					t("Query-Internal-Financial-Agent"),
					t("Query-Internal-General-Agent"),
					t("Search-Internal-Documents-Agent"),
					t("Search-Internal-Knowledge-Agent"),
				}),
				i(5, "type"),
				i(6, "paramName"),
				i(7, "Parameter description"),
				i(8, "type"),
				i(9, "Return description"),
				i(10, "fieldName"),
				i(11, "type"),
				i(12, "description"),
				c(13, { t("async "), t("") }),
				rep(3), -- Reuse method name
				i(14, "params"),
				i(0), -- Final cursor position
			}
		)
	),

	-- Return schema only
	s(
		"retschema",
		fmt(
			[[
@returnSchema schema {}|{}|{}
            ]],
			{
				i(1, "fieldName"),
				c(2, {
					t("string"),
					t("number"),
					t("boolean"),
					t("array"),
					t("object"),
				}),
				i(3, "description"),
			}
		)
	),

	-- Multiple return fields schema
	s(
		"retfields",
		fmt(
			[[
@returnSchema schema {}|{}|{};{}|{}|{}
            ]],
			{
				i(1, "field1"),
				c(2, {
					t("string"),
					t("number"),
					t("boolean"),
					t("array"),
					t("object"),
				}),
				i(3, "description1"),
				i(4, "field2"),
				c(5, {
					t("string"),
					t("number"),
					t("boolean"),
					t("array"),
					t("object"),
				}),
				i(6, "description2"),
			}
		)
	),
}

-- Add snippets to JavaScript
ls.add_snippets("javascript", llm_snippets)
-- If you also want these in TypeScript
ls.add_snippets("typescript", llm_snippets)

-- Shared React snippets (for both JS and TS)
local react_snippets = {
	-- Component with Props
	s(
		"rfc",
		fmt(
			[[
        {}const {} = ({}: {}) => {{
          return (
            {}
          );
        }};
        
        export default {};
      ]],
			{
				c(1, {
					t(""),
					t("export "),
				}),
				i(2, "ComponentName"),
				i(3, "props"),
				c(4, {
					t("Props"),
					sn(nil, {
						t("{"),
						i(1, "propType"),
						t("}"),
					}),
				}),
				i(5, "<div></div>"),
				rep(2),
			}
		)
	),

	-- useEffect hook
	s(
		"rue",
		fmt(
			[[
        useEffect(() => {{
          {}
          {}
        }}, [{}]);
      ]],
			{
				i(1, "// effect"),
				c(2, {
					t(""),
					sn(nil, {
						t({ "return () => {", "  " }),
						i(1, "// cleanup"),
						t({ "", "}" }),
					}),
				}),
				i(3, ""),
			}
		)
	),

	-- useState hook
	s(
		"rus",
		fmt(
			[[
        const [{}, set{}] = useState{}<{}>({}); 
      ]],
			{
				i(1, "state"),
				f(function(args)
					return (args[1][1]:gsub("^%l", string.upper))
				end, { 1 }),
				c(2, { t(""), t("<>") }),
				i(3, "type"),
				i(4, "initialValue"),
			}
		)
	),

	-- useCallback hook
	s(
		"ruc",
		fmt(
			[[
        const {} = useCallback(({}) => {{
          {}
        }}, [{}]);
      ]],
			{
				i(1, "callback"),
				i(2, ""),
				i(3, "// callback body"),
				i(4, "dependencies"),
			}
		)
	),

	-- useMemo hook
	s(
		"rum",
		fmt(
			[[
        const {} = useMemo(() => {{
          {}
          return {};
        }}, [{}]);
      ]],
			{
				i(1, "memoized"),
				i(2, "// computation"),
				i(3, "result"),
				i(4, "dependencies"),
			}
		)
	),

	-- className div with children
	s(
		"div",
		fmt(
			[[
        <div className="{}">
          {}
        </div>
      ]],
			{
				i(1, ""),
				i(2, ""),
			}
		)
	),

	-- Handle input change
	s(
		"hic",
		fmt(
			[[
        const handle{}Change = (e: React.ChangeEvent<HTMLInputElement>) => {{
          set{}(e.target.value);
        }};
      ]],
			{
				i(1, "Input"),
				rep(1),
			}
		)
	),

	-- React form with submission
	s(
		"rform",
		fmt(
			[[
        const handle{}Submit = (e: React.FormEvent<HTMLFormElement>) => {{
          e.preventDefault();
          {}
        }};

        return (
          <form onSubmit={{handle{}Submit}} className="{}">
            {}
          </form>
        );
      ]],
			{
				i(1, "Form"),
				i(2, "// handle submission"),
				rep(1),
				i(3, ""),
				i(4, "<input />"),
			}
		)
	),

	-- Interface declaration
	s(
		"int",
		fmt(
			[[
        interface {} {{
          {}: {};
        }}
      ]],
			{
				i(1, "InterfaceName"),
				i(2, "property"),
				i(3, "type"),
			}
		)
	),

	-- Type declaration
	s(
		"typ",
		fmt(
			[[
        type {} = {{
          {}: {};
        }};
      ]],
			{
				i(1, "TypeName"),
				i(2, "property"),
				i(3, "type"),
			}
		)
	),
}

-- Add snippets to both JavaScript React and TypeScript React
ls.add_snippets("javascriptreact", react_snippets)
ls.add_snippets("typescriptreact", react_snippets)

-- TypeScript-specific snippets
ls.add_snippets("typescriptreact", {
	-- Generic component
	s(
		"rgc",
		fmt(
			[[
        {}const {}<{}> = ({{ {}, ...props }}: {}{}) => {{
          return (
            {}
          );
        }};
        
        export default {};
      ]],
			{
				c(1, {
					t(""),
					t("export "),
				}),
				i(2, "ComponentName"),
				i(3, "T"),
				i(4, "prop"),
				i(5, "Props"),
				c(6, {
					t(""),
					sn(nil, {
						t(" & "),
						i(1, "OtherProps"),
					}),
				}),
				i(7, "<div></div>"),
				rep(2),
			}
		)
	),
})
