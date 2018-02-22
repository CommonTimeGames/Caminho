Session = {}

function Session:new(d, c)
    o = {}
	setmetatable(o, self)
    self.__index = self
    o.data = d
    o.context = c
    return o
end

function Session:Run(arg)
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

function Session:Start()
    self.co = coroutine.create(Session.Run)
    coroutine.resume(self.co, self)
end

function Session:Continue(val)

    if not self.co then
        error("Session:continue(): Call Session:Start() first!")
        return
    end

    success, x = coroutine.resume(self.co, val)
    
    if not success then
        error(x)
    end

end