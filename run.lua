require('session')

if #arg < 1 then
    print("Usage: lua luatalk.lua <dialog> <package>")
    return
end

sample = require(arg[1])
context = {}

package = arg[2] or "default"

print("Loaded dialog '" .. arg[1] .. "'")

s = Session:new(sample[package], context)
s:Start()

while coroutine.status(s.co) ~= "dead" do
    if s.current.type == "text" then
        print("Text: " .. s.current:GetText(s))
        print("Press ENTER to continue...")
        io.read()
        s:Continue()

    elseif s.current.type == "choice" then
        print("Choice: " .. s.current:GetText(s))

        for i=1, #s.current.choices do
            print(i .. ") " .. s.current.choices[i]:GetText(s))
        end

        print("Type a choice, then press ENTER to continue...")

        local c = io.read()
        s:Continue(c)

    elseif(s.current.type == "function") then
        print("Calling Function Node...")
        s:Continue()

    elseif(s.current.type == "wait") then
        print("Wait node: " .. d.current.time)
        s:Continue()

    elseif s.current.type then
        print("*** ERROR: Don't know this node type: " .. s.current.type)
        break
    end
end

print("Complete!")
