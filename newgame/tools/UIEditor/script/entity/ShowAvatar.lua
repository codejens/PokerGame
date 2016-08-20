-- ShowAvatar.lua
-- created by lyl on 2013-3-23
-- 面板显示用的实体

super_class.ShowAvatar()

local _EFFECT_PATH = "frame/effect/buff/"

-- tab_equip_info 装备信息
function ShowAvatar:__init( body, wing, weapon ,tab_equip_info)
	self.avatar = ZXAvatar:createShowAvatar()
    -- 创建时设置一次，udpate_body后再setActionStept、playAction没效果的样子
    self.avatar:setActionStept(ZX_ACTION_STEPT)
	self:udpate_body( body ,tab_equip_info)
	self:update_wing( wing )
	self:update_weapon( weapon )	
end

-- 创建身体
function ShowAvatar:udpate_body( body ,tab_equip_info )
	if body then
        self.body = ZXLuaUtils:lowByte( body )
        self.body_name = EntityFrameConfig:get_human_path( self.body );--string.format("frame/human/%05d" ,self.body )
        -- ZXLog('-----------ShowAvatar:udpate_body------------------')
        self.avatar:changeBody( self.body_name )
	end
    -- 更新品阶特效 
    if tab_equip_info ~= nil then
        self:show_pj_effect( tab_equip_info )
    end
end

-- 创建翅膀
function ShowAvatar:update_wing( wing )
	if wing then
        self.wing = ZXLuaUtils:lowByte(wing)
        if ( self.wing == 0 ) then
        	self.avatar:takeOffWing()
			return
		end
		self.wing_name = "frame/wing/"..self.wing
		self.avatar:putOnWing( self.wing_name )
	end
end

-- 创建武器
function ShowAvatar:update_weapon( weapon )
    -- 武器特效要脱下装备才会刷新，这里先脱下
    self.avatar:takeOffWeapon()
    
	if weapon then
        self.weapon = ZXLuaUtils:lowByte(weapon)
        if ( self.weapon == 0 ) then
        	self.avatar:takeOffWeapon()
		else
            self.weapon_name = EntityFrameConfig:get_weapon_path( self.weapon )--"frame/weapon/"..self.weapon
            self.avatar:putOnWeapon( self.weapon_name )
		end

        self.weapon_effect_id = ZXLuaUtils:highByte(weapon)         -- 武器特效id
        if self.weapon_effect_id ~= 0 then
            self.weapon_effect_name = _EFFECT_PATH..self.weapon_effect_id
        else 
            self.weapon_effect_name = nil;
        end
        -- print("##############ShowAvatar:update_weapon self.weapon_effect_name",self.weapon_effect_name)
        if self.weapon_effect_name then
            -- self.avatar:putOnEffect(self.weapon_effect_name)
            -- self.avatar:showWeaponEffect(self.weapon_effect_name);
        end
	end
end

-- 状态变更， 例如 真龙之魂显示特效
function ShowAvatar:update_zhenlong( if_zhenlong )
    if if_zhenlong then
        self.avatar:stopEffect(79)
        local ani_table = effect_config[79];
        self.avatar:playEffect(ani_table[1],79,7,ani_table[3],nil,0,0,10,ani_table[2]);
    else
        self.avatar:stopEffect(79)
    end
end

-- 创建人物面板 的avatar
function ShowAvatar:create_user_panel_avatar( x, y ,equip_info,other_player)
	local player = other_player or EntityManager:get_player_avatar()
    print("创建人物面板", player.body)
    local showAvatar = ShowAvatar( player.body, player.wing, player.weapon ,equip_info)
    showAvatar.avatar:setPosition( x, y )

    return showAvatar
end

-- 创建翅膀界面 的avatar
function ShowAvatar:create_wing_panel_avatar( x, y, other_player )
    
    local player = other_player or EntityManager:get_player_avatar();
    print("创建翅膀界面avatar", player.body ,player.wing);
    local showAvatar = ShowAvatar(player.body, player.wing);
    showAvatar.avatar:setPosition(x,y);
    return showAvatar;

end

-- 创建其他玩家信息面板的 avatar
function ShowAvatar:create_other_panel_avatar( x, y, player_obj )
    local showAvatar = ShowAvatar( player_obj.body, player_obj.wing, player_obj.weapon )
    showAvatar.avatar:setPosition( x, y )
    return showAvatar
end

-- 其他玩家avatar的更新，要传入一个entity
function ShowAvatar:other_player_change_attri( attri_type, player_obj, not_from_OtherAttrWin)
    if attri_type == "body" then
        local other_equip_list;
        if not_from_OtherAttrWin then
            other_equip_list = nil
        else
            other_equip_list = OtherAttrWin:get_other_player_equip_list()
        end
        self:udpate_body( player_obj.body ,other_equip_list )
    elseif attri_type == "wing" then
        self:update_wing( player_obj.wing )
    elseif attri_type == "weapon" then
        self:update_weapon( player_obj.weapon )
    end
end

-- 更新属性
function ShowAvatar:change_attri( attri_type ,tab_equip_info )
    --print("ShowAvatar:change_attri( attri_type )",attri_type,#tab_equip_info)
	local player = EntityManager:get_player_avatar()

    if attri_type == "body" then
        self:udpate_body( player.body ,tab_equip_info)
    elseif attri_type == "wing" then
        self:update_wing( player.wing )
    elseif attri_type == "weapon" then
        self:update_weapon( player.weapon )
    elseif attri_type == "remove_pj_effect" then
        self:remove_pj_effect(tab_equip_info);
    elseif attri_type == "update_pj_effect" then
        self:show_pj_effect( tab_equip_info )
    end

end

-- 显示品阶特效 
function ShowAvatar:show_pj_effect( tab_equip_info )
    self.avatar:stopEffect(89)
    self.avatar:stopEffect(59)
    local equip_count = #tab_equip_info;
    if ( equip_count < 10 ) then
        return;
    end

    local is_zhizun_effect = true;     --至尊特效
    local is_zhen_effect = true;       --真特效
    local len = 0;
    for i=1,equip_count do
        local item_base = ItemConfig:get_item_by_id( tab_equip_info[i].item_id );
        if ( item_base.type > 0 and item_base.type < 11 ) then
            local pj = ItemModel:get_item_pj( item_base )
            if ( pj == 2 ) then
                
            elseif ( pj == 1 ) then
                is_zhizun_effect = false;
            elseif ( pj == 0 ) then
                --print("有装备品阶为0")
                return;
            end
            len = len + 1;
            --print("pj = ",pj);
        end
    end
    --print("len = ",len,"is_zhizun_effect",is_zhizun_effect,"is_zhen_effect",is_zhen_effect);
    if ( len == 10 ) then
        if ( is_zhizun_effect ) then
            local ani_table = effect_config[89];
            self.avatar:playEffect(ani_table[1],89,7,ani_table[3],nil,0,0,10,ani_table[2]);
            return
        end

        --取消真特效
        -- if ( is_zhen_effect ) then
        --     local ani_table = effect_config[59];
        --     self.avatar:playEffect(ani_table[1],89,7,ani_table[3],nil,0,0,10,ani_table[2]);
        -- end
    end

end

function ShowAvatar:remove_pj_effect( tab_equip_info )
    self.avatar:stopEffect(89)
    self.avatar:stopEffect(59)
end