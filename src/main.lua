
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("resourceTree/")
cc.FileUtils:getInstance():addSearchPath("binary/")

require "config"
require "my_cocos_init"
--require "cocos.init"
require 'layout.LayoutLoader'
require 'layout.UILoader'
require 'layout.UICreateByLayout'
require 'common.utils.logger'

--@debug_begin
require 'common.std.strict'
cc.Director:getInstance():setDisplayStats(true)
--@debug_end

require 'common.std.binder'

require 'common.utils.init'
require 'common.helpers.init'

require 'gamecore.appMarco'
require 'gamecore.application'
is_debug = true
is_no_server = true
--[[
	打印请统一使用print
	打印堆栈使用print_stack
]]

winSize = cc.Director:getInstance():getOpenGLView():getFrameSize()
print("main>>>>>>winSize",winSize.width,winSize.height)
local _print = print
function xprint( ... )
	_print('>>', ...)
	_print('>> stack top')
	for level = 3, math.huge do
		if not print_stack('  [x]>> ',level,_print) then break end
	end
	_print('>> stack bottom')
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



local _require = require
local LAYOUT_PATH = "layout.ue."
function loadLayout(szName)
	local filePath = string.format("%s%s",LAYOUT_PATH,szName);
	return _require(filePath)	
end

local function myrequire(szName)
	if package.loaded[szName]==nil then
		local s = _require(szName)
		return s
	end
end
require = myrequire





local function main()
	application:run()
	--require 'gamecore.test.test_timer'
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
