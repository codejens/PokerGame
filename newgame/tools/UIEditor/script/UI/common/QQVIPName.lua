----------------------HJH 2013-9-14
-------QQVIP 名字
QQVIPName = {}
Is_Open_QQVIPName = true
------开启显示QQ钻功能
Is_Show_QQVIP_Info = false
-------
---HJH 2013-9-12
----qqvip
function QQVIPName:get_user_qq_vip_info(info)
    -- local player = EntityManager:get_player_avatar()
    -- local qqvip = player.QQVIP
    --print("UserInfoModel:get_user_qq_vip_info info", info)
    if info == nil or Is_Open_QQVIPName == false or Is_Show_QQVIP_Info == false then
        return { blue_vip_level = 0, is_blue_vip = 0, is_blue_year_vip = 0, is_super_blue_vip = 0,
                qq_vip_level = 0, is_qq_vip = 0, is_qq_year_vip = 0, is_qq_super_vip = 0 }
    end
    local diamond_b = Utils:get_byte_by_position( info, 2 )
    local is_diamond_b_vip = Utils:get_bit_by_position( info, 1 )
    local is_diamond_b_year = Utils:get_bit_by_position( info, 2 )
    local is_diamond_b_super = Utils:get_bit_by_position( info, 3 )

    local vip_level = 0
    local is_vip = 0 
    local is_year_vip = 0
    local is_super_vip = 0
    return { blue_vip_level = diamond_b, is_blue_vip = is_diamond_b_vip, is_blue_year_vip = is_diamond_b_year, is_super_blue_vip = is_diamond_b_super,
     qq_vip_level = vip_level, is_qq_vip = is_vip, is_qq_year_vip = is_year_vip, is_qq_super_vip = is_super_vip }
end

function QQVIPName:get_qq_vip_image_info(info)
    local qq_vip_info = QQVIPName:get_user_qq_vip_info(info)
    local result_info = { blue_vip_icon = "", blue_year_icon = "", normal_vip_icon = "", normal_year_icon = "" }
    print("qq_vip_info.blue_vip_leve, qq_vip_info.is_blue_vip, qq_vip_info.is_blue_year_vip, qq_vip_info.is_super_blue_vip",qq_vip_info.blue_vip_level, qq_vip_info.is_blue_vip, qq_vip_info.is_blue_year_vip, qq_vip_info.is_super_blue_vip)
    -----------check blue qq vip icon
    if qq_vip_info.is_blue_vip == 0 then
        result_info.blue_vip_icon = UIResourcePath.FileLocate.qqvip .. "1_d.png"
    else
        if qq_vip_info.is_super_blue_vip == 0 then
            result_info.blue_vip_icon = string.format( "%s%d.png", UIResourcePath.FileLocate.qqvip, qq_vip_info.blue_vip_level )
        else
            result_info.blue_vip_icon = string.format( "%ss%d.png", UIResourcePath.FileLocate.qqvip, qq_vip_info.blue_vip_level )
        end
    end
    ----------check blue year vip
    if qq_vip_info.is_blue_year_vip == 1 then
        result_info.blue_year_icon = UIResourcePath.FileLocate.qqvip .. "year.png"
    else
        result_info.blue_year_icon = UIResourcePath.FileLocate.qqvip .. "year_d.png"
    end
    ----------check normal qq vip icon
    if qq_vip_info.is_qq_vip == 0 then
        result_info.normal_vip_icon = UIResourcePath.FileLocate.qqvip .. "1_d.png"
    else
        if qq_vip_info.is_qq_super_vip == 0 then
            result_info.normal_vip_icon = string.format( "%s%d.png", UIResourcePath.FileLocate.qqvip, qq_vip_info.qq_vip_level )
        else
            result_info.normal_vip_icon = string.format( "%s%sd.png", UIResourcePath.FileLocate.qqvip, qq_vip_info.qq_vip_level )
        end
    end
    ----------check normal year vip
    if qq_vip_info.is_qq_year_vip == 1 then
        result_info.normal_year_icon = UIResourcePath.FileLocate.qqvip .. "year.png"
    else
        result_info.normal_year_icon = UIResourcePath.FileLocate.qqvip .. "year_d.png"
    end
    --print("result_info.blue_vip_icon,result_info.year_icon,result_info.normal_vip_icon,result_info.normal_year_icon",result_info.blue_vip_icon, result_info.blue_year_icon, result_info.normal_vip_icon,result_info.normal_year_icon)
    return result_info
end
----------------------
---创建QQVIP名字
function QQVIPName:create_qq_vip_info(info, name, aline)
	---------HJH 2013-9-12
    ---------qqvip and role name
    local show_vip = false
    local show_year = false
    local add_list = {}
    --------------------
    local qq_blue_vip_icon = nil
    local qq_blue_vip_year_icon = nil
    local qq_blue_vip_icon_size = { width = 0, height = 0 }
    local qq_blue_vip_year_icon_size = { width = 0, height = 0 }
    local qqvip_year_icon_pos = { x = 0, y = 0 }
    --------------------
    qq_blue_vip_icon = Image:create( nil , 0, 0, -1, -1,  UIResourcePath.FileLocate.qqvip .. "1.png" )
    qq_blue_vip_icon_size = qq_blue_vip_icon:getSize()
    table.insert( add_list, qq_blue_vip_icon )
   	--------------------
    qq_blue_vip_year_icon = Image:create( nil, 0, 0, -1, -1, UIResourcePath.FileLocate.qqvip .. "year.png" )
    qq_blue_vip_year_icon_size = qq_blue_vip_year_icon:getSize()
    table.insert( add_list, qq_blue_vip_year_icon )
    --------------------
    local name_lab = Label:create( nil, 0, 0, name )
    table.insert( add_list, name_lab )
    local name_lab_size = name_lab:getSize()
    --------------------
    local panel_height = 0
    if name_lab_size.height > qq_blue_vip_year_icon_size.height then
        panel_height = name_lab_size.height
    else
        panel_height = qq_blue_vip_year_icon_size.height
    end
    --------------------
    local temp_panel = BasePanel:create( nil, 0, 0, qq_blue_vip_icon_size.width + qq_blue_vip_year_icon_size.width + name_lab_size.width, panel_height )
    --------------------
    temp_panel.qq_blue_vip_icon = qq_blue_vip_icon
    temp_panel.qq_blue_vip_year_icon = qq_blue_vip_year_icon
    temp_panel.name_lab = name_lab
    temp_panel.aline = aline
    temp_panel:setTouchBeganReturnValue(false)
    temp_panel:setTouchMovedReturnValue(false)
    temp_panel:setTouchEndedReturnValue(false)
    -------------
    for i = 1, #add_list do
        temp_panel:addChild( add_list[i] )
    end
    -------------reset icon pos
    QQVIPName:reinit_info( temp_panel, info, name )
    -------------
    return temp_panel
end
----------------------
---重设QQVIP名字信息与位置
function QQVIPName:reinit_info(panel, info, name)
    if panel == nil or panel.qq_blue_vip_icon == nil or panel.qq_blue_vip_year_icon == nil or panel.name_lab == nil then
        return
    end
    -------------
    local show_vip = false
    local show_year = false
    local qq_blue_vip_icon_size = { width = 0, height = 0 }
    local qq_blue_vip_year_icon_size = { width = 0, height = 0 }
    local qq_blue_vip_year_icon_pos = { x = 0, y = 0 }
    local temp_panel_size = panel:getSize()
    local qq_vip_info = QQVIPName:get_qq_vip_image_info(info)
    local qq_vip_tar_info = QQVIPName:get_user_qq_vip_info(info)
    --print("qq_vip_tar_info.is_blue_vip,qq_vip_tar_info.is_super_blue_vip,qq_vip_tar_info.is_blue_year_vip",qq_vip_tar_info.is_blue_vip,qq_vip_tar_info.is_super_blue_vip,qq_vip_tar_info.is_blue_year_vip)
    -------------reset vip icon
    if qq_vip_tar_info.is_blue_vip == 1 or qq_vip_tar_info.is_super_blue_vip == 1 then
        panel.qq_blue_vip_icon.view:setTexture( qq_vip_info.blue_vip_icon )
        panel.qq_blue_vip_icon.view:setIsVisible( true )
        show_vip = true
        qq_blue_vip_icon_size = panel.qq_blue_vip_icon:getSize()
    else
        panel.qq_blue_vip_icon.view:setIsVisible( false )
    end
    -------------reset year icon
    if qq_vip_tar_info.is_blue_year_vip == 1 then
        panel.qq_blue_vip_year_icon.view:setTexture( qq_vip_info.blue_year_icon )
        panel.qq_blue_vip_year_icon.view:setIsVisible( true )
        show_year = true
        qq_blue_vip_year_icon_size = panel.qq_blue_vip_year_icon:getSize()
        qq_blue_vip_year_icon_pos = panel.qq_blue_vip_year_icon:getPosition()
    else
        panel.qq_blue_vip_year_icon.view:setIsVisible( false )
    end
    -------------reset name
    panel.name_lab.view:setText( name )
    local name_lab_size = panel.name_lab:getSize()
    -------------
    if show_year == false then
        if show_vip == false then
            if panel.aline == true then
                panel.name_lab:setPosition( 0, 0 )
            else
                panel.name_lab:setPosition( ( temp_panel_size.width - name_lab_size.width ) / 2, 0 )
            end
        else
            panel.qq_blue_vip_icon:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_blue_vip_icon_size.width ) / 2, 0 )
            panel.name_lab:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_blue_vip_icon_size.width ) / 2 + qq_blue_vip_icon_size.width, 0 )
        end
    else
        if show_vip == false then
            panel.qq_blue_vip_year_icon:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_blue_vip_year_icon_size.width ) / 2, 0 )
            panel.name_lab:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_blue_vip_year_icon_size.width ) / 2 + qq_blue_vip_year_icon_size.width, 0 )        
        else
            panel.qq_blue_vip_icon:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_blue_vip_icon_size.width - qq_blue_vip_year_icon_size.width ) / 2, 0 )
            panel.qq_blue_vip_year_icon:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_blue_vip_icon_size.width - qq_blue_vip_year_icon_size.width ) / 2 + qq_blue_vip_icon_size.width, 0 )
            panel.name_lab:setPosition( ( temp_panel_size.width - name_lab_size.width - qq_blue_vip_icon_size.width - qq_blue_vip_year_icon_size.width ) / 2 + qq_blue_vip_icon_size.width + qq_blue_vip_year_icon_size.width, 0 )
        end
    end
end
----------------------
---向后台请求QQVIP信息
function QQVIPName:get_qqvip_request_info()
    if Target_Platform == Platform_Type.QQHall then
        require "platform/PlatformInterface"
        local open_id, token, pf, pf_key = PlatformInterface:getLoginRet()
        local server_url = GameUrl_global:getServerIP()
        return { url = string.format("%s%s",server_url , "getBlueVip") , param = '&openid='..open_id..'&openkey='..token..'&pf='..pf }
    end
end
----------------------
---后台请求返回处理
function QQVIPName.request_callback(error_code, message)
    -- print("QQVIPName:request_callback error_code, message", error_code, message)
    if error_code == 0 then
        local info_list = json.decode( message )
        local temp_info = { }
        temp_info[1] = "is_blue_vip"
        temp_info[2] = info_list['is_blue_vip']
        temp_info[3] = "is_blue_year_vip"
        temp_info[4] = info_list['is_blue_year_vip']
        temp_info[5] = "blue_vip_level"
        temp_info[6] = info_list['blue_vip_level']
        temp_info[7] = "is_super_blue_vip"
        temp_info[8] = info_list['is_super_blue_vip']
        for i = 1, #temp_info do
            -- print("temp_info[i]",temp_info[i])
        end
        MiscCC:send_params_to_server( #temp_info / 2, temp_info )
    else
        NormalDialog:show( string.format("%s%s", "QQVIPName:request_callback error_code=", error_code ), nil, 2 )
    end
end
----------------------
---角色登录后将QQVIP信息发给服务器
function QQVIPName:game_login_qqvip_info_request()
    if Is_Open_QQVIPName == false then
         return
    end
    if Target_Platform == Platform_Type.QQHall  then
        local qqvip_request_info = QQVIPName:get_qqvip_request_info()
        local qqvip_request = HttpRequest:new( qqvip_request_info.url, qqvip_request_info.param, QQVIPName.request_callback )
        qqvip_request:send()
    elseif Target_Platform == Platform_Type.UNKNOW or Target_Platform == Platform_Type.YYB then
        local temp_info = { }
        temp_info[1] = "is_blue_vip"
        temp_info[2] = "0"
        temp_info[3] = "is_blue_year_vip"
        temp_info[4] = "0"
        temp_info[5] = "blue_vip_level"
        temp_info[6] = "0"
        temp_info[7] = "is_super_blue_vip"
        temp_info[8] = "0"
        for i = 1, #temp_info do
            -- print("temp_info[i]",temp_info[i])
        end
        MiscCC:send_params_to_server( 4, temp_info )
    end
end
----------------------
---特殊函数用于摸拟QQVIP等级改变
function QQVIPName:game_login_qqvip_info_request_ex(is_blue_vip, is_blue_year_vip, blue_vip_level, is_super_blue_vip)
    if Target_Platform == Platform_Type.UNKNOW then
        local temp_info = { }
        temp_info[1] = "is_blue_vip"
        temp_info[2] = tostring( is_blue_vip )
        temp_info[3] = "is_blue_year_vip"
        temp_info[4] = tostring( is_blue_year_vip )
        temp_info[5] = "blue_vip_level"
        temp_info[6] = tostring( blue_vip_level )
        temp_info[7] = "is_super_blue_vip"
        temp_info[8] = tostring( is_super_blue_vip )
        for i = 1, #temp_info do
            -- print("temp_info[i]",temp_info[i])
        end
        MiscCC:send_params_to_server( 4, temp_info )
    end
    MiscCC:send_params_to_server( 4, temp_info )
end
----------------------
---当当前角色QQVIP改变时更新相就页面
function QQVIPName:update_panel_for_qqvip_change()
    if Is_Open_QQVIPName == false then
         return
    end
    --------------------
    -- local user_attr_win = UIManager:find_window("user_attr_win")
    -- if user_attr_win ~= nil then
    --     user_attr_win:update_qqvip()
    -- end
    -------------------
    local user_panel = UIManager:find_window("user_panel")
    if user_panel ~= nil then
        user_panel:update_my_qqvip_info()
    end
    -- -------------------
    -- local guild_win = UIManager:find_window("guild_win")
    -- if guild_win ~= nil then
    --     GuildModel:update_qq_vip_info()
    -- end
    -- -------------------
    -- local chat_xz_win = UIManager:find_visible_window("chat_xz_win")
    -- if chat_xz_win ~= nil then
    --     ChatXZModel:reinit_scroll_info()
    -- end
    -- -------------------
    -- local chat_private_win = UIManager:find_visible_window("chat_private_win")
    -- if chat_private_win ~= nil then
    --     ChatPrivateChatModel:reinit_title_info()
    -- end
end
----------------------
---
function QQVIPName:get_qq_blue_vip_url()
    local temp_url = UpdateManager.blue_diamond_url--"http://pay.qq.com/h5/index.shtml?m=buy&c=xxqgame&pf=2016&aid=%s"
    local open_id, token, pf, pf_key = PlatformInterface:getLoginRet()
    local result = string.format( temp_url, tostring(PlatformInterface.AppId) )
    return result
end
-- 支付URL 的规则如下（参数均以get方式传入并对参数值做url编码）：
-- http://pay.qq.com/h5/index.shtml?m=buy&c=XXXXXX&pf=XXXXXX 
-- 参数必须参数描述
-- m是标识为购买页面，目前固定为buy
-- c是业务的代码
-- n否默认数量
-- aid否统计用的，可统计到该aid对应某包月业务的开通量。业务侧自由控制该参数的值
-- ru否开通成功后返回业务的url。（请注意url编码）
-- pf是接入前需联系zoelin申请。主要用于平台侧的业务来源区分。 
-- u有时必须用户qq号。如果是sid登录态需传入此参数。
-- sid有时必须sid登录态的sid。如果是sid登录态需传入此参数。
----------------------
--QQVIP 主屏添加按钮
function QQVIPName:insert_qqvip_icon_fun(panel)
    if Is_Show_QQVIP_Info == true then
        panel:insert_btn(3)
    end
end
----------------------
--商城QQ钻添加按钮
function QQVIPName:mall_win_add_btn(panel)
    if Is_Show_QQVIP_Info == true then
        -----------------
        local qqvip_btn = ZButton:create( nil, UIResourcePath.FileLocate.qqvip .. "blue_btn.png", nil, 500, 28, 100, 40 )
        panel:addChild( qqvip_btn.view )
        local function qqvip_btn_fun()
            if Target_Platform ~= Platform_Type.UNKNOW then              
                local temp_url = QQVIPName:get_qq_blue_vip_url()
                -- print("QQVIPModel:qq_blue_vip_btn_fun url=",temp_url)
                phoneGotoURL(temp_url)  
            end
        end
        qqvip_btn:setTouchClickFun( qqvip_btn_fun )
    end
end