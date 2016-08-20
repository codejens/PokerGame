-- OtherAttrPanel.lua
-- created by lyl on 2012-12-4
-- 人物属性窗口的属性显示面板

super_class.OtherAttrPanel()

require "utils/UI/UILabel"

local had_show_detail = false ;                  --是否已经显示详细面板
local detail_panel    = nil   ;                  --详细信息面板
local had_show_up_atta= false ;                   --是否已经显示提升战力窗口

--一些公用方法

--创建一个label，并且把label存储。使创建后可以动态修改显示的lable内容
local function create_lable( label, dimensions, item_pos_x , item_pos_y, fontsize, alignment, r, g, b, index , label_t)
    local labelttf = UILabel:create_label_1(label, dimensions, item_pos_x ,  item_pos_y, fontsize, alignment, r, g, b)
    if index ~= nil and label ~= nil then 
        label_t[ tostring(index) ] = labelttf
    end
    return labelttf
end

--根据获取数字图片名称
-- local function get_num_ima( one_num )
--     if one_num == "0" then
--         return UIResourcePath.FileLocate.normal .. "number0.png"
--     elseif one_num == "1" then
--         return UIResourcePath.FileLocate.normal .. "number1.png"
--     elseif one_num == "2" then
--         return UIResourcePath.FileLocate.normal .. "number2.png"
--     elseif one_num == "3" then
--         return UIResourcePath.FileLocate.normal .. "number3.png"
--     elseif one_num == "4" then
--         return UIResourcePath.FileLocate.normal .. "number4.png"
--     elseif one_num == "5" then
--         return UIResourcePath.FileLocate.normal .. "number5.png"
--     elseif one_num == "6" then
--         return UIResourcePath.FileLocate.normal .. "number6.png"
--     elseif one_num == "7" then
--         return UIResourcePath.FileLocate.normal .. "number7.png"
--     elseif one_num == "8" then
--         return UIResourcePath.FileLocate.normal .. "number8.png"
--     elseif one_num == "9" then
--         return UIResourcePath.FileLocate.normal .. "number9.png"
--     end
--     return UIResourcePath.FileLocate.normal .. "number0.png"
-- end

--把数字转成对应的数字图片:  显示的数字，起始坐标 x  y ,显示的底panel
-- local function change_num_to_ima( num ,star_x, star_y )
--     local image_num_obj =  {}
--     image_num_obj.view = CCZXImage:imageWithFile( star_x, star_y, 200, 20, "" )

--     -- 加入数字
--     image_num_obj.set_num = function( num_temp )
--         image_num_obj.view:removeAllChildrenWithCleanup(true)

--         local num_str = tostring(num_temp)  --把数字转成字符串
--         local i = 1                    --获取字符索引
--         if num_str ~= nil then
--             local a_char = string.sub(num_str, i, i)
--             while a_char ~= "" do
--                 --画图
--                 local num_ima = CCZXImage:imageWithFile( 16 * (i - 1), 0, 19, 22, get_num_ima( a_char )); --数字图片
--                 image_num_obj.view:addChild( num_ima )
--                 i = i + 1
--                 a_char = string.sub(num_str, i, i)
--             end
--         end
--     end

--     image_num_obj.set_num( num )

--     return image_num_obj
-- end

--创建一个文字按钮，用菜单item实现.参数：显示的字符串，坐标
function OtherAttrPanel:create_a_button(name, item_pos_x , item_pos_y)
    local labelttf = CCLabelTTF:labelWithString(name, CCSize(250,30), CCTextAlignmentCenter, "Arial", 15);
    labelttf:setPosition(CCPoint(item_pos_x,item_pos_y));
    local col1 = labelttf:getColor();
    col1.r = 255 ;
    col1.g = 100 ;
    col1.b = 100 ;
    labelttf:setColor(col1);
    local ccMenuItemLabel =  CCMenuItemLabel:itemWithLabel(labelttf);

    local function onClick(eventType)
        require "UI/UIManager";
        if had_show_detail == false then 
            if had_show_up_atta == true then
                UIManager:destroy_window("up_attack_win")
                had_show_up_atta = false
            end
            UIManager:show_window("user_detail_attr")
            had_show_detail = true;                    --标记面板已经显示
        else
            UIManager:destroy_window("user_detail_attr")
            --测试请求装备信息的消息
            require "control/UserEquipCC"
            UserEquipCC:request_get_equi();
            had_show_detail = false;
        end
    end
   -- ccMenuItemLabel:registerScriptHandler(onClick);  --设置触发的方法

    return ccMenuItemLabel;
end



--======================================
--ChaAttrPanel 属性显示面板
--用于布局属性和数值
--
--======================================

--ChaAttrPanel初始化方法
function OtherAttrPanel:__init( fath_Panel )
    self.label_t = {}       --存储文字label的table，这样可以动态地获取修改文字内容

    --背景
    local background = CCBasePanel:panelWithFile( 7, 10, 422, 557, UILH_COMMON.normal_bg_v2, 500, 500);  --方形区域
    fath_Panel:addChild( background )
    
    --显示所有属性
    self:addattribute( background )
    
    --综合战斗力
    -- local player = EntityManager:get_player_avatar()
    -- local all_atta_bg = CCNGBtnMulTex:buttonWithFile(0 , 19, -1, -1, UIResourcePath.FileLocate.normal .. "zonghe_zhanli.png")
    -- background:addChild( all_atta_bg )
    -- local all_atta_num = player.fightValue             --战力数值
    -- -- change_num_to_ima( all_atta_num ,110, 25, background)
    -- self.image_num_obj = change_num_to_ima( all_atta_num ,116, 20 )
    -- background:addChild( self.image_num_obj.view )
    
    -- -- --提升战斗力按钮
    -- local but_upgrade = CCNGBtnMulTex:buttonWithFile(230 , 0, 100, 33, "ui/common/button2_bg.png", 500, 500)
    -- but_upgrade:addTexWithFile(CLICK_STATE_DOWN, "ui/common/button2_bg.png")
    -- -- but_upgrade:addTexWithFile(ClickStateMove, "ui/common/button2_bg.png")
    -- local function but_upgrade_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then 
    --         UIManager:show_window("fight_value_win");
    --         return true
    --     end
    -- end
    -- but_upgrade:registerScriptHandler(but_upgrade_fun)  --注册
    -- background:addChild(but_upgrade)
    -- local but_upgrade_name = CCZXImage:imageWithFile( 5 , 8, 85, 20, "ui/character/up_atta1.png");  --按钮名称
    -- but_upgrade:addChild( but_upgrade_name )
    
    self.view = background
    -- self:flash(  )  -- 测试
end

--添加属性.注意要使用  sefl:来调用，因为数值lablettf要存储，以便动态修改
function OtherAttrPanel:addattribute( bgPanel )
    --获取角色属性
    local player = EntityManager:get_player_avatar()
    
    local sub_title_x = 34

    -- 三个背景
    local bg1 = CCZXImage:imageWithFile(13,409,395,124,UILH_COMMON.bottom_bg,500,500)
    bgPanel:addChild(bg1)
    local bg2 = CCZXImage:imageWithFile(13,270,395,125,UILH_COMMON.bottom_bg,500,500)
    bgPanel:addChild(bg2)
    local bg3 = CCZXImage:imageWithFile(13,55,395,201,UILH_COMMON.bottom_bg,500,500)
    bgPanel:addChild(bg3)

    -- 角色信息， 标题
    local char_info = CCZXImage:imageWithFile( sub_title_x, 504, -1, -1, UILH_NORMAL.title_bg3);  --背景框
    bgPanel:addChild( char_info )
    -- MUtils:create_zxfont(char_info,Lang.role_info.user_attr_panel.title1,134,16,CCTextAlignmentCenter,19);
    local title_img = CCZXImage:imageWithFile(356/2,49/2,-1,-1,UILH_ROLE.juesexingxi)
    title_img:setAnchorPoint(0.5,0.5)
    char_info:addChild(title_img)

    -- 基础信息标题
    local attr_info_back = CCZXImage:imageWithFile( sub_title_x, 365, -1, -1, UILH_NORMAL.title_bg3);
    bgPanel:addChild( attr_info_back )
    -- MUtils:create_zxfont(attr_info_back,Lang.role_info.user_attr_panel.title2,134,16,CCTextAlignmentCenter,19);
    local title_img = CCZXImage:imageWithFile(356/2,49/2,-1,-1,UILH_ROLE.jichushuxing)
    title_img:setAnchorPoint(0.5,0.5)
    attr_info_back:addChild(title_img)

    --高级属性标题
    local hight_attr_info_back = CCZXImage:imageWithFile( sub_title_x, 226, -1, -1, UILH_NORMAL.title_bg3);
    bgPanel:addChild( hight_attr_info_back )
    -- MUtils:create_zxfont(hight_attr_info_back,Lang.role_info.user_attr_panel.title3,134,16,CCTextAlignmentCenter,19);
    local title_img = CCZXImage:imageWithFile(356/2,49/2,-1,-1,UILH_ROLE.qitashuxing)
    title_img:setAnchorPoint(0.5,0.5)
    hight_attr_info_back:addChild(title_img)

	-- --字体相关固定值
    local fontsize = 20                                  --字体大小
    local lable_siz_w = 100                              --label尺寸的宽度值
    local lable_siz_h = fontsize                         --尺寸高度设置成和字体大小一样，就不会出现中文和数字不对齐的问题
    local dimensions = CCSize(lable_siz_w,lable_siz_h)   --lable尺寸
    local lable_inteval_x = 220                          --labelx坐标的间距
    local lable_inteva_y = lable_siz_h+15                   --labely坐标的间距

    --基准坐标
    local lable_nam_sta_x = 60                        --属性名称的起始x坐标
    local lable_nam_sta_y = 500                           --当到某一行，需要分块（距离更大）时，可以调整基准起始y坐标实现
    local lable_num_sta_x = lable_nam_sta_x + lable_siz_w -2 --属性数值的起始x坐标
    local lable_num_sta_y = lable_nam_sta_y               --当到某一行，需要分块（距离更大）时，可以调整基准起始y坐标实现
    local count = 1                                       --用于计算第几行，计算坐标

    --分隔线
    -- for j=0,2 do
    --     local fengeup_bg = CCZXImage:imageWithFile(5,290+j*20,320,-1,UIResourcePath.FileLocate.common .. "fenge_bg.png")
    --     bgPanel:addChild(fengeup_bg)
    -- end
    -- for i=0,7 do
    --     local fengedown_bg = CCZXImage:imageWithFile(5,100+i*20,320,-1,UIResourcePath.FileLocate.common .. "fenge_bg.png")
    --     bgPanel:addChild(fengedown_bg)
    -- end

    local default_font_size = 17
    -- 角色信息
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.role_name, dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )

    bgPanel:addChild( create_lable( player.name, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "name" , self.label_t) )
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.role_level, dimensions, lable_nam_sta_x + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.level, dimensions, lable_num_sta_x + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "level" , self.label_t) )

    -- local camp_name_t = {"#cff1493逍遥", "#c0000ff星辰", "#c00ff00逸仙"}
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.camp, dimensions, lable_nam_sta_x      + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( Lang.camp_info[player.camp] or "", dimensions, lable_num_sta_x + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "campPost" , self.label_t) )
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.charm, dimensions, lable_nam_sta_x      + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.charm, dimensions, lable_num_sta_x    + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "charm" , self.label_t) )

    local guild_name = LangGameString[1642] -- [1642]="未加入"
    require "model/GuildModel"
    local guild_info = GuildModel:get_user_guild_info( )
    if guild_info.if_join_guild == 0 then
        guild_name = guild_info.guild_name
    else
        guild_name = Lang.role_info.user_attr_panel.none_guild_info
    end
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.guild, dimensions, lable_nam_sta_x      + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 2, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( guild_name, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 2, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "guildId" , self.label_t) )



    -- 属性信息
    lable_nam_sta_y = lable_nam_sta_y - 140
    lable_num_sta_y = lable_nam_sta_y

    -- 不同职业，攻击的属性不同。天雷：物理攻击   蜀山：法术攻击    圆月：物理攻击  云华：法术攻击
    print("打印other角色信息  "..player.name..player.job)
    local atta_name_table = {Lang.role_info.user_attr_panel.phy_attack, Lang.role_info.user_attr_panel.magic_attack, Lang.role_info.user_attr_panel.phy_attack, Lang.role_info.user_attr_panel.magic_attack}
    local atta_value_table = {player.outAttack, player.innerAttack, player.outAttack, player.innerAttack}
    -- 生命
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.life, dimensions, lable_nam_sta_x          + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.maxHp, dimensions, lable_num_sta_x           + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "hp" , self.label_t) )
    -- 耐力
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.magic, dimensions, lable_nam_sta_x    + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.maxMp, dimensions, lable_num_sta_x  + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "mp" , self.label_t) )
    -- 攻击
    bgPanel:addChild( create_lable( atta_name_table[player.job], dimensions, lable_nam_sta_x        + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight, 209, 206, 163,"attack_type",self.label_t) )
    bgPanel:addChild( create_lable( atta_value_table[player.job], dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "innerAttack" , self.label_t) )
    -- 物理防御
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.phy_defence, dimensions, lable_nam_sta_x        + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.outDefence, dimensions, lable_num_sta_x   + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "outDefence" , self.label_t) )
    -- 精神防御
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.magic_defence, dimensions, lable_nam_sta_x        + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 2, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.innerDefence, dimensions, lable_num_sta_x + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 2, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "innerDefence" , self.label_t) )
    -- 命中
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.accurate, dimensions, lable_nam_sta_x    + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 2, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.hit, dimensions, lable_num_sta_x    + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 2, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "hit" , self.label_t) )

    lable_nam_sta_y = lable_nam_sta_y - 33-5
    lable_num_sta_y = lable_num_sta_y - 33-5

    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.dodge, dimensions, lable_nam_sta_x    + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 3, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.dodge, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 3, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "dodge" , self.label_t) )
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.criticalStrikes, dimensions, lable_nam_sta_x    + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 3, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.criticalStrikes, dimensions, lable_num_sta_x + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 3, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "criticalStrikes" , self.label_t) )
   
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.defCriticalStrikes, dimensions, lable_nam_sta_x                 + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 4, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.defCriticalStrikes, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 4, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "defCriticalStrikes" , self.label_t) )
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.criticalStrikesDamage, dimensions, lable_nam_sta_x                 + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 4, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    local criticalStrikesDamage_temp = UserInfoModel:calculate_( player.criticalStrikesDamage )
    bgPanel:addChild( create_lable( criticalStrikesDamage_temp.."%", dimensions, lable_num_sta_x + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 4, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "criticalStrikesDamage" , self.label_t) )

    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.attackAppend, dimensions, lable_nam_sta_x         + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 5, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.attackAppend, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 5, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "attackAppend" , self.label_t) )
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.outAttackDamageAdd, dimensions, lable_nam_sta_x         + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 5, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.outAttackDamageAdd, dimensions, lable_num_sta_x    + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 5, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "outAttackDamageAdd" , self.label_t) )

    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.subDef, dimensions, lable_nam_sta_x        + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 6, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.subDef, dimensions, lable_num_sta_x       + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 6, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "subDef" , self.label_t) )
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.inAttackDamageAdd, dimensions, lable_nam_sta_x        + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 6, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.inAttackDamageAdd, dimensions, lable_num_sta_x + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 6, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "inAttackDamageAdd" , self.label_t) )

    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.moveSpeed, dimensions, lable_nam_sta_x      + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 7, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.moveSpeed, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 7, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "moveSpeed" , self.label_t) )
    
    -- 经验条
    -- “升级经验”文字图片
    self.img_shengjijingyan = MUtils:create_zximg(bgPanel,UILH_ROLE.text_shengjijingyan,21, 30,-1,-1)
    -- 经验条背景    
    self.exp_bg = CCZXImage:imageWithFile( 100, 27, 300, 23, UILH_NORMAL.progress_bg, 500, 500 )   -- 经验条背景
    bgPanel:addChild( self.exp_bg )
    -- 经验“条”图片
    local player_exp = player.expH *(2^32) + player.expL
    local player_max_exp = player.maxExpH *(2^32) + player.maxExpL
    local exp_prog_long_per = ( player_exp / player_max_exp <= 1) and (player_exp / player_max_exp) or 1     -- 目前有当前血量大于最大血量的情况
    self.exp_prog = CCZXImage:imageWithFile( 111, 33, 277 * exp_prog_long_per, 12, UILH_NORMAL.progress_bar, 500, 500 )
    bgPanel:addChild( self.exp_prog , 5)
    -- 经验数字
    player_exp = UserInfoModel:big_num_show( player_exp )
    player_max_exp = UserInfoModel:big_num_show( player_max_exp )
    bgPanel:addChild( create_lable( player_exp.." / "..player_max_exp, dimensions, 250, 41, default_font_size-2, CCTextAlignmentCenter, 255, 255, 255, "exp" , self.label_t), 6)
    
end

-- 刷新所有数值，当服务器通知用户角色属性改变时，就调用这个方法，从新同步属性。(注意不要参数化)
-- 注意这个方法一定要用 本对象 来调用。因为要用到self.label_t  
-- 参数： 如果传参数，表示显示其他角色的信息。 如果没传参数，表示显示玩家自己的信息
function OtherAttrPanel:flash( player_obj )
    --获取角色
    local player = player_obj or EntityManager:get_player_avatar()

    self.label_t["name"]:setString( player.name  )
    self.label_t["level"]:setString( player.level )
    -- local camp_name_t = {"#cff1493逍遥", "#c0000ff星辰", "#c00ff00逸仙"}
    self.label_t["campPost"]:setString( Lang.camp_info[player.camp] or "" )

    local guild_name = player.guild_name or Lang.role_info.user_attr_panel.guild_unjoin
    self.label_t["guildId"]:setString( guild_name )
    -- require "model/GuildModel"
    -- local guild_info = GuildModel:get_user_guild_info( )
    -- if guild_info.if_join_guild == 0 then
    --     guild_name = guild_info.guild_name
    -- else
    --     guild_name = "无"
    -- end
    
    


    self.label_t["charm"]:setString( player.charm )  
    local atta_name_table = {Lang.role_info.user_attr_panel.phy_attack, Lang.role_info.user_attr_panel.magic_attack, Lang.role_info.user_attr_panel.phy_attack, Lang.role_info.user_attr_panel.magic_attack}
    local atta_value_table = {player.outAttack, player.innerAttack, player.outAttack, player.innerAttack}
    -- 攻击类型会改变，导致颜色会被重置成白色，在此重新设置一下文字颜色。
    self.label_t["attack_type"]:setString( "#cd1cea3"..atta_name_table[player.job] )
    self.label_t["innerAttack"]:setString( atta_value_table[player.job] )
    self.label_t["outDefence"]:setString( player.outDefence )
    self.label_t["innerDefence"]:setString( player.innerDefence )
    self.label_t["hp"]:setString( player.maxHp )
    self.label_t["mp"]:setString( player.maxMp )
    self.label_t["hit"]:setString( player.hit )
    self.label_t["dodge"]:setString( player.dodge )
    self.label_t["criticalStrikes"]:setString( player.criticalStrikes )
    self.label_t["defCriticalStrikes"]:setString( player.defCriticalStrikes )
    
    --避免会心数值传nil
    local criticalStrikesDamage_temp = nil
    if player.criticalStrikesDamage then
        criticalStrikesDamage_temp  = UserInfoModel:calculate_( player.criticalStrikesDamage )
    else
        criticalStrikesDamage_temp = 0
    end
       
    self.label_t["criticalStrikesDamage"]:setString( criticalStrikesDamage_temp.."%" )
    self.label_t["attackAppend"]:setString( player.attackAppend )

    -- 物理免伤是负数，要变成正数
    local outAttackDamageAdd = player.outAttackDamageAdd
    if type(outAttackDamageAdd) == "number" then 
        outAttackDamageAdd = math.abs( outAttackDamageAdd )
    end
    self.label_t["outAttackDamageAdd"]:setString( outAttackDamageAdd )
    self.label_t["subDef"]:setString( player.subDef )
    
        -- 物理免伤是负数，要变成正数
    local inAttackDamageAdd = player.inAttackDamageAdd
    if type(outAttackDamageAdd) == "number" then 
        inAttackDamageAdd = math.abs( inAttackDamageAdd )
    end
    self.label_t["inAttackDamageAdd"]:setString( inAttackDamageAdd )
    self.label_t["moveSpeed"]:setString( player.moveSpeed )

    if ( player.expH ~= nil ) and ( not player.expL  ~= nil ) then
        self.exp_bg:setIsVisible(true)
        self.img_shengjijingyan:setIsVisible(true)
        self.view:removeChild( self.exp_prog, true)
        local player_exp = player.expH *(2^32) + player.expL                          -- 玩家经验值
        local player_max_exp = player.maxExpH *(2^32) + player.maxExpL                -- 最大经验值
        local exp_prog_long_per = ( player_exp / player_max_exp <= 1) and (player_exp / player_max_exp) or 1     -- 控制不超出
        player_exp = UserInfoModel:big_num_show( player_exp )
        player_max_exp = UserInfoModel:big_num_show( player_max_exp )
        self.label_t["exp"]:setString( player_exp.." / "..player_max_exp )
        self.exp_prog = CCZXImage:imageWithFile( 111, 33, 277 * exp_prog_long_per, 12, UILH_NORMAL.progress_bar, 500, 500 )
        self.view:addChild( self.exp_prog )
    else
        self.exp_prog:setIsVisible(false)
        self.exp_bg:setIsVisible(false)
        self.img_shengjijingyan:setIsVisible(false)
        self.label_t["exp"]:setString("")
    end

    -- 战斗力
    -- self.image_num_obj.set_num( player.fightValue )
end

-- 刷新，重新同步装备数据
function OtherAttrPanel:update(  )
    self:flash()
end
