-- MiyouOlfriend.lua  
-- created by liuguowang on 2013-9-3
-- 游戏助手页 中的 每行的基类。  

super_class.MiyouOlfriend()


function MiyouOlfriend:__init( width, height , cell_index)--,days

    self.view = CCBasePanel:panelWithFile( 0, 0, width, height, UIResourcePath.FileLocate.common.."bg2.png", 500, 500 );
    

    local function message_function(eventType, arg, msgid)
        ------------------------------------
        if eventType == nil or arg == nil or msgid == nil then
            return
        end
        ------------------------------------
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == TOUCH_CLICK then
            if self.click_friendList_func then
                self.click_friendList_func( self.friendInfo.roleId )
            end
        end
        return true

    ------------------------------------
    end
    self.view:registerScriptHandler(message_function)

    self.friendInfo = FriendModel:get_my_OL_friendIndex_info(cell_index)
    if self.friendInfo ~= nil then 
        local friend_name = UILabel:create_lable_2( self.friendInfo.roleName, 10, 8, 14, ALIGN_LEFT )
        self.view:addChild( friend_name )
    end

end


function MiyouOlfriend:set_click_friendList_func( fn )
    self.click_friendList_func = fn;
end