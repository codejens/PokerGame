---------------------------------HJH 2013-10-10
----------------------QQVIP接口类
QQNoneVipInterface = {}
----------------------
function QQNoneVipInterface:init_none_vip_info()
	QQVipInterface.QQVipInterface_info_gm_command = false
	QQVipInterface.QQVipInterface_info = false
	QQVipInterface.QQVipInterface_shop_btn = false
	QQVipInterface.QQVipInterface_sell_price = false
	QQVipInterface.QQVipInterface_fuben_count = false
	QQVipInterface.QQVipInterface_activity = false
	QQVipInterface.QQVipInterface_Get_Platform_QQvip_Info_Function = QQNoneVipInterface.get_platform_qq_vip_info
	QQVipInterface.QQVipInterface_Get_Platform_QQvip_Image_Function = QQNoneVipInterface.get_qq_vip_image_info
	-- QQVipInterface_Get_Platform_QQvip_Back_Ground_Request_Url_Function = nil
	-- QQVipInterface_Send_Platform_QQvip_Info_To_Server_Function = nil
	QQVipInterface.QQVipInterface_Send_Platform_QQvip_Info_To_Server_GM_Function = nil
	QQVipInterface.QQVipInterface_Create_Platform_QQvip_Recharge_Btn_Function = nil
	QQVipInterface.QQVipInterface_Create_Platform_QQvip_MainGround_Btn_Function = nil
	QQVipInterface.QQVipInterface_Add_Platform_QQVip_FubenCount_Function = nil
	QQVipInterface.QQVipInterface_Sum_Platfrom_QQVip_MallPrice_Function = nil
	QQVipInterface.QQVipInterface_Get_Platform_QQvip_ShopItemName_Function = nil
	QQVipInterface.QQVipInterface_Show_Platform_QQvip_ShopPrice_Function = nil
	QQVipInterface.QQVipInterface_Send_Platform_QQvip_Login_Function = QQNoneVipInterface.login_function
    QQVipInterface.QQVipInterface_Get_Platform_QQvip_Activity_PanelInfo_Function = nil
    QQVipInterface.QQVipInterface_Get_Platform_QQvip_Recharge_Url_Function = nil
    QQVipInterface.QQVipInterface_Create_Platform_QQvip_MallNotic_Function = nil
    QQVipConfig.get_vip_fresh_award_info = nil
    QQVipConfig.get_vip_daly_award_info = nil
    QQVipConfig.get_vip_year_award_info = nil
    QQVipConfig.get_vip_level_award_info = nil
    QQVipConfig.get_vip_pet_award_info = nil
    QQVipConfig.get_vip_award_item_num = nil
    QQVipConfig.get_vip_max_level = nil
end
----------------------
----取得平台VIP信息
function QQNoneVipInterface:get_platform_qq_vip_info(info)
	local return_result = { is_vip = 0, vip_level = 0, is_super_vip = 0, is_year_vip = 0 }
    return return_result
end
----------------------
----取得图片信息
function QQNoneVipInterface:get_qq_vip_image_info(info)
	local result_info = { vip_icon = "", year_icon = "" }
 	-----------check blue qq vip icon
    if info.is_blue_vip == 0 then
        result_info.vip_icon = UIResourcePath.FileLocate.qqvip .. "1_d.png"
    else
        if info.is_super_blue_vip == 0 then
            result_info.vip_icon = string.format( "%s%d.png", UIResourcePath.FileLocate.qqvip, info.blue_vip_level )
        else
            result_info.vip_icon = string.format( "%ss%d.png", UIResourcePath.FileLocate.qqvip, info.blue_vip_level )
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
----帐号登录后处理函数
function QQNoneVipInterface:login_function()
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