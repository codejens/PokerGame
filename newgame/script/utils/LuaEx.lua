-- LuaEx.lua
-- created by aXing on 2013-3-23
-- 添加lua保留字的扩展功能，包括：
-- require: 添加加载前和加载后的回调
-- reload:  添加重新加载模块的关键字

require 'AppMessages'

-------------------------------------------------
-- 重载require

local _require = require

-- add by chj @2015-3-2
local LAYOUT_PATH = "../data/layouts/"

function loadLayout(szName)
	local filePath = string.format("%s%s",LAYOUT_PATH,szName);
	return _require(filePath)	
end


function reloadScript(szName)
	package.loaded[szName] = nil
	collectgarbage();
	return _require(szName)
end

local function myrequire(szName)
	if package.loaded[szName]==nil then
		--AppMessages:before_require( szName )
		return _require(szName)
		--AppMessages:after_require( szName )
	end
end

require = myrequire

-- end 重载require
-------------------------------------------------

-------------------------------------------------
-- reload

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
	--AppMessages:reload_module( moduleInfo )
end

-- end reload
-------------------------------------------------