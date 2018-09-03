require("dialogue")

local d = Dialogue:new()

ch = {
    {text = "First Choice", next = "firstSelected"},
    {text = "Second Choice", next = "secondSelected"}
}

d:add {
    id = "choice",
    text = "What do you choose?",
    choices = ch,
    start = true
}

d:add {id = "firstSelected", text = "First Selected!"}
d:add {id = "secondSelected", text = "Second Selected!"}

return d
