-- PetSkillKeYinPage.lua
-- create by hcl on 2012-12-10
-- 技能刻印

super_class.PetSkillKeYinPage()

-- 当前选中的技能索引 从1开始
local curr_select_skill_index = 1;

local node_skill_keyin = nil;

local icon_scale_TJXS = 64/67

function PetSkillKeYinPage:__init()

    ------下面是保存了要更新信息的控件
    self.tab_skill_keyin_view = {};
    local tab_skill_keyin_view = self.tab_skill_keyin_view;

    node_skill_keyin = CCBasePanel:panelWithFile(250,8,630,508,nil,0,0);
    self.view = node_skill_keyin;
 
    -- 中部背景
    local mid_bg = CCZXImage:imageWithFile( 0, 7, 334, 497, UILH_COMMON.bottom_bg,500,500)
    self.view:addChild(mid_bg)

    -- 服务端发过来的技能信息
    -- local base_name = "";
    -- local skill_str ="";
    -- local skill_type="";
    -- local range = "";
    -- local cooldown_t = ""; 

    ----------------------兽魂仓库-------------------------
    local pet_skill_store = PetModel:get_pet_skill_store();
    local start_y = 117;
    local start_x = 24
    local item_width = 80
    local item_height = 90
    local y = start_y;
    local _x = 80-64;       --slotitem icon和背景的差值
    local _y = 80-64;       --slotitem icon和背景的差值
    for i=1,8 do
        if(i==5) then
            y = y - item_height;
        end
        local x = start_x + ( (i-1) % 4) *item_width;
        if ( i<= #pet_skill_store ) then
            tab_skill_keyin_view[18 + i] = MUtils:create_pet_slot_skill2(node_skill_keyin, UILH_NORMAL.item_bg2 ,x,y,64,64,pet_skill_store[i].skill_id , pet_skill_store[i].skill_lv);
        else
            tab_skill_keyin_view[18 + i] = MUtils:create_pet_slot_skill2(node_skill_keyin, UILH_NORMAL.item_bg2 ,x,y,64,64,nil,nil);
        end

        local function btn_fun(_self,eventType, args, msgi)
            print("_self,eventType, args, msgi = ",_self,eventType, args, msgi)
            local index = MUtils:get_click_btn_index(args,start_x-_x,start_y+item_height-_y,item_width,item_height,4);
            local pet_skill_store = PetModel:get_pet_skill_store();
            local skill_book = pet_skill_store[index];
            print("index = ",index,"#pet_skill_store",#pet_skill_store);
            if ( skill_book ) then 
                self:update_skill_panel( skill_book ,2,tab_skill_keyin_view ,node_skill_keyin);
                 -- 当前选中的技能索引
                curr_select_skill_index = index ;
                tab_skill_keyin_view[18 + i]:set_select_effect_state( true );
            else
                tab_skill_keyin_view[18 + i]:set_select_effect_state( false );

            end
        end
        tab_skill_keyin_view[18 + i]:set_click_event(btn_fun);
    end

    self:create_middle_up_panel(0,225,335,280,nil)
    self:create_right_panel(334, 7, 298, 497, UILH_COMMON.bottom_bg)

    self:on_band();
    self:update(1,{PetWin:get_current_pet_info()});
    return node_skill_keyin;
end

function PetSkillKeYinPage:create_right_panel(x, y, width, height,texture_path)
    self.right_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
    self.view:addChild(self.right_panel,-1)

    -- 装饰用的slotitem背景
    local item_bg = CCZXImage:imageWithFile(43,410,-1,-1,UILH_NORMAL.item_bg2)
    self.right_panel:addChild(item_bg)

    local tab_skill_keyin_view = self.tab_skill_keyin_view;
    -- 封印按钮
    tab_skill_keyin_view[11] = ZTextButton:create(self.right_panel,Lang.pet.keyin_page[7],UILH_COMMON.button4,btn_feng_fun,141 ,417,-1,-1); -- [1725]="封印"
    tab_skill_keyin_view[11].view:setIsVisible(false);
    -- 解封按钮
    tab_skill_keyin_view[10] = ZTextButton:create(self.right_panel,Lang.pet.keyin_page[1],UILH_COMMON.button4,btn_jie_fun,141 ,417,-1,-1); -- [1718]="解封"
    tab_skill_keyin_view[10].view:setIsVisible(false);

    tab_skill_keyin_view[9] = ZLabel:create(self.right_panel,"",143,468,16);
    tab_skill_keyin_view[9].view:setAnchorPoint(CCPointMake(0,0))

    -- 分割线
    local line = CCZXImage:imageWithFile( 10, 406, width-18, 3, UILH_COMMON.split_line)
    self.right_panel:addChild(line)

    local top_y = 386
    tab_skill_keyin_view[13] = ZLabel:create(self.right_panel,"",16,top_y,18);
    self.label_keyin_state = ZLabel:create(self.right_panel,"",150,top_y,18);

    self.label_skill_cd = ZLabel:create(self.right_panel,"" ,160,top_y-26,15);
    self.label_skill_range = ZLabel:create(self.right_panel,"",16,top_y-26,15);

    tab_skill_keyin_view[16] = ZDialog:create(self.right_panel,"",16,top_y-26,270,70,15);
    tab_skill_keyin_view[16]:setAnchorPoint( 0, 1)
    tab_skill_keyin_view[16].view:setLineEmptySpace(6)
    tab_skill_keyin_view[16]:setText("")

    -- 分割线
    local line = CCZXImage:imageWithFile( 10, 64, width-18, 3, UILH_COMMON.split_line)
    self.right_panel:addChild(line)

    -- 说明按钮
    local function btn_explain_fun(eventType,x,y)
        HelpPanel:show(3,UILH_NORMAL.title_tips,Lang.pet.pet_keyin);
    end
    self.shuoming = ZBasePanel:create(self.right_panel,"",20,15,115,40)
    self.shuoming:setTouchClickFun(btn_explain_fun)
    ZImage:create(self.shuoming, UILH_NORMAL.wenhao, 0, 0, -1, -1)
    ZImage:create(self.shuoming, UILH_NORMAL.shuoming, 40, 9, -1, -1) 

    -- 宠物技能图鉴
    self.pet_skill_table = ZButton:create(self.right_panel,{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},nil,171,9,-1,-1); -- [1729]="宠物技能图鉴"
    MUtils:create_zxfont(self.pet_skill_table,Lang.pet.keyin_page[11],121/2,23,2,13);     -- [25] = 伙伴技能图鉴
end

function PetSkillKeYinPage:create_middle_up_panel(x, y, width, height,texture_path)
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

    -- self.pet_skill_items = {}

    -- 子标题背景
    local text_bg = CCZXImage:imageWithFile( 6, -28, width-12, 35, UILH_NORMAL.title_bg4, 500, 500)
    self.middle_up_panel:addChild(text_bg)
    -- 子标题文字
    ZLabel:create(self.middle_up_panel,Lang.pet.keyin_page[15],width/2,-17,15,2); -- [15]="刻印仓库"
end

function PetSkillKeYinPage:on_band()
    -- 解封
    local function btn_jie_fun(eventType,x,y)
        local p_s = PetWin:get_current_pet_info();
        if ( p_s ) then
            local pet_id = p_s.tab_attr[1];
            local skill_index = PetModel:get_pet_skill_store()[curr_select_skill_index].skill_index;
            PetCC:req_remove_skill_form_store(skill_index,pet_id);
        end
    end
    self.tab_skill_keyin_view[10]:setTouchClickFun(btn_jie_fun);

    -- 封印函数
    local function btn_feng_fun(eventType,x,y)
        local function fun (item_id)
            local pet_id = PetWin:get_current_pet_info().tab_attr[1];
            local skill_id = PetWin:get_current_pet_info().tab_pet_skill_info[curr_select_skill_index].skill_id;
            PetCC:req_skill_keyin( pet_id , skill_id );
        end
        local p_s = PetWin:get_current_pet_info();
        if ( p_s ) then
            local pet_name = p_s.pet_name;
            local skill_info1 = p_s.tab_pet_skill_info[curr_select_skill_index];
            local skill_info = SkillConfig:get_skill_by_id( skill_info1.skill_id );
            local base_name = "";
            if ( skill_info1.skill_lv == 1) then
                base_name = Lang.pet.keyin_page[2] .. skill_info.name; -- [1719]="初级"
            elseif ( skill_info1.skill_lv == 2 ) then
                base_name = Lang.pet.keyin_page[3] .. skill_info.name; -- [1720]="中级"
            elseif ( skill_info1.skill_lv == 3 ) then 
                base_name = Lang.pet.keyin_page[4] .. skill_info.name; -- [1721]="高级"
            elseif ( skill_info1.skill_lv == 4 ) then  
                base_name = Lang.pet.keyin_page[5] .. skill_info.name; -- [1722]="顶级"
            end
            local item_id = PetConfig:get_shy_item_id(skill_info1.skill_lv) ;

            -- 技能未刻印
            if ( skill_info1.skill_keyin == 0 ) then
                UseItemDialog:show(item_id,fun,3,Lang.pet.keyin_page[6]..pet_name..Lang.pet.keyin_page[13]..base_name..Lang.pet.keyin_page[16],UILH_PET.jinengfengyin); -- [1723]="你确认封印" -- [437]="的" -- [16]="技能吗"
            else
                fun();
            end
        end
    end    
    self.tab_skill_keyin_view[11]:setTouchClickFun(btn_feng_fun);

    -- 宠物技能图鉴
    local function btn_pet_skill_table_fun(eventType,x,y)
        UIManager:hide_window("pet_win");
        UIManager:show_window("pet_skill_table_win");
    end
    self.pet_skill_table:setTouchClickFun(btn_pet_skill_table_fun);
end

function PetSkillKeYinPage:update(type,tab_arg)

	if ( type == 1 ) then
        self:update_all(tab_arg[1]);
    elseif ( type == 2 ) then
        self:cb_skill_move_store(tab_arg[1]);
    elseif ( type == 3 ) then
    	self:cb_remove_skill_form_store();
    elseif ( type == 4 ) then
    elseif ( type == 5 ) then
    elseif ( type == 6 ) then
    elseif ( type == 7 ) then
    end

end

-- 选中宠物技能时更新右边的技能面板 
-- type 1 点击当前宠物的技能  type 2 点击技能书
function PetSkillKeYinPage:update_skill_panel(skill_struct,type,node_tab,parent)

    if (skill_struct == nil) then
        self.label_keyin_state:setText("")
        self.label_skill_cd:setText("")
        self.label_skill_range:setText("")
        node_tab[9]:setText("");
        node_tab[11].view:setIsVisible(false);
        node_tab[10].view:setIsVisible(false);
        node_tab[13]:setText("");
        node_tab[16]:setText("");
        if ( node_tab[18] ) then
        node_tab[18]:removeFromParentAndCleanup(true);
        node_tab[18] = nil;
        end
        return;
    end
    local table = PetConfig:get_pet_skill_strs(skill_struct);
    -- 静态表的技能信息
    local skill_info2 = SkillConfig:get_skill_by_id( skill_struct.skill_id );

    node_tab[9]:setText(table.skill_name);
    if (type == 1) then
        node_tab[11].view:setIsVisible(true);
        node_tab[10].view:setIsVisible(false);
    elseif (type == 2) then
        node_tab[11].view:setIsVisible(false);
        node_tab[10].view:setIsVisible(true);
    end

    if (skill_struct.skill_keyin == 1) then 
        self.label_keyin_state:setText(Lang.pet.skillstudy_page[22])    -- 已刻印
    else
        self.label_keyin_state:setText(Lang.pet.skillstudy_page[23])    -- 未刻印
    end

    node_tab[13]:setText("#cffff00" .. table.skill_type);
    -- 技能释放范围
    self.label_skill_range:setText(Lang.pet.skillstudy_page[20]..table.skill_range);
    -- local cooldown_t =  skill_info2.skillSubLevel[skill_struct.skill_lv].cooldownTime/1000 ;
    self.label_skill_cd:setText(Lang.pet.skillstudy_page[21]..table.skill_cd..Lang.pet.keyin_page[14])
    local skill_str = Lang.pet.keyin_page[12] .. skill_info2.skillSubLevel[skill_struct.skill_lv].desc; -- [1730]="#c66ff66施法效果:#cffffff"
    -- -- 计算行数
    -- local line = math.ceil( string.len(skill_str)/ 45);
    -- if ( node_tab[16] ) then
    --     node_tab[16]:removeFromParentAndCleanup(true);
    --     node_tab[16] = nil;
    -- end
  
    node_tab[16]:setText(skill_str);
  
    
    -- 技能图标
    local path =  SkillConfig:get_skill_icon_path(skill_struct.skill_id ,skill_struct.skill_lv);
    if ( node_tab[18] ) then
        node_tab[18]:removeFromParentAndCleanup(true);
        node_tab[18] = nil;
    end
    node_tab[18] = MUtils:create_sprite(parent,table.icon_path,417,458);
    node_tab[18]:setScale(icon_scale_TJXS)
end

function PetSkillKeYinPage:update_all( p_s )

    if ( p_s == nil ) then
        return ;
    end

    local tab_skill_keyin_view = self.tab_skill_keyin_view;

    -- 先取消选中特效
    SlotEffectManager.stop_current_effect()

	local pet_attrs = p_s.tab_attr;
    -- 更新宠物名字
    self.label_pet_name:setText(p_s.pet_name);
    -- 宠物技能 要更新
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
        if ( tab_skill_keyin_view[1 + i] ) then
             -- 判断技能数量,小于技能数量就不用图片
            if ( i  < p_s.pet_skill_num ) then 
                local skill_id = p_s.tab_pet_skill_info[i+1].skill_id;
                local skill_lv = p_s.tab_pet_skill_info[i+1].skill_lv;
                tab_skill_keyin_view[1 + i]:set_pet_skill_icon( skill_id,skill_lv );
                tab_skill_keyin_view[1 + i]:set_icon_bg_texture(UILH_NORMAL.item_bg2)
            elseif i < p_s.tab_attr[34] then
                tab_skill_keyin_view[1 + i]:set_pet_skill_icon( nil,nil );
                tab_skill_keyin_view[1 + i]:set_icon_bg_texture(UILH_NORMAL.item_bg2)
            else
                tab_skill_keyin_view[1 + i]:set_pet_skill_icon( nil,nil );
                tab_skill_keyin_view[1 + i]:set_icon_bg_texture(UILH_NORMAL.lock)
            end
        else
            local bg_path = UILH_NORMAL.item_bg2;
            if ( i  < p_s.pet_skill_num ) then 
                local skill_id = p_s.tab_pet_skill_info[i+1].skill_id;
                local skill_lv = p_s.tab_pet_skill_info[i+1].skill_lv;
                tab_skill_keyin_view[1 + i] = MUtils:create_pet_slot_skill2( node_skill_keyin,bg_path,start_x  + (i % 4) * item_width,y,64,64,skill_id,skill_lv );
            elseif i < p_s.tab_attr[34] then
                tab_skill_keyin_view[1 + i] = MUtils:create_pet_slot_skill2( node_skill_keyin,bg_path,start_x  + (i % 4) * item_width,y,64,64,nil,nil,nil );
            else
                tab_skill_keyin_view[1 + i] = MUtils:create_pet_slot_skill2( node_skill_keyin,bg_path,start_x  + (i % 4) * item_width,y,64,64,nil,nil,nil );
                tab_skill_keyin_view[1 + i]:set_icon_bg_texture(UILH_NORMAL.lock)
            end
            local function btn_fun(_self,eventType, args, msgi)
                local index = MUtils:get_click_btn_index(args,start_x-_x,start_y+item_height-_y,item_width,item_height,4);
                local pet_struct = PetWin:get_current_pet_info();
                if ( index <=  #pet_struct.tab_pet_skill_info) then
                    self:update_skill_panel( pet_struct.tab_pet_skill_info[index] ,1,tab_skill_keyin_view,node_skill_keyin);
                    -- 当前选中的技能索引
                    curr_select_skill_index = index ;
                    tab_skill_keyin_view[1 + i]:set_select_effect_state( true )
                else
                    self:update_skill_panel(nil,1,tab_skill_keyin_view,node_skill_keyin);
                    curr_select_skill_index = 0;
                    tab_skill_keyin_view[1 + i]:set_select_effect_state( false )
                    SlotEffectManager.stop_current_effect()
                   -- print("i = ",i,"pet_struct.tab_attr[34]",pet_struct.tab_attr[34])
                    if ( i >= pet_struct.tab_attr[34] ) then
                       GlobalFunc:create_screen_notic( Lang.pet.pet_info_page[17] ) -- [1691]="悟性达到12、24,成长到达13、26分别增加一个技能槽"
                    end
                end
                return true;
            end
            tab_skill_keyin_view[1 + i]:set_click_event( btn_fun )
        end

    end
    -- if ( p_s.pet_skill_num > 0 ) then
    --     self:update_skill_panel(p_s.tab_pet_skill_info[1],1,tab_skill_keyin_view,node_skill_keyin);
    -- else
    --     self:update_skill_panel(nil,1,tab_skill_keyin_view,node_skill_keyin);
    -- end
    self:update_skill_panel(nil,1,tab_skill_keyin_view,node_skill_keyin);
end

-- 18 技能移到仓库结果  回调
function PetSkillKeYinPage:cb_skill_move_store(store_id)
    print("store_id",store_id )
	-- 处理数据
    local struct = PetWin:get_current_pet_info();
    local skill_tab = struct.tab_pet_skill_info;
    -- 添加新技能到仓库
    local skill_lv = skill_tab[curr_select_skill_index].skill_lv;
    local skill_id = skill_tab[curr_select_skill_index].skill_id;
    local skill_store_tab = PetModel:get_pet_skill_store();
    local len = #skill_store_tab;
    require "struct/PetStoreSkillStruct"
    skill_store_tab[ len + 1 ] = PetStoreSkillStruct(nil,store_id,skill_id,skill_lv,1);

    -- 删除当前宠物移动到仓库的技能
    struct:deleteSkill(curr_select_skill_index);
	self:change_layout1();
    curr_select_skill_index = - 1;
    self:update_skill_panel(nil,1,self.tab_skill_keyin_view,nil);
    -- 停止选中特效
    SlotEffectManager:stop_current_effect();
end

-- 19 技能从仓库移出 回调
function PetSkillKeYinPage:cb_remove_skill_form_store()
	-- 处理数据
    -- 从仓库取出对应的技能信息
    local skill_store_tab = PetModel:get_pet_skill_store();
    --print("skill_store_tab.num = "..  #skill_store_tab);
   -- print("curr_select_skill_index = " .. curr_select_skill_index);
    local skill_lv = skill_store_tab[curr_select_skill_index].skill_lv;
    local skill_id = skill_store_tab[curr_select_skill_index].skill_id;
   -- print ("skill_id =" .. skill_id .. " skill_lv =" .. skill_lv);
    -- 当前选中宠物的struct
    local pet_struct = PetWin:get_current_pet_info();
   --require "struct/PetSkillStruct"
    -- 添加新技能到宠物
    pet_struct:addSkill(skill_id,skill_lv,1);
    -- 仓库删除指定索引的技能
    table.remove(skill_store_tab,curr_select_skill_index);
	-- 更新界面
    self:change_layout2();
    curr_select_skill_index = -1;
    self:update_skill_panel(nil,2,self.tab_skill_keyin_view,nil);
    -- 停止选中特效
    SlotEffectManager:stop_current_effect();
end

-- 流程 1:兽魂仓库增加一个技能数据，当前宠物技能表删除一个数据，然后宠物的技能移动到兽魂仓库最后
function PetSkillKeYinPage:change_layout1()
	local p_s = PetWin:get_current_pet_info();


    -- 所有位置前移
    for i=curr_select_skill_index ,8 do
        if ( i <= p_s.pet_skill_num) then
            local skill_id = p_s.tab_pet_skill_info[i].skill_id;
            local skill_lv = p_s.tab_pet_skill_info[i].skill_lv;
            self.tab_skill_keyin_view[i]:set_pet_skill_icon( skill_id ,skill_lv);
        elseif ( i == p_s.pet_skill_num + 1) then
            self.tab_skill_keyin_view[i]:set_icon_ex(nil);
        end
    end
    -- 兽魂仓库增加一个技能
    local pet_skill_store = PetModel:get_pet_skill_store();
    local store_len = #pet_skill_store;
    local skill_id = pet_skill_store[store_len].skill_id;
    local skill_lv = pet_skill_store[store_len].skill_lv;
    if self.tab_skill_keyin_view[18 +store_len] then
        self.tab_skill_keyin_view[18 +store_len]:set_pet_skill_icon( skill_id ,skill_lv);
    end
end
-- 兽魂仓库的技能移动到宠物身上
function PetSkillKeYinPage:change_layout2()
    local p_s = PetWin:get_current_pet_info();

    -- 兽魂仓库删除一个技能
    local pet_skill_store = PetModel:get_pet_skill_store();
    local store_len = #pet_skill_store;
    print("store_len = ",store_len);
    local y = 107;
    -- 从被清除的技能后一位开始，所有的技能位置前移
    for i= curr_select_skill_index ,8 do
        if ( i <= store_len) then
            local skill_id = pet_skill_store[i].skill_id;
            local skill_lv = pet_skill_store[i].skill_lv;
            self.tab_skill_keyin_view[18 +i]:set_pet_skill_icon( skill_id ,skill_lv);
        elseif ( i == store_len + 1) then
            self.tab_skill_keyin_view[18 +i]:set_pet_skill_icon(nil);
        end
    end
    local pet_skill_tab = p_s.tab_pet_skill_info;
    
    self.tab_skill_keyin_view[#pet_skill_tab]:set_pet_skill_icon(pet_skill_tab[#pet_skill_tab].skill_id,pet_skill_tab[#pet_skill_tab].skill_lv);

end
