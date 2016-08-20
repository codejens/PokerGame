--UICreateByLayout.lua
----山海经ui编辑器配置文件加载

function UICreateByLayout( layout,result )

	local node  = _G[layout.class]:create_by_layout(layout)
	if not node then
		return
	end
	if not result then
		result = {}
		result["root"] = node
	end

	result[layout.name] = node

	if layout.child then
		for i=1,#layout.child do
			child = UIEditModel:create_by_layout( layout.child[i],result )
			node:addChild(child)
		end
	end
	return node,result
end

-- function FindSWidgetByName( root,name )
-- 	if root.layout.name == name then
-- 		return root
-- 	end

-- 	local childs = root.layout.child
-- 	if childs  then
-- 		for i=1,#childs do
-- 			return FindSWidgetByName( childs[i],name )
-- 		end
-- 	end
	
-- end