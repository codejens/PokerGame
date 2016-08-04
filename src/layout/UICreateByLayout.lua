--UICreateByLayout.lua
----山海经ui编辑器配置文件加载

-- 返回一个table 包含所有控件 result["root"]是根节点
function UICreateByLayout( win_self)
	-- require ("../data/uieidtor/"..file_name)
	loadLayout(win_self.layout)
	-- local result = {}
	_UICreateByLayout(_G[win_self.layout],win_self)
	-- return result
end

function _UICreateByLayout( layout,win_self,auto_load_name)
	local node = nil
	-- print("layout.name,auto_load_name=",layout.name,auto_load_name)
	if layout.auto_load == 0 or layout.auto_load =="0" then
	    if layout.name == auto_load_name then
	    	node = _UICreateMethod(layout,win_self)
	    end     
	else
		node = _UICreateMethod(layout,win_self)
	end
	return node
end

--[[
旧的
local _create_class = 
{
	SButton,SPanel,SLabel,SImage,SEditBox,STextButton,STextArea,SScroll,
	SRadioButtonGroup,SRadioButton,SSlotItem,SProgress,SSwitchBtn,SSwitchBtnNew,SDragBar,STouchPanel,
}

--]]
local new_controll_class = {
	["SButton"] = "GUIButton",
	["SPanel"] = "GUIPanel",
	["SLabel"] = "GUIText",
	["SImage"] = "GUIImg",
	["SEditBox"] = "GUITextField",
	["STextButton"] = "GUIButton",
	["STextArea"] = "GUIRichText",
	["SScroll"] = "GUINode",
	["SRadioButtonGroup"] = "GUINode",
	["SRadioButton"] = "GUINode",
	["SSlotItem"] = "GUINode",
	["SProgress"] = "GUINode",
	["SSwitchBtn"] = "GUINode",
	["SSwitchBtnNew"] = "GUINode",
	["STouchPanel"] = "GUINode",
}
function ChangeControllName(controll_name)
	-- print("controll_name=",controll_name)
	local new_name = new_controll_class[controll_name]
	if new_name == nil then 
		-- print("该控件尚未实现controll_name=",controll_name)
		return controll_name
	end
	return new_name
end


function _UICreateMethod( layout,win_self)
		layout.class = ChangeControllName(layout.class)
		local node  = _G[layout.class]:create_by_layout(layout)
		--root保存根节点
		if not win_self["root"] then
			win_self["root"] = node
			--node:setName("root") -- 设置控件名：识别控件用 @2015-08-05 by chj
		end
		win_self[layout.name] = node
		-- print( "UICreateByLayout", string.format("%20s", layout.name), string.format("%20s", layout.class) )
		-- 设置控件名：识别控件用 @2015-08-05 by chj 
		--node:setName(layout.name)
		if layout.child then
			for i=1,#layout.child do
				local child = _UICreateByLayout( layout.child[i],win_self )				
				node:addChild(child,layout.child[i].zOrder or 0)
				-- print("addChild name=",layout.child[i].name)
			end
		end
		return node
end


----------------------------寻找并重加载初始化未添加的控件--------------------------------
function UICreateLayoutByName(result,layout,node_name)
	require ("../data/uieidtor/"..layout)
	local _result = result
	_UICreateLayoutByName(_G[layout],_result,node_name)
	return _result
end

function _UICreateLayoutByName( layout,result,auto_load_name)
  --寻找node_name控件
	_UIFindByLayout(layout,result,auto_load_name)

end

function  _UIFindByLayout(layout,result,auto_load_name)
			if layout.child then
			for i=1,#layout.child do  --递归查找
				    if layout.name == auto_load_name then
				    	--找到初始化未加载控件
				            if result[layout.parent] then  --找到控件并父类已经存在
				            	local node  = _UICreateMethod(layout,result)
				            	result[layout.parent]:addChild(node,layout.zOrder or 0)
			                end
			               return true
				    else
				    	 _UIFindByLayout(layout.child[i],result,auto_load_name)
				    end  
			end
			return false
		end
end


----------------------------寻找并重加载初始化未添加的控件--------------------------------