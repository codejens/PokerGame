-- UserBuffPanel.lua
-- created by hcl on 2013-7-8
-- 玩家buff界面

super_class.UserBuffPanel()
local buffer_per_height = 53
function UserBuffPanel:__init( bgPanel )
    local background = CCBasePanel:panelWithFile( 40,11,339,383, UIPIC_GRID_nine_grid_bg3, 500, 500);  --方形区域
    bgPanel:addChild( background )
    self.view = background;

    -----角色血蓝包----
    -- 标题 角色药包信息
    local title1 = ZImage:create(self.view,UIResourcePath.FileLocate.common .. "quan_bg.png",4,353,332,28,0,500,500);
    MUtils:create_sprite(title1,UIResourcePath.FileLocate.role .. "yaobao_mg.png",332/2,14);
    -- 两条线
    -- MUtils:create_zximg(self.view,UIResourcePath.FileLocate.common .. "coner2.png", 60,300,266,2,10,0);
    -- MUtils:create_zximg(self.view,UIResourcePath.FileLocate.common .. "coner2.png", 60,270,266,2,10,0);
    -- MUtils:create_zximg(self.view,UIResourcePath.FileLocate.common .. "coner2.png", 20,240,306,2,10,0);
    local tt = Image:create( nil, 95, 320, 234, 2, UIResourcePath.FileLocate.common .. "fenge_bg.png" )
    self.view:addChild(tt.view)
    local tt2 = Image:create( nil, 95, 290, 234, 2, UIResourcePath.FileLocate.common .. "fenge_bg.png" )
    self.view:addChild(tt2.view)
    local tt3 = Image:create( nil, 95, 260, 234, 2, UIResourcePath.FileLocate.common .. "fenge_bg.png" )
    self.view:addChild(tt3.view)

    -- 药水
    MUtils:create_sprite(self.view,UIResourcePath.FileLocate.role .. "user_bottle.png",50,300);
    -- 生命值
    MUtils:create_zxfont(self.view,Lang.role_info.user_buff_panel.role_life_item,110,327);   
    MUtils:create_zxfont(self.view,Lang.role_info.user_buff_panel.role_magic_item,110,297);
    self.user_left_hp = MUtils:create_zxfont(self.view,"0",238,327);   
    self.user_left_mp = MUtils:create_zxfont(self.view,"0",238,297);

    MUtils:create_zxfont(self.view,Lang.role_info.user_buff_panel.pet_life_item,110,267);
    self.pet_left_hp = MUtils:create_zxfont(self.view,"0",238,267);

    local title3 = ZImage:create(self.view,UIResourcePath.FileLocate.common .. "quan_bg.png",4,220,332,28,0,500,500);
    MUtils:create_sprite(title3,UIResourcePath.FileLocate.role .. "buff_mg.png",332/2,14);    

    -- 第一次打开的时候添加所有的buff
    self:create_scroll(  )

end

function UserBuffPanel:update()
    -- print("-------------------------------------------------UserBuffPanel:update-----------------------------")
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

function UserBuffPanel:create_scroll(  )
    -- 更新玩家的buff数据
    self:set_player_buff_table(  )
    self.timer_lab_table = {};
    self.buff_view_table = {};

    local _scroll_info = { x = 4 , y = 6 , width = 330, height = 210, maxnum = 1, stype = TYPE_HORIZONTAL }
    self.scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
    --self.scroll:setScrollLump( UIResourcePath.FileLocate.common .. "progress_green.png", 10, 20, 10 )
    self.view:addChild(self.scroll);

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
            self.scroll_item_panel = CCBasePanel:panelWithFile(0,0 ,330,10,"", 600, 600);
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

function UserBuffPanel:create_scroll_item(parent, index )
    local temp_panel_size = self.scroll_item_panel:getSize()
    local len = #self.buff_view_table;
    -- buff面板
    local buff_node = CCBasePanel:panelWithFile(0, 0, 330, buffer_per_height, "", 600, 600 )--CCNode:node();
    self.buff_view_table[len+1] = buff_node;
    parent:addChild( buff_node );
    buff_node:setPosition( 0, temp_panel_size.height - ( index ) * buffer_per_height )
    --buff_node:setPosition( 0, 220-(len+1)*53 );
    local buff_struct = self.buff_info_table[index];
    -- buff背景
    local item_bg = MUtils:create_sprite( buff_node,UIPIC_ITEMSLOT,30,26.5 )
    item_bg:setScaleX(40/62);
    item_bg:setScaleY(40/62);
    -- buff图标
    local icon_path = string.format("icon/buff/%05d.jd",buff_struct.buff_type);
    --local icon_path = string.format("icon/buff/%05d.jpg",buff_struct.buff_type);
    local icon = MUtils:create_sprite(buff_node,icon_path,30,26.5);
    icon:setScaleX(1.4);
    icon:setScaleY(1.4);
    local str = self:get_desc( buff_struct.buff_type, buff_struct.buff_value ,buff_struct.buff_name)
    -- buff描述
    MUtils:create_zxfont(buff_node,str,65,28,15);
    -- 分隔线
    --MUtils:create_zximg(buff_node,UIResourcePath.FileLocate.common .. "coner2.png", 0,0,306,2,500,500);
    local tt3 = Image:create( nil, 0, 0, 330, 2, UIResourcePath.FileLocate.common .. "fenge_bg.png" )
    buff_node:addChild(tt3.view)
    -- 计时器
    buff_node.timer_lab = TimerLabel:create_label(buff_node, 65, 5, 15, buff_struct.alive_time-1, "#c00D257", nil,nil);

end

function UserBuffPanel:add_buff( buff )

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

function UserBuffPanel:remove_buff( buff_type,buff_group )
    for i=1,#self.buff_info_table do
        if ( self.buff_info_table[i].buff_type == buff_type and ( buff_group==nil or self.buff_info_table[i].buff_group == buff_group) )  then
            local buff_node = table.remove(self.buff_view_table,i);
            buff_node.timer_lab:destroy();
            buff_node:removeFromParentAndCleanup( true );
            -- 删除一个后，后面的buff要往上移
            for j=i,#self.buff_view_table do
                local _buff_node = self.buff_view_table[j];
                local pos_x,pos_y = _buff_node:getPosition();
                _buff_node:setPosition(pos_x,pos_y+53);
            end
            table.remove(self.buff_info_table,i);
            break;
        end
    end
    local buff_info_table_size = #self.buff_info_table
    self.scroll_item_panel:setSize( 330, buff_info_table_size * buffer_per_height )
    self:reinit_per_buff_pos()
end

function UserBuffPanel:getIncText( buff_type, value)
    -- switch(type)
    -- {
    --     case aMoveSpeedAdd:
    --     case aAttackSpeedAdd:
    --     case aInAttackDamageValueAdd:
    --     case aOutAttackDamageValueAdd:
    --         return value < 0 ? Language.Common_Promote : Language.Common_Reduce;
    --     case aRootPower:
    --     case aAttackSpeedAdd:
    --     case aExpPower:
    --     case aInAttackDamageValueAddPower:
    --     case aOutAttackDamageValueAddPower:
    --     case aPetAddHp:
    --     case aDamage2Hp:
    --     case aRenowRateAdd:
    --         return value > 0 ? Language.Common_Increase : Language.Common_Decrease;
    --     default:
    --         return value < 0 ? Language.Common_Decrease : Language.Common_Increase;
    -- }

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

function UserBuffPanel:get_desc( buff_type, value ,name)
   -- print("---------------------------buff_type---------------------",buff_type,value,name);
    local buff_str = BuffConfig:get_buff_desc_by_buff_id( buff_type )
    value = math.abs(value)
  --  print(buff_str);
    --buff_str = string.gsub( buff_str,"#name#","#c66ff66"..name.."#cfff000" );
    -- buff_str = string.gsub(buff_str,"#name#","");
    -- print(buff_str);
    local inc_str = UserBuffPanel:getIncText( buff_type, value)
    buff_str = string.gsub( buff_str,"#inc#",inc_str );
   -- print(buff_str);
    buff_str = string.gsub( buff_str,"<BR>"," " );
   -- print(buff_str);
    -- 小于1的数字都变成百分比形式
    if ( value < 1 ) then
        value = math.floor( value * 100 ) .. "%%";
    end
    buff_str = string.gsub( buff_str,"#value#",value );
   -- print(buff_str);
    return buff_str;
end

function UserBuffPanel:set_player_buff_table(  )
    self.buff_info_table = {};
    local player_avatar = EntityManager:get_player_avatar();
    for k,v in pairs(player_avatar.buff_dict) do
        self.buff_info_table[#self.buff_info_table+1] = v
    end

end

function UserBuffPanel:reinit_per_buff_pos()
    local temp_panel_size = self.scroll_item_panel:getSize()
    for i = 1 , #self.buff_view_table do
        self.buff_view_table[i]:setPosition( 0, temp_panel_size.height - i * buffer_per_height )
    end
    self.scroll:autoAdjustItemPos()
end