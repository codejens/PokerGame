-- QQWeixindIalog.lua 
-- created by liuguowang on 2014-3-4
-- QQ浏览器活动窗口
 

super_class.QQWeiXinDialog(Window)

require "../data/activity_config/qq_weixin_conf"

function QQWeiXinDialog:__init(window_name, window_info)

    ZImage:create( self.view, UIResourcePath.FileLocate.QQactive .. "QQweixinBk.png", 0, 0, -1, -1)
    ----------------------------------------------------------------
    -- 输入框前的文字
    local enter_title = UILabel:create_lable_2( LangGameString[2326], 18, 80, 20,ALIGN_LEFT)
    self:addChild( enter_title )

    -- 输入框
    local enter_frame_bg = CCZXImage:imageWithFile( 92, 75,268,31, UIPIC_GRID_nine_grid_bg3, 500, 500 )
    self:addChild( enter_frame_bg )

    self.enter_frame = CCZXEditBox:editWithFile( 92+10, 75, 248,31, "",  20 , 16, EDITBOX_TYPE_NORMAL, 500, 500)
    self:addChild( self.enter_frame )
    ----------------------------------------------------------------
    local function get_btn_fun( )--领取按钮
        if ItemModel:check_bag_if_full() then
            GlobalFunc:create_screen_notic( LangModelString[11] ) -- [11]="背包已满,不能领取奖励"
            return
        end
     
        local cd_key = self.enter_frame:getText()
        OnlineAwardCC:req_get_weixin_libao(cd_key)
        self.enter_frame:setText("");
    end

    self.get_btn = UIButton:create_button_with_name( 137, 15,-1,-1,  UIResourcePath.FileLocate.common .. "button_red.png",  UIResourcePath.FileLocate.common .. "button_red.png", nil, nil, get_btn_fun )
    self.view:addChild( self.get_btn );
    --  "领取奖励"  文字
    local get_award_text = CCZXImage:imageWithFile( 12, 10,-1, -1, UIResourcePath.FileLocate.normal .. "get_award.png");
    self.get_btn:addChild( get_award_text );

    ----------------------------------------------------------------

    local offerFrame = 33  
    local one_width = (window_info.width-offerFrame*2)/#_qq_weixin_get_slot_id
    self.slot_item = {}
    for i=1,#_qq_weixin_get_slot_id do  --领取的图标id
        self.slot_item[i] = MUtils:create_slot_item(self.view,UIPIC_ITEMSLOT,offerFrame+one_width/2 - 60 /2 + (i-1) *one_width,135,60,60,_qq_weixin_get_slot_id[i].id);
        self.slot_item[i]:set_item_count(_qq_weixin_get_slot_id[i].num)
        self.slot_item[i]:play_activity_effect();        
    end
    ----------------------------------------------------------------

end



function QQWeiXinDialog:active(active)
    if active == true then
        self:update()
    end
end


function QQWeiXinDialog:update()


    for i=1,#_qq_weixin_get_slot_id do  --领取的图标id
        self.slot_item[i]:play_activity_effect();        
    end
end
