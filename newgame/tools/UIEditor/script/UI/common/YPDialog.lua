-- YPDialog.lua
-- created by hcl on 2013/6/27
-- 药品提示框

require "UI/component/Window"
require "utils/MUtils"
super_class.YPDialog(Window)

-- 
function YPDialog:__init(window_name, texture_name)
	local spr_bg = CCZXImage:imageWithFile( 0, 0, 420, 420, UIResourcePath.FileLocate.common .. "bg_blue.png",  120,88,120,88,120,74,120,74 );
    self.view:addChild( spr_bg );

    -- 九宫格背景
    --MUtils:create_zximg(panel,"ui/common/nine_grid_bg.png", 12,45,216,50+16+10,500,500);
    -- 标题
    -- local title_bg = CCZXImage:imageWithFile( 420 / 2 - 81, 420 - 35, -1, -1, UIResourcePath.FileLocate.common .. "dialog_title_bg.png"  )
    -- MUtils:create_sprite(title_bg,UIResourcePath.FileLocate.normal .. "dialog_title_t.png",81,23)
    -- spr_bg:addChild(title_bg,2);


    MUtils:create_sprite(spr_bg,UIResourcePath.FileLocate.other .. "yp_title.png",210,227)

    -- 关闭按钮
    local function btn_close_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            UIManager:hide_window("yp_dialog");
        end
        return true
    end
    local exit_btn = MUtils:create_btn(self.view,UIResourcePath.FileLocate.common .. "close_btn_z.png",UIResourcePath.FileLocate.common .. "close_btn_z.png",btn_close_fun,0,0,-1,-1);
    local exit_btn_size = exit_btn:getSize()
    local spr_bg_size = self.view:getSize()
    exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )

    local function btn_ok_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            UIManager:hide_window("yp_dialog");
            local user_item = ItemModel:get_item_info_by_id( 18300 )
            if ( user_item ) then
                local win = UIManager:find_visible_window("menus_panel");
                if ( win ) then
                    win:add_supply(user_item,true);
                end
            end
            
        end
        return true
    end
    self.btn1 = MUtils:create_btn(self.view,UIResourcePath.FileLocate.common .. "button2_red.png", UIResourcePath.FileLocate.common .. "button2_red.png",btn_ok_fun,157,25,106,41,1,39,19,39,19,39,19,39,19);
    MUtils:create_sprite(self.btn1,UIResourcePath.FileLocate.other .. "yp_btn_text.png",53 ,20.5)

end