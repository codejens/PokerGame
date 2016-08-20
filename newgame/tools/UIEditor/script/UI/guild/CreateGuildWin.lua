-- CreateGuild.lua
-- created by lyl on 2012-12-27
-- 创建仙宗窗口

super_class.CreateGuildWin(Window)

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _guild_icon  = {}             -- 仙宗图标集合
local _curr_icon_index = 1          -- 当前选中仙宗图标序列号
local _guild_name_edit = nil        -- 名称输入框
local _condition_notice = nil        -- 条件提示lable

--窗体大小
local view_size = CCSize(440,340)
--帮派背景大小
local bgPanel_size = CCSize(120, 240)

--左右选题按钮位置
local left_pos = CCPoint(125,179)

-- 刷新仙宗图标
function CreateGuildWin:flash_guild_icon(  )
	for key, icon in pairs( _guild_icon ) do
        icon:setIsVisible( false )
	end
	_guild_icon[ _curr_icon_index ]:setIsVisible( true )
    if _curr_icon_index == 1 then
       self.select_but_left.view:setCurState( CLICK_STATE_DISABLE ) 
    elseif _curr_icon_index ==GuildCommon:get_icon_max()  then
        self.select_but_right.view:setCurState( CLICK_STATE_DISABLE ) 
    end
end


function CreateGuildWin:__init( window_name, texture_name, is_grid, width, height,title_text  )

    local dialog_bg = self.view

    view_size= CCSize(width,height)

     --标题
    local title_bg = ZImage:create( self.view, UIPIC_COMMOM_title_bg, 0, 0, -1, 60 )
    local title_bg_size = title_bg:getSize()
   -- title_bg:setPosition( ( width - title_bg_size.width ) / 2, height - title_bg_size.height )
   title_bg:setPosition(width/2 - title_bg_size.width/ 2, 296)
    local t_width = title_bg:getSize().width
    local t_height = title_bg:getSize().height
    local window_title = ZImage:create(title_bg, title_text , t_width/2,  t_height-27, -1,-1,999 );
    window_title.view:setAnchorPoint(0.5,0.5)


    --第二层背景
    local bgPanel = CCBasePanel:panelWithFile(view_size.width/2 - 400/2, 63, 400, 240, UILH_COMMON.bottom_bg,500, 500 )
    -- local bgPanel = CCBasePanel:panelWithFile((view_size.width -bgPanel_size.width)/2, 150,bgPanel_size.width,bgPanel_size.height, UIPIC_GRID_nine_grid_bg3,500, 500 )
    dialog_bg:addChild( bgPanel )


    -- 关闭按钮
    local function close_but_CB( )
        self:hide_keyboard()
        UIManager:hide_window( "create_guild_win" )
    end
    local close_btn = ZButton:create(dialog_bg, UIPIC_COMMOM_008, close_but_CB,0,0,-1,-1,999)
    local bg_size = self.view:getSize()
    local close_size = close_btn:getSize()
    close_btn:setPosition( bg_size.width - close_size.width - 9, 296 )

    -- 仙宗图标选择， 左
    local function select_icon_left(  )
        if _curr_icon_index > 1 then
            _curr_icon_index = _curr_icon_index - 1
            self:flash_guild_icon( )
        end
    end

    -- 仙宗图标选择，  右
    local function select_icon_right(  )
        if _curr_icon_index < #_guild_icon then
            _curr_icon_index = _curr_icon_index + 1
            self:flash_guild_icon( )
        end
    end
 
    -- 选择按钮  左   
    self.select_but_left = UIButton:create_button_with_name( left_pos.x, left_pos.y, -1, -1, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal,UILH_COMMON.arrow_disable, "", select_icon_left )
    dialog_bg:addChild( self.select_but_left.view )
    -- 选择按钮 右
    self.select_but_right = UIButton:create_button_with_name( 292, 92, -1, -1, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal,UILH_COMMON.arrow_disable, "", select_icon_right )
    local s_size = self.select_but_right.view:getSize()
    self.select_but_right.view:setFlipX(true)
    self.select_but_right.view:setPosition(view_size.width-left_pos.x-s_size.width,left_pos.y)
    dialog_bg:addChild(self.select_but_right.view )

    -- 军团图标
    local icon_bg = CCZXImage:imageWithFile( 156, 161, 127, 128, "", 500, 500 )
    dialog_bg:addChild(icon_bg)

    for i=1,GuildCommon:get_icon_max() do
        _guild_icon[i] = GuildCommon:get_icon_by_index(i-1, 25, 8, -1, -1)
        icon_bg:addChild(_guild_icon[i])
    end

    self:flash_guild_icon( )

    -- 军团名字输入
    _guild_name_edit = CCZXEditBox:editWithFile( 120, 108, 200, 40, UILH_COMMON.bg_grid1, 6, 16, EDITBOX_TYPE_NORMAL, 500, 500)
    dialog_bg:addChild( _guild_name_edit )

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
    _guild_name_edit:registerScriptHandler( edit_box_function )

    -- 提示信息，  条件  和 所需金钱提示
    _condition_notice = UILabel:create_lable_2( "", 168, 70, 16, ALIGN_LEFT )
    dialog_bg:addChild( _condition_notice )

    -- local needmoney = UILabel:create_lable_2( LangGameString[1127], 190, 68, 16, ALIGN_CENTER ) -- [1127]="#c53ee48创宗所需：250000仙币"
    MUtils:create_zxfont(dialog_bg, LangGameString[1127], 221, 89, 2, 16)
    -- bgPanel:addChild( needmoney )


    -- 创建军团 按钮
    local function create_guild_bt_CBF( eventType, x, y )
        if eventType == TOUCH_CLICK then
            -- 判断输入文字
            local enter_str = _guild_name_edit:getText()
            local check_result, check_msg = GuildModel:check_create_guild_confitions( enter_str )
            if check_result then
                self:hide_keyboard()
                _condition_notice:setString( "" )
                GuildModel:create_guild( _curr_icon_index - 1, enter_str )
                -- close_but_CB( )
            else
                _condition_notice:setString( check_msg )
            end
            self:hide_keyboard()
        end
        return true
    end
    -- 创建军团 按钮
    local create_guild_bt = MUtils:create_btn(self.view,
        UILH_NORMAL.special_btn,
        UILH_COMMON.special_btn_d,
        create_guild_bt_CBF,
        138, 13, -1, -1)

    -- local btn_txt = UILabel:create_lable_2(Lang.guild.create[1], 126/2, 15, 16, ALIGN_CENTER) -- [1]="创建仙宗"/创建军团
    -- create_guild_bt:addChild( btn_txt )

 local create_img = ZImage:create( create_guild_bt, UILH_GUILD.create_guild, 0, 0, -1, -1 )
 local guild_size = create_guild_bt:getSize()
 local img_size = create_img:getSize()
 create_img:setPosition(guild_size.width/2 - img_size.width/2,guild_size.height/2 - img_size.height/2)

    local function self_view_func( eventType )
        if eventType == TOUCH_BEGAN then
            self:hide_keyboard()
        end
        return true
    end
    self.view:registerScriptHandler(self_view_func)
end

function CreateGuildWin:create( texture_name )
	return CreateGuildWin( "CreateGuildWin", "", false, 760, 429);
end

-- 提供外部调用的更新窗口方法。静态调用
function CreateGuildWin:update_create_guild_win( update_type )
	local win = UIManager:find_visible_window( "create_guild_win" )
    if win ~= nil then
        win:update( update_type )
    end
end

function CreateGuildWin:update( update_type )
	if update_type == "init" then
        self:update_init(  )
	end
end

-- 初始化显示
function CreateGuildWin:update_init(  )
	_condition_notice:setString( "" )
	_guild_name_edit:setText( "" )
	_curr_icon_index = 1
    self:flash_guild_icon( )
end

function CreateGuildWin:active( )
    self:update("init")
    if self.exit_btn then
        self.exit_btn:setPosition(363,278)
    end 
end

------------------弹出/关闭 键盘时将整个CreateGuildWin的y坐标的调整
function CreateGuildWin:keyboard_will_show( keyboard_w, keyboard_h )
    self.keyboard_visible = true;
    local win = UIManager:find_visible_window("create_guild_win");
    -- local win_info = UIManager:get_win_info("create_guild_win")
    if win then
        -- local win_pos = win:getPosition()
        -- ZXLog('=====win_pos: ', win_pos.x, win_pos.y)
        if keyboard_h == 162 then--ip eg
            win:setPosition(_refWidth(0.5),500);
        elseif keyboard_h == 198 then---ip cn
            win:setPosition(_refWidth(0.5),550);
        elseif keyboard_h == 352 then --ipad eg
            win:setPosition(_refWidth(0.5),500);
        elseif keyboard_h == 406 then --ipad cn
            win:setPosition(_refWidth(0.5),500);
        end
        -- local win_pos = win:getPosition()
        -- ZXLog('=====win_pos: ', win_pos.x, win_pos.y)
    end
end
function CreateGuildWin:keyboard_will_hide(  )
    self.keyboard_visible = false;
    local win = UIManager:find_visible_window("create_guild_win");
    -- local win_info = UIManager:get_win_info("create_guild_win")
    if win then
        win:setPosition(_refWidth(0.5),_refHeight(0.5));
    end
end

-------------------- 手动关闭键盘
function CreateGuildWin:hide_keyboard(  )
    if _guild_name_edit then
        _guild_name_edit:detachWithIME();
    end
end

function CreateGuildWin:destroy(  )
    self:hide_keyboard()
    -- 汉德这大坑，没释放内存
    Window.destroy(self)
end

