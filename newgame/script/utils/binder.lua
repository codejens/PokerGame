--binder.lua
--绑定帮助文件

--连接参数
local function concat(...)
  local r = {}
  for _,l in ipairs({...}) do
    for _,v in ipairs(l) do
      table.insert(r, v)
    end
  end
  return r
end

--绑定回调
function bind(f, ...)
  local fix = {...}
  return function (...)
    return f(unpack(concat (fix, {...})))
  end
end