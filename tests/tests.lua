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

test.status = function ()
  c:Start{name="data/basic.lua"}
  test.equal(c.status, "active")
  c:Continue()
  c:Continue()
  c:Continue()
  test.equal(c.status, "inactive")
end

test.basic = function ()
  c:Start{name="data/basic.lua"}
  test.equal(c.current.node.text, "First")

  c:Continue()
  test.equal(c.current.node.text, "Second")

  c:Continue()
  test.equal(c.current.node.text, "Third")  
end

test.package = function()
  c:Start{name="data/basic.lua", package="second"}
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
