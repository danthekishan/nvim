local ls = require("luasnip")

-- custom snippets
ls.add_snippets("all", {
  -- available in any filetype
  ls.parser.parse_snippet("expand", "-- this is what was expanded"),
})

-- lua custom snippets
ls.add_snippets("lua", {
  -- available in any filetype
  ls.parser.parse_snippet("lf", "local $1 = function($2)\n  $0\nend"),
})

-- lua custom snippets
ls.add_snippets("javascriptreact", {
  -- available in any filetype
  ls.parser.parse_snippet("dv", "<div className=$1>\n  $2\n</div>$0"),
})

