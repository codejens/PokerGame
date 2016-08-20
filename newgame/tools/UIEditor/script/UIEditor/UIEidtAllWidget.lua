--UIEidtAllWidget.lua

UIEidtAllWidget = {}

local panel = nil
local _scroll = nil
local is_show = false

local function update_scroll(name,utype)
	return UIEditModel:update_scroll(name,utype)
end 

function UIEidtAllWidget:show_windows()
	if not panel then
		panel = UIEidtAllWidget:create()
		local ui_root = UIManager:get_main_panel()
		ui_root:addChild(panel.view,9999)
	end
	is_show = not is_show
	panel:setIsVisible(is_show)
	if is_show then
		update_scroll("win_root",1)
		_scroll:update(#UIEditModel:get_child_date())
	end
end

function UIEidtAllWidget:create()
	local panel = SPanel:create("sui/common/panel9.png",200,550,true)
	panel.view:setPositionY((640-550)/2)

	local fpanel = SPanel:create("",100,40)
	fpanel:setPosition(100,515)
	panel:addChild(fpanel)
	local flabel = SLabel:create("win_root", 20, ALIGN_CENTER)
	fpanel:addChild(flabel)

	local function click_func()
		if update_scroll(flabel:getText(),2) then
			flabel:setText(UIEditModel:get_parent_name(flabel:getText()))
			_scroll:update(#UIEditModel:get_child_date())
		end
	end
	fpanel:set_click_func(click_func)

	local scroll = SScroll:create(180,500,"sui/common/frame.png",true)
	scroll:setPosition(10,10)
	panel:addChild(scroll)

	local function create_scroll(index)
		local _child_date = UIEditModel:get_child_date()
		-- print("__child_date",#_child_date)
		local fpanel = SPanel:create("",100,40)
		--panel:addChild(fpanel)
		local label =  SLabel:create(_child_date[index+1].name)
		label:setPosition(40,15)
		fpanel:addChild(label)
		local function click_func()
			local child = _child_date[index+1]
			if child then
				local flags = update_scroll(child.name,1)
				if flags then
					flabel:setText(child.name)
					_scroll:update(#UIEditModel:get_child_date())
				end
				UIEditModel:set_selected_by_name(child.name)
			end
		end
		fpanel:set_click_func(click_func)
		return fpanel.view
	end
	scroll:set_touch_func(SCROLL_CREATE_ITEM,create_scroll)

	update_scroll("win_root",1)
	scroll:update(#UIEditModel:get_child_date())

	_scroll = scroll
	return panel
end