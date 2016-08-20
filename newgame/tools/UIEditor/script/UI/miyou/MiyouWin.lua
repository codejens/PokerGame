-- MiyouWin.lua  
-- created by liuguowang on 2013-9-3
-- 主窗口  Miyou_Win


super_class.MiyouWin(Window)



function MiyouWin:__init(  )
    local function win_touch_event( eventType )
        if self._showFriendList == true then
            self:showFriendFirendList(0,false) --关闭的时候， 把  friendlist关掉
        end
    end

    self.view:registerScriptHandler(win_touch_event)

    -------init var
    self._showFriendList =false

    self._miyouRow_obj = {}  --存对象的  刚开始创建6个
    --------
    self.scrollBK = CCZXImage:imageWithFile(26, 60, 695, 325,UIResourcePath.FileLocate.common .. "bg2.png",500,500);
    self.view:addChild(self.scrollBK)

    MiyouCC:req_miyou_gift()--请求奖励列表

end


function MiyouWin:add_Win_UI()

    self.scroll = CCScroll:scrollWithFile(26, 60, 695, 276, 9, nil, TYPE_HORIZONTAL);

    local function scrollViewFunc(eventType, args, msg_id)

        if eventType == nil or args == nil or msg_id == nil then 
            return 
        end

        if eventType == TOUCH_BEGAN then
            if self._showFriendList == true then 
                self.view:addChild(self.scrollFriend);
            end
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then

            local temparg = Utils:Split(args,":")
            local times = tonumber(temparg[1])+1;              -- times是第几次调用进来
            -- local basePanel = CCBasePanel:panelWithFile( 0,0,683, 251/6 ,UIResourcePath.FileLocate.common.."bg2.png", 500, 500 );

            local cell = MiyouRow( 683, 250/5,times )
            self._miyouRow_obj[ times ] = cell --保存 行的对象
            if self._miyouRow_obj[times] ~= nil then --设置数据

                local send_data,get_data = MiyouModel:getListData()
                self._miyouRow_obj[times]:set_get_item_data(get_data[times])
                self._miyouRow_obj[times]:set_send_item_data(send_data[times])
            end

            if MiyouModel:get_continue_day() ~= nil  then  --如果获取到了连续天数 才去更新
                cell:update(times)         --aaaaaaaaaaaa
            end
            -----
            local function func(times,bEdit )
                self:showFriendFirendList(times,bEdit)
            end
            cell:set_click_friend_func(func)
            self.scroll:addItem(cell.view);
            self.scroll:refresh();
        end
    end
    self.scroll:registerScriptHandler(scrollViewFunc)
    self.scroll:refresh()
    self.view:addChild(self.scroll);
 
    --剩余时间字体
    local miyou_time = CCZXImage:imageWithFile(30,345,166,23,UIResourcePath.FileLocate.miyou .. "miyou_time.png");
    self.view:addChild(miyou_time);

    --规则说明
    local function goto_rule(  )
        self:chow_get_explain()
    end

    local rule_Label = UIButton:create_button_with_name( 30,25,90,25, UIResourcePath.FileLocate.miyou .. "miyou_rule.png", UIResourcePath.FileLocate.miyou .. "miyou_rule.png", nil, "", goto_rule )
    self.view:addChild(rule_Label )

    --标题
    -- local miyou_title_sp = CCZXImage:imageWithFile(760/2-230/2,429-35,226,46,UIResourcePath.FileLocate.common .. "win_title1.png");
    -- self.view:addChild(miyou_title_sp);
    -- local miyou_title = CCZXImage:imageWithFile(226/2-107/2-5,46/2-30/2+5,107,30,UIResourcePath.FileLocate.miyou .. "miyou_title.png");
    -- miyou_title_sp:addChild(miyou_title);

    --分界线
    local miyou_camp = CCZXImage:imageWithFile(180,335,409,4,UIResourcePath.FileLocate.common .. "camp_line.png");
    self.view:addChild(miyou_camp);
  
    -- --关闭按钮
    -- local function close_but_CB( )
    --     UIManager:hide_window( "miyou_win" )
    -- end
    -- local close_but = UIButton:create_button_with_name( 340 + 389 -18, 377, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png", nil, "", close_but_CB )
    -- local exit_btn_size = close_but:getSize()
    -- local spr_bg_size = self.view:getSize()
    -- close_but:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    -- self.view:addChild( close_but )

------------------------------------------------------------
    if self._showFriendList == true then 
        self:addFriendScroll()     
    end

end

function MiyouWin:showFriendFirendList(times,bEdit)

    if self._showFriendList == false and bEdit == true then
        self._showFriendList = true
        MiyouModel:setUpdateIndex(times) --保存修改下拉框
        self:addFriendScroll()
    elseif self._showFriendList == true then
        if self.scrollFriend ~= nil then
            self.view:removeChild(self.scrollFriend, true)
        end
        if self.scrollFriendFrame ~= nil then
            self.view:removeChild(self.scrollFriendFrame,true)
        end
        if self.no_friend_words ~= nil then
            self.view:removeChild(self.no_friend_words,true)
        end
        self._showFriendList = false
    end
end

function MiyouWin:addFriendScroll( )
    local onlineFriendNum = FriendModel:get_my_friend_online_num()

    self.scrollFriendFrame = CCZXImage:imageWithFile(403, 10, 156, 342,UIResourcePath.FileLocate.common .. "bg05.png",500,500);
    
    self.view:addChild(self.scrollFriendFrame)

    local function scrollViewFunc_Friend(eventType, args, msg_id)
       
        if eventType == nil or args == nil or msg_id == nil then 
            return 
        end 
        
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == TOUCH_CLICK then
        elseif eventType == SCROLL_CREATE_ITEM then
            local temparg = Utils:Split(args,":")
            local times = tonumber(temparg[1])+1;              -- times是第几次调用进来
            local cell = MiyouOlfriend( 130, 40 , times);
            
            local function func( roleId )
                local updateIndex = MiyouModel:getUpdateIndex()
                if self._miyouRow_obj[updateIndex] ~= nil then 
                    self._miyouRow_obj[updateIndex]:setRoleID(roleId) --保存选择的是哪个friend ID
                    MiyouModel:setListSubData(true,updateIndex,MiyouModel.ITEM_ROLEID,roleId)
                end
                
                self.view:removeChild(self.scrollFriendFrame,true)
                self.view:removeChild(self.no_friend_words,true)
                self.view:removeChild(self.scrollFriend, true)
                self._showFriendList = false
                self:updateRow()

            end
            cell:set_click_friendList_func(func);

            self.scrollFriend:addItem(cell.view);
            self.scrollFriend:refresh();  

        end
    end
    if onlineFriendNum > 0 then 
        self.scrollFriend = CCScroll:scrollWithFile(413, 20, 135, 322, onlineFriendNum, nil, TYPE_HORIZONTAL)
        self.scrollFriend:registerScriptHandler(scrollViewFunc_Friend)
        self.scrollFriend:refresh()
        if self._showFriendList == true then 
            self.view:addChild(self.scrollFriend);
        end
    else
        self.no_friend_words = UILabel:create_lable_2( LangGameString[1567], 420, 312, 14, ALIGN_LEFT ) -- [1567]="#ceb1d2b没有好友在线"
        self.view:addChild(self.no_friend_words )
    end
end

function MiyouWin:active( show )
    if show == true then
        if self.match_time then
            self.match_time:destroy();
            self.match_time = nil;
        end
        local now_time = MiyouModel:get_miyou_remain_Time()
        if now_time > 0 then
            self.match_time = TimerLabel:create_label( self.view, 205,350, 16, now_time, "#cffff00", nil, false, ALIGN_LEFT, false);       
        else
            local activity_stop = UILabel:create_lable_2( LangGameString[1568], 205, 348,16, ALIGN_LEFT ) -- [1568]="#cffff00活动已截止"
            self.view:addChild(activity_stop )
        end   
    elseif show == false then
        if self.match_time then
            self.match_time:destroy();
            self.match_time = nil;
        end
        if self._showFriendList == true then
            self:showFriendFirendList(0,false) --关闭的时候， 把  friendlist关掉
        end
    end
end
    

function MiyouWin:set_GetBtn_state( rowIndex  ) 
    if self._miyouRow_obj[rowIndex] ~= nil then 
        self._miyouRow_obj[rowIndex]:set_get_btn_state( 2 )
    end
end


function MiyouWin:set_SendBtn_state( rowIndex  ) 
    if self._miyouRow_obj[rowIndex] ~= nil then
        self._miyouRow_obj[rowIndex]:set_send_btn_state( 2 )
    end
end

function MiyouWin:updateRow() --更新 某一行
    local updateIndex = MiyouModel:getUpdateIndex()
    if self._miyouRow_obj[updateIndex] ~= nil then
        self._miyouRow_obj[updateIndex]:update()
    end
end

-- 显示获取说明
function MiyouWin:chow_get_explain(  )
    local explain_content = LangGameString[1569].. -- [1569]="#c66FF66规则说明 #r"
                            LangGameString[1570].. -- [1570]="#c66FF661.只能赠送给在线好友。#r"
                            LangGameString[1571] .. -- [1571]="#c66FF662.每个玩家同种奖励只能受赠10次。#r"
                            LangGameString[1572]  -- [1572]="#c66FF663.连续登录期间，中断或者8天满后重新计算连续登陆次数并重置奖励，第15天只需要玩家在线即可赠送和领取奖励。#r"
                          
    HelpPanel:show( 3, UIResourcePath.FileLocate.normal .. "tishi.png", explain_content )
end
