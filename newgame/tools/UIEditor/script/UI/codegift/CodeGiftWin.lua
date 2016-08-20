-- CodeGiftWin.lua  
-- created by lyl on 2013-5-16
-- 活动礼包主窗口  entrust_Win

super_class.CodeGiftWin(NormalStyleWindow)

local _page_info = nil
local _layout_info = nil            -- 布局信息临时变量

-- 活动礼包，图片资源、坐标等，静态配置
code_gift_win_config_ = {
    page1 = {
        bg1 = { img = UILH_MAINACTIVITY.cd_key_bg, x = 280, y = 220, w = -1, h = -1 },

        enter_title = { words = Lang.mainActivity.cdkey[1], x = 215 - 95+60 , y = 43+50 , size = 20, layout = ALIGN_LEFT },          -- 提示语

        enter_frame_bg = { x = 294 , y = 73, w = 300, h = 45, img = UILH_COMMON.bg_10  },   -- 右边区域标题

        enter_frame = { x = 298, y = 76 , w = 280, h = 40, bg = "",  max_num = 20, size = 16, enter_type = EDITBOX_TYPE_NORMAL },          -- 输入框

        get_but = { x = 570 - 75+60 , y = 35+50 , image_path = UILH_COMMON.button4, 
                    word_x = 30, word_y = 13, word_image_path = ""  },          -- 领取按钮

    }
}

function CodeGiftWin:__init( window_name, texture_name )
    
	-- dofile( "E:/mieshen_client/develop/script/UI/codegift/code_gift_win_config.lua" )    -- 动态刷新测试用
    -- require "UI/codegift/code_gift_win_config"
    _page_info = code_gift_win_config_.page1
    local bgPanel = self.view
    -- 背景
    local page_bg = CCBasePanel:panelWithFile(10, 10, 880, 550, UILH_COMMON.normal_bg_v2, 500, 500)
    self.view:addChild(page_bg)

    -- 提示文字
    ZLabel:create(self.view,LH_COLOR[1]..Lang.mainActivity.cdkey[2],450,140,16,2)

    -- 背景图片
    bgPanel:addChild(  CCZXImage:imageWithFile( 267, 166, -1, -1, UILH_MAINACTIVITY.cd_key_bg )  )
    bgPanel:addChild(  CCZXImage:imageWithFile( 361, 246, -1, -1, UILH_MAINACTIVITY.cd_key_libao )  )

    -- 输入框前的文字
    local enter_title = ZLabel:create( bgPanel,LH_COLOR[2]..Lang.mainActivity.cdkey[3], 161, 88, 16, ALIGN_LEFT );

    -- 输入框
    _layout_info = _page_info.enter_frame_bg
    local enter_frame_bg = CCZXImage:imageWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.img, 500, 500 )
    bgPanel:addChild( enter_frame_bg )


    local function edit_box_function(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return true
        end
        if eventType == KEYBOARD_CONTENT_TEXT then
            
        elseif eventType == KEYBOARD_FINISH_INSERT then
            -- ZXLog('-----------detachWithIME---------')
            self:hide_keyboard()
        elseif eventType == TOUCH_BEGAN then
            -- ZXLuaUtils:SendRemoteDebugMessage(self.edit_box:getText())
        elseif eventType == KEYBOARD_WILL_SHOW then
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_show( keyboard_width, keyboard_height ); 
        elseif eventType == KEYBOARD_WILL_HIDE then
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_hide( keyboard_width, keyboard_height );
        end
        return true
    end

    _layout_info = _page_info.enter_frame
    self.enter_frame = CCZXEditBox:editWithFile( _layout_info.x, _layout_info.y, _layout_info.w, _layout_info.h, _layout_info.bg,  _layout_info.max_num, _layout_info.size, _layout_info.enter_type, 500, 500)
    bgPanel:addChild( self.enter_frame )
    self.enter_frame:registerScriptHandler( edit_box_function )

    
    -- 领取按钮
    local function get_but_fun(eventType,x,y)
        self:requet_get_gift(  )
    end

    self.get_gift_but = ZButton:create( self.view, UILH_COMMON.button4, get_but_fun, 602, 77, -1, -1);
    local lingqu_lab = ZLabel:create( self.get_gift_but.view,Lang.benefit.welfare[8],126/2, 20, 16, ALIGN_LEFT )
    local btn_size = self.get_gift_but:getSize()
    local lab_size = lingqu_lab:getSize()
    lingqu_lab:setPosition(btn_size.width/2 - lab_size.width/2,btn_size.height/2 - lab_size.height/2+3)

    local function self_view_func( eventType )
        if eventType == TOUCH_BEGAN then
            self:hide_keyboard()
        end
        return true
    end
    self.view:registerScriptHandler(self_view_func)

end

function CodeGiftWin:requet_get_gift(  )
    local cd_key = self.enter_frame:getText()
    
    OnlineAwardCC:req_get_huodonglibao(cd_key)
    self.enter_frame:setText("");

    -- print("向登录服务器密码验证   ,,,,,,,,,,,,,,      RoleModel:request_server_list_platform")
    
    -- -- 请求回调
    -- local function http_callback( error_code, message )
    --     ZXLog( "请求cdkey礼包 http返回：result_code:", error_code, "message", message )
    --     if error_code == 0 then
    --         ZXLog("http成功！！！", message)
    --         local message_temp = message:match("%s*(.-)%s*$")                 -- 去掉空格  (a,"%s*(.-)%s*$"))
    --         local register_info_t = Utils:Split_old( message_temp, ",|" )     -- 注意请求服务器列表不一样
    --         local resulst_code = register_info_t[1]                           -- 0：操作失败   1：操作成功   -1：其他错误

    --         if resulst_code == "1" then 

    --         else
                
    --         end
    --     else
    --         ZXLog("http失败!!!")
    --         RoleModel:show_notice( "连接服务器失败！请您检查网络是否正常！["..error_code.."]" )
    --     end
    -- end

    -- local login_server_ip = PlatformInterface:getServerIP() or ""
    -- local url = login_server_ip .. get_server_list_page_name  
    -- local param = PlatformInterface:get_servlist_param(  ) or ""
    -- ZXLog("（平台公用）请求服务器列表： url: ", url , "param:", param )


    -- local http_request = HttpRequest:new( url, param, http_callback )
    -- http_request:send()


end
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

------------------弹出/关闭 键盘时将整个ChatXZWin的y坐标的调整
function CodeGiftWin:keyboard_will_show( keyboard_w, keyboard_h )
    self.keyboard_visible = true;
    local win = UIManager:find_visible_window("code_gift_win");
    -- local win_info = UIManager:get_win_info("chat_xz_win")
    if win then
        if keyboard_h == 162 then--ip eg
            win:setPosition(_refWidth(0.5),620);
        elseif keyboard_h == 198 then---ip cn
            win:setPosition(_refWidth(0.5),650);
        elseif keyboard_h == 352 then --ipad eg
            win:setPosition(_refWidth(0.5),620);
        elseif keyboard_h == 406 then --ipad cn
            win:setPosition(_refWidth(0.5),620);
        end
    end
end
function CodeGiftWin:keyboard_will_hide(  )
    self.keyboard_visible = false;
    local win = UIManager:find_visible_window("code_gift_win");
    -- local win_info = UIManager:get_win_info("chat_xz_win")
    if win then
        win:setPosition(_refWidth(0.5),_refHeight(0.5));
    end
end

-------------------- 手动关闭键盘
function CodeGiftWin:hide_keyboard(  )
    if self.enter_frame then
        self.enter_frame:detachWithIME();
    end
end

function CodeGiftWin:destroy(  )
    self:hide_keyboard()
    Window.destroy(self)
end


