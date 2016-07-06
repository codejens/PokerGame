resourceHelper = {}
local res_helpers = helpers.ResourceHelpers
--不允许直接调用ResourceHelpers
res_helpers:loadImageSet("ui/common/ui_common1.imageset")
-- res_helpers:loadImageSet("ui/common/ui_common2.imageset")
-- res_helpers:loadImageSet("ui/Login/ui_login1.imageset")
helpers.ResourceHelpers = nil
--所有活动中的异步加载
local _async_handles = {}

local _trace = debug.traceback

local CFUNCTION = luaFunToCFunc.convert

local function _regAsyncHandle(h)
	if h ~= 0 then
		-- body
		local t = true
	--@debug_begin
	  	local t = _trace("",2)
	--@debug_end
		_async_handles[h] = t
	end
end

local function _unregAsyncHandle(h)
	print('_unregAsyncHandle', h)
	_async_handles[h] = nil
end

local function _createAsyncLoadOption(filename,customID,priority,callback)
	return res_helpers:getAsyncLoadOption(filename,customID,priority,CFUNCTION(callback))
end

res_helpers:listenAsyncFinish(CFUNCTION(_unregAsyncHandle))

function resourceHelper.init()

end

function resourceHelper.get()
	-- body
	return res_helpers
end

function resourceHelper.fini()
	print('异步调用退出检查')
	resourceHelper.check_alive()
end

function resourceHelper.check_alive()
--@debug_begin
	for k,v in pairs(_async_handles) do
		logWarn('%s',v)
		print(' ','-------------------------')
	end
	if next(_async_handles) ~= nil then
		logWarn('%s','异步资源加载调用完成的回调中，请调用 resourceHelper.unregAsyncHandle')
	end
--@debug_end	
end


function resourceHelper.loadDependency(file)
	res_helpers:loadDependency(file)
end


function resourceHelper.loadWWW(option,okFunc,errFunc,progressFunc)
	local function _okCallback(_customID)
		--_unregAsyncHandle(async_h)
		okFunc(_customID)
	end

	local function _errCallback(_customID, stage, curlCode1, curlCode2)
		--_unregAsyncHandle(async_h)
		errFunc(stage, _customID, stage, curlCode1, curlCode2)
	end


	
	local h = res_helpers:loadWWW(option,CFUNCTION(_okCallback),CFUNCTION(_errCallback),CFUNCTION(progressFunc))
	_regAsyncHandle(h)
	print('resourceHelper.loadWWW',h)
	return h
end

function resourceHelper.loadTextureAsync(frameName, customID, priority, luaFunction)
	local function _callback(ret, _customID)
		--_unregAsyncHandle(async_h)
		luaFunction(ret, _customID)
	end

	local option = _createAsyncLoadOption(frameName, customID, priority, _callback)
	local h = res_helpers:loadTextureAsync(option)
	_regAsyncHandle(h)
	print('resourceHelper.loadTextureAsync',frameName,h)
	return h
end


function resourceHelper.loadAnimationAsync(frameName, customID, priority, luaFunction)
	local function _callback(ret, _customID)
		--_unregAsyncHandle(async_h)
		luaFunction(ret, _customID)
	end
	local option = _createAsyncLoadOption(frameName, customID, priority, _callback)
	local h = res_helpers:loadAnimationAsync(option)
	_regAsyncHandle(h)
	print('resourceHelper.loadAnimationAsync',frameName,h)
	return h
end

function resourceHelper.loadCSBTextureAsync(filename,customID,priority, luaFunction)
	local function _callback(ret, _customID)
		--_unregAsyncHandle(async_h)
		luaFunction(ret, _customID)
	end
	local option = _createAsyncLoadOption(filename, customID, priority, _callback)
	local h = res_helpers:loadCSBTextureAsync(option)
	_regAsyncHandle(h)
	print('resourceHelper.loadCSBTextureAsync',filename,h)
	return h
end

function resourceHelper.decompressAsync(filename, progressThreshold, finishCallback, progressCallback)
	local h = res_helpers:decompressAsync(filename, progressThreshold, CFUNCTION(finishCallback), CFUNCTION(progressCallback))
	return h
end

function resourceHelper.cancelDownload(name)
	res_helpers:cancelDownload(name)
end

function resourceHelper.cancelLoadAsync( handle )
	-- body
	_unregAsyncHandle(handle)
	res_helpers:cancelLoadAsync(handle)
end

function resourceHelper.getAsyncLoadOption(filename,customID,priority,callback)
	return _createAsyncLoadOption(filename,customID,priority,callback)
end



function resourceHelper.loadCSB(filename,bWithTimeline,bCache)
	return res_helpers:loadCSB(filename,bWithTimeline,bCache)
end
