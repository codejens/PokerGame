-- GetSkillDialog.lua
-- created by hcl on 2013/5/27
-- 获得技能对话框


require "UI/component/Window"
require "utils/MUtils"
super_class.GetSkillDialog(Window)

local _ui_width = GameScreenConfig.ui_screen_width 
local _ui_height = GameScreenConfig.ui_screen_height

function GetSkillDialog:show( item_id_table,item_series )
    UIManager:destroy_window("get_skill_dialog")
	local win = UIManager:show_window("get_skill_dialog");
	win:init_with_args( item_id_table )
	self.item_series = item_series;
    self.item_id_table = item_id_table;
end

function GetSkillDialog:__init(window_name, texture_name, is_grid, width, height)
	local spr_bg = CCBasePanel:panelWithFile( 0, 0, width, height, UILH_COMMON.dialog_bg, 500,500);
    self.view:addChild( spr_bg);
    spr_bg = self.view

    self:create_title()

    local bgPanel = CCBasePanel:panelWithFile( 15, 68, width-30, height-110, UILH_COMMON.bottom_bg, 500, 500 )
    spr_bg:addChild( bgPanel )
    -- 描述
    MUtils:create_zxfont(bgPanel,Lang.pet.common[18],(width-30)/2,20,2,16); -- [18] = "使用技能秘籍可获得任意一种技能",
    -- 标题背景
    -- MUtils:create_sprite(spr_bg,UIResourcePath.FileLocate.common .. "dialog_title_bg.png",175 ,345 );
    -- MUtils:create_sprite(spr_bg,UIResourcePath.FileLocate.normal .. "dialog_title_t.png",175 ,347 );

    -- 关闭按钮
    -- local function btn_close_fun(eventType,x,y)
    --     if eventType == TOUCH_BEGAN then
    --         return true;
    --     elseif eventType == TOUCH_CLICK then
    --         UIManager:hide_window("get_skill_dialog");
    --         return true;
    --     elseif eventType == TOUCH_ENDED then
    --         return true;
    --     end
    -- end
    -- local exit_btn = MUtils:create_btn(spr_bg,UIResourcePath.FileLocate.common .. "close_btn_n.png",UIResourcePath.FileLocate.common .. "close_btn_s.png",btn_close_fun,0,0,-1,-1);
    -- local exit_btn_size = exit_btn:getSize()
    -- local spr_bg_size = spr_bg:getSize()
    -- exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    -- 选中框
    -- self.select_effect_node = MUtils:create_zximg(spr_bg, UILH_COMMON.select_focus2,-500,-500,158,164,500,500,50);

    self.slot_item_table = {};
    self.slot_item_name = {};
    self.slot_item_bg = {}
    -- 4个技能
    for i=1,2 do
    	local x = 30 + (i-1)%2*181;
    	local y = 112 -- 284-math.floor((i-1)/2)*172;
        local function panel_function( eventType,args,msg_id)
            if ( eventType == TOUCH_BEGAN ) then
                return true;
            elseif ( eventType == TOUCH_CLICK ) then
                if ( i <= #self.item_id_table ) then 
                    -- self.select_effect_node:setPosition(x,y);
                    if self.curr_select_index ~= nil and self.curr_select_index > 0 then
                        self.slot_item_bg[self.curr_select_index]:setTexture(UILH_COMMON.bg_normal)
                    end
                    self.slot_item_bg[i]:setTexture(UILH_COMMON.bg_selected)
                    self.curr_select_index = i;
                    self.get_skill_btn:setCurState(CLICK_STATE_UP);
                end
                return true;
            end
            return true
        end
        local icon_bg = CCBasePanel:panelWithFile( x, y, 173, 164, nil);
    	spr_bg:addChild(icon_bg);
        local img_bg = CCZXImage:imageWithFile(0,0,173,164,UILH_COMMON.bg_normal, 500,500)
        icon_bg:addChild(img_bg)
        self.slot_item_bg[i] = img_bg;
        icon_bg:registerScriptHandler(panel_function);
        self.slot_item_table[i] = MUtils:create_slot_item2(icon_bg, UIPIC_ITEMSLOT, 53, 80, 64, 64,nil,nil,9.5);
   		--local str = PetConfig:get_pet_skill_name_by_skill_lv(4,skill_book_name_table[i]);
   		self.slot_item_name[i] = MUtils:create_zxfont(icon_bg,"", 173/2, 44, 2, 16);
    end

    local function btn_ok_fun(eventType,x,y)
        -- if eventType == TOUCH_BEGAN then
        --     return true;
        -- elseif eventType == TOUCH_CLICK then
 			-- TODO 获得技能
 			if ( self.curr_select_index ~= -1 ) then 
	 			MiscCC:req_get_a_item( self.item_series,self.curr_select_index);
                --xiehande 获得技能特效
                -- self:play_skill_effect()
                --延迟0.4秒播放特效
                -- local cb =callback:new();
                -- local function  cbfunc()
                    UIManager:hide_window("get_skill_dialog")
                -- end 
                -- cb:start(0.4,cbfunc);

            else
                GlobalFunc:create_screen_notic( LangGameString[2437], 16, _ui_width/2, _ui_height/2, 2 )
	 		end
        --     return true;
        -- end
        -- return true
    end
    -- self.get_skill_btn = MUtils:create_btn(spr_bg,UIResourcePath.FileLocate.common .. "dan.png",UIResourcePath.FileLocate.common .. "dan.png",btn_ok_fun,122,30,-1,-1,1,39,19,39,19,39,19,39,19);
    -- MUtils:create_sprite(self.get_skill_btn,UIResourcePath.FileLocate.pet .. "get_skill.png",53 ,20.5 );
    self.get_skill_btn = ZButton:create( self.view, UILH_NORMAL.special_btn, btn_ok_fun, (width-162)/2, 12 )
    local btn_text = CCZXImage:imageWithFile( 162/2, 53/2, -1, -1, UILH_PET.huodejineng )
    btn_text:setAnchorPoint(0.5, 0.5)
    self.get_skill_btn:addChild( btn_text )

end

function GetSkillDialog:create_title(  )
    --标题背景
    self.title_bg = CCBasePanel:panelWithFile( 0, 0, -1, 60, UIPIC_COMMOM_title_bg )
    local title_bg_size = self.title_bg:getSize()
    self.title_bg:setPosition( ( self.view:getSize().width - title_bg_size.width ) / 2, self.view:getSize().height - title_bg_size.height/2-14)
    self.title  = CCZXImage:imageWithFile( title_bg_size.width/2, title_bg_size.height-27, -1, -1,  UILH_NORMAL.title_tips  )
    self.title:setAnchorPoint(0.5,0.5)
    self.title_bg:addChild( self.title )
    self.view:addChild( self.title_bg )
end

function GetSkillDialog:init_with_args( item_id_table )
	for i=1,2 do
		if ( i <= #item_id_table ) then 
			self.slot_item_table[i].view:setIsVisible(true);
			self.slot_item_name[i]:setIsVisible(true);

			local item_id = item_id_table[i];
			local item_name = ItemModel:get_item_name_with_color( item_id )
			self.slot_item_table[i]:update( item_id ,1)
            self.slot_item_table[i]:set_color_frame(item_id, -2, -2, 68, 68);
			self.slot_item_name[i]:setText( item_name );
			-- -- 打开道具选中特效
			-- self.slot_item_table[i]:set_select_effect_state( true )
		else
			self.slot_item_table[i].view:setIsVisible(false);
			self.slot_item_name[i]:setIsVisible(false);
		end
	end
	-- 按钮不可点击
	self.get_skill_btn:setCurState(CLICK_STATE_DISABLE);
    -- self.select_effect_node:setPosition(-500,-500);
	-- 当前选中哪个技能
    self.curr_select_index = -1;
end  

--xiehande 获取顶级技能特效
function GetSkillDialog:play_skill_effect(  )
    -- body
    LuaEffectManager:play_view_effect(10014,214,281,self.view,false,999 )
end