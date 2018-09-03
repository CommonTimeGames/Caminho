require("dialogue")

local d = Dialogue:new()

d:add {name = "a", text = "Raw-First", next = "b", start = true}
d:add {name = "b", text = "Raw-Second", next = "c"}
d:add {name = "c", text = "Raw-Third"}

return d
