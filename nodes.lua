-- Base Node class
Node = {}

function Node:new(o)
    o = o or {}
	setmetatable(o, self)
    self.__index = self
    return o
end

function Node:Next(d)
    if self.next then
        return d.data[self.next]
    end
end

-- TextNode 
TextNode = Node:new{type = "text"}

function TextNode:GetText(d)

    if self.key then

        -- TODO: Look up string for current locale 
        return key

    elseif type(d.data[self.text]) == "function" then

        -- If text points to a function in d.func, 
        -- then return the result of that call

        local ret = d.data[self.text](d)

        if ret and type(ret) == "string" then
            return ret
        else
            error("TextNode.GetText() function " .. self.text .. " must return a string!")
            return nil
        end

    elseif self.text and type(self.text) == "string" then
        -- If text property is a string, return that string
        return self.text
    end

end

-- WaitNode
WaitNode = Node:new{type = "wait", time = 3}

function WaitNode:Update(time)
    self.elapsed = self.elapsed or 0
    self.elapsed = self.elapsed + time
end

-- FunctionNode
FunctionNode = Node:new{type = "function"}

function FunctionNode:Next(d)
    
    -- FunctionNode must have property "func" defined;
    -- Then a function matching that name is searched for in
    -- the dialogue table. No globals function calls are allowed.

    if not self.func then
        error("FunctionNode: func property is missing!")
        return nil

    elseif not d.data[self.func] or type(d.data[self.func]) ~= "function" then
        error("FunctionNode: Missing function declaration " .. self.func)
        return nil
    end

    local ret = d.data[self.func](d)
        
    -- If function returns no value, then 
    -- attempt to use value self.next
    
    if not ret and self.next then
        return d.data[self.next]

    -- If function returns a table,
    -- this becomes the active node
    elseif ret and type(ret) == "table" then
        return ret

    -- Otherwise perform lookup to get
    -- the next node
    else
        return d.data[ret]

    end
end

-- ChoiceNode
ChoiceNode = TextNode:new{type = "choice"}

function ChoiceNode:Next(d, v)

    assert(self.choices and type(self.choices) == "table",
        "ChoiceNode.choices must be a table")

    v = tonumber(v) or 1

    return self.choices[v]:Next(d)

end

