-- GeniusIconCell.lua
-- created by mwy on 2014-5-3
-- 精灵显示单个icon

super_class.GeniusIconCell(  )


function GeniusIconCell:__init( panel_table_para,x, y,callback )
    local pos_x = x or 0
    local pos_y = y or 0
    self.mount_id=panel_table_para.modelId

    self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 100, 100, UIResourcePath.FileLocate.common .. "wpk-1.png", 500, 500 )  
    -- 匹配
    local function match_btn_click( eventType )
        if TOUCH_CLICK == eventType then
            --ZXLog("-----------GeniusIconCell match_btn_click-------------",self.mount_id)
            callback(self.mount_id)
        end
        return true;
    end
    -- 匹配按钮 
    local icon_path = string.format("icon/spirits/%05d.pd",self.mount_id)
    -- print("-------------icon_path",icon_path)
    self.match_btn = MUtils:create_btn( self.view,icon_path,icon_path,match_btn_click,1,1,98,98);

   return self.view
end