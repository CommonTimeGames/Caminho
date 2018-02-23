-- Main Caminho Runtime
-- By: Nigel Brady
-- lordtrilink@gmail.com

Caminho = {}

function Caminho:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  
  o.loader = Caminho.Load
  o.loadDir = "."
  o.status = "inactive"
  o.locale = "en"
  o.context = o.context or {}

  return o
end

function Caminho:Load(filename)
  local path = self.loadDir .. "/" .. filename
  return assert(loadfile(path))
end

function Caminho:Run()
  self.status = "active"
  
  while self.current.node do
    local n = coroutine.yield()
    self.current.node = self.current.node:Next(self.current, n)
  end

  self.current = nil
  self.status = "inactive"

end

function Caminho:setError(err)
  self.status = "error"
  self.current = self.current or {}
  self.current.error = err
end

function Caminho:Start(arg)
  status, err = pcall(function()
      assert(arg and arg.name, "Caminho:Start(): A valid dialogue name must be specified!")
      assert(self.loader, "Caminho:Start(): A valid dialogue loader must be provided!")
      
      d = self:loader(arg.name)

      assert(d, "Caminho:Start(): Cannot find dialogue: " .. arg.name)

      d = d()

      local package = arg.package or "default"
      local data = d[package]

      assert(data,
       "Dialogue: " .. arg.name .. " is missing package " .. package .. "!")

      local startNode = data[arg.start] or data[data.start]

      assert(startNode,
       "Dialogue: " .. arg.name .. ", package: " .. package ..
        ": Unable to find start node " .. (arg.start or "start"))

      self.current ={
        name=arg.name,
        package=arg.package,
        data=data,
        context=self.context,
        node=startNode,
        co=coroutine.create(Caminho.Run)
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
  assert(self.status == "active", "Caminho:Continue(): No dialogue is currently active.")
  status, err = coroutine.resume(self.current.co, val)
  
  if not status then
    self:setError(err)
    error(err)
  end

end

function Caminho:End()
  self.current = nil
  self.status = "inactive"
end
