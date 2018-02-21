Dialogue = require('dialogue')

if #arg < 1 then
    print("Usage: lua luatalk.lua <dialog>")
    return
end

sample = require(arg[1])
context = {}

print("Loaded dialog '" .. arg[1] .. "'")

d = Dialogue:new(sample,context)
d:start()

while coroutine.status(d.co) ~= "dead" do
    if d.current.type == "text" then
        print("Text: " .. d.current:GetText(d))
        print("Press ENTER to continue...")
        io.read()
        d:continue()

    elseif d.current.type == "choice" then
        print("Choice: " .. d.current:GetText(d))

        for i=1, #d.current.choices do
            print(i .. ") " .. d.current.choices[i]:GetText(d))
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

print("Complete!")
