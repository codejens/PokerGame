require "UI/component/Window"
super_class.UserBuffWin(Window)

-- 左面板
local  left_panel = nil
-- 右面板
local  right_panel = nil

local buffer_per_height = 53

function UserBuffWin:__init( window_name, texture_name,is_grid,width,height)

    -- print("UserBuffWin:__init( window_name, texture_name,is_grid,width,height)",width,height)

    -- 右面板buff信息
    --背景图
    panel=self.view

    local spr_bg = CCZXImage:imageWithFile( 0, 0, 457,638, UILH_COMMON.bottom_bg,500,500);
    panel:addChild( spr_bg );

    local bg_1 = CCBasePanel:panelWithFile(30, 20, 397, 531+40,UILH_COMMON.bg_01, 500, 500)
    panel:addChild(bg_1)

    right_panel = CCBasePanel:panelWithFile(41, 31, 397-22, 531-22+30,UILH_COMMON.bg_10, 500, 500)
    panel:addChild(right_panel)

    -- 药包信息标题
    local medechine_title = CCBasePanel:panelWithFile( 0, 476+33, 120,30, UIPIC_UserSkillWin_0007, 500, 500);  --方形区域
    right_panel:addChild( medechine_title )
    local title_1 = Image:create( nil, 25,4, -1, -1, UIPIC_UserBuffWin_0001, 500, 500 )
    medechine_title:addChild(title_1.view)

    -- Buff信息标题
    local buff_title = CCBasePanel:panelWithFile( 0, 465+50-30-180, 120,30, UIPIC_UserSkillWin_0007, 500, 500);  --方形区域
    right_panel:addChild( buff_title )
    local title_2 = Image:create( nil, 25,4, -1, -1, UIPIC_UserBuffWin_0002, 500, 500 )
    buff_title:addChild(title_2.view)

    -- 药包icon
    local yaobao_icon = MUtils:create_zximg(right_panel,UIPIC_UserBuffWin_0006,22,380+25,72,72)
    MUtils:create_zximg(yaobao_icon,UIPIC_UserBuffWin_0005,3,3,-1,-1)
    

    --6条分割线
    local fengge_bg_x = 114
    local fengge_bg_y = 442+10
    for i=1,3 do
    	local fengge_bg1 = CCZXImage:imageWithFile(fengge_bg_x,fengge_bg_y-50*(i-1),255,2,UIPIC_UserSkillWin_00012)
    	right_panel:addChild(fengge_bg1)
    end

    local p_x = 264
    local p_y = 475

    local  avator_life_label1 = UILabel:create_label_1('#ce519cb角色生命药包:', CCSize(300,20), p_x , p_y, 18,  CCTextAlignmentLeft, 255, 255, 100)
    right_panel:addChild( avator_life_label1 )

    local avator_magic_label2 = UILabel:create_label_1('#c0096ff角色耐力药包:', CCSize(300,20), p_x , p_y-50, 18,  CCTextAlignmentLeft, 255, 255, 100)
    right_panel:addChild( avator_magic_label2 )

    local pet_life_label3 = UILabel:create_label_1('#c00D257宠物生命药包:', CCSize(300,20), p_x , p_y-100, 18,  CCTextAlignmentLeft, 255, 255, 100)
    right_panel:addChild( pet_life_label3 )

    self.user_left_hp = MUtils:create_zxfont(right_panel,"#cfff0000",250,450+15,1,18);   
    self.user_left_mp = MUtils:create_zxfont(right_panel,"#c0096ff0",250,400+15,1,18);
    self.pet_left_hp = MUtils:create_zxfont(right_panel,"#cffffff0",250,350+15,1,18);

    -- 第一次打开的时候添加所有的buff
    self:create_scroll(  )

end

function UserBuffWin:create( texture_name )
    -- local bgPanel = UserAttrWin( 10, 46, 389, 429, texture_name );
    return UserAttrWin( texture_name, 10, 46, 389, 429);
end

function UserBuffWin:destroy()
    Window.destroy(self)
    -- for key, page in pairs(self.all_page_t) do
    --     page:destroy()
    -- end
end

function UserBuffWin:create_scroll(  )
    -- 更新玩家的buff数据
    self:set_player_buff_table(  )
    self.timer_lab_table = {};
    self.buff_view_table = {};

    local _scroll_info = { x = 22 , y = 10 , width = 330, height = 300-10, maxnum = 1, stype = TYPE_HORIZONTAL }
    self.scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
    --self.scroll:setScrollLump( UIResourcePath.FileLocate.common .. "progress_green.png", 10, 20, 10 )
    right_panel:addChild(self.scroll);

    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then
            -- local temparg = Utils:Split(args,":")
            -- local row = temparg[1] +1             -- 行
            -- 每行的背景panel
            self.scroll_item_panel = CCBasePanel:panelWithFile(0,0 ,330+80,10,"", 600, 600);
            self.scroll:addItem(self.scroll_item_panel);
            self.scroll:refresh();
            return false
        end
    end
    self.scroll:registerScriptHandler(scrollfun);
    self.scroll:refresh()
    self.scroll_item_panel:setAnchorPoint( 0, 1 )
    local buff_info_table_size = #self.buff_info_table
    if buff_info_table_size > 0 then
        self.scroll_item_panel:setSize(330, buff_info_table_size * buffer_per_height )
    end
    for i=1, buff_info_table_size do
        self:create_scroll_item(self.scroll_item_panel,i);
    end
end

function UserBuffWin:create_scroll_item(parent, index )
    local temp_panel_size = self.scroll_item_panel:getSize()
    local len = #self.buff_view_table;
    -- buff面板
    local buff_node = {}
    local buff_node_bg = CCBasePanel:panelWithFile(10, 0, 420, buffer_per_height, "", 600, 600 )--CCNode:node();
    buff_node.view = buff_node_bg

    self.buff_view_table[len+1] = buff_node;
    parent:addChild( buff_node.view );

    buff_node.view:setPosition( 0, temp_panel_size.height - ( index ) * buffer_per_height )
    --buff_node:setPosition( 0, 220-(len+1)*53 );
    local buff_struct = self.buff_info_table[index];
    -- buff背景
    local item_bg = MUtils:create_sprite( buff_node.view,UIPIC_ITEMSLOT,30,26.5 )
    item_bg:setScaleX(40/62);
    item_bg:setScaleY(40/62);
    -- buff图标
    local icon_path = string.format("icon/buff/%05d.jd",buff_struct.buff_type);
    --local icon_path = string.format("icon/buff/%05d.jpg",buff_struct.buff_type);
    local icon = MUtils:create_sprite(buff_node.view,icon_path,30,26.5);
    icon:setScaleX(1.4);
    icon:setScaleY(1.4);
    local str = self:get_desc( buff_struct.buff_type, buff_struct.buff_value ,buff_struct.buff_name)
    -- buff描述
    MUtils:create_zxfont(buff_node.view,str,65,28,15);
    -- 分隔线
    --MUtils:create_zximg(buff_node,UIResourcePath.FileLocate.common .. "coner2.png", 0,0,306,2,500,500);
    local tt3 = Image:create( nil, 0, 0, 330, 2, UIPIC_UserSkillWin_00012 )
    buff_node.view:addChild(tt3.view)
    -- 计时器
    buff_node.timer_lab = TimerLabel:create_label(buff_node.view, 65, 5, 15, buff_struct.alive_time-1, "#c0edc09", nil,nil);

end

function UserBuffWin:add_buff( buff )

    for k,v in pairs(self.buff_info_table) do
        if v.buff_type == buff.buff_type and v.buff_group == buff.buff_group then
            self:remove_buff( v.buff_type,v.buff_group );
            -- print("UserBuffPanel:add_buff( buff )同一个buff删除掉旧的",v.buff_type,v.buff_group)
            break;
        end
    end

    self.buff_info_table[#self.buff_info_table+1] = buff;
    local buff_info_table_size = #self.buff_info_table
    self.scroll_item_panel:setSize( 330, buff_info_table_size * buffer_per_height )
    self:create_scroll_item(self.scroll_item_panel,#self.buff_info_table);
    self:reinit_per_buff_pos()
    -- local size = self.scroll_item_panel:getSize();
    -- self.scroll_item_panel:setSize(size.width,size.height+53);
end

function UserBuffWin:remove_buff( buff_type,buff_group )
    for i=1,#self.buff_info_table do
        if ( self.buff_info_table[i].buff_type == buff_type and ( buff_group==nil or self.buff_info_table[i].buff_group == buff_group) )  then
            local buff_node = table.remove(self.buff_view_table,i);
            if buff_node.timer_lab then
                buff_node.timer_lab:destroy();
                buff_node.timer_lab = nil
            end
            buff_node.view:removeFromParentAndCleanup( true );
            -- 删除一个后，后面的buff要往上移
            for j=i,#self.buff_view_table do
                local _buff_node = self.buff_view_table[j];
                if(_buff_node.view) then
                    local pos_x,pos_y = _buff_node.view:getPosition();
                    _buff_node.view:setPosition(pos_x,pos_y+53);
                end
            end
            table.remove(self.buff_info_table,i);
            break;
        end
    end
    local buff_info_table_size = #self.buff_info_table
    self.scroll_item_panel:setSize( 330, buff_info_table_size * buffer_per_height )
    self:reinit_per_buff_pos()
end

function UserBuffWin:getIncText( buff_type, value)

    if ( buff_type == 15 or buff_type == 16 or buff_type == 21 or buff_type == 22 or buff_type == 31 or buff_type == 32 or buff_type == 27 or buff_type == 28) then
        if ( value < 0 ) then
            return Lang.role_info.user_buff_panel.min
        else
            return Lang.role_info.user_buff_panel.add
        end
    else
        if ( value < 0 ) then
            return Lang.role_info.user_buff_panel.min
        else
            return Lang.role_info.user_buff_panel.add_e
        end
    end
end

function UserBuffWin:get_desc( buff_type, value ,name)
   -- print("---------------------------buff_type---------------------",buff_type,value,name);
    local buff_str = BuffConfig:get_buff_desc_by_buff_id( buff_type )
    value = math.abs(value)

    local inc_str = UserBuffWin:getIncText( buff_type, value)
    -- print('>>>', buff_type,  inc_str,  buff_str)
    buff_str = string.gsub( buff_str,"#inc#",inc_str );
   -- print(">>>", buff_str);
    buff_str = string.gsub( buff_str,"<BR>"," " );
   -- print(">>>", buff_str);
    -- 小于1的数字都变成百分比形式
    if ( value < 1 ) then
        value = math.floor( value * 100 ) .. "%%";
    end
    buff_str = string.gsub( "#cfff000"..buff_str,"#value#","#cffffff"..value );
   -- print(">>>", buff_str);
    return buff_str;
end

function UserBuffWin:set_player_buff_table(  )
    self.buff_info_table = {};
    local player_avatar = EntityManager:get_player_avatar();
    for k,v in pairs(player_avatar.buff_dict) do
        self.buff_info_table[#self.buff_info_table+1] = v
    end

end

function UserBuffWin:reinit_per_buff_pos()
    local temp_panel_size = self.scroll_item_panel:getSize()
    for i = 1 , #self.buff_view_table do
        self.buff_view_table[i].view:setPosition( 0, temp_panel_size.height - i * buffer_per_height )
    end
    self.scroll:autoAdjustItemPos()
end

function UserBuffWin:add_xz_icon(  )  --添加仙踪神兽图标
    -- print("self.view=",self.view)

    -- if self.view ~= nil then
    --     local function my_callback( )
    --     end
    --     self.myBtn_bg = ZCCSprite:create(  self.view, UIResourcePath.FileLocate.common.."but_bg.png" , 238, 304)
    --     self.myBtn = UIButton:create_button_with_name( 218, 284, -1, -1, UIResourcePath.FileLocate.guild .. "luck.png", UIResourcePath.FileLocate.guild .. "luck.png", nil, "", my_callback )
    --     self.view:addChild(self.myBtn )  -- here_here
    -- end
end


-- 刷新，重新同步装备数据
function UserBuffWin:update()

    -- print("UserBuffWin:update()")
    local player = EntityManager:get_player_avatar()

    -- 更新主角血蓝宠物血
    local player_avatar = EntityManager:get_player_avatar();

    self.user_left_hp:setText( player_avatar.hpStore )
    self.user_left_mp:setText( player_avatar.mpStore )

    local player_pet = EntityManager:get_player_pet();

    if ( player_pet ) then
        --print("PetModel:get_current_pet_info().tab_attr[8]",PetModel:get_current_pet_info().tab_attr[8])
        self.pet_left_hp:setText(PetModel:get_current_pet_info().tab_attr[8]);
    end
    -- 更新buff 
end
