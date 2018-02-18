Dialogue = require('dialogue')
sample = require('sample')
context = {}

print("Starting dialogue...")

d = Dialogue:new(sample,context)
d:start()

while(coroutine.status(d.co) ~= "dead") do
    if d.current.type == "text" then
        print("Text: " .. d.current.text)
        print("Press ENTER to continue...")
        io.read()
        d:continue()

    elseif d.current.type == "choice" then
        print("Choice: " .. d.current.text)

        for i=1, #d.current.choices do
            print(i .. ") " .. d.current.choices[i].text)
        end

        print("Type a choice, then press ENTER to continue...")

        local c = io.read()
        d:continue(c)

    elseif(d.current.type == "function") then
        print("Calling Function Node...")
        d:continue()

    elseif(d.current.type == "wait") then
        print("Wait node: " .. d.current.time)
        d:continue()

    elseif d.current.type then
        print("*** ERROR: Don't know this node type: " .. d.current.type)
        break
    end
end

print("Finished dialogue!")
