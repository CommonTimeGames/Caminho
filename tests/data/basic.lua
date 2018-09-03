require("dialogue")

local d = Dialogue:new()

d:add {id = "a", text = "First", next = "b", start = true}
d:add {id = "b", text = "Second", next = "c"}
d:add {id = "c", text = "Third"}

d:add {package = "second", id = "a", text = "Second:First", next = "b", start = true}
d:add {package = "second", id = "b", text = "Second:Second", next = "c"}
d:add {package = "second", id = "c", text = "Second:Third"}

d:seq {
  package = "third",
  start = true,
  id = "test",
  {text = "Sequence1"},
  {text = "Sequence2"},
  {text = "Sequence3"}
}

d:add {package = "fourth", id = "a", text = "First", next = "b", start = true}
d:add {package = "fourth", id = "b", key = "fourth.key", next = "c"}
d:add {package = "fourth", id = "c", text = "textFunc"}

d.fourth.textFunc = function(d)
  return "FunctionText"
end

return d
