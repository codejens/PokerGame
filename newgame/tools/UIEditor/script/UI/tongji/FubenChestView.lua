-- FubenChestView.lua
-- created by fjh on 2013-3-12
-- 诛仙阵宝箱视图

super_class.FubenChestView(Window)
local _tick_cb = callback:new();

local function close_win(  )
    
   	UIManager:destroy_window("fuben_chest_win");
end

function FubenChestView:__init(  )
	--宝箱按钮
    local _ui_width = GameScreenConfig.ui_screen_width 
    local _ui_height = GameScreenConfig.ui_screen_height

    local chest_btn = CCNGBtnMulTex:buttonWithFile(0,0,82, 70, UILH_AWARD.baoxiang)
    -- chest_btn:addTexWithFile(CLICK_STATE_DOWN,UILH_FUBEN.chest_s)
    local function open_chest( eventType,x,y )
        if eventType == TOUCH_CLICK then

            FuBenModel:open_chest_in_fuben();
            
            close_win()
        end
        return true;
    end
    chest_btn:registerScriptHandler(open_chest) 
    self:addChild(chest_btn)
    _tick_cb:start(15,close_win)

    self.view:setPosition((_ui_width-82)/2,(_ui_height-70)/2)
end
