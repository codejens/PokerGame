-- PetRongHePage.lua
-- create by hcl on 2012-12-10
-- 宠物融合

super_class.PetRongHePage()

-- 当前已经选中的宠物数量
local curr_selected_pet_num = 0;
local curr_selected_pet_index_table = {};
-- 要更新的控件
local update_view = {};
-- 要更新的值
local update_value = {};
-- 当前正在拖拽的宠物的索引
local curr_draping_index = -1;

local THIRD_PET_POS_X = 475  
local THIRD_PET_POS_Y = 270

function PetRongHePage:__init()

    -- local node_x = 170;
    self.view = CCBasePanel:panelWithFile(250,8,630,508,nil,0,0);
    local view_size = self.view:getSize()
    -- local function panel_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then
    --         return false;
    --     end
    -- end
    -- self.view:registerScriptHandler(panel_fun);

    local left_bg = ZImage:create( self.view, UILH_COMMON.bottom_bg, 0, 0, 326, 505, nil, 600, 600 )
    local left_bg_size = left_bg:getSize()
    local left_bg_line = ZImage:create( left_bg, UILH_COMMON.split_line, 8, left_bg_size.height / 2, left_bg_size.width - 16, 2 )
    local right_bg = ZImage:create( self.view, UILH_COMMON.bottom_bg, 325, 0, 305, 505, nil, 600, 600 )
    local right_bg_size = right_bg:getSize()

    local right_title_bg = ZImage:create( right_bg, UILH_NORMAL.title_bg4, 0, right_bg_size.height - 45, right_bg_size.width, 40, nil, 500, 500 )
    local right_title_bg_size = right_title_bg:getSize()
    local right_title_text = ZLabel:create( right_title_bg, Lang.pet.ronghe_page[10], 0, 0 )
    local right_title_text_size = right_title_text:getSize()
    right_title_text:setPosition( ( right_title_bg_size.width - right_title_text_size.width ) / 2, ( right_title_bg_size.height - right_title_text_size.height ) / 2 + 3 )
    local right_bg_line = ZImage:create( right_bg, UILH_COMMON.split_line, 8, right_bg_size.height / 2 - 35, right_bg_size.width - 16, 2 )

    ZImage:create( self.view, UILH_COMMON.right_arrows, view_size.width / 2 - 10, view_size.height / 2 - 18, -1, -1 )

    ZImage:create( left_bg, UILH_PET.tab_five_pet_1, 10, left_bg_size.height - 132 )

    ZImage:create( left_bg, UILH_PET.tab_five_pet_2, 10, left_bg_size.height / 2 - 127 )
    -- -- 九宫格背景
    -- local left_bg1 = ZImage:create(self.view, UILH_COMMON.bg_grid, 0, 255, 324, 254, nil, 600, 600);
    -- -- left_bg1.view:setScale(0.67);
    -- local left_bg2 = ZImage:create(self.view, UILH_COMMON.bg_grid, 0, 0, 324, 258, nil, 600, 600);
    -- -- left_bg2.view:setScale(0.67);
    -- local left_bg3 = ZImage:create(self.view, UILH_COMMON.bg_grid,330, 0, 286, 508, nil, 600, 600);
    -- ZImage:create(self.view,UI_PET_010,320 ,0,331,229+25,0,500,500);
    -- left_bg3.view:setScale(0.8);
    -- ZImage:create(self.view,"",278,55,294 ,109,0,500,500);
    
    local pet_ronghe_bg1 = CCZXImage:imageWithFile( 5, -5, -1, -1, UILH_PET.pet_ronghe_bg )
    left_bg:addChild(pet_ronghe_bg1)
    local pet_ronghe_bg2 = CCZXImage:imageWithFile( 5, 241, -1, -1, UILH_PET.pet_ronghe_bg )
    left_bg:addChild(pet_ronghe_bg2)
    local pet_ronghe_bg3 = CCZXImage:imageWithFile( -10, 207, -1, -1, UILH_PET.pet_ronghe_bg )
    right_bg:addChild(pet_ronghe_bg3)

    -- 创建宠物融合栏右上角的宠物名字 
    self.pet_name_table = {};
    self.pet_name_table[1] = ZLabel:create( left_bg.view, "", left_bg_size.width / 2, left_bg_size.height - 30, 16, 1 );
    self.pet_name_table[1].view:setAnchorPoint( CCPointMake(0.5, 0) )
    self.pet_name_table[2] = ZLabel:create( left_bg.view, "", left_bg_size.width / 2, left_bg_size.height / 2 - 30, 16, 1 );
    self.pet_name_table[2].view:setAnchorPoint( CCPointMake(0.5, 0) )
    self.pet_name_table[3] = ZLabel:create( right_bg.view, "", right_bg_size.width / 2, right_bg_size.height - 65, 16, 1 );
    self.pet_name_table[3].view:setAnchorPoint( CCPointMake(0.5, 0) )
    for i=1,3 do
        self.pet_name_table[i].view:setIsVisible(false);
    end

    -- 记录坐标的slotPet
    self.slotPet_table = {};
    -- 记录宠物动画表
    self.pet_animation_table = {};
    self.slotPet_table[1] = self:create_selotMove_item(self.view, 0,238+25,311,229+25, 1 );
    self.slotPet_table[2] = self:create_selotMove_item(self.view, 0,0,311,229+25, 2 );


    -- ZCCSprite:create(self.view,UIResourcePath.FileLocate.pet .. "pet_jiantou.png",270+54,191+56);
    -- ZCCSprite:create(left_bg1.view,UIResourcePath.FileLocate.pet .. "pet_zhuchong.png",30,180);
    -- ZCCSprite:create(left_bg2.view,UIResourcePath.FileLocate.pet .. "pet_fuchong.png",30,180);

    -- ZTextImage:create(self.view,LangGameString[1703],UIResourcePath.FileLocate.common .. "title_bg_01_s.png",14,288.5,144); -- [1703]="#cffff00融合预览"
    -- 融合预览
    -- ZCCSprite:create(self.view,UIResourcePath.FileLocate.pet.."t_rhyl.png",488,470 );

    local start_x = 325
    local start_y = 180+25;
    local font_size = 14

    -- ZImageImage:create(self.view,"ui/pet/rhyl.png",UI_PET_016,start_x-5,start_y+21);

    local ccdialogEx1 = ZDialog:create(self.view,"",start_x+10,start_y+15,100,0,font_size) -- [1704]="#c66ff66攻击资质:#h3#防御资质:#h3#灵巧资质:#h3#身法资质:"
    ccdialogEx1:setAnchorPoint(0, 1)
    ccdialogEx1.view:setLineEmptySpace(5)
    ccdialogEx1:setText( Lang.pet.ronghe_page[4] .. Lang.pet.ronghe_page[3] )

    update_view[1] = ZDialog:create(self.view,"",start_x+90,start_y-52 ,65,0,font_size)
    update_view[1]:setAnchorPoint(0, 1)
    update_view[1].view:setLineEmptySpace(5)
    update_view[1]:setText(Lang.pet.ronghe_page[3])

    update_view[2] = ZDialog:create(self.view,"",start_x+160,start_y -52,85,0,font_size)
    update_view[2]:setAnchorPoint(0, 1)
    update_view[2].view:setLineEmptySpace(5)
    update_view[2]:setText('')

    -- local ccdialogEx2 = ZDialog:create(self.view,Lang.pet.ronghe_page[4],start_x+195,start_y+15,45,0,font_size)
    -- ccdialogEx2:setAnchorPoint(0, 1)
    -- ccdialogEx2.view:setLineEmptySpace(13)
    -- ccdialogEx2:setText(Lang.pet.ronghe_page[4])

    update_view[3] = ZDialog:create(self.view,"",start_x+90,start_y+15,55,0,font_size)
    update_view[3]:setAnchorPoint(0, 1)
    update_view[3].view:setLineEmptySpace(5)
    update_view[3]:setText('')
    update_view[4] = ZDialog:create(self.view,"",start_x+160,start_y+15,55,0,font_size)
    update_view[4]:setAnchorPoint(0, 1)
    update_view[4].view:setLineEmptySpace(5)
    update_view[4]:setText('')

    self.up_arrow_img = {}
    for i = 1, 7 do 
        self.up_arrow_img[i] = ZImage:create( self.view, UILH_NORMAL.arrow_up, start_x + 145, start_y - 5 - ( i - 1 ) * 23, -1, -1)
        self.up_arrow_img[i].view:setIsVisible(false)
    end
    -- line
    -- local line = ZImage:create(self.view,"ui/common/jgt_line.png", 330,72+5,310,2)

    -- 融合按钮
    self.ronghe = ZTextButton:create( self.view, Lang.pet.ronghe_page[9], UILH_COMMON.btn4_nor, nil, 0, 0 )
    local ronghe_size = self.ronghe:getSize()
    self.ronghe:setPosition( 330 + ( right_bg_size.width - ronghe_size.width ) / 2, 5 )
    -- self.ronghe = ZImageButton:create(self.view,"ui/common/dan.png","ui/pet/pet_ronghe.png",nil,410,11);

    self:on_band();
    self:on_active();

 	return self.view;
end

function PetRongHePage:on_band()
    local function btn_merge_fun(eventType,x,y)
        -- print("btn_merge_fun..................")
        -- 首先判断是否选择了两个宠物    

        if ( curr_selected_pet_num == 2 ) then
            local function fun(  )
                    local pet_id1 = PetModel:get_pet_info().tab[curr_selected_pet_index_table[1]].tab_attr[1];
                    local pet_id2 = PetModel:get_pet_info().tab[curr_selected_pet_index_table[2]].tab_attr[1];
                    PetCC:req_merge( pet_id1 , pet_id2 );
            end
            if ( PetModel:get_pet_info().tab[curr_selected_pet_index_table[2]].pet_skill_num > 0 ) then
                NormalDialog:show(Lang.pet.ronghe_page[5],fun); -- [1707]="副宠身上带有技能，融合后技能会消失，确定融合吗？（可以使用兽魂印刻印技能到技能仓库）"
            else
                NormalDialog:show(Lang.pet.ronghe_page[6],fun); -- [1708]="融合会使副宠(包括技能)消失，确定融合吗?"
            end

        else
            GlobalFunc:create_screen_notic( Lang.pet.ronghe_page[7] ); -- [1709]="请选择两只宠物"
        end
    end
    self.ronghe:setTouchClickFun(btn_merge_fun);
end

function PetRongHePage:update(type , tab_arg)

	if ( type == 1 ) then
     
    elseif ( type == 2 ) then
        self:update_add_pet(tab_arg[1]);
    elseif ( type == 3 ) then
        -- 融合成功回调，将两个拖动提示语还原
        self:play_fade_in_and_fade_out( 1, 1 );
        self:play_fade_in_and_fade_out( 2, 1 );
        self:update_ronghe_success();
    elseif ( type == 4 ) then
    elseif ( type == 5 ) then
    elseif ( type == 6 ) then
    elseif ( type == 7 ) then
    end

end

function PetRongHePage:on_active()
    -- print("PetRongHePage:on_active()")
    -- 清除动画
    -- LuaEffectManager:stop_view_effect( 10012,self.view);
    -- LuaEffectManager:stop_view_effect( 10013,self.view);
    -- LuaEffectManager:stop_view_effect( 10012,self.slotPet_table[1].view);
    -- LuaEffectManager:stop_view_effect( 10013,self.slotPet_table[1].view);
    -- LuaEffectManager:stop_view_effect( 10012,self.slotPet_table[2].view);
    -- LuaEffectManager:stop_view_effect( 10013,self.slotPet_table[2].view);

    -- local effect_bg1 = LuaEffectManager:play_view_effect( 10012,0 ,0,self.view,true ,0);
    -- local effect_1   = LuaEffectManager:play_view_effect( 10013,440 ,175,self.view,true ,2);
    -- effect_bg1:setPosition(493,410)
    -- effect_1:setPosition(493,410)

    -- local effect_bg2 = LuaEffectManager:play_view_effect( 10012,116 ,42,self.slotPet_table[1].view,true ,0);
    -- local effect_2   =LuaEffectManager:play_view_effect( 10013,116 ,42,self.slotPet_table[1].view,true ,2);
    -- effect_bg2:setPosition(161.5,148)
    -- effect_2:setPosition(161.5,148)

    -- local effect_bg3 = LuaEffectManager:play_view_effect( 10012,116 ,42,self.slotPet_table[2].view,true ,0);
    -- local effect_3   =LuaEffectManager:play_view_effect( 10013,116 ,42,self.slotPet_table[2].view,true ,2);
    -- effect_bg3:setPosition(161.5,148)
    -- effect_3:setPosition(161.5,148)

    self:update_ronghe_success()

    -- 播放淡入淡出特效
    -- if ( self.tips1_spr and self.tips2_spr ) then
        self:play_fade_in_and_fade_out( 1, 1 );
        self:play_fade_in_and_fade_out( 2, 1 );
    -- end
end

-- 当有一只宠物拖动到融合栏时更新显示的数据
function PetRongHePage:update_add_pet(index)

    if ( curr_selected_pet_index_table[index] == curr_draping_index) then
        -- print("同一只宠物，return")
        return;
    end

    if ( curr_selected_pet_index_table[index] == nil) then
        -- 增加一
        curr_selected_pet_num = curr_selected_pet_num + 1
    end
    curr_selected_pet_index_table[index] = curr_draping_index;
    -- 如果只有一只
    if ( curr_selected_pet_num == 1 ) then
        local curr_pet_info = PetModel:get_pet_info().tab[curr_draping_index];
        local str = curr_pet_info.tab_attr[29].."#r".. curr_pet_info.tab_attr[30].."#r".. curr_pet_info.tab_attr[31].."#r".. curr_pet_info.tab_attr[32];
        -- update_view[1]:setText("");
        -- update_view[1]:setLineEmptySpace(3)
        update_view[1]:setText("#cffffff"..str);
        str = curr_pet_info.tab_attr[6].."#r".. curr_pet_info.curr_wx.."#r".. curr_pet_info.curr_grow;
        -- update_view[3]:setText("");
        -- update_view[3]:setLineEmptySpace(3)
        update_view[3]:setText("#cffffff"..str);
    end

    if ( curr_selected_pet_num == 2 ) then

        local main_pet_info = PetModel:get_pet_info().tab[curr_selected_pet_index_table[1]];
        local str = main_pet_info.tab_attr[29].."#r".. main_pet_info.tab_attr[30].."#r".. main_pet_info.tab_attr[31].."#r".. main_pet_info.tab_attr[32];
        -- update_view[1]:setText("");
        -- update_view[1]:setLineEmptySpace(3)
        update_view[1]:setText("#cffffff"..str);
        local second_pet_info = PetModel:get_pet_info().tab[curr_selected_pet_index_table[2]];
        str = "";
        for i=1,4 do
            if ( i ~= 4) then
                str = str .."".. self:get_pet_add_attr( main_pet_info.tab_attr[28 + i] , second_pet_info.tab_attr[28 + i] ) .. "#r" .. LH_COLOR[6]--#c66ff66";
            else
                str = str .."".. self:get_pet_add_attr( main_pet_info.tab_attr[28 + i] , second_pet_info.tab_attr[28 + i] );
            end
        end
        -- update_view[2]:setText("");
        -- update_view[2]:setLineEmptySpace(3)
        update_view[2]:setText(LH_COLOR[6] ..str);

        str = main_pet_info.tab_attr[6].."#r".. main_pet_info.curr_wx.."#r".. main_pet_info.curr_grow;
        -- update_view[3]:setText("");
        -- update_view[3]:setLineEmptySpace(3)
        update_view[3]:setText("#cffffff"..str);

        str = "".. self:get_pet_add_attr( main_pet_info.tab_attr[6 ] , second_pet_info.tab_attr[6 ] ) .. "#r" .. LH_COLOR[6] .. "".. self:get_pet_add_attr( main_pet_info.curr_wx , second_pet_info.curr_wx ) .. "#r" .. LH_COLOR[6] .. "".. self:get_pet_add_attr( main_pet_info.curr_grow , second_pet_info.curr_grow ) ;
      
        -- update_view[4]:setText("");
        -- update_view[4]:setLineEmptySpace(3)
        update_view[4]:setText(LH_COLOR[6]..str);

        -- 要更新的数据
        for i=1,4 do
            update_value[i] = math.max(main_pet_info.tab_attr[28 + i],second_pet_info.tab_attr[28 + i]);
        end
        update_value[5] = math.max(main_pet_info.tab_attr[6],second_pet_info.tab_attr[6]);
        update_value[6] = math.max(main_pet_info.curr_wx,second_pet_info.curr_wx);
        update_value[7] = math.max(main_pet_info.curr_grow,second_pet_info.curr_grow);
        
        -- 设置第三只宠物
        local pet_file = string.format("scene/monster/%d",main_pet_info.tab_attr[2]);
        local action = {0,0,9,0.2};
        self.pet_animation_table[3] =  MUtils:create_animation( THIRD_PET_POS_X  , THIRD_PET_POS_Y ,pet_file,action )
        self.view:addChild( self.pet_animation_table[3] );
        
        local pet_name_color = MUtils:get_color_by_zz( {update_value[1],update_value[2],update_value[3],update_value[4]} )
        -- 设置名字
        self.pet_name_table[3]:setText( pet_name_color..self.pet_name_table[1]:getText() ); 
        self.pet_name_table[3].view:setIsVisible(true);
        for i = 1, 7 do
            self.up_arrow_img[i].view:setIsVisible(true)
        end       
    end
end

-- 返回第二只宠比第一只宠属性的差值，大于等于0
function PetRongHePage:get_pet_add_attr(first_attr,second_attr)

    local num = second_attr - first_attr;
    if ( num <= 0 ) then
        num = 0;
    end

    return num;
end

function PetRongHePage:update_ronghe_success()

    -- 更新出战宠物的位置
    PetWin:change_fight_img_pos(  );

    curr_selected_pet_index_table = nil;
    curr_selected_pet_index_table = {};
    curr_selected_pet_num = 0;

    update_view[1]:setText("");
    update_view[2]:setText("");
    update_view[3]:setText("");
    update_view[4]:setText("");

    if ( self.pet_animation_table ) then
        for i=1,3 do
            self.pet_name_table[i]:setText("");
            self.pet_name_table[i].view:setIsVisible(false);
            if ( self.pet_animation_table[i] ) then 
                self.pet_animation_table[i]:stopAllActions();
                self.pet_animation_table[i]:removeFromParentAndCleanup(true);
                self.pet_animation_table[i] = nil;
            end
        end
    end

    for i = 1, 7 do
        self.up_arrow_img[i].view:setIsVisible(false)
    end

end

function PetRongHePage:set_curr_draging_index ( index ) 
    curr_draping_index = index;
end

function PetRongHePage:create_selotMove_item(parent, x, y, width, height, index )
        local testItem = SlotPet(width,height);
        testItem:setPosition (x,y);   

        local function drag_in( source_item )
            -- 如果有 清除拖动条
            Instruction:destroy_drag_out_animation()
            -- 拖拽进来后取消原来的动画，播放双击取消的提示动画
            self:play_fade_in_and_fade_out( index, 2 );
            -- 设置宠物动画
            -- print("curr_draping_index,index",curr_draping_index,index,"#curr_selected_pet_index_table = ",#curr_selected_pet_index_table);
            -- 判断能否拖进去
            for i=1,2 do
                -- 判断当前拖进去的这一只和另外一只是否相同
                if ( curr_selected_pet_index_table[i] and curr_draping_index == curr_selected_pet_index_table[i] ) then
                    if ( index == i ) then
                        -- 同一只宠物
                        GlobalFunc:create_screen_notic( Lang.pet.ronghe_page[8] ); -- [1710]="同一只宠物"
                        return ;
                    else
                        -- 清除掉原来的宠物
                        self:delete_pet_by_index( i );
                    end
                end
            end

             -- 如果这里之前没有有动画，就创建动画
            if ( self.pet_animation_table[index] == nil ) then

                local pet_file = string.format("scene/monster/%d",source_item.obj_data.tab_attr[2]);
                local action = {0,0,9,0.2};
                self.pet_animation_table[index] =  MUtils:create_animation(x+width/2+10,y+height/2-75,pet_file,action )
                self.view:addChild( self.pet_animation_table[index] );
            -- 如果这里之前有动画，就删除掉之前的动画，然后重新创建
            else
                self:delete_pet_by_index( index );
                local pet_file = string.format("scene/monster/%d",source_item.obj_data.tab_attr[2]);
                local action = {0,0,9,0.2};
                self.pet_animation_table[index] =  MUtils:create_animation(x+width/2+10,y+height/2-75,pet_file,action )
                self.view:addChild( self.pet_animation_table[index] );
            end
            local pet_name = source_item.obj_data.pet_name;
            -- 设置名字
            self.pet_name_table[index]:setText(pet_name)
            self.pet_name_table[index].view:setIsVisible(true);

            self:update_add_pet(index);
            -- if ( XSZYManager:get_state() == XSZYConfig.CWRH_ZY ) then
            --     -- 新手指引代码
            --     XSZYManager:destroy_drag_out_animation();
            -- end
        end

        local function cancel_fun()
            self:delete_pet_by_index( index )
            self:play_fade_in_and_fade_out( index, 1 );
        end

        testItem:set_double_click_event( cancel_fun );
        testItem.view:setEnableDoubleClick(true)
        testItem:set_drag_in_event(drag_in);
        parent:addChild(testItem.view);
        return testItem;
end

-- 判断融合的怪物中是否有正在出战的宠物
function PetRongHePage:is_merge_fighting_pet()
    local curr_pet_id = PetModel:get_current_pet_id();
    for i=1,#curr_selected_pet_index_table do
        local index = curr_selected_pet_index_table[i];
        local curr_pet_info = PetModel:get_pet_info().tab[index];
        if ( curr_pet_info.tab_attr[1] == curr_pet_id ) then
            return true;
        end
    end
    return false;
end

-- 清除某一只宠物的数据
function PetRongHePage:delete_pet_by_index( index )
    -- print("删除第"..index.."只宠物");
    local pet_index = curr_selected_pet_index_table[index];
    if ( pet_index ) then
        for i = 1, 7 do
            self.up_arrow_img[i].view:setIsVisible(false)
        end
        if ( curr_selected_pet_num == 2 ) then
            self:clear_ronghe_info(index);
        else
            update_view[1]:setText("");
            update_view[3]:setText("");
        end
        -- 删除宠物动画
        self.pet_animation_table[index]:stopAllActions();
        self.pet_animation_table[index]:removeFromParentAndCleanup(true);
        self.pet_animation_table[index] = nil;

        curr_selected_pet_num = curr_selected_pet_num - 1;
        curr_selected_pet_index_table[index] = nil;

        -- 设置名字为空
        self.pet_name_table[index]:setText("");
        self.pet_name_table[index].view:setIsVisible(false);

    end
end

-- 清除融合数据
function PetRongHePage:clear_ronghe_info( index )
    self.pet_animation_table[3]:stopAllActions();
    self.pet_animation_table[3]:removeFromParentAndCleanup(true);
    self.pet_animation_table[3] = nil;

    -- 设置名字为空
    self.pet_name_table[3]:setText("");
    self.pet_name_table[3].view:setIsVisible(false);
    update_view[2]:setText("");
    update_view[4]:setText("");
    local other_index = 0;
    if ( index == 1 ) then
        other_index = 2;
    else
        other_index = 1;
    end

    local curr_pet_info = PetModel:get_pet_info().tab[other_index];
    local str = curr_pet_info.tab_attr[29].."#r".. curr_pet_info.tab_attr[30].."#r".. curr_pet_info.tab_attr[31].."#r".. curr_pet_info.tab_attr[32];
    update_view[1]:setText(LH_COLOR[6]..str);
    str = curr_pet_info.tab_attr[6].."#r".. curr_pet_info.curr_wx.."#r".. curr_pet_info.curr_grow;
    update_view[3]:setText(LH_COLOR[6]..str);
end

function PetRongHePage:play_fade_in_and_fade_out( view_index, effect_index )
    local path = "ui/lh_pet/pet_tips"..effect_index..".png";
    if ( view_index == 1 ) then
        if ( self.tips1_spr ) then
            self.tips1_spr:removeFromParentAndCleanup(true);
        end
        self.tips1_spr = MUtils:create_sprite(self.view,path,166,270,100);
        LuaEffectManager:play_fade_in_fade_out_effect( self.tips1_spr )
        
    elseif ( view_index == 2 ) then
        if ( self.tips2_spr ) then
            self.tips2_spr:removeFromParentAndCleanup(true);
        end
        self.tips2_spr = MUtils:create_sprite(self.view,path,166,25,100);
        LuaEffectManager:play_fade_in_fade_out_effect( self.tips2_spr )
    end
end

-- xiehande 宠物融合特效
function PetRongHePage:play_ronghe_success_effect(  )
    -- body
    LuaEffectManager:play_view_effect( 10014,300,280,self.view,false,999 )
end