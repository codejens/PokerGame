-- GuildFubenRight.lua 
-- createed by liuguowang on 2014-3-25
-- 仙踪副本 右窗口
local _select_index
super_class.GuildFubenRight(Window)

function GuildFubenRight:__init( texture_name )	
	self.guid_open = nil --
	-- 构造面板内容
    local background = CCBasePanel:panelWithFile( 10, 11 , 373,385,UIPIC_GRID_nine_grid_bg3, 500, 500);  --方形区域
    self:addChild( background,2 )
	--参与条件 
    ZImageImage:create(background, UIResourcePath.FileLocate.guild .. "join_need.png", UIResourcePath.FileLocate.common .. "quan_bg.png", 3, 357, 367, -1, 500, 500)
	ZDialog:create(background,Lang.guild.fuben.open_need,10,288,344,60)
	--开启条件
    ZImageImage:create(background, UIResourcePath.FileLocate.guild .. "open_need.png", UIResourcePath.FileLocate.common .. "quan_bg.png", 3, 252, 367, -1, 500, 500)
	ZDialog:create(background,Lang.guild.fuben.join_need,10,184,344,60)

	ZImage:create( background,UIResourcePath.FileLocate.common .."white_line2.png",0,170,366,1)

	ZLabel:create(background,Lang.guild.fuben.label1,20,140)

	self.need_level = ZLabel:create(background,"",20,140-25)--

	ZLabel:create(background,Lang.guild.fuben.label3,20,140-25*2)--本周个人可参加次数:
	self.geren_jion = ZLabel:create(background,"0",20+167,140-25*2)--本周个人可参加次数:  X

	ZLabel:create(background,Lang.guild.fuben.label4,20,140-25*3)--本周仙宗可开启次数:
	self.guid_open = ZLabel:create(background,"0",20+167,140-25*3)--本周仙宗可开启次数:  X

	function open_funben_fun() -- 开启副本
		local status = GuildModel:get_fuben_btn_status()
		if status == 2  then --开启了
			GuildModel:pop_notice()
			UIManager:hide_window("guild_fuben_left");
	        UIManager:hide_window("guild_fuben_right");
		else -- 开启副本
			if GuildModel:is_zongzhu() == true then 
				function sure_fun(  )
					if self.sell_time_select then -- sell_time_select 从0 开始
						local diff = self.sell_time_select:getCurSelect() +1
						GuildCC:req_fudizhizhan_fuben(diff)
					end					
				end
				local tishi_str = string.format(Lang.guild.fuben.open_tishi,self.level_text:getText() )
				NormalDialog:show(tishi_str,sure_fun,1)
			else
				GlobalFunc:create_screen_notic("只有宗主和副宗主才能开启")
			end

		end
	end
	self.open_btn = ZImageButton:create(background,UIResourcePath.FileLocate.common .. "button_red.png",UIResourcePath.FileLocate.guild .. "open_fuben.png",open_funben_fun,129,10)

	-- function canyufuben() -- 开启副本
	-- end
	-- ZButton:create(background, UIResourcePath.FileLocate.common .. "button4.png",canyufuben,200,10)
---------------------------------------------------------------------------------------
	-- --下拉框
	local sell_time_show_btn = ZImage:create( background, UIResourcePath.FileLocate.common .. "xiala.png", 236+100, 137, -1, -1 )
	--显示的背景
	self.sell_time_bg = ZBasePanel:create( background, UIPIC_GRID_nine_grid_bg3,  236, 134,126,30, 600, 600 )
	local function time_bg_fun()
		if self.sell_time_select ~= nil and self.sell_time_select.view ~= nil then
			local result = self.sell_time_select.view:getIsVisible()
			self.sell_time_select.view:setIsVisible(not result)
		end
	end
	self.sell_time_bg:setTouchClickFun(time_bg_fun)
	self.level_text = ZLabel:create(background,"",236+40, 140+1)--本周个人可参加次数:  X
	--下拉出的显示
	self.sell_time_select = ZRadioButtonGroup:create( background, 236, 9,126,25*5, 1, UIPIC_GRID_nine_grid_bg3, 600, 600)
	self.sell_time_select.view:setIsVisible(false)
	local level_info = Lang.guild.fuben.level_info --  { "#c38afe1简单","#c38afe1普通","#c38afe1困难" } 
	for i = 1, #level_info do
		local temp = ZTextButton:create( nil, level_info[i], UIResourcePath.FileLocate.normal .. "empyt_tex.png", nil, 0, 0, 126, 25, nil, 600, 600 )
		self.sell_time_select:addItem( temp, 0, 1 )
		local function time_btn_fun()
			self.sell_time_select.view:setIsVisible(false)
			self.level_text:setText(level_info[i])
			
			local need_level_str = string.format(Lang.guild.fuben.label2,i+1)
			self.need_level:setText(need_level_str)

		end
		temp:setTouchClickFun(time_btn_fun)
	end
	self.level_text:setText(level_info[1])
	local need_level_str = string.format(Lang.guild.fuben.label2,1+1)
	self.need_level:setText(need_level_str)

	-- local item_text_info = {"111","222","#3333"}
	-- ZCombox:create(background, 236, 144,126,30,25,item_text_info)
    local function btn_close_fun()
        UIManager:hide_window("guild_fuben_left");
        UIManager:hide_window("guild_fuben_right");
        return true
    end
	self.exit_btn:setTouchClickFun(btn_close_fun)
end


function GuildFubenRight:update_btn()
	local status = GuildModel:get_fuben_btn_status()
	if status == 2 then --活动活动进行中， 2表示活动进行中
		self.open_btn:set_image_texture(UIResourcePath.FileLocate.guild .. "join_fuben.png")
	else
		self.open_btn:set_image_texture(UIResourcePath.FileLocate.guild .. "open_fuben.png")
	end
end

function GuildFubenRight:update_xiala()
	local diff = GuildModel:get_fuben_diff() --自动下发得到的数据
	if diff == nil then
		return
	end
	if self.level_text then -- 
		local level_info = Lang.guild.fuben.level_info --  { "#c38afe1简单","#c38afe1普通","#c38afe1困难" } 
		self.level_text:setText(level_info[diff])
	end
	local need_level_str = string.format(Lang.guild.fuben.label2,diff+1)
	self.need_level:setText(need_level_str)
	_select_index = diff
end

function GuildFubenRight:update_data()--初始化
	local person_times,guild_times = GuildModel:get_fuben_times()
	if person_times == nil or guild_times == nil then
		return 
	end

	self.geren_jion:setText(person_times)
	self.guid_open:setText(guild_times)

end


function GuildFubenRight:update(Type)
	if Type == "xiala" then
		self:update_xiala()
	elseif Type == "btn" then
		self:update_btn()
	elseif Type == "data" then
		self:update_data()
	end
end

function GuildFubenRight:active(show)
	if show == true then
		GuildCC:req_fudizhizhan_data()--"update("data")
		self:update("xiala")
		self:update("btn")
	end
end
