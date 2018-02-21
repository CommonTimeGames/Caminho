require('nodes')

local helloChoices =
{
  TextNode:new{text="Say Hello", next="saidHello"},
  TextNode:new{text="Say Goodbye", next="saidGoodbye"}
}

local data = 
{
  start="A",

  A=TextNode:new{text="Hello, World!", next="B"},
  B=ChoiceNode:new{text="What do you want to say?", choices=helloChoices},

  saidHello=TextNode:new{text="You said hello!", next="D"},
  saidGoodbye=TextNode:new{text="You said goodbye!", next="D"},
  
  D=TextNode:new{text="This conversation is over!", next="E"},
  E=FunctionNode:new{func="testFunc"},

  testFunc=function(d) 
    print("testFunc() called!")
  end
}

return data