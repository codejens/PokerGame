--[[
 usage = 
 基础类
    base = simple_class()
 继承类
    inheri = simple_class(base)

 构造函数 __init会主动调用，继承类需要在__init主动调用基类构造

 function base:__init()
 end

 function inheri:__init()
    base.__init(self)
 end
]]--
--[[ 这个类是浅复制父类的方法，单向继承，
     使用这个类是因为luajit的检索深度过深会崩溃 ]]--
function simple_class(base)
   local c = {}    -- a new class instance
   if type(base) == 'table' then
    -- our new class is a shallow copy of the base class!
      for i,v in pairs(base) do
         c[i] = v
      end
      c._base = base
   end
   -- the class will be the metatable for all its objects,
   -- and they will look up their methods in it.
   c.__index = c

   -- expose a constructor which can be called by <classname>(<args>)
   local mt = {}
   mt.__call = function(class_tbl, ...)
   local obj = {}
   setmetatable(obj,c)
   obj:__init(...)
   return obj
   end

   c.is_a = function(self, klass)
      local m = getmetatable(self)
      while m do
         if m == klass then return true end
         m = m._base
      end
      return false
   end
   setmetatable(c, mt)
   return c
end


function isclass(class, object)
    local t = type(object)
    return t == 'table' and class.__classname == object.__classname
end