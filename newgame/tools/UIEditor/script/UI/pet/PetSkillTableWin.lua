-- PetWin.lua
-- create by hcl on 2013-1-6
-- refactored by guozhinan on 2014-10-29
-- 宠物技能图鉴

super_class.PetSkillTableWin(NormalStyleWindow)

-- 左边距
local l_m = 19;
-- 下边距
local b_m = 39;

local base_panel = nil;

-- 控制系滚动
-- local kongzhixi_panel = nil;
-- local gongjixi_panel = nil;
-- local fuzhuxi_panel = nil;

-- 当前选中的面板的序号
local curr_select_panel_index = 1;
-- 当前选中的面板
local curr_select_panel = nil;

-- 右边要更新的技能信息控件table
local tab_right_panel = {};

-- UIManager使用来创建
function PetSkillTableWin:create( texture_name )
    local view = PetSkillTableWin(nil,5,10,890,565);
	return view;
end
-- 

function PetSkillTableWin:__init( window_name, texture_name)

	base_panel = self.view;

    -- 大背景
    local bg = CCZXImage:imageWithFile(12,10,878,565,UILH_COMMON.bottom_bg,500,500)
    self.view:addChild(bg,-1)

    -- 中间背景
    local mid_bg = CCZXImage:imageWithFile(135,17,390,550,UILH_COMMON.bg_10,500,500)
    self.view:addChild(mid_bg)

    -- 左边的选项卡
    local raido_btn_group = ZRadioButtonGroup:create(base_panel, 25 ,345, 105,70*3, 1 );

    -- 旗帜图标，代表当前选中按钮
    self.select_btn_flag = CCZXImage:imageWithFile(5,511,-1,-1,UILH_BENEFIT.month_bg)
    self.select_btn_flag:setFlipX(true)
    self.view:addChild(self.select_btn_flag,-1)

    self.base_path_gray = UIResourcePath.FileLocate.lh_pet .. "tab_title_gray";
    self.base_path_light = UIResourcePath.FileLocate.lh_pet .. "base_path_light";
    for i=1,3 do
        local function radio_btn_fun(eventType, args, msg_id)
            self:create_tab_view(i);
            self.select_btn_flag:setPosition(5,581-i*70);
        end
        local btn = ZButton:create(nil,{"",""},radio_btn_fun,0,0,105,50);
        ZImage:create(btn,self.base_path_gray .. i .. ".png",27,13,-1,-1);
        raido_btn_group:addItem(btn,20);
    end

    local start_x = 550
    local start_y = 416

    -- 技能名称
    tab_right_panel[1] = ZLabel:create(base_panel,LangGameString[1736],720,490,17,2); -- [1736]="#cfff000等级技能名称"
    tab_right_panel[2] = ZLabel:create(base_panel,LangGameString[1737],start_x,start_y,17); -- [1737]="#cfff000攻击系"
    ZLabel:create(base_panel,Lang.pet.skillstudy_page[20],start_x,start_y-30,17); -- [1726]="#c66ff66施法距离:"
    tab_right_panel[3] = ZLabel:create(base_panel,"#cfff00010",start_x+95,start_y-30,17);
    ZLabel:create(base_panel,Lang.pet.skillstudy_page[21],start_x+150,start_y-30,17);    -- [1727]="#c66ff66冷却时间:"
    tab_right_panel[4] = ZLabel:create(base_panel,LangGameString[1738],start_x+245,start_y-30,17); -- [1738]="#cfff00010秒"
    --tab_right_panel[5] = MUtils:create_label_with_size(base_panel,"施法效果:在攻击时有一定几率对目标造成100%攻击伤害，并使目标在6秒内每3秒损失2%生命，灵巧资质越高，触发概率越高","Arial",15,CCSizeMake(240,130),CCTextAlignmentLeft,516-l_m,225-b_m,ccc3(255,255,0),CCPoint(0,1.0));  
    tab_right_panel[5] = ZDialog:create(base_panel,"",start_x,start_y-35,300,0,17)
    tab_right_panel[5].view:setLineEmptySpace(10)
    tab_right_panel[5]:setAnchorPoint(0, 1)

    self:create_skill_info_panel(530,17,355,550, nil)

    self:create_scroll_view(self.view);
end

function PetSkillTableWin:create_skill_info_panel(x, y, width, height,texture_path)
    self.skill_info_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
    self.view:addChild(self.skill_info_panel,-1)

    -- 技能slotitem背景
    ZCCSprite:create(self.skill_info_panel,UILH_NORMAL.item_bg2,80,480);

    -- 分割线
    local line = CCZXImage:imageWithFile( 10, 430, 335, 3, UILH_COMMON.split_line)
    self.skill_info_panel:addChild(line)

    -- 项目逼得紧，没空再整理旧代码了
end

function PetSkillTableWin:on_exit_btn_create_finish()
    local function close_fun()
        UIManager:hide_window("pet_skill_table_win")

        local page_index = PetModel:get_cur_page_index(); -- 创建宠物窗口后，页数会被重置，所以先保存一下
        local win = UIManager:show_window("pet_win");
        if win then
            win:change_pet_index(PetModel:get_cur_pet_index())
            win:goto_page(page_index)
        end
    end
    self._exit_btn:setTouchClickFun( close_fun )  
end

-- index 1 = 控制系,2 = 攻击系 ,3 = 辅助系
function PetSkillTableWin:create_tab_view(index)
    self.select_btn_index = index
    local skill_type_group = PetConfig:get_skill_type_group();
    self.curr_type_group = skill_type_group[index];
    self.scroll:clear();
    self.scroll:setMaxNum(#self.curr_type_group);
    self.scroll:refresh();
    local skill_info,skill_type_str,skill_range,icon_path = self:get_right_panel_info( 1,1,index );
    self:update_right_panel(skill_info,skill_type_str,1,skill_range,icon_path);
end

function PetSkillTableWin:create_scroll_view(parent)

    local skill_type_group = PetConfig:get_skill_type_group();
    self.select_btn_index = 1;
    -- 先取第一个
    self.curr_type_group = skill_type_group[1];
    local row_num         = #self.curr_type_group;
    -- print("row_num",row_num)
    local function scrollfun( _self, row )
        -- print("row = ",row)
        row = row + 1;
        local panel = CCBasePanel:panelWithFile(0,0,365,125,nil,0,0);

        local lab_x = 44;
        local lab_y = 90;
        -- 创建技能名称标题 
        -- 根据技能id取得对应的技能信息
        local skill_info = SkillConfig:get_skill_by_id( self.curr_type_group[row] );
        -- ZTextImage:create(panel,"#cfff000"..skill_info.name,UIResourcePath.FileLocate.common .. "quan_bg.png",15, lab_x, lab_y,460,26,19,12,19,12,19,12,19,12);
        -- 标题
        MUtils:create_zxfont(panel, "#cffffff"..skill_info.name, 10, 101, 1, 17)
        -- 分割线
        local line = CCZXImage:imageWithFile( 0, 0, 360, 3, UILH_COMMON.split_line)
        panel:addChild(line)

        for j=1,4 do
            -- 根据技能id和技能等级取得icon
            local skill_info,skill_type_str,skill_range,icon_path = self:get_right_panel_info(row,j,self.select_btn_index);
            local function btn_fun(eventType, args, msg_id)
                self:update_right_panel(skill_info,skill_type_str,j,skill_range,icon_path);
            end
            local spr_x = lab_x + (j-1) * 92;
            ZCCSprite:create(panel,UILH_NORMAL.item_bg2,spr_x,51)
            local btn = ZButton:create(panel,icon_path,btn_fun,spr_x, 51,64,64);
            btn.view:setAnchorPoint(0.5,0.5)
        end
        return panel;
    end

    self.scroll = ZScroll:create(parent, scrollfun, 145, 37, 365, 510 , row_num);
    self.scroll:setScrollLump( 10, 20, 90 )
    self.scroll:setScrollLumpPos( 365 )
    self.scroll:refresh();

    local arrow_up = CCZXImage:imageWithFile(510 , 547, 10, -1 , UILH_COMMON.scrollbar_up, 500, 500)
    local arrow_down = CCZXImage:imageWithFile(510, 26, 10, -1, UILH_COMMON.scrollbar_down, 500 , 500)
    parent:addChild(arrow_up)
    parent:addChild(arrow_down)

    local skill_info,skill_type_str,skill_range,icon_path = self:get_right_panel_info( 1,1,self.select_btn_index );
    self:update_right_panel(skill_info,skill_type_str,1,skill_range,icon_path);

    return scroll;
end

function PetSkillTableWin:get_right_panel_info( row,lv ,index)
    local skill_type_str = "";
    local skill_range = "";
    if ( index == 1 ) then
        skill_type_str = LangGameString[301]; -- [301]="控制系"
        skill_range = "10";
    elseif(index == 2) then
        skill_type_str = LangGameString[302]; -- [302]="攻击系"
        skill_range = "60";
    elseif(index == 3) then
        skill_type_str = LangGameString[303]; -- [303]="辅助系"
        skill_range = "10";
    end
    local skill_info = SkillConfig:get_skill_by_id( self.curr_type_group[row] );
    local icon_path = SkillConfig:get_skill_icon_path( self.curr_type_group[row] , lv);
    return skill_info,skill_type_str,skill_range,icon_path;
end

function PetSkillTableWin:update_right_panel(skill_info,skill_type_str,skill_lv,skill_range,icon_path)
     print("PetSkillTableWin:update_right_panel(skill_info,skill_type_str,skill_lv,skill_range,icon_path)",skill_info,skill_type_str,skill_lv,skill_range,icon_path)
    local base_name = "";
    local cooldown_t =  skill_info.skillSubLevel[skill_lv].cooldownTime/1000 .. LangGameString[875]; -- [875]="秒"
    local skill_str = Lang.pet.skillstudy_page[11] .. skill_info.skillSubLevel[skill_lv].desc; -- [1739]="#cfff000施法效果:"
    local skill_name = PetConfig:get_pet_skill_name_by_skill_lv(skill_lv,skill_info.name);

    tab_right_panel[1]:setText(skill_name);
    tab_right_panel[2]:setText(LH_COLOR[1]..skill_type_str);
    tab_right_panel[3]:setText(LH_COLOR[15]..skill_range);
    tab_right_panel[4]:setText(LH_COLOR[15]..cooldown_t);

    tab_right_panel[5]:setText(skill_str);
    
    -- if tab_right_panel[6] ~= nil then
    --     tab_right_panel[6].view:removeFromParentAndCleanup(true);
    --     tab_right_panel[6] = nil;
    -- end
    tab_right_panel[6] = ZImage:create(base_panel,icon_path,579,465, 64, 64);

end
