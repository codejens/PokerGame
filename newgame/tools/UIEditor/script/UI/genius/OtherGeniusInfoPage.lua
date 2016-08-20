--OtherGeniusInfoPage.lua
--create by Little BC @ 2014-6-1
--happy children's day!
--查看他人式神窗口

super_class.OtherGeniusInfoPage()

function OtherGeniusInfoPage:__init(pos_x,pos_y )
	self.items_dict={}

	self.label_t = {}       --存储文字label的table，这样可以动态地获取修改文字内容
	self.t_equip_level={}	--按index保存装备闪耀等级
	self.t_equip_attr={} 	--按index保存装备追加属性

	local pos_x = x or 0
    local pos_y = y or 0
	self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 835,465+60, nil, 500, 500 )

	-- 底板
	local panel = self.view
	-- 左上
	local _left_up_panel = CCBasePanel:panelWithFile( 11, 222-6-2+46, 390+20, 263, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_left_up_panel)
	self.avator_panel=_left_up_panel
	-- 左下
	local _left_down_panel = CCBasePanel:panelWithFile( 10, 13, 390+20, 200+40, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_left_down_panel)
	-- 右
	_right_panel = CCBasePanel:panelWithFile( 404+20, 13, 390+10,465+44, UI_MountsWinNew_004, 500, 500 )
	panel:addChild(_right_panel)

	self:initUI(_left_up_panel,_left_down_panel,_right_panel)
end

-- 加载UI
function OtherGeniusInfoPage:initUI( left_up_panel,left_down_panel,right_panel)
	self:init_left_up_view(left_up_panel)

	self:init_left_down_view(left_down_panel)

	self:init_right_view(right_panel)
end

-- 创建左上底版显示内容
function OtherGeniusInfoPage:init_left_up_view( left_up_panel)
	-- 式神背景
	self.sprite_panel = CCBasePanel:panelWithFile( 1,1,390+20-2, 263-2, UI_GeniusWin_0013, 500, 500 )
	left_up_panel:addChild(self.sprite_panel)

	-- 式神形象
    local action = UI_GENIUS_ACTION;
    self.sprite_animate = MUtils:create_animation(162+39,160-18,"frame/gem/00001",action );
    self.sprite_panel:addChild(self.sprite_animate);

	--精灵名底色
	local name_bg = CCZXImage:imageWithFile(134, 228,145,-1,UI_MountsWinNew_016,500,500)
	self.sprite_panel:addChild(name_bg)

	-- 精灵名字 	
	self.sprite_name = UILabel:create_lable_2( "#cfff000白虎", 70, 6, 20, ALIGN_CENTER );
	name_bg:addChild(self.sprite_name);

	-- 战斗力
	local _power_bg = CCBasePanel:panelWithFile( 86-12,8,260, -1, UI_MountsWinNew_017, 500, 500 )
	self.sprite_panel:addChild(_power_bg)
	-- 战斗力文字
	local _power_title = CCZXImage:imageWithFile(60,17,-1,-1,UI_MountsWinNew_018)
    _power_bg:addChild(_power_title)
    -- 战斗力值
	self.sprite_fight = ZXLabelAtlas:createWithString("99999",UIResourcePath.FileLocate.normal .. "number");
	self.sprite_fight:setPosition(CCPointMake(130,17));
	self.sprite_fight:setAnchorPoint(CCPointMake(0,0));
	_power_bg:addChild(self.sprite_fight);
end

-- 创建左下底版显示内容
function OtherGeniusInfoPage:init_left_down_view( left_down_panel)
	--增加属性标题
	local _left_down_title_panel = CCBasePanel:panelWithFile( 1, 170+44, 120, -1, UI_MountsWinNew_005, 500, 500 )
	left_down_panel:addChild(_left_down_title_panel)
	local name_title = CCZXImage:imageWithFile(27, 3,-1,-1,UI_GeniusWin_0021,500,500)
	_left_down_title_panel:addChild(name_title)

	-- 装备item
	local index = 1
	for i=1,2 do
		for j=1,5 do
			if index==10 then
				return
			end
	        local panel = CCBasePanel:panelWithFile( 20+(j-1)*77, 120-(i-1)*84, 62, 62, "" );
	        left_down_panel:addChild(panel);

	    	local skill_item = MUtils:create_one_slotItem(nil, 0, 0, 48, 48 );

	    	skill_item:set_icon_texture(SpriteConfig:get_skill_icon_by_id(index));

	    	local _index=index
	        local function tip_func(  )
	            --self:selected_skill_item(_index);
	        end

	        skill_item:set_click_event(tip_func);
	        skill_item:set_select_effect_state(true)
	    	panel:addChild(skill_item.view);
	    	
	        self.items_dict[_index] = skill_item;
	        index = index+1
        end
	end
end

-- 创建右底版显示内容
function OtherGeniusInfoPage:init_right_view( right_panel)
	--增加基础信息标题
	local base_info_title = CCBasePanel:panelWithFile( 1, 436+44, 120, -1, UI_MountsWinNew_005, 500, 500 )
	right_panel:addChild(base_info_title)
	local base_info_label = CCZXImage:imageWithFile(27, 3,-1,-1,UI_GeniusWin_0032,500,500)
	base_info_title:addChild(base_info_label)

	--增加基础属性标题
	local base_arrt_title = CCBasePanel:panelWithFile( 1,355, 120, -1, UI_MountsWinNew_005, 500, 500 )
	right_panel:addChild(base_arrt_title)
	local base_arrt_lable = CCZXImage:imageWithFile(27, 3,-1,-1,UI_GeniusWin_0018,500,500)
	base_arrt_title:addChild(base_arrt_lable)

	--增加式神装备标题
	local sprite_equip_title = CCBasePanel:panelWithFile( 1, 214+30, 120, -1, UI_MountsWinNew_005, 500, 500 )
	right_panel:addChild(sprite_equip_title)
	local sprite_equip_label = CCZXImage:imageWithFile(27, 0,-1,-1,UI_GeniusWin_0017,500,500)
	sprite_equip_title:addChild(sprite_equip_label)

	-- 名字标签和数值标签的RGB值，统一放外面设置
    local name_rgb_t = { 250, 250, 250}
    local num_rgb_t =  { 0, 210, 87 }
 	-- --字体相关固定值
    local fontsize = 18                                  --字体大小
    local label_siz_w = 100                              --label尺寸的宽度值
    local label_siz_h = fontsize                         --尺寸高度设置成和字体大小一样，就不会出现中文和数字不对齐的问题
    local dimensions = CCSize(label_siz_w,label_siz_h)   --lable尺寸
    local lable_inteval_x = 200                          --labelx坐标的间距
    local lable_inteva_y = label_siz_h + 12               --labely坐标的间距

    --基准坐标
    local lable_nam_sta_x = 50                          --属性名称的起始x坐标
    local lable_nam_sta_y = 425+42                          --当到某一行，需要分块（距离更大）时，可以调整基准起始y坐标实现
    local lable_num_sta_x = lable_nam_sta_x + label_siz_w -2   --属性数值的起始x坐标
    local lable_num_sta_y = lable_nam_sta_y                    --当到某一行，需要分块（距离更大）时，可以调整基准起始y坐标实现
    local count = 1                                            --用于计算第几行，计算坐标

    local default_font_size = 18

    --等级
    right_panel:addChild( MUtils:create_lable( Lang.genius.other_genius_info.level, dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    right_panel:addChild( MUtils:create_lable( "0", dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "level" , self.label_t) )

    --等阶
	right_panel:addChild( MUtils:create_lable( Lang.genius.other_genius_info.stage_level, dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    right_panel:addChild( MUtils:create_lable( "0", dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "stage_level" , self.label_t) )

    --升阶星级
	right_panel:addChild( MUtils:create_lable( Lang.genius.other_genius_info.star_level, dimensions, lable_nam_sta_x + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    right_panel:addChild( MUtils:create_lable( "0", dimensions, lable_num_sta_x  + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "star_level" , self.label_t) )

    --轮回
	right_panel:addChild( MUtils:create_lable( Lang.genius.other_genius_info.lunhui_level, dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 2, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    right_panel:addChild( MUtils:create_lable( "0", dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 2, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "lunhui_level" , self.label_t) )

    --轮回星级
	right_panel:addChild( MUtils:create_lable( Lang.genius.other_genius_info.lunhui_star_level, dimensions, lable_nam_sta_x + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 2, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    right_panel:addChild( MUtils:create_lable( "0", dimensions, lable_num_sta_x  + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 2, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "lunhui_star_level" , self.label_t) )
 	-- 属性信息 分行:调整lable_nam_sta_y既可
    lable_nam_sta_y = lable_nam_sta_y - 132
    lable_num_sta_y = lable_nam_sta_y
    lable_inteva_y = label_siz_h + 20 

	--生命
	right_panel:addChild( MUtils:create_lable( Lang.genius.other_genius_info.attr_life, dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
	MUtils:create_zximg(right_panel,UI_GeniusWin_0034,lable_num_sta_x  + lable_inteval_x * 0 - label_siz_w/2,lable_num_sta_y - lable_inteva_y * 0 - label_siz_h+2,label_siz_w,31)
    right_panel:addChild( MUtils:create_lable( "0", dimensions, lable_num_sta_x  + lable_inteval_x * 0 +5, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "attr_life" , self.label_t) )    

    --攻击
	right_panel:addChild( MUtils:create_lable( Lang.genius.other_genius_info.attr_attack, dimensions, lable_nam_sta_x + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
	MUtils:create_zximg(right_panel,UI_GeniusWin_0034,lable_num_sta_x  + lable_inteval_x * 1 - label_siz_w/2,lable_num_sta_y - lable_inteva_y * 0 - label_siz_h+2,label_siz_w,31)
    right_panel:addChild( MUtils:create_lable( "0", dimensions, lable_num_sta_x  + lable_inteval_x * 1+5, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "attr_attack" , self.label_t) )    

    --物理防御
	right_panel:addChild( MUtils:create_lable( Lang.genius.other_genius_info.attr_wDefense, dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
	MUtils:create_zximg(right_panel,UI_GeniusWin_0034,lable_num_sta_x  + lable_inteval_x * 0 - label_siz_w/2,lable_num_sta_y - lable_inteva_y * 1 - label_siz_h+2,label_siz_w,31)
    right_panel:addChild( MUtils:create_lable( "0", dimensions, lable_num_sta_x  + lable_inteval_x * 0+5, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "attr_wDefense" , self.label_t) )    

    --精神防御
	right_panel:addChild( MUtils:create_lable( Lang.genius.other_genius_info.attr_mDefense, dimensions, lable_nam_sta_x + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
	MUtils:create_zximg(right_panel,UI_GeniusWin_0034,lable_num_sta_x  + lable_inteval_x * 1 - label_siz_w/2,lable_num_sta_y - lable_inteva_y *1  - label_siz_h+2,label_siz_w,31)
    right_panel:addChild( MUtils:create_lable( "0", dimensions, lable_num_sta_x  + lable_inteval_x * 1+5, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "attr_mDefense" , self.label_t) )    

    lable_nam_sta_y = lable_nam_sta_y - 107
    lable_num_sta_y = lable_nam_sta_y
    lable_inteva_y = label_siz_h + 11

    --装备属性
    local index = 1
    for i=1,8 do
    	right_panel:addChild( MUtils:create_lable( Lang.genius.other_genius_info.equip[i], dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * (i-1), default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )   
    	self.t_equip_level[i]=MUtils:create_lable( "", dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * (i-1), default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3])
    	right_panel:addChild(self.t_equip_level[i]) 
    	self.t_equip_attr[i]=MUtils:create_lable( "", dimensions, lable_nam_sta_x  + lable_inteval_x * 1+25, lable_nam_sta_y - lable_inteva_y * (i-1), default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3])    	
    	right_panel:addChild(self.t_equip_attr[i])
    end

end

--刷新数据
function OtherGeniusInfoPage:show_view_by_data(sprite_info)
	if sprite_info==nil then
		return
	end
	print("OtherGeniusInfoPage:show_view_by_data(sprite_info.model_id,sprite_info.stage_level,sprite_info.star_level)",sprite_info.model_id,sprite_info.stage_level,sprite_info.star_level)

 	-- local sprite_info =SpriteModel:get_sprite_info()
 	
    if sprite_info then

    	-- 更新精灵属性
        -- local stages_config = SpriteConfig:get_spirits_stages(sprite_info.model_id, sprite_info.star_level );
        local stages_config = SpriteConfig:get_spirits_stages(sprite_info.stage_level, sprite_info.star_level );

        self.sprite_name:setText( stages_config.name );
        self.sprite_fight:init(tostring(sprite_info.fight_value))

        local count = sprite_info.skill_count

        for i,v in ipairs(self.items_dict) do
        	if i>count then
        		v:set_icon_dead_color();
        	else
        		v:set_icon_light_color();
        	end	
        end

		self:update_current_sprite_avatar( sprite_info.model_id  )

		--更新属性面板数值
		self.label_t["level"]:setString("#cfff000"..sprite_info.level)
		self.label_t["stage_level"]:setString("#cfff000"..sprite_info.stage_level.."阶")
		self.label_t["star_level"]:setString("#cfff000"..sprite_info.star_level.."/10")
		self.label_t["lunhui_level"]:setString("#cfff000"..sprite_info.lunhui_level.."转")
		self.label_t["lunhui_star_level"]:setString("#cfff000"..sprite_info.lunhui_star_level.."/10")
		self.label_t["attr_life"]:setString("#cfff000"..sprite_info.attr_life)
		self.label_t["attr_attack"]:setString("#cfff000"..sprite_info.attr_attack)
		self.label_t["attr_wDefense"]:setString("#cfff000"..sprite_info.attr_wDefense)
		self.label_t["attr_mDefense"]:setString("#cfff000"..sprite_info.attr_mDefense)

		--更新装备属性面板值
		-- print("<<<<<<<<<<<<<<<sprite_info.equip_count",sprite_info.equip_count)
		for i=1,sprite_info.equip_count do
			--闪耀等级
			local sprite_shanyao_level = sprite_info.equips_level[i]
			self.t_equip_level[i]:setString("#ce519cb领悟级别+"..sprite_shanyao_level)
			--追加属性
			local  sprite_attr_add=self:get_shanyao_attr_add(i,sprite_shanyao_level)
			self.t_equip_attr[i]:setString("#cfff000"..sprite_attr_add.type_add.."+"..sprite_attr_add.attr_add)
		end
    end
end

-- 获取闪耀伤害追加值
-- 参数：技能序号（技能索引）、闪耀级别
function OtherGeniusInfoPage:get_shanyao_attr_add(equip_index, equip_shanyao_level)
	local attr_add = spirits_equip.equip[equip_index].addRate[equip_shanyao_level]
	local _type = spirits_equip.equip[equip_index].type
	local type_ddd = SpriteModel:get_shanyao_attr_by_type(_type)
	return {attr_add=attr_add,type_add=type_ddd}
end

--统一刷新接口
function OtherGeniusInfoPage:update(_sprite_info)
	self:show_view_by_data(_sprite_info)
end

-- 更新当前式神形象
function OtherGeniusInfoPage:update_current_sprite_avatar( model_id )
    if self.sprite_animate then
        self.sprite_animate:removeFromParentAndCleanup(true);
    end
    local frame_str = string.format("frame/gem/%05d",model_id);
    local action = UI_GENIUS_ACTION;
    self.sprite_animate = MUtils:create_animation( 162+39,160-18,frame_str,action );
    self.sprite_panel:addChild( self.sprite_animate );
end