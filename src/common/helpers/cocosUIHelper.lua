local ccui_helper = ccui.Helper
local ccs_GUIReader = ccs.GUIReader:getInstance()
local _quit_event_key = {}

cocosUIHelper = {}

function cocosUIHelper.init()
	-- body
	-- 监听退出事件
end

function cocosUIHelper.seekWidgetByName(root, name)
	-- body
	return ccui_helper:seekWidgetByName(root,name)
end

function cocosUIHelper.readUICSB(filename)
	return ccs_GUIReader:widgetFromBinaryFile(filename)
end

function cocosUIHelper.createUIComponent(filename,creator)
	local view = ccs_GUIReader:widgetFromBinaryFile(filename)
	return creator(view)
end

function cocosUIHelper.onAppQuit()
	print('cocosUIHelper.onAppQuit')
	ccs.GUIReader:destroyInstance()
end

function cocosUIHelper.creatUI(filename)
	return cc.CSLoader:createNode(filename)
end

-- 创建 stutio 导出的lua版布局文件 lyl
function cocosUIHelper.creatUI_lua(filename)
	local csLuaScene = require(filename).create()
    return csLuaScene
end