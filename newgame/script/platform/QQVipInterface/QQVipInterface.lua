---------------------------------HJH 2013-10-10
----------------------QQVIP接口类
QQVipInterface = {}
----------------------
----------------------
----------------------
QQVipInterface.QQVipInterface_info = false											----QQVIP信息开关,这个是总开关
QQVipInterface.QQVipInterface_info_gm_command = false								----用于调QQVIP等级用的命令开关
QQVipInterface.QQVipInterface_shop_btn = false										----商城显示QQVIP充值按钮功能
QQVipInterface.QQVipInterface_sell_price = false									----QQVIP打折显示功能
QQVipInterface.QQVipInterface_fuben_count = false									----QQVIP副本次数功能
QQVipInterface.QQVipInterface_activity = false										----QQVIP主屏活动功能
----------------------
QQVipInterface.QQVipInterface_Init_Interface_Function = nil        					----接口初始化函数
QQVipInterface.QQVipInterface_Get_Platform_QQvip_Info_Function = nil 				----取得对应平台QQVIP信息函数
QQVipInterface.QQVipInterface_Get_Platform_QQvip_Image_Function = nil 				----取得对应平台钻图标函数
-- QQVipInterface_Get_Platform_QQvip_Back_Ground_Request_Url_Function = nil 	----取得对应平台请求QQVIP信息URL地址
-- QQVipInterface_Send_Platform_QQvip_Info_To_Server_Function = nil 			----向服务器发送QQVIP信息
QQVipInterface.QQVipInterface_Send_Platform_QQvip_Info_To_Server_GM_Function = nil 	----向服务器发送QQVIP信息GM命令
QQVipInterface.QQVipInterface_Create_Platform_QQvip_Recharge_Btn_Function = nil 	----创建对应平台充值按钮
QQVipInterface.QQVipInterface_Create_Platform_QQvip_MainGround_Btn_Function = nil  	----创建主屏QQVIP活动入口按钮
QQVipInterface.QQVipInterface_Add_Platform_QQVip_FubenCount_Function = nil 			----QQVIP副本添加次数判定函数
QQVipInterface.QQVipInterface_Sum_Platfrom_QQVip_MallPrice_Function = nil 			----取得QQVIP商场价格函数
QQVipInterface.QQVipInterface_Get_Platform_QQvip_ShopItemName_Function = nil 		----取得QQVIP商场名字函数
QQVipInterface.QQVipInterface_Show_Platform_QQvip_ShopPrice_Function = nil 			----取得是否显示QQVIP商场价格函数
QQVipInterface.QQVipInterface_Send_Platform_QQvip_Login_Function = nil 				----帐号登录后QQVIP处理函数
QQVipInterface.QQVipInterface_Get_Platform_QQvip_Activity_PanelInfo_Function = nil 	----取得QQVIP活动面板信息函数
QQVipInterface.QQVipInterface_Get_Platform_QQvip_Recharge_Url_Function = nil		----取得充值连接URL
QQVipInterface.QQVipInterface_Create_Platform_QQvip_MallNotic_Function = nil        ----创建商城说明图片
QQVipInterface.QQVipInterface_Recharge_Game_Vip_Function = nil                      ----游戏对应平台VIP充值函数
----------------------
------------------------------------------------------------------
------------------------------------------------------------------
----------------------
---根据不同平台激活功能
function QQVipInterface:init_qq_vip_interface()
    --print('Target_Platform',Target_Platform)
    if Target_Platform == Platform_Type.UNKNOW then
    	require "platform/QQVipInterface/QQUnknowVipInterface"
        QQVipInterface.QQVipInterface_Init_Interface_Function =  QQUnknowVipInterface.init_vip_info
    elseif Target_Platform == Platform_Type.YYB then
    	require "platform/QQVipInterface/QQNoneVipInterface"
        QQVipInterface.QQVipInterface_Init_Interface_Function =  QQNoneVipInterface.init_vip_info
    elseif Target_Platform == Platform_Type.QQHall then
    	require "platform/QQVipInterface/QQBlueVipInterface"
        QQVipInterface.QQVipInterface_Init_Interface_Function = QQBlueVipInterface.init_blue_vip_info
    end
    if QQVipInterface.QQVipInterface_Init_Interface_Function ~= nil then
        QQVipInterface:QQVipInterface_Init_Interface_Function()
    end
end
----------------------
----取得QQVIP信息
local function get_user_qq_vip_info(info)
 	----print("QQVipInterface:get_user_qq_vip_info info", info)
    if info == nil or QQVipInterface.QQVipInterface_info == false then
        return 
        { 
        	blue_vip_level = 0, is_blue_vip = 0, is_blue_year_vip = 0, is_super_blue_vip = 0,
        	yeallow_vip_level = 0, is_yeallow_vip = 0, is_yeallow_year_vip = 0, is_super_yeallow_vip = 0,
        	qq_vip_level = 0, is_qq_vip = 0, is_qq_year_vip = 0, is_qq_super_vip = 0 
        }
    end
    --------------蓝钻信息
    local diamond_b = Utils:get_byte_by_position( info, 2 )
    local is_diamond_b_vip = Utils:get_bit_by_position( info, 1 )
    local is_diamond_b_year = Utils:get_bit_by_position( info, 2 )
    local is_diamond_b_super = Utils:get_bit_by_position( info, 3 )
    --------------黄钻信息
    local diamond_y = 0
    local is_diamond_y_vip = 0
    local is_diamond_y_year = 0
    local is_diamond_y_super = 0
    --------------普通会员信息
    local vip_level = 0
    local is_vip = 0 
    local is_year_vip = 0
    local is_super_vip = 0
    --------------
    return 
    { 
    	blue_vip_level = diamond_b, is_blue_vip = is_diamond_b_vip, is_blue_year_vip = is_diamond_b_year, is_super_blue_vip = is_diamond_b_super,
    	yeallow_vip_level = diamond_y, is_yeallow_vip = is_diamond_y_vip, is_yeallow_year_vip = is_diamond_y_year, is_super_yeallow_vip = is_diamond_y_super,
    	qq_vip_level = vip_level, is_qq_vip = is_vip, is_qq_year_vip = is_year_vip, is_qq_super_vip = is_super_vip 
	}
end
----------------------
----取得QQVIP对应平台信息
function QQVipInterface:get_qq_vip_platform_info(info)
    local temp_info = get_user_qq_vip_info(info)
    local return_result = { is_vip = 0, vip_level = 0, is_super_vip = 0, is_year_vip = 0 }
    if QQVipInterface.QQVipInterface_Get_Platform_QQvip_Info_Function ~= nil then
        return_result = QQVipInterface:QQVipInterface_Get_Platform_QQvip_Info_Function(temp_info)
    end
    return return_result
end
------------------------------------------------------------------
------------------------------------------------------------------
----------------------
----取得QQVIP图片信息
function QQVipInterface:get_qq_vip_image_info(info)
    local qq_vip_info = get_user_qq_vip_info(info)
    local result_info = { vip_icon = "", year_icon = "" }
--@debug_begin
--     --print( 
--     	string.format("blue_vip_level = %d, is_blue_vip = %d, is_blue_year_vip = %d, is_super_blue_vip = %d,\
-- yeallow_vip_level = %d, is_yeallow_vip = %d, is_yeallow_year_vip = %d, is_super_yeallow_vip = %d,\
-- qq_vip_level = %d, is_qq_vip = %d, is_qq_year_vip = %d, is_qq_super_vip = %d",
--     	 qq_vip_info.blue_vip_level, qq_vip_info.is_blue_vip, qq_vip_info.is_blue_year_vip, qq_vip_info.is_super_blue_vip,
--     	 qq_vip_info.yeallow_vip_level, qq_vip_info.is_yeallow_vip, qq_vip_info.is_yeallow_year_vip, qq_vip_info.is_super_yeallow_vip,
--     	 qq_vip_info.qq_vip_level, qq_vip_info.is_qq_vip, qq_vip_info.is_qq_year_vip, qq_vip_info.is_qq_super_vip
--     	 )
--         )
--@debug_end
    ------------
    if QQVipInterface.QQVipInterface_Get_Platform_QQvip_Image_Function ~= nil then
    	result_info = QQVipInterface:QQVipInterface_Get_Platform_QQvip_Image_Function(qq_vip_info)
    end
    ------------
    return result_info
end
----------------------
---创建QQVIP名字
function QQVipInterface:create_qq_vip_info(info, name, aline)
	---------HJH 2013-9-12
    ---------qqvip and role name
    local show_vip = false
    local show_year = false
    local add_list = {}
    --------------------
    local qq_vip_icon = nil
    local qq_vip_year_icon = nil
    local qq_vip_icon_size = { width = 0, height = 0 }
    local qq_vip_year_icon_size = { width = 0, height = 0 }
    local qqvip_year_icon_pos = { x = 0, y = 0 }
    local _icon_size_height = 0
    --------------------QQVIP图片
    ---getContentSize
    if QQVipInterface.QQVipInterface_info then
        qq_vip_icon = CCSprite:spriteWithFile(UIResourcePath.FileLocate.qqvip .. "1.png")
        qq_vip_icon:setContentSize(CCSizeMake(16,15))
        qq_vip_icon:setAnchorPoint(CCPointMake(0,0))
        qq_vip_icon_size = qq_vip_icon:getContentSize()
        --qq_vip_icon = Image:create( nil , 0, 0, -1, -1,  UIResourcePath.FileLocate.qqvip .. "1.png" )
        --qq_vip_icon_size = qq_vip_icon:getSize()
        table.insert( add_list, qq_vip_icon )
   	--------------------QQ年费图片
        qq_vip_year_icon = CCSprite:spriteWithFile(UIResourcePath.FileLocate.qqvip .. "year.png")
        qq_vip_year_icon_size = qq_vip_year_icon:getContentSize()
        qq_vip_year_icon:setAnchorPoint(CCPointMake(0,0))
        -- qq_vip_year_icon = Image:create( nil, 0, 0, -1, -1, UIResourcePath.FileLocate.qqvip .. "year.png" )
        -- qq_vip_year_icon_size = qq_vip_year_icon:getSize()
        table.insert( add_list, qq_vip_year_icon )

        _icon_size_height = qq_vip_year_icon_size.height
    end
    --------------------角色名字
    local name_lab = Label:create( nil, 0, 0, name )
    table.insert( add_list, name_lab.view )
    local name_lab_size = name_lab:getSize()
    --------------------
    local panel_height = 0
    if name_lab_size.height > qq_vip_year_icon_size.height then
        panel_height = name_lab_size.height
    else
        panel_height = qq_vip_year_icon_size.height
    end
    --------------------
    -- local temp_panel = CCNode:node()
    -- temp_panel:setContentSize(CCSizeMake(qq_vip_icon_size.width + qq_vip_year_icon_size.width + name_lab_size.width, panel_height))
    local temp_panel = ZBasePanel:create( nil, "", 0, 0, qq_vip_icon_size.width + qq_vip_year_icon_size.width + name_lab_size.width, panel_height )
    --------------------
    temp_panel.qq_vip_icon = qq_vip_icon
    temp_panel.qq_vip_year_icon = qq_vip_year_icon
    temp_panel.name_lab = name_lab
    temp_panel.aline = aline
    -- temp_panel:setTouchBeganReturnValue(false)
    -- temp_panel:setTouchMovedReturnValue(false)
    -- temp_panel:setTouchEndedReturnValue(false)
    -------------
    for i = 1, #add_list do
        temp_panel:addChild( add_list[i] )
    end
    -------------reset icon pos
    QQVipInterface:reinit_info( temp_panel, info, name )
    -------------
    return temp_panel
end
----------------------
---重设QQVIP名字信息与位置
function QQVipInterface:reinit_info(panel, info, name)
    if panel == nil or  panel.name_lab == nil then
        return
    else
        if panel.qq_vip_icon == nil or panel.qq_vip_year_icon == nil then
            local temp_panel_size = panel:getSize()
            panel.name_lab.view:setText( name )
            local name_lab_size = panel.name_lab:getSize()
            panel.name_lab:setPosition( ( temp_panel_size.width - name_lab_size.width ) / 2, 0 )
            return
        end
    end
    -------------
    local show_vip = false
    local show_year = false
    local qq_vip_icon_size = { width = 0, height = 0 }
    local qq_vip_year_icon_size = { width = 0, height = 0 }
    local qq_vip_year_icon_pos = { x = 0, y = 0 }
    local temp_panel_size = panel:getSize()
    --local temp_panel_size = panel:getContentSize()
    local qq_vip_info = QQVipInterface:get_qq_vip_image_info(info)
    local qq_vip_tar_info = QQVipInterface:get_qq_vip_platform_info(info)
    -------------reset vip icon
    -- --print("qq_vip_tar_info.is_vip, qq_vip_tar_info.is_super_vip",qq_vip_tar_info.is_vip, qq_vip_tar_info.is_super_vip)
    if qq_vip_tar_info.is_vip == 1 or qq_vip_tar_info.is_super_vip == 1 then
        --print("qq_vip_info.vip_icon",qq_vip_info.vip_icon)
        panel.qq_vip_icon:replaceTexture( qq_vip_info.vip_icon )
        panel.qq_vip_icon:setAnchorPoint(CCPointMake(0,0))
        panel.qq_vip_icon:setIsVisible( true )
        show_vip = true
        qq_vip_icon_size = panel.qq_vip_icon:getContentSize()
        -- panel.qq_vip_icon.view:setTexture( qq_vip_info.vip_icon )
        -- panel.qq_vip_icon.view:setIsVisible( true )
        -- show_vip = true
        -- qq_vip_icon_size = panel.qq_vip_icon:getSize()
    else
        panel.qq_vip_icon:setIsVisible( false )
        --panel.qq_vip_icon.view:setIsVisible( false )
    end
    -------------reset year icon
    if qq_vip_tar_info.is_year_vip == 1 then
        panel.qq_vip_year_icon:replaceTexture( qq_vip_info.year_icon )
        panel.qq_vip_year_icon:setAnchorPoint(CCPointMake(0,0))
        panel.qq_vip_year_icon:setIsVisible( true )
        show_year = true
        qq_vip_year_icon_size = panel.qq_vip_year_icon:getContentSize()
        qq_vip_year_icon_pos = panel.qq_vip_year_icon:getPosition()
        -- panel.qq_vip_year_icon.view:setTexture( qq_vip_info.year_icon )
        -- panel.qq_vip_year_icon.view:setIsVisible( true )
        -- show_year = true
        -- qq_vip_year_icon_size = panel.qq_vip_year_icon:getSize()
        -- qq_vip_year_icon_pos = panel.qq_vip_year_icon:getPosition()
    else
        panel.qq_vip_year_icon:setIsVisible(false)
        --panel.qq_vip_year_icon.view:setIsVisible( false )
    end
    -------------reset name
    panel.name_lab.view:setText( name )
    local name_lab_size = panel.name_lab:getSize()
    -------------reset position
    if show_year == false then
        if show_vip == false then
            if panel.aline == true then
                panel.name_lab:setPosition( 0, 3 )
            else
                panel.name_lab:setPosition( ( temp_panel_size.width - name_lab_size.width ) / 2, 3 )
            end
        else
            panel.qq_vip_icon:setPosition( CCPointMake( ( temp_panel_size.width - name_lab_size.width - qq_vip_icon_size.width ) / 2, 0 ) )
            panel.name_lab:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_vip_icon_size.width ) / 2 + qq_vip_icon_size.width, 3 ) 
            -- panel.qq_vip_icon:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_vip_icon_size.width ) / 2, 0 )
            -- panel.name_lab:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_vip_icon_size.width ) / 2 + qq_vip_icon_size.width, 0 )
        end
    else
        if show_vip == false then
            panel.qq_vip_year_icon:setPosition( CCPointMake( ( temp_panel_size.width - name_lab_size.width - qq_vip_year_icon_size.width ) / 2, 0 ) )
            --panel.qq_vip_year_icon:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_vip_year_icon_size.width ) / 2, 0 )
            panel.name_lab:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_vip_year_icon_size.width ) / 2 + qq_vip_year_icon_size.width, 3 )        
        else
            panel.qq_vip_icon:setPosition( CCPointMake( ( temp_panel_size.width - name_lab_size.width - qq_vip_icon_size.width - qq_vip_year_icon_size.width ) / 2, 0 ) )
            panel.qq_vip_year_icon:setPosition( CCPointMake( ( temp_panel_size.width - name_lab_size.width - qq_vip_icon_size.width - qq_vip_year_icon_size.width ) / 2 + qq_vip_icon_size.width, 0 ) )
            -- panel.qq_vip_icon:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_vip_icon_size.width - qq_vip_year_icon_size.width ) / 2, 0 )
            -- panel.qq_vip_year_icon:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_vip_icon_size.width - qq_vip_year_icon_size.width ) / 2 + qq_vip_icon_size.width, 0 )
            panel.name_lab:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_vip_icon_size.width - qq_vip_year_icon_size.width ) / 2 + qq_vip_icon_size.width + qq_vip_year_icon_size.width, 3 )
        end
    end
end
------------------------------------------------------------------
------------------------------------------------------------------
----------------------
---角色登录后将QQVIP信息发给服务器
function QQVipInterface:game_login_qqvip_info_request()
	if QQVipInterface.QQVipInterface_Send_Platform_QQvip_Login_Function ~= nil then
		QQVipInterface:QQVipInterface_Send_Platform_QQvip_Login_Function()
	end
end
----------------------
---特殊函数用于摸拟QQVIP等级改变
function QQVipInterface:game_login_qqvip_info_request_gm(is_blue_vip, is_blue_year_vip, blue_vip_level, is_super_blue_vip)
    if QQVipInterface.QQVipInterface_info_gm_command == true and QQVipInterface.QQVipInterface_info == true then
        local temp_info = { }
        if QQVipInterface.QQVipInterface_Send_Platform_QQvip_Info_To_Server_GM_Function ~= nil then
        	temp_info = QQVipInterface:QQVipInterface_Send_Platform_QQvip_Info_To_Server_GM_Function(is_blue_vip, is_blue_year_vip, blue_vip_level, is_super_blue_vip)
        end
        for i = 1, #temp_info do
            -- --print("temp_info[i]",temp_info[i])
        end
        MiscCC:send_params_to_server( 4, temp_info )
    end
end
----------------------
---当当前角色QQVIP改变时更新相就页面
function QQVipInterface:update_panel_for_qqvip_change()
    if QQVipInterface.QQVipInterface_info == false or QQVipInterface.QQVipInterface_info == false then
         return
    end
    --------------------更新角色面板
    -- local user_attr_win = UIManager:find_window("user_equip_win")
    -- if user_attr_win ~= nil then
    --     user_attr_win:update_qqvip()
    -- end
    -------------------更新用户面板
    local user_panel = UIManager:find_window("user_panel")
    if user_panel ~= nil then
        user_panel:update_my_qqvip_info()
    end
    ---------------更新商城界面
    local play = EntityManager:get_player_avatar()
    local qqvip_info =  QQVipInterface:get_qq_vip_platform_info(play.QQVIP)
    if ( qqvip_info.vip_level == 1 and ( qqvip_info.is_vip == 1 or qqvip_info.is_super_vip == 1 ) ) or ( qqvip_info.vip_level == 0 and ( qqvip_info.is_vip == 0 or qqvip_info.is_super_vip == 0 ) )then
        local mall_win = UIManager:find_window("mall_win")
        local mall_win_show = UIManager:find_visible_window("mall_win")
        if mall_win ~= nil then
            UIManager:destroy_window("mall_win")
            if mall_win_show ~= nil then
                UIManager:show_window("mall_win")
            end
        end
    end
end
------------------------------------------------------------------
------------------------------------------------------------------
----------------------
--商城成为QQVIP按钮
function QQVipInterface:mall_win_add_btn()
    if QQVipInterface.QQVipInterface_info == false or QQVipInterface.QQVipInterface_shop_btn == false or QQVipInterface.QQVipInterface_Create_Platform_QQvip_Recharge_Btn_Function == nil then
        return nil
    end
    local temp_btn = QQVipInterface:QQVipInterface_Create_Platform_QQvip_Recharge_Btn_Function( 22, 10, 112, 32)
    if QQVipInterface.QQVipInterface_Create_Platform_QQvip_MallNotic_Function ~= nil then
        local notic_img = QQVipInterface:QQVipInterface_Create_Platform_QQvip_MallNotic_Function()
        notic_img:setPosition( 130, 10)
        temp_btn.view:addChild( notic_img.view )
    end
    return temp_btn
end
------------------------------------------------------------------
------------------------------------------------------------------
----------------------
--QQVIP 主屏添加按钮处理方法
function QQVipInterface:insert_qqvip_icon_fun(panel)
    -- if QQVipInterface.QQVipInterface_activity == false or QQVipInterface.QQVipInterface_info == false then
    --     return 
    -- end
    -- panel:insert_btn(3)
end
----------------------
---QQVIP主屏显示按钮返回函数
function QQVipInterface:qq_vip_main_gruond_btn(info)
	-- --print("QQVipInterface.QQVipInterface_Create_Platform_QQvip_MainGround_Btn_Function",QQVipInterface.QQVipInterface_Create_Platform_QQvip_MainGround_Btn_Function)
   	if QQVipInterface.QQVipInterface_Create_Platform_QQvip_MainGround_Btn_Function ~= nil then
   		return QQVipInterface:QQVipInterface_Create_Platform_QQvip_MainGround_Btn_Function(info)
   	end
    return nil
end
------------------------------------------------------------------
------------------------------------------------------------------
----------------------
---QQVIP副本增加次数函数处理
function QQVipInterface:fuben_count(info)
    ----------------------
    if QQVipInterface.QQVipInterface_info == false or QQVipInterface.QQVipInterface_fuben_count == false or QQVipInterface.QQVipInterface_Add_Platform_QQVip_FubenCount_Function == nil then
        return false
    end
    local temp_qq_vip_info = get_user_qq_vip_info(info)
    ----------------------
    return QQVipInterface:QQVipInterface_Add_Platform_QQVip_FubenCount_Function(temp_qq_vip_info)
end
------------------------------------------------------------------
------------------------------------------------------------------
----------------------
---QQVIP商城打折功能
function QQVipInterface:mall_price(info, price)
    if QQVipInterface.QQVipInterface_info == nil or QQVipInterface.QQVipInterface_sell_price == false or QQVipInterface.QQVipInterface_Sum_Platfrom_QQVip_MallPrice_Function == nil then
        return price
    end
    local temp_qq_info = QQVipInterface:get_qq_vip_platform_info(info)
    local temp_info = QQVipInterface:QQVipInterface_Sum_Platfrom_QQVip_MallPrice_Function(temp_qq_info, price)
    return temp_info
end
----------------------
---商城QQVIP价名字
function QQVipInterface:shop_item_name()
    if QQVipInterface.QQVipInterface_Get_Platform_QQvip_ShopItemName_Function == nil then
    	return ""
    else
    	return QQVipInterface:QQVipInterface_Get_Platform_QQvip_ShopItemName_Function()
    end
end
----------------------
---是否显示商场价格
function QQVipInterface:show_shop_price()
    local play = EntityManager:get_player_avatar()
    local temp_vip_info = QQVipInterface:get_qq_vip_platform_info(play.QQVIP)
    if QQVipInterface.QQVipInterface_info == nil or QQVipInterface.QQVipInterface_sell_price == false or QQVipInterface.QQVipInterface_Show_Platform_QQvip_ShopPrice_Function == nil then
        return false
    end
    return QQVipInterface:QQVipInterface_Show_Platform_QQvip_ShopPrice_Function(temp_vip_info)
end
---------------------
---取得QQVIP活动面板信息
function QQVipInterface:get_activity_panel_info()
	if QQVipInterface.QQVipInterface_info ~= nil and QQVipInterface.QQVipInterface_Get_Platform_QQvip_Activity_PanelInfo_Function ~= nil then
		return QQVipInterface:QQVipInterface_Get_Platform_QQvip_Activity_PanelInfo_Function()
	end
end