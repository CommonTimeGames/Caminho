require("dialogue")

local d = Dialogue:new()

d:add {id = "a", text = "Begin", next = "b", start = true}
d:add {id = "b", wait = 3, next = "c"}
d:add {id = "c", text = "Final"}

return d
