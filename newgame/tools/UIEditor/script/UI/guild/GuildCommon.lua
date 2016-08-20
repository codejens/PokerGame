-- GuildCommon.lua  
-- created by lyl on 2012-1.22
-- 仙宗相关的公用方法

super_class.GuildCommon()

local _max_icon = 4
local _icon_path_t = { 
    UILH_GUILD.guild_icon1, 
    UILH_GUILD.guild_icon2, 
    UILH_GUILD.guild_icon3, 
    UILH_GUILD.guild_icon4
}

-- 更具仙宗icon 号获取图标, 返回 CCZXImage .  x, y 不传默认为0
function GuildCommon:get_icon_by_index( icon_index, x, y, w, h  )
	-- local icon_path_t = { UIResourcePath.FileLocate.guild .. "guild_icon_01.png", UIResourcePath.FileLocate.guild .. "guild_icon_02.png", UIResourcePath.FileLocate.guild .. "guild_icon_03.png" }
    local icon_path = self:get_icon_path_by_index(icon_index) or self:get_icon_path_by_index(1)
    	local pos_x = x or 0
    	local pos_y = y or 0
        local size_w = w or 90
        local size_h = h or 90
        return CCZXImage:imageWithFile( pos_x, pos_y, size_w, size_h, icon_path, 500, 500 )
end

-- 更具仙宗icon 号获取图标名称
function GuildCommon:get_icon_path_by_index( icon_index  )
	-- local _icon_path_t = { UIPIC_FAMILY_018, UIPIC_FAMILY_019, UIPIC_FAMILY_020, UIPIC_FAMILY_021, UIPIC_FAMILY_022 }
    if _icon_path_t[ icon_index + 1 ] then
        return _icon_path_t[ icon_index + 1 ]
    end
    return  UILH_GUILD.guild_icon1 
end

function GuildCommon:get_icon_max( ... )
    return _max_icon
end