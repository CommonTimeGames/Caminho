require('dialogue')

local d = Dialogue:new()

d:add{name="a", text="First", next="b", start=true}
d:add{name="b", text="Second", next="c"}
d:add{name="c", text="Third"}

d:add{package="second", name="a", text="Second:First", next="b", start=true}
d:add{package="second", name="b", text="Second:Second", next="c"}
d:add{package="second", name="c", text="Second:Third"}

return d