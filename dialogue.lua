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
        self.current = self.data[self.current.next]
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