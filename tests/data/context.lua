require("dialogue")

local d = Dialogue:new()

d:add {id = "a", set = "test", value = 5, next = "b", start = true}
d:add {id = "b", text = "Second", next = "c"}

d:add {package = "second", id = "a", set = "test", value = "foo", next = "b", start = true}
d:add {package = "second", id = "b", text = "Second", next = "c"}

d:add {package = "third", id = "a", set = "test", value = "5", next = "b", start = true}
d:add {package = "third", id = "b", increment = "test", next = "c"}
d:add {package = "third", id = "c", text = "Second"}

d:add {package = "fourth", id = "a", func = "d.context.test = 8", next = "b", start = true}
d:add {package = "fourth", id = "b", decrement = "test", next = "c"}
d:add {package = "fourth", id = "c", text = "Second"}

return d
