function testFunction(d, c)
    print("testFunction() called!")
end

local data = 
{
    start="A",
    A={type="text", text="Hello, World!", next="B"},
    B={type="text", text="This is a sample dialogue.", next="C"},
    C={type="text", text="This conversation is over!", next="D"},
    D={type="function", func=testFunction}
}

return data