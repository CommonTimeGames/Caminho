require('dialogue')

local d = Dialogue:new()

d:add{id="func",func=function(d) d.context.test = 3 end, start=true}

d.second = {}
d.second.test_func = function(d)
  d.context.test = 4
end

d:add{name="second", id="func", func="test", start=true}

d:add{name="third", id="func", func="d.context.test = 5", start=true}

return d