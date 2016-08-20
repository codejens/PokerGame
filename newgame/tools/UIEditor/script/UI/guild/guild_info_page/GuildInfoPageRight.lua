
-- GuildInfoPageRight.lua
-- created by lyl on 2012-1.23
-- 仙宗信息页面

super_class.GuildInfoPageRight( Window )

local font_size = 16

function GuildInfoPageRight:create(  )
	return GuildInfoPageRight( "GuildInfoPageRight", "", false, 850, 500-293 )
end

function GuildInfoPageRight:__init( )
    self:create_panel()
end

-- 创建左侧上部分的面板  军团公告
function GuildInfoPageRight:create_panel()
    local bgPanel = self.view

    --个人信息  本来是GuildInfoPageRight，显示拿到整个页面的左下边来显示
    local up_panel = CCBasePanel:panelWithFile(3, 0, 420, 205, "", 500, 500)
    self.view:addChild(up_panel)
    --个人信息标题
    local title_bg = CCZXImage:imageWithFile( 4, 168, 414, 31, UILH_NORMAL.title_bg4, 500, 500 )
    -- local title = CCZXImage:imageWithFile(22, 2, 71, 23, UIPIC_FAMILY_023)
    -- title_bg:addChild(title)
    local title_name =  UILabel:create_lable_2(LH_COLOR[5]..Lang.guild[29], 154, 10, font_size, ALIGN_LEFT ) 

    local title_bg_size = title_bg:getSize()
    local title_size = title_name:getSize()
    title_name:setPosition(title_bg_size.width/2 - title_size.width/2,title_bg_size.height/2 - title_size.height/2+3)


    title_bg:addChild(title_name)
    up_panel:addChild(title_bg)

    --军团功能
    local down_panel = CCBasePanel:panelWithFile(419, 0, 420, 254, "", 500, 500)
    self.view:addChild(down_panel)



    -- local xinxi = ZImageImage:create(bgPanel, UIResourcePath.FileLocate.guild .. "user_test.png", UIResourcePath.FileLocate.common .. "quan_bg.png", 3, 315, 430, -1, 500, 500) 
    --bgPanel:addChild( CCZXImage:imageWithFile( 10, 307, 107, 19, UIResourcePath.FileLocate.common .. "title_bg_01_s.png", 500, 500 ) )
    --bgPanel:addChild( UILabel:create_lable_2( LangGameString[1210], 15, 312, 15,  ALIGN_LEFT ) ) -- [1210]="#cffff00个人信息"

    up_panel:addChild( UILabel:create_lable_2( Lang.guild[12], 14, 142, font_size, ALIGN_LEFT ) ) -- [1211]="#c38ff33仙宗职位："
    self.guild_standing = UILabel:create_lable_2( "", 108, 142, font_size, ALIGN_LEFT )
    up_panel:addChild( self.guild_standing )

    up_panel:addChild( UILabel:create_lable_2(Lang.guild[13], 14, 102, font_size, ALIGN_LEFT ) ) -- [1212]="#c38ff33当前贡献："
    self.guild_contribution = UILabel:create_lable_2( "", 108, 102, font_size, ALIGN_LEFT )
    up_panel:addChild( self.guild_contribution )

    up_panel:addChild( UILabel:create_lable_2(Lang.guild[14], 14, 58, font_size, ALIGN_LEFT ) ) -- [1213]="#c38ff33积累贡献："
    self.cont_add_up = UILabel:create_lable_2( "", 108, 58, font_size, ALIGN_LEFT )
    up_panel:addChild( self.cont_add_up )

    up_panel:addChild( UILabel:create_lable_2( Lang.guild[15], 14, 14, font_size, ALIGN_LEFT ) ) -- [1214]="#c38ff33仙宗福利："
    self.guild_welfare = UILabel:create_lable_2( "", 108, 14, font_size, ALIGN_LEFT )
    up_panel:addChild( self.guild_welfare )

    -- 领取福利 按钮
    local function get_welfare_fun(  )
        GuildModel:send_get_welfare(  )   -- 如果失败，会返回失败信息
    end
    
    --文字形式按钮
    -- self.get_welfare_but = ZTextButton:create(up_panel, Lang.guild[19], UILH_NORMAL.special_btn, get_welfare_fun, 240, 19, -1, -1) -- [1215]领取福利
    -- self.get_welfare_but.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
    --图片形式按钮
    -- self.get_welfare_but = ZImageButton:create(up_panel, UILH_NORMAL.special_btn, UILH_GUILD.lingqufuli, get_welfare_fun, 240, 19, -1, -1)

    self.get_welfare_but = ZButton:create(up_panel, {UILH_NORMAL.special_btn,UILH_NORMAL.special_btn}, get_welfare_fun, 240, 19, -1, -1);
    self.get_welfare_but:addImage(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d);

    local img  = MUtils:create_zximg(self.get_welfare_but,UILH_GUILD.lingqufuli,40,13,-1,-1)
    -- 化形文字
   
    -- self.consume = UILabel:create_lable_2( "#c1993c4".."消耗#cffffff"..GuildModel:get_welfare_need_consume().."#c1993c4仙宗贡献", 240, 240, 15, ALIGN_LEFT )
    -- up_panel:addChild( self.consume )

    -- 如何获取贡献    要求点击一个区域都有反应，所以背景放一个透明basepanel
    local contribute_bg =  CCBasePanel:panelWithFile( 221, 108, 250, 40, "", 500, 500 )
    local function contribute_bg_fun( eventType, x, y )
        if eventType == TOUCH_CLICK then
            GuildModel:show_notice_win(Lang.guild[16]) -- [16]="1、每天寻找#c27cb58仙宗使者#cffffff完成仙宗任务#r2、通过捐献仙宗灵石#r3、每周日参加#c27cb58天元之战"
        end
        return true
    end
    contribute_bg:registerScriptHandler( contribute_bg_fun )
    up_panel:addChild( contribute_bg )
    --问号
    local question_mark = CCZXImage:imageWithFile( 0, 0, -1, -1, UILH_NORMAL.wenhao )
    contribute_bg:addChild( question_mark ) 
    --问号后面文字
    local get_cont_help_word = CCZXImage:imageWithFile( 40, 9, -1, -1, UILH_GUILD.gongxian)
    contribute_bg:addChild( get_cont_help_word ) 

    
    -- **仙宗功能** 家族功能  军团功能
    -- 军团功能标题  
    local title_bg = CCZXImage:imageWithFile( 3, 215, 411, 31, UILH_NORMAL.title_bg4, 500, 500 )
    local title_name =  UILabel:create_lable_2(LH_COLOR[5]..Lang.guild[31], 171, 10, font_size, ALIGN_LEFT ) 

        local title_bg_size = title_bg:getSize()
    local title_size = title_name:getSize()
    title_name:setPosition(title_bg_size.width/2 - title_size.width/2,title_bg_size.height/2 - title_size.height/2+3)


    title_bg:addChild(title_name)

    down_panel:addChild(title_bg)

    -- local xinxi = ZImageImage:create(bgPanel, UIResourcePath.FileLocate.guild .. "function.png", UIResourcePath.FileLocate.common .. "quan_bg.png", 3, 156, 430, -1, 500, 500) 
    --bgPanel:addChild( CCZXImage:imageWithFile( 10, 155, 107, 19, UIResourcePath.FileLocate.common .. "title_bg_01_s.png", 500, 500 ) )
    --bgPanel:addChild( UILabel:create_lable_2( LangGameString[1217], 15, 160, 15,  ALIGN_LEFT ) ) -- [1217]="#cffff00仙宗功能"

    -- 仙宗领地 按钮  军团任务
    local function guild_manor_fun(  )
        GuildModel:go_to_guild_manor(  )
    end
    self.guild_manor_but = UIButton:create_button_with_name( 20, 100, 98, 98, UILH_NORMAL.skill_bg1, nil, nil, "", guild_manor_fun )
    down_panel:addChild( self.guild_manor_but.view )
    self.guild_manor_but.view:addChild( CCZXImage:imageWithFile( -2, 2, -1, -1,UILH_GUILD.task, 500, 500 ) )
    local title_tag1 =  UILabel:create_lable_2(LH_COLOR[2]..Lang.guild[33], 9, 0, font_size, ALIGN_LEFT ) 
    self.guild_manor_but.view:addChild(title_tag1)

    --驻地
    local function guild_zhudi_fun(  )
        GuildModel:go_to_guild_task_npc(  )
    end
    self.guild_task_but = UIButton:create_button_with_name( 117, 100, 98, 98, UILH_NORMAL.skill_bg1, nil, nil, "", guild_zhudi_fun )
    down_panel:addChild( self.guild_task_but.view )
    self.guild_task_but.view:addChild( CCZXImage:imageWithFile( -2, 8, -1, -1, UILH_GUILD.zhudi, 500, 500 ) )
    local title_tag2 =  UILabel:create_lable_2(LH_COLOR[2]..Lang.guild[34], 9, 0, font_size, ALIGN_LEFT ) 
    self.guild_task_but.view:addChild(title_tag2)

    -- 仙宗捐献 按钮  捐款令牌
    local function guild_contribute_fun(  )
        GuildModel:contribute_to_guild(  )
    end
    self.guild_contribute_but = UIButton:create_button_with_name( 216, 100, 98, 98, UILH_NORMAL.skill_bg1, nil, nil, "", guild_contribute_fun )
    down_panel:addChild( self.guild_contribute_but.view )
    self.guild_contribute_but.view:addChild( CCZXImage:imageWithFile( -2, 2, -1, -1,UILH_GUILD.juanxian, 500, 500 ) )
    local title_tag3 =  UILabel:create_lable_2(LH_COLOR[2]..Lang.guild[35], 9, 0, font_size, ALIGN_LEFT ) 
    self.guild_contribute_but.view:addChild(title_tag3)

    -- 仙宗仓库 按钮
    -- local function guild_task_fun(  )
    --     -- GuildModel:go_to_guild_task_npc(  )
    --     UIManager:show_window("guild_cangku_win");
    --     UIManager:show_window("bag_win");
    -- end
    -- self.guild_task_but = UIButton:create_button_with_name( 216, 100, 98, 98, UILH_NORMAL.skill_bg1, nil, nil, "", guild_task_fun )
    -- down_panel:addChild( self.guild_task_but.view )
    -- self.guild_task_but.view:addChild( CCZXImage:imageWithFile( 16, 16, -1, -1, UIResourcePath.FileLocate.guild .. "cangku.png", 500, 500 ) )


    -- 仙宗商店 按钮
    local function guild_store_fun(  )
        GuildModel:show_guild_store(  )
    end
    self.guild_store_but = UIButton:create_button_with_name( 313, 100, 98, 98, UILH_NORMAL.skill_bg1, nil, nil, "", guild_store_fun )
    down_panel:addChild( self.guild_store_but.view )
    self.guild_store_but.view:addChild( CCZXImage:imageWithFile( -2, 2, -1, -1,UILH_GUILD.gx_shop, 500, 500 ) )
    local title_tag4 =  UILabel:create_lable_2(LH_COLOR[2]..Lang.guild[36], 9, 0, font_size, ALIGN_LEFT ) 
    self.guild_store_but.view:addChild(title_tag4)
 
    -- 军团聊天 按钮
    local function guild_chat_fun(  )
        ChatXZModel:open_xz_chat()
    end
    self.guild_chat_but = TextButton:create( nil, 447, 19, -1, -1, LH_COLOR[2]..Lang.guild[17], UILH_COMMON.btn4_nor ) -- [1218]"家族聊天"
    self.guild_chat_but:setTouchClickFun(guild_chat_fun)
    self.guild_chat_but.view:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.btn4_nor)
    bgPanel:addChild(self.guild_chat_but.view)
    -- self.guild_chat_but = MUtils:create_btn(bgPanel,
    -- UILH_COMMON.btn4_nor,
    -- UILH_COMMON.btn4_sel,
    -- guild_chat_fun,
    -- 499, 19, -1, -1)
    -- local btn_txt = UILabel:create_lable_2(Lang.guild[17], 126/2, 15, 16)
    -- local b_size =  self.guild_chat_but:getSize()
    -- local t_size =  btn_txt:getSize()
    -- btn_txt:setPosition(b_size.width/2-t_size.width/2,b_size.height/2-t_size.height/2+3)
    -- self.guild_chat_but:addChild(btn_txt)
    -- self.guild_chat_but:setAnchorPoint(0.5, 0)

    -- local function guild_fuben_fun(  )
    --     UIManager:show_window("guild_fuben_left")
    --     UIManager:show_window("guild_fuben_right")
    -- end
    -- self.guild_fuben_but = TextButton:create( nil, 180, 0, -1, -1, "家族副本", UIPIC_FAMILY_032 )
    -- self.guild_fuben_but:setTouchClickFun(guild_fuben_fun)
    -- bgPanel:addChild(self.guild_fuben_but.view)

    -- 退出军团 按钮
    local function bow_out_fun(  )
        GuildModel:request_leave_guild(  )
    end
    self.bow_out_but = TextButton:create( nil, 709, 19, -1, -1, LH_COLOR[2]..Lang.guild[18], UILH_COMMON.lh_button_4_r )  -- [1219]"退出家族"
    self.bow_out_but.view:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.lh_button_4_r)
    self.bow_out_but:setTouchClickFun(bow_out_fun)
    bgPanel:addChild(self.bow_out_but.view)


    -- bow_out_but = MUtils:create_btn(bgPanel,
    -- UILH_COMMON.btn4_nor,
    -- UILH_COMMON.btn4_sel,
    -- bow_out_fun,
    -- 709, 19, -1, -1)
    -- local btn_txt = UILabel:create_lable_2(Lang.guild[18], 126/2, 15, 16)
    -- local b_size =  bow_out_but:getSize()
    -- local t_size =  btn_txt:getSize()
    -- btn_txt:setPosition(b_size.width/2-t_size.width/2,b_size.height/2-t_size.height/2+3)
    -- bow_out_but:addChild(btn_txt)
    -- bow_out_but:setAnchorPoint(0.5, 0)
 


    return bgPanel
end

function GuildInfoPageRight:flash_guild_icon(  )
	for key, icon in pairs( self.guild_icon ) do
        icon:setIsVisible( false )
	end
	self.guild_icon[ self.curr_icon_index ]:setIsVisible( true )
end

function GuildInfoPageRight:update( update_type )
    if update_type == "all" then
        self:update_all()
    elseif update_type == "first_page_info" then
        self:update_all()
    elseif update_type == "user_guild_info" then
        self:update_all()
    end
end

-- 刷新所有数据
function GuildInfoPageRight:update_all(  )
    local guild_info = GuildModel:get_user_guild_info(  )
    if guild_info == nil then
        return
    end
    self.guild_standing:setString( "#ccebda6" .. GuildModel:get_guild_standing_name( guild_info.standing )  )   -- 职位
    self.guild_contribution:setString("#ccebda6" .. guild_info.contribution )                                   -- 贡献
    self.cont_add_up:setString("#ccebda6" .. guild_info.cont_add_up )                                           -- 累加贡献值
    local guild_level = GuildModel:get_guild_level( )
    local welfare = GuildModel:get_guild_welfare( guild_level, guild_info.standing ) 
    self.guild_welfare:setString("#ccebda6" .. welfare..Lang.guild[20] )             -- 福利 -- [1220]="#c1993c4仙币"
    if GuildModel:check_if_can_welfare(  ) then
        self.get_welfare_but:setCurState( CLICK_STATE_UP )   
       --xiehande  领取福利特效
    --    local win = UIManager:find_visible_window("guild_win");
    -- if win then
    --     win:play_success_effect();
    -- end
    else
        self.get_welfare_but:setCurState( CLICK_STATE_DISABLE ) 
    end
end


function GuildInfoPageLeft:destroy(  )
     Window.destroy(self);
end