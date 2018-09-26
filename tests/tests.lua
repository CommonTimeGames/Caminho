package.path = package.path .. ";../?.lua"

require("caminho")

local test = require("u-test")
local c = nil

test.start_up = function()
  c = Caminho:new()
end

test.tear_down = function()
  c = nil
end

test.basic = function()
  c:Start {package = "data/basic.lua"}
  test.equal(c.current.node.text, "First")

  c:Continue()
  test.equal(c.current.node.text, "Second")

  c:Continue()
  test.equal(c.current.node.text, "Third")
end

test.status = function()
  c:Start {package = "data/basic.lua"}
  test.equal(c.status, "active")
  c:Continue()
  c:Continue()
  c:Continue()
  test.equal(c.status, "inactive")
end

test.package = function()
  c:Start {package = "data/basic.lua", name = "second"}
  test.equal(c.current.node.text, "Second:First")

  c:Continue()
  test.equal(c.current.node.text, "Second:Second")

  c:Continue()
  test.equal(c.current.node.text, "Second:Third")
end

test.sequence = function()
  c:Start {package = "data/basic.lua", name = "third"}
  test.equal(c.current.node.text, "Sequence1")

  c:Continue()
  test.equal(c.current.node.text, "Sequence2")

  c:Continue()
  test.equal(c.current.node.text, "Sequence3")
end

test.textNodes = function()
  c:Start {package = "data/basic.lua", name = "fourth"}
  test.equal(c.current.node.type, "text")
  test.equal(c.current.node.text, "First")

  c:Continue()
  test.equal(c.current.node.type, "text")
  test.equal(c.current.node.key, "fourth.key")
  test.equal(c.current.node.displayText, "fourth.key")

  c:Continue()
  test.equal(c.current.node.type, "text")
  test.equal(c.current.node.displayText, "FunctionText")
end

test.choiceNodes = function()
  c:Start {package = "data/choice.lua"}
  test.equal(c.current.node.type, "choice")
  test.equal(c.current.node.text, "What do you choose?")

  c:Continue(1)
  test.equal(c.current.node.type, "text")
  test.equal(c.current.node.text, "First Selected!")

  c:Start {package = "data/choice.lua"}
  c:Continue(2)
  test.equal(c.current.node.type, "text")
  test.equal(c.current.node.text, "Second Selected!")

  c:Start {package = "data/choice.lua"}
  c:Continue()
  test.equal(c.current.node.type, "text")
  test.equal(c.current.node.text, "First Selected!")
end

test.functionNodes = function()
  c:Start {package = "data/functions.lua"}
  test.equal(c.context.test, 3)

  c:Start {package = "data/functions.lua", name = "second"}
  test.equal(c.context.test, 4)

  c:Start {package = "data/functions.lua", name = "third"}
  test.equal(c.context.test, 5)
end

test.waitNode = function()
  c:Start {package = "data/wait.lua"}
  test.equal(c.current.node.text, "Begin")

  c:Continue()

  test.equal(c.current.node.type, "wait")

  c:Update(1)
  c:Update(1)
  c:Update(1)

  test.equal(c.current.node.text, "Final")
end


test.setNode = function()
  c:Start {package = "data/context.lua"}
  test.equal(c.current.node.text, "Second")
  test.equal(c.context.test, 5)

  c:Start {package = "data/context.lua", name = "second"}
  test.equal(c.current.node.text, "Second")
  test.equal(c.context.test, "foo")
end

test.incrementNode = function()
  c:Start {package = "data/context.lua", name = "third"}
  test.equal(c.current.node.text, "Second")
  test.equal(c.context.test, 6)
end

test.decrementNode = function()
  c:Start {package = "data/context.lua", name = "fourth"}
  test.equal(c.current.node.text, "Second")
  test.equal(c.context.test, 7)
end

test.autoAdvance = function()
  c:Start {package = "data/autoAdvance.lua"}
  test.equal(c.current.node.text, "Stop here.")
  test.equal(c.context.foo, 7)

  c:Start {package = "data/autoAdvance.lua", name = "second"}
  test.equal(c.current.node.text, "Start here.")
  c:Continue()
  test.equal(c.current.node.text, "Stop here.")
  test.equal(c.context.foo, 7)

  c.autoAdvance = false

  c:Start {package = "data/autoAdvance.lua", name = "second"}
  test.equal(c.current.node.text, "Start here.")

  c:Continue()
  test.equal(c.current.node.type, "function")

  c:Continue()
  test.equal(c.current.node.type, "increment")

  c:Continue()
  test.equal(c.current.node.type, "increment")

  c:Continue()
  test.equal(c.current.node.text, "Stop here.")
  test.equal(c.context.foo, 7)
end

test.loadRaw = function()
  local d = loadfile("data/loadRaw.lua")

  c:Start({data = d})
  test.equal(c.current.node.text, "Raw-First")

  c:Continue()
  test.equal(c.current.node.text, "Raw-Second")

  c:Continue()
  test.equal(c.current.node.text, "Raw-Third")
end

test.resolveNames = function()
  c.loadDir = "./data"
  c:Start({name = "@basic/second"})
  test.equal(c.current.node.text, "Second:First")

  c:Continue()
  test.equal(c.current.node.text, "Second:Second")

  c:Continue()
  test.equal(c.current.node.text, "Second:Third")
end

-- obtain total number of tests and numer of failed tests
local ntests, nfailed = test.result()

-- this code prints tests summary and invokes os.exit with 0 or 1
test.summary()
