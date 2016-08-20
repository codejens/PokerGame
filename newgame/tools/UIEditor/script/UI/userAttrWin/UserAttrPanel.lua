-- UserAttrPanel.lua
-- created by lyl on 2012-12-4
-- 人物属性窗口的属性显示面板

super_class.UserAttrPanel()

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
--[[
--根据获取数字图片名称
local function get_num_ima( one_num )
    if one_num == "0" then
        return UIResourcePath.FileLocate.normal .. "number0.png"
    elseif one_num == "1" then
        return UIResourcePath.FileLocate.normal .. "number1.png"
    elseif one_num == "2" then
        return UIResourcePath.FileLocate.normal .. "number2.png"
    elseif one_num == "3" then
        return UIResourcePath.FileLocate.normal .. "number3.png"
    elseif one_num == "4" then
        return UIResourcePath.FileLocate.normal .. "number4.png"
    elseif one_num == "5" then
        return UIResourcePath.FileLocate.normal .. "number5.png"
    elseif one_num == "6" then
        return UIResourcePath.FileLocate.normal .. "number6.png"
    elseif one_num == "7" then
        return UIResourcePath.FileLocate.normal .. "number7.png"
    elseif one_num == "8" then
        return UIResourcePath.FileLocate.normal .. "number8.png"
    elseif one_num == "9" then
        return UIResourcePath.FileLocate.normal .. "number9.png"
    end
    return UIResourcePath.FileLocate.normal .. "number0.png"
end

--把数字转成对应的数字图片:  显示的数字，起始坐标 x  y ,显示的底panel
local function change_num_to_ima( num ,star_x, star_y )
    local image_num_obj =  {}
    image_num_obj.view = CCZXImage:imageWithFile( star_x, star_y, 200, 20, "" )

    -- 加入数字
    image_num_obj.set_num = function( num_temp )
        image_num_obj.view:removeAllChildrenWithCleanup(true)

        local num_str = tostring(num_temp)  --把数字转成字符串
        local i = 1                    --获取字符索引
        if num_str ~= nil then
            local a_char = string.sub(num_str, i, i)
            while a_char ~= "" do
                --画图
                local num_ima = CCZXImage:imageWithFile( 16 * (i - 1), 0, 19, 22, get_num_ima( a_char )); --数字图片
                image_num_obj.view:addChild( num_ima )
                i = i + 1
                a_char = string.sub(num_str, i, i)
            end
        end
    end

    image_num_obj.set_num( num )

    return image_num_obj
end
]]--
--创建一个文字按钮，用菜单item实现.参数：显示的字符串，坐标
function UserAttrPanel:create_a_button(name, item_pos_x , item_pos_y)
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
    ccMenuItemLabel:registerScriptHandler(onClick);  --设置触发的方法

    return ccMenuItemLabel;
end



--======================================
--ChaAttrPanel 属性显示面板
--用于布局属性和数值
--
--======================================

--ChaAttrPanel初始化方法
function UserAttrPanel:__init( fath_Panel )
    self.label_t = {}       --存储文字label的table，这样可以动态地获取修改文字内容

    --背景
    local background = CCBasePanel:panelWithFile( 7, 10, 422, 557, UILH_COMMON.normal_bg_v2, 500, 500);  --方形区域
    fath_Panel:addChild( background )
    
    --显示所有属性
    self:addattribute( background )
    
    --综合战斗力
    -- local player = EntityManager:get_player_avatar()
    -- local all_atta_bg = CCZXImage:imageWithFile(-5 , 19, -1, -1, UIResourcePath.FileLocate.normal .. "zonghe_zhanli.png")
    -- background:addChild( all_atta_bg )
    -- local all_atta_num = player.fightValue             --战力数值
    -- self.image_num_obj = ImageNumberEx:create(all_atta_num,nil,11)  --change_num_to_ima( all_atta_num ,116-10, 20 )
    -- background:addChild( self.image_num_obj.view )
    
    -- -- --提升战斗力按钮
    -- local but_upgrade = CCNGBtnMulTex:buttonWithFile(203 , 8, -1, -1, UIResourcePath.FileLocate.common .. "button3.png", 500, 500)
    -- but_upgrade:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "button3.png")
    -- local function but_upgrade_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then 
    --         UIManager:show_window("fight_value_win");
    --         return true
    --     end
    --     return true
    -- end
    -- but_upgrade:registerScriptHandler(but_upgrade_fun)  --注册
    -- background:addChild(but_upgrade)
    -- local but_upgrade_name = ZCCSprite:create(but_upgrade,UIResourcePath.FileLocate.role .. "up_atta1.png",65.5 , 21 );  --按钮名称
    
    self.view = background
    -- self:flash(  )  -- 测试
end

--添加属性.注意要使用  sefl:来调用，因为数值lablettf要存储，以便动态修改
function UserAttrPanel:addattribute( bgPanel )
    --获取角色属性
    local player = EntityManager:get_player_avatar()
    
    local sub_title_x = 34

    -- 三个背景
    local bg1 = CCZXImage:imageWithFile(14,423,393,108,UILH_COMMON.bottom_bg,500,500)
    bgPanel:addChild(bg1)
    local bg2 = CCZXImage:imageWithFile(14,297,393,108,UILH_COMMON.bottom_bg,500,500)
    bgPanel:addChild(bg2)
    local bg3 = CCZXImage:imageWithFile(14,90,393,190,UILH_COMMON.bottom_bg,500,500)
    bgPanel:addChild(bg3)

    -- 角色信息， 标题
    local char_info = CCZXImage:imageWithFile( sub_title_x, 502, -1, -1, UILH_NORMAL.title_bg3);  --背景框
    -- char_info:setConerSize(10,10,10,10,10,10,10,10)
    --char_info:addChild( UILabel:create_label_1(Lang.role_info.user_attr_panel.role_title, CCSize(100,20), 65, 13, 15, CCTextAlignmentLeft, 255, 255, 0) )
    bgPanel:addChild( char_info )
    -- MUtils:create_zxfont(char_info,Lang.role_info.user_attr_panel.title1,134,16,CCTextAlignmentCenter,19);
    local title_img = CCZXImage:imageWithFile(356/2,49/2,-1,-1,UILH_ROLE.juesexingxi)
    title_img:setAnchorPoint(0.5,0.5)
    char_info:addChild(title_img)

    -- 基础信息标题
    local attr_info_back = CCZXImage:imageWithFile( sub_title_x, 377, -1, -1, UILH_NORMAL.title_bg3);
    bgPanel:addChild( attr_info_back )
    -- MUtils:create_zxfont(attr_info_back,Lang.role_info.user_attr_panel.title2,134,16,CCTextAlignmentCenter,19);
    local title_img = CCZXImage:imageWithFile(356/2,49/2,-1,-1,UILH_ROLE.jichushuxing)
    title_img:setAnchorPoint(0.5,0.5)
    attr_info_back:addChild(title_img)

    --高级属性标题
    local hight_attr_info_back = CCZXImage:imageWithFile( sub_title_x, 252, -1, -1, UILH_NORMAL.title_bg3);
    bgPanel:addChild( hight_attr_info_back )
    -- MUtils:create_zxfont(hight_attr_info_back,Lang.role_info.user_attr_panel.title3,134,16,CCTextAlignmentCenter,19);
    local title_img = CCZXImage:imageWithFile(356/2,49/2,-1,-1,UILH_ROLE.qitashuxing)
    title_img:setAnchorPoint(0.5,0.5)
    hight_attr_info_back:addChild(title_img)

    -- 药包信息标题
    -- local medechine_title = CCBasePanel:panelWithFile( sub_title_x, 95, 130,28, UIPIC_UserSkillWin_0007, 500, 500);  --方形区域
    -- bgPanel:addChild( medechine_title )
    -- local title_1 = Image:create( nil, 25,4, -1, -1, UIPIC_UserBuffWin_0001, 500, 500 )
    -- medechine_title:addChild(title_1.view)

    --综合战力底色
    -- local  zonghe_bg = CCZXImage:imageWithFile(4, 5, 332, 50, UIResourcePath.FileLocate.common .. "title_bg_03.png",500,500)
    -- bgPanel:addChild(zonghe_bg)

    -- line = CCZXImage:imageWithFile( 10, 55, 310, 1, UIResourcePath.FileLocate.common .. "explain_bg.png" )             -- 线
    -- bgPanel:addChild( line )
	
	-- --字体相关固定值
	local fontsize = 18                                  --字体大小
	local lable_siz_w = 100                              --label尺寸的宽度值
    local lable_siz_h = fontsize                         --尺寸高度设置成和字体大小一样，就不会出现中文和数字不对齐的问题
    local dimensions = CCSize(lable_siz_w,lable_siz_h)   --lable尺寸
    local lable_inteval_x = 220                          --labelx坐标的间距
    local lable_inteva_y = lable_siz_h+9                  --labely坐标的间距

    --基准坐标
    local lable_nam_sta_x = 60                        --属性名称的起始x坐标
    local lable_nam_sta_y = 497                           --当到某一行，需要分块（距离更大）时，可以调整基准起始y坐标实现
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

    local default_font_size = 16

    -- 角色信息
    -- 名称
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.role_name, dimensions, lable_nam_sta_x + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.name, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "name" , self.label_t) )
    -- 等级
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.role_level, dimensions, lable_nam_sta_x + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.level, dimensions, lable_num_sta_x + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "level" , self.label_t) )
    -- 阵营
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.camp, dimensions, lable_nam_sta_x      + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( Lang.camp_info[player.camp] or "", dimensions, lable_num_sta_x + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "campPost" , self.label_t) )
    -- 魅力
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.charm, dimensions, lable_nam_sta_x      + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.charm, dimensions, lable_num_sta_x    + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "charm" , self.label_t) )
    -- 仙宗
    local guild_name = LangGameString[1642] -- [1642]="未加入"
    require "model/GuildModel"
    local guild_info = GuildModel:get_user_guild_info( )
    if guild_info.if_join_guild == 0 then
        guild_name = guild_info.guild_name
    else
        guild_name = Lang.role_info.user_attr_panel.none_guild_info
    end
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.guild, dimensions, lable_nam_sta_x      + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 2, default_font_size,  CCTextAlignmentRight,209, 206, 163) )
    bgPanel:addChild( create_lable( guild_name, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 2, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "guildId" , self.label_t) )

    -- 属性信息
    lable_nam_sta_y = lable_nam_sta_y - 125
    lable_num_sta_y = lable_nam_sta_y

    -- 不同职业，攻击的属性不同。天雷：物理攻击   蜀山：法术攻击    圆月：物理攻击  云华：法术攻击
    local atta_name_table = {Lang.role_info.user_attr_panel.phy_attack, Lang.role_info.user_attr_panel.magic_attack, Lang.role_info.user_attr_panel.phy_attack, Lang.role_info.user_attr_panel.magic_attack}
    local atta_value_table = {player.outAttack, player.innerAttack, player.outAttack, player.innerAttack}
    -- 生命
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.life, dimensions, lable_nam_sta_x          + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight,209, 206, 163) )
    bgPanel:addChild( create_lable( player.maxHp, dimensions, lable_num_sta_x           + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "hp" , self.label_t) )
    -- 法力
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.magic, dimensions, lable_nam_sta_x    + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 0, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.maxMp, dimensions, lable_num_sta_x  + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 0, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "mp" , self.label_t) )
    -- 攻击
    bgPanel:addChild( create_lable( atta_name_table[player.job], dimensions, lable_nam_sta_x        + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( atta_value_table[player.job], dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "innerAttack" , self.label_t) )
    -- 物理防御
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.phy_defence, dimensions, lable_nam_sta_x        + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 1, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.outDefence, dimensions, lable_num_sta_x   + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 1, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "outDefence" , self.label_t) )
    -- 法术防御
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.magic_defence, dimensions, lable_nam_sta_x        + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 2, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.innerDefence, dimensions, lable_num_sta_x + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 2, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "innerDefence" , self.label_t) )
    -- 命中
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.accurate, dimensions, lable_nam_sta_x    + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 2, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.hit, dimensions, lable_num_sta_x    + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 2, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "hit" , self.label_t) )
    
    lable_nam_sta_y = lable_nam_sta_y - 33-11
    lable_num_sta_y = lable_num_sta_y - 33-11

    -- 闪避
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.dodge, dimensions, lable_nam_sta_x    + lable_inteval_x * 0, lable_nam_sta_y - lable_inteva_y * 3, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.dodge, dimensions, lable_num_sta_x  + lable_inteval_x * 0, lable_num_sta_y - lable_inteva_y * 3, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "dodge" , self.label_t) )
    -- 暴击
    bgPanel:addChild( create_lable( Lang.role_info.user_attr_panel.criticalStrikes, dimensions, lable_nam_sta_x    + lable_inteval_x * 1, lable_nam_sta_y - lable_inteva_y * 3, default_font_size,  CCTextAlignmentRight, 209, 206, 163) )
    bgPanel:addChild( create_lable( player.criticalStrikes, dimensions, lable_num_sta_x + lable_inteval_x * 1, lable_num_sta_y - lable_inteva_y * 3, default_font_size, CCTextAlignmentLeft, 240, 134, 200, "criticalStrikes" , self.label_t) )
    -- 抗暴击
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
    self.img_shengjijingyan = MUtils:create_zximg(bgPanel,UILH_ROLE.text_shengjijingyan,23, 101,-1,-1)
    -- 经验条背景
    self.exp_bg = CCZXImage:imageWithFile( 100, 98, 300, 23, UILH_NORMAL.progress_bg, 500, 500 )   
    bgPanel:addChild( self.exp_bg )
    -- 经验“条”图片
    local player_exp = player.expH *(2^32) + player.expL
    local player_max_exp = player.maxExpH *(2^32) + player.maxExpL
    local exp_prog_long_per = ( player_exp / player_max_exp <= 1) and (player_exp / player_max_exp) or 1     -- 目前有当前血量大于最大血量的情况
    self.exp_prog = CCZXImage:imageWithFile( 111, 104, 277 * exp_prog_long_per, 12, UILH_NORMAL.progress_bar, 500, 500 )
    bgPanel:addChild( self.exp_prog , 5)
    -- 经验数字
    player_exp = UserInfoModel:big_num_show( player_exp )
    player_max_exp = UserInfoModel:big_num_show( player_max_exp )
    bgPanel:addChild( create_lable( player_exp.." / "..player_max_exp, dimensions, 250, 112, default_font_size-2, CCTextAlignmentCenter, 255, 255, 255, "exp" , self.label_t), 6)

    -- 分割线
    -- MUtils:create_zximg(bgPanel,UILH_COMMON.split_line,7,97,401,3,0,0)

    -- 药包icon
    local yaobao_icon = MUtils:create_zximg(bgPanel,UILH_ROLE.bottle,18,15,71,76)

    --3条分割线
    -- local fengge_bg_x = 114
    -- local fengge_bg_y = 70
    -- for i=1,3 do
    --     local fengge_bg1 = CCZXImage:imageWithFile(fengge_bg_x,fengge_bg_y-30*(i-1),255,2,UIPIC_UserSkillWin_00012)
    --     bgPanel:addChild(fengge_bg1)
    -- end

    local p_x = 260
    local p_y = 80
    local space_y = 25

    local  avator_life_label1 = UILabel:create_label_1(Lang.role_info.user_buff_panel.role_life_item, CCSize(300,20), p_x , p_y, default_font_size,  CCTextAlignmentLeft, 209, 206, 163)
    bgPanel:addChild( avator_life_label1 )

    local avator_magic_label2 = UILabel:create_label_1(Lang.role_info.user_buff_panel.role_magic_item, CCSize(300,20), p_x , p_y-space_y, default_font_size,  CCTextAlignmentLeft, 209, 206, 163)
    bgPanel:addChild( avator_magic_label2 )

    local pet_life_label3 = UILabel:create_label_1(Lang.role_info.user_buff_panel.pet_life_item, CCSize(300,20), p_x , p_y-space_y * 2, default_font_size,  CCTextAlignmentLeft, 209, 206, 163)
    bgPanel:addChild( pet_life_label3 )

    p_x = p_x - 20
    p_y = p_y - 10
    self.user_left_hp = MUtils:create_zxfont(bgPanel,"#cfff0000",p_x,p_y,1,default_font_size);   
    self.user_left_mp = MUtils:create_zxfont(bgPanel,"#c0096ff0",p_x,p_y-space_y,1,default_font_size);
    self.pet_left_hp = MUtils:create_zxfont(bgPanel,"#cffffff0",p_x,p_y-space_y*2,1,default_font_size);
end

-- 刷新所有数值，当服务器通知用户角色属性改变时，就调用这个方法，从新同步属性。(注意不要参数化)
-- 注意这个方法一定要用 本对象 来调用。因为要用到self.label_t  
-- 参数： 如果传参数，表示显示其他角色的信息。 如果没传参数，表示显示玩家自己的信息
function UserAttrPanel:flash( player_obj )
    --获取角色
    local player = player_obj or EntityManager:get_player_avatar()

    self.label_t["name"]:setString( player.name  )
    self.label_t["level"]:setString( player.level )
    -- local camp_name_t = {"#cff1493逍遥", "#c0000ff星辰", "#c00ff00逸仙"}
    self.label_t["campPost"]:setString( Lang.camp_info[player.camp] or "" )
    local guild_name = LangGameString[1642] -- [1642]="未加入"
    require "model/GuildModel"
    local guild_info = GuildModel:get_user_guild_info( )
    if guild_info.if_join_guild == 0 then
        guild_name = guild_info.guild_name
    else
        guild_name = Lang.role_info.user_attr_panel.none_guild_info
    end
    self.label_t["guildId"]:setString( guild_name )
    self.label_t["charm"]:setString( player.charm )  

    local atta_value_table = {player.outAttack, player.innerAttack, player.outAttack, player.innerAttack}
    self.label_t["innerAttack"]:setString( atta_value_table[player.job] )
    self.label_t["outDefence"]:setString( player.outDefence )
    self.label_t["innerDefence"]:setString( player.innerDefence )
    self.label_t["hp"]:setString( player.maxHp )
    self.label_t["mp"]:setString( player.maxMp )
    self.label_t["hit"]:setString( player.hit )
    self.label_t["dodge"]:setString( player.dodge )
    self.label_t["criticalStrikes"]:setString( player.criticalStrikes )
    self.label_t["defCriticalStrikes"]:setString( player.defCriticalStrikes )
    local criticalStrikesDamage_temp = UserInfoModel:calculate_( player.criticalStrikesDamage )
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
        self.exp_prog = CCZXImage:imageWithFile( 111, 104, 277 * exp_prog_long_per, 12, UILH_NORMAL.progress_bar, 500, 500 )
        self.view:addChild( self.exp_prog )
    else
        self.exp_prog:setIsVisible(false)
        self.exp_bg:setIsVisible(false)
        self.img_shengjijingyan:setIsVisible(false)
        self.label_t["exp"]:setString("")
    end

    -- 战斗力
    -- self.image_num_obj:set_number( player.fightValue )
end

-- 刷新，重新同步装备数据
function UserAttrPanel:update(  )
    self:flash()
    self:update_medicine_info()
end

-- 刷新，重新同步装备数据
function UserAttrPanel:update_medicine_info()
    -- 更新主角血蓝
    local player_avatar = EntityManager:get_player_avatar();
    self.user_left_hp:setText( player_avatar.hpStore )
    self.user_left_mp:setText( player_avatar.mpStore )
    -- 更新宠物血
    local player_pet = EntityManager:get_player_pet();
    if ( player_pet ) then
        self.pet_left_hp:setText(PetModel:get_current_pet_info().tab_attr[8]);
    end
end