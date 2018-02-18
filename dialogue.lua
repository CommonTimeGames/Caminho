local Dialogue = {}

function Dialogue:new(d, c)
    o = {}
	setmetatable(o, self)
    self.__index = self
    o.data = d
    o.context = c
    return o
end

function Dialogue:run()
    assert(self.data.start, "data.start must not be nil!")
    self.current = self.data[self.data.start]

    while self.current do
        local n = coroutine.yield()

        if self.current.type == "function" then
            local ret = self.current.func()
            local next = ret or self.current.next
            self.current = self.data[next]

        elseif self.current.type == "choice" then
            if self.current.choices[tonumber(n)] then
                self.current = self.data[self.current.choices[tonumber(n)].next]
            end

        else
            self.current = self.data[self.current.next]
        end

    end
end

function Dialogue:start()
    self.co = coroutine.create(Dialogue.run)
    coroutine.resume(self.co, self)
end

function Dialogue:continue(val)
    coroutine.resume(self.co, val)
end

return Dialogue