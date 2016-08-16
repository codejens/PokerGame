--单挑 的双方玩家vs血条什么的界面

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight
local panelWidth =  _refWidth(1.0)
local panelHeight = _refHeight(1.0)


Dantiao = simple_class()

--[[
params
	my_name
	di_name

]]

function Dantiao:__init(params)
	self.params = params
	local w,h = 800, 100
	--local panel = SPanel:create( "nopack/xszy/zezhao1.png", w, h, true)
	local panel = SPanel:create( "", w, h, true)
	panel:setAnchorPoint(0.5,0.5)
	panel:setPosition(panelWidth/2, panelHeight -h/2 -20)
	self.panel = panel

	local vs = SImage:create( "sui/guild/vs.png")
	vs:setAnchorPoint(0.5, 0.5)
	vs:setPosition(w/2, h/2+10)
	vs:setScale(0.5)
	panel.view:addChild(vs.view)
	panel.view:registerScriptHandler(function () return false end)

	
	local mp = self:create_info(panel, params, true)
	mp:setPosition(0, h/2 -20)

	local dp = self:create_info(panel, params, false)
	dp:setPosition(600, h/2 -20)

	self:create_str_time()

	-- local root = ZXLogicScene:sharedScene():getUINode()
	-- 	--先删除 再添加 以免重复
	-- root:removeChildByTag(UI_TAG_SCREENMASK,true)
	-- root:addChild(panel.view, Z_ZORDER_GUIDE, UI_TAG_SCREENMASK)
end

function Dantiao:get_panel()
	return self.panel
end

function Dantiao:create_info(panel, params, isMy)
	--local tmp_panel = SPanel:create( "sui/mainUI/progress1.png", 200, 80, true)
	local tmp_panel = SPanel:create( "", 200, 80, true)
	tmp_panel.view:registerScriptHandler(function () return false end)
	panel.view:addChild(tmp_panel.view)

	-- local name_bg = SImage:create( "sui/mainUI/otherNameBg.png")
	-- tmp_panel.view:addChild(name_bg.view)

	local name = SLabel:create( isMy and params.my_name or params.di_name,16, not isMy and ALIGN_RIGHT)
	tmp_panel.view:addChild(name.view, 100)

	local head = false
	local job = params.di_job
	if isMy then
		job = params.my_job
	end
	-- local head = MUtils:create_head_grp_by_id(job, tmp_panel.view, 34.5, 58.5, 10086)
	-- head:setAnchorPoint(0.5, 0.5)
	local head_bg =  MUtils:create_zximg(tmp_panel.view, "sui/mainUI/roleGraphLayer.png", 34.5, 58.5, -1, -1, nil, nil, 10086)
	head_bg:setAnchorPoint(0.5, 0.5)
	local head_path = "sui/normal/head"..job..".png"
    local head = MUtils:create_sprite(head_bg, head_path, 41, 43)
    head:setScale(0.95)
    head:setAnchorPoint(CCPointMake(0.5, 0.5))
    local frame = MUtils:create_zximg(head_bg, "sui/mainUI/roleFrame.png", 0, 0, -1, -1, nil, nil, z)

	local level = SLabel:create( "#cb27339" .. (isMy and params.my_level or params.di_level),14,2)
	level:setPosition(19,8)
	frame:addChild(level.view)

	local blood_bg = SImage:create( "sui/mainUI/blood_bg.png")
	tmp_panel.view:addChild(blood_bg.view)
	local layout = {}
	layout.pos = {0,0}
	layout.size = {233,15}
	layout.img_s = "sui/mainUI/vs_blood_bg.png"
	layout.img_n = "sui/mainUI/vs_blood.png"
	local pro = SProgress:create_by_layout( layout )
	blood_bg:addChild(pro.view)
	pro:set_progress_size(229, 12, 0, 1)
	pro:set_lab_visible(false)
	pro:set_is_show_light(false)
	pro:set_cur_style_lab(2)

	local layout = {}
	layout.pos = {0,0}
	layout.size = {231,10}
	layout.img_s = "sui/mainUI/vs_mp_bg.png"
	layout.img_n = "sui/mainUI/vs_mp.png"
	local pro2 = SProgress:create_by_layout( layout )
	--pro2:doFlip(not isMy, false)
	blood_bg:addChild(pro2.view)
	pro2:set_progress_size(226.5, 7, 0, 1)
	pro2:set_lab_visible(false)
	pro2:set_is_show_light(false)
	pro2:set_cur_style_lab(2)

	--pro2:setIsVisible(false) --暂时不要蓝条

	pro:doFlip(not isMy, false)
	pro2:doFlip(not isMy, false)
	blood_bg:setFlip(not isMy,false)
	pro:set_value(100, 100)
	pro2:set_value(100, 100)

	if isMy then
		name:setPosition(45, 43)
		-- frame:setPosition(33, 31)
		--name_bg:setPosition(48, 42)
		blood_bg:setPosition(20, 0)
		pro:setPosition(30, 22)
		pro2:setPosition(31, 12)
		head_bg:setPosition(0,32)

		self.my_hp = pro
		self.my_mp = pro2
		self.my_level = level
		self.my_name = name
		self.my_head = head
	else
		name:setPosition(145, 43)
		-- frame:setPosition(165, 31)
		-- name_bg:setPosition(2, 32)
		-- name_bg:setFlip(true, true)
		blood_bg:setPosition(-140, 0)
		pro:setPosition(48, 22)
		pro2:setPosition(49, 12)
		head_bg:setPosition(190,32)

		self.di_hp = pro
		self.di_mp = pro2
		self.di_level = level
		self.di_name = name
		self.di_head = head
		--pro:set_progress_size(242, 12, 0, 1)
		--pro:doFlip(true, ture)
	end

	return tmp_panel
end

function Dantiao:create_str_time()
	local lb = SLabel:create("", 20, ALIGN_CENTER)
	self.str_time = lb

	local size = self.panel:getSize()
	local time_bg = SImage:create( "sui/fuben/wave_bg.png")
	time_bg:setAnchorPoint(0.5,0)
	time_bg:setPosition(size.width/2, size.height/4 -50)
	self.panel:addChild(time_bg.view)

	local size = time_bg:getSize()
	lb:setAnchorPoint(0,0.5)
	lb:setPosition(size.width/2, size.height/2)
	time_bg.view:addChild(lb.view)
	return lb
end

function Dantiao:update_time_str(time)
	local time_str = Utils:second_to_time_str(time,true)
	self.str_time:setText("#cf8cca7" .. "倒计时 " .. time_str)
end

-- function Dantiao:remove()
-- 	local root = ZXLogicScene:sharedScene():getUINode()
-- 		--先删除 再添加 以免重复
-- 	root:removeChildByTag(UI_TAG_SCREENMASK,true)
-- end

function Dantiao:set_my_level(level)
	self.my_level:setText("#cb27339" .. tostring(level))
end

function Dantiao:set_my_hp(cur, max)
	self.my_hp:set_value(cur, max)
end

function Dantiao:set_my_mp(cur, max)
	self.my_mp:set_value(cur, max)
end



function Dantiao:set_di_name(name)
	self.di_name:setText(name)
end

function Dantiao:set_di_level(level)
	self.di_level:setText("#cb27339" .. tostring(level))
end

function Dantiao:set_di_hp(cur, max)
	self.di_hp:set_value(cur, max)
end

function Dantiao:set_di_mp(cur, max)
	self.di_mp:set_value(cur, max)
end

function Dantiao:update_di_info(info)
	--self:set_di_name(info.name)
	self:set_di_level(info.level)
	self:set_di_hp(info.cur_hp, info.max_hp)
	self:set_di_mp(info.cur_mp, info.max_mp)
end

function Dantiao:update_my_info(info)
	self:set_my_level(info.level)
	self:set_my_hp(info.cur_hp, info.max_hp)
	self:set_my_mp(info.cur_mp, info.max_mp)
end

function Dantiao:update(data)
	-- print "Dantiao:update(data)"
	-- Utils:print_table(data)
	if data.utype == "update" then
		if self.params.my_handle == data.info.handle then
			self:update_my_info(data.info)
		else
			self:update_di_info(data.info)
		end
	elseif data.utype == "time_img" then
		self:update_time_str(data.info)
	end
end