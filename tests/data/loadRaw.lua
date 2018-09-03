require("dialogue")

local d = Dialogue:new()

d:add {id = "a", text = "Raw-First", next = "b", start = true}
d:add {id = "b", text = "Raw-Second", next = "c"}
d:add {id = "c", text = "Raw-Third"}

return d
