Dialogue = require('dialogue')
sample = require('sample')
context = {}

print("Starting dialogue...")

d = Dialogue:new(sample,context)
d:start()

while(coroutine.status(d.co) ~= "dead") do
    if(d.current.type == "text") then
        print("Text: " .. d.current.text)
        io.read()
        d:continue()
    elseif(d.current.type == "function") then
        print("Function Node: ")
        d:continue()
    elseif(d.current.type == "wait") then
        print("Wait node: " .. d.current.time)
        d:continue()
    else
        print("Don't know this node type: ")
        break
    end
end

print("Finished dialogue!")
