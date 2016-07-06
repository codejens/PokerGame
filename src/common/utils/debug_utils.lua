local _retain_checker = {}
local _trace = debug.traceback

function reload(szName)
  strict_if_strict( false )
  local moduleInfo = nil
  if type(szName) == 'table' then
    moduleInfo = szName._NAME
  else
    moduleInfo = szName
  end

  if not moduleInfo then
    error('expected arg #1 string or table got ' .. type(moduleInfo))
  end

  local _loaded = package.loaded
  if _loaded[moduleInfo] == nil then
    logInfo('require module',moduleInfo)
  else
    logInfo('reload module',moduleInfo)
    _loaded[moduleInfo] = nil
    collectgarbage()
  end
  require(moduleInfo)
  strict_if_strict( true )
end

local function _debug_retain(view)
--@debug_begin
	local t = _trace("",2)
	_retain_checker[view] = t
--@debug_end
end

local function _debug_release(view)
--@debug_begin
	_retain_checker[view] = nil
--@debug_end
end

local function _debug_retain_check()
--@debug_begin
	print('_debug_retain_check:')
	for k,v in pairs(_retain_checker) do
		logWarn('%s',v)
		print(' ','-------------------------')
	end
	if next(_retain_checker) ~= nil then
		print('Ref leaks!','Ref Leaks in lua')
		systemHelper.messageBox('Ref leaks!','Ref Leaks in lua')
	end
--@debug_end
end


function safe_retain(obj)
--@debug_begin
	_debug_retain(obj)
--@debug_end
	obj:retain()
end

function safe_release(obj)
--@debug_begin
	_debug_release(obj)
--@debug_end
	obj:release()
end

function safe_retain_check()
--@debug_begin
	_debug_retain_check()
--@debug_end
end

