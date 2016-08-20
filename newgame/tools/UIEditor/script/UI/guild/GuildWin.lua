
-- GuildWin.lua  
-- created by lyl on 2012-12-26
--alter by xiehande on 2014-12-11
-- 仙宗主窗口  guild_win

super_class.GuildWin(NormalStyleWindow)


require "UI/guild/GuildCommon"
require "config/ComAttribute"


-- 创建仙宗按钮回调
local function create_guild_bt_CBF(  )
    GuildModel:show_create_guild_win(  )
end

--窗体大小
local window_width = 900
local window_height = 605

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function GuildWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name, but_name_s,but_name_siz_w, but_name_siz_h, but_index)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
	local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            self:change_page( but_index )
            return true;
        elseif eventType == TOUCH_BEGAN then
            
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
	end
    radio_button:registerScriptHandler(but_1_fun)    --注册
    panel:addGroup(radio_button)

    --按钮显示的名称
    --self.btn_name_t[but_index] = GuildWin:create_btn_name(but_name,but_name_s,size_w/2,size_h/2,but_name_siz_w,but_name_siz_h)

    self.btn_name_t[but_index] = ZLabel:create( nil, but_name, 0, 0)
    local btn_size = radio_button:getSize()
    local lab_size = self.btn_name_t[but_index]:getSize()
    self.btn_name_t[but_index]:setPosition( ( btn_size.width - lab_size.width ) / 2, ( btn_size.height - lab_size.height ) / 2 )

    radio_button:addChild( self.btn_name_t[but_index].view )
    return radio_button
end


--xiehande  
-- function  GuildWin:create_btn_name( btn_name_n,btn_name_s,name_x,name_y,btn_name_size_w,btn_name_size_h )
--     -- 按钮名称贴图集合
--     local  button_name = {}
--     local  button_name_image = CCZXImage:imageWithFile(name_x,name_y,btn_name_size_w,btn_name_size_h,btn_name_n)
--     button_name_image:setAnchorPoint(0.5,0.5)
--     button_name.view = button_name_image
--     --按钮被选中，调用函数切换贴图至btn_name_s
--     button_name.change_to_selected = function ( )
--         button_name_image:setTexture(btn_name_s)
--     end

--     --按钮变为未选时  切换贴图到btn_name_n
--     button_name.change_to_no_selected = function ( )
--         button_name_image:setTexture(btn_name_n)
--     end

--     return button_name

-- end

--切换功能窗口:   
function GuildWin:change_page( but_index )
    --    for k,v in pairs(self.btn_name_t) do
    --    v.change_to_no_selected()
    -- end
    -- self.btn_name_t[but_index].change_to_selected()
            
    -- 外部切换时，因为没有触发事件，用程序设置按下状态
    if but_index ~= 11 then
        self.had_join_buts:selectItem( but_index - 1)
    end
    -- 把当前显示的页隐藏
    if self.current_panel then
        self.current_panel.view:setIsVisible(false)
    end
    
    local curr_page_width = 860
    local curr_page_height = 410
   
    if but_index == BENEFIT_FULI_TAG then   --家族信息
        if self.all_page_t[BENEFIT_FULI_TAG] == nil then
            self.all_page_t[BENEFIT_FULI_TAG] =  GuildInfoPage:create()
            curr_page_width =  self.all_page_t[BENEFIT_FULI_TAG]:getSize().width
            self.all_page_t[BENEFIT_FULI_TAG].view:setPosition(window_width/2-curr_page_width/2, 13)
            self.view:addChild( self.all_page_t[BENEFIT_FULI_TAG].view )
        end
        self.current_panel = self.all_page_t[BENEFIT_FULI_TAG]
    elseif  but_index == FAMILY_MEM_TAG then  --成员管理
        if self.all_page_t[FAMILY_MEM_TAG] == nil then
            self.all_page_t[FAMILY_MEM_TAG] =  GuildMember:create()
            curr_page_width =  self.all_page_t[FAMILY_MEM_TAG]:getSize().width
            self.all_page_t[FAMILY_MEM_TAG].view:setPosition(window_width/2-curr_page_width/2, 13)
            self.view:addChild( self.all_page_t[FAMILY_MEM_TAG].view )
        end
        self.current_panel = self.all_page_t[FAMILY_MEM_TAG]
    elseif  but_index == FAMILY_ACTION_TAG then   --家族动态
        if self.all_page_t[FAMILY_ACTION_TAG] == nil then
            self.all_page_t[FAMILY_ACTION_TAG] = GuildAction:create()
            self.all_page_t[FAMILY_ACTION_TAG].view:setPosition(33, 28)
            self.view:addChild( self.all_page_t[FAMILY_ACTION_TAG].view )
        end
        self.current_panel = self.all_page_t[FAMILY_ACTION_TAG]
    elseif  but_index == BENEFIT_VERSION_TAG then    --军团建设
        if self.all_page_t[BENEFIT_VERSION_TAG] == nil then
            self.all_page_t[BENEFIT_VERSION_TAG] =  GuildBuilding:create()
            curr_page_width =  self.all_page_t[BENEFIT_VERSION_TAG]:getSize().width
            self.all_page_t[BENEFIT_VERSION_TAG].view:setPosition(window_width/2-curr_page_width/2, 13)
            self.view:addChild( self.all_page_t[BENEFIT_VERSION_TAG].view )
        end
        self.current_panel = self.all_page_t[BENEFIT_VERSION_TAG]
    elseif but_index == FAMILY_ALTAR_TAG then                --军团战旗
        self:check_page_five()
    elseif  but_index == FAMILY_LIST_TAG then    --家族列表
        if self.all_page_t[FAMILY_LIST_TAG] == nil then
            self.all_page_t[FAMILY_LIST_TAG] =  GuildList:create()
            curr_page_width =  self.all_page_t[FAMILY_LIST_TAG]:getSize().width
            self.all_page_t[FAMILY_LIST_TAG].view:setPosition(window_width/2-curr_page_width/2, 13)
            self.view:addChild( self.all_page_t[FAMILY_LIST_TAG].view )
        end
        self.current_panel = self.all_page_t[FAMILY_LIST_TAG]
    elseif  but_index == FAMILY_WAR_TAG then 
        if self.all_page_t[FAMILY_WAR_TAG] == nil then
            self.all_page_t[FAMILY_WAR_TAG] =  GuildTianyan:create()    --天元之战
            curr_page_width =  self.all_page_t[FAMILY_WAR_TAG]:getSize().width
            self.all_page_t[FAMILY_WAR_TAG].view:setPosition(window_width/2-curr_page_width/2, 13)
            self.view:addChild( self.all_page_t[FAMILY_WAR_TAG].view )
        end
        self.current_panel = self.all_page_t[FAMILY_WAR_TAG]
    elseif but_index == 11 then       --家族列表
        if self.all_page_t[11] == nil then
            self.all_page_t[11] =  GuildList:create()
            curr_page_width =  self.all_page_t[11]:getSize().width
            self.all_page_t[11].view:setPosition(window_width/2-curr_page_width/2, 13)
            self.view:addChild( self.all_page_t[11].view )
        end
        self.current_panel  =  self.all_page_t[11]
    elseif but_index == FAMILY_APPLY_TAG then   
        if self.all_page_t[FAMILY_APPLY_TAG] == nil then
            self.all_page_t[FAMILY_APPLY_TAG] = GuildApplyWin:create()  --申请列表
            curr_page_width =  self.all_page_t[FAMILY_APPLY_TAG]:getSize().width
            self.all_page_t[FAMILY_APPLY_TAG].view:setPosition(window_width/2-curr_page_width/2-10, 13)
            self.view:addChild(self.all_page_t[FAMILY_APPLY_TAG].view)
        end
        self.current_panel = self.all_page_t[FAMILY_APPLY_TAG]
    end
    
    -- self.current_panel:syn_date(  )
    if self.current_panel and self.current_panel.update then
        self.current_panel:update( "all" )
    end
    self.current_panel.view:setIsVisible(true)
end


function GuildWin:__init( window_name, texture_name )
    self.all_page_t = {}              -- 存储所有已经创建的页面
    self.current_panel = nil      -- 当前的面板。用于记录 界面。在切换的时候做操作
    self.btn_name_t = {}  --标签不同文字贴图集合
      --背景框
    local bgPanel = self.view
    window_width = bgPanel:getSize().width
    window_height = bgPanel:getSize().height

    -- 顶部所有按钮

    local win_size = self.view:getSize();
    local but_beg_x = 35          --按钮起始x坐标
    local but_beg_y = win_size.height - 105        --按钮起始y坐标
    local but_int_x = 101          --按钮x坐标间隔 102
    local btn_w = -1  
    local btn_h = -1


    -- 未加入仙宗情况下的按钮
    self.not_join_buts = CCRadioButtonGroup:buttonGroupWithFile( but_beg_x ,
        but_beg_y , 
        but_int_x * 1,
        42, nil )
    bgPanel:addChild( self.not_join_buts )
   --71 18--> -1 -1
    self:create_a_button(self.not_join_buts, 
        1 + but_int_x * (1 - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.guild.create[2] ,
        "",
        -1, -1, 11)


    -- 创建仙宗按钮
    local create_guild_func = function(eventType,x,y)
        if eventType == TOUCH_CLICK then
            create_guild_bt_CBF()
        end
        return true
    end
    self.create_guild_bt = MUtils:create_btn(bgPanel,
        UILH_GUILD.button_lv,
        UILH_GUILD.button_lv,
        create_guild_func,
        712-5, 527, -1, -1)
    local btn_txt = UILabel:create_lable_2(Lang.guild.create[1], 61, 21, 16, ALIGN_CENTER)-- "创建仙宗"
    self.create_guild_bt:addChild( btn_txt )



    -- 加入仙宗情况下的按钮
    self.had_join_buts = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,
        but_beg_y, 
        but_int_x * 8, 
        42,
        nil)
    bgPanel:addChild( self.had_join_buts )


    local i = 1
    --78 11 ->-1 -1
    self:create_a_button(self.had_join_buts, 
        1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.guild.tab[1],
        "",
        -1, -1, i)
    BENEFIT_FULI_TAG = i

    i = i + 1   -- i = 2
    self:create_a_button(self.had_join_buts, 
        1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.guild.tab[2],
        "",
        -1, -1, i)
    FAMILY_MEM_TAG = i

    i = i + 1   -- i = 3
    self:create_a_button(self.had_join_buts, 
        1 + but_int_x * (i - 1), 1, btn_w, btn_h,
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.guild.tab[3],
        "",
        -1, -1, i)
    FAMILY_APPLY_TAG = i

    i = i + 1   -- i = 4
    self:create_a_button(self.had_join_buts, 
        1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.guild.tab[4],
        "",
        -1, -1, i)
    BENEFIT_VERSION_TAG = i

    --军团战旗/(过往版本为神兽)
    i = i + 1   -- i = 5
    self:create_a_button(self.had_join_buts, 
        1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.guild.tab[7], 
        "",
        -1, -1, i)
   FAMILY_ALTAR_TAG = i

    -- i = i + 1   -- i = 6
    -- self:create_a_button(self.had_join_buts, 
    --     1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
    --     UIPIC_FAMILY_001,
    --     UIPIC_FAMILY_002,
    --     UIPIC_FAMILY_069,
    --     UIPIC_FAMILY_003,
    --     -1, -1, i)
    -- FAMILY_ACTION_TAG = i

    i = i + 1   -- i = 7
    self:create_a_button(self.had_join_buts, 
        1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.guild.tab[5],
        "",
        -1, -1, i)
    FAMILY_LIST_TAG =  i

    -- i = i + 1   -- i = 8
    -- self:create_a_button(self.had_join_buts, 
    --     1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
    --     UIPIC_FAMILY_001,
    --     UIPIC_FAMILY_002, 
    --     UIPIC_FAMILY_007,
    --     71, 18, i)

    i = i + 1   -- i = 7
    self:create_a_button(self.had_join_buts, 
        1 + but_int_x * (i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.guild.tab[6],
        "",
        -1, -1, i)

    FAMILY_WAR_TAG = i
    self:update( "if_join_guild" )
end

function GuildWin:create( texture_name )
	return GuildWin("GuildWin", texture_name, false, 850, 490);
end

-- 提供外部调用更新的静态方法
function GuildWin:update_guild_win( update_type )
    local win = UIManager:find_visible_window( "guild_win" )
    if win ~= nil then
        win:update( update_type )
    end
end

function GuildWin:update( update_type )
    if update_type == "if_join_guild" then
        self:update_if_join_guild(  )
    elseif update_type == "guildId" then
        self:update_if_join_guild(  )
    else
        self.current_panel:update( update_type )
    end
end

-- 根据是否加入仙宗，显示上面的单选卡数量
function GuildWin:update_if_join_guild(  )
    if GuildModel:check_if_join_guild( ) then
        self.not_join_buts:setIsVisible(false)
        self.create_guild_bt:setIsVisible(false)
        self.had_join_buts:setIsVisible(true)

        if self.current_panel == self.all_page_t[11] then
            self:change_page( 1 )
        end
    else
        self.not_join_buts:setIsVisible(true)
        self.create_guild_bt:setIsVisible(true)
        self.had_join_buts:setIsVisible(false)
        self:change_page( 11 )
    end
end

-- 显示某个仙宗的详细信息 (静态方法)
function GuildWin:show_guild_detail( guild )
    local win = UIManager:find_visible_window( "guild_win" )
    if win ~= nil then
       local detail_win =  UIManager:find_visible_window( "guild_detail_win" )
       if detail_win~=nil then 
          detail_win:set_content(guild)
          detail_win.view:setIsVisible(true)
       else
         local win = GuildDetailPanel:show(guild)
       end
    end
end

--显示捐献界面  未使用
function GuildWin:show_donate_win( ... )
    local win = UIManager:find_visible_window("guild_win")
    if win then
        if win.donateWin then
            win.donateWin.view:setIsVisible(true)
        else
            win.donateWin = FamilyDonateWin:create()
            win.donateWin.view:setPosition(232, 200)
            win.view:addChild(win.donateWin.view)
        end
    end
end

--隐藏捐献界面  未使用
function GuildWin:hide_donate_win( ... )
    local win = UIManager:find_visible_window("guild_win")
    if win then
        if win.donateWin then
            win.donateWin.view:setIsVisible(false)
        end
    end
end


function GuildWin:show_nominate_win( param )
    local win = UIManager:find_visible_window("guild_win")
    if win then
        if win.nominateWin then
            win.nominateWin.view:setIsVisible(true)
            win.nominateWin:set_mem_info(param)
        else
            win.nominateWin = FamilyNominateWin:create(param)
            -- win.nominateWin:set_mem_info(param)
            win.nominateWin.view:setPosition(232, 200)
            win.view:addChild(win.nominateWin.view)
        end
    end
end

function GuildWin:hide_nominate_win( ... )
    local win = UIManager:find_visible_window("guild_win")
    if win then
        if win.nominateWin then
            win.nominateWin.view:setIsVisible(false)
        end
    end
end

-- 隐藏某个仙宗详细信息的显示
-- function GuildWin:hide_guild_detail( )
--     local win = UIManager:find_visible_window( "guild_win" )
--     if win ~= nil then
--         if win.detailPanel then
--             win.detailPanel.view:setIsVisible( false )
--         end
--     end
    
-- end

-- 激活窗口更新 
function GuildWin:active( show )
    if show then
        --切换标题文字图片
        -- if GuildModel:get_is_return_init() == false then
        --     self:change_page(1)
        --     GuildModel:set_is_return_init(true)
        -- end
        if GuildModel:get_is_return_init() == false then
            GuildModel:set_is_return_init(true)
            if self.current_panel == self.all_page_t[FAMILY_ALTAR_TAG] then
                GuildModel:open_guild_altar()
            end
        end
        if self.current_panel and self.current_panel.update then
            self.current_panel:update("all")
        end

    elseif ( show == false ) then 
        local help_win = UIManager:find_visible_window("help_panel")
        if help_win ~= nil then
            UIManager:hide_window("help_panel")
        end
        -- 新手指引代码 
        -- if (XSZYManager:get_state() == XSZYConfig.XIAN_ZONG_ZY ) then
        --     AIManager:do_quest(TaskModel:get_zhuxian_quest());
        --     XSZYManager:destroy()
        -- end
    end
end
------------
function GuildWin:clear_altar_page()
    if self.all_page_t[FAMILY_ALTAR_TAG] ~= nil then
        self.view:removeChild( self.all_page_t[FAMILY_ALTAR_TAG].view , true )
        self.all_page_t[FAMILY_ALTAR_TAG]:destroy()
        self.all_page_t[FAMILY_ALTAR_TAG] = nil 
    end
end
------------
function GuildWin:page_altar_page_change()
    if self.all_page_t[FAMILY_ALTAR_TAG] ~= nil and self.current_panel == self.all_page_t[FAMILY_ALTAR_TAG] then
        ----------delete cur page
        self.view:removeChild( self.all_page_t[FAMILY_ALTAR_TAG].view , true )
        self.all_page_t[FAMILY_ALTAR_TAG]:destroy()
        self.all_page_t[FAMILY_ALTAR_TAG] = nil
        ----------

        self.all_page_t[FAMILY_ALTAR_TAG] = GuildAltarPage:create()
        --设置军团战旗的页面位置
        curr_page_width =  self.all_page_t[FAMILY_ALTAR_TAG].view:getSize().width
        self.all_page_t[FAMILY_ALTAR_TAG].view:setPosition(window_width/2-curr_page_width/2-10, 13)
        ----------
        self.view:addChild( self.all_page_t[FAMILY_ALTAR_TAG].view )
        self.current_panel = self.all_page_t[FAMILY_ALTAR_TAG]
        GuildModel:set_guild_altar_page_type(1)
        GuildModel:set_guild_altar_page_init_info( false )
        GuildModel:open_guild_altar()
        self:update_guild_win("update_all")
    end
end
------------
--检查是第一级的战旗或者二级以上战旗
function GuildWin:check_page_five()
    local altar_egg_info = GuildModel:get_guild_altar_egg_page_info()  --蛋
    local altar_pet_info = GuildModel:get_guild_altar_page_info()  --兽
    local page_five_init_info = GuildModel:get_guild_altar_page_init_info()
    if page_five_init_info == false then
        if self.all_page_t[FAMILY_ALTAR_TAG] ~= nil then

            self.view:removeChild( self.all_page_t[FAMILY_ALTAR_TAG].view, true )
            self.all_page_t[FAMILY_ALTAR_TAG]:destroy()
            self.all_page_t[FAMILY_ALTAR_TAG] = nil
        end
        GuildModel:set_guild_altar_page_init_info( true )
    end
    if self.all_page_t[FAMILY_ALTAR_TAG] == nil then
       if altar_pet_info.pet_level > 0 then  --兽页
            self.all_page_t[FAMILY_ALTAR_TAG] = GuildAltarPage:create()
            GuildModel:set_guild_altar_page_type(1)
        else     --蛋页
            self.all_page_t[FAMILY_ALTAR_TAG] = GuildAltarEggPage:create()
            GuildModel:set_guild_altar_page_type(0)    
        end
        --设置军团战旗的页面位置
        curr_page_width =  self.all_page_t[FAMILY_ALTAR_TAG].view:getSize().width
        self.all_page_t[FAMILY_ALTAR_TAG].view:setPosition(window_width/2-curr_page_width/2, 13)
        self.view:addChild( self.all_page_t[FAMILY_ALTAR_TAG].view )
        self.current_panel = self.all_page_t[FAMILY_ALTAR_TAG]
    end
    self.current_panel = self.all_page_t[FAMILY_ALTAR_TAG]
    GuildModel:open_guild_altar()
end

function GuildWin:update_guild_self_qqvip_info()
    if self.all_page_t[2] ~= nil then

    end
    if self.all_page_t[6] ~= nil then

    end
    if self.all_page_t[11] ~= nil then

    end
end
------------
function GuildWin:destroy()
    -----------HJH
    -----------2013-3-18
    -----------补上DESTROY方法
    if self.all_page_t ~= nil and type(self.all_page_t) == "table" then
        for key, page in pairs(self.all_page_t) do
            self.view:removeChild( page.view, true )
            page:destroy()
        end 
    end
    -- 详细信息界面
    if self.detailPanel then 
        self.detailPanel:destroy()
    end

        Window.destroy(self)

end
