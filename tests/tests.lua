package.path = package.path .. ';../?.lua'

require('caminho')

local test = require('u-test')
local c = nil

test.start_up = function () 
  c = Caminho:new()
end

test.tear_down = function () 
  c = nil 
end

test.basic = function ()
  c:Start{name="data/basic.lua"}
  test.equal(c.current.node.text, "First")

  c:Continue()
  test.equal(c.current.node.text, "Second")

  c:Continue()
  test.equal(c.current.node.text, "Third")  
end

test.status = function ()
  c:Start{name="data/basic.lua"}
  test.equal(c.status, "active")
  c:Continue()
  c:Continue()
  c:Continue()
  test.equal(c.status, "inactive")
end

test.package = function()
  c:Start{name="data/basic.lua", package="second"}
  test.equal(c.current.node.text, "Second:First")

  c:Continue()
  test.equal(c.current.node.text, "Second:Second")

  c:Continue()
  test.equal(c.current.node.text, "Second:Third")
end

test.sequence = function()
  c:Start{name="data/basic.lua", package="third"}
  test.equal(c.current.node.text, "Sequence1")

  c:Continue()
  test.equal(c.current.node.text, "Sequence2")

  c:Continue()
  test.equal(c.current.node.text, "Sequence3")
end

test.textNodes =  function()
  c:Start{name="data/basic.lua", package="fourth"}
  test.equal(c.current.node.type, "text")
  test.equal(c.current.node.text, "First")

  c:Continue()
  test.equal(c.current.node.type, "text")
  test.equal(c.current.node.key, "fourth.key")
  test.equal(c.current.node.text, "fourth.key")

  c:Continue()
  test.equal(c.current.node.type, "text")
  test.equal(c.current.node.text, "FunctionText")
end

-- obtain total number of tests and numer of failed tests
local ntests, nfailed = test.result()

-- this code prints tests summary and invokes os.exit with 0 or 1
test.summary()
