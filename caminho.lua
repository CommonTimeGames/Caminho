require("queue")
require("dialogue")

Caminho = {}

function Caminho:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self

  o.loader = Caminho.Load
  o.loadDir = "."

  o.cacheEnabled = true
  o.cacheMaxSize = 10
  o.cache = Queue:new()

  o.autoAdvance = true

  o.status = "inactive"
  o.locale = "en"
  o.context = o.context or {}

  return o
end

function Caminho:Load(filename)
  local path = self.loadDir .. "/" .. filename
  local altPath = path .. ".lua"

  result = loadfile(path)

  if not result then 
    result = loadfile(altPath)
  end

  assert(result, "Caminho:Load(): Cannot find file " .. path .. " or " .. altPath)

  return result
  
end

function Caminho:Run()
  self.status = "active"

  while self.current.node do
    self.current.node:OnEnter(self.current)
    if self.autoAdvance and self.current.node.autoAdvance then
      self:Advance()
    else
      local n = coroutine.yield()
      self:Advance(n)
    end
  end

  self.current = nil
  self.status = "inactive"
end

function Caminho:Advance(n)
  if self.autoAdvance then
    repeat
      self.current.node = self.current.node:Next(self.current, n)
    until not self.current.node or not self.current.node.autoAdvance
  else
    self.current.node = self.current.node:Next(self.current, n)
  end
end

function Caminho:setError(err)
  self.status = "error"
  self.current = self.current or {}
  self.current.error = err
end

function Caminho:loadFromCache(name)
  if self.cache[name] then
    return self.cache[name]
  else
    local d = self:loader(name)

    if not d then
      return
    end

    while self.cache.size >= self.cacheMaxSize do
      self.cache:popRight()
    end

    self.cache:pushLeft(d, name)

    return d
  end
end

function Caminho:loadDialogue(arg)
  assert(self.loader, "Caminho:loadDialogue(): A valid dialogue loader must be provided!")
  if self.cacheEnabled then
    return self:loadFromCache(arg.package)
  else
    return self:loader(arg.package)
  end
end

function Caminho:Start(arg)
  assert(self, "Call Caminho:Start(), not Caminho.Start()!")
  assert(arg, "Caminho:Start(): Missing argument!")
  
  if arg.name and string.sub(arg.name, 1, 1) == "@" then
    resolved = Caminho.resolve(arg.name)
    arg.name = resolved.name
    arg.package = resolved.package
  end

  status, err =
    pcall(
    function()
      local d = nil

      arg.package = arg.package or "default"
      arg.name = arg.name or "default"

      if arg.data and type(arg.data) == "function" then
        arg.name = arg.name or "default"
        arg.package = "raw"
        d = arg.data
      else
        assert(arg.name, "Caminho:Start(): A valid dialogue name must be specified!")
        d = self:loadDialogue(arg)
      end

      assert(d, "Caminho:Start(): Cannot find package: " .. arg.package)

      d = d()

      assert(
        d and type(d) == "table",
        "Caminho:Start(): Package: " .. arg.package .. ", Dialogue: " .. arg.name .. " must return a table (see example files)!"
      )

      local dName = getDialogueName(arg)
      local data = d[dName]

      assert(data, "Package: " .. arg.package .. " is missing dialogue " .. dName .. "!")

      local startNode = data[arg.start] or data[data.__start]

      assert(
        startNode,
        "Package: " .. arg.package .. ", dialogue: " .. dName .. ": Unable to find start node " .. (arg.start or "start")
      )

      self.current = {
        name = arg.name,
        package = arg.package,
        data = data,
        context = self.context,
        node = startNode,
        co = coroutine.create(Caminho.Run)
      }

      coSuccess, coError = coroutine.resume(self.current.co, self)

      if not coSuccess then
        error(coError)
      end
    end
  )

  if not status then
    self:setError(err)
    error(err)
  end
end

function Caminho:Continue(val)
  assert(self, "Call Caminho:Continue(), not Caminho.Continue()!")
  assert(self.status == "active", "Caminho:Continue(): No dialogue is currently active.")
  status, err = coroutine.resume(self.current.co, val)

  if not status then
    self:setError(err)
    error(err)
  end
end

function Caminho:End()
  assert(self, "Call Caminho:End(), not Caminho.End()!")
  self.current = nil
  self.status = "inactive"
end

function Caminho.resolve(name)
  result = {}
  slashIndex = string.find(name, "/")

  if slashIndex then
    result.package = string.sub(name, 2, slashIndex - 1)
    result.name = string.sub(name, slashIndex + 1, string.len(name))
  else
    result.package = string.sub(name, 2, string.len(name))
  end

  if not result.package or string.len(result.package) < 1 then
    result.package = "default"
  end

  if not result.name or string.len(result.name) < 1 then
    result.name = "default"
  end

  return result
  
end