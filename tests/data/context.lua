require("dialogue")

local d = Dialogue:new()

d:add {id = "a", set = "test", value = 5, next = "b", start = true}
d:add {id = "b", text = "Second", next = "c"}

d:add {name = "second", id = "a", set = "test", value = "foo", next = "b", start = true}
d:add {name = "second", id = "b", text = "Second", next = "c"}

d:add {name = "third", id = "a", set = "test", value = "5", next = "b", start = true}
d:add {name = "third", id = "b", increment = "test", next = "c"}
d:add {name = "third", id = "c", text = "Second"}

d:add {name = "fourth", id = "a", func = "d.context.test = 8", next = "b", start = true}
d:add {name = "fourth", id = "b", decrement = "test", next = "c"}
d:add {name = "fourth", id = "c", text = "Second"}

return d
