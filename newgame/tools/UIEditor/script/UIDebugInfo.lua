------------------------------------------------
---------HJH 2013-6-25
---------
function print_ui_debug_info()
	print("run debug_info--------------------------------------------------------")
	local ui_root = UIManager:get_main_panel()
	local child_count = ui_root:getChildrenCount()
	-- local self_info = CCTextAnalyze:shareTextAnalyse():getItemInfo(ui_root)
	-- print("----------------------------------------------------")
	-- print(self_info)
	local cur_dep = 1
	for i = 0, child_count -1 do
		local cur_child = CCTextAnalyze:shareTextAnalyse():CoverToNode(ui_root, i) --temp_child:getObjectAtIndex(i)
		print_child_info(cur_child, cur_dep)
	end
end

function print_child_info(child, depth)
	local self_info = CCTextAnalyze:shareTextAnalyse():getItemInfo(child, depth)
	print("----------------------------------------------------")
	print(self_info)
	local child_count = child:getChildrenCount()
	for i = 0, child_count - 1 do
		local cur_child = CCTextAnalyze:shareTextAnalyse():CoverToNode(child, i)
		print_child_info(cur_child, depth + 1)
	end	
end