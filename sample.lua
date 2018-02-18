function testFunction(d, c)
    print("testFunction() called!")
end

local data = 
{
    start="A",
    A={type="text", text="Hello, World!", next="B"},
    B={type="text", text="This is a sample dialogue.", next="C"},
    C={type="choice", 
       text="What do you want to do?",
       choices={
           {text="Say Hello!", next="D"},
           {text="Say Goodbye!", next="E"}}},
    D={type="text", text="You said hello!", next="F"},
    E={type="text", text="You said goodbye!", next="F"},
    F={type="text", text="This conversation is over!", next="G"},
    G={type="function", func=testFunction}
}

return data