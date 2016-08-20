-- OtherEquipPanel.lua
-- created by lyl on 2012-12-4
-- 显示人物形象和装备的面板

super_class.OtherEquipPanel()

-- 每种装备类型的名字。提示字使用
-- local _equi_names_table = { "武器", "衣服", "帽子", "护腕", "裤子", "戒指", "项链", "饰品", "腰带", "鞋子", "婚戒", "", "足迹", "翅膀", "", "衣服,:时装","武器,:时装" }
local _equi_names_table = { LangGameString[393], LangGameString[394], LangGameString[1643], LangGameString[396], LangGameString[397], LangGameString[398], LangGameString[399], LangGameString[400], LangGameString[401], LangGameString[402], LangGameString[2123], "", LangGameString[2124], LangGameString[406], "", LangGameString[1644],LangGameString[1645] } 
-- [393]="武器" -- [394]="衣服" -- [1643]="帽子" -- [396]="护腕" -- [397]="裤子" -- [398]="戒指" -- [399]="项链" -- [400]="饰品" -- [401]="腰带" -- [402]="鞋子" -- [406]="翅膀" -- [1644]="衣服,:时装" -- [1645]="武器,:时装"
local _equip_name_pic = {
    "ui/renwu/wq.png",
    "ui/renwu/yf.png",
    "ui/renwu/dl.png",
    "ui/renwu/hw.png",
    "ui/renwu/rb.png",
    "ui/renwu/jz.png",
    "ui/renwu/xl.png",
    "ui/renwu/sp.png",
    "ui/renwu/he.png",
    "ui/renwu/rx.png",
    "ui/renwu/hj.png",
    "",
    "ui/renwu/gy.png",
    "ui/renwu/xjxj.png",
    "",
    "ui/renwu/sz.png",
    "ui/renwu/wqsz.png",
}

local _equipment_list = {}     -- 保存装备列表

-- 标记是否属于普通slot
local _normal_slot_flag_table = {
[1] = true,[2] = true,[3] = true,[4] = true,[5] = true,
[6] = true,[7] = true,[8] = true,[9] = true,[10] = true,
[15] = true,
}
-- 标记是否属于点击衣柜按钮后打开的slot
local _wardrobe_slot_flag_table = {
[11] = true,[13] = true,[14] = true,[16] = true,[17] = true,
}

function OtherEquipPanel:__init( bgPanel )
    print("OtherEquipPanel:__init( bgPanel )")
    self.slot_table = {}                 -- 记录所有slot，以便根据实际数据来获取到slot改变
    -- self.star_but_state = 1              -- 星星按钮的状态
    -- self.sun_but_state  = 1              -- 太阳按钮的状态
    -- self.label_t = {}       --存储文字label的table，这样可以动态地获取修改文字内容
    --获取角色属性
    local player = EntityManager:get_player_avatar()

    --背景
    local panel = CCBasePanel:panelWithFile( 7, 10, 422, 557, UILH_COMMON.normal_bg_v2, 500, 500);  --方形区域
    bgPanel:addChild( panel,2)

    -- local panel2 = CCBasePanel:panelWithFile( 0, 50, 415, 500, UILH_COMMON.bg_grid, 500, 500);  --方形区域
    -- panel:addChild( panel2)    

    --左背景
    -- left_panel = CCBasePanel:panelWithFile( 10, 60+20, 420,465+30, UIPIC_UserEquipPanel_000, 500, 500);  --方形区域
    -- panel:addChild( left_panel,3 )
    -- 右背景
    --  local right_panel = CCBasePanel:panelWithFile( 435, 60+20, 400,465+30, UIPIC_UserEquipPanel_002, 500, 500);  --方形区域
    -- panel:addChild( right_panel,3 )

     -- 底部背景
     local bt_panel = CCBasePanel:panelWithFile( 10, 8, 395,56, nil, 500, 500);  --方形区域
    panel:addChild( bt_panel,3 )

    -- 人物模型背景
    local half_bg_x = 10
    local half_bg_y = 60
    local left_half_bg = MUtils:create_zximg(panel,"nopack/BigImage/role_bg.png",half_bg_x,half_bg_y,196,525,0,0) 
    local right_half_bg = MUtils:create_zximg(panel,"nopack/BigImage/role_bg.png",half_bg_x+195,half_bg_y,196,525,0,0) 
    right_half_bg:setFlipX(true)

    --提升战力
    --  local function click_event( eventType )
    --     UIManager:show_window("fight_value_win");
    -- end
    -- local text_btn = TextButton:create(nil,150,140,120,40,"提升战力", UIPIC_UserEquipPanel_009)
    -- text_btn:setFontSize(16)
    -- text_btn:setTouchClickFun(click_event)
    -- left_panel:addChild(text_btn.view)

    -- 顶部的阵营文字和背景
    local zhengying_bg = MUtils:create_zximg(panel,UILH_NORMAL.level_bg,82,500,-1,-1) 
    -- MUtils:create_zximg(zhengying_bg,UILH_ROLE.text_zhenying,25,10,-1,-1)   -- 阵营
    self.zhenying = MUtils:create_zxfont(zhengying_bg,"",89/2,13,2,15);

    --顶部的人物名称、等级
    local job_name = Lang.job_info[ player.job ] or ""
    local player_name = player.name 
    self.name_lable = UILabel:create_label_1( "#c66ff66"..job_name.."#cffffff•#cffff00"..player_name , CCSize(200,15), 238, 521, 17, CCTextAlignmentCenter, 255, 255, 0)
    panel:addChild( self.name_lable )

    --综合战斗力
    local all_atta_bg = CCZXImage:imageWithFile(135,470,-1,-1,UILH_ROLE.text_zhandouli)
    panel:addChild(all_atta_bg)

    -- local player = EntityManager:get_player_avatar()
    local all_atta_num = player.fightValue             --战力数值
    local function get_num_ima( one_num )
        return string.format("ui/lh_other/number1_%d.png",one_num);
    end
    self.image_num_obj = ImageNumberEx:create(all_atta_num,get_num_ima,12)
    panel:addChild( self.image_num_obj.view )
    self.image_num_obj.view:setPosition(CCPointMake(237,480))

    -- 满装，星星按钮. 创建不同的按钮：根据不同状态显示 暗色的按钮或者两色的按钮
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            -- print("星星按下......")
            local strong_level = self:check_body_strong_all_level( _equipment_list )               -- 全身强化等级
            local equip_count = 10
            -- local equip_count  = OtherEquipPanel:statistics_equip_by_strong_level( strong_level )  -- 达到强化等级的数量
            print("星星按下......  ", strong_level )
            if strong_level < 4 then 
                strong_level = 4          -- 不够满装的时候 
                equip_count = OtherEquipPanel:statistics_equip_by_strong_level( 4 )
            end
            local player = EntityManager:get_player_avatar()
            local tips_date = { strong_level, equip_count, player.job }
            print("全身强化tip(strong_level, equip_count, player.job)", strong_level, equip_count, player.job  )
            TipsModel:show_strong_levels_tip( 400, 240, tips_date );
            return true
        end
        return true
    end

    --宝石
    local but_1 = CCNGBtnMulTex:buttonWithFile( 280, 420, -1, -1, UILH_ROLE.star)
    but_1:registerScriptHandler(but_1_fun)    --注册
    panel:addChild(but_1)
    self.star_but = but_1

    -- local but_1_black = CCNGBtnMulTex:buttonWithFile( 280, 420, -1, -1, UILH_ROLE.star)
    -- but_1_black:registerScriptHandler(but_1_fun)    --注册
    -- self.star_but_black = but_1_black
    -- panel:addChild(but_1_black)

    --满装，“太阳”按钮
    local function but_2_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then         
            local gem_level = self:calcultate_total_gem_level( _equipment_list )
            local player = EntityManager:get_player_avatar()
            local tips_date = { gem_level, player.job }
            TipsModel:show_stone_levels_tip( 400, 240, tips_date );
            return true
        end
        return true
    end

    local but_2 = CCNGBtnMulTex:buttonWithFile( 280, 370, -1, -1, UILH_ROLE.diamond)
    but_2:registerScriptHandler(but_2_fun)    --注册
    panel:addChild(but_2)
    self.sun_but = but_2

    -- local but_2_black = CCNGBtnMulTex:buttonWithFile( 280, 370, -1, -1, UILH_ROLE.diamond)
    -- but_2_black:registerScriptHandler(but_2_fun)    --注册
    -- panel:addChild(but_2_black)
    -- self.sun_but_black = but_2_black

    self:flash_star_sun(  )

    -- 衣柜按钮
    local function btn_wardrobe_function(eventType, x, y)
        if eventType == TOUCH_CLICK then  
            -- 切换显示装备槽 
            self:switch_display_slot()
            return true
        end
        return true
    end
    self.btn_wardrobe = MUtils:create_btn(panel, UILH_ROLE.role_button1,UILH_ROLE.role_button1,btn_wardrobe_function,102,65,79,80,10);
    self.btn_wardrobe_img = MUtils:create_zximg(self.btn_wardrobe,UILH_ROLE.text_yigui,19,30,-1,-1) -- 衣柜
    self.is_display_wardrobe = false

     -- 计算坐标的参数
    local equip_x_beg = 23
    local equip_y_beg = 450
    local equip_y_int = 95

    self.name_label_table = {}  -- 保存一下装备的名字label，有装备存在时进行隐藏（主要因为婚戒的背景是透明的，会显示底下文字）

     -- 真龙之魂
    self:create_one_equi_slot(panel, 15, 263, 90)

    -- 第一排. 注意类型排列不是有规律的。 按页游
    self:create_one_equi_slot(panel, 1, equip_x_beg, equip_y_beg - equip_y_int * 0)
    self:create_one_equi_slot(panel, 7, equip_x_beg, equip_y_beg - equip_y_int * 1)
    self:create_one_equi_slot(panel, 4, equip_x_beg, equip_y_beg - equip_y_int * 2)
    self:create_one_equi_slot(panel, 8, equip_x_beg, equip_y_beg - equip_y_int * 3)
    self:create_one_equi_slot(panel, 6, equip_x_beg, equip_y_beg - equip_y_int * 4)
    -- self:create_one_equi_slot(panel, 11, equip_x_beg, equip_y_beg - equip_y_int * 5)
    -- 第二排
    equip_x_beg = 330
    self:create_one_equi_slot(panel, 2, equip_x_beg, equip_y_beg - equip_y_int * 0)
    self:create_one_equi_slot(panel, 3, equip_x_beg, equip_y_beg - equip_y_int * 1)
    self:create_one_equi_slot(panel, 9, equip_x_beg, equip_y_beg - equip_y_int * 2)
    self:create_one_equi_slot(panel, 5, equip_x_beg, equip_y_beg - equip_y_int * 3)
    self:create_one_equi_slot(panel, 10,equip_x_beg, equip_y_beg - equip_y_int * 4)
    -- self:create_one_equi_slot(panel, 13,equip_x_beg, equip_y_beg - equip_y_int * 5)

    -- 下面横排
    -- equip_x_beg = 94
    -- local equip_x_int = 88
    -- equip_y_beg = 10
    
    -- self:create_one_equi_slot(panel, 17, equip_x_beg + equip_x_int * 0, equip_y_beg)
    -- self:create_one_equi_slot(panel, 14, equip_x_beg + equip_x_int * 1, equip_y_beg)
    -- self:create_one_equi_slot(panel, 16, equip_x_beg + equip_x_int * 2, equip_y_beg)

    -- 第三排衣柜
    equip_x_beg = 23
    self:create_one_equi_slot(panel, 17, equip_x_beg, equip_y_beg - equip_y_int * 0)
    self:create_one_equi_slot(panel, 11, equip_x_beg, equip_y_beg - equip_y_int * 1)
    self:create_one_equi_slot(panel, 16, equip_x_beg, equip_y_beg - equip_y_int * 2)
    self:create_one_equi_slot(panel, 13, equip_x_beg, equip_y_beg - equip_y_int * 3)
    self:create_one_equi_slot(panel, 14, equip_x_beg, equip_y_beg - equip_y_int * 4)

    self:syn_all_equi(  )

    self:create_user_model_show( panel )

    self.view = panel

    --发送帮派神兽祭坛信息
    -- GuildCC:client_send_guild_altar_info()  --请求    pet_level

    -- 右侧，人物属性页面
    -- self:addattribute(right_panel)
    -- 底部4个按钮页
    self:addBottomPanel(bt_panel)

    -- local long_bg = ZImage:create(background, UIResourcePath.FileLocate.role.."long_bg.png", 60,104,-1,-1)
    -- 点击任何地方，都要关闭： 全身强化详细属性面板
    -- local function f1(eventType,x,y)
    --     return false
    -- end
    -- background:registerScriptHandler(f1)    --注册

    -- local title_bg = CCZXImage:imageWithFile( 76, 337, -1, -1, UIResourcePath.FileLocate.common .. "test_bg.png");                 --角色名称处的背景
    -- local title_bg_size = title_bg:getSize()
    -- local title_bg_pos = title_bg:getPositionS()
    -- panel:addChild( title_bg )
    -- local center_bg = CCZXImage:imageWithFile( 10, 70, 313, 269, "ui/character/equi_center_bg.png");          --中央处的背景
    -- background:addChild( center_bg )
    -- local center_player = CCZXImage:imageWithFile( 15, 50, 275, 310, "ui/character/player.png");          --角色形象
    -- background:addChild( center_player )

    --顶部的人物名称、等级
    -- background:addChild( UILabel:create_label_1("角色名:  ", CCSize(100,15), 105, 344, 16, CCTextAlignmentRight, 105, 207, 97) )
    -- self.name_lable = UILabel:create_label_1( "#c66ff66"..Lang.job_info[player.job].."#cffffff•#cffff00"..player.name , CCSize(200,15), 170, 344, 16, CCTextAlignmentCenter, 255, 255, 0)
    -- background:addChild( self.name_lable )
    -- self.name_panel = QQVipInterface:create_qq_vip_info( player.QQVIP, "#c66ff66"..Lang.job_info[player.job]..LangGameString[1646]..player.name ) -- [1646]="#cffffff•#cffff00"
    -- panel:addChild( self.name_panel.view )
    -- local name_panel_size = self.name_panel.view:getSize()
    -- self.name_panel.view:setPosition( title_bg_pos.x + ( title_bg_size.width - name_panel_size.width ) / 2, title_bg_pos.y + name_panel_size.height / 5 )
    -- 满装，星星按钮. 创建不同的按钮：根据不同状态显示 暗色的按钮或者两色的按钮
    -- but_1:addTexWithFileEx(CLICK_STATE_DOWN,TYPE_GRAY,"ui/character/star.png")
    -- local function but_1_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then 
    --         -- print("星星按下......")
    --         local strong_level = self:check_body_strong_all_level( _equipment_list )               -- 全身强化等级
    --         local equip_count = 10
    --         -- local equip_count  = OtherEquipPanel:statistics_equip_by_strong_level( strong_level )  -- 达到强化等级的数量
    --         print("星星按下......  ", strong_level )
    --         if strong_level < 4 then 
    --             strong_level = 4          -- 不够满装的时候 
    --             equip_count = OtherEquipPanel:statistics_equip_by_strong_level( 4 )
    --         end
    --         local player = EntityManager:get_player_avatar()
    --         local tips_date = { strong_level, equip_count, player.job }
    --         print("全身强化tips：：：", strong_level, equip_count, player.job  )
    --         TipsModel:show_strong_levels_tip( 400, 240, tips_date );
    --         return true
    --     end
    --     return true
    -- end
    --底色
    -- local but_1_bg = CCZXImage:imageWithFile(208, 80, -1, -1, UIResourcePath.FileLocate.common .. "but_bg.png")
    -- background:addChild(but_1_bg)

    -- but_1:setIsVisible( false )

    -- local but_1_black = CCNGBtnMulTex:buttonWithFile( 218, 90, -1, -1, UIResourcePath.FileLocate.role .. "star.png" )
    -- but_1_black:registerScriptHandler(but_1_fun)    --注册
    -- self.star_but_black = but_1_black
    -- background:addChild(but_1_black)
    -- but_1_black:setIsVisible( false )

    -- 满装，“太阳”按钮
    -- but_2:addTexWithFileEx(CLICK_STATE_DOWN,TYPE_GRAY,"ui/character/sun.png")
    -- local function but_2_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then 
            
    --         local gem_level = self:calcultate_total_gem_level( _equipment_list )
    --         local player = EntityManager:get_player_avatar()
    --         local tips_date = { gem_level, player.job }
    --         TipsModel:show_stone_levels_tip( 400, 240, tips_date );
    --         print( "太阳按下。。。", gem_level )
            
    --         return true
    --     end
    --     return true
    -- end

    -- --底色
    -- local but_2_bg = CCZXImage:imageWithFile(73, 80, -1, -1, UIResourcePath.FileLocate.common .. "but_bg.png")
    -- background:addChild(but_2_bg)

    -- but_2:setIsVisible( false )

    -- local but_2_black = CCNGBtnMulTex:buttonWithFile( 83, 90, -1, -1, UIResourcePath.FileLocate.role .. "sun.png" )
    -- but_2_black:registerScriptHandler(but_2_fun)    --注册
    -- background:addChild(but_2_black)
    -- self.sun_but_black = but_2_black
    -- but_2_black:setIsVisible( false )

    -- -- 播放魔法阵特效
    -- LuaEffectManager:play_view_effect( 10012,170 ,160,background,true ,0);
    -- LuaEffectManager:play_view_effect( 10013,170 ,160,background,true ,2);
end

-- 切换显示普通的slot和衣柜的slot
function OtherEquipPanel:switch_display_slot()
    local display_wardrobe_state = not self.is_display_wardrobe;
    for item_type=1,17 do
        if _wardrobe_slot_flag_table[item_type] and self.slot_table[item_type] ~= nil then
            self.slot_table[ item_type ].view:setIsVisible(display_wardrobe_state)
        elseif _normal_slot_flag_table[item_type] and self.slot_table[item_type] ~= nil then
            self.slot_table[ item_type ].view:setIsVisible(not display_wardrobe_state)
        end
    end
    -- 显示衣柜槽的时候，隐藏星星按钮
    if display_wardrobe_state == true then
        self.sun_but:setIsVisible(false)
        self.star_but:setIsVisible(false)
        self.btn_wardrobe_img:setTexture(UILH_ROLE.text_zhuangbei)
    else
        self.sun_but:setIsVisible(true)
        self.star_but:setIsVisible(true)
        self.btn_wardrobe_img:setTexture(UILH_ROLE.text_yigui)
    end
    self.is_display_wardrobe = display_wardrobe_state;
end

--添加属性.注意要使用  sefl:来调用，因为数值lablettf要存储，以便动态修改
function OtherEquipPanel:addattribute( bgPanel )
    --获取角色属性
    local player = EntityManager:get_player_avatar()
    -- 名字标签和数值标签的RGB值，统一放外面设置
    local name_rgb_t = { 0, 210, 87}
    local num_rgb_t =  {250, 250, 250 }
    local exp_name_rgb_t = {255,97,0}
    -- 角色信息标题
    local jiaose_info_back = CCZXImage:imageWithFile( 2, 432+25, 130, 28, UIResourcePath.FileLocate.common .. "wzd-1.png",500,500 ); 
    bgPanel:addChild( jiaose_info_back )
    local jiaose_xinxi = CCZXImage:imageWithFile(60,28/2,-1,-1,UIResourcePath.FileLocate.renwu.."jsxx.png")
    jiaose_xinxi:setAnchorPoint(0.5,0.5)
    jiaose_info_back:addChild(jiaose_xinxi)

    -- 基础信息标题
    local attr_info_back = CCZXImage:imageWithFile( 2, 328+25, 130, 28, UIResourcePath.FileLocate.common .. "wzd-1.png",500,500 ); 
    bgPanel:addChild( attr_info_back )
    local shuxin_xinxi = CCZXImage:imageWithFile(60,28/2,-1,-1,UIResourcePath.FileLocate.renwu.."jcxx-1.png")
    shuxin_xinxi:setAnchorPoint(0.5,0.5)
    attr_info_back:addChild(shuxin_xinxi)

    --高级属性标题
    local hight_attr_info_back = CCZXImage:imageWithFile( 2, 200+25, 130, 28, UIResourcePath.FileLocate.common .. "wzd-1.png",500,500 ); 
    bgPanel:addChild( hight_attr_info_back )
    local shuxin_gaojixx = CCZXImage:imageWithFile(60,28/2,-1,-1,UIResourcePath.FileLocate.renwu.."gjsx.png")
    shuxin_gaojixx:setAnchorPoint(0.5,0.5)
    hight_attr_info_back:addChild(shuxin_gaojixx)
    
    -- --字体相关固定值
    local fontsize = 18                                  --字体大小
    local lable_siz_w = 100                              --label尺寸的宽度值
    local lable_siz_h = fontsize                         --尺寸高度设置成和字体大小一样，就不会出现中文和数字不对齐的问题
    local dimensions = CCSize(lable_siz_w,lable_siz_h)   --lable尺寸
    local lable_inteval_x = 235                          --labelx坐标的间距
    local lable_inteva_y = lable_siz_h + 10               --labely坐标的间距

    --基准坐标
    local lable_nam_sta_x = 55                           --属性名称的起始x坐标
    local lable_nam_sta_y = 410+25                          --当到某一行，需要分块（距离更大）时，可以调整基准起始y坐标实现
    local lable_num_sta_x = lable_nam_sta_x + lable_siz_w -2   --属性数值的起始x坐标
    local lable_num_sta_y = lable_nam_sta_y                    --当到某一行，需要分块（距离更大）时，可以调整基准起始y坐标实现
    local count = 1                                            --用于计算第几行，计算坐标

    local default_font_size = 18
    -- 角色信息
    -- 名称
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.role_name, dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )

    bgPanel:addChild( MUtils:create_lable( player.name, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "name" , self.label_t) )
    -- 等级
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.role_level, dimensions, lable_nam_sta_x + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.level, dimensions, lable_num_sta_x + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "level" , self.label_t) )

    -- local camp_name_t = {"#cff1493逍遥", "#c0000ff星辰", "#c00ff00逸仙"}
    -- 阵营
    --bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.camp, dimensions, lable_nam_sta_x      + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight,  name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    --bgPanel:addChild( MUtils:create_lable( Lang.camp_info[player.camp] or "", dimensions, lable_num_sta_x + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "campPost" , self.label_t) )
    -- 魅力
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.charm, dimensions, lable_nam_sta_x      + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight,  name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.charm, dimensions, lable_num_sta_x    + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "charm" , self.label_t) )
    -- 仙宗
    local guild_name = LangGameString[1642] -- [1642]="未加入"
    require "model/GuildModel"
    local guild_info = GuildModel:get_user_guild_info( )
    if guild_info.if_join_guild == 0 then
        guild_name = guild_info.guild_name
    else
        guild_name = Lang.role_info.user_attr_panel.none_guild_info
    end
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.guild, dimensions, lable_nam_sta_x      + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( guild_name, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft,num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "guildId" , self.label_t) )

    -- 属性信息 分行:调整lable_nam_sta_y既可
    lable_nam_sta_y = lable_nam_sta_y - 90-35 +23
    lable_num_sta_y = lable_nam_sta_y

    -- 不同职业，攻击的属性不同。天雷：物理攻击   蜀山：法术攻击    圆月：物理攻击  云华：法术攻击
    local atta_name_table = {Lang.role_info.user_attr_panel.phy_attack, Lang.role_info.user_attr_panel.magic_attack, Lang.role_info.user_attr_panel.phy_attack, Lang.role_info.user_attr_panel.magic_attack}
    local atta_value_table = {player.outAttack, player.innerAttack, player.outAttack, player.innerAttack}

     --生命
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.life, dimensions, lable_nam_sta_x        + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight,  name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.maxHp, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "hp" , self.label_t) )

    -- 攻击
    bgPanel:addChild( MUtils:create_lable( atta_name_table[player.job], dimensions, lable_nam_sta_x        + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( atta_value_table[player.job], dimensions, lable_num_sta_x   + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "innerAttack" , self.label_t) )

    -- 耐力(法力)
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.magic, dimensions, lable_nam_sta_x    + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight,  name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.maxMp, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "mp" , self.label_t) )

    -- 物理防御
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.phy_defence, dimensions, lable_nam_sta_x + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight,  name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.outDefence, dimensions, lable_num_sta_x + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft,num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "outDefence" , self.label_t) )

    -- 速度
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.moveSpeed, dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 2, default_font_size,  CCTextAlignmentRight,  name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.moveSpeed, dimensions, lable_num_sta_x + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 2, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "moveSpeed" , self.label_t) )

    -- 精神防御
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.magic_defence, dimensions, lable_nam_sta_x + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 2, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.innerDefence, dimensions, lable_num_sta_x + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 2, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "innerDefence" , self.label_t) )

   

    -- 高级属性 分行:调整lable_nam_sta_y既可
    lable_nam_sta_y = lable_nam_sta_y -35 -7
    lable_num_sta_y = lable_nam_sta_y

    -- 命中
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.accurate, dimensions, lable_nam_sta_x    + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 3, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.hit, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 3, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "hit" , self.label_t) )

     -- 物理免伤
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.outAttackDamageAdd, dimensions, lable_nam_sta_x + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 3, default_font_size,  CCTextAlignmentRight,  name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.outAttackDamageAdd, dimensions, lable_num_sta_x + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 3, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "outAttackDamageAdd" , self.label_t) )

    -- 闪避
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.dodge, dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 4, default_font_size,  CCTextAlignmentRight,  name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.dodge, dimensions, lable_num_sta_x + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 4, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "dodge" , self.label_t) )

     -- 法术(精神)免伤
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.inAttackDamageAdd, dimensions, lable_nam_sta_x+ lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 4, default_font_size,  CCTextAlignmentRight,  name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.inAttackDamageAdd, dimensions, lable_num_sta_x + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 4, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "inAttackDamageAdd" , self.label_t) )

    --暴击
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.criticalStrikes, dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 5, default_font_size,  CCTextAlignmentRight,  name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.criticalStrikes, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 5, default_font_size, CCTextAlignmentLeft,num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "criticalStrikes" , self.label_t) )

     -- 伤害追加
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.attackAppend, dimensions, lable_nam_sta_x + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 5, default_font_size,  CCTextAlignmentRight,  name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.attackAppend, dimensions, lable_num_sta_x + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 5, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "attackAppend" , self.label_t) )

    -- 抗暴击
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.defCriticalStrikes, dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 6, default_font_size,  CCTextAlignmentRight,  name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.defCriticalStrikes, dimensions, lable_num_sta_x + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 6, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "defCriticalStrikes" , self.label_t) )

    -- 无视防御
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.subDef, dimensions, lable_nam_sta_x + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 6, default_font_size,  CCTextAlignmentRight,  name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    bgPanel:addChild( MUtils:create_lable( player.subDef, dimensions, lable_num_sta_x  + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 6, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "subDef" , self.label_t) )

    -- 会心
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.criticalStrikesDamage, dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 7, default_font_size,  CCTextAlignmentRight, name_rgb_t[1],name_rgb_t[2],name_rgb_t[3]) )
    local criticalStrikesDamage_temp = UserInfoModel:calculate_( player.criticalStrikesDamage )
    bgPanel:addChild( MUtils:create_lable( criticalStrikesDamage_temp.."%", dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 7, default_font_size, CCTextAlignmentLeft, num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "criticalStrikesDamage" , self.label_t) )

    --分隔线
    ZImage:create(bgPanel, UIResourcePath.FileLocate.common .. "jgt_line.png" , 2, 45, 396,2)

    -- 经验条
    bgPanel:addChild( MUtils:create_lable( Lang.role_info.user_attr_panel.exp, dimensions, 60, 25, default_font_size, CCTextAlignmentRight,  exp_name_rgb_t[1],exp_name_rgb_t[2],exp_name_rgb_t[3], "exp_name_lable" , self.label_t) )

    self.exp_bg = CCZXImage:imageWithFile( 110, 15, 205, 17, UIResourcePath.FileLocate.common .. "common_progress_bg.png", 500, 500 )   -- 经验条背景
    bgPanel:addChild( self.exp_bg )
    -- player.hp = 500
    local player_exp = player.expH *(2^32) + player.expL
    local player_max_exp = player.maxExpH *(2^32) + player.maxExpL
    local exp_prog_long_per = ( player_exp / player_max_exp <= 1) and (player_exp / player_max_exp) or 1     
    -- 目前有当前血量大于最大血量的情况
    self.exp_prog = CCZXImage:imageWithFile( 112, 15, 205 * exp_prog_long_per - 3, 15, UIResourcePath.FileLocate.common .. "common_progress.png", 500, 500 )
    bgPanel:addChild( self.exp_prog , 5)
    -- 经验值
    player_exp = UserInfoModel:big_num_show( player_exp )
    player_max_exp = UserInfoModel:big_num_show( player_max_exp )
    bgPanel:addChild( MUtils:create_lable( player_exp.." / "..player_max_exp, dimensions, 210, 25, default_font_size, CCTextAlignmentCenter,num_rgb_t[1],num_rgb_t[2],num_rgb_t[3], "exp" , self.label_t), 6)    
end

--底部4个按钮：忍书、技能、buff、兑换
function OtherEquipPanel:addBottomPanel( bgPanel )
    -- local function btn_rs_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then
    --         LingGen:show()
    --     end
    --     return true
    -- end
    -- local function btn_jn_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then
    --         UIManager:show_window("user_skill_win")
    --     end
    --     return true
    -- end
    -- local function btn_buff_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then
    --         UIManager:show_window("user_buff_win")
    --     end
    --     return true
    -- end
    -- local function btn_dh_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then
    --         UIManager:show_window("exchange_win")
    --     end
    --     return true
    -- end
    -- -- 按钮
    -- self.renshu = MUtils:create_btn( bgPanel,UIPIC_UserEquipPanel_004, UIPIC_UserEquipPanel_004,btn_rs_fun,30,5,100,40)
    -- self.jn = MUtils:create_btn( bgPanel,UIPIC_UserEquipPanel_004, UIPIC_UserEquipPanel_004,btn_jn_fun,30+100+10,5,100,40)
    -- self.buff = MUtils:create_btn( bgPanel,UIPIC_UserEquipPanel_004, UIPIC_UserEquipPanel_004,btn_buff_fun,30+200+20,5,100,40)
    -- self.dh = MUtils:create_btn( bgPanel,UIPIC_UserEquipPanel_004, UIPIC_UserEquipPanel_004,btn_dh_fun,30+300+30,5,100,40)
    -- -- 地图
    -- MUtils:create_zximg( self.renshu, UIPIC_UserEquipPanel_008,15,10, -1, -1)
    -- MUtils:create_zximg( self.jn, UIPIC_UserEquipPanel_007,20,10, -1, -1)
    -- MUtils:create_zximg( self.buff, UIPIC_UserEquipPanel_005,25,11, -1, -1)
    -- MUtils:create_zximg( self.dh, UIPIC_UserEquipPanel_006,20,10, -1, -1)

    local function detail_info_btn_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            OtherEquipWin:open_other_attr_win()
        end
        return true
    end
    local btn_bg = UILH_COMMON.btn4_nor;
    local btn_bg_down = UILH_COMMON.btn4_sel;
    self.detail_info = MUtils:create_btn(bgPanel,btn_bg,btn_bg_down,detail_info_btn_fun,136,0,121,53);
    MUtils:create_zxfont(self.detail_info,Lang.role_info.user_equip_panel.btn_detail_info_description,121/2,22,2,15);
end

function OtherEquipPanel:show_detail_info_btn(is_show)
    self.detail_info:setIsVisible(is_show)
end

-- 激活窗口
function OtherEquipPanel:active( if_active )
    if if_active then
        -- local equi_infos = UserInfoModel:get_equi_info()
        -- self.showAvatar:change_attri("body",equi_infos);  
        -- self.showAvatar.avatar:playAction( ZX_ACTION_IDLE, 4, true )     -- 播放角色模型待机动画
        -- self.showAvatar:update_zhenlong( UserInfoModel:check_if_equip_zhenlong(  ) )
        -- -- 重新播放魔法阵特效 10, 70, 313, 269
        -- -- LuaEffectManager:stop_view_effect( 10012,left_panel);
        -- -- LuaEffectManager:stop_view_effect( 10013,left_panel);
        -- -- 播放魔法阵特效
        -- -- local effect_1=LuaEffectManager:play_view_effect( 10012,166+40 ,280,left_panel,true ,0);
        -- -- effect_1:setPosition(201,290)
        -- -- local effect_2=LuaEffectManager:play_view_effect( 10013,166+40 ,280,left_panel,true ,2);
        -- -- effect_2:setPosition(201,290)
    else
        -- self.showAvatar.avatar:resetShowAvatar();
    end
end


-- 创建一个人物模型显示
function OtherEquipPanel:create_user_model_show( panel )
    -- local player = EntityManager:get_player_avatar()
    -- local equip_info = UserInfoModel:get_equi_info();
    -- require "entity/ShowAvatar"
    -- self.showAvatar = ShowAvatar:create_user_panel_avatar( 200, 195,equip_info )
    -- self.showAvatar.avatar:setActionStept(ZX_ACTION_STEPT)
    -- self.showAvatar:update_zhenlong( UserInfoModel:check_if_equip_zhenlong(  ) )
    -- self.showAvatar.avatar:setScale( 1 )
    -- self.showAvatar.avatar:playAction(ZX_ACTION_IDLE, 4, true)
    -- panel:addChild( self.showAvatar.avatar, 1 )
end

-- -- 创建本类对象的方法
-- function UserEquipPanel:create( bgPanel )
--  return UserEquipPanel( bgPanel );
-- end


-- 创建一个装备slot. 参数：要加入的面板，类型(作为索引用)， 坐标， 大小
function OtherEquipPanel:create_one_equi_slot( fath_penel, item_type, po_x , po_y, width, height  )
    local width  = 67
    local height = 67
    local slotItem = SlotItem(width, height)
    slotItem.view:setEnableDoubleClick(true)
    slotItem:setPosition( po_x , po_y )     
    slotItem:set_enable_drag_out(false)

    if item_type ~= 15 then
        -- self.zhenlong_bg = ZCCSprite:create(  self.view, UIResourcePath.FileLocate.common.."but_bg.png" , 108, 304)
        slotItem:set_icon_bg_texture(UILH_COMMON.slot_bg,  -8, -8, 83, 83)   -- 背框, 15是真龙之魂，没有背景框
    end
    -- -- 默认提示文字  武器时装  服饰时装要分两排写
    if item_type == 16 or item_type == 17 then 
        local name_t = Utils:Split_old( _equi_names_table[item_type], ",:" ) 
        local label_temp1 = UILabel:create_lable_2( "#cffff00"..name_t[1], 33, 39, 16, ALIGN_CENTER )
        slotItem.view:addChild(label_temp1)
        local label_temp2 = UILabel:create_lable_2( "#cffff00"..name_t[2], 33, 16, 16, ALIGN_CENTER )
        slotItem.view:addChild(label_temp2)
        self.name_label_table[item_type] = {}
        self.name_label_table[item_type][1] = label_temp1
        self.name_label_table[item_type][2] = label_temp2
    else
        local label_temp = UILabel:create_label_1(_equi_names_table[item_type], CCSize(100,15), 33, 36, 16, CCTextAlignmentCenter, 255, 255, 0)    
        self.name_label_table[item_type] = label_temp
        slotItem.view:addChild( label_temp )           --因为lable要随slot共存亡，所以是添加到slot的view中
    end
    -- 装备类型的提示文字图片
    -- local text_img = CCSprite:spriteWithFile(_equip_name_pic[item_type])
    -- text_img:setPosition(slotItem.width / 2, slotItem.height / 2)
    -- slotItem.view:addChild( text_img ) 

    -- 单击触发
    local function click_fn()
        if slotItem.item_base and slotItem.item_base.name then
            if item_type == 11 then
                -- 结婚戒指
                slotItem.item_player.other_marry_ring = true;
            end
            -- TipsModel:show_tip( 212, 270, slotItem.item_player, nil, nil, true,nil,nil,TipsModel.LAYOUT_RIGHT )     
            -- UserInfoModel:show_equip_tips( slotItem.item_player.series )
            TipsModel:show_tip( 260, 380, slotItem.item_player, nil, nil, true, nil, nil, TipsModel.LAYOUT_RIGHT )
        end
    end
    slotItem:set_click_event( click_fn )
    -- 双击触发
    local function double_click_fn()
        
    end
    slotItem:set_double_click_event( double_click_fn )
    
    slotItem.item_player = nil
    slotItem.item_base   = nil

    self.slot_table[ item_type ] = slotItem
    fath_penel:addChild( slotItem.view, 999 )

    -- 按下衣柜按钮后才会显示的slot先隐藏
    if _wardrobe_slot_flag_table[item_type] then
        slotItem.view:setIsVisible(false)
    end
end


-- 同步所有装备
function OtherEquipPanel:syn_all_equi(  )
    local equi_infos = UserInfoModel:get_equi_info()
    local item_base = nil
    for i, equipment in ipairs(equi_infos) do
        require "model/ItemModel"
        item_base = ItemConfig:get_item_by_id( equipment.item_id )
        self:set_one_equi( equipment, item_base )
    end
end

-- 根据传入数据，设置单个设备
function OtherEquipPanel:set_one_equi( item_player, item_base )
    if item_player == nil or item_base == nil then
        return
    end
    local slotItem = self.slot_table[ item_base.type ]
    if slotItem == nil then
        return
    end

    if item_base.type <= 11 then
        slotItem:set_color_frame( item_player.item_id, -1, -1, 69, 69 )
    end
    if item_base.type ~= 15 then        -- 真龙之魂不用 设置锁等
        slotItem:set_lock(true)
        slotItem:set_strong_level( item_player.strong )
    end
    
    if item_base.type == ItemConfig.ITEM_TYPE_MARRIAGE_RING then
        slotItem:set_strong_level( 0 ); 
    end

    -- 设置一下namelabel隐藏（因为婚戒的背景是透明的，会显示底下文字）
    if self.name_label_table[item_base.type] ~= nil then
        -- 分两行的label
        if item_base.type == 16 or item_base.type == 17 then
            self.name_label_table[item_base.type][1]:setIsVisible(false)
            self.name_label_table[item_base.type][2]:setIsVisible(false)
        else
            self.name_label_table[item_base.type]:setIsVisible(false)
        end
    end

    slotItem:set_icon( item_player.item_id )
    local pj = ItemModel:get_item_pj( item_base )
    slotItem:set_item_quality( item_player.void_bytes_tab[1],pj );
    
    slotItem.item_player = item_player
    slotItem.item_base = item_base
end

-- 初始化所有装备slot
function OtherEquipPanel:init_all_equi(  )
    for i, slotItem in pairs(self.slot_table) do
        slotItem.item_player = nil
        slotItem.item_base   = nil
        slotItem:set_icon_texture( "" )
        slotItem:set_lock(false)
        slotItem:set_color_frame( 0 )
        slotItem:set_strong_level( 0 )
        slotItem:set_item_quality()

        -- 设置一下namelabel出现（因为婚戒的背景是透明的，会显示底下文字）
        if self.name_label_table[i] ~= nil then
            -- 分两行的label
            if i == 16 or i == 17 then
                self.name_label_table[i][1]:setIsVisible(true)
                self.name_label_table[i][2]:setIsVisible(true)
            else
                self.name_label_table[i]:setIsVisible(true)
            end
        end
    end
end

-- 刷新模型
function OtherEquipPanel:update_avatar( player_obj, if_zhenlong )

    if self.player_img then
        self.player_img:removeFromParentAndCleanup(true)
        self.player_img = nil;
    end
    if self.effect_sprite then
        self.effect_sprite:removeFromParentAndCleanup(true)
        self.effect_sprite = nil;
    end

    local img_position = {{x = -76,y = 75},{x = 9,y = 94},{x = 33,y = 107},{x = 62,y = 63}}
    if player_obj.job and player_obj.sex then
        local file = string.format("nopack/body/%d%d.png",player_obj.job,player_obj.sex);
        self.player_img = CCZXImage:imageWithFile(img_position[player_obj.job].x,img_position[player_obj.job].y,-1,-1,file)
        self.player_img:setScale(0.6)
        if player_obj.job == 2 then
            self.player_img:setFlipX(true)
        end
        self.view:addChild( self.player_img)
    end
    -- 原画加上特效
    local img_effects_config = {
        [1] = {effect_id = 11040, x = 48, y = 312, flipx = false,scale = 1.2},
        [2] = {effect_id = 11044, x = 81, y = 236, flipx = true,scale = 1.2},
        [3] = {effect_id = 11046, x = 269, y = 426, flipx = false,scale = 1.2},
        [4] = {effect_id = 11043, x = 247, y = 414, flipx = false,scale = 0.6},
    } 
    if img_effects_config[player_obj.job] then
        local config_tmp = img_effects_config[player_obj.job];
        self.effect_sprite = LuaEffectManager:play_view_effect( config_tmp.effect_id,200,200,self.view,true)
        self.effect_sprite:setPosition(config_tmp.x,config_tmp.y)
        self.effect_sprite:setScale(config_tmp.scale)
        if config_tmp.flipx == true then
            self.effect_sprite:setFlipX(true)
        end
    end

    -- self.showAvatar:other_player_change_attri( "body", player_obj )
    -- self.showAvatar:other_player_change_attri( "wing", player_obj )
    -- self.showAvatar:other_player_change_attri( "weapon", player_obj )
    -- self.showAvatar:update_zhenlong( if_zhenlong )
end

-- 刷新，重新同步装备数据
function OtherEquipPanel:update()
    local player = EntityManager:get_player_avatar()
    -- QQVipInterface:reinit_info(self.name_panel, player.QQVIP, "#c66ff66"..Lang.job_info[player.job]..LangGameString[1646]..player.name ) -- [1646]="#cffffff•#cffff00"
    self.name_lable:setString( "#c66ff66"..Lang.job_info[player.job].."#cffffff•#cffff00"..player.name )
    self:init_all_equi()
    -- self:syn_all_equi()
    -- self:flash_star_sun(  )
    -- self.showAvatar.avatar:playAction( ZX_ACTION_IDLE, 4, true )     -- 播放角色模型待机动画
    -- 重新播放魔法阵特效 10, 70, 313, 269
    -- LuaEffectManager:stop_view_effect( 10012,self.view);
    -- LuaEffectManager:stop_view_effect( 10013,self.view);
    -- -- 播放魔法阵特效
    -- LuaEffectManager:play_view_effect( 10012,170 ,160,self.view,true ,0);
    -- LuaEffectManager:play_view_effect( 10013,170 ,160,self.view,true ,2);
end

-- 显示其他角色的装备
function OtherEquipPanel:show_other_equipment(  )
    self:init_all_equi()
end

-- 根据装备列表显示装备
function OtherEquipPanel:show_equip_by_equip_list( equipment_list, player_obj)
    _equipment_list = equipment_list
    -- print("根据装备列表显示装备OtherEquipPanel:show_equip_by_equip_list!!!!!!!!!!!")
    if type( equipment_list ) ~= "table" then
        return
    end
    local item_base = nil
    for i, equipment in ipairs(equipment_list) do
        require "model/ItemModel"
        item_base = ItemConfig:get_item_by_id( equipment.item_id )
        self:set_one_equi( equipment, item_base )
    end

    if player_obj then
        print("player_obj.job,player_obj.name",player_obj.job,player_obj.name)
        -- QQVipInterface:reinit_info(self.name_panel, player_obj.QQVIP, "#c66ff66"..Lang.job_info[player_obj.job]..LangGameString[1646]..player_obj.name ) -- [1646]="#cffffff•#cffff00"
        self.name_lable:setString( "#c66ff66"..Lang.job_info[player_obj.job].."#cffffff•#cffff00"..player_obj.name )
        local if_zhenlong = OtherEquipPanel:check_if_zhenlong( equipment_list )
        self:update_avatar( player_obj, if_zhenlong )
        self:flash(player_obj)

    else
        -- QQVipInterface:reinit_info(self.name_panel, 0, "" )
        self.name_lable:setString( "" )
    end
end

-- 刷新所有数值，当服务器通知用户角色属性改变时，就调用这个方法，从新同步属性。(注意不要参数化)
-- 注意这个方法一定要用 本对象 来调用。因为要用到self.label_t  
-- 参数： 如果传参数，表示显示其他角色的信息。 如果没传参数，表示显示玩家自己的信息
function OtherEquipPanel:flash( player_obj )
    --获取角色
    local player = player_obj or EntityManager:get_player_avatar()

    -- self.label_t["name"]:setString( player.name  )
    -- self.label_t["level"]:setString( player.level )
    -- -- local camp_name_t = {"#cff1493逍遥", "#c0000ff星辰", "#c00ff00逸仙"}
    -- -- self.label_t["campPost"]:setString( Lang.camp_info[player.camp] or "" )
    -- local guild_name = LangGameString[1642] -- [1642]="未加入"
    -- require "model/GuildModel"

    -- if player_obj.guild_name ~= nil then
    --     guild_name = player_obj.guild_name
    -- end

    -- self.label_t["guildId"]:setString( guild_name )
    -- self.label_t["charm"]:setString( player.charm )  

    -- local atta_value_table = {player.outAttack, player.innerAttack, player.outAttack, player.innerAttack}
    -- self.label_t["innerAttack"]:setString( atta_value_table[player.job] )
    -- self.label_t["outDefence"]:setString( player.outDefence )
    -- self.label_t["innerDefence"]:setString( player.innerDefence )
    -- self.label_t["hp"]:setString( player.maxHp )
    -- self.label_t["mp"]:setString( player.maxMp )
    -- self.label_t["hit"]:setString( player.hit )
    -- self.label_t["dodge"]:setString( player.dodge )
    -- self.label_t["criticalStrikes"]:setString( player.criticalStrikes )
    -- self.label_t["defCriticalStrikes"]:setString( player.defCriticalStrikes )
    -- local criticalStrikesDamage_temp = UserInfoModel:calculate_( player.criticalStrikesDamage )
    -- self.label_t["criticalStrikesDamage"]:setString( criticalStrikesDamage_temp.."%" )
    -- self.label_t["attackAppend"]:setString( player.attackAppend )

    -- -- 物理免伤是负数，要变成正数
    -- local outAttackDamageAdd = player.outAttackDamageAdd
    -- if type(outAttackDamageAdd) == "number" then 
    --     outAttackDamageAdd = math.abs( outAttackDamageAdd )
    -- end
    -- self.label_t["outAttackDamageAdd"]:setString( outAttackDamageAdd )
    -- self.label_t["subDef"]:setString( player.subDef )

    -- -- 物理免伤是负数，要变成正数
    -- local inAttackDamageAdd = player.inAttackDamageAdd
    -- if type(outAttackDamageAdd) == "number" then 
    --     inAttackDamageAdd = math.abs( inAttackDamageAdd )
    -- end
    -- self.label_t["inAttackDamageAdd"]:setString( inAttackDamageAdd )
    -- self.label_t["moveSpeed"]:setString( player.moveSpeed )

    -- if ( player.expH ~= nil ) and ( not player.expL  ~= nil ) then
    --     self.exp_bg:setIsVisible(true)
    --     self.label_t["exp_name_lable"]:setIsVisible(true)
    --     self.view:removeChild( self.exp_prog, true)
    --     local player_exp = player.expH *(2^32) + player.expL                          -- 玩家经验值
    --     local player_max_exp = player.maxExpH *(2^32) + player.maxExpL                -- 最大经验值
    --     local exp_prog_long_per = ( player_exp / player_max_exp <= 1) and (player_exp / player_max_exp) or 1     -- 控制不超出
    --     player_exp = UserInfoModel:big_num_show( player_exp )
    --     player_max_exp = UserInfoModel:big_num_show( player_max_exp )
    --     self.label_t["exp"]:setString( player_exp.." / "..player_max_exp )
    --     self.exp_prog = CCZXImage:imageWithFile( 92, 65, 205 * exp_prog_long_per - 3, 15, UIResourcePath.FileLocate.common .. "common_progress.png", 500, 500 )
    --     self.view:addChild( self.exp_prog )
    -- else
    --     self.exp_prog:setIsVisible(false)
    --     self.exp_bg:setIsVisible(false)
    --     self.label_t["exp_name_lable"]:setIsVisible(false)
    --     self.label_t["exp"]:setString("")
    -- end

    -- 战斗力
    self.image_num_obj:set_number( player.fightValue )
    -- 阵营
    self.zhenying:setText(Lang.camp_info_ex[player.camp].color..Lang.camp_info[player.camp])
end

-- 判断列表中是否包含真龙之魂
function OtherEquipPanel:check_if_zhenlong( equipment_list )
    for key, equipment in pairs(equipment_list) do
        if equipment.item_id == 11500 then 
            return true
        end
    end
    return false
end

-- 两个 满装 按钮的显示
function OtherEquipPanel:flash_star_sun(  )
    -- 星星按钮
    -- if self:check_strengthen_level() then
    --     self.star_but:setIsVisible(true)
    --     self.star_but_black:setIsVisible(false)
    -- else
    --     self.star_but:setIsVisible(false)
    --     self.star_but_black:setIsVisible(true)
    -- end
    -- -- 太阳按钮
    -- if self:check_body_gem_level() then
    --     self.sun_but:setIsVisible(true)
    --     self.sun_but_black:setIsVisible(false)
    -- else
    --     self.sun_but:setIsVisible(false)
    --     self.sun_but_black:setIsVisible(true)
    -- end
end

-- 检查强化满装等级(星星)
function OtherEquipPanel:check_strengthen_level(  )
    require "model/UserInfoModel"
    local user_equi_date = _equipment_list or {}
    local if_star_light = false              -- 装备的强化等级是否可以亮星星
    local count = 0                         -- 必须装备了是个装备才可以
    for i, equipment in pairs(user_equi_date) do
        if equipment.strong >= 4 then
            count = count + 1
        end
    end
    if count >= 10 then
        if_star_light = true
    end
    return if_star_light
end

-- 算出人物身上装备的强化等级
function OtherEquipPanel:check_body_strong_all_level(  )
    if _equipment_list == nil then 
        return 0
    end
    
    -- 检查所有装备的强化等级是否大于这个level
    local function check_level( level )
        if #_equipment_list ~= 0  then
            local _temp_equip_list = {};
            -- 将所有非装备的物品排除，如翅膀和时装
            for i,v in pairs(_equipment_list) do
                if UserInfoModel:check_item_if_be_equipment( v.item_id ) then
                    _temp_equip_list[#_temp_equip_list+1] = v;
                end
            end

            for i,equipment in ipairs(_temp_equip_list) do
                if equipment.strong < level then 
                    -- 小于给定的强化等级时返回false
                    print("有装备强化等级",equipment.strong,"小于",level,"   id",equipment.item_id,
                    ItemConfig:get_item_name_by_item_id(equipment.item_id));

                    return false;
                end
            end

            return true;
        end    
    end

    local level = 0;
    for i = 4, 15 do 
        if check_level(i) and #_equipment_list >= 10 then

            level=i;
            print("强化",level);
        else
            break;
        end
    end
    
    return level;
end

-- 计算大于某个强化等级的装备数量
function OtherEquipPanel:statistics_equip_by_strong_level( strong_level )
    local equip_count = 0
    for key, equip in pairs(_equipment_list) do 
        if equip.strong >= strong_level then 
            equip_count = equip_count + 1
        end
    end
    return equip_count
end


-- 检查宝石满装等级（圆）
function OtherEquipPanel:check_body_gem_level(  )
    local ret = false
    local gem_level_total = OtherEquipPanel:calcultate_total_gem_level( _equipment_list )
    
    if gem_level_total > 99 then
        ret = true
    end
    return ret
end

-- 计算所有宝石总的等级
function OtherEquipPanel:calcultate_total_gem_level( user_equi_date )
    local user_equi_date = user_equi_date or {}
    local gem_level_total = 0
    -- 统计所有宝石的等级
    for i, equipment in pairs(user_equi_date) do
        if UserInfoModel:check_item_if_be_equipment( equipment.item_id )  then
            gem_level_total = gem_level_total + self:get_equi_gem_level(equipment)
        end
    end
    return gem_level_total
end


-- 获取一个装备，总的宝石等级
function OtherEquipPanel:get_equi_gem_level( equipment )
    local equi_gem_level_count = 0
    if equipment == nil then
        return equi_gem_level_count
    end
    if equipment.holes[1] ~= 0 then
        equi_gem_level_count = equi_gem_level_count + self:get_one_gem_level( equipment.holes[1] )
    end
    if equipment.holes[2] ~= 0 then
        equi_gem_level_count = equi_gem_level_count + self:get_one_gem_level( equipment.holes[2] )
    end
    if equipment.holes[3] ~= 0 then
        equi_gem_level_count = equi_gem_level_count + self:get_one_gem_level( equipment.holes[3] )
    end
    return equi_gem_level_count
end

-- 获取宝石的等级
function OtherEquipPanel:get_one_gem_level( gem_id )
    if gem_id == nil then
        return 0
    end
    require "config/ItemConfig"
    local item_base = ItemConfig:get_item_by_id( gem_id )
    if item_base then
        return item_base.suitId
    end
    return 0
end
