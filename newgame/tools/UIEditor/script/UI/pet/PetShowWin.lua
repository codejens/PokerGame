-- PetShowWin
-- 查看宠物界面
-- create by hcl on 2013/7/1

super_class.PetShowWin(NormalStyleWindow)

local tab_str = {LangGameString[1711],LangGameString[1712],LangGameString[1713],LangGameString[1714],LangGameString[1715],LangGameString[1716],LangGameString[1699]} -- [1711]="悟      性：" -- [1712]="成      长：" -- [1713]="攻击资质：" -- [1714]="防御资质：" -- [1715]="灵巧资质：" -- [1716]="身法资质：" -- [1699]="#c66ff66携带技能:"

function PetShowWin:show( pet_struct )
    local win = UIManager:find_visible_window("pet_show_win");
    if ( win ) then
        UIManager:destroy_window("pet_show_win");
    end
    win = UIManager:show_window("pet_show_win")
    if ( win ) then

      win:init_with_arg( pet_struct );
    end
end

local tab_str = Lang.pet.show_win[1]
function PetShowWin:__init(  )

end


function PetShowWin:init_with_arg( pet_struct )

    -- 所有切页按钮
    local win_size = self.view:getSize();
    local but_beg_x  = 23            -- 按钮起始x坐标
    local but_beg_y  = win_size.height - 60 - 47            -- 按钮起始y坐标
    local but_int_x  = 107           -- 按钮x坐标间隔
    local btn_with   = 108 
    local btn_height = 45

    self.text_title = {Lang.pet.show_win[2],}
    self.label_title = {}
    self.radio_btn_tab   = {}
    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(but_beg_x ,but_beg_y , btn_with*1, btn_height,nil)
    self.view:addChild(self.raido_btn_group)

    -- 查看伙伴按钮
    self.radio_btn_tab[1] = self:create_a_button(self.raido_btn_group, 0 + but_int_x*0, 0, btn_with, btn_height, UILH_COMMON.tab_gray, UILH_COMMON.tab_light, 1)

    -- 目前只有一个按钮，就先不写change_page这些方法了
    self.raido_btn_group:selectItem(0)
    self.label_title[1]:setText(LH_COLOR[15]..self.text_title[1])

    -- 背景按钮
    local bg = CCZXImage:imageWithFile(8,8,417,521,UILH_COMMON.normal_bg_v2,500,500)
    self.view:addChild(bg)

    -- 黑色背景
    local bg_in = CCZXImage:imageWithFile(12, 12, 392, 495,UILH_COMMON.bottom_bg,500,500)
    bg:addChild(bg_in)

    -- 宠物背景
    local pet_ronghe_bg = CCZXImage:imageWithFile(51,200,-1,-1,UILH_PET.pet_ronghe_bg)
    self.view:addChild(pet_ronghe_bg)

    -- 战斗力标题
    ZImage:create(bg, UILH_ROLE.text_zhandouli, 131, 451)

    -- 战斗力数字
    local function get_num_ima( one_num )
        return string.format("ui/lh_other/number1_%d.png",one_num);
    end
    self.fight_value_label = ImageNumberEx:create(0,get_num_ima,15)
    bg:addChild( self.fight_value_label.view )
    self.fight_value_label.view:setPosition(CCPointMake(221,462))
    self.fight_value_label:set_number(pet_struct.tab_attr[33])

    local _tab_slot_pet_skill = {};
    local pet_id = pet_struct.tab_attr[1];
    local fight_pet_struct = PetModel:get_current_pet_info(  )
    -- 8个技能槽
    for i=1,8 do
        _tab_slot_pet_skill[i] = MUtils:create_pet_slot_skill2(self.view,UIPIC_ITEMSLOT,43+math.floor((i-1)/4)*300,442-(i-1)%4*85,64,64)
    end

    -- 子标题
    local title_panel = CCBasePanel:panelWithFile( 6, 121, 408, 34, UILH_NORMAL.title_bg4, 500, 500 )
    bg:addChild(title_panel)
    MUtils:create_zxfont(title_panel,Lang.pet.show_win[3],408/2,(31-16)*0.5,2,17);

    -- 宠物名
    ZLabel:create(bg,pet_struct.pet_name,417/2,483,18,2); 
    for i=1,6 do
        local lab = ZLabel:create(self.view,tab_str[i].. pet_struct.curr_grow,
            30 + (i-1)%2*220 ,102-math.floor((i-1)/2)*35,16,1);
        if i < 3 then
            local up_or_down = nil;
            if i == 1 then
                lab:setText(tab_str[i].. pet_struct.curr_wx);
                if fight_pet_struct then
                    if pet_struct.curr_wx > fight_pet_struct.curr_wx then
                        up_or_down = true;
                    elseif pet_struct.curr_wx < fight_pet_struct.curr_wx then
                        up_or_down = false;
                    end
                end
            else
                lab:setText(tab_str[i].. pet_struct.curr_grow);
                if fight_pet_struct then
                    if pet_struct.curr_grow > fight_pet_struct.curr_grow then
                        up_or_down = true;
                    elseif pet_struct.curr_grow < fight_pet_struct.curr_grow then
                        up_or_down = false;
                    end
                end
            end
            if up_or_down then
                ZCCSprite:create(lab,UILH_OTHER.up_arrow,136,6);
            elseif up_or_down == false then
                ZCCSprite:create(lab,UILH_OTHER.down_arrow,136,6);
            end
        else
            local zz = pet_struct.tab_attr[26+i];
            local color = MUtils:get_zz_color( zz )
            lab:setText(color..tab_str[i].. zz);
            if ( fight_pet_struct and zz > fight_pet_struct.tab_attr[26+i] ) then
                ZCCSprite:create(lab,UILH_OTHER.up_arrow,136,6);
            elseif ( fight_pet_struct and zz < fight_pet_struct.tab_attr[26+i] ) then
                ZCCSprite:create(lab,UILH_OTHER.down_arrow,136,6);
            end
        end 
    end 

    if ( pet_struct.pet_skill_num > 0 )then
        for i=1,pet_struct.pet_skill_num do
            local skill_struct = pet_struct.tab_pet_skill_info[i];
            _tab_slot_pet_skill[i]:set_pet_skill_icon( skill_struct.skill_id,skill_struct.skill_lv ) 
            local function f1( _self,eventType, args, msgi )
                local click_pos = Utils:Split(args, ":")
                -- print(click_pos[1],click_pos[2])
                local world_pos = _tab_slot_pet_skill[i].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
                TipsModel:show_pet_skill_tip( world_pos.x, world_pos.y,skill_struct );
            end
            _tab_slot_pet_skill[i]:set_click_event( f1 )
        end
    end

    if ( self.spr == nil ) then
        local pet_file = string.format("scene/monster/%d",pet_struct.tab_attr[2]);
        local action = {0,0,9,0.2};
        self.spr = MUtils:create_animation(218 ,280,pet_file,action )
        self.view:addChild( self.spr,1 );
    end

    -- LuaEffectManager:stop_view_effect( 10012,self.view);
    -- LuaEffectManager:stop_view_effect( 10013,self.view);
    -- -- -- 播放魔法阵特效
    -- local effect_bg=LuaEffectManager:play_view_effect( 10012,116+80 ,110+80,self.view,true ,0);
    -- local effect  =LuaEffectManager:play_view_effect( 10013,116+80 ,110+80,self.view,true ,0);
    -- effect_bg:setPosition(220,415)
    -- effect:setPosition(220,415)


end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，显示文字图片，文字图片的长宽，序列号（用于触发事件判断调用的方法）
function PetShowWin:create_a_button(panel, pos_x, pos_y, size_w, size_h, image_n, image_s ,index)
     local radio_button = CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    radio_button:addTexWithFile(CLICK_STATE_DOWN,image_s)
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then 
            return true
        elseif eventType == TOUCH_CLICK then
            -- self:change_page( index )
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end
    radio_button:registerScriptHandler(but_1_fun)
    panel:addGroup(radio_button)

    --按钮显示的名称
    -- local word_x_temp = word_x+20 or 17
    -- local word_y_temp = word_y + 25 or 29 + 10+40
    -- print("  ::: ", word_x_temp, word_y_temp)
    -- local name_image = CCZXImage:imageWithFile( word_x_temp, word_y_temp, but_name_siz_w, but_name_siz_h, but_name ); 
    -- radio_button:addChild( name_image )
    -- self.but_name_t[index] = MountsWinNew:create_but_name( but_name, but_name_s, size_w/2, size_h/2 )
    -- radio_button:addChild(self.but_name_t[index].view)
    self.label_title[index] = MUtils:create_zxfont(radio_button,LH_COLOR[2]..self.text_title[index],size_w/2,10,2,17);
    return radio_button;
end