require('dialogue')

local d = Dialogue:new()

d:add{name="a", text="This is a sample dialogue", next="b", start=true}
d:add{name="b", text="This is some more interesting text", next="c"}
d:add{name="c", text="This conversation is over!"}



-- Second Dialogue - Choice and Function nodes

local c={
  {text="Say Hello", next="saidHello"},
  {text="Say Goodbye", next="saidGoodbye"} 
}

d:add{package="second", name="choice", text="What do you want to say?", choices=c, start=true}

d:add{package="second", name="saidHello", text="You said hello!", next="f"}
d:add{package="second", name="saidGoodbye", text="You said goodbye!", next="f"}

d:add{package="second", name="f", func="testFunc", next="complete"}
d:add{package="second", name="complete", text="And now it's complete"}

d.second.testFunc = function() print("testFunc() called!") end

-- Third Dialog

d:add{package="third", name="a", text="And this is yet another dialogue", next="b", start=true}
d:add{package="third", name="b", text="Because we have so much to say", next="c"}
d:add{package="third", name="c", text="But not anymore"}

return d