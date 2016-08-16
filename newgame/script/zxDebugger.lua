local _print = print
zxDebugger = { _debug_mode = true }

local _retain_checker = {}

-- if GetPlatform() ~= CC_PLATFORM_WIN32 then
	-- print = function(...) end
	-- _print = function(...) end
-- end

--·¢ËÍjsonÏûÏ¢µ½java
send_message_to_java = phone_getInfo

function print_zengsi(...)
	if false then
		_print("by [zengsi] <<<<",...)
	end
end

function _print_jens(...)
	if false then
		_print('by [jens] <<<<',...)
	end
end

function _print_xhd(...)
	if false then
		_print('by xiehande <<<<',...)
	end
end

function _print_chj(...)
	if false then
		_print('by [chj] <<<<',...)
	end
end

function reload(szName)
	local moduleInfo = nil
	if type(szName) == 'table' then
		moduleInfo = szName._NAME
	else
		moduleInfo = szName
	end

	if not moduleInfo then
		error('expected arg #1 string or table got ' .. type(moduleInfo))
	end

	if package.loaded[moduleInfo] == nil then
		-- --print('require module',moduleInfo)
	else
		-- --print('reload module',moduleInfo)
		package.loaded[moduleInfo] = nil
		collectgarbage()
	end
	require(moduleInfo)
end

function ZXLog(...)
	_print(...)
end

function lprint( ... )
	_print('>>', ...)
	print_stackprint_stack('  [l]>> ',3,_print)
end

function xprint( ... )
--@debug_begin
	_print('>>', ...)
	_print('>> stack top')
	for level = 3, math.huge do
		if not print_stack('  [x]>> ',level,_print) then break end
	end
	_print('>> stack bottom')
--@debug_end
end

function printcolor( ... )
	local arg = {...}
	local color = tonumber(arg[#arg])
	if color then
		print(1024+color,...)
	else
		print(...)
	end
end

--print = xprint
function print_stack(prefix, level, func)
	local t = debug.getinfo(level,'Sln')
	
	if not t then return false end

	local debug_table = {}

	for k,v in pairs(t) do
	   if v and k == 'name' or k == 'currentline' or k =='short_src' then
		  	debug_table[#debug_table + 1] = string.format('%s=%s',tostring(k),tostring(v))
	   end
	end

	func(string.format('%s: {%s}',prefix,table.concat(debug_table,' ')))
	return true
end

function debug_c_callhook()

	local t = debug.getinfo(2,'S')
	if t and t.what == 'C' then
		print_stack('>',3,_print)

		for level = 4, math.huge do
			if not print_stack('>',level,_print) then break end
		end
		_print('--------------------------')
	end
end

function debug_hook(state)
	if state then
		debug.sethook(debug_c_callhook,'c')
	else
		debug.sethook(nil,'c')
	end
end

function enable_weather(b)
	SceneEffectManager : enableWeather(b)
end

function enable_scene_anim( b )
	SceneEffectManager : enableEffectAnimation(b)
end

function enable_scene_par( b )
	SceneEffectManager : enableParticles(b)
end

function show_ui(b)
	SceneManager.UIRoot:setIsVisible(b)
end

function show_map(b)
	SceneManager.SceneNode:setIsVisible(b)
end

function show_entity(b)
	SceneManager.SceneEntityRoot:setIsVisible(b)
end

function show_flow(b)
	SceneManager.FlowTextRoot:setIsVisible(b)
end

function show_scene_effect(b)
	SceneManager.SceneEffectRoot:setIsVisible(b)
end

function dump_texture()
	CCTextureCache:sharedTextureCache():removeUnusedTextures()
	CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
end



local function _split(szFullString, szSeparator)  
    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    while true do  
       local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
       if not nFindLastIndex then  
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
        break  
       end  
       nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
       nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
       nSplitIndex = nSplitIndex + 1  
    end  
    return nSplitArray  
end 


local function _debugger(arg)
	ZXLuaUtils:DisconnectRemoteDebugger()
	ZXLuaUtils:SetRemoteDebuggerAddress(arg[2],tonumber(arg[3]))
	ZXLuaUtils:ConnectRemoteDebugger()
end

local _debugTouchLayer = nil
local _label = nil
local _clicks = 0
local lastClick = 0
local function _debugTouch(arg)
	if _debugTouchLayer and tonumber(arg) == 0 then
		_debugTouchLayer:removeFromParentAndCleanup(true)
		_debugTouchLayer = nil
	else
		local root = ZXLogicScene:sharedScene():getUINode()
		local layer = CCLayer:node()
		local cross = CCDebugLine:node()
		cross:setLineWidth(2.0)
		local _sp = CCSprite:spriteWithFile('nopack/black.png');
        _sp:setPosition(CCPointMake(0,0))
        _sp:setAnchorPoint(CCPointMake(0,0))
        _sp:setScaleX(100)
        _sp:setScaleY(50)
        
		_label = CCZXLabel:labelWithText(50,50,'');
		_label:addChild(_sp)
		layer:addChild(_label,-1)

	    local function ui_main_msg_fun(eventType,xx,yy)
	    	x = xx / GameScaleFactors.ui_scale_factor
	    	y = yy / GameScaleFactors.ui_scale_factor
	 		cross:setLine(0,CCPointMake(x-128,y),CCPointMake(x+128,y),ccc3(255,0,0))
			cross:setLine(1,CCPointMake(x,y-128),CCPointMake(x,y+128),ccc3(0,255,0))
			if eventType == 0 then
				local df = os.clock() - lastClick
				if df < 0.3 then
					_clicks = _clicks + 1
				else
					_clicks = 0
				end
				if _clicks >= 3 then
					require 'UIEditor/UIEditor'
					UIEditor:toggle()
				end
				lastClick = os.clock()
				_label:setText(string.format('%d %d',xx,yy))
			end

		end
		layer:setIsTouchEnabled(true)
		layer:registerScriptTouchHandler(ui_main_msg_fun, false, 0, false)
		layer:addChild(cross)
		root:addChild(layer,10000)
		_debugTouchLayer = layer
	end
end

local _debug_options = 
{
	['?debug'] = _debugger,
	['?touch'] = _debugTouch,
}

function zxDebugger.acceptCmd(msg)
	local com = _split(msg,' ')
	local f = _debug_options[com[1]]
	if f then
		f(com)
		MUtils:toast(msg,2048)
		return true
	end
	return false
end

function _debug_retain(view)
--@debug_begin
	local t = {}
	for level = 2, math.huge do
		local d = debug.getinfo(level,'Sln')
		if not d then
			break
		end
		t[#t+1] = d
	end
	_retain_checker[view] = t
--@debug_end
end

function _debug_release(view)
--@debug_begin
	_retain_checker[view] = nil
--@debug_end
end

function _debug_retain_check()
--@debug_begin
	--print('_debug_retain_check:')
	for k,v in pairs(_retain_checker) do
		for i, vv in ipairs(v) do
			--print(' ',vv.source, vv.currentline)
		end
		--print(' ','-------------------------')
	end
	if next(_retain_checker) ~= nil then
		CCMessageBox('CCObject Leaks in lua','CCObject leaks!')
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

function safe_remove( obj )
--@debug_begin
	_debug_release(obj)
--@debug_end
	obj:removeFromParentAndCleanup(true)
end

function safe_retain_check()
--@debug_begin
	_debug_retain_check()
--@debug_end
end

local _pdt = 0
--打印手机内存占用情况
function print_sys_info( dt )
--@debug_begin
	_pdt = _pdt + dt
	if _pdt > 10 then
		_pdt = 0
		local av = SystemInfo.getAvailableMemory()
		local th = SystemInfo.getThreshold()
		local use = SystemInfo.phone_getMemoryUsage()
		local tipmsg = string.format('剩余内存[%.2fmb],可用内存[%.2fmb]',av/1024.0,(av-th)/1024.0)
		-- print(tipmsg)
		-- print(string.format("当前占用[%.2fmb]",use/1024.3))
	end
--@debug_end
end