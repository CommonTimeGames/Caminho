
Node = {id=0}

function Node:new(o)
    o = o or {}
	setmetatable(o, self)
    self.__index = self
    return o
end

function Node:next()
    if(type(self.next) == "table") then
        return self.next
    elseif(type(self.next) == "function") then
        return self.next()
    else
        return nil
    end
end

TextNode = Node:new{type = "text"}

function TextNode:new (o)
    o = o or {}
	setmetatable(o, self)
    self.__index = self
    return o
end

WaitNode = Node:new{type = "wait", time = 3}

function WaitNode:new (o)
    o = o or {}
	setmetatable(o, self)
    self.__index = self
    return o
end

FunctionNode = Node:new{type = "function", func=function(d,c) end}

function FunctionNode:new (o)
    o = o or {}
	setmetatable(o, self)
    self.__index = self
    return o
end

function FunctionNode:next()
	local result = self.func()
    return result or self.next
end
