require("dialogue")

local d = Dialogue:new()

d:seq {
  start = true,
  id = "test",
  {func = "d.context.foo = 5"},
  {increment = "foo"},
  {increment = "foo"},
  {text = "Stop here."}
}

d:seq {
  start = true,
  name = "second",
  id = "test",
  {text = "Start here."},
  {func = "d.context.foo = 5"},
  {increment = "foo"},
  {increment = "foo"},
  {text = "Stop here."}
}

return d
