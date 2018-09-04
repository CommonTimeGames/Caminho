require("dialogue")

local d = Dialogue:new()

d:seq {
  start = true,
  id = "test",
  next = "testFunc",
  {text = "This is a sample dialogue"},
  {text = "This is some more interesting text"},
  {text = "This conversation is over!"}
}

-- Second Dialogue - Choice and Function nodes

d:add {
  start = true,
  name = "second",
  id = "choice",
  text = "What do you want to say?",
  choices = {
    {text = "Say Hello", next = "saidHello"},
    {text = "Say Goodbye", next = "saidGoodbye"}
  }
}

d:add {name = "second", id = "saidHello", text = "You said hello!", next = "f"}
d:add {name = "second", id = "saidGoodbye", text = "You said goodbye!", next = "f"}

d:func(
  {
    name = "second",
    id = "f",
    next = "complete"
  },
  function(d)
    print("testFunc() called!")
  end
)

d:add {name = "second", id = "complete", text = "And now it's complete!"}

-- Third Dialog

d:add {name = "third", id = "a", text = "And this is yet another dialogue", next = "b", start = true}
d:add {name = "third", id = "b", text = "Because we have so much to say", next = "c"}
d:add {name = "third", id = "c", text = "But not anymore"}

return d
