require("dialogue")

local d = Dialogue:new()

d:add {id = "a", text = "First", next = "b", start = true}
d:add {id = "b", text = "Second", next = "c"}
d:add {id = "c", text = "Third"}

d:add {name = "second", id = "a", text = "Second:First", next = "b", start = true}
d:add {name = "second", id = "b", text = "Second:Second", next = "c"}
d:add {name = "second", id = "c", text = "Second:Third"}

d:seq {
  name = "third",
  start = true,
  id = "test",
  {text = "Sequence1"},
  {text = "Sequence2"},
  {text = "Sequence3"}
}

d:add {name = "fourth", id = "a", text = "First", next = "b", start = true}
d:add {name = "fourth", id = "b", key = "fourth.key", next = "c"}
d:add {name = "fourth", id = "c", text = "textFunc"}

d.fourth.textFunc = function(d)
  return "FunctionText"
end

return d
