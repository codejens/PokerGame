-- PetOpenEggWin.lua
-- create by hcl on 2013-1-19
-- refactored by guozhinan on 2014-10-30
-- 宠物开蛋窗口

-- 下边距
local b_m = 81;

require "UI/component/Window"
super_class.PetOpenEggWin(NormalStyleWindow)

-- 宠物蛋的item_id
function PetOpenEggWin:show( pet_struct )
    if ( GameSysModel:isSysEnabled(GameSysModel.PET) ) then
        local win = UIManager:show_window("pet_open_egg_win");
        win:update_view(pet_struct);
    end
end


local update_view = {};

function PetOpenEggWin:__init( )

	local bg = CCZXImage:imageWithFile( 12, 73, 457, 287, UILH_COMMON.bottom_bg,500,500)
	self.view:addChild(bg)

	-- local clip_bg = CCTouchPanel:touchPanel(18, 86, 255, 260);
    local clip_bg = CCZXImage:imageWithFile(18, 86, 255, 260,UILH_COMMON.bg_10,500,500);
	self.view:addChild(clip_bg)

	local pet_bg = CCZXImage:imageWithFile( -36, -2, 324, 264, UILH_PET.pet_ronghe_bg,0,0)
	clip_bg:addChild(pet_bg)

    self.tab_slot_pet_skill = {};
    -- 技能槽
    for i=1,2 do
        self.tab_slot_pet_skill[i] = MUtils:create_pet_slot_skill2(self.view,UILH_NORMAL.item_bg2,198+i*100,100,64,64)
    end

    self.tab_str = Lang.pet.egg_page[1]
    local begin_x = 279
    local top_y = 335
    local space = 23 
    -- 宠物名
    self.lab_pet_name = ZLabel:create(self.view,Lang.pet.egg_page[4],begin_x,top_y,16,1); -- [1700]="#cfff000宠物名"
    for i=1,6 do
        update_view[i] = ZLabel:create(self.view,self.tab_str[i],begin_x,top_y-i*space,16,1);
        -- update_view[i].up_view = ZCCSprite:create(update_view[i].view,UIResourcePath.FileLocate.normal .. "up_g.png",130,10);
        -- update_view[i].up_view.view:setIsVisible(false);
        -- update_view[i].down_view = ZCCSprite:create(update_view[i].view,UIResourcePath.FileLocate.normal .. "down_r.png",130,10);
        -- update_view[i].down_view.view:setIsVisible(false);
    end
    ZLabel:create(self.view,Lang.pet.egg_page[5],begin_x,top_y-7*space,16,1);

    -- 分割线
    -- local line = CCZXImage:imageWithFile( 16, 76, 450, 3, UILH_COMMON.split_line)
    -- self.view:addChild(line)

	local function btn_ok_fun(eventType,x,y)
        Instruction:handleUIComponentClick(instruct_comps.PET_WIN_GET)
    	self.pet_id = nil;
       --xiehande  添加领养特效
       local win = UIManager:find_visible_window("bag_win");
       if win then
         win:play_success_effect();
       end
 		UIManager:hide_window("pet_open_egg_win");
	end
    local btn1 = ZTextButton:create(self.view,Lang.pet.egg_page[2],{UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s},btn_ok_fun,67,15); -- [1701]="领养"

	local function btn_cancel_fun(eventType,x,y)
    	if ( self.pet_id ) then
            PetCC:req_delete_pet(self.pet_id);
        end
    	UIManager:hide_window("pet_open_egg_win");
    	self.pet_id = nil;
	end
	local btn2 = ZTextButton:create(self.view,Lang.pet.egg_page[3],{UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s},btn_cancel_fun,282,15); -- [1682]="放生"

 --    local function get_pet_and_open_win( eventType,x,y )
 --        UIManager:hide_window("pet_open_egg_win");
 --        local win = UIManager:show_window("pet_win");
 --        if ( win ) then
 --            win:do_tab_button_method( 6 )
 --        end
 --    end
 --    ZTextButton:create(self.view,LangGameString[1702],{UIResourcePath.FileLocate.common .. "button2_bg.png",UIResourcePath.FileLocate.common .. "button2_bg.png"},get_pet_and_open_win,142,15,110,31,23,12,23,12,23,12,23,12) -- [1702]="领养融合"
end

function PetOpenEggWin:update_view(pet_struct)

	-- 更新宠物名字 
	self.lab_pet_name:setText(Lang.pet.egg_page[4]..pet_struct.pet_name);
	self.pet_id = pet_struct.tab_attr[1];
    local fight_pet_struct = PetModel:get_current_pet_info(  )
	-- 更新资质
	for i=1,6 do
        if i < 3 then
            if i == 1 then
                update_view[i]:setText(self.tab_str[i].. pet_struct.curr_wx);
            else
                update_view[i]:setText(self.tab_str[i].. pet_struct.curr_grow);
            end
        else
            local zz = pet_struct.tab_attr[26+i];
            local color = MUtils:get_zz_color( zz )
            update_view[i]:setText(self.tab_str[i]..color..zz);
            if ( fight_pet_struct and zz > fight_pet_struct.tab_attr[26+i] ) then
                -- update_view[i].up_view.view:setIsVisible(true);
                -- update_view[i].down_view.view:setIsVisible(false);
            elseif ( fight_pet_struct and zz < fight_pet_struct.tab_attr[26+i] ) then
                -- update_view[i].up_view.view:setIsVisible(false);
                -- update_view[i].down_view.view:setIsVisible(true);
            else
                -- update_view[i].up_view.view:setIsVisible(false);
                -- update_view[i].down_view.view:setIsVisible(false);  
            end
        end

	end 

	if ( pet_struct.pet_skill_num > 0 )then
        for i=1,pet_struct.pet_skill_num do
            local skill_struct = pet_struct.tab_pet_skill_info[i];
            self.tab_slot_pet_skill[i]:set_pet_skill_icon( skill_struct.skill_id,skill_struct.skill_lv ) 
            local function f1( _self,eventType, args, msgi )
                local click_pos = Utils:Split(args, ":")
                print(click_pos[1],click_pos[2])
                local world_pos = self.tab_slot_pet_skill[i].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
                TipsModel:show_pet_skill_tip( world_pos.x, world_pos.y,skill_struct );
            end
            self.tab_slot_pet_skill[i]:set_click_event( f1 )
        end

	end

    if ( self.spr == nil ) then
        local pet_file = string.format("scene/monster/%d",pet_struct.tab_attr[2]);
        local action = {0,0,9,0.2};
        self.spr = MUtils:create_animation(150,200, pet_file,action )
        self.view:addChild( self.spr,1 );
    else
        self.spr:removeFromParentAndCleanup(true);
        local pet_file = string.format("scene/monster/%d",pet_struct.tab_attr[2]);
        local action = {0,0,9,0.2};
        self.spr = MUtils:create_animation(150,200, pet_file,action )
        self.view:addChild( self.spr,1 );
    end

    -- LuaEffectManager:stop_view_effect( 10012,self.view);
    -- LuaEffectManager:stop_view_effect( 10013,self.view);
    -- -- 播放魔法阵特效
    -- LuaEffectManager:play_view_effect( 10012,116+80 ,110+80,self.view,true ,0);
    -- LuaEffectManager:play_view_effect( 10013,116+80 ,110+80,self.view,true ,2);
end

function PetOpenEggWin:active( show )
	--print("show.........")
	if ( show ) then
		if ( XSZYManager:get_state() == XSZYConfig.CWRH_ZY ) then
			-- XSZYManager:unlock_screen();
			-- 指向领取按钮 79 ,64,71,31
			XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.CWRH_ZY,1, XSZYConfig.OTHER_SELECT_TAG );
		end
	else
		--self.spr:stopAllActions();
		if ( XSZYManager:get_state() == XSZYConfig.CWRH_ZY ) then
			XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG )
			-- 打开宠物界面
			local win = UIManager:show_window("pet_win");
            win:do_tab_button_method(1);
		end
	end
	--print("show.........2")
end


