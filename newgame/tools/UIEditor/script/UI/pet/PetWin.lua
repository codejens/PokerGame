-- PetWin.lua
-- create by hcl on 2012-12-10
-- refactored by guozhinan on 2014-10-21
-- 宠物窗口

super_class.PetWin(NormalStyleWindow)

-- 宠物信息,悟性提升，成长提升，技能学习，技能刻印，宠物融合的table
local tab_pages = {nil,nil,nil,nil,nil,nil};

-- 当前选中tab的index
local curr_node_index = -1;
-- 当前选中的宠物的index
local curr_pet_index = 1;
-- 总面板
local basePanel = nil;

local font_size = 17

-- 要更新的view
local update_view = {};

function PetWin:show()
    UIManager:toggle_window("pet_win");
end

function PetWin:get_tab_pages()
    return tab_pages
end
------点击左边栏的宠物会更新右边栏的信息----
-- 
function PetWin:__init( window_name, texture_name)
    self.cur_select_pet = 1

    -- 请求宠物技能仓库列表
    PetCC:req_store_skill_list();

    -- 空面板
    basePanel = self.view;
    -- 九宫格背景
    ZImage:create(self.view,UILH_COMMON.normal_bg_v2,5,5,890,520,0,500,500);

    -- 创建导航栏，上面有6个按钮 1,宠物信息，2悟性提升，3成长提升，4技能学习，5技能刻印，6宠物融合 
    self:create_radio_button_group();
    -- 创建左边的宠物栏
    self:create_left_pets_panel();

    local function _close_btn_fun()
        Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
        UIManager:destroy_window("pet_win")
    end
    self:setExitBtnFun(_close_btn_fun)
end

function PetWin:create_radio_button_group()
    --横版标题
    local _radio_item_info = {
    width = 101,
    height = 48,
    image = {
        {nil,nil},
        {nil,nil},
        {nil,nil},
        {nil,nil},
        {nil,nil},
        {nil,nil},
        },
    image_bg = {
        UILH_COMMON.tab_gray,
        UILH_COMMON.tab_light
        },
    }

    self._radio_item_info = _radio_item_info
    self.raido_btn_group = ZRadioButtonGroup:create(basePanel,20 ,520, _radio_item_info.width*6,_radio_item_info.height,0);
    -- 宠物栏上面的6个按钮 1,宠物信息，2悟性提升，3成长提升，4技能学习，5技能刻印，6宠物融合
    self.text_title = {Lang.pet.common[3],Lang.pet.common[4],Lang.pet.common[5],Lang.pet.common[6],Lang.pet.common[7],Lang.pet.common[8],}
    self.label_title = {}
    for i=1,6 do
        local function btn_fun(eventType,args,msg_id)
            -- Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
            self:do_tab_button_method(i);
        end
        local item_btn = ZImageButton:create( nil, _radio_item_info.image_bg, _radio_item_info.image[i][1], btn_fun, 1+_radio_item_info.width*(i-1), 1, _radio_item_info.width, _radio_item_info.height, nil)
        self.label_title[i] = MUtils:create_zxfont(item_btn.view,LH_COLOR[2]..self.text_title[i],101/2,14,2,17);
        self.raido_btn_group:addItem(item_btn);
 
    end 
end

-- 战 字的图片，当出战宠物变化时，需要变化战字图片的坐标
local spr_fight = nil;
local LEFT_PET_PANEL_START_Y = 510;
local LEFT_PET_PANEL_START_X = 19;
local LEFT_PET_PANEL_ITEM_HEIGHT = 99;    -- 更改间隔除了要改这个，还要改addItem中间隔
local LEFT_PET_PANEL_ITEM_WIDTH = 230;

function PetWin:create_left_pets_panel()

    if(basePanel == nil) then
        return;
    end
    -- 战的背景和战字,update会重置位置，所以这里不用管位置
    spr_fight = CCZXImage:imageWithFile(0,0,-1,-1,UILH_MAIN.vip_bg)
    basePanel:addChild(spr_fight,10)
    local fight_text = CCZXImage:imageWithFile(15,20,-1,-1,UILH_PET.zhan)
    spr_fight:addChild(fight_text)
    spr_fight:setIsVisible(false);
    
    -- 创建九宫格背景2
    -- ZImage:create(self.view,UILH_COMMON.bg_07,LEFT_PET_PANEL_START_X,LEFT_PET_PANEL_START_Y-5*LEFT_PET_PANEL_ITEM_HEIGHT,LEFT_PET_PANEL_ITEM_WIDTH,LEFT_PET_PANEL_ITEM_HEIGHT*5+2,0,500,500);
    
    local pet_info = PetModel:get_pet_info();
    local max_num = pet_info.max_num;
    local curr_num= pet_info.curr_num;
    local tab = pet_info.tab;

    self.pet_radio_group = ZRadioButtonGroup:create(basePanel,LEFT_PET_PANEL_START_X ,LEFT_PET_PANEL_START_Y-5*LEFT_PET_PANEL_ITEM_HEIGHT, LEFT_PET_PANEL_ITEM_WIDTH,LEFT_PET_PANEL_ITEM_HEIGHT*5+2,1);
    for i=1,5 do
        self:create_left_panel_item(i,tab[i],curr_num,max_num);
    end
    self:do_tab_button_method(1);

    -- 选中框
    self.selected_item_img = CCZXImage:imageWithFile(LEFT_PET_PANEL_START_X,LEFT_PET_PANEL_START_Y-LEFT_PET_PANEL_ITEM_HEIGHT+3,LEFT_PET_PANEL_ITEM_WIDTH,100, UILH_COMMON.select_focus2,500,500);
    self.view:addChild(self.selected_item_img)
end

function PetWin:create_left_panel_item( i,pet_struct,curr_num,max_num )
    -- print("i,pet_struct,curr_num,max_num",i,pet_struct,curr_num,max_num)
    local x = 0;
    local y = LEFT_PET_PANEL_START_Y - i * LEFT_PET_PANEL_ITEM_HEIGHT;

    local function pet_item_function(eventType,x,y)
        if eventType == TOUCH_BEGAN then 
            local pet_info = PetModel:get_pet_info();
            local max_num = pet_info.max_num;
            local curr_num= pet_info.curr_num;
            -- 如果宠物索引小于宠物的数量
            if i <= curr_num then
                if ( curr_node_index == 6 ) then
                    -- 更新宠物融合界面
                    tab_pages[6]:set_curr_draging_index ( i ) ;
                end
            end
            return true
        elseif eventType == TOUCH_CLICK then
            return true;
        elseif eventType == TOUCH_ENDED then
            self:change_pet_index(i)
            return true;
        end        
    end

    local btn = {}
    btn.view = CCRadioButton:radioButtonWithFile(x, y, LEFT_PET_PANEL_ITEM_WIDTH, 96, UILH_COMMON.bg_11, TYPE_MUL_TEX, 500, 500)
    btn.view:registerScriptHandler(pet_item_function)
    update_view[i] = btn;
    self.pet_radio_group:addItem(btn,3);
    self:create_pet_view( i,btn,pet_struct )
end

function PetWin:change_pet_index(i)
    local pet_info = PetModel:get_pet_info();
    local max_num = pet_info.max_num;
    local curr_num= pet_info.curr_num;
    -- 如果宠物索引小于宠物的数量
    if i <= curr_num then
        self:set_select_pet_pos( i )
        PetModel:set_cur_pet_index( i )
        self:update(1 , {i,curr_node_index,1})
    end
end

function PetWin:create_pet_view( index ,btn,pet_struct)
    local pet_info = PetModel:get_pet_info();
    local max_num = pet_info.max_num;
    local curr_num= pet_info.curr_num;

    if index <= curr_num then
        btn.lab_fight_value = ZLabel:create(btn.view,Lang.pet.common[1]..pet_struct.tab_attr[33] ,98,29,15,1);   -- [1] = "#c66ff66战斗力:"
        btn.lab_name = ZLabel:create(btn.view,pet_struct.pet_name ,98,59,15,1);
        -- 头像
        btn.slot_head = self:create_selotMove_item(btn.view, 16, 19,64,64,pet_struct);
        if ( PetModel:get_current_pet_id() == pet_struct.tab_attr[1]) then
            self:change_fight_img_pos( index )
            if ( PetModel:get_current_pet_is_fight() ) then 
                spr_fight:setIsVisible(true);
            else
                spr_fight:setIsVisible(false);
            end
        end
    elseif index<= max_num then

    else
        local function open_pet_slot()
            -- local money_type = MallModel:get_only_use_yb() and 3 or 2
            -- local price = 10
            -- local param = {money_type}
            -- local open_func = function( param )
            --     PetCC:req_add_pet_max_num(param[1])
            -- end
            local function cb_fun()
                -- MallModel:handle_auto_buy( price, open_func, param )
                PetCC:req_add_pet_max_num();
            end
            -- 开启宠物栏
            NormalDialog:show(Lang.pet.common[9],cb_fun); -- [1740]="是否花费10元宝扩展一个宠物栏?"
        end
        local x = 0;
        local y = LEFT_PET_PANEL_START_Y - index * LEFT_PET_PANEL_ITEM_HEIGHT;
        update_view[15 + index] = ZButton:create(basePanel,"",open_pet_slot,LEFT_PET_PANEL_START_X+x,6+y,194,65,3);

        MUtils:create_zxfont(update_view[15 + index].view,Lang.pet.common[2],80,40,1,20);     -- [2]="未开启"
    end    
end 

function PetWin:get_click_btn_index( args )
    return MUtils:get_click_btn_index(args,0,LEFT_PET_PANEL_ITEM_HEIGHT*5,LEFT_PET_PANEL_ITEM_WIDTH,LEFT_PET_PANEL_ITEM_HEIGHT,1);
end

function PetWin:set_select_pet_pos( index )
    self.selected_item_img:setPosition(LEFT_PET_PANEL_START_X, LEFT_PET_PANEL_START_Y-index*LEFT_PET_PANEL_ITEM_HEIGHT+3)
    -- spr_selected_pet_img.view:setPosition(105,LEFT_PET_PANEL_START_Y + 33.5  - index * LEFT_PET_PANEL_ITEM_HEIGHT);
    self.pet_radio_group:selectItem(index-1);
end

function PetWin:goto_page( index )
    self:do_tab_button_method(index)
end

-- 外部通用调用
function PetWin:change_page( index )
    self:do_tab_button_method(index)
end

--xiehande  点击按钮切换字体贴图
function PetWin:change_btn_name( index )
    -- body
    -- for i,v in ipairs(self.raido_btn_group.item_group) do
    --     if(i==index) then
    --       self.raido_btn_group:getIndexItem(i-1):set_image_texture(self._radio_item_info.image[i][2])
    --     else
    --       self.raido_btn_group:getIndexItem(i-1):set_image_texture(self._radio_item_info.image[i][1])
    --     end
    -- end
    for i,v in ipairs(self.label_title) do
        if(i == index) then
          	self.label_title[i]:setText("#cffffff"..self.text_title[i])
        else
          	self.label_title[i]:setText("#cd0cda2"..self.text_title[i])
        end
    end
end

-- tab上button的回调
function PetWin:do_tab_button_method( index )
    Instruction:handleUIComponentClick(instruct_comps.PET_WIN_TAB_BASE + index)
    Instruction:destroy_drag_out_animation()
    PetModel:set_cur_page_index(index)
    -- 如果点击的面板当前正在显示，直接返回
    if(curr_node_index == index) then
        return;
    end

    if ( curr_node_index ~= -1 ) then
        -- 当前显示的面板隐藏
        tab_pages[curr_node_index].view:setIsVisible(false);
    end

    self:change_btn_name(index)

    if ( not tab_pages[index] ) then
        if(1 == index) then
            tab_pages[index] = PetInfoPage();
        elseif(2 == index) then
            tab_pages[index] = PetWuXingPage();
        elseif(3 == index) then
            tab_pages[index] = PetChengZhangPage();
        elseif(4 == index) then
            tab_pages[index] = PetSkillStudyPage();
            tab_pages[index]:check_scroll()
        elseif(5 == index) then
            tab_pages[index] = PetSkillKeYinPage();
        elseif(6 == index) then
            tab_pages[index] = PetRongHePage();
        end
        basePanel:addChild(tab_pages[index].view);
    else
        tab_pages[index].view:setIsVisible(true);
        -- 子面板更新
        self:update(1 , {curr_pet_index,index,2})
        --self:update_panel(curr_pet_index,index,2);
    end

    -- 如果是宠物技能学习页面,则请求刷新数据
    if index == 4 then
        tab_pages[4]:request_refresh_record()
    end

    -- 更新选中的面板索引
    curr_node_index = index;
    self.raido_btn_group:selectItem(curr_node_index-1)
    if ( curr_node_index == 6 ) then
         -- 设置宠物可以拖拽
        for i=1,5 do
            if update_view[i].slot_head then
                update_view[i].slot_head:set_enable_drag_out(true);
            end
        end
        -- -- 新手指引代码
        -- if ( XSZYManager:get_state() == XSZYConfig.CWRH_ZY ) then
        --     XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
        --     XSZYManager:create_drag_out_animation( 44,325,1);
        -- end
    else
        -- if ( XSZYManager:get_state() == XSZYConfig.CWRH_ZY ) then
        --     XSZYManager:destroy_drag_out_animation();
        -- end
        -- 设置宠物可以拖拽
        for i=1,5 do
            if update_view[i].slot_head then
                update_view[i].slot_head:set_enable_drag_out(false);
            end
        end
    end
end

function PetWin:update( type ,tab_arg)
    -- 点击上面的按钮更新子面板
    if ( type == 1 ) then
        self:update_sub_panel(tab_arg[1],tab_arg[2],tab_arg[3])
    elseif ( type == 2 ) then
        self:cb_fight(tab_arg[1],tab_arg[2],tab_arg[3]);
    elseif ( type == 3 ) then
        self:cb_delete_pet(tab_arg[1],tab_arg[2]);
    elseif ( type == 4 ) then
        self:cb_change_name(tab_arg[1],tab_arg[2]);
    elseif ( type == 5 ) then
        
    elseif ( type == 6 ) then
        self:cb_add_pet_max_num(tab_arg[1]);
    elseif ( type == 7 ) then
    elseif ( type == 8 ) then
    elseif ( type == 9 ) then
    elseif ( type == 10 ) then
    elseif ( type == 11 ) then
    elseif ( type == 12 ) then
    elseif ( type == 13 ) then
        self:cb_merge();
    elseif ( type == 14 ) then
        self:cb_study_skill(tab_arg[1],tab_arg[2],tab_arg[3]);
    elseif ( type == 15 ) then
        self:cb_forget_Skill();
    elseif ( type == 16 ) then
    elseif ( type == 17 ) then
        self:cb_skill_keyin(tab_arg[1],tab_arg[2]);
    elseif ( type == 18 ) then
        self:cb_skill_move_store(tab_arg[1],tab_arg[2]);
    elseif ( type == 19 ) then
        self:cb_remove_skill_form_store();
    elseif ( type == 20 ) then
    elseif ( type == 21 ) then
    elseif ( type == 22 ) then
    elseif ( type == 23 ) then
        self:cb_wake_skill(tab_arg[1],tab_arg[2]);
    elseif ( type == 30 ) then
        self:update_left_pet_panel(tab_arg[1]);
    -- 更新悟性丹数量
    elseif ( type == 31 ) then
        if tab_pages[2] then
            tab_pages[2]:update_item_count(tab_arg[1])
        end
    -- 更新成长丹数量
    elseif ( type == 32 ) then
        if tab_pages[3] then
            tab_pages[3]:update_item_count(tab_arg[1])   
        end
    end
end

-- 选中宠物时更新右边的面板,select_pet_index:要更新的宠物索引, panel_index:要更新的面板索引，
--type 1:是点击左边宠物更新右边界面,type 2:点击其他按钮更新右边界面
function PetWin:update_sub_panel(select_pet_index,panel_index,type)
    --print("update_sub_panel....................")
    if (type == 1) then
        if(curr_pet_index == select_pet_index) then
            print("PetWin:同一个宠物，不用更新");
            return;
        end
    end
    curr_pet_index = select_pet_index;
    -- 当前选中宠物的信息
    local p_s = PetModel:get_pet_info().tab[curr_pet_index];
    --local pet_attrs = p_s.tab_attr;
    tab_pages[panel_index]:update(1, { p_s } );
end
---------------------------------
-------- 宠物协议回调 -----------
---------------------------------

-- 2 宠物出战或回收回调
function PetWin:cb_fight(result,pet_do_type,pet_id)
     print("PetWin:cb_fight")
     -- 0 代表成功，1代表失败
    if(result == 0) then
        -- do_taype 1 代表出战，0代表回收
        -- 当pet_do_type =1时，代表pet_id的宠物出战了
        if(pet_do_type == 1) then
            PetModel:set_current_pet_id(pet_id);
            PetModel:set_current_pet_is_fight(true);
            -- 调整战字的坐标
            spr_fight:setIsVisible(true);
            self:change_fight_img_pos(  );
        else
            PetModel:set_current_pet_is_fight(false);
            -- 其实是不用设置current_pet_id的，但为了保险起见
            PetModel:set_current_pet_id(pet_id);
            -- 调整战字的坐标
            spr_fight:setIsVisible(false);
        end
        tab_pages[1]:update(3,{pet_do_type});
    end
  
end

-- 更新出战宠物的位置
function PetWin:change_fight_img_pos( pet_index )
    if ( pet_index ) then
        spr_fight:setPosition(LEFT_PET_PANEL_ITEM_WIDTH-31, LEFT_PET_PANEL_START_Y - pet_index * LEFT_PET_PANEL_ITEM_HEIGHT + 53);
    else
        local curr_fight_pet_id = PetModel:get_current_pet_id();
        local pet_tab = PetModel:get_pet_info().tab;
        for i=1,#pet_tab do
            if ( curr_fight_pet_id == pet_tab[i].tab_attr[1] ) then
                spr_fight:setPosition(LEFT_PET_PANEL_ITEM_WIDTH-31, LEFT_PET_PANEL_START_Y - i * LEFT_PET_PANEL_ITEM_HEIGHT + 53);
                return ;
            end
        end 
    end 
end

-- 3 删除宠物回调
function PetWin:cb_delete_pet( pet_id ,pet_index)

    PetWin:left_pet_panel_remove_pet(pet_index);

    -- 如果删除的宠物是当前出战的宠物
    if ( pet_id == PetModel:get_current_pet_id() ) then
        -- 设置当前出战的宠物id为 0
        PetModel:set_current_pet_id(0 )
        -- 隐藏战字
        spr_fight:setIsVisible(false);
    end

    -- -- 移动选中光标到第一只宠物
    curr_pet_index = 1;
    PetModel:set_cur_pet_index(1)
    self:set_select_pet_pos( curr_pet_index )

    if ( curr_node_index == 1) then
        -- 宠物信息界面显示第一只宠物
        -- 子面板更新
        self:update(1 , {curr_pet_index,1,2})
    elseif (curr_node_index == 6) then
        self:do_tab_button_method(6);
    end
    self:change_fight_img_pos(  )
end

-- 4 修改名字回调
function PetWin:cb_change_name(pet_id,pet_new_name)
    -- 更新
    local index = PetModel:get_index_by_pet_id(pet_id);
    local pet_struct = PetModel:get_pet_info_by_pet_id ( pet_id )
    pet_struct:update_pet_name( pet_new_name );
    update_view[index].lab_name:setText( pet_struct.pet_name );
    -- 子面板更新
    tab_pages[1]:update(4,{pet_id, pet_struct.pet_name});
end

-- 5 修改宠物的战斗类型回调 1 attr_id,2 attr_value,3attr_value2
function PetWin:cb_change_pet_attr( attr_id,attr_value,attr_value2 )
    -- 延寿
    if ( attr_id == 4) then
        tab_pages[1]:update(2,{attr_id,attr_value});
    -- 玩耍
    elseif ( attr_id == 5 ) then
        if ( curr_node_index == 1 ) then 
            tab_pages[1]:update(2,{attr_id,attr_value});
        end
    -- 喂食
    elseif ( attr_id == 3 ) then
        -- 如果当前打开的是宠物信息界面
        if ( curr_node_index == 1 ) then 
            tab_pages[1]:update(2,{attr_id,attr_value,attr_value2});
        end
    -- 提悟 10
    elseif ( attr_id == 11 ) then
        -- 提悟没带保护符会倒退
        if ( attr_value > attr_value2 ) then
            -- 播放提升成功的特效
            LuaEffectManager:play_view_effect( 10014,730,340,self.view,false,5 );
        end
        if ( curr_node_index == 2 ) then
            self:update(1,{curr_pet_index, 2 , 2});
        end
        self:update_pet_fight( curr_pet_index );
    -- 提成长 11
    elseif ( attr_id == 12 ) then
        -- 提成长没带保护符会倒退
        if ( attr_value > attr_value2 ) then
            -- 播放提升成功的特效
            LuaEffectManager:play_view_effect( 10014,730,340,self.view,false,5 );
        end
        if ( curr_node_index == 3 ) then
            self:update(1,{ curr_pet_index, 3 , 2});
        end
        self:update_pet_fight( curr_pet_index );
    -- 攻击类型 13
    elseif ( attr_id == 14 ) then
        tab_pages[1]:update(2,{ attr_id,attr_value });
    -- 经验
    elseif ( attr_id ==  9 ) then
        tab_pages[1]:update(2,{ attr_id,attr_value ,attr_value2});
    -- 战斗力
    elseif ( attr_id == 33 ) then
        self:update_name_and_fight_value( attr_value )
    end
end

-- 6 扩展宠物栏回调
function PetWin:cb_add_pet_max_num(_max_num)
    PetModel:get_pet_info().max_num =_max_num;
    update_view[15 + _max_num].view:removeFromParentAndCleanup(true);
end

-- 7 增加一个宠物回调
function PetWin:cb_add_new_pet()

end

-- 8 延寿，玩耍，喂食操作回调
function PetWin:cb_add_live_play_feed()

end

-- 9 使用宠物存储血量回调
function PetWin:cb_use_pet_hp_bottle()

end

-- 10 提悟回调
function PetWin:cb_req_tiwu()

end

-- 11 提成长回调
function PetWin:cb_req_add_grow_up()
end

-- 12 转换攻击类型(法术或物理) 回调
function PetWin:cb_attack_type()

end

-- 13 融合 回调
function PetWin:cb_merge()
    tab_pages[6]:update(3);
    -- 宠物信息界面显示第一只宠物
    curr_pet_index = 1;
    PetModel:set_cur_pet_index(1)
    --xiehande 更新完后 添加宠物融合特效
      tab_pages[6]:play_ronghe_success_effect();
end

-- 14 学习技能回调
function PetWin:cb_study_skill(pet_id,skill_id,skill_level)
    -- 更新数据
    -- 添加技能到宠物技能栏
    local pet_struct = self:get_current_pet_info();
    -- 添加新技能到宠物 0代表技能没刻印
    local skill_index = pet_struct:addSkill(skill_id,skill_level,0);
    -- 宠物技能学习更新界面
    tab_pages[4]:update(3,{skill_index});

end

-- 15 遗忘技能回调
function PetWin:cb_forget_Skill()

    -- 宠物技能学习更新界面
    tab_pages[4]:update(4);
end

-- 16 宠物死亡 回调
function PetWin:cb_pet_dead()
    
end

-- 17 技能刻印 回调
function PetWin:cb_skill_keyin(pet_id,skill_id)
    -- 更新数据
    -- local curr_pet_struct = self:get_current_pet_info();
    -- curr_pet_struct.tab_pet_skill_info[curr_select_skill_index].skill_keyin = 1;
end

-- 18 技能移到仓库结果  回调
function PetWin:cb_skill_move_store(pet_id,store_id)

    -- 宠物刻印更新界面
    tab_pages[5]:update(2,{store_id});

end

-- 19 技能从仓库移出 回调
function PetWin:cb_remove_skill_form_store()

    -- 宠物刻印更新界面
    tab_pages[5]:update(3);
end

-- 20 请求仓库技能列表  回调
function PetWin:cb_store_skill_list()

end

-- 21 刷新唤魂玉或获取唤魂玉的数据 回调
function PetWin:cb_get_huan_hun_yu_info()

end

-- 23 苏醒技能 回调 type 1:技能书数量加一 2:增加新的技能书
function PetWin:cb_wake_skill(item_struct,type)
    -- 宠物刻印更新界面
    tab_pages[4]:update(5,{item_struct,type});
end

-- 24 出战的宠物选择一个实体作为目标，用于技能攻击 回调
function PetWin:cb_pet_target()
  
end

-- 25 使用技能 回调
function PetWin:cb_use_skill()

end

-- 27 宠物强行回收，并有5秒的cd 回调
function PetWin:cb_recover_pet()
 
end

-- 28 获取其他玩家的宠物信息 回调
function PetWin:cb_get_other_pet_info()
  
end

-- 29 发送当前宠物id 回调
function PetWin:cb_send_current_pet_id()

end
-- 取得当前选中的宠物索引
function PetWin:get_current_pet_index()
    return curr_pet_index;
end
-- 取得当前选中的宠物的信息
function PetWin:get_current_pet_info()
    return PetModel:get_pet_info().tab[curr_pet_index];
end
-- 宠物栏删除宠物
function PetWin:left_pet_panel_remove_pet(remove_index)
    print("remove_index = " .. remove_index);
    --删除控件和引用
    local pet_num = #PetModel:get_pet_info().tab;

    print("pet_num = " .. pet_num);
    if ( remove_index <= pet_num+1) then
        -- 重新设置数据
        for i = remove_index , pet_num+1  do
            local pet_struct = PetModel:get_pet_info().tab[i];
            self:update_pet_view(i,pet_struct)
        end
    end
end

function PetWin:update_pet_view( index,pet_struct )
    print("PetWin:update_pet_view( index,pet_struct )",index,pet_struct)
    if pet_struct then
        local btn = update_view[index];
        btn.lab_fight_value:setText(Lang.pet.common[1]..pet_struct.tab_attr[33]) -- [1] = "#c66ff66战斗力:"
        btn.lab_name:setText(pet_struct.pet_name);
        -- 头像
        btn.slot_head:set_icon_texture("icon/pet/" .. string.format("%05d",pet_struct.tab_attr[2]) .. ".pd");
        btn.slot_head:set_drag_info( 3 ,"pet_win",pet_struct);
    else
        local btn = update_view[index];
        btn.lab_fight_value.view:removeFromParentAndCleanup(true);
        btn.lab_fight_value = nil;
        btn.lab_name.view:removeFromParentAndCleanup(true);
        btn.lab_name = nil;
        -- 头像
        btn.slot_head.view:removeFromParentAndCleanup(true);
        btn.slot_head = nil;
    end
end

-- 宠物栏增加一只宠物
function PetWin:left_pet_panel_add_pet(index,pet_struct)
    self:create_pet_view( index ,update_view[index],pet_struct)
end

-- 更新宠物战斗力
function PetWin:update_pet_fight( index )
    local pet_info = PetModel:get_pet_info();
   -- print("战斗力 = " .. pet_info.tab[index].tab_attr[33]);
    update_view[ index ].lab_fight_value:setText(Lang.pet.common[1]..pet_info.tab[index].tab_attr[33]);  -- [1] = "#c66ff66战斗力:"
end

-- 更新宠物名字和战斗力
function PetWin:update_name_and_fight_value( pet_id )
    local index = PetModel:get_index_by_pet_id( pet_id )
    local pet_info = PetModel:get_pet_info();
    update_view[ index ].lab_fight_value:setText(Lang.pet.common[1]..pet_info.tab[index].tab_attr[33]);  -- [1] = "#c66ff66战斗力:"
    update_view[ index ].lab_name:setText(pet_info.tab[index].pet_name);
end

-- 宠物提升悟性或成长失败
function PetWin:wx_or_cz_fail( _type )
    if _type == 0 then
        if ( curr_node_index == 2 ) then
            tab_pages[curr_node_index]:update( 2 );
        end
    elseif _type == 1 then
        if ( curr_node_index == 3 ) then
            tab_pages[curr_node_index]:update( 2 );
        end
    end
end

function PetWin:create_selotMove_item(parent, x, y, width, height, item_model )
    local testItem = SlotPet(width,height);
    testItem:setPosition (x,y);
    testItem:set_icon_size(width,height);
    if testItem.icon_bg == nil then
        testItem.icon_bg = CCZXImage:imageWithFile(-12, -15, 90, 90, UILH_NORMAL.item_bg, 0,0)
        testItem.view:addChild(testItem.icon_bg, 0)
    end

    if item_model ~= nil then
        print("item_model.tab_attr[2]",item_model.tab_attr[2])
        testItem:set_icon_texture("icon/pet/" .. string.format("%05d",item_model.tab_attr[2]) .. ".pd");
        -- 
        testItem:set_drag_info( 3 ,"pet_win",item_model);
    end
    parent:addChild(testItem.view);

    local function drag_invalid_callback(drag_object )
        print("拖入非法区域！")
    end 
    testItem:set_drag_invalid_callback(drag_invalid_callback);
    return testItem;
end


-- 被添加或移除到显示节点上面的事件
function PetWin:active( show )
    
    -- PetModel记录pet_win的打开状态
    PetModel:update_pet_win_state( show );

    if ( show ) then

        -- 打开前先删除一次性的特效
        LuaEffectManager:stop_view_effect( 10014,self.view );
        -- print("PetWin:active( show )",curr_pet_index,curr_node_index)
        -- 更新当前打开的页面
        -- curr_pet_index = PetModel:get_cur_pet_index( )
        self:update_sub_panel(curr_pet_index,curr_node_index,2);
        -- 更新宠物栏出战状态
        if ( PetModel:get_current_pet_is_fight() ) then
            spr_fight:setIsVisible(true);
        else
            spr_fight:setIsVisible(false);
        end

        -- 刷新宠物信息和宠物融合界面
        if ( tab_pages[1] ) then
            tab_pages[1]:on_active();
        end
        if ( tab_pages[6] ) then
            tab_pages[6]:on_active();
        end

        self:set_select_pet_pos(curr_pet_index)

        -- 每次打开的时候删除选中效果
        SlotEffectManager.stop_current_effect();
    end
    
    if ( show == false ) then
        local help_win = UIManager:find_visible_window("help_panel")
        if help_win ~= nil then
            UIManager:hide_window("help_panel")
        end
        -- 如果当前新手指引的状态是2
        if ( XSZYManager:get_state() == XSZYConfig.CHONG_WU_ZY or XSZYManager:get_state() == XSZYConfig.CWRH_ZY ) then 
            -- 如果滑动动画没取消的话，取消滑动动画
            XSZYManager:destroy_drag_out_animation()
            -- 自动执行下一个任务
            local quest_id = XSZYManager:get_data();
            AIManager:do_quest( quest_id,1 );
            XSZYManager:destroy( XSZYConfig.OTHER_SELECT_TAG );
            -- 隐藏菜单栏
            local win = UIManager:find_window("menus_panel");
            win:show_or_hide_panel(false);
        end
        Instruction:continue_next()
    else
        if ( XSZYManager:get_state() == XSZYConfig.CHONG_WU_ZY ) then
            -- XSZYManager:play_jt_and_kuang_animation( 222,208,"",3,62,63 , XSZYConfig.OTHER_SELECT_TAG);
            XSZYManager:play_jt_and_kuang_animation_by_id(XSZYConfig.CHONG_WU_ZY,1, XSZYConfig.OTHER_SELECT_TAG);
        -- 宠物融合指引
        elseif ( XSZYManager:get_state() == XSZYConfig.CWRH_ZY ) then
            -- 98 - l_m ,402 - b_m , 94*6,37
            -- 指向宠物融合指引
            XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.CWRH_ZY,2 , XSZYConfig.OTHER_SELECT_TAG);
        end
    end

end

function PetWin:update_pet_skill_book( series ,add_or_delete)
    if ( tab_pages[4] ) then
        tab_pages[4]:update_skill_book_stroe( series,add_or_delete )
    end
end

function PetWin:destroy()
    tab_pages = {nil,nil,nil,nil,nil,nil};

    -- 当前选中tab的index
    curr_node_index = -1;
    -- 当前选中的宠物的index
    curr_pet_index = 1;
    -- 总面板
    basePanel = nil;

    -- 要更新的view
    update_view = {};
    tab_slot_pet = {};
    Instruction:destroy_drag_out_animation()
    Instruction:continue_next()
    Window.destroy(self)
end

function PetWin:update_zhan_bu_buff_info(index)
    -- print("PetWin:update_zhan_bu_buff_info ",index, tab_pages[index])
    -- if index == 2 and tab_pages[index] ~= nil then
    --      tab_pages[index] = PetWuXingPage();
    --      self:update(1 , {curr_pet_index,index,2})
    -- elseif 3 == index and tab_pages[index] ~= nil then
    --     tab_pages[index] = PetChengZhangPage();
    --     self:update(1 , {curr_pet_index,index,2})
    -- end
end

-- 宠物技能点击刷新后的回调
function PetWin:cb_refresh_skill(item_id)
    tab_pages[4]:update_refresh_result(item_id)
end