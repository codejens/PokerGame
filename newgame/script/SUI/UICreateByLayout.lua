--UICreateByLayout.lua
----山海经ui编辑器配置文件加载

--延迟加载
local _delay_load = {
	-- fbresult_win = true,
}

-- 返回一个table 包含所有控件 result["root"]是根节点
function UICreateByLayout( file_name)
	local s = ZXLuaUtils:GetTickCounts()
	require ("../data/uieditor/"..file_name)
	
	local result = {}
	result.delay = 0
	_UICreateByLayout(_G[file_name],result,nil,_delay_load[file_name])
	return result
end

function _UICreateByLayout( layout,result,auto_load_name,is_delay)
	local node = nil
	if layout.auto_load == 0 or layout.auto_load =="0" then
	    if layout.name == auto_load_name then
	    	node = _UICreateMethod(layout,result,is_delay)
	    end     
	else
		node = _UICreateMethod(layout,result,is_delay)
	end
	return node
end


function _UICreateMethod( layout,result,is_delay)
		local node  = _G[layout.class]:create_by_layout(layout)
		--root保存根节点
		if not result["root"] then
			result["root"] = node
			--node:setName("root") -- 设置控件名：识别控件用 @2015-08-05 by chj
		end
		result[layout.name] = node
		-- ----print( "UICreateByLayout", string.format("%20s", layout.name), string.format("%20s", layout.class) )
		-- 设置控件名：识别控件用 @2015-08-05 by chj 
		--node:setName(layout.name)
		if layout.child then
			for i=1,#layout.child do
				if is_delay then
					local function delaycb( ... )
						result.delay = result.delay - 1
						child = _UICreateByLayout( layout.child[i],result,nil,is_delay )				
						node:addChild(child,layout.child[i].zOrder or 0)
					end
					new_call_back( result.delay*0.01,delaycb )
					result.delay = result.delay + 1
				else
					child = _UICreateByLayout( layout.child[i],result,nil,is_delay )				
					node:addChild(child,layout.child[i].zOrder or 0)
				end
			end
		end
		return node
end


----------------------------寻找并重加载初始化未添加的控件--------------------------------
function UICreateLayoutByName(result,layout,node_name)
	require ("../data/uieditor/"..layout)
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