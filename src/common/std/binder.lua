--- Concatenate lists.
-- @param ... lists
-- @return <code>{l<sub>1</sub>[1], ...,
-- l<sub>1</sub>[#l<sub>1</sub>], ..., l<sub>n</sub>[1], ...,
-- l<sub>n</sub>[#l<sub>n</sub>]}</code>
local function concat (...)
  local r = {}
  for _, l in ipairs ({...}) do
    for _, v in ipairs (l) do
      table.insert (r, v)
    end
  end
  return r
end

--- Partially apply a function.
-- @param f function to apply partially
-- @param ... arguments to bind
-- @return function with ai already bound
function bind (f, ...)
  local fix = {...}
  return function (...)
           return f (unpack (concat (fix, {...})))
         end
end

--[[
function f3arg(a,b,c)
  print(a,b,c)
end

a = bind(f3arg,1,2,3)
a()


function tick( fixarg, dt)
  print('fix', fixarg, 'dt', dt)
end

b = bind(tick, "This is Fixed")
print(b)
b(0.1)
]]--


