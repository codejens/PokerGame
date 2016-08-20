-- SuXingWin.lua
-- create by hcl on 2013-1-5
-- 苏醒窗口

super_class.SuXingWin(NormalStyleWindow)

-- 左边距
local l_m = 19;
-- 下边距
local b_m = 39;

-- 单次刷新选择的消耗货币类型,1,元宝2,绑定元宝
local one_sel_type = 1;
-- 批量刷新选择的消耗货币类型,1,元宝，2绑定元宝
local muti_sel_type = 1;
-- 要更新的控件
local table_update_view = {};

local suxing_panel = nil;

local series = nil;

-- UIManager使用来创建PetWin
-- function SuXingWin:create( texture_name )
-- 	--local view = PetWin("ui/common/bg02.png",20,30,760,424);
--     local view = SuXingWin(nil,l_m,b_m,760,424);
-- 	return view;
-- end
-- 

function SuXingWin:__init( window_name, texture_name)

    suxing_panel = self.view;
    
    -- 背景
    -- MUtils:create_zximg(suxing_panel,UILH_COMMON.bg_grid,5,10,890,565,500,500);
    -- 二级背景
    local left_bg = MUtils:create_zximg(suxing_panel,UILH_COMMON.bottom_bg,18,94,352,473,500,500);
    -- MUtils:create_zximg(suxing_panel,UILH_COMMON.bg_07,18,21,865,70,500,500);
    MUtils:create_zximg(suxing_panel,UILH_COMMON.bottom_bg,371,94,512,473,500,500);

    --单个刷新标题
    local title_panel = CCBasePanel:panelWithFile( 0, 473-39, 350, 35, UILH_NORMAL.title_bg4, 500, 500)
    left_bg:addChild(title_panel)
    MUtils:create_zxfont(title_panel,Lang.pet.skillstudy_page[29],350/2,11,2,16);    -- 单个刷新

    table_update_view[8] = MUtils:create_slot_item2(suxing_panel,UILH_NORMAL.item_bg2,161,420,64,64,nil,nil,9);
    table_update_view[1] = ZLabel:create(suxing_panel,"",18+350/2,375,20,ALIGN_CENTER)

    -- 苏醒
    local function btn_suxing_fun(eventType,x,y)
        if ( series ) then 
         PetCC:req_wake_skill( series,0);
            series = nil;
        end
        -- if table_update_view[8].item_id and table_update_view[8].item_id ~= 0 then
        --     PetCC:req_wake_skill(0, 0)
        -- else
        --     print("没有技能书，不能苏醒技能")
        -- end
    end
    local btn_study = ZButton:create(suxing_panel,UILH_COMMON.button6_4,btn_suxing_fun,149,310,-1,-1)
    MUtils:create_zxfont(btn_study,Lang.pet.skillstudy_page[28],89/2,16,2,14);     --[1767]="苏醒记忆"

    -- 分割线
    local line = CCZXImage:imageWithFile( 5, 198, 342, 3, UILH_COMMON.split_line)
    left_bg:addChild(line)
    
    -- 单选框
    local raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(116,203, 40,120,nil);
    suxing_panel:addChild(raido_btn_group);
    local function toggle1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
			one_sel_type = 2;
            return true;
        -- RadioButton必须要注册TOUCH_BEGAN和TOUCH_ENDED
        elseif eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    local function toggle2_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	one_sel_type = 1;
            return true;
        -- RadioButton必须要注册TOUCH_BEGAN和TOUCH_ENDED
        elseif eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    MUtils:create_radio_button(raido_btn_group,UILH_COMMON.fy_bg, UILH_COMMON.fy_select,toggle1_fun,0,45,-1,-1,false);
    MUtils:create_radio_button(raido_btn_group,UILH_COMMON.fy_bg, UILH_COMMON.fy_select,toggle2_fun,0,0,-1,-1,false);
    
    local function _func2()
        one_sel_type = 2;
        raido_btn_group:selectItem(0)
    end
    MUtils:create_text_btn(suxing_panel,Lang.pet.skillstudy_page[33],151,255,100,20,_func2) -- [33]="50绑定元宝刷新"

    local function _func()
        one_sel_type = 1;
        raido_btn_group:selectItem(1)
    end
    MUtils:create_text_btn(suxing_panel,Lang.pet.skillstudy_page[34],151,209,100,20,_func) -- [34]="10元宝刷新"

    -- 刷新
    local function btn_refresh_fun(eventType,x,y)
        if ( series ) then 
            if ( one_sel_type == 1 ) then
                if ( PlayerAvatar:check_is_enough_money( 4,10 ) ) then
                    PetCC:req_get_huan_hun_yu_info( series,1,one_sel_type);
                end
            else
                PetCC:req_get_huan_hun_yu_info( series,1,one_sel_type);
            end
        end
        -- local money_num   = 10
        -- local item_index  = 0
        -- local refresh_type= 1
        -- local money_type  = MallModel:get_only_use_yb() and 3 or 2
        -- local param = {item_index, refresh_type, money_type}
        -- local function request_refresh( param )
        --     PetCC:req_get_huan_hun_yu_info(param[1], param[2], param[3]);
        -- end

        -- MallModel:handle_auto_buy( money_num, request_refresh, param )
    end
    local btn_refresh = ZButton:create(suxing_panel,{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},btn_refresh_fun,134,102,-1,-1)
    MUtils:create_zxfont(btn_refresh,Lang.pet.skillstudy_page[31],121/2,20,2,16);     -- [31]="刷新"


    --批量刷新标题
    local title_panel = CCBasePanel:panelWithFile( 372, 532, 512, 31, UILH_NORMAL.title_bg4, 500, 500 )
    self.view:addChild(title_panel)
    MUtils:create_zxfont(title_panel,Lang.pet.skillstudy_page[30],512/2,9,2,16);    -- 单个刷新

    -- 批量刷新
    local x,y = 0,0;
    for i=1,6 do
        x = 464 + (i-1)%2*253;
        y = 465 - math.floor((i-1)/2)*103;

        ZImage:create(suxing_panel,UILH_COMMON.bg_10,x-87,y-34.5,247,100,0,500,500)
        table_update_view[8 + i] =  MUtils:create_slot_item2(suxing_panel,UILH_NORMAL.item_bg2,x-71,y-18,64,64,nil,nil,9);
        -- 苏醒
        local function btn_fun(eventType,x,y)
            if ( series ) then 
            	require "control/PetCC"
        		PetCC:req_wake_skill( series,i);
            end
            -- if table_update_view[8 + i].item_id and table_update_view[8 + i].item_id ~= 0 then
            --     PetCC:req_wake_skill(0, i)
            -- end
        end
        local btn_study = ZButton:create(suxing_panel,UILH_COMMON.button6_4,btn_fun,x+10,y-25,-1,-1)
        MUtils:create_zxfont(btn_study,Lang.pet.skillstudy_page[28],89/2,16,2,14);     --"学习技能"
        table_update_view[1+i] = MUtils:create_zxfont(suxing_panel,"",x +70,y+35,2,20);
    end

    -- 分割线
    local line = CCZXImage:imageWithFile( 372, 217, 508, 3, UILH_COMMON.split_line)
    self.view:addChild(line)

    -- 单选框
    local raido_btn_group2 = CCRadioButtonGroup:buttonGroupWithFile(378,184,260,33,nil);
    suxing_panel:addChild(raido_btn_group2);

    local function toggle3_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
			muti_sel_type = 2;
            return true;
        -- RadioButton必须要注册TOUCH_BEGAN和TOUCH_ENDED
        elseif eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    local function toggle4_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	muti_sel_type = 1;
            return true;
        -- RadioButton必须要注册TOUCH_BEGAN和TOUCH_ENDED
        elseif eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    MUtils:create_radio_button(raido_btn_group2,UILH_COMMON.fy_bg, UILH_COMMON.fy_select,toggle3_fun,0,0,-1,-1,false);
    MUtils:create_radio_button(raido_btn_group2,UILH_COMMON.fy_bg, UILH_COMMON.fy_select,toggle4_fun,230,0,-1,-1,false);

    local function func2()
        muti_sel_type = 2;
        raido_btn_group2:selectItem(0)
    end
    MUtils:create_text_btn(suxing_panel,Lang.pet.skillstudy_page[35],409,190,100,20,func2) -- [1771]="250礼券刷新"
    local function func()
        muti_sel_type = 1;
        raido_btn_group2:selectItem(1)
    end
    MUtils:create_text_btn(suxing_panel,Lang.pet.skillstudy_page[36],643,190,100,20,func) -- [1772]="50元宝刷新"

    -- 说明
    MUtils:create_zxfont(suxing_panel,Lang.pet.skillstudy_page[37],381 ,162,1,15); -- [1766]="#cff49f4注意:只能苏醒一次技能."

    -- 批量刷新
    local function btn_muti_refresh_fun(eventType,x,y)
        if ( series ) then 
        	require "control/PetCC"
        	--PetCC:req_get_huan_hun_yu_info( series,2,muti_sel_type);
            if ( muti_sel_type == 1 ) then
                if ( PlayerAvatar:check_is_enough_money( 4,50 ) ) then
                    PetCC:req_get_huan_hun_yu_info( series,2,muti_sel_type);
                end
            else
                PetCC:req_get_huan_hun_yu_info( series,2,muti_sel_type);
            end
        end
        -- local money_num   = 50
        -- local item_index  = 0
        -- local refresh_type= 2
        -- local money_type  = MallModel:get_only_use_yb() and 3 or 2
        -- local param = {item_index, refresh_type, money_type}
        -- local function request_refresh( param )
        --     PetCC:req_get_huan_hun_yu_info(param[1], param[2], param[3]);
        -- end

        -- MallModel:handle_auto_buy( money_num, request_refresh, param )
    end
    local btn_refresh_all = ZButton:create(suxing_panel,{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},btn_muti_refresh_fun,560,100,-1,-1)
    MUtils:create_zxfont(btn_refresh_all,Lang.pet.skillstudy_page[32],121/2,20,2,16);     -- [31]="刷新"

    -- 星星
    -- MUtils:create_sprite(suxing_panel,UIResourcePath.FileLocate.common .. "pet_star_r_bg.png",631-l_m,76-b_m);
    -- MUtils:create_sprite(suxing_panel,UIResourcePath.FileLocate.common .. "pet_star_l_bg.png",178-l_m,76-b_m);
    table_update_view[16] = MUtils:create_zxfont(suxing_panel,"",696,47,16); -- [1773]="已刷新999次"
    -- table_update_view[15] = nil;
    for i=1,8 do
        table_update_view[16 + i] = MUtils:create_zximg(suxing_panel,UILH_NORMAL.star,178 + 63 * (i-1), 33,-1,-1);
        -- table_update_view[16 + i]:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.star_d)
        table_update_view[16 + i]:setCurState(CLICK_STATE_DISABLE);
    end

end

function SuXingWin:cb_refresh(_series,star_num,skill_book_num,skill_book_tab)
    print("cb_refresh")
	series = _series;
	self:update_view(star_num,skill_book_num,skill_book_tab);
end

function SuXingWin:update_view(star_num,skill_book_num,skill_book_tab)
	--print("skill_book_num = " .. skill_book_num);
	-- 更新星星

	-- if ( table_update_view[15] ) then
	-- 	table_update_view[15]:removeFromParentAndCleanup(true);
	-- 	table_update_view[15] = nil;
	-- end
    local str = string.format(Lang.pet.skillstudy_page[38],star_num)  -- [38]="#cd0cda2已刷新#cffffff%d#cd0cda2次"
	table_update_view[16]:setText(str); 
    local len = math.min(8,math.floor(star_num/50));
    for i=1,len do
        table_update_view[16 + i]:setCurState(CLICK_STATE_UP);
    end


	require "config/ItemConfig"
	--local l_path = ItemConfig:get_item_icon(skill_book_tab[1]);
    if skill_book_num == 0 then
        return
    end

    self:set_icon_and_function( table_update_view[8],skill_book_tab[1].skill_item_id );

	local name = ItemConfig:get_item_name_by_item_id(skill_book_tab[1].skill_item_id);
    if not name then
        name = ""
    end
    local color = "#cffffff";
    local skill_lv = PetConfig:get_lv_by_item_id( skill_book_tab[1].skill_item_id );
        if ( skill_lv == 1 ) then
            color = "#c66ff66";
        elseif (skill_lv == 2 ) then
            color = "#c35c3f7";
        elseif (skill_lv == 3 ) then
            color = "#cff49f4";
        elseif (skill_lv == 4 ) then
            color = "#cffc000";
        end
	table_update_view[1]:setText(color.. name);

	-- if ( skill_book_num == 1) then
	-- 	return;
	-- end

	for i=1,6 do
        if ( skill_book_num~=1 ) then
            self:set_icon_and_function( table_update_view[8 + i],skill_book_tab[i+1].skill_item_id );
    		local name = ItemConfig:get_item_name_by_item_id(skill_book_tab[i+1].skill_item_id);
            if not name then
                name = ""
            end
            local color = "#cffffff";
            local skill_lv = PetConfig:get_lv_by_item_id( skill_book_tab[i+1].skill_item_id );
            if ( skill_lv == 1 ) then
                color = "#c66ff66";
            elseif (skill_lv == 2 ) then
                color = "#c35c3f7";
            elseif (skill_lv == 3 ) then
                color = "#cff49f4";
            elseif (skill_lv == 4 ) then
                color = "#cffc000";
            end
    		table_update_view[1 + i]:setText(color .. name);
        else
            self:set_icon_and_function( table_update_view[8 + i] )
            table_update_view[1 + i]:setText("");
        end
	end
	
end

-- function SuXingWin:active(show)
--     one_sel_type = 1;
--     muti_sel_type = 1;
-- end

function SuXingWin:set_icon_and_function( slotItem,item_id )

    if ( item_id and item_id ~= 0 ) then 
        slotItem:set_icon_ex( item_id )
    else
        slotItem:set_icon_ex(  );
    end
    local function f1(...)
        local a, b, arg = ...
        local position = Utils:Split(arg,":");
        -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local pos = slotItem.view:getParent():convertToWorldSpace( CCPointMake(tonumber(position[1]),tonumber(position[2])) );                       

        if ( item_id and item_id ~= 0) then 
                TipsModel:show_shop_tip( pos.x, pos.y, item_id );
            end
        end
    slotItem:set_click_event( f1 )
end

function SuXingWin:active( show )
    if show then
        PetCC:req_get_huan_hun_yu_info(0, 3)
    end
end

function SuXingWin:clear_refresh()
    table_update_view[8]:set_icon_texture("")
    for i=1,6 do
        table_update_view[8 + i]:set_icon_texture("")
    end
end

function SuXingWin:on_exit_btn_create_finish()
    -- 关闭
    local function btn_close_fun(eventType,x,y)
        UIManager:hide_window("suxing_win");
        
        local page_index = PetModel:get_cur_page_index(); -- 创建宠物窗口后，页数会被重置，所以先保存一下
        local win = UIManager:show_window("pet_win");
        if win then
            win:change_pet_index(PetModel:get_cur_pet_index())
            win:goto_page(page_index)
        end
    end
    self._exit_btn:setTouchClickFun(btn_close_fun)
end