require('util')

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

-- EventNode
EventNode = Node:new{type = "event"}

-- ErrorNode
ErrorNode = Node:new{type="error"}

-- Dialogue 
Dialogue = {}

function Dialogue:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Dialogue:getNode(arg)
    
    if arg.node then
        return node
    
    elseif arg.choices then
        return ChoiceNode:new{
            text=arg.text,
            key=arg.key,
            choices=map(function(n) return TextNode:new(n) end, arg.choices)
        }

    elseif arg.event then
        return EventNode:new{event=arg.event, data=arg.data}

    elseif arg.wait then
        return WaitNode:new{wait=arg.wait}

    elseif arg.text or arg.key then
        return TextNode:new{text=arg.text, key=arg.key}

    end

end

function Dialogue:add(arg)

    assert(arg, "Dialogue:add(): Missing argument!")
    assert(arg.name, "Dialogue:add(): Missing node name!")

    local node = self:getNode(arg)
    assert(node, "Dialogue:add(): Could not find or deduce a valid node!")

    local target = arg.package or "default"
    self[target] = self[target] or {}
    
    node.next = arg.next

    self[target][arg.name] = node

    if arg.start then
        self[target].start = arg.name
    end

end

function Dialogue:func(arg, func)

    assert(arg, "Dialogue:func(): Missing first argument!")
    assert(arg.name, "Dialogue:add(): Missing node name!")
    assert(func and type(func) == "function",
         "Dialogue:func(): func must be callable")

    local target = arg.package or "default"
    self[target] = self[target] or {}

    local funcName = arg.name .. "_func"
    self[target][funcName] = func

    local node = FunctionNode:new{func=funcName, next=arg.next}
    self[target][arg.name] = node

end


