-- QuestAwardView.lua
-- created by hcl on 2013/2/27
-- 队伍面板的item项

require "utils/MUtils"
super_class.QuestAwardView()

function QuestAwardView:__init(parent,x,y)
    self.slot_item = MUtils:create_slot_item( parent,
        UILH_COMMON.slot_bg,
        x, y, 83, 83, nil);
    self.slot_item:set_icon_bg_texture( UILH_COMMON.slot_bg, -9, -9, 82, 82 )   -- 背框
    self.view = self.slot_item.view;
end

function QuestAwardView:set_icon_and_num( icon_path,icon_count ,item_id)
    self.slot_item:set_icon_texture(icon_path);
    self.slot_item:set_item_count(icon_count);
    self.slot_item:set_color_frame( item_id, 0, 0, 64, 64);
    local function f1()
        TipsModel:show_shop_tip( 450, 323, item_id );
    end
    self.slot_item:set_click_event( f1 )
end

function QuestAwardView:set_item_name( item_name )
    -- self.slot_item_name:setText("");
    -- self.slot_item_name:setText(item_name);
end