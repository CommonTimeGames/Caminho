require('caminho')

if #arg < 1 then
    print("Usage: lua run.lua <dialog> [<package>]")
    return
end

dlg = arg[1]
pkg = arg[2] or "default"

c = Caminho:new()
c:Start{name=dlg, package=pkg}

print("Loaded dialog '" .. arg[1] .. "', package '" .. pkg .. "'")

while c.status == "active" do
    
    if c.current.node.type == "text" then
        print("[Text] " .. c.current.node:GetText(c.current))
        print("Press ENTER to continue...")
        io.read()
        c:Continue()

    elseif c.current.node.type == "choice" then
        print("[Choice] " .. c.current.node:GetText(c.current))

        for i=1, #c.current.node.choices do
            print(i .. ") " .. c.current.node.choices[i]:GetText(c.current))
        end

        print("Type a choice, then press ENTER to continue...")

        local v = io.read()
        c:Continue(v)

    elseif(c.current.node.type == "function") then
        print("[Function] ")
        c:Continue()

    elseif(c.current.node.type == "wait") then
        print("[Wait] " .. c.current.node.time)
        c:Continue()

    elseif c.current.node.type then
        print("*** ERROR: Don't know this node type: " .. c.current.node.type)
        c:End()
    end

end

print("Complete!")
