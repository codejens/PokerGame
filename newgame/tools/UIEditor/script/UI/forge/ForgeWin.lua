-- ForgeWin.lua
-- created by lyl on 2012-12-11
-- 炼器主窗口

super_class.ForgeWin(NormalStyleWindow)


local _current_page = nil       --当前的面板。用于记录 强化装备、宝石镶嵌、等界面。在切换的时候做操作

--标记手否在等待操作的结果。在发送强化等消息后，会有装备变化。
--接受服务器消息后，会使用这个“静态变量”来判断，是否是本界面发送的消息，是的话，就调用相关方法（显示成功或者失败）
local _if_waiting_result = false 
local _if_waiting_reflash = false

--标记手否在等待背包更新。在发送强化等消息后，会有装备变化。
--接受服务器消息后，会使用这个“静态变量”来判断，是否是本界面发送的消息，是的话，就调用相关方法（刷新装备显示）
local if_waiting_reflash = false  

-- 用于记录radio_group的页数
local _radio_group_page = 1;

-- 可静态调用
function ForgeWin:set_if_waiting_result( if_waiting_result )
    _if_waiting_result = if_waiting_result
end

function ForgeWin:get_if_waiting_result(  )
    return _if_waiting_result
end

function ForgeWin:set_if_waiting_reflash( if_waiting_reflash )
    _if_waiting_reflash = if_waiting_reflash
end

function ForgeWin:get_if_waiting_reflash(  )
    return _if_waiting_reflash
end


-- 一个静态方法。可以静态调用。让model调用更新数据
function ForgeWin:forge_win_update( update_type, server_resp )
    local win = UIManager:find_visible_window( "forge_win" )
    if win ~= nil then
        win:update( update_type, server_resp )
    end
end

-- 更新数据      参数：更新的类型, args:参数
function ForgeWin:update( update_type ,args)
    if update_type == "bag" then
        _current_page:update( "bag" )
    elseif update_type == "equipment" then
        _current_page:update( "equipment" )
    else
        _current_page:update( update_type ,args)
    end
end


-- 跳转到合成界面，强化类型（强化中，材料不够时，合成高级以上强化符使用） 
function ForgeWin:goto_synth(  )
    self:change_page( 3 )
    _current_page:change_to_strength()
end

-- 跳转某个界面界面。  强化：strengthen  镶嵌：set   合成-其他： synth_3  合成-宝石 synth_1  
function ForgeWin:goto_page( page_name)
    -- 供其他功能静态使用的方法，在这里 show window
    local win = UIManager:show_window( "forge_win" )
    if page_name == "strengthen" then
        win:change_page( 1 )
    elseif page_name == "strengthen_user" then             -- 打开炼器界面，道具显示人物身上道具
        win:change_page( 1 )
    elseif page_name == "strengthen_bag" then             -- 打开炼器界面，道具显示人物身上道具
        win:change_page( 1 )
    elseif page_name == "set" then
        win:change_page( 2 )
    elseif page_name == "set_user" then
        win:change_page( 2 )
    elseif page_name == "set_bag" then
        win:change_page( 2 )
    elseif page_name == "synth_1" then
        win:change_page( 3 )
        _current_page:change_to_gem()
    elseif page_name == "synth_2" then
        win:change_page( 3 )
        
    elseif page_name == "synth_3" then
        win:change_page( 3 )
        _current_page:change_to_other( )
    elseif page_name == "transfer" then
        win:change_page( 4 )
    elseif page_name == "upgrade" then
        win:change_page( 5 )
    -- 切换到提品
    elseif page_name == "tipin" then
        win:change_page( 6 )
    end
end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function ForgeWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,but_name,but_name_s, but_name_siz_w, but_name_siz_h, but_index)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
	local function but_1_fun(eventType,x,y)
		if eventType == TOUCH_BEGAN  then 
			--根据序列号来调用方法
            
			return true
        elseif eventType == TOUCH_CLICK then
            -- Instruction:handleUIComponentClick(instruct_comps.FORGE_WIN_OK_PAGE_BASE + but_index)
            self:change_page( but_index )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
		end
	end
    radio_button:registerScriptHandler(but_1_fun)    --注册
    panel:addGroup(radio_button)
    --按钮显示的名称
  --  local name_image = CCZXImage:imageWithFile( 13, 10+5+3, but_name_siz_w, but_name_siz_h, but_name );  
    --self.btn_name_t[but_index] = ForgeWin:create_btn_name(but_name,but_name_s,size_w/2,size_h/2,-1,-1)

    self.btn_name_t[but_index] = ZLabel:create( nil, but_name, 0, 0)
    local btn_size = radio_button:getSize()
    local lab_size = self.btn_name_t[but_index]:getSize()
    self.btn_name_t[but_index]:setPosition( ( btn_size.width - lab_size.width ) / 2, ( btn_size.height - lab_size.height ) / 2 )
    radio_button:addChild( self.btn_name_t[but_index].view )
    return radio_button
end

--xiehande
function  ForgeWin:create_btn_name( btn_name_n,btn_name_s,name_x,name_y,btn_name_size_w,btn_name_size_h )
    -- 按钮名称贴图集合
    local  button_name = {}
    local  button_name_image = CCZXImage:imageWithFile(name_x,name_y,btn_name_size_w,btn_name_size_h,btn_name_n)
    button_name_image:setAnchorPoint(0.5,0.5)
    button_name.view = button_name_image
    --按钮被选中，调用函数切换贴图至btn_name_s
    button_name.change_to_selected = function ( )
        button_name_image:setTexture(btn_name_s)
    end

    --按钮变为未选时  切换贴图到btn_name_n
    button_name.change_to_no_selected = function ( )
        button_name_image:setTexture(btn_name_n)
    end

    return button_name

end
--切换功能页面:   1:装备强化   2：宝石镶嵌   3:物品合成   4：强化转移   5：装备升级
-- 天降雄师功能界面：（1）装备强化界面（2）宝石镶嵌界面（3）物品合成界面
--                   （4）强化转移界面（5）装备升级界面（6）装备提品界面（7）装备升阶界面
function ForgeWin:change_page( but_index )
    -- 做单选效果先所有按钮设置成非选择状态，再把选中的设置成选择状态
    -- for i, v in ipairs( self.but_t ) do
    --     v:setCurState( CLICK_STATE_UP )
    -- end
    -- self.but_t[ but_index ]:setCurState( CLICK_STATE_DOWN )

    --将其他标签全部更改文字贴图
    -- for k,v in pairs(self.btn_name_t) do
    --    v.change_to_no_selected()
    -- end
    -- self.btn_name_t[but_index].change_to_selected()
            
    self.raido_btn_group:selectItem( but_index - 1)

    if _current_page and _current_page.view then
        _current_page.view:setIsVisible(false)
    end

    if but_index == 1 then
        if self.all_page_t[1] == nil then
            self.all_page_t[1] = Strengthen( "strengthen", UILH_COMMON.normal_bg_v2, true, 870, 510 )
            self.all_page_t[1]:setPosition(15, 15)
            self.view:addChild( self.all_page_t[1].view )
        end
        _current_page = self.all_page_t[1]
    elseif  but_index == 2 then
        if self.all_page_t[2] == nil then
            self.all_page_t[2] = GemSet(  "GemSet", UILH_COMMON.normal_bg_v2, true, 870, 510 )
            self.all_page_t[2]:setPosition(15, 15)
            self.view:addChild( self.all_page_t[2].view )
        else
            -- ForgeModel:req_gem_meta()
        end
        _current_page = self.all_page_t[2]
        ForgeModel:set_update_type(nil)
        -- ForgeModel:req_get_gem_meta(  )
    elseif  but_index == 3 then
        if self.all_page_t[3] == nil then
            self.all_page_t[3] = Synth(  "Synth", UILH_COMMON.normal_bg_v2, true, 870, 510 )
            self.all_page_t[3]:setPosition(15, 15)
            self.view:addChild( self.all_page_t[3].view )
        end
        _current_page = self.all_page_t[3]
        _current_page:active(true)
    elseif  but_index == 4 then
        if self.all_page_t[4] == nil then
            self.all_page_t[4] = Transfer( "Transfer", UILH_COMMON.normal_bg_v2, true, 870, 510 )
            self.all_page_t[4]:setPosition(15, 15)
            self.view:addChild( self.all_page_t[4].view )
        end
        _current_page = self.all_page_t[4]
    elseif  but_index == 5 then
        if self.all_page_t[5] == nil then
            self.all_page_t[5] = Upgrade(  "upgrade", UILH_COMMON.normal_bg_v2, true, 870, 510 )
            self.all_page_t[5]:setPosition(15, 15)
            self.view:addChild( self.all_page_t[5].view )
        end
        _current_page = self.all_page_t[5]
    elseif but_index == 6 then
        if self.all_page_t[6] == nil then
            self.all_page_t[6] = TiPin(  "TiPin", UILH_COMMON.normal_bg_v2, true, 870, 510  )
            self.all_page_t[6]:setPosition(15, 15)
            self.view:addChild( self.all_page_t[6].view )
        end
        _current_page = self.all_page_t[6]
    elseif but_index == 7 then
        if self.all_page_t[7] == nil then
            self.all_page_t[7] = ShengJie(  "ShengJie", UILH_COMMON.normal_bg_v2, true, 870, 510  )
            self.all_page_t[7]:setPosition(15, 15)
            self.view:addChild( self.all_page_t[7].view )
        end
        _current_page = self.all_page_t[7]
    elseif but_index == 8 then
        if self.all_page_t[8] == nil then
            self.all_page_t[8] = ZhuangBeiXiLian( "ZhuangBeiXiLian", UILH_COMMON.normal_bg_v2, true, 870, 510 )
            self.all_page_t[8]:setPosition( 15, 15 )
            self.view:addChild( self.all_page_t[8].view )
        end
        _current_page = self.all_page_t[8]
    end
    _current_page.view:setIsVisible(true)

    if _current_page and _current_page.update then
        _current_page:update( "all" )
    end
end

--
function ForgeWin:__init( window_name, texture_name )
    self.all_page_t = {}              -- 存储所有已经创建的页面

    self.btn_name_t = {}  --标签不同文字贴图集合

     --背景框
    local bgPanel = self.view

    -- 点击任何地方，判断是否打开了说明，是就关闭
    -- local function f1(eventType,x,y)
    --     if eventType == TOUCH_BEGAN then
    --         if _current_page.remove_explain_panel then
    --             _current_page:remove_explain_panel()
    --             return true
    --         end
    --     end
    -- end
    -- bgPanel:registerScriptHandler(f1)    --注册

    -- self.but_t = {}               -- 存放所有按钮，设置按钮状态


    -- 顶部所有按钮
    local win_size = self.view:getSize();
    local but_beg_x = 25          --按钮起始x坐标
    local but_beg_y = win_size.height - 112        --按钮起始y坐标
    local but_int_x = 101          --按钮x坐标间隔 102
    local btn_w = 101  --96
    local btn_h = 48
    local btn_n = 8
    local btn_i = 1

    -- 第一页的按钮
    self.page_two_btns = {}
    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x, but_beg_y , but_int_x * btn_n, btn_h,nil)
    bgPanel:addChild(self.raido_btn_group)

    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.forge.tab_label[1], 
        "",
        -1, -1, btn_i)

    btn_i = btn_i + 1
    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.forge.tab_label[2], 
        "",
        -1, -1, btn_i)

    btn_i = btn_i + 1
    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.forge.tab_label[3], 
        "",
        -1, -1, btn_i)

    btn_i = btn_i + 1
    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.forge.tab_label[4], 
        "",
        -1, -1, btn_i)

    btn_i = btn_i + 1
    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.forge.tab_label[5], 
        "",
        -1, -1, btn_i)

    btn_i = btn_i + 1
    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.forge.tab_label[6], 
        "",
        -1, -1, btn_i)

    btn_i = btn_i + 1
    self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.forge.tab_label[7], 
        "",
        -1, -1, btn_i)

    btn_i = btn_i + 1
    self.page_two_btns[3] = self:create_a_button(self.raido_btn_group, 1 + but_int_x * (btn_i - 1), 1, btn_w, btn_h, 
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light,
        Lang.forge.tab_label[8], 
        "",
        -1, -1, btn_i)
    
    -- 页面底色,位置还没有调好，回头来调整！note by guozhinan
    -- local page_bg =  CCZXImage:imageWithFile( 35, 21, 856, 494+40, UIPIC_itemBack_01,500,500)
    -- bgPanel:addChild(page_bg)

    -- local function change_page( eventType,args,msgid )
    --     if ( eventType == TOUCH_CLICK ) then
    --         if ( _radio_group_page == 1 ) then
    --             _radio_group_page = 2;
    --             self.raido_btn_group:setIsVisible(false);
    --             self.radio_btn_group2:setIsVisible(true);
    --             self.radio_btn_group2:selectItem(0)
    --             self:change_page( 6 )
    --             self.spr1:setIsVisible(false)
    --             self.spr2:setIsVisible(true)
    --         elseif ( _radio_group_page == 2 ) then
    --             _radio_group_page = 1;
    --             self.raido_btn_group:setIsVisible(true);
    --             self.radio_btn_group2:setIsVisible(false);
    --             self:change_page( 1 )
    --             self.raido_btn_group:selectItem(0)
    --             self.spr1:setIsVisible(true)
    --             self.spr2:setIsVisible(false)
    --         end
    --     end
    --     return true;
    -- end
    -- -- 翻页的按钮,玩家等级大于40级才会显示
    -- self.more_btn = MUtils:create_btn( bgPanel,UIResourcePath.FileLocate.common .. "button3.png",UIResourcePath.FileLocate.common .. "button3.png",change_page,620,365,-1,-1)
    -- self.spr1 = MUtils:create_sprite(self.more_btn,UIResourcePath.FileLocate.forge .."more_btn1.png",44,14)
    -- self.spr2 = MUtils:create_sprite(self.more_btn,UIResourcePath.FileLocate.forge .."more_btn2.png",44,14)
    -- self.spr2:setIsVisible(false)
    -- self.more_btn:setIsVisible(false);

    -- -- 第二页的按钮
    -- self.radio_btn_group2 = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , but_int_x * 5,33,nil)
    -- bgPanel:addChild(self.radio_btn_group2)
    -- self.radio_btn_group2:setIsVisible(false);
    -- self.page_two_btns = {}
    -- -- 装备提品
    -- self.page_two_btns[1] = self:create_a_button(self.radio_btn_group2, 1 + but_int_x * (1 - 1), 1, 94, 37, UIResourcePath.FileLocate.common .. "common_tab_n.png",
    --  UIResourcePath.FileLocate.common .. "common_tab_s.png", UIResourcePath.FileLocate.forge .. "zhuangbeitipin.png",79, 22, 6)
    -- -- 装备升阶
    -- self.page_two_btns[2] = self:create_a_button(self.radio_btn_group2, 1 + but_int_x * (2 - 1), 1, 94, 37, UIResourcePath.FileLocate.common .. "common_tab_n.png",
    --  UIResourcePath.FileLocate.common .. "common_tab_s.png", UIResourcePath.FileLocate.forge .. "zhuangbeishengjie.png",79, 22, 7)
    -- -- 装备洗练
    -- self.page_two_btns[3] = self:create_a_button(self.radio_btn_group2, 1 + but_int_x * (3 - 1), 1, 94, 37, UIResourcePath.FileLocate.common .. "common_tab_n.png",
    --  UIResourcePath.FileLocate.common .. "common_tab_s.png", UIResourcePath.FileLocate.forge .. "zhuangbeixilian.png",79, 22, 8)
    -- -- 洗练继承
    -- self.page_two_btns[4] = self:create_a_button(self.radio_btn_group2, 1 + but_int_x * (4 - 1), 1, 94, 37, UIResourcePath.FileLocate.common .. "common_tab_n.png",
    --  UIResourcePath.FileLocate.common .. "common_tab_s.png", UIResourcePath.FileLocate.forge .. "xilianjicheng.png",79, 22, 9)

    -- self.page_two_btns[1]:setIsVisible(false);
    -- self.page_two_btns[2]:setIsVisible(false);
    self.page_two_btns[3]:setIsVisible(false);
    -- self.page_two_btns[4]:setIsVisible(false);

    -- 默认打开的是强化界面
    self:change_page( 1 )

end

function ForgeWin:create( texture_name )
	return ForgeWin( texture_name, 35, 46, 760, 429);
end

function ForgeWin:active( show )
    -- 每次打开前先删除特效
    if ( show ) then
        -- LuaEffectManager:stop_view_effect( 10014,self.view);
        local player = EntityManager:get_player_avatar();
        if ( player.level >= 50 ) then
            self.page_two_btns[3]:setIsVisible(true);
        else
            self.page_two_btns[3]:setIsVisible(false);
        end
        -- if ( player.level >= 40 ) then
        --     self.more_btn:setIsVisible(true);
        --     self.page_two_btns[1]:setIsVisible(true);
        --     self.page_two_btns[2]:setIsVisible(true);
        --     if(  player.level >=51 ) then
        --         self.page_two_btns[3]:setIsVisible(true);
        --         self.page_two_btns[4]:setIsVisible(true);
        --     else
        --         self.page_two_btns[3]:setIsVisible(false);
        --         self.page_two_btns[4]:setIsVisible(false); 
        --     end
        -- else
        --     self.more_btn:setIsVisible(false);
        --     self.page_two_btns[1]:setIsVisible(false);
        --     self.page_two_btns[2]:setIsVisible(false);
        -- end
        self:update("bag")
        self:update("all")
        self:update("equipment")

        if ( _current_page ) then
            _current_page:active( show );
        end
    else
        local help_win = UIManager:find_visible_window("help_panel")
        if help_win ~= nil then
            UIManager:hide_window("help_panel")
        end
    end

    -- -- 新手指引代码
    -- if ( XSZYManager:get_state() == XSZYConfig.LIAN_QI_ZY ) then
    --     if ( show ) then
    --         --363,310,62,62
    --         -- XSZYManager:unlock_screen(  )
    --         -- 指向第一个道具
    --         XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.LIAN_QI_ZY,1 ,XSZYConfig.OTHER_SELECT_TAG);
    --     else
    --         -- 继续做任务
    --         AIManager:do_quest(TaskModel:get_zhuxian_quest());
    --         XSZYManager:destroy( XSZYConfig.OTHER_SELECT_TAG );
    --         -- 隐藏菜单栏
    --         local win = UIManager:find_window("menus_panel");
    --         win:show_or_hide_panel(false);
    --     end
    -- end

    -- if ( show ) then
    --     LuaEffectManager:stop_view_effect( 11008,self.view)
    --     LuaEffectManager:play_view_effect( 11008,190,270,self.view,true,10  );
    -- end
end

function ForgeWin:destroy()
     -----------HJH
    -----------2013-3-18
    -----------补上DESTROY方法
    Window.destroy(self)
    for key, page in pairs(self.all_page_t) do
        page:destroy()
    end
end

--xiehande 播放炼器提升成功特效
function ForgeWin:play_success_effect()
    --170,128
    -- 播放炼器成功特效
    LuaEffectManager:play_view_effect( 10014,710,340,self.view,false,5 );
end


--强化失败并强化等级下降  播放特效
function ForgeWin:play_fail_effect()
    -- body
    -- LuaEffectManager:play_view_effect(35,710,340,self.view,false,5 );
end

--装备 升级/升阶/提品 成功特效
function ForgeWin:play_upsuccess_effect()
    -- body
    LuaEffectManager:play_view_effect(10014,650,420,self.view,false,5 );
end
 --装备合成  成功特效
function ForgeWin:play_synth_effect()
    -- body
    LuaEffectManager:play_view_effect(10014,655,430,self.view,false,5 );
end

function ForgeWin:update_zhan_bu_buff_info(index)
    if self.all_page_t[index] ~= nil then
        self.all_page_t[index]:update("all")
    end
end
-- 宝石镶嵌成功特效
function ForgeWin:play_gem_insert()
    -- LuaEffectManager:play_view_effect(400,655,450,self.view,false,5 );
end
--宝石摘除特效
function ForgeWin:play_gem_remove()
    -- LuaEffectManager:play_view_effect(404,655,450,self.view,false,5 );
end

--强化转移失败并强化等级下降  播放特效
-- function ForgeWin:play_fail_effect()
--     LuaEffectManager:play_view_effect(35,710,340,self.view,false,5 );
-- end

-- 强化转移 播放炼器提升成功特效
function ForgeWin:play_qhzy_success_effect()
    LuaEffectManager:play_view_effect( 10014,675,380,self.view,false,5 );
end