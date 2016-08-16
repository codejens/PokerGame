local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight
local panelWidth =  _refWidth(1.0)
local panelHeight = _refHeight(1.0)


DuiWu = simple_class()

DuiWu.SHOW_MODEL_ZDTT = 1

--[[
params
	show_model
]]

function DuiWu:__init(params)
	self.show_model = params.show_model
	self.team = {[1] = {}, [2] = {}}

	local w,h = 800, 100
	--local panel = SPanel:create( "nopack/xszy/zezhao1.png", w, h, true)
	local panel = SPanel:create( "", w, h, true)
	panel:setAnchorPoint(0.5,1)
	panel:setPosition(panelWidth/2, panelHeight)
	panel.view:registerScriptHandler(function () return false end)
	self.panel = panel

	-- local root = ZXLogicScene:sharedScene():getUINode()
	-- 	--先删除 再添加 以免重复
	-- root:removeChildByTag(UI_TAG_SCREENMASK,true)
	-- root:addChild(panel.view, Z_ZORDER_GUIDE, UI_TAG_SCREENMASK)



	if self.show_model == DuiWu.SHOW_MODEL_ZDTT then
		self:show_zdtt_model()
	end
end

function DuiWu:get_panel()
	return self.panel
end

-- function DuiWu:remove()
-- 	local root = ZXLogicScene:sharedScene():getUINode()
-- 		--先删除 再添加 以免重复
-- 	root:removeChildByTag(UI_TAG_SCREENMASK,true)
-- end

function DuiWu:create_team(team_id, info, center_x)
	local size = self.panel:getSize()
	local x = size.width/2
	local offset_x = 69 +10 
	local tmp = {}
	for k,v in ipairs(info) do
		local member = self:create_player_info(v)

		--member.handle = v.handle
		if member then
			tmp[k] = member
			if team_id == 1 then
				member.bg:setPosition(x - center_x - (k-1)*offset_x, -10)
			elseif team_id == 2 then
				member.bg:setPosition(x + center_x + (k-2)*offset_x, -10)
			end
			self.panel:addChild(member.bg.view)
		end
	end
	self.team[team_id] = tmp
end

function DuiWu:create_player_info(data)
	--local bg = SImage:create( "sui/mainUI/vs_team_member.png")
-- print( "-----not data.handle or data.handle == 0:", data.handle, tonumber(data.handle) == 0)
	if not data.handle or tonumber(data.handle) == 0 then
		return nil
	end
	local bg = SImage:create( "")
	bg:setAnchorPoint(0.5, 0)
	--tmp_panel.view:addChild(bg.view)

	local layout = {}
	layout.pos = {3,15}
	layout.size = {62,10}
	layout.img_s = "sui/mainUI/vs_team_bg.png"
	layout.img_n = "sui/mainUI/vs_team_hp.png"
	local pro = SProgress:create_by_layout( layout )
	bg:addChild(pro.view)
	--pro:set_progress_size(62, 12)
	pro:set_lab_visible(false)
	pro:set_is_show_light(false)
	pro:set_cur_style_lab(2)
	pro:set_value(100, 100)

	local layout = {}
	layout.pos = {3,5}
	layout.size = {62,10}
	layout.img_s = "sui/mainUI/vs_team_bg.png"
	layout.img_n = "sui/mainUI/vs_team_mp.png"
	local pro2 = SProgress:create_by_layout( layout )
	--pro2:doFlip(not isMy, false)
	bg:addChild(pro2.view)
	--pro2:set_progress_size(62, 4)
	pro2:set_lab_visible(false)
	pro2:set_is_show_light(false)
	pro2:set_cur_style_lab(2)
	pro2:set_value(100, 100)

	local head_bg =  MUtils:create_zximg(bg, "sui/mainUI/roleGraphLayer.png", 34.5, 58.5, -1, -1)
	head_bg:setAnchorPoint(0.5, 0.5)
	head_bg:setScale(0.9)
	local head_path = "sui/normal/head"..data.job..".png"
    local head = MUtils:create_sprite(head_bg, head_path, 39.5, 44)
    head:setScale(0.9)
    head:setAnchorPoint(CCPointMake(0.5, 0.5))
    local frame = MUtils:create_zximg(head_bg, "sui/mainUI/roleFrame.png", 0, 0, -1, -1, nil, nil, z)
	-- local head = MUtils:create_head_grp_by_id(data.job, bg, 34.5, 58.5)
	-- head:setScale(0.8)
	-- local head = SImage:create( string.format("sui/normal/head%d.png",data.job) )
	-- head:setPosition(34.5,58.5)
	-- bg:addChild(head.view)

	local level = SLabel:create( "#cb27339" .. tostring(data.level or 0),14, 2)
	level:setPosition(20,10)
	frame:addChild(level.view)

	local info = {}
	info.bg = bg
	info.hp = pro
	info.mp = pro2
	info.handle = data.handle
	info.head = head
	info.level = level

	return info
end

function DuiWu:create_img_time(img_path_format, img_maohao, offset_x)
	self.time_img_path_format = img_path_format
	self.time_img_list = {}
	--local panel = SPanel:create( "nopack/xszy/zezhao1.png", 20, 20, true)
	local panel = SPanel:create( "", 20, 20, true)
	for i = 1, 5 do
		local numb = SImage:create( string.format("%s0.png", img_path_format))
		numb:setAnchorPoint(0.5, 0)
		local size = numb:getSize()
		numb:setPosition((size.width +offset_x)* (i-3) )
		panel:addChild(numb.view)
		self.time_img_list[i] = numb
	end
	
	self.time_img_list[3]:setTexture(img_maohao)

	return panel
end

function DuiWu:create_str_time()
	local str = SLabel:create("", 20, ALIGN_CENTER)
	self.str_time = str
	return str
end

function DuiWu:update_time_str(time)
	local time_str = Utils:second_to_time_str(time,true)
	self.str_time:setText(S_COLOR[9] .. time_str)
end

function DuiWu:update_time_img(time)
	-- print ("DuiWu:update_time_img >>>", time)
	local time_str = Utils:second_to_time_str(time,true)
	if self.time_img_list and self.time_img_path_format then
		local time_tab = Utils:Split(time_str, ":")
		-- print ("time_tab >>", time_tab[1], time_tab[2])
		
		local numb = string.sub(tostring(time_tab[1]), 1, 1)
		self.time_img_list[1]:setTexture(string.format("%s%d.png", self.time_img_path_format, tonumber(numb)))
		local numb = string.sub(tostring(time_tab[1]), 2, 2)
		self.time_img_list[2]:setTexture(string.format("%s%d.png", self.time_img_path_format, tonumber(numb)))

		local numb = string.sub(tostring(time_tab[2]), 1, 1)
		self.time_img_list[4]:setTexture(string.format("%s%d.png", self.time_img_path_format, tonumber(numb)))
		local numb = string.sub(tostring(time_tab[2]), 2, 2)
		self.time_img_list[5]:setTexture(string.format("%s%d.png", self.time_img_path_format, tonumber(numb)))

	end
end

function DuiWu:update_member_info(team_id, team_num, info)
	local member = self.team[team_id][team_num]
	if member then
		member.hp:set_value(info.cur_hp, info.max_hp)
		member.mp:set_value(info.cur_mp, info.max_mp)
	end
end

function DuiWu:udate_member_by_handle(handle, info)
	-- print ("udate_member_by_handle >>>>>>>>", handle)
	-- Utils:print_table(self.team)
	for k, v in pairs(self.team) do
		for m, n in pairs(v) do
			-- print ("n.handle >>", n.handle)
			if handle == n.handle then
				n.hp:set_value(info.cur_hp, info.max_hp)
				n.mp:set_value(info.cur_mp, info.max_mp)
				n.level:setText("#cb27339" .. tostring(info.level))
				break
			end
		end
	end
end

function DuiWu:update(data)
	if self.show_model == DuiWu.SHOW_MODEL_ZDTT then
		if data.utype == "init_team" then
			self:update_zdtt_model(data)
		elseif data.utype == "update" then
			self:udate_member_by_handle(data.info.handle, data.info)
		elseif data.utype == "time_img" then
			self:update_time_str(data.info)
		end
	end
end

function DuiWu:test()
	self:show_zdtt_model()
	-- local info = {1,2,3}
	-- self:create_team(1, info, 280)
	-- self:create_team(2, info, 280)
	-- self:update_zdtt_model(data)

	local t = timer()
	local ss = 100
	local function xxx()
		ss = ss -1
		self:update_time_img(ss)
		if ss == 0 then
			t:stop()
		end
	end
	t:start(1, xxx)
	
end

-----------------------------------------------------------------------------------------------

function DuiWu:show_zdtt_model()
	-- local time_bg1 = SImage:create( "sui/mainUI/vs_team_time_bg.png")
	-- local time_bg2 = SImage:create( "sui/mainUI/vs_team_time_bg.png")
	-- time_bg2:setFlip(true,false)
	-- time_bg1:setAnchorPoint(1,1)
	-- time_bg2:setAnchorPoint(0,1)
	-- local size = self.panel:getSize()
	-- time_bg1:setPosition(size.width/2, size.height)
	-- time_bg2:setPosition(size.width/2, size.height)
	-- self.panel:addChild(time_bg1.view)
	-- self.panel:addChild(time_bg2.view)

	local size = self.panel:getSize()
	local time_bg = SImage:create( "sui/mainUI/vs_team_time_bg.png")
	time_bg:setAnchorPoint(0.5,1)
	time_bg:setPosition(size.width/2, size.height)
	self.panel:addChild(time_bg.view)

	local lb = self:create_str_time()
	local size = time_bg:getSize()
	lb:setAnchorPoint(0,0.5)
	lb:setPosition(size.width/2, size.height/2)
	time_bg.view:addChild(lb.view)

	-- local tp = self:create_img_time("ui/fonteffect/t_", "ui/fonteffect/t_fenge.png", -10)
	-- time_bg.view:addChild(tp.view)
end

function DuiWu:update_zdtt_model(data)
	--sui/clans/icon_1.png
	local info = data.info
	local size = self.panel:getSize()
	local vs = SImage:create( "sui/guild/vs.png")
	vs:setAnchorPoint(0.5, 0.5)
	vs:setPosition(size.width/2,size.height/2 -25)
	vs:setScale(0.4)
	self.panel:addChild(vs.view)

	local team_icon1 = SImage:create( string.format("sui/clans/icon_%d.png", info.icon1))
	local team_icon2 = SImage:create( string.format("sui/clans/icon_%d.png", info.icon2))
	team_icon1:setAnchorPoint(0.5, 0.5)
	team_icon2:setAnchorPoint(0.5, 0.5)
	team_icon1:setPosition(size.width/2 -150, 30)
	team_icon2:setPosition(size.width/2 +150, 30)

	-- team_icon1:setScale(0.7,0.7)
	-- team_icon2:setScale(0.7,0.7)
	self.panel:addChild(team_icon1.view)
	self.panel:addChild(team_icon2.view)


	local team = info.team
	--local tmp_team = Utils:table_deepcopy(team)
	local player = EntityManager:get_player_avatar()
	local index = 1
	for k,v in pairs(team) do
		print ("player.handle >>>", player.handle , v.handle)
		if player.handle == v.handle then
			index = k
			break
		end
	end
	--玩家自己队，总在左边
	local bian1 = 1
	local bian2 = 2
	if index > 3 then
		bian1 = 2
		bian2 = 1
	end
	self:create_team(bian1, {team[1], team[2], team[3]}, 280)
	self:create_team(bian2, {team[4], team[5], team[6]}, 280)
end
