----------------------------------------------
--------HJH 2014-1-24
---------新选服界面
require "UI/component/Window"
super_class.NewSelectServerPage()
local _target_server_data = nil
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _create2Flow = effectCreator.create2Flow
local _create4Flow = effectCreator.create4Flow
local _rx = UIScreenPos.designToRelativeWidth
local _ry = UIScreenPos.designToRelativeHeight
---------------------------------
function NewSelectServerPage:__init( window_name, texture_name, pos_x, pos_y, width, height )
    pos_y = -20
	local base_panel = CCBasePanelScissor:panelWithFile(0, 0, width, height, "")
	self.view = base_panel
        -- ZBasePanel:create(self.view, "ui2/login/lh_ser_bg.png", 0, 0, 800, 480)
	safe_retain(self.view)


    --self.new_server_list_panel = new_server_list_panel
    ------------------------
    --local temp_bg = ZImage:create( self.view, "ui2/login/temp_bg.png", 400, 180 - 20, 660, 280, nil, 600, 600 )
    --temp_bg:setAnchorPoint(0.5,0.5)
    
    --local server_img = ZImage:create( self.view, "ui2/login/server.png", 0, 0 - 20, -1, -1 )
    --local server_img_size = server_img:getSize()
    ------------------------
    --self.enter_bg = ZImage:create( self.view, "ui2/login_ani/login_server_back.png", 
    --                                          297, 279, -1, -1, nil, -1, -1 )
    
    self.enter_bg = CCBasePanel:panelWithFile(_refWidth(0.5),_ry(279),338,85, "ui2/login/select_bg.png", 500, 500)
    local enter_bg_size = self.enter_bg:getSize()
    self.enter_bg:setAnchorPoint(0.5,0.0)
    ------------------------
    self.view:addChild(self.enter_bg)

    -- local function select_all_server()
        
    --     --if Target_Platform == Platform_Type.YYB or Target_Platform == Platform_Type.QQHall then
    --         RoleModel:change_login_page( "select_server" )
    --         RoleModel:update_role_win( "server_list" )
    --         --self.view:removeFromParentAndCleanup(true)
    --         --PlatformUILoginWin:show_new_server_list(false)
    --    -- else
    --     --    RoleModel:change_login_page( "login" )
    --     --    self.view:removeFromParentAndCleanup(true)
    --         --PlatformUILoginWin:show_new_server_list(false)
    --     --end
    -- end

    local function select_all_server( eventType,msg_id,args)
        -- 记录点击切换按钮进入选择服务器页面
        if BISystem.server_choice ~= nil then
            BISystem:server_choice()
        end
        RoleModel:change_login_page( "select_server" )
        RoleModel:update_role_win( "server_list" )
    end

    self.enter_all_server_btn = ZButton:create(self.enter_bg,
                "ui2/login/lh_change.png", select_all_server, 246, 19, 56, 45, 1)

    -- local enter_all_server_btn = ZButton:create( self.enter_bg, 
    --                                              "ui2/login_ani/login_change_server.png", 
    --                                              select_all_server, 246, 19, -1, -1 )
    local enter_all_server_btn_size = self.enter_all_server_btn:getSize()
    ------------------------
    local sum_width =  enter_bg_size.width + enter_all_server_btn_size.width
    local star_pos_x = ( GameScreenConfig.standard_width - sum_width ) / 2
    --server_img:setPosition( star_pos_x, GameScreenConfig.standard_height - 280 + 55 - 26 )
    --self.enter_bg:setPosition( star_pos_x , GameScreenConfig.standard_height - 320 + 50 - 28 )
    --self.enter_all_server_btn:setPosition( star_pos_x + enter_bg_size.width + 20, GameScreenConfig.standard_height - 320 + 50 - 28 )
    ------------------------
    local new_server_list = RoleModel:get_server_info_list()
    local target_server = new_server_list[1]
    _target_server_data = target_server
    --print("#new_server_list,target_server",#new_server_list,target_server)
    -- if new_server_list ~= nil and #new_server_list > 0 then           
    --     self.server_index = MUtils:create_zxfont(self.enter_bg,"["..target_server.server_id.."服]",41,32,2,16);
    --     local server_index_size = self.server_index:getSize()
        
    --     self.server_index_name = MUtils:create_font_spr( server_name_config[tonumber(target_server.server_id)] ,
    --                                                     self.enter_bg,
    --                                                     41 + server_index_size.width + 20,
    --                                                     32,"ui2/server/")
    -- end      
    ------------------------
    local function enter_btn_fun()
        --self:show_connecting( true )
        local enter_btn_pushed = RoleModel:get_enter_btn_pushed()
        if not enter_btn_pushed then
            require 'UI/UI_Utilities'
            UI_Utilities.DestroyAdButton()
            UI_Utilities.DestroyFixButton()
            UI_Utilities.DestroyResourceButton()
            --UI_Utilities.CreateFixButton()
           -- UI_Utilities.CreateAdButton()
            RoleModel:land_to_game_server( _target_server_data )
            RoleModel:set_enter_btn_pushed( true )
            --PlatformUILoginWin:show_new_server_list(false)
        end
    end

    local enter_btn = ZButton:create( self.view, "ui2/login/lh_enter3.png",  
                                                  enter_btn_fun,
                                                  _refWidth(0.5), 
                                                  _ry(220))

    local scaleIn = CCScaleTo:actionWithDuration(1.0,1);
    local scaleOut = CCScaleTo:actionWithDuration(1.0,1.2);
    local array = CCArray:array();
    array:addObject(scaleIn);
    array:addObject(scaleOut);
    local seq = CCSequence:actionsWithArray(array);
    local action = CCRepeatForever:actionWithAction(seq);

    enter_btn.view:runAction(action)

    enter_btn:setAnchorPoint( 0.5, 0.5 )
    -- local enter_btn_size = enter_btn:getSize()
    -- local enter_text_img = ZImage:create( enter_btn, "ui2/login/kaishiyouxi.png", enter_btn_size.width / 2, -10 )
    -- enter_text_img:setAnchorPoint( 0.5, 0 )
    ------------------------
    --[[
    local function bbs_btn_fun()
        local bbs_url = Lang.kefu.luntan --"http://bbs.agame.qq.com/forum.php?mod=forumdisplay&fid=191"
        phoneGotoURL(bbs_url)
    end
    local enter_bbs_btn = ZImageButton:create( self.view, "ui/common/button4.png", "ui2/login/enter_bbs.png", bbs_btn_fun )
    enter_bbs_btn:setPosition( _refWidth(1.0), _refHeight(0.8) )
    enter_bbs_btn:setAnchorPoint(1.0,1.0)
    ]]--
    
end

function NewSelectServerPage:update()
	--print("run NewSelectServerPage:update")
	local new_server_list = RoleModel:get_server_info_list()
    print('NewSelectServerPage:update()',#new_server_list)
    local target_server = new_server_list[1]
    _target_server_data = target_server
    if self.server_index then
        self.view:removeChild(self.server_index,true)
    end
    -- if self.server_index_name then
    --     self.view:removeChild(self.server_index_name,true)
    -- end
    -- print("#new_server_list,target_server",#new_server_list,target_server)
    if new_server_list ~= nil and #new_server_list > 0 then
     -- print("target_server.server_name",target_server.server_name)           
        if not self.server_index then
            if Target_Platform ~= Platform_Type.NOPLATFORM then
                self.server_index = MUtils:create_zxfont(self.enter_bg, LH_COLOR[1] .. "[" .. target_server.server_name .. "]", 100, 32, 2, 18)
            else
                self.server_index = MUtils:create_zxfont(self.enter_bg, LH_COLOR[1] .. "["..target_server.server_id.."服]",100,32,2,18);
            end
        else
            if Target_Platform ~= Platform_Type.NOPLATFORM then
                self.server_index:setText( "[" .. target_server.server_name .. "]" )
            else
                self.server_index:setText("["..target_server.server_id.."服]")
            end
        end
        local server_index_size = self.server_index:getSize()
        --self.server_index:setPosition( 10 + server_index_size.width / 2, 8 )

        -- if self.server_index_name then
        --     self.enter_bg:removeChild(self.server_index_name,true)
        -- end
        -- self.server_index_name = MUtils:create_font_spr( server_name_config[tonumber(target_server.server_id)] ,
        --                                                  self.enter_bg,
        --                                                  50 + server_index_size.width + 20,36,
        --                                                  "ui2/server/")
    end    
end

function NewSelectServerPage:show_to_center( show_type )
    --[[
    local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( 0, 0 ));          -- 动画
    self.view:runAction( moveto );
    if show_type == "login" or show_type == "register" then 
        --self:reset_page(  )
    end
    ]]--
    self.view:setIsVisible(true)
end

function NewSelectServerPage:hide_to_left( show_type )
    --[[
    local end_x = -_refWidth(1.0)
    if show_type == "login" then
        end_x = _refWidth(1.0)
    end
    local moveto = CCMoveTo:actionWithDuration( RoleModel:get_move_rate(  ), CCPoint( end_x, 0 ));          -- 动画
    self.view:runAction( moveto );
    ]]--切换
    --self.view:setIsVisible(false)
    local delay = CCDelayTime:actionWithDuration(1.0)
    local array = CCArray:array();
    array:addObject(delay)
    array:addObject(CCHide:action());
    local seq = CCSequence:actionsWithArray(array);
    self.view:runAction(seq)
end

function NewSelectServerPage:destroy()
    if self.view ~= nil then
        --print('destroy window', self.__classname,self.view)
        safe_release(self.view)
        self.view = nil
    end
end
