-- NotificationCenter.lua
-- created by fjh on 2013-1-5

super_class.NotificationCenter()

local notificationTable = nil;
local drag_object 	= nil;  --拖拽物件的表
local drag_end_count = 0;

local has_click_slotItem = false;	--是否点击了slotItem
local has_click_backGround = false;	--是否点击了空地

local target_win = nil;		--拖动到目标窗口

---------------------
--drag_obj.type类型:1=item，2=skill，3=pet, 4=xianhun
---------------------

function NotificationCenter:registDragObject(drag_obj ,point_x,point_y)	

	drag_object = drag_obj;
	
	require "UI/UIManager"
	local icon = NotificationCenter:get_icon()
	

	UIManager:create_drag_item(icon,point_x,point_y);
	
end

--检查是否有注册拖拽对象
function NotificationCenter:checkRegistDragObject()
	return drag_object;
end

--销毁拖拽对象
function NotificationCenter:destoryDragObject( )
	require "UI/UIManager"
	----print("NotificationCenter destoryDragObject");
	--销毁拖拽图标
	UIManager:destory_drag_item();
	drag_object = nil;
	has_click_slotItem = false;
	has_click_backGround = false;

end

--拖拽进了非法区域
function NotificationCenter:drag_invalid( )
	if drag_object.dragInvalid_callback ~= nil then
		--通知拖拽对象
		local callback_func = drag_object.dragInvalid_callback;
		callback_func(drag_object);
	else
		local icon = self:get_icon()

		drag_object:set_icon_texture(icon)
	end
end
--拖拽进格子成功
function NotificationCenter:darg_succ_callback()
	if drag_object.dragIn_callback ~= nil then
		--通知拖拽对象
		local callback_func = drag_object.dragIn_callback;
		callback_func(target_win);
	end
end
--丢弃格子成功(放置到空地上)
function NotificationCenter:darg_to_background( )
	if drag_object.discard_item_callback ~= nil then
		
		local callback_func = drag_object.discard_item_callback;
		callback_func(drag_object);
	end
end

--检查拖到哪里去了
function NotificationCenter:check_hit_where( )
	--拖拽入了格子
	if has_click_slotItem == true and has_click_backGround == false then 
		NotificationCenter:darg_succ_callback();
	--拖拽到了空地
	elseif has_click_backGround == true and has_click_slotItem == false then
		----print("拖拽到了空地");
		NotificationCenter:darg_to_background();
	--拖拽到了非法区域
	elseif has_click_slotItem == false and has_click_backGround == false then
		----print("拖拽到了非法区域");
		NotificationCenter:drag_invalid();
	end
	
end

--点击了slotItem
function NotificationCenter:click_slotItem( win )
	if has_click_slotItem == false then
		target_win = win;
		has_click_slotItem = true;
		has_click_backGround = false;
	end
end

--点击了空地
function NotificationCenter:click_backGround( )
	if has_click_backGround == false then
		has_click_backGround = true;
		has_click_slotItem = false;
	end
end

function NotificationCenter:get_icon()
	local icon = nil
	if drag_object.type == 1 then --item
		require "config/ItemConfig"
		icon = ItemConfig:get_item_icon(drag_object.obj_data.item_id) --item的icon
	elseif drag_object.type == 2 then -- skill
		icon = SkillConfig:get_skill_icon(drag_object.obj_data.id) -- 技能的icon
	elseif drag_object.type == 3 then -- partner
		icon = PartnerConfig:get_icon_config( drag_object.obj_data)	-- 伙伴头像(not use @2015-10-9)
	elseif drag_object.type == 4 then
		icon = FabaoConfig:get_xianhun_icon( drag_object.obj_data )	--仙魂icon
	elseif drag_object.type == 5 then
		icon = PartnerConfig:get_skill_icon_config( drag_object.obj_data) -- 伙伴技能的icon
	end
	return icon
end


