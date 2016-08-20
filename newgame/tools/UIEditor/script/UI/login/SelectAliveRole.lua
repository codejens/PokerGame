----------------------------------------------
--------HJH 2014-2-24
--------合服后选角色界面
require "UI/component/Window"
super_class.SelectAliveRole()
----------------------------------------------
-- local _camp_icon_list = {
-- 	"ui2/role/tianlei_tip.png",
-- 	"ui2/role/shushan_tip.png",
-- 	"ui2/role/yuanyue_tips.png",
-- 	"ui2/role/yuanhua_tips.png"
-- }

-- local _job_icon_list = {
-- 	"ui2/role/tianlei_tip_t.png",
-- 	"ui2/role/shushan_tip_t.png",
-- 	"ui2/role/yuanyue_tips_t.png",
-- 	"ui2/role/yuanhua_tips_t.png"
-- }

local _role_model_info = {
	{ body_info = 1000, weapon_info = 11200, wing_info = 8 },
	{ body_info = 2000, weapon_info = 12200, wing_info = 8 },
	{ body_info = 3000, weapon_info = 13200, wing_info = 8 },
	{ body_info = 4000, weapon_info = 14200, wing_info = 8 },
}

local _limit_role_num = 3
local dis_x = 255
local temp_begin_x = 90
local _rx = UIScreenPos.designToRelativeWidth
local _ry = UIScreenPos.designToRelativeHeight

----------------------------------------------
super_class.AliveRoleCard()
----------------------------------------------
function AliveRoleCard:__init( x, y, width, height, role_info )
   
	--------------
	local panel = ZBasePanel:create( nil, nil, x, y, width, height )
	self.panel = panel
	self.view = panel.view
	--------------
    
    --角色的背景框
	local bg = ZImage:create( panel, "ui2/login/select_role_bg.png", width / 2, height / 2, width, height,nil, 500, 500 )
	bg:setAnchorPoint(0.5, 0.5)
	--------------
	local job_img_pos = { x = 0, y = height - 30}
	if role_info.sex == 1 then
		job_img_pos.x = width - 90
	else
		job_img_pos.x = 30
	end

	-- self.job_img = ZImage:create( self, _camp_icon_list[role_info.job], job_img_pos.x, job_img_pos.y )
	-- self.job_img:setAnchorPoint(0, 1)
	--------------
	-- self.job_tip = ZImage:create( self, _job_icon_list[role_info.job], width / 2, height - 270 )
	-- self.job_tip:setAnchorPoint( 0.5, 0.5 )
	--------------
	--print("role_info.level,role_info.job",role_info.level,role_info.job,role_info.camp)
	-- local name_info = string.format("#cfff000LV.%s %s%s#cfff000%s", role_info.level, Lang.camp_info_ex[role_info.camp].color,
	--  Lang.camp_info_ex[role_info.camp].name[3], role_info.name )

    --角色等级
	self.lv_label = ZLabel:create(self, LH_COLOR[6].."LV."..tostring(role_info.level), width / 2, height - 40, 18, ALIGN_CENTER)

	local name_info = string.format("#cfff000%s%s.#cfff000%s", Lang.camp_info_ex[role_info.camp].color,
	 Lang.camp_info_ex[role_info.camp].name[3], role_info.name )
	--角色名称
	self.name = ZLabel:create( self, name_info, width / 2, 66, 20 )
	self.name.view:setAnchorPoint(CCPointMake(0.5, 0))
	--------------	
	-- ZImage:create( self, "ui/fonteffect/f_v.png", 70, 28, 140/2, 64/2 )


	--战斗力
	local fight_lab =  ZLabel:create( self.view,'#cfff000战力：',  72, 37,18)

	    local function get_num_ima( one_num )
        return string.format("ui/lh_other/number1_%d.png",one_num);
    end
	self.fightValue = ImageNumberEx:create( role_info.fightValue,get_num_ima,12)
	self.fightValue.view:setPosition( 130, 43 )
	self.fightValue.view:setAnchorPoint(CCPointMake(0,0))
	self.view:addChild(self.fightValue.view)
	-- local fight_value_info = string.format( "#cff0000战斗力:%s", role_info.fightValue, 16)
	-- self.fightValue = ZLabel:create( self, fight_value_info, width / 2, 46 )
	-- self.fightValue.view:setAnchorPoint(CCPointMake(0.5,0.5))
	--------------



	local tar_role_shadow = CCSprite:spriteWithFile('nopack/shadow.png')
	-- self.tar_role = ZXAvatar:createShowAvatar()
	-- self.tar_role:changeBody( _role_model_info[role_info.job].body_info )
	-- self.tar_role:putOnWeapon( _role_model_info[role_info.job].weapon_info )
	-- self.tar_role:putOnWing( _role_model_info[role_info.job].wing_info )

	player_obj = {}
	-- print("top_info_table[i].body",top_info_table[i].body)
	-- if top_info_table[i].body == 2100 then
	-- 	top_info_table[i].body = 10003
	-- end

	player_obj.body =_role_model_info[role_info.job].body_info
	player_obj.weapon = _role_model_info[role_info.job].weapon_info
	player_obj.wing = _role_model_info[role_info.job].wing_info
    
    self.tar_role = ShowAvatar:create_user_panel_avatar(120, 150,nil,player_obj)

	self.tar_role.avatar:setActionStept(ZX_ACTION_STEPT)
	self.tar_role.avatar:playAction(ZX_ACTION_IDLE, 4, true)
	self.view:addChild( self.tar_role.avatar )


	-- self.tar_role:addChild( tar_role_shadow, -1 )
	-- self.tar_role:setPosition( 140, 150 )
	-- self.view:addChild( self.tar_role )
end
----------------------------------------------
function SelectAliveRole:select_index_role_card(index)
	--print('run select_index_role_card',index)
	SelectServerRoleModel:set_cur_role_select_index(index)
	self.select_arc:setPosition(temp_begin_x + (index -1 ) * dis_x, 10)
end
----------------------------------------------
function SelectAliveRole:refresh_role_card()
	local temp_role_info = SelectServerRoleModel:get_role_data_list()
	local temp_index = ( SelectServerRoleModel:get_cur_page_index() - 1 )* _limit_role_num
	print("temp_index  #temp_role_info ",temp_index,#temp_role_info )
	self:select_index_role_card(1)

    


	-- for i = 1, #self.role_card_info do
	for i = 1, _limit_role_num do
		--如果已经存在则只需要更新
		if self.role_card_info[i] then 
			temp_index = temp_index + 1
			if temp_index > #temp_role_info then
				self.role_card_info[i].view:setIsVisible(false)
			else
				self.role_card_info[i].view:setIsVisible(true)
				--print(temp_role_info[temp_index].job,temp_role_info[temp_index].name)
				-- local job_img_pos = self.role_card_info[i].job_img:getPosition()
				-- if temp_role_info[temp_index].sex == 1 then
				-- 	job_img_pos.x = 280 - 90
				-- else
				-- 	job_img_pos.x = 30
				-- end
				-- self.role_card_info[i].job_img:setPosition( job_img_pos.x, job_img_pos.y )
				-- self.role_card_info[i].job_img.view:setTexture( _camp_icon_list[temp_role_info[temp_index].job] )

				-- self.role_card_info[i].job_tip.view:setTexture( _job_icon_list[temp_role_info[temp_index].job] )	
				local name_info = string.format("#cfff000%s%s.#cfff000%s", 
					Lang.camp_info_ex[temp_role_info[temp_index].camp].color, Lang.camp_info_ex[temp_role_info[temp_index].camp].name[3],
					temp_role_info[temp_index].name )
	            --角色等级
				self.role_card_info[i].lv_label:setText(LH_COLOR[6].."LV."..tostring(temp_role_info[temp_index].level))
				self.role_card_info[i].name:setText( name_info )
				-- self.role_card_info[i].tar_role:changeBody( _role_model_info[temp_role_info[temp_index].job].body_info )
				-- self.role_card_info[i].tar_role:putOnWeapon( _role_model_info[temp_role_info[temp_index].job].weapon_info )
				-- self.role_card_info[i].tar_role:putOnWing( _role_model_info[temp_role_info[temp_index].job].wing_info )	
				self.role_card_info[i].tar_role:udpate_body(_role_model_info[temp_role_info[temp_index].job].body_info)
				self.role_card_info[i].tar_role:update_weapon(_role_model_info[temp_role_info[temp_index].job].weapon_info)
				self.role_card_info[i].tar_role:update_wing(_role_model_info[temp_role_info[temp_index].job].wing_info)

				local fight_value_info = string.format( "#cff0000战斗力:%s", temp_role_info[temp_index].fightValue)
				self.role_card_info[i].fightValue:set_number( temp_role_info[temp_index].fightValue )
			end		
		else
			--不存在则创建
					if i <= #temp_role_info then
						local function role_card_function()
							t_self:select_index_role_card(i)
						end
						local temp_role = AliveRoleCard( temp_begin_x + ( i - 1 ) * _rx(dis_x), 180, 245, 400, temp_role_info[i] )
						-- temp_role.view:setScale( 0.9 )
						temp_role.panel:setTouchClickFun(role_card_function)
						self.base_panel:addChild( temp_role )
						table.insert( self.role_card_info, temp_role )
					end

		end
	
	end

end
----------------------------------------------
function SelectAliveRole:flip_page(stept)
	local temp_role_info = SelectServerRoleModel:get_role_data_list()
	local max_num = math.ceil( #temp_role_info / _limit_role_num )
	local cur_temp_index = SelectServerRoleModel:get_cur_page_index()
	print("max_num=",max_num)
	print("stept=",stept)
	--print("run flip_page cur_temp_index, max_num", cur_temp_index, max_num)

	if cur_temp_index + stept <= 1 then
		self.left_btn.view:setCurState(CLICK_STATE_DISABLE)
		if cur_temp_index + stept < max_num then
			self.right_btn.view:setCurState(CLICK_STATE_UP)
		end
	elseif cur_temp_index + stept >= max_num then
		self.right_btn.view:setCurState(CLICK_STATE_DISABLE)
		if cur_temp_index + stept > 0 then
			self.left_btn.view:setCurState(CLICK_STATE_UP)
		end
	end

	cur_temp_index = cur_temp_index + stept
	--print("cur_temp_index",cur_temp_index)
	-- if cur_temp_index < 0 then
	-- 	cur_temp_index = 0
	-- elseif cur_temp_index > max_num then
	-- 	cur_temp_index = max_num
	-- end

	SelectServerRoleModel:set_cur_page_index(cur_temp_index)

	self:refresh_role_card()
end
----------------------------------------------
function SelectAliveRole:__init( window_name, texture_name, pos_x, pos_y, width, height )
	--------------
	self.base_panel = ZBasePanel:create(nil, texture_name, pos_x, pos_y, width, height)
	self.view = self.base_panel.view
	safe_retain(self.view)
	--------------
	-- local title = ZImage:create( self, "ui2/login/lh_ser_bg.png", 400, 450 )
	-- title:setAnchorPoint(0.5, 0.5)
	--------------
	local temp_role_info = SelectServerRoleModel:get_role_data_list()
	--------------

	--选择左页
	local function left_btn_fun()
		self:flip_page(-1)
	end
   self.left_btn = UIButton:create_button_with_name( _rx(20), 388, -1, -1, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_disable, "", left_btn_fun )
   self.view:addChild(self.left_btn.view)
    self.left_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.arrow_disable )
	self.left_btn.view:setAnchorPoint(0, 0.5)
	self.left_btn.view:setCurState(CLICK_STATE_DISABLE)
	--------------
		--选择右页
	local function right_btn_fun()
		self:flip_page(1)
	end
	self.right_btn =  UIButton:create_button_with_name( _rx(940), 388, -1, -1, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_disable, "", right_btn_fun )
	self.view:addChild(self.right_btn.view)
    self.right_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.arrow_disable )
	self.right_btn.view:setAnchorPoint(1, 0.5)
	self.right_btn.view:setFlipX(true)
	if #temp_role_info < _limit_role_num then
		self.right_btn.view:setCurState(CLICK_STATE_DISABLE)
	end
	--------------
    -- 龙2
    local long1 = CCZXImage:imageWithFile( _rx(0), 0 , -1, -1, 'ui2/role/lh_dragon_2.png', -1, -1 )
    self.view:addChild( long1 )
    long1:setAnchorPoint( 0, 0)
    long1:setFlipX( true)
    long1:setScale(0.8)
    local long2 = CCZXImage:imageWithFile( _rx(960), 0 , -1, -1, 'ui2/role/lh_dragon_2.png', -1, -1 )
    self.view:addChild( long2 )
    long2:setAnchorPoint( 1, 0)

	--返回按钮
	local function return_btn_fun()
        local login_info = RoleModel:get_login_info(  );
        SelectRoleCC:req_exit( login_info.server_id,login_info.user_name )
        RoleModel:back_to_select_server(  )
        RoleModel:update_role_win( "server_list" )
	end

	local left_bottom_but = ZImageButton:create( self.view, 'ui2/role/lh_start.png',
                                                  "", return_btn_fun, 2, 0 )
    left_bottom_but.view:setFlipX( true)
    left_bottom_but.view:setScale( 0.8)
    local img_back_word = CCBasePanel:panelWithFile(55, 20, -1, -1, "ui2/role/role_back.png")
    left_bottom_but:addChild( img_back_word)

	-- ZImageButton:create( self, UILH_COMMON.button1, "ui2/login/back.png", return_btn_fun, 30, 15 )
	--------------

	--登录游戏按钮
	local function enter_btn_fun()
		local cur_page_index = SelectServerRoleModel:get_cur_page_index()
		local cur_index = SelectServerRoleModel:get_cur_role_select_index()
		local temp_info = SelectServerRoleModel:get_role_data_by_index( ( cur_page_index - 1 ) * _limit_role_num + cur_index )
		RoleModel:enter_game_scene(temp_info.id, 0);
	end

	local btn = ZButton:create( self.view, 'ui2/role/lh_start.png', 
                                    enter_btn_fun, 
                                    _rx(960), 0)
    btn:setAnchorPoint(1.0,0)
    local img_start_word = CCBasePanel:panelWithFile(75, 25, -1, -1, "ui2/role/role_start.png")
    btn.view:addChild( img_start_word)

    --给开始按钮添加特效
    btn.effect_light = effectCreator.createEffect_animation( "frame/effect/login/11047", 0.125, -1, -1)
    btn.effect_light:setPosition(210*0.5, 78*0.5)
    -- btn.effect_light:setScale(1)
    btn.view:addChild( btn.effect_light)




	-- --------------
	self.role_card_info = {}
	self.panel_card = CCBasePanel:panelWithFile( _rx(480), _ry(400), 900, 500, "")
	self.panel_card:setAnchorPoint(0.5, 0.5)
	self.base_panel:addChild(self.panel_card)
	--local temp_role_info = SelectServerRoleModel:get_role_data_list()
	local t_self = self
	for i = 1, _limit_role_num do
		if i <= #temp_role_info then
			local function role_card_function()
				t_self:select_index_role_card(i)
			end
			local temp_role = AliveRoleCard( temp_begin_x + ( i - 1 ) * dis_x, 10, 245, 400, temp_role_info[i] )
			-- temp_role.view:setScale( 0.9 )
			temp_role.panel:setTouchClickFun(role_card_function)
			self.panel_card:addChild( temp_role.view )
			table.insert( self.role_card_info, temp_role )
		end
	end
	--------------
	self.select_arc = ZImage:create( self.panel_card, UILH_COMMON.select_focus2, 0, 0, 245, 391, nil, 600, 600 )
	self:select_index_role_card(1)
	--------------
	-- local tip = ZLabel:create( self, "#cfff000温馨提示：系统默认只保留战斗力最强的6个角色", 400, 60, 20 )
	-- tip.view:setAnchorPoint(CCPointMake(0.5,0.5))

	--你目前一共拥有多个角色
	local count = #SelectServerRoleModel:get_role_data_list(  )
	self.player_count =  ZLabel:create( self.view,LH_COLOR[7]..count, 510, 102,35,ALIGN_CENTER)
	local tip_img = ZImage:create( self, "ui2/login/select_role_txt.png", _rx(480), _ry(104),-1,-1 )
	tip_img.view:setAnchorPoint(0.5,0.5)
    SelectServerRoleModel:set_cur_page_index(1)

    local count = #SelectServerRoleModel:get_role_data_list(  )
	self.player_count =  ZLabel:create( tip_img.view,LH_COLOR[7]..count, 195, 0,35,ALIGN_CENTER)
end

function SelectAliveRole:show_to_center( show_type )
    local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( 0, 0 ));          -- 动画
    self.view:runAction( moveto );
    if show_type == "login" or show_type == "register" then 
        --self:reset_page(  )
    end
end

function SelectAliveRole:hide_to_left( show_type )
    local end_x = -1000
    if show_type == "login" then
        end_x = 1000
    end
    local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( end_x, 0 ));          -- 动画
    self.view:runAction( moveto );
end

function SelectAliveRole:active( )
	--更新角色列表
	self:refresh_role_card()
	--更新角色个数
	local count = #SelectServerRoleModel:get_role_data_list(  )
	self.player_count:setText(LH_COLOR[7]..count);
    --更新按钮状态
    self:select_index_role_card(1)
    SelectServerRoleModel:set_cur_page_index(1)
	local temp_role_info = SelectServerRoleModel:get_role_data_list()
	--总共页数
	local max_num = math.ceil( #temp_role_info / _limit_role_num )
	--当前页数
	local cur_temp_index = SelectServerRoleModel:get_cur_page_index()

	if cur_temp_index < max_num then
		self.left_btn.view:setCurState(CLICK_STATE_DISABLE)
		self.right_btn.view:setCurState(CLICK_STATE_UP)
	else
		self.left_btn.view:setCurState(CLICK_STATE_DISABLE)
		self.right_btn.view:setCurState(CLICK_STATE_DISABLE)
	end

end
