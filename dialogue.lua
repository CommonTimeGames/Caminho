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
        
        if self.current.type == "choice" then

            if self.current.choices[tonumber(n)] then
                self.current = self.current:Next(self, n)
            end

        else
            self.current = self.current:Next(self)
        end

    end
end

function Dialogue:start()
    self.co = coroutine.create(Dialogue.run)
    coroutine.resume(self.co, self)
end

function Dialogue:continue(val)
    success, x = coroutine.resume(self.co, val)
    
    if not success then
        print(x)
    end

end

return Dialogue