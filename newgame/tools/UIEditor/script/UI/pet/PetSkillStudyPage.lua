-- PetSkillStudyPage.lua
-- create by hcl on 2012-12-10
-- refactored by guozhinan on 2014-10-29
-- 技能学习

require "UI/pet/SuXingWin"

super_class.PetSkillStudyPage()

-- 背包里唤魂玉数量
local yhs_num = nil;
-- 背包里唤魂玉的表
local yhs_tab = {};
-- 当前选中的唤魂石头
local curr_select_hhy = -1;
-- 当前选中的技能索引 从1开始
local curr_select_skill_index = 1;

local node_skill_study = nil;

-- 背包中的技能书表
local tab_skill_book = {};
-- 左下角的技能书slot_item列表

local icon_scale_TJXS = 64/67


function PetSkillStudyPage:__init()
    --------------------------------------背景------------------------------------
    ------下面是保存了要更新信息的控件
    self.tab_skill_study_view = {};
    local tab_skill_study_view = self.tab_skill_study_view;
    node_skill_study = CCBasePanel:panelWithFile(250,8,630,508,nil,0,0);
    self.view = node_skill_study;

    -- 中部背景
    local mid_bg = CCZXImage:imageWithFile( 0, 7, 334, 497, UILH_COMMON.bottom_bg,500,500)
    self.view:addChild(mid_bg)

    -------------------------- 右上技能栏 ---------------------------------------------------------
    local start_x = 416
    local start_y = 422+50
    -- 宠物技能图标在update_skill_panel里面
    -- self.select_pet_skill = MUtils:create_sprite(parent,table.icon_path,416+7 ,422+50);
    -- self.select_pet_skill:setScale(64/48)

    local font_size = 15;

    -- 服务端发过来的技能信息
    -- local base_name = "";
    -- local skill_str ="";
    -- local range = "";
    -- local cooldown_t = "";
    -- local skill_type = ""; 

    -- 左下角的技能书仓库
    self:create_skill_book_store_view();

    self:create_middle_up_panel(0,225,335,280,nil)
    self:create_right_panel(334, 7, 298, 497, UILH_COMMON.bottom_bg)

    self:on_band();

    self:update(1,{PetWin:get_current_pet_info()});
    return node_skill_study;
end

function PetSkillStudyPage:create_right_panel(x, y, width, height,texture_path)
    self.right_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
    self.view:addChild(self.right_panel,-1)

    -- 装饰用的slotitem背景
    local item_bg = CCZXImage:imageWithFile(43,410,-1,-1,UILH_NORMAL.item_bg2)
    self.right_panel:addChild(item_bg)

    --学习按钮
    self.btn_study = ZTextButton:create(self.right_panel,Lang.pet.skillstudy_page[1],UILH_COMMON.button4,nil,141 ,417,-1,-1); -- [840]="学习"
    self.btn_study.view:setIsVisible(false);
    --遗忘按钮
    self.btn_forget = ZTextButton:create(self.right_panel,Lang.pet.skillstudy_page[2],UILH_COMMON.button4,nil,141 ,417,-1,-1); -- [1733]="遗忘"
    self.btn_forget.view:setIsVisible(false);
    -- 技能名字
    self.label_skill_name = ZLabel:create(self.right_panel,"", 143,468,16);
    self.label_skill_name.view:setAnchorPoint(CCPointMake(0,0))

    -- 分割线
    local line = CCZXImage:imageWithFile( 10, 406, width-18, 3, UILH_COMMON.split_line)
    self.right_panel:addChild(line)

    local top_y = 386
    self.label_skill_type = ZLabel:create(self.right_panel,"",16,top_y,18);
    self.label_keyin_state = ZLabel:create(self.right_panel,"",150,top_y,18);

    -- 学习条件(学习状态下)
    self.study_condition = ZLabel:create(self.right_panel,Lang.pet.skillstudy_page[3],16,top_y-26,15) -- "#cffff00学习条件："
    self.study_condition.view:setIsVisible(false)
    -- 已学习状态下：“#c66ff66消耗材料：#cFFFFFF通灵忘川水 × #cffff001”
    self.have_study = ZLabel:create(self.right_panel,Lang.pet.skillstudy_page[4],16,top_y-26,15)
    self.have_study.view:setIsVisible(false)

    self.label_skill_cd = ZLabel:create(self.right_panel,"" ,160,top_y-53,15);
    self.label_skill_range = ZLabel:create(self.right_panel,"",16,top_y-53,15);

    self.dialog_skill_info = ZDialog:create(self.right_panel, "", 16,top_y-53,270,70,15);
    self.dialog_skill_info.view:setAnchorPoint(0,1)
    self.dialog_skill_info.view:setLineEmptySpace(6)
    self.dialog_skill_info:setText("")

    -- 子标题背景
    local text_bg = CCZXImage:imageWithFile( 6, 197, width-12, 35, UILH_NORMAL.title_bg4, 500, 500)
    self.right_panel:addChild(text_bg)
    -- 子标题文字:技能秘籍
    ZLabel:create(self.right_panel,Lang.pet.skillstudy_page[24],width/2,208,15,2); -- [18]="伙伴技能"

    -- 唤魂玉的背景
    local tab_skill_study_view = self.tab_skill_study_view;
    yhs_tab = ItemModel:get_yhs_by_id(PetConfig:get_hhy_item_id());
    yhs_num = #yhs_tab;
    local hhy_item_id = PetConfig:get_hhy_item_id();
    local y = 167;
    local start_x = 43
    local str = "";
    local btn_start_x = start_x-32
    local btn_start_y = y-90
    for i=0,3 do
        local x = start_x + (i%2) * 143;
        y = 167 - math.floor(i/2)*65
        btn_start_y = 73 - math.floor(i/2)*65
        if (i < yhs_num ) then
            tab_skill_study_view[35 + i] = MUtils:create_slot_item2(self.right_panel,UILH_COMMON.slot_bg,x-31,y-31,60,60,PetConfig:get_hhy_item_id());
            str = LangGameString[834]; -- [834]="使用"
        else
            tab_skill_study_view[35 + i] = MUtils:create_slot_item2(self.right_panel,UILH_COMMON.slot_bg,x-31,y-31,60,60);
            str = Lang.pet.skillstudy_page[26]; -- [1016]="购买"
        end
        local function btn_fun(_self,arg)
            local num = #ItemModel:get_yhs_by_id(PetConfig:get_hhy_item_id());
            local index  = i + 1

            -- 使用
            if ( index <= num) then
                UIManager:hide_window("pet_win");
                UIManager:show_window("suxing_win");
                PetCC:req_get_huan_hun_yu_info(yhs_tab[index].series,3);
                curr_select_hhy = index ;
            else 
                -- 购买
                local function cb_fun()
                    -- 购买唤魂玉会优先放在左边
                    yhs_tab = ItemModel:get_yhs_by_id(PetConfig:get_hhy_item_id());
                    yhs_num = #yhs_tab;
                    tab_skill_study_view[35 + yhs_num - 1]:set_icon( PetConfig:get_hhy_item_id() );
                    tab_skill_study_view[35 + yhs_num - 1]:set_color_frame(PetConfig:get_hhy_item_id(),0,0,60,60);
                    local function f1(a, b, arg)
                        local click_pos = Utils:Split(arg, ":")
                        local world_pos = tab_skill_study_view[35 + yhs_num - 1].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
                        TipsModel:show_shop_tip( world_pos.x, world_pos.y, PetConfig:get_hhy_item_id());
                    end
                    tab_skill_study_view[35 + yhs_num - 1]:set_click_event( f1 );
                    tab_skill_study_view[39 + yhs_num - 1]:setText(LangGameString[834]); -- [834]="使用"
                end
                -- GlobalFunc:create_screen_notic( "只能购买一个." );
                BuyKeyboardWin:show(hhy_item_id,cb_fun);
            end
        end
    
        local btn = ZButton:create(self.right_panel,UILH_COMMON.button4,btn_fun,x + 30,btn_start_y+74);
        tab_skill_study_view[39 + i] = ZLabel:create(btn,str,77/2,13,18,2);
        -------------------------------------
        ----HJH 2014-11-5 add begin
        ----版署版本
        local soft_check_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_check_version")
        if soft_check_version == true then
            btn.view:setIsVisible(false)
        end
        ----HJH 2014-11-5 add end
        -------------------------------------
    end


    -- 分割线
    local line = CCZXImage:imageWithFile( 10, 64, width-18, 3, UILH_COMMON.split_line)
    self.right_panel:addChild(line)

    -- 说明按钮
    local function btn_explain_fun(eventType,x,y)
        HelpPanel:show(3,UILH_NORMAL.title_tips,Lang.pet.pet_skill_study);
    end
    self.shuoming = ZBasePanel:create(self.right_panel,"",20,15,115,40)
    self.shuoming:setTouchClickFun(btn_explain_fun)
    ZImage:create(self.shuoming, UILH_NORMAL.wenhao, 0, 0, -1, -1)
    ZImage:create(self.shuoming, UILH_NORMAL.shuoming, 40, 9, -1, -1)  

    -- 宠物技能图鉴
    self.pet_skill_table = ZButton:create(self.right_panel,{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},nil,171,9,-1,-1)
    MUtils:create_zxfont(self.pet_skill_table,Lang.pet.skillstudy_page[25],121/2,23,2,13);     -- [25] = 伙伴技能图鉴
end

function PetSkillStudyPage:create_middle_up_panel(x, y, width, height,texture_path)
    self.middle_up_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
    self.view:addChild(self.middle_up_panel)

    --宠物名字的标题
    local title_panel = CCBasePanel:panelWithFile( -9, 236, 356, 49, UILH_NORMAL.title_bg3, 0, 0 )
    self.middle_up_panel:addChild(title_panel)
    self.label_pet_name = MUtils:create_zxfont(title_panel,"",356/2,18,2,15);

    -- 子标题背景
    local text_bg = CCZXImage:imageWithFile( 6, height-71, width-12, 35, UILH_NORMAL.title_bg4, 500, 500)
    self.middle_up_panel:addChild(text_bg,-1)
    -- 子标题文字
    ZLabel:create(self.middle_up_panel,Lang.pet.skillstudy_page[18],width/2,height-60,15,2); -- [18]="伙伴技能"

    self.pet_skill_items = {}

    -- 子标题背景
    local text_bg = CCZXImage:imageWithFile( 6, -28, width-12, 35, UILH_NORMAL.title_bg4, 500, 500)
    self.middle_up_panel:addChild(text_bg)
    -- 子标题文字
    ZLabel:create(self.middle_up_panel,Lang.pet.skillstudy_page[19],width/2,-17,15,2); -- [19]="拥有技能书"
end

function PetSkillStudyPage:on_band()
    -- 学习
    local function btn_study_fun(eventType,x,y)
        local p_s = PetWin:get_current_pet_info();
        if (p_s) then
            local pet_id = p_s.tab_attr[1];
            local series = tab_skill_book[ curr_select_skill_index ].struct.series;
            PetCC:req_study_skill(pet_id,series);
        end
    end
    self.btn_study:setTouchClickFun(btn_study_fun)
    -- 遗忘
    local function btn_forget_fun(eventType,x,y)
        local p_s = PetWin:get_current_pet_info();
        if (p_s) then
            local pet_name = p_s.pet_name;
            -- 服务器发过来的技能数据
            local sever_skill_info = p_s.tab_pet_skill_info[curr_select_skill_index];
            -- 静态配置表的技能数据
            local skill_info = SkillConfig:get_skill_by_id( sever_skill_info.skill_id );
            -- 取得宠物技能名
            local base_name = PetConfig:get_pet_skill_name_by_skill_lv(sever_skill_info.skill_lv,skill_info.name)
            -- 取得遗忘之水的item_id
            local item_id = PetConfig:get_forget_water_item_id() ;

            local function fun(item_id)
                local p_s = PetWin:get_current_pet_info();
                local pet_id = p_s.tab_attr[1];
                local skill_id = p_s.tab_pet_skill_info[curr_select_skill_index].skill_id;
                PetCC:req_forget_Skill(pet_id,skill_id);
            end
            UseItemDialog:show(item_id,fun,1,Lang.pet.skillstudy_page[9]..pet_name..Lang.pet.skillstudy_page[2]..base_name..Lang.pet.skillstudy_page[10],UILH_PET.jinengyiwang); -- [1732]="你确定要让" -- [1733]="遗忘" -- [1724]="吗"
        end
    end
    self.btn_forget:setTouchClickFun(btn_forget_fun);
    --  -- 说明
    --  local function btn_explain_fun(eventType,x,y)
    --     HelpPanel:show(3,UIResourcePath.FileLocate.pet .. "pet_t_jnxxsm.png",Lang.pet.pet_skill_study);
    -- end
    -- self.shuoming:setTouchClickFun(btn_explain_fun);

    -- 宠物技能图鉴
    local function btn_pet_skill_table_fun(eventType,x,y)
        UIManager:hide_window("pet_win");
        UIManager:show_window("pet_skill_table_win");
    end 
    self.pet_skill_table:setTouchClickFun(btn_pet_skill_table_fun);  
end

---更新函数
function PetSkillStudyPage:update(type,tab_arg)
    -- 更新整个面板
	if ( type == 1 ) then
        self:update_all(tab_arg[1]);
    -- 更新技能面板
    elseif ( type == 2 ) then
    	self:update_skill_panel(tab_arg[1],tab_arg[2],tab_arg[3],tab_arg[4]);
    -- 学习技能后的更新
    elseif ( type == 3 ) then
    	self:cb_study_skill(tab_arg[1]);
    -- 忘记技能后的更新
    elseif ( type == 4 ) then
    	self:cb_forget_Skill();
    -- 苏醒技能后的更新
    elseif ( type == 5 ) then
    	self:cb_wake_skill(tab_arg[1],tab_arg[2]);
    end
end
---更新整个界面
function PetSkillStudyPage:update_all(p_s)

    if ( p_s == nil )then
        return;
    end

    local tab_skill_study_view = self.tab_skill_study_view;

    -- 先取消选中特效
    SlotEffectManager.stop_current_effect()

	local pet_attrs = p_s.tab_attr;
    -- 更新宠物名字
    self.label_pet_name:setText(p_s.pet_name);
     -- 宠物技能 要更新(中间上方的宠物技能)
    local start_y = 360;
    local start_x = 24
    local item_width = 80
    local item_height = 90
    local y = start_y;
    local _x = 80-64;       --slotitem icon和背景的差值
    local _y = 80-64;       --slotitem icon和背景的差值
    for i=0,7 do
        if(i==4) then
            y = y - item_height;
        end
        -- 如果控件已经存在
        if ( self.pet_skill_items[1+i] ) then
             -- 判断技能数量,小于技能数量就不用图片
            if ( i  < p_s.pet_skill_num ) then 
                local skill_id = p_s.tab_pet_skill_info[i+1].skill_id;
                local skill_lv = p_s.tab_pet_skill_info[i+1].skill_lv;
                self.pet_skill_items[1+i]:set_pet_skill_icon( skill_id,skill_lv);
                self.pet_skill_items[1+i]:set_icon_bg_texture(UILH_NORMAL.item_bg2)
            elseif i < p_s.tab_attr[34] then
                self.pet_skill_items[1+i]:set_pet_skill_icon( nil,nil );
                self.pet_skill_items[1+i]:set_icon_bg_texture(UILH_NORMAL.item_bg2)
            else
                self.pet_skill_items[1+i]:set_pet_skill_icon( nil,nil );
                self.pet_skill_items[1+i]:set_icon_bg_texture(UILH_NORMAL.lock)
            end
        else
            local bg_path = UILH_NORMAL.item_bg2;
            if ( i  < p_s.pet_skill_num ) then 
                local skill_id = p_s.tab_pet_skill_info[i+1].skill_id;
                local skill_lv = p_s.tab_pet_skill_info[i+1].skill_lv;
                self.pet_skill_items[1+i] = MUtils:create_pet_slot_skill2( node_skill_study,bg_path,start_x  + (i % 4) * item_width,y,64,64,skill_id,skill_lv );
            elseif i < p_s.tab_attr[34] then
                self.pet_skill_items[1+i] = MUtils:create_pet_slot_skill2( node_skill_study,bg_path,start_x  + (i % 4) * item_width,y,64,64,nil,nil,nil );
            else
                self.pet_skill_items[1+i] = MUtils:create_pet_slot_skill2( node_skill_study,bg_path,start_x  + (i % 4) * item_width,y,64,64,nil,nil,nil );
                self.pet_skill_items[1+i]:set_icon_bg_texture(UILH_NORMAL.lock)
            end
            local function btn_fun( _self,eventType, args, msgi)
                print("_self,eventType, args, msgi = ",_self,eventType, args, msgi)
                local index = MUtils:get_click_btn_index(args,start_x-_x,start_y+item_height-_y,item_width,item_height,4);
                print("index",index)
                local pet_struct = PetWin:get_current_pet_info();
                if ( index <=  #pet_struct.tab_pet_skill_info) then
                    self:update_skill_panel( pet_struct.tab_pet_skill_info[index] ,1,tab_skill_study_view,node_skill_study);
                    -- 当前选中的技能索引
                    curr_select_skill_index = index ;
                    self.pet_skill_items[1+i]:set_select_effect_state( true )
                else
                    self:update_skill_panel(nil,1,tab_skill_study_view,node_skill_study);
                    curr_select_skill_index = 0;
                    self.pet_skill_items[1+i]:set_select_effect_state( false )
                    SlotEffectManager.stop_current_effect()
                    if ( i >= p_s.tab_attr[34] ) then
                        GlobalFunc:create_screen_notic( Lang.pet.pet_info_page[17] ) -- [1691]="悟性达到12、24,成长到达13、26分别增加一个技能槽"
                    end
                end
                return true;
            end
            self.pet_skill_items[1+i]:set_click_event( btn_fun )
        end
    end

    self:update_skill_panel(nil,1,tab_skill_study_view,node_skill_study);

    -- 取得背包中的技能书
    tab_skill_book = PetModel:get_bag_skill_book();
    --print("item_num = " .. #tab_skill_book);
    self.scroll_skill_book_store:clear();
    self.scroll_skill_book_store:setMaxNum(#tab_skill_book);
    self.scroll_skill_book_store:refresh()
    -- 更新唤魂玉
    yhs_tab = ItemModel:get_yhs_by_id(PetConfig:get_hhy_item_id());
    yhs_num = #yhs_tab;
    print("yhs_num = ",yhs_num);
    for i=0,3 do
        local str = "";
        if (i < yhs_num ) then
            local function f1(a, b, arg)
                local click_pos = Utils:Split(arg, ":")
                local world_pos = tab_skill_study_view[35 + i].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
                TipsModel:show_shop_tip( world_pos.x, world_pos.y, PetConfig:get_hhy_item_id());
            end
            tab_skill_study_view[35 + i]:set_click_event( f1 );
            tab_skill_study_view[35 + i]:set_icon( PetConfig:get_hhy_item_id() );
            tab_skill_study_view[35 + i]:set_color_frame(PetConfig:get_hhy_item_id())
            str = LangGameString[834]; -- [834]="使用"
        else
            local function f1()
            end
            tab_skill_study_view[35 + i]:set_click_event( f1 );
            tab_skill_study_view[35 + i]:set_icon_texture( "" );
            str = LangGameString[1016]; -- [1016]="购买"
        end
        tab_skill_study_view[39 + i]:setText( str );
    end
end


-- 选中宠物技能时更新右边的技能面板 
-- type 1 点击当前宠物的技能  type 2 点击技能书
function PetSkillStudyPage:update_skill_panel(skill_struct,type,node_tab,parent)

    if (skill_struct == nil) then
        self.label_skill_name:setText("");
        self.btn_forget.view:setIsVisible(false);
        self.btn_study.view:setIsVisible(false);
        self.label_keyin_state:setText("")
        self.label_skill_type:setText("");
        self.label_skill_range:setText("");
        self.label_skill_cd:setText("");
        self.dialog_skill_info:setText("");
        if ( self.sprite_selected_skill ) then
            self.sprite_selected_skill:removeFromParentAndCleanup(true);
            self.sprite_selected_skill = nil;
            self.study_condition:setText("");
            self.have_study.view:setIsVisible(false)
        end
        return;
    end

    local table = PetConfig:get_pet_skill_strs(skill_struct);

    -- -- 静态表的技能信息
    local skill_info2 = SkillConfig:get_skill_by_id( skill_struct.skill_id );
    self.label_skill_name:setText(table.skill_name);
    print("type = ",type);
    if (type == 1) then
        self.btn_forget.view:setIsVisible(true);
        self.btn_study.view:setIsVisible(false);
    elseif (type == 2) then
        self.btn_forget.view:setIsVisible(false);
        self.btn_study.view:setIsVisible(true);
    end

    if (skill_struct.skill_keyin == 1) then 
        self.label_keyin_state:setText(Lang.pet.skillstudy_page[22])-- 已刻印
    else
        self.label_keyin_state:setText(Lang.pet.skillstudy_page[23])-- 未刻印
    end
    --local skill_type,range = PetConfig:get_skill_type_and_range(skill_struct.skill_id);
    self.label_skill_type:setText("#cffff00" .. table.skill_type);
    -- 技能释放范围
    self.label_skill_range:setText(Lang.pet.skillstudy_page[20]..table.skill_range);
    --local cooldown_t =  skill_info2.skillSubLevel[skill_struct.skill_lv].cooldownTime/1000 ;
    -- CD时间
    self.label_skill_cd:setText(Lang.pet.skillstudy_page[21]..table.skill_cd..Lang.pet.keyin_page[14]); -- [875]="秒"
    -- [2451]="#cffff00施法效果：#cffffff"
    local skill_str = Lang.pet.skillstudy_page[11] .. skill_info2.skillSubLevel[skill_struct.skill_lv].desc;
    self.dialog_skill_info:setText(skill_str);

    if type == 1 then
        self.study_condition.view:setIsVisible(false)
        self.have_study.view:setIsVisible(true)
    else
        local skill_lv, skill_id, skill_name = self:getLastLevelPetSkillLevelIDName()
        if skill_name then
            -- 技能名颜色
            if skill_lv == 0 then
                skill_name = ""
            elseif skill_lv == 1 then
                skill_name = Lang.pet.skillstudy_page[12] .. skill_name     -- [12]="#c458908初级"
            elseif skill_lv == 2 then
                skill_name = Lang.pet.skillstudy_page[13] .. skill_name                   -- [13]="#c0096ff中级"
            elseif skill_lv == 3 then
                skill_name = Lang.pet.skillstudy_page[14] .. skill_name     -- [14]="#ce519cb高级"
            end
            local str = Lang.pet.skillstudy_page[3] .. skill_name   -- 学习条件
            if skill_lv == 0 then
                str = str .. "#cffffff" .. Lang.pet.skillstudy_page[17]   -- （无）
            else
                local isHaveStudy = self:isSkillHaveStudy(skill_lv,skill_id)
                if isHaveStudy then
                    str = str .. "#cffffff" .. Lang.pet.skillstudy_page[15] -- (已达成)
                else
                    str = str .. "#cffffff" .. Lang.pet.skillstudy_page[16] -- (未达成)
                end
            end
            self.study_condition:setText(str)
            self.study_condition.view:setIsVisible(true)
        end
        self.have_study.view:setIsVisible(false)
    end
    
    -- 技能图标
    --local path =  SkillConfig:get_skill_icon_path(skill_struct.skill_id ,skill_struct.skill_lv);
    if ( self.sprite_selected_skill ) then
        self.sprite_selected_skill:removeFromParentAndCleanup(true);
        self.sprite_selected_skill = nil;
    end
    self.sprite_selected_skill = MUtils:create_sprite(parent,table.icon_path,417,458);
    self.sprite_selected_skill:setScale(icon_scale_TJXS)
end


-- 14 学习技能回调
function PetSkillStudyPage:cb_study_skill(skill_index)
    self:change_layout3( skill_index );
    curr_select_skill_index = -1; 
    self:update_skill_panel(nil,2,self.tab_skill_study_view,nil);
end

-- 技能书仓库的技能移动到宠物身上
function PetSkillStudyPage:change_layout3( skill_index )
    -- 如果技能书的数量大于一
    local skill_book_count = tab_skill_book[ curr_select_skill_index ].struct.count;
    -- 取得对应的item数据
    local item = ItemModel:get_item_by_series(tab_skill_book[curr_select_skill_index].struct.series);
    -- 如果item存在
    if (item) then
        print("tab_skill_book[index]存在" )
        print(tab_skill_book[curr_select_skill_index].struct.item_id .. "技能书数量 = " .. skill_book_count);
    end

    if ( item ) then
        -- 如果item存在，就更新Item的数量
        if ( self.lb_scroll_view_item[curr_select_skill_index] ) then
            self.lb_scroll_view_item[curr_select_skill_index]:set_item_count(tostring(skill_book_count));
        else
            print("tab_skill_study_view[26 + curr_select_skill_index ]不存在");
        end
    else
        -- 如果item不存在了就要删除这个item的图标和数据，然后后面的图标要往前移动
        -- 删除消耗掉的技能书
        table.remove(tab_skill_book,curr_select_skill_index);
        local store_len = #tab_skill_book ;
        -- 设置滚动条的最大数量
        self.scroll_skill_book_store:clear();
        self.scroll_skill_book_store:setMaxNum(store_len);
        self.scroll_skill_book_store:refresh();
    end
   
    -- 当前选中的的宠物数据结构
    local p_s = PetWin:get_current_pet_info();
    local pet_skill_tab = p_s.tab_pet_skill_info;
    self.pet_skill_items[skill_index]:set_pet_skill_icon( pet_skill_tab[skill_index].skill_id,pet_skill_tab[skill_index].skill_lv);
end

-- 15 遗忘技能回调
function PetSkillStudyPage:cb_forget_Skill()
	-- 更新数据
    local struct = PetWin:get_current_pet_info();
    -- 删除当前宠物要遗忘的技能
    struct:deleteSkill(curr_select_skill_index);
	self:change_layout4();
    curr_select_skill_index = - 1;
    self:update_skill_panel(nil,2,self.tab_skill_study_view,nil);
    -- 清除选中特效
    SlotEffectManager.stop_current_effect()
end

-- 删除宠物当前的技能
function PetSkillStudyPage:change_layout4()

    -- 出战的宠物数据结构
    local p_s = PetWin:get_current_pet_info();
    -- 更新宠物技能栏
    for i=curr_select_skill_index ,8 do   
        if ( i <= p_s.pet_skill_num) then
            local skill_id = p_s.tab_pet_skill_info[i].skill_id;
            local skill_lv = p_s.tab_pet_skill_info[i].skill_lv;
            self.pet_skill_items[i]:set_pet_skill_icon( skill_id ,skill_lv);
        elseif ( i == p_s.pet_skill_num + 1) then
            print("置空第",i,"个")
            self.pet_skill_items[i]:set_pet_skill_icon(nil,nil);
        end
    end

end

-- 23 苏醒技能 回调 type 1:技能书数量加一 2:增加新的技能书
function PetSkillStudyPage:cb_wake_skill(item_struct,type)
  	-- print("cb_wake_skill");

   --  if ( type == 1) then
   --      for i=1,#self.lb_scroll_view_item do
   --          if ( item_struct.series == tab_skill_book[i].struct.series) then
   --              print("更新技能书的数量 PetWin:i = " .. i);
   --              -- 更新数据
   --              self.lb_scroll_view_item[i]:set_item_count(tostring(tab_skill_book[i].struct.count));
   --              break
   --          end
   --      end
   --  else
   --      -- 背包中增加新的技能书
   --      local sub_tab = {};
        
   --      sub_tab.struct = item_struct;
   --      require "config/ItemConfig"
   --      sub_tab.skill_id = ItemConfig:get_skill_id_by_item_id(item_struct.item_id);
   --      sub_tab.skill_lv = PetConfig:get_lv_by_item_id( item_struct.item_id );
   --      tab_skill_book[#tab_skill_book + 1] = sub_tab;
   --      local len = #tab_skill_book;
   --      print("len = ",len);
   --      -- 设置滚动条的最大数量
   --      self.scroll_skill_book_store.view:setMaxNum(len);
   --      self.scroll_skill_book_store.view:clear();
   --      self.scroll_skill_book_store.view:refresh();   
   --  end


   --  -- 更新唤魂玉
    yhs_tab = ItemModel:get_yhs_by_id(PetConfig:get_hhy_item_id());
    yhs_num = #yhs_tab;
    print("yhs_num = ",yhs_num);
    for i=0,3 do
        local str = "";
        if (i < yhs_num ) then
            local function f1(a, b, arg)
                local click_pos = Utils:Split(arg, ":")
                local world_pos = tab_skill_study_view[35 + i].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
                TipsModel:show_shop_tip( world_pos.x, world_pos.y, PetConfig:get_hhy_item_id());
            end
            tab_skill_study_view[35 + i]:set_click_event( f1 );
            tab_skill_study_view[35 + i]:set_icon( PetConfig:get_hhy_item_id() );
            tab_skill_study_view[35 + i]:set_color_frame(PetConfig:get_hhy_item_id())
            str = Lang.pet.skillstudy_page[27]; -- 使用
        else
            local function f1()
            end
            tab_skill_study_view[35 + i]:set_click_event( f1 );
            tab_skill_study_view[35 + i]:set_icon_texture( "" );
            str = Lang.pet.skillstudy_page[26]; -- "购买";
        end
        tab_skill_study_view[39 + i]:setText( str );
    end
end

function PetSkillStudyPage:check_scroll()
    self.scroll_skill_book_store:refresh()
end

function PetSkillStudyPage:set_scroll_max_num(num)
    if self.scroll_skill_book_store ~= nil then
        self.scroll_skill_book_store:setMaxNum(num)
    end
end
function PetSkillStudyPage:create_skill_book_store_view()
    self.lb_scroll_view_item = {};
    print("当有拥有技能书数量 = ",#tab_skill_book);
    local item_width = 80
    local item_height = 90

    -------modify by HJH
    -------2013-3-21
    local _scroll_info = { x = 11, y = 20, width = 4 * item_width, height = item_height * 2, vertical = 4, horizontal = 2, runtype = TYPE_VERTICAL_EX, gapsize = 0 }
    local _scroll_max_num = #tab_skill_book / _scroll_info.vertical / _scroll_info.horizontal
    if _scroll_max_num < 1 and #tab_skill_book > 0 then
        _scroll_max_num = 1
    end
    self.scroll_skill_book_store = Scroll:create( nil, _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height,
     math.ceil(_scroll_max_num), _scroll_info.runtype, _scroll_info.gapsize )
    --(float posx, float posy, float width, float height, unsigned short numvertical, unsigned short numhorizontal, unsigned long maxnum, const char *file, SCROLL_TYPE type,
    --self.scroll_skill_book_store = CCScroll:scrollWithFile(70-31,44-31,4*63,63*2,2,4,#tab_skill_book,nil,TYPE_HORIZONTAL,500,500);
    node_skill_study:addChild(self.scroll_skill_book_store.view)
    function PetSkillStudyPage:scrollfun(index)
        local pet_win = UIManager:find_window("pet_win")
        local tap_page = pet_win:get_tab_pages()
        local selfItem = tap_page[4]
        -------------------
        if selfItem == nil then
            return
        end
        --
        local max_num = #tab_skill_book / _scroll_info.vertical / _scroll_info.horizontal
        if max_num < 1 and #tab_skill_book > 0 then
            max_num = 1
        end
        selfItem:set_scroll_max_num(math.ceil(max_num))
        if index >  #tab_skill_book / _scroll_info.vertical / _scroll_info.horizontal then
            return
        end
        -------------------
        local temp_list = List:create( nil, 0, 0, _scroll_info. width, _scroll_info.height, _scroll_info.vertical, _scroll_info.horizontal)
        temp_list.view:setAddType(TYPE_HORIZONTAL);
        for i = 1 , _scroll_info.vertical * _scroll_info.horizontal do
            local cur_index = index * _scroll_info.vertical * _scroll_info.horizontal + i
            if cur_index > #tab_skill_book then
                break 
            end
            -------------------
            local panel = CCBasePanel:panelWithFile( 0 , 0 , _scroll_info.width / _scroll_info.vertical , _scroll_info.height / _scroll_info.horizontal , "" )
            local function panelfun ()
                local skill_id = tab_skill_book[ cur_index ].skill_id;
                local skill_lv = tab_skill_book[ cur_index ].skill_lv;
                   -- 当前选中的技能索引
                curr_select_skill_index = cur_index ;
                require "struct/PetStoreSkillStruct"
                selfItem:update_skill_panel( PetStoreSkillStruct(nil,-1,skill_id,skill_lv,0) ,2,selfItem.tab_skill_study_view ,node_skill_study);
                    
            end
            local item_id = tab_skill_book[ cur_index ].struct.item_id;
            selfItem.lb_scroll_view_item[cur_index] = MUtils:create_slot_item2(panel,UILH_NORMAL.item_bg2,5, 5, 
             64, 64, item_id, panelfun,8)
            selfItem.lb_scroll_view_item[cur_index]:set_color_frame(item_id, -2, -2, 68, 68);
            -- 设置数量
            selfItem.lb_scroll_view_item[cur_index]:set_item_count(tostring(tab_skill_book[cur_index].struct.count))
            selfItem.lb_scroll_view_item[cur_index]:set_select_effect_state( true )
            temp_list:additemEx(panel)
        end
        return temp_list
    end
    self.scroll_skill_book_store:setScrollCreatFunction(PetSkillStudyPage.scrollfun)
    -- local function scrollfun(eventType, args, msg_id)
    --     if eventType == nil or args == nil or msg_id == nil then 
    --         return
    --     end
    --     if eventType == TOUCH_BEGAN then
    --         return true
    --     elseif eventType == TOUCH_MOVED then
    --         return true
    --     elseif eventType == TOUCH_ENDED then
    --         return true
    --     elseif eventType == SCROLL_CREATE_ITEM then

    --         local temparg = Utils:Split(args,":")
    --         -- 
    --         local column = temparg[1] ;          -- 列
    --         local row = temparg[2];             -- 行
    --         --print("column = ",column,"row=",row);
    --         local index = column * 2 + row + 1;
    --         if ( index > #tab_skill_book ) then
    --             return;
    --         end

    --         -- 每行的背景panel
    --         local panel = CCBasePanel:panelWithFile( column * 63 , math.floor((row+1)/2)*63 ,62,62,nil,0,0);
    --         self.scroll_skill_book_store:addItem(panel);
    --         local function fun ()
    --             local skill_id = tab_skill_book[ index ].skill_id;
    --             local skill_lv = tab_skill_book[ index ].skill_lv;
    --                -- 当前选中的技能索引
    --             curr_select_skill_index = index ;
    --             require "struct/PetStoreSkillStruct"
    --             self:update_skill_panel( PetStoreSkillStruct(nil,-1,skill_id,skill_lv,0) ,2,tab_skill_study_view ,node_skill_study);
                    
    --         end
    --         local item_id = tab_skill_book[ index ].struct.item_id;
    --         -- 
    --         self.lb_scroll_view_item[index] = MUtils:create_slot_item(panel,"ui/common/item_bg01.png",0,
    --             0,62,62,item_id,fun)
    --         -- 设置数量
    --         self.lb_scroll_view_item[index]:set_item_count(tostring(tab_skill_book[index].struct.count));

    --         self.scroll_skill_book_store:refresh();
    --         return false
    --     end
    -- end
    --self.scroll_skill_book_store:registerScriptHandler(scrollfun);
    self.scroll_skill_book_store:refresh()
end

function PetSkillStudyPage:update_skill_book_stroe( series ,add_or_delete)
    tab_skill_book = PetModel:get_bag_skill_book();

    if ( add_or_delete ) then
        
    else
        for i=1,#tab_skill_book do
            if ( tab_skill_book[i].struct.series == series ) then
                table.remove(tab_skill_book,i);
                break;
            end
        end
    end
 
    local len = #tab_skill_book;
    print("技能书数量 = ",len);
    -- 设置滚动条的最大数量
    self.scroll_skill_book_store.view:setMaxNum(len);
    self.scroll_skill_book_store.view:clear();
    self.scroll_skill_book_store.view:refresh();   
end

-- 获取当前技能的上一级技能等级、名称
function PetSkillStudyPage:getLastLevelPetSkillLevelIDName()
    if tab_skill_book[curr_select_skill_index] then
        -- 获得当前选中的技能书的id
        local item_id = tab_skill_book[curr_select_skill_index].struct.item_id
        -- 获得当前选中的技能书对应的宠物技能的等级
        local skill_lv= PetConfig:get_lv_by_item_id(item_id)
        if not skill_lv then
            return
        end
        -- 如果当前技能书对应的宠物技能等级为1,则无需再获得它的上一级技能
        if skill_lv == 1 then
            local skill_id   = ItemConfig:get_skill_id_by_item_id(item_id)
            local skill_info = SkillConfig:get_skill_by_id(skill_id)
            if skill_info then
                return skill_lv - 1, skill_id, skill_info.name
            end
        else
            -- 获取上一级的技能书
            last_lv_item_id  = item_id - 1
            local skill_id   = ItemConfig:get_skill_id_by_item_id(last_lv_item_id)
            local skill_info = SkillConfig:get_skill_by_id(skill_id)
            if skill_info then
                return skill_lv - 1, skill_id, skill_info.name
            end
        end
    end
end

-- 某一宠物技能是否已学习
function PetSkillStudyPage:isSkillHaveStudy( skill_lv, skill_id )
    local petWin = UIManager:find_visible_window("pet_win")
    if petWin then
        petInfo = petWin:get_current_pet_info();
        -- 查找是否已学习skill_id的技能
        for i = curr_select_skill_index, petInfo.pet_skill_num do
            local id = petInfo.tab_pet_skill_info[i].skill_id
            local lv = petInfo.tab_pet_skill_info[i].skill_lv
            if id == skill_id and lv == skill_lv then
                return true
            end
        end
    end
end

-- 请求刷新后的界面更新
function PetSkillStudyPage:update_refresh_result(item_id)
    -- if item_id and item_id ~= 0 then
    --     self.refresh_skill_item:set_icon(item_id)
    -- else
    --     self.refresh_skill_item:set_icon_texture("")
    -- end
end

function PetSkillStudyPage:request_refresh_record()
    PetCC:req_get_huan_hun_yu_info(0, 3)
end