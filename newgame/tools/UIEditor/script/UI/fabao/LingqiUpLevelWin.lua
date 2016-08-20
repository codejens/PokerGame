-- LingqiInfoPage.lua
-- created by xiehande on 2014-10-29
-- 灵器系统左页面
super_class.LingqiUpLevelWin(Window)
local font_size = 16
local color_type = LH_COLOR[2]

local switch_ten_var = false  --是否选中一键十次

--三种晶体的配置中的ID数组
local _crystal_ids = {18603,18604,18605};

 local lingqi_level = 1

local beauty_array = {}

 --对应阶的美人图谱
local beauty_img_array = {
    UILH_LINGQI.beauty1,
    UILH_LINGQI.beauty2,
    UILH_LINGQI.beauty3,
    UILH_LINGQI.beauty4,
    UILH_LINGQI.beauty5,
}

--对应的灰化的美人图
local beauty_img_array_d = {
    UILH_LINGQI.beauty1_d,
    UILH_LINGQI.beauty2_d,
    UILH_LINGQI.beauty3_d,
    UILH_LINGQI.beauty4_d,
    UILH_LINGQI.beauty5_d,
}

--对应的美人背景  --牌
local beauty_bg_array = {
    UILH_LINGQI.pai1,
    UILH_LINGQI.pai2,
    UILH_LINGQI.pai3,
    UILH_LINGQI.pai4,
    UILH_LINGQI.pai5,
}

local lingqi_name_list = {
    UILH_LINGQI.name_t_1,
    UILH_LINGQI.name_t_2,
    UILH_LINGQI.name_t_3,
    UILH_LINGQI.name_t_4,
    UILH_LINGQI.name_t_5,
}

--等级开放
local  lingqi_level_open = {
    [2] = UILH_LINGQI.later_11,
    [3] = UILH_LINGQI.later_21,
    [4] = UILH_LINGQI.later_31,
    [5] = UILH_LINGQI.later_41,
}


--创建方法
function  LingqiUpLevelWin:create( )
	return LingqiUpLevelWin( "LingqiUpLevelWin", "", true, 880, 500)
end

--初始化
function  LingqiUpLevelWin:__init(window_name, texture_name, is_grid, width, height)
	local  bg_panel = self.view
    self:create_left(bg_panel,7,0,423,497,UILH_COMMON.bottom_bg)
    local right_panel = CCBasePanel:panelWithFile(443-10, 0, 441, 497, UILH_COMMON.bottom_bg, 500, 500)
    bg_panel:addChild(right_panel)
	self:create_panel(right_panel)
end

--创建上下面板
function LingqiUpLevelWin:create_panel(bg_panel)

   	--灵器总属性
	local up_panel = CCBasePanel:panelWithFile(2, 274, 441, 220, "", 500, 500)
    bg_panel:addChild(up_panel)

    --上方的标题  基本属性
    local title_bg = CCZXImage:imageWithFile( 0, 186, 441/2, 31, UILH_NORMAL.title_bg4 )
    local title_name1 =  UILabel:create_lable_2(Lang.lingqi.upgrade[1], 75, 10, font_size, ALIGN_LEFT ) 
    title_bg:addChild(title_name1)

    local title_bg2 = CCZXImage:imageWithFile(215,186, 441/2, 31, UILH_NORMAL.title_bg4 )
     local title_name2 =  UILabel:create_lable_2(Lang.lingqi.upgrade[2], 75, 10, font_size, ALIGN_LEFT ) 
    title_bg2:addChild(title_name2)
    up_panel:addChild(title_bg)
    up_panel:addChild(title_bg2)

        -- 分割线
    local split_img = CCZXImage:imageWithFile(6,5,425,4,UILH_COMMON.split_line);
    up_panel:addChild(split_img);
   

    --当前基本属性
    self.cur_at_attri = MUtils:create_attrs_bar( up_panel, 43, 161, LH_COLOR[2]..Lang.lingqi.upgrade[5], 50 ); -- [963]="攻    击:"

    self.cur_hp_attri = MUtils:create_attrs_bar( up_panel, 43, 127, LH_COLOR[2]..Lang.lingqi.upgrade[6], 50 ); -- [966]="生    命:"
    
    self.cur_wd_attri = MUtils:create_attrs_bar( up_panel, 43, 94, LH_COLOR[2]..Lang.lingqi.upgrade[7], 50 ); -- [964]="物理防御:"
    
    self.cur_md_attri = MUtils:create_attrs_bar( up_panel, 43, 60, LH_COLOR[2]..Lang.lingqi.upgrade[8], 50 );   -- [967]="法术防御:"

    self.cur_bj_attri = MUtils:create_attrs_bar( up_panel, 43, 25, LH_COLOR[2]..Lang.lingqi.upgrade[9], 50 ); -- [965]="抗 暴 击:"


    --下一级属性
    self.next_at_attri = MUtils:create_attrs_bar( up_panel, 284, 161, LH_COLOR[2]..Lang.lingqi.upgrade[5], 50 ); -- [963]="攻    击:"

    self.next_hp_attri = MUtils:create_attrs_bar( up_panel, 284, 127, LH_COLOR[2]..Lang.lingqi.upgrade[6], 50 ); -- [966]="生    命:"
    
    self.next_wd_attri = MUtils:create_attrs_bar( up_panel, 284, 94, LH_COLOR[2]..Lang.lingqi.upgrade[7], 50 ); -- [964]="物理防御:"
    
    self.next_md_attri = MUtils:create_attrs_bar( up_panel, 284, 60, LH_COLOR[2]..Lang.lingqi.upgrade[8], 50 );   -- [967]="法术防御:"

    self.next_bj_attri = MUtils:create_attrs_bar( up_panel, 284, 25, LH_COLOR[2]..Lang.lingqi.upgrade[9], 50 ); -- [965]="抗 暴 击:"

    

    local down_panel = CCBasePanel:panelWithFile(3, 0, 440, 275, "", 500, 500)
    bg_panel:addChild(down_panel)

  -- 法宝等级
    local level_lab = UILabel:create_lable_2(LH_COLOR[2]..Lang.lingqi.upgrade[3], 35, 248, 14, ALIGN_LEFT ); -- [945]="#c38ff33等    级:"
    down_panel:addChild(level_lab);

    self.level = UILabel:create_lable_2( "1", 90, 248, 14, ALIGN_LEFT );
    down_panel:addChild(self.level);

    -- 经验
    local progress_lab = UILabel:create_lable_2(LH_COLOR[2]..Lang.lingqi.upgrade[4], 164, 248, 14, ALIGN_LEFT ); -- [946]="#c38ff33经    验:"
    down_panel:addChild(progress_lab);
    --经验值进度条
    self.progress_bar = ZXProgress:createWithValueEx( 0, 180, 216, 17,UILH_NORMAL.progress_bg2,UILH_NORMAL.progress_bar_orange, true );
    self.progress_bar:setPosition(CCPointMake(211,245));
    down_panel:addChild(self.progress_bar);

    --晶体的集合
    self.crystal_dict = {};

--从可选中的面板改变成slot 创建 三种晶体
    for i = 1,3 do 
        --选中晶体面板的触发方法
        local function selected_crystal( eventType )
            if eventType == TOUCH_CLICK then
                self:selected_crystal(i);
            end          
            return true;
        end 
        local panel  = CCBasePanel:panelWithFile(50+(i-1)*130,120,90,120,"")
        panel:registerScriptHandler(selected_crystal)
        down_panel:addChild(panel);

        local item = MUtils:create_one_slotItem( _crystal_ids[i], 5, 30, 66, 66);
        item:set_icon_bg_texture( UILH_COMMON.slot_bg, -10, -10, 84, 84 )   -- 背框
        --点击之后弹出的tip信息框
         local function tip_func(  )
            TipsModel:show_shop_tip( 0, 0, _crystal_ids[i], TipsModel.LAYOUT_LEFT)
        end
  
          --slot双击选中的时间
        local function selected_change( eventType )
            self:selected_crystal(i);   
            tip_func()  
            return true;
        end 

        item:set_click_event(selected_change);

         --双击弹出tip
        -- item:set_double_click_event(tip_func);
        panel:addChild(item.view);
        self.crystal_dict[i] = item;
        local text ;
        if i == 1 then
            text = Lang.lingqi.upgrade[10] -- ="#c38ff33初级灵器碎片"
        elseif i == 2 then
            text = Lang.lingqi.upgrade[11] -- "#c38ff33初级灵器碎片"
        elseif i == 3 then
            text = Lang.lingqi.upgrade[12] -- "#c38ff33初级灵器碎片"
        end
        local lab = UILabel:create_lable_2(LH_COLOR[2]..text, 5, 7, 14, ALIGN_LEFT );
        panel:addChild(lab);
    end


     -- 选中框
    self.crystal_select_frame = MUtils:create_zximg(down_panel, UILH_COMMON.slot_focus, 46, 142, 86, 86);
      --晶石选择索引
    self.crestal_select_index = 1;
    --更新晶体的总数 从背包中获取
    -- self:update_crystal_count();


    self.switch_btn_var = false;
    --选中和取消选中方法
    local function selected_switch_btn( bool )
    self.switch_btn_var = bool;
    SetSystemModel:set_one_date( SetSystemModel.COST_UPGRADE_GEM, self.switch_btn_var )
    end
        -- 材料不足时，使用元宝代替
    self.use_yb = UIButton:create_switch_button( 151, 75, 240, 30, UILH_COMMON.dg_sel_1,UILH_COMMON.dg_sel_2,
                         Lang.lingqi.upgrade[13], 50, 14, nil, nil, nil, nil, selected_switch_btn ); -- "材料不足时，使用10元宝代替"
    down_panel:addChild(self.use_yb.view);



    --一键十次 回调
     local function selected_ten_btn( bool )
       switch_ten_var = bool;
     end
    self.ten_btn = UIButton:create_switch_button( 19, 75, 60, 30, UILH_COMMON.dg_sel_1,UILH_COMMON.dg_sel_2,
                        LH_COLOR[2]..Lang.lingqi.upgrade[14], 50, 14, nil, nil, nil, nil, selected_ten_btn ); --一键十次
    --避免页面关闭后打开 选种情况未对应
    if switch_ten_var then
        selected_ten_btn()
    end
    down_panel:addChild(self.ten_btn.view);

    local  function get_fabao_info_level( )
        local fabao_info = FabaoModel:get_fabao_info( ) 
        if fabao_info then
             lingqi_level = fabao_info.level
        end 
    end 

 --升级按钮
   local function up_level_event(  )
        get_fabao_info_level()
        if lingqi_level ==FabaoConfig:get_fabao_max_level() then --如果满级 50级满级
            ConfirmWin2:show( 3, 0, LH_COLOR[2]..Lang.lingqi[11],  nil, nil, nil )
        else
           FabaoModel:req_up_fabao_level( self.crestal_select_index, self.switch_btn_var,switch_ten_var )
        end

    end
    local uplevel_btn = TextButton:create( nil, 165, 11, -1, -1, LH_COLOR[2]..Lang.lingqi.upgrade[15], UILH_COMMON.lh_button2 ) 
    uplevel_btn:setTouchClickFun(up_level_event)
    uplevel_btn.view:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.lh_button2_s)
    down_panel:addChild(uplevel_btn.view)
    return bg_panel
end

--创建一个美人图谱
function  LingqiUpLevelWin:create_one_beauty( panel_bg,x,y,width,height,index,can_light)
    local one_beauty = {}

    local  img_bg  = CCBasePanel:panelWithFile(x, y, width, height, UILH_COMMON.bg_02, 500, 500)

    one_beauty.view =  img_bg
    local  b_img = nil
    if can_light then
        b_img = beauty_img_array[index]
    else
        b_img = beauty_img_array_d[index]
    end
    one_beauty.b_img = b_img
    local beauty = CCZXImage:imageWithFile(1,69+3+20,-1,-1,b_img)                                                                                                                                                                                                                                                                     
    one_beauty.beauty = beauty
    local pai    = CCZXImage:imageWithFile(-4,-7,-1,-1,beauty_bg_array[index])
    one_beauty.pai = pai
    local name   = CCZXImage:imageWithFile(55,221,-1,-1,lingqi_name_list[index])
    one_beauty.name = name

    local attrs  = CCZXImage:imageWithFile(5,3,-1,-1,UILH_NORMAL.item_bg2)
    img_bg:addChild(attrs)
    local level_bg = nil
    local level_open = nil 
    if index ~= 1 then
           level_bg   = CCZXImage:imageWithFile(36,15,-1,-1,UILH_NORMAL.level_bg)
           level_open = CCZXImage:imageWithFile(12,11,-1,-1,lingqi_level_open[index])
           level_bg:addChild(level_open)
           beauty:addChild(level_bg)
    end

        --技能icon
    local icon   = CCZXImage:imageWithFile(12,12,-1,-1,meiren_config[index].icon)
    img_bg:addChild(icon)

    local attrs_txt = UILabel:create_lable_2(meiren_config[index].color..meiren_config[index].attrs[1][1],93, 43, 14,  ALIGN_LEFT )
    img_bg:addChild(attrs_txt)

    local attrs_value = UILabel:create_lable_2(meiren_config[index].color.."+"..meiren_config[index].attrs[1][2],97, 20, 14,  ALIGN_LEFT )
    img_bg:addChild(attrs_value)


    one_beauty.level_open = level_open
    
    --切换人物
    one_beauty.change_img_func = function(index,can_light)
            local max_level = FabaoConfig:get_fabao_max_level() 

            if(tonumber(index) == max_level/10+1) then
                --满级情况
                beauty_array[2].view:setIsVisible(false)
                index = max_level/10
                beauty_array[1].view:setPosition(x-117,y)
                self.jiantou:setIsVisible(false)
            end


             if can_light then
                beauty:setTexture(beauty_img_array[index])
                icon:setTexture(meiren_config[index].icon)
            else
                beauty:setTexture(beauty_img_array_d[index])
                icon:setTexture(meiren_config[index].icon_d)

            end
             pai:setTexture(beauty_bg_array[index])
             name:setTexture(lingqi_name_list[index])
             if level_open ~= nil then
                level_open:setTexture(lingqi_level_open[index])
             end
             
             --更新添加的技能属性
             if attrs_txt then 
                 attrs_txt:setString(meiren_config[index].color..meiren_config[index].attrs[1][1])
             end

             if attrs_value then
                attrs_value:setString(meiren_config[index].color.."+"..meiren_config[index].attrs[1][2])
             end
    end


    beauty:addChild(pai)
    pai:addChild(name)
    img_bg:addChild(beauty)
    panel_bg:addChild(one_beauty.view)

    table.insert(beauty_array,one_beauty)
end

--更新美女图
function LingqiUpLevelWin:change_img( index)
    if #beauty_array~= 0 then
        beauty_array[1].change_img_func(index,true)
        beauty_array[2].change_img_func(index+1,false)
    end
end

function LingqiUpLevelWin:update_fight_value( fight_value )
    if not _is_other_fabao then
        --打开自己的法宝界面才刷新这个战斗力
        self.fabao_fight:init( ""..fight_value );
       -- self.fabao_fight_lv:init(""..fight_value);
    end
end


--创建更新页面的美人预览
function LingqiUpLevelWin:create_left(panel,pos_x, pos_y, width, height, texture_name)
    local left_panel = CCBasePanel:panelWithFile(pos_x, pos_y, width, height, texture_name,500,500)
    
    --美人预览标题
    local l_title_bg = CCZXImage:imageWithFile( 3, 461, 420, 35, UILH_NORMAL.title_bg4, 500, 500 )
    local l_title_name =  UILabel:create_lable_2(Lang.lingqi.upgrade[18], 168, 10, font_size, ALIGN_LEFT ) 
    l_title_bg:addChild(l_title_name)
    left_panel:addChild(l_title_bg)

   --战斗力
    local fightValue_lab = CCZXImage:imageWithFile(138,434,-1,-1,UILH_ROLE.text_zhandouli);
    left_panel:addChild(fightValue_lab);

    self.fabao_fight = ZXLabelAtlas:createWithString("888",UIResourcePath.FileLocate.lh_other .. "number1_");
    self.fabao_fight:setPosition(220,437);
    left_panel:addChild(self.fabao_fight);
    

    --箭头
    self.jiantou = CCZXImage:imageWithFile(188, 292, -1, -1, UILH_LINGQI.jiantou)
    left_panel:addChild(self.jiantou)
    
    self.beauty1 =  self:create_one_beauty(left_panel,7,83,170,340,1,true)
    self.beauty2 =  self:create_one_beauty(left_panel,246,83,170,340,2,false)

    --炫耀
    local function show_fabao_func(  )
        FabaoModel:xuanyao_fabao(  );
    end
    self.show_btn = TextButton:create( nil, 164, 11, -1, -1, LH_COLOR[2]..Lang.lingqi.info[1], UILH_COMMON.lh_button2 ) 
    self.show_btn:setTouchClickFun(show_fabao_func)
    self.show_btn.view:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.lh_button2_s)
    left_panel:addChild(self.show_btn.view)
    panel:addChild(left_panel)

end


--------------------界面更新

-- --更新美女信息
-- function LingqiUpLevelWin:update_beauty_info(index,can_light,data)
--     -- self.beauty1
-- end


function LingqiUpLevelWin:active( show )
    -- print("LingqiUpLevelWin:active( show )")
    self:update();
    if ( show ) then
        -- 打开前先删除一次性的特效
        -- LuaEffectManager:stop_view_effect( 82,self.view );
        -- LuaEffectManager:stop_view_effect( 83,self.view );
        -- LuaEffectManager:stop_view_effect( 84,self.view );
        -- LuaEffectManager:stop_view_effect( 10015,self.view );
        -- LuaEffectManager:stop_view_effect( 9,self.view );
       -- self:update_crystal_count();

        if FabaoModel:if_can_upgrade( )==true then 
            -- LuaEffectManager:play_view_effect( 9, 215, 35, self.view, false )
        end        
    end
end


function LingqiUpLevelWin:selected_crystal( i )
    local yb,y ;
    if i==1 then
        yb = 10;
        -- y = 189;
          self.crystal_select_frame:setPosition(46,142)
    elseif i == 2 then
        yb = 25;
        -- y = 189-65;
          self.crystal_select_frame:setPosition(175,142)
    elseif i == 3 then
        yb = 80;
        -- y = 189-65*2;
          self.crystal_select_frame:setPosition(305,142)
    end
    self.use_yb.setString(string.format(Lang.lingqi.upgrade[16],yb)); -- [953]="材料不足时，使用%d元宝代替"

    self.crestal_select_index = i;
end

-- 更新晶石数量
function LingqiUpLevelWin:update_crystal_count(  )
    -- print("LingqiUpLevelWin:update_crystal_count  更新晶石数量............................")
    for i,item in ipairs(self.crystal_dict) do
        local num = ItemModel:get_item_count_by_id( _crystal_ids[i] );
        item:set_item_count(num);
        if num == 0 then
            item:set_icon_dead_color();
        else
            item:set_icon_light_color();
        end
    end

    local win  = UIManager:find_visible_window("lingqi_win")
    if win then 
        if win.lingqi_left then
        --更新一下提示
        win.lingqi_left:update_fabao_upgrade_tip()
        end
    end 
end

--刷新方法
function  LingqiUpLevelWin:update( update_type )
    -- print(" LingqiUpLevelWin:update( update_type )")
    --获得自己的法宝信息
    local fabao_info = FabaoModel:get_fabao_info( ) 
    if fabao_info then
        local level = fabao_info.level
        local max_level = FabaoConfig:get_fabao_max_level()
         local fabao_config = nil;
         local  next_fabao_config = nil;
        -- 更新法宝属性
            fabao_config = FabaoConfig:get_fabao( fabao_info.jingjie, fabao_info.level - (fabao_info.jingjie-1)*10 );
            if (tonumber(fabao_info.jingjie) == max_level/10) then

                 next_fabao_config = FabaoConfig:get_fabao( fabao_info.jingjie, fabao_info.level - (fabao_info.jingjie-1)*10 );
            else
            --下一级别属性
            next_fabao_config = FabaoConfig:get_fabao( fabao_info.jingjie+1, fabao_info.level - (fabao_info.jingjie-1)*10 );
            end
        --灵器等级
        self.level:setText( fabao_info.level );
        lingqi_level = fabao_info.level 
        local fight = fabao_info.fight;
        --战斗力
        self.fabao_fight:init( fight );
        --经验值
        self.progress_bar:setProgressValue( fabao_info.exp, fabao_config.baseAttrs.upExp );
            --更新基本属性和下一级属性
        self:update_fabao_upattr(fabao_config,next_fabao_config)
        --更新晶体数量
        self:update_crystal_count();
        -- 更新选择框

        --更新美女
        self:change_img(fabao_info.jingjie)
    end

    self.switch_btn_var = SetSystemModel:get_date_value_by_key( SetSystemModel.COST_UPGRADE_GEM );
    self.use_yb.set_state( self.switch_btn_var );
    --升级之后刷新精灵
    FabaoModel:flash_lingqi()
end

--更新基本属性和下一级属性
function  LingqiUpLevelWin:update_fabao_upattr(fabao_config,next_fabao_config)
    if fabao_config then
        if self.cur_at_attri then

        -- 攻击属性
        self.cur_at_attri.update_data(fabao_config.baseAttrs.baseAttrs[1]);
        -- 生命属性
        self.cur_hp_attri.update_data(fabao_config.baseAttrs.baseAttrs[2])
        -- 物理防御属性
        self.cur_wd_attri.update_data(fabao_config.baseAttrs.baseAttrs[3])
        -- 法术防御属性
        self.cur_md_attri.update_data(fabao_config.baseAttrs.baseAttrs[4])
        -- 暴击防御属性
        self.cur_bj_attri.update_data(fabao_config.baseAttrs.baseAttrs[5]);

         end    
    else
          if self.cur_at_attri then
        
            -- 攻击属性
            self.cur_at_attri.update_data("");
            -- 生命属性
            self.cur_hp_attri.update_data("")
            -- 物理防御属性
            self.cur_wd_attri.update_data("")
            -- 法术防御属性
            self.cur_md_attri.update_data("")
            -- 暴击防御属性
            self.cur_bj_attri.update_data("");

        end

    end

    --下一级别属性
    if next_fabao_config then
         if self.next_at_attri then 
               -- 攻击属性
            self.next_at_attri.update_data(next_fabao_config.baseAttrs.baseAttrs[1]);
            -- 生命属性
            self.next_hp_attri.update_data(next_fabao_config.baseAttrs.baseAttrs[2])
            -- 物理防御属性
            self.next_wd_attri.update_data(next_fabao_config.baseAttrs.baseAttrs[3])
            -- 法术防御属性
            self.next_md_attri.update_data(next_fabao_config.baseAttrs.baseAttrs[4])
            -- 暴击防御属性
            self.next_bj_attri.update_data(next_fabao_config.baseAttrs.baseAttrs[5]);

        end
    else
         if self.next_at_attri then 
               -- 攻击属性
                self.next_at_attri.update_data("");
                -- 生命属性
                self.next_hp_attri.update_data("")
                -- 物理防御属性
                self.next_wd_attri.update_data("")
                -- 法术防御属性
                self.next_md_attri.update_data("")
                -- 暴击防御属性
                self.next_bj_attri.update_data("");

         end
    end
   
end
-- 播放暴击特效
-- effect_type 1,初级晶石暴击 2,中级晶石暴击 3,高级晶石暴击
function LingqiUpLevelWin:play_cri_animation( effect_type )
    -- 暂时屏蔽
    -- local effect_id = 0;
    -- if ( effect_type == 1 ) then
    --     effect_id = 82;
    -- elseif effect_type == 2 then
    --     effect_id = 83;
    -- elseif effect_type == 3 then 
    --     effect_id = 84;
    -- end 
     LuaEffectManager:play_view_effect( 10015,750,263,self.view,false,5 );
end



function LingqiUpLevelWin:destroy(  )
    beauty_array = {}
    Window.destroy(self);

end
