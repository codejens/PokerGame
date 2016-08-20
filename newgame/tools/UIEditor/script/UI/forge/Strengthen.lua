-- Strengthen.lua
-- created by lyl on 2012-12-11
-- 炼器--强化装备面板

super_class.Strengthen(Window)


local _had_show_explain = false             --标记为未显示  说明面板


function Strengthen:__init(  )
	self.strengthenL = StrengthenL( 428, 10, 430, 488, UILH_COMMON.bottom_bg, self )
    self.view:addChild( self.strengthenL.view )

    self.strengthenRU = StrengthenRU( 10, 10, 420, 488, UILH_COMMON.bottom_bg, self)
    self.view:addChild( self.strengthenRU.view )

    self.strengthenRD = StrengthenRD( 432, 18, 420, 200, UILH_COMMON.bg_10, self)
    self.view:addChild( self.strengthenRD.view )
end

function Strengthen:update( update_type )
    -- print("update_type=",update_type)
    if update_type == "strengthen_item" then
        self.strengthenL:strengthen_item_change(  )
        self.strengthenRU:update_select_state(  )
        self.strengthenRD:flash_all_item_r_dow()
        ForgeModel:send_request_get_wish_val()
    elseif update_type == "strengthen_gem" then
        self.strengthenRU:update_all_item_date(  )
        self.strengthenL:strengthen_item_change(  )
        self.strengthenL:update_strengthen_gem(  )
        self.strengthenRD:update_select_state(  )
        self.strengthenRD:update_all_item_date(  )
        self.strengthenRD:flash_all_item_r_dow()
        ForgeModel:send_request_get_wish_val()
    elseif update_type == "strengthen_prot" then
        self.strengthenL:update_strengthen_prot(  )
        self.strengthenRD:update_select_state(  )
        ForgeModel:send_request_get_wish_val()
    elseif update_type == "all" then
        LuaEffectManager:stop_view_effect( 11008,self.view)
        ForgeModel:set_strengthen_item_series( nil )      -- 每次打开，都把已经选择的去掉
        ForgeModel:reset_strengthen_item_series(  )
        self.strengthenRU:flash_all_item_r_up()
        self.strengthenRU:set_default_item()
        self.strengthenRD:flash_all_item_r_dow()
        ForgeModel:send_request_get_wish_val()
    elseif update_type == "bag_change" then
        ForgeModel:reset_strengthen_item_series(  )
        self.strengthenL:update_all_item_date(  )
        self.strengthenRU:update_all_item_date(  )
        self.strengthenRD:update_all_item_date(  )
    elseif update_type == "bag_add" or update_type == "bag_remove"  then
        ForgeModel:reset_strengthen_item_series(  )
        self.strengthenL:update_all_item_date(  )
        self.strengthenRU:flash_all_item_r_up(  )
        self.strengthenRD:flash_all_item_r_dow(  )
    elseif update_type == "strengthen_15" then     -- 强化达到十五级，要重新刷新装备列表，去掉十五级的装备
        self.strengthenRU:flash_all_item_r_up(  )
    elseif update_type == "wish_val" then
        local wish_val = ForgeModel:get_wish_val()
        self.strengthenL:set_wish_val(wish_val)
    end 
end

function Strengthen:destroy()
    self.strengthenRU:destroy()
    self.strengthenRD:destroy()
    self.strengthenL:destroy()
    Window.destroy(self)
    -- print("======= strengthen:destroy() =======")
end

function Strengthen:active()

end

