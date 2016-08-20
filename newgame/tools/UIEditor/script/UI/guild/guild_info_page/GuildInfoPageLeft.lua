-- GuildInfoPageLeft.lua
-- created by lyl on 2012-1.23
-- 仙宗信息页面

super_class.GuildInfoPageLeft( Window )


local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

function GuildInfoPageLeft:create(  )
	return GuildInfoPageLeft( "GuildInfoPageLeft", "", false, 850, 293 )
end

function GuildInfoPageLeft:__init( )
    
    --军团信息
    self.panel_up = GuildInfoPageLeft:create_panel_up()
    self.view:addChild( self.panel_up )
    
    --军团公告  本来是GuildInfoPageLeft的，现在拿到整个页面的右上显示
    self.panel_down = GuildInfoPageLeft:create_panel_down()
    self.view:addChild( self.panel_down )
    self:create_down_btn(self.panel_down )

    local function self_view_func( eventType )
        if eventType == TOUCH_BEGAN then
            self:hide_keyboard()
        end
        return true
    end
    self.view:registerScriptHandler(self_view_func)
end

-- 创建左侧上部分的面板
function GuildInfoPageLeft:create_panel_up()
    -- self.guild_icon = {}          -- 仙宗图标集合
    self.curr_icon_index = 1      -- 当前选中仙宗图标序列号

    local bgPanel = CCBasePanel:panelWithFile( 2, 12, 420, 280, "", 500, 500 )
    
    -- 宗徽
    -- local icon_bg = CCZXImage:imageWithFile( 200, 75 - 53, 88, 88, UIResourcePath.FileLocate.guild .. "guild_icon_bg.png", 500, 500 )  -- 图标背景
    -- bgPanel:addChild( icon_bg )
    -- self.guild_icon[ 1 ] = CCZXImage:imageWithFile( 220, 95 - 53, 48, 48, UIResourcePath.FileLocate.guild .. "guild_icon_01.png", 500, 500 )     
    -- bgPanel:addChild( self.guild_icon[1] )
    -- self.guild_icon[ 2 ] = CCZXImage:imageWithFile( 220, 95 - 53, 48, 48, UIResourcePath.FileLocate.guild .. "guild_icon_02.png", 500, 500 )     
    -- bgPanel:addChild( self.guild_icon[2] )
    -- self.guild_icon[ 3 ] = CCZXImage:imageWithFile( 220, 95 - 53, 48, 48, UIResourcePath.FileLocate.guild .. "guild_icon_03.png", 500, 500 )     
    -- bgPanel:addChild( self.guild_icon[3] )
    local icon_bg = CCZXImage:imageWithFile( 258, 141, 110, 110, UILH_NORMAL.skill_bg_b )  -- 图标背景
    bgPanel:addChild(icon_bg)
    self.guild_icon = GuildCommon:get_icon_by_index( 1, 275, 156 ,-1,-1 )
    bgPanel:addChild(self.guild_icon)
    self:flash_guild_icon( )

    bgPanel:addChild( UILabel:create_lable_2( Lang.guild[1], 14, 249, 16, ALIGN_LEFT ) ) -- [1]="#c38ff33家族名称："
    self.guild_name = UILabel:create_lable_2( "", 108, 249, 16, ALIGN_LEFT )
    bgPanel:addChild( self.guild_name )


    bgPanel:addChild( UILabel:create_lable_2( Lang.guild[4], 14, 204, 16, ALIGN_LEFT ) ) -- [5]="#c38ff33家族排名："
    self.guild_ranking = UILabel:create_lable_2( "", 108, 202, 16, ALIGN_LEFT )
    bgPanel:addChild( self.guild_ranking )


    bgPanel:addChild( UILabel:create_lable_2( Lang.guild[3], 14, 166, 16, ALIGN_LEFT ) ) -- [3]="#c38ff33家族等级："
    self.guild_level = UILabel:create_lable_2( "0", 108, 165, 16, ALIGN_LEFT )
    bgPanel:addChild( self.guild_level )


    bgPanel:addChild( UILabel:create_lable_2( Lang.guild[5], 14, 128, 16, ALIGN_LEFT ) ) -- [2]="#c38ff33军团长："
    self.wang_name = UILabel:create_lable_2( "", 108, 127, 16, ALIGN_LEFT )
    bgPanel:addChild( self.wang_name )

    
    bgPanel:addChild( UILabel:create_lable_2( Lang.guild[28], 14, 90, 16, ALIGN_LEFT ) ) -- [2]="#c38ff33阵营："
    self.zhen_ying = UILabel:create_lable_2( "", 108, 89, 16, ALIGN_LEFT )
    bgPanel:addChild( self.zhen_ying )


   bgPanel:addChild( UILabel:create_lable_2( Lang.guild[6], 14,52, 16, ALIGN_LEFT ) ) -- [6]="#cffffff建 设 度：" /灵石/军团令牌
    self.stone_num = UILabel:create_lable_2( "", 108, 52, 16, ALIGN_LEFT )
    bgPanel:addChild( self.stone_num )


    bgPanel:addChild( UILabel:create_lable_2(Lang.guild[2], 14, 15, 16, ALIGN_LEFT ) ) -- [4]="成员数量："
    self.mem_num = UILabel:create_lable_2( "0", 108, 15, 16, ALIGN_LEFT )
    bgPanel:addChild( self.mem_num )

 
    return bgPanel
end

function GuildInfoPageLeft:flash_guild_icon(  )
	-- for key, icon in pairs( self.guild_icon ) do
 --        icon:setIsVisible( false )
	-- end
	-- self.guild_icon[ self.curr_icon_index + 1 ]:setIsVisible( true )
    self.guild_icon:setTexture(GuildCommon:get_icon_path_by_index(self.curr_icon_index))
end

-- 创建左侧下部分的面板 军团公告
function GuildInfoPageLeft:create_panel_down()
    local bgPanel = CCBasePanel:panelWithFile( 425, 65, 411, 228, "", 500, 500)

    -- 标题
    local title_bg = CCZXImage:imageWithFile( 5, 191, 410, 31,UILH_NORMAL.title_bg4, 500, 500 )
    -- local title = CCZXImage:imageWithFile(22, 2, 71, 23, UIPIC_FAMILY_029)
    -- title_bg:addChild(title)
    local title_name =  UILabel:create_lable_2(LH_COLOR[5]..Lang.guild[30], 171, 10, font_size, ALIGN_LEFT ) 

    local title_bg_size = title_bg:getSize()
    local title_size = title_name:getSize()
    title_name:setPosition(title_bg_size.width/2 - title_size.width/2,title_bg_size.height/2 - title_size.height/2+3)


    title_bg:addChild(title_name)
    bgPanel:addChild(title_bg)

    bgPanel:addChild( CCZXImage:imageWithFile( 2, 55, 418, 130, UILH_COMMON.bg_02, 500, 500 ) )
    -- local fengchen = ZImageImage:create(bgPanel, UIResourcePath.FileLocate.guild .. "notice.png", UIResourcePath.FileLocate.common .. "quan_bg.png", 3, 176, 300, -1, 500, 500)       
    --bgPanel:addChild( CCZXImage:imageWithFile( 10, 168, 107, -1, UIResourcePath.FileLocate.common .. "quan_bg.png", 500, 500 ) )
    --bgPanel:addChild( UILabel:create_lable_2( LangGameString[1183], 15, 173, 15,  ALIGN_LEFT ) ) -- [1183]="#cffff00仙宗公告"

    -- 仙宗公告输入.    为支持换行。先使用editbox输入，回车后设置到dialog中。
    self.notice_editbox = CCZXEditBoxArea:editWithFile( 9, 58, 408, 120, "", 40, 16 )
    bgPanel:addChild( self.notice_editbox )

    local function edit_box_function(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return true
        end
        if eventType == KEYBOARD_CONTENT_TEXT then
            
        elseif eventType == KEYBOARD_FINISH_INSERT then
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
   self.notice_editbox:registerScriptHandler(edit_box_function)

    return bgPanel
end

-- 下面按钮栏
function GuildInfoPageLeft:create_down_btn(panel )
--    弹劾族长
    local contribute_bg =  CCBasePanel:panelWithFile( 8, 0, 135, 60, "", 500, 500 )
    --问号
    local question_mark = CCZXImage:imageWithFile( 0, 5, -1,-1, UILH_NORMAL.wenhao )
    contribute_bg:addChild( question_mark )

    local xianzongshenhe = CCZXImage:imageWithFile( 44, 10, -1, -1, UILH_GUILD.tanhe )
    question_mark:addChild( xianzongshenhe )

    local function xianzongdanhe_fun( eventType, x, y )
        if eventType == TOUCH_CLICK then
            -- GuildModel:show_notice_win(   ) 
            HelpPanel:show(3,UILH_NORMAL.title_tips,Lang.guild[7]);--1.宗主连续7日以上不在线，会被罢免宗主职位#r2.宗主职位会转移给在线的宗众，优先转移给在线的副宗主#r3.副宗主不在线，宗主职位会转移给在线，贡献最高的宗众",
        end
        return true
    end
    contribute_bg:registerScriptHandler( xianzongdanhe_fun )
   panel:addChild( contribute_bg )

    -- 修改
    local function modify_but_fun(  )
        local notice_content = self.notice_editbox:getText()
        GuildModel:modify_guild_notice( notice_content )
        self:hide_keyboard()
    end

    self.modify_but = TextButton:create( nil, 299, 0, -1, -1, LH_COLOR[2]..Lang.guild[8],  UILH_COMMON.button2_sel)
      self.modify_but.view:addTexWithFile(CLICK_STATE_DOWN, UILH_COMMON.button2_sel)
    self.modify_but:setTouchClickFun(modify_but_fun)
    panel:addChild(self.modify_but.view)

    -- 清除 
    -- self.clear_button = TextButton:create( nil, 150, 30, -1, -1, Lang.guild[9], UIPIC_COMMOM_001 ) -- [1208]="清除"
    -- if GuildModel:get_user_guild_info().standing ~= 4 then--ip
    --     self.clear_button.view:setIsVisible(false)
    -- end

    -- local function clear_button_function()
    --    if  GuildModel:get_user_guild_info().standing == 4 then
    --      self.notice_editbox:setText("")
    --     end
    -- end
    -- self.clear_button:setTouchClickFun(clear_button_function)
    -- self.view:addChild(self.clear_button.view)
end

function GuildInfoPageLeft:update( update_type )
    if update_type == "all" then
        self:update_all()
    elseif update_type == "first_page_info" then
        self:update_all()
    elseif update_type == "user_guild_info" then
        self:update_all()
    end
end

-- 刷新所有数据
function GuildInfoPageLeft:update_all(  )
    local guild_info = GuildModel:get_user_guild_info(  )
    if guild_info == nil then
        return
    end
    
    self.mem_num:setString("#cd0cda2" .. (guild_info.memb_count or "") .. "/" .. (GuildModel:get_user_guild_max_count() or ""))  --成员
    self.guild_name:setString("#cd0cda2" .. (guild_info.guild_name or "") )  --军团名称
    local guild_level = GuildModel:get_guild_building_level( "biMain" )     --军团等级
    self.guild_level:setString("#cd0cda2" .. guild_level )
    self.guild_ranking:setString("#cd0cda2" .. (guild_info.ranking or "") )  --军团排名
    self.wang_name:setString("#cd0cda2" .. (guild_info.wang_name or "") )    --军团长
    self.stone_num:setString("#cd0cda2" .. (guild_info.stone_num or "") )    --建议度/军团令牌
    local camp  = {[1]=Lang.guild.create.camp[1],[2] = Lang.guild.create.camp[2],[3]=Lang.guild.create.camp[3]}
    self.zhen_ying:setString("#cd0cda2" .. (camp[guild_info.zhenying] or "") )
    local temp_info = ChatModel:check_safe(guild_info.notice)
    if temp_info == nil then
        return
    end
    if guild_info.notice then
        self.notice_editbox:setText( "#cd0cda2"..temp_info )
    else
        self.notice_editbox:setText( Lang.guild[10]) -- [1209]="#cffff00点击输入公告内容"
    end
    -- 宗主才能修改  公告
    if guild_info.standing == 4 then
        self.notice_editbox:setCurState( CLICK_STATE_UP )   
        self.modify_but.view:setIsVisible( true )
      --  self.clear_button.view:setIsVisible(true)
    else
        self.notice_editbox:setCurState( CLICK_STATE_DISABLE )   
        self.modify_but.view:setIsVisible( false )
      -- self.clear_button.view:setIsVisible(false)
    end
    self.notice_editbox:isRunIcon( false )

    -- 图标
    self.curr_icon_index = guild_info.icon
    self:flash_guild_icon(  )
end

-- 更新元素
function GuildInfoPageLeft:update_element( update_type )
    local guild_info = GuildModel:get_user_guild_info(  )
    if update_type == "stone_num" then
        self.stone_num:setString("#cd0cda2" .. guild_info.stone_num )
    end
end

------------------弹出/关闭 键盘时将整个GuildInfoPageLeft的y坐标的调整
function GuildInfoPageLeft:keyboard_will_show( keyboard_w, keyboard_h )
    self.keyboard_visible = true;
    local win = UIManager:find_visible_window("guild_win");
    -- local win_info = UIManager:get_win_info("guild_win")
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
function GuildInfoPageLeft:keyboard_will_hide(  )
    self.keyboard_visible = false;
    local win = UIManager:find_visible_window("guild_win");
    -- local win_info = UIManager:get_win_info("guild_win")
    if win then
        win:setPosition(_refWidth(0.5),_refHeight(0.5));
    end
end

-------------------- 手动关闭键盘
function GuildInfoPageLeft:hide_keyboard(  )
    if self.notice_editbox then
        self.notice_editbox:detachWithIME();
    end
end

function GuildInfoPageLeft:destroy(  )
    self:hide_keyboard()
     Window.destroy(self);
end


