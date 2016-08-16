---------------------------------HJH 2013-10-10
----------------------QQVIP接口类
QQUnknowVipInterface = {}
----------------------
---初始化函数 
function QQUnknowVipInterface:init_vip_info()
	QQVipInterface.QQVipInterface_info_gm_command = true
	QQVipInterface.QQVipInterface_info = false
	QQVipInterface.QQVipInterface_shop_btn = true
	QQVipInterface.QQVipInterface_sell_price = true
	QQVipInterface.QQVipInterface_fuben_count = true
	QQVipInterface.QQVipInterface_activity = true
	QQVipInterface.QQVipInterface_Get_Platform_QQvip_Info_Function = QQUnknowVipInterface.get_platform_qq_vip_info
	QQVipInterface.QQVipInterface_Get_Platform_QQvip_Image_Function = QQUnknowVipInterface.get_qq_vip_image_info
	-- QQVipInterface_Get_Platform_QQvip_Back_Ground_Request_Url_Function = QQBlueVipInterface.get_qq_blue_vip_back_ground_request_url
	-- QQVipInterface_Send_Platform_QQvip_Info_To_Server_Function = QQBlueVipInterface.send_qq_blue_vip_info_to_server
	QQVipInterface.QQVipInterface_Send_Platform_QQvip_Info_To_Server_GM_Function = QQUnknowVipInterface.send_qq_vip_info_to_server_gm_commmand
	QQVipInterface.QQVipInterface_Create_Platform_QQvip_Recharge_Btn_Function = QQUnknowVipInterface.create_qq_vip_recharge_btn
	QQVipInterface.QQVipInterface_Create_Platform_QQvip_MainGround_Btn_Function = QQUnknowVipInterface.create_qq_vip_main_ground_btn
	QQVipInterface.QQVipInterface_Add_Platform_QQVip_FubenCount_Function = QQUnknowVipInterface.add_qq_vip_fuben_count
	QQVipInterface.QQVipInterface_Sum_Platfrom_QQVip_MallPrice_Function = QQUnknowVipInterface.sum_mall_price
	QQVipInterface.QQVipInterface_Get_Platform_QQvip_ShopItemName_Function = QQUnknowVipInterface.get_shop_item_name
	QQVipInterface.QQVipInterface_Show_Platform_QQvip_ShopPrice_Function = QQUnknowVipInterface.get_is_show_shop_price
	QQVipInterface.QQVipInterface_Send_Platform_QQvip_Login_Function = QQUnknowVipInterface.login_function
	QQVipInterface.QQVipInterface_Get_Platform_QQvip_Activity_PanelInfo_Function = QQUnknowVipInterface.get_activity_panel_info
	QQVipInterface.QQVipInterface_Get_Platform_QQvip_Recharge_Url_Function = nil
    QQVipInterface.QQVipInterface_Create_Platform_QQvip_MallNotic_Function = QQUnknowVipInterface.create_qq_vip_mall_notic_img
	QQVipConfig.get_vip_fresh_award_info = QQVipConfig.get_vip_blue_fresh_award_info
	QQVipConfig.get_vip_daly_award_info = QQVipConfig.get_vip_blue_daly_award
	QQVipConfig.get_vip_year_award_info = QQVipConfig.get_vip_blue_year_award
	QQVipConfig.get_vip_level_award_info = QQVipConfig.get_vip_blue_level_award
	QQVipConfig.get_vip_pet_award_info = QQVipConfig.get_vip_blue_pet
	QQVipConfig.get_vip_award_item_num = QQVipConfig.get_vip_blue_award_item_num
    QQVipConfig.get_vip_max_level = QQVipConfig.get_vip_blue_max_level
end
----------------------
----取得平台VIP信息
function QQUnknowVipInterface:get_platform_qq_vip_info(info)
	local return_result = { is_vip = 0, vip_level = 0, is_super_vip = 0, is_year_vip = 0 }
    return_result.is_vip = info.is_blue_vip
    return_result.vip_level = info.blue_vip_level
    return_result.is_super_vip = info.is_super_blue_vip
    return_result.is_year_vip = info.is_blue_year_vip
    return return_result
end
----------------------
----取得图片信息
function QQUnknowVipInterface:get_qq_vip_image_info(info)
	local result_info = { vip_icon = "", year_icon = "" }
    local temp_vip_level = info.blue_vip_level
    local temp_max_vip_level = QQVipConfig:get_vip_max_level()
    ----print("temp_vip_level,temp_max_vip_level",temp_vip_level,temp_max_vip_level)
    if temp_vip_level > temp_max_vip_level then
        temp_vip_level = temp_max_vip_level
    end
 	-----------check blue qq vip icon
    if info.is_blue_vip == 0 then
        result_info.vip_icon = UIResourcePath.FileLocate.qqvip .. "1_d.png"
    else
        if info.is_super_blue_vip == 0 then
            result_info.vip_icon = string.format( "%s%d.png", UIResourcePath.FileLocate.qqvip, temp_vip_level )
        else
            result_info.vip_icon = string.format( "%ss%d.png", UIResourcePath.FileLocate.qqvip, temp_vip_level )
        end
    end
    ----------check blue year vip
    if info.is_blue_year_vip == 1 then
        result_info.year_icon = UIResourcePath.FileLocate.qqvip .. "year.png"
    else
        result_info.year_icon = UIResourcePath.FileLocate.qqvip .. "year_d.png"
    end
    return result_info
end
----------------------
----取得向后台请求信息地址
-- function QQUnknowVipInterface:get_qq_blue_vip_back_ground_request_url()
--     local open_id, token, pf, pf_key = PlatformInterface:getLoginRet()
--     local back_ground_url_font = GameUrl_global:getServerIP()
--     local temp_url_info = "http://test.app1000000129.twsapp.com/getBlueVip.jsp"
--     if back_ground_url_font ~= nil then

--     end
--     return { url = string.format("%s%s", back_ground_url_font, ) "http://test.app1000000129.twsapp.com/getBlueVip.jsp", param = '&openid='..open_id..'&openkey='..token..'&pf='..pf }
-- end
----------------------
----发送给服务器蓝钻信息
-- function QQUnknowVipInterface:send_qq_blue_vip_info_to_server(info)
--     local temp_info = { }
--     temp_info[1] = "is_blue_vip"
--     temp_info[2] = info['is_blue_vip']
--     temp_info[3] = "is_blue_year_vip"
--     temp_info[4] = info['is_blue_year_vip']
--     temp_info[5] = "blue_vip_level"
--     temp_info[6] = info['blue_vip_level']
--     temp_info[7] = "is_super_blue_vip"
--     temp_info[8] = info['is_super_blue_vip']
--     return temp_info
-- end
----------------------
----请求回调函数
-- function QQUnknowVipInterface.request_callback(error_code, message)
--     --print("QQVipInterface:request_callback error_code, message", error_code, message)
--     if error_code == 0 then
--         local info_list = json.decode( message )
--         local temp_info = {}
--         ----------------------
--         temp_info = QQBlueVipInterface:send_qq_blue_vip_info_to_server(info_list)
--         ----------------------
--         for i = 1, #temp_info do
--             --print("temp_info[i]",temp_info[i])
--         end
--         ----------------------
--         MiscCC:send_params_to_server( #temp_info / 2, temp_info )
--     else
--         NormalDialog:show( string.format("%s%s", "QQVipInterface:request_callback error_code=", error_code ), nil, 2 )
--     end
-- end
----------------------
----帐号登录后处理函数
function QQUnknowVipInterface:login_function()
    local temp_info = { }
    temp_info[1] = "is_blue_vip"
    temp_info[2] = "0"
    temp_info[3] = "is_blue_year_vip"
    temp_info[4] = "0"
    temp_info[5] = "blue_vip_level"
    temp_info[6] = "0"
    temp_info[7] = "is_super_blue_vip"
    temp_info[8] = "0"
    ----------------------
    for i = 1, #temp_info do
        -- --print("temp_info[i]",temp_info[i])
    end
    ----------------------
    MiscCC:send_params_to_server( 4, temp_info )
end
----------------------
----发送给服务器信息GM命令
function QQUnknowVipInterface:send_qq_vip_info_to_server_gm_commmand( is_vip, is_year_vip, vip_level, is_super_vip )
    local temp_info = { }
    temp_info[1] = "is_blue_vip"
    temp_info[2] = tostring( is_vip )
    temp_info[3] = "is_blue_year_vip"
    temp_info[4] = tostring( is_year_vip )
    temp_info[5] = "blue_vip_level"
    local temp_max_vip_level = QQVipConfig:get_vip_max_level()
    if vip_level > temp_max_vip_level then
        vip_level = temp_max_vip_level
    end
    temp_info[6] = tostring( vip_level )
    temp_info[7] = "is_super_blue_vip"
    temp_info[8] = tostring( is_super_vip )
    return temp_info
end
----------------------
----创建充值按钮
function QQUnknowVipInterface:create_qq_vip_recharge_btn(x, y, widht, height)
    -----------------
    local play = EntityManager:get_player_avatar()
    local vip_info = QQVipInterface:get_qq_vip_platform_info(play.QQVIP)
    local btn_path = "";
    --print("vip_info.is_vip",vip_info.is_vip);
    if vip_info.is_vip > 0 then
        btn_path = UIResourcePath.FileLocate.qqvip .. "blue_btn2.png";
    else
        btn_path = UIResourcePath.FileLocate.qqvip .. "blue_btn.png";
    end
    local qqvip_btn = Button:create( nil, x, y, widht, height, btn_path)
    --panel:addChild( qqvip_btn.view )
    local function qqvip_btn_fun()        
        -- local temp_url = QQUnknowVipInterface:get_qq_blue_vip_recharge_url()
        -- --print("QQVipInterface:get_qq_vip_recharge_url url=",temp_url)
        -- phoneGotoURL(temp_url)  
    end
    qqvip_btn:setTouchClickFun( qqvip_btn_fun )
    return qqvip_btn
end
----------------------
----创建蓝钻主屏按钮
function QQUnknowVipInterface:create_qq_vip_main_ground_btn(info)
    local function qqvip_btn_fun()
        UIManager:show_window("qqvip_win")
    end
    local qqvip_btn = CountDownButton( 350-info*70,0,70,60, UIResourcePath.FileLocate.main .. "right_top/qq_blue.png", UIResourcePath.FileLocate.main .. "right_top/qq_blue_bg.png",
                         qqvip_btn_fun, nil, nil);
    return qqvip_btn
end
----------------------
----判断是否添加副本次数
function QQUnknowVipInterface:add_qq_vip_fuben_count(info)
	if info.is_vip == 1 or info.is_super_vip == 1 then
        return true
    else
        return false
    end
end
----------------------
----计算商城物品价格
function QQUnknowVipInterface:sum_mall_price(info, price)
    if info.is_vip == 1 or info.is_super_vip == 1 then
        return math.floor( price * 0.8 )
    else
        return price
    end
end
----------------------
----取得商城物品价格名字
function QQUnknowVipInterface:get_shop_item_name()
	return LangCommonString[72] -- [72]="#c7cfc00蓝钻"
end
----------------------
----取得当前是否显示商城价
function QQUnknowVipInterface:get_is_show_shop_price(info)
    if info.is_vip == 1 or info.is_super_vip == 1 then
        return true
    else
    	return false
    end
end
-----------------------
---
function QQUnknowVipInterface:get_activity_panel_info()
	local temp_info = 
	{
		pet_info = Lang.qqvip_info.blue_pet_info,
		award_info = Lang.qqvip_info.blue_award_info,
		warning_info = { vip_get = Lang.qqvip_info.blue_vip_get_info, vip_pet_get = Lang.qqvip_info.blue_vip_get_pet_info, vip_year_get = Lang.qqvip_info.blue_year_vip_get_info },
        shop_notic_info = Lang.qqvip_info.blue_shop_notic_info,
	}
	return temp_info
end
-----------------------
---
function QQUnknowVipInterface:create_qq_vip_mall_notic_img()
    local temp_img = Image:create( nil, 0, 0, -1, -1, UIResourcePath.FileLocate.qqvip .. "mall_price.png" )
    return temp_img
end
