-- MiyouRow.lua  
-- created by liuguowang on 2013-9-3
-- 游戏助手页 中的 每行的基类。  

super_class.MiyouRow()


MiyouRow.ACTIVE   = 1            --  活动状态，这时要排在前面
MiyouRow.INACTIVE = 2            --  非活动状态， 往后面排

MiyouRow.WHITE   = 1        --  活动状态，这时要排在前面
MiyouRow.GRAY    = 2            --  灰色

MiyouRow.CANNOT_SEND_GET   = 0        --  不可赠送,领取
MiyouRow.NEVER_SEND_GET    = 1        --  未赠送,领取
MiyouRow.ALREADY_SEND_GET   = 2        --  已赠送,领取


function MiyouRow:__init( width, height , cell_index )--,days
    self.cell_index = cell_index;
    self._width = width;
    self._SelRoleId = nil
    self._roleid = nil

    self._roleName = LangGameString[1558] -- [1558]="选择在线好友"
    local DayText = {}
    self.view = CCBasePanel:panelWithFile( 0, 0, width, height, UIResourcePath.FileLocate.common.."bg2.png", 500, 500 );
    --字体
    local friend_words = UILabel:create_lable_2( "", 10, 12, 14, ALIGN_LEFT )
    self.view:addChild(friend_words )
    if cell_index == 9 then
    	friend_words:setText( string.format( LangGameString[1559]  )  )--cell_index -- [1559]="#cffff00第        天登陆 ,可赠密友："
        DayText = CCZXImage:imageWithFile(28,10,20,24,UIResourcePath.FileLocate.caiquan .. "1.png");
        self.view:addChild(DayText);
        DayText = CCZXImage:imageWithFile(42,10,20,24,UIResourcePath.FileLocate.caiquan .. "5.png");
        self.view:addChild(DayText);

    else
     	friend_words:setText( string.format( LangGameString[1560]  )  )--cell_index -- [1560]="#cffff00连续登陆      天,可赠密友："
        DayText = CCZXImage:imageWithFile(80,10,20,24,UIResourcePath.FileLocate.caiquan .. cell_index ..".png");
        self.view:addChild(DayText);
    end


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
            if self.click_friend_func  then
                self.click_friend_func(cell_index,false )
            end
        end
    ------------------------------------
    end
    self.view:registerScriptHandler(message_function)


    --编辑框按钮
    local function edit_my_callback( )
        if self.click_friend_func then
            self.click_friend_func(cell_index,true)
        end
    end
    self.editBtn = UIButton:create_button_with_name( 255, 10, 130, 25, UIResourcePath.FileLocate.normal .. "compute_bg.png", UIResourcePath.FileLocate.normal .. "compute_bg.png", nil, "", edit_my_callback )
    self.view:addChild(self.editBtn.view )

    self:set_sendXialaText_Color(MiyouRow.WHITE)
    local xialaImg = CCZXImage:imageWithFile(105,0,-1,-1,UIResourcePath.FileLocate.miyou .. "xiala.png");
    self.editBtn.view:addChild(xialaImg);

    --赠送btn
    local function btn_friend_callback()
        if self._roleid ~= nil  then  --选好好友 
            if self._send_state ==  MiyouRow.NEVER_SEND_GET  then--服务器下发可赠送状态
                MiyouCC:req_miyou_sendGift(cell_index,self._roleid)
            elseif self._send_state ==  MiyouRow.CANNOT_SEND_GET then --不可赠送 
                ConfirmWin2:show( 3, nil, LangGameString[1561],  nil, nil, nil ) -- [1561]="           不可赠送"
            end
        else
            ConfirmWin2:show( 3, nil, LangGameString[1562],  nil, nil, nil ) -- [1562]="         请选择在线好友赠送"
        end
    end
    self.send_gift_btn = UIButton:create_button_with_name( 390, 6, -1, -1, UIResourcePath.FileLocate.common .. "button2.png", UIResourcePath.FileLocate.common .. "button2.png", nil, "", btn_friend_callback )
    self.view:addChild(self.send_gift_btn.view )
    self.send_btn_name_lable = UILabel:create_lable_2( LangGameString[1563], 33, 6, 16, ALIGN_CENTER ) -- [1563]="赠送"
    self.send_gift_btn.view:addChild( self.send_btn_name_lable )

    --自己可获得
    local my_words = UILabel:create_lable_2( LangGameString[1564], width-220, 12, 14, ALIGN_LEFT ) -- [1564]="#cffff00自己可获得："
    self.view:addChild(my_words )

    --领取btn
 	local function btn_my_callback()
        if self._get_state ==  MiyouRow.NEVER_SEND_GET then  
            MiyouCC:req_miyou_get(cell_index)
        elseif self._get_state ==  MiyouRow.CANNOT_SEND_GET then --不可领取 
            ConfirmWin2:show( 3, nil, LangGameString[1565],  nil, nil, nil ) -- [1565]="            不可领取"
        end
    end
    self.get_gift = UIButton:create_button_with_name( width - 65, 6, -1, -1, UIResourcePath.FileLocate.common .. "button2.png", UIResourcePath.FileLocate.common .. "button2.png", nil, "", btn_my_callback )
    self.view:addChild(self.get_gift.view )
    self.get_btn_name_lable = UILabel:create_lable_2( LangGameString[549], 33, 6, 16, ALIGN_CENTER ) -- [549]="领取"
    self.get_gift.view:addChild( self.get_btn_name_lable )

end

function MiyouRow:set_send_item_data( miyouRow_send_Data)

    if miyouRow_send_Data ~= nil then
        self._send_item_id = miyouRow_send_Data.itemID 
        self._send_item_num = miyouRow_send_Data.num
        self._send_state = miyouRow_send_Data.state
        self._SelRoleId = miyouRow_send_Data.roleID
    end
end

function MiyouRow:set_get_item_data( miyouRow_get_Data )

    if miyouRow_get_Data.itemID ~= nil then
        self._get_item_id = miyouRow_get_Data.itemID
        self._get_item_num = miyouRow_get_Data.num
        self._get_state = miyouRow_get_Data.state
    end
end

function MiyouRow:set_get_btn_state( state )
    self._get_state = MiyouRow.ALREADY_SEND_GET
end

function MiyouRow:set_send_btn_state( state )
    self._send_state = MiyouRow.ALREADY_SEND_GET
end

-- 设置赠送按钮状态
function MiyouRow:set_sendGift_btn_state( is_enable )
    if is_enable then 
        self.send_gift_btn.view:setCurState( CLICK_STATE_UP )
    else
        self.send_gift_btn.view:setCurState( CLICK_STATE_DISABLE )  
    end
end

-- 设置领取按钮状态
function MiyouRow:set_getGift_btn_state( is_enable )
    if is_enable then 
        self.get_gift.view:setCurState( CLICK_STATE_UP )
    else
        self.get_gift.view:setCurState( CLICK_STATE_DISABLE )  
    end
end

-- 设置下拉按钮状态
function MiyouRow:set_sendGift_Xialabtn_state( is_enable )
    if is_enable then 
        self.editBtn.view:setCurState( CLICK_STATE_UP )
    else
        self.editBtn.view:setCurState( CLICK_STATE_DISABLE )  
    end
end

function MiyouRow:is_Btn_Enable()
    
    local is_enable = false;
    if self.cell_index <= MiyouModel:get_continue_day() and self.cell_index < 9 then
        is_enable = true;
    end
    if self.cell_index == 9 and MiyouModel:get_miyou_15th() == true then 
        is_enable = true
    end
    return is_enable
end

function MiyouRow:set_sendGift_btn_Continue_state( is_enable )

    self:set_sendGift_btn_state(is_enable)
    self:set_sendGift_Xialabtn_state(is_enable)
    if is_enable == true then
        self:set_sendXialaText_Color(MiyouRow.WHITE)
    elseif is_enable == false then
        self:set_sendXialaText_Color(MiyouRow.GRAY)
    end
end


function MiyouRow:set_getGift_btn_Continue_state( is_enable )

    self:set_getGift_btn_state(is_enable)
end

-- 按钮赠送名称, 和位置
function MiyouRow:set_sendBtn_name( but_name, x, y )
    if but_name then
        self.send_btn_name_lable:setString( but_name )
    end
    if type(x) == "number" and type(y) == "number" then
        self.send_btn_name_lable:setPosition( x, y )
    end
end


-- 按钮领取名称, 和位置
function MiyouRow:set_getBtn_name( but_name, x, y )
    if but_name then
        self.get_btn_name_lable:setString( but_name )
    end
    if type(x) == "number" and type(y) == "number" then
        self.get_btn_name_lable:setPosition( x, y )
    end
end


function MiyouRow:setXialaText(roleID)
    self._roleid = roleID;
    local friend_info = FriendModel:get_my_friend_info(roleID)
    self._roleName = friend_info.roleName
    self.editBtn.view:removeChild( self.onlinePlayer ,true)
    self.onlinePlayer = UILabel:create_lable_2(self._roleName , 7, 6, 13, ALIGN_LEFT )
    self.editBtn.view:addChild( self.onlinePlayer )
end



function MiyouRow:set_sendXialaText_Color(COLOR)
    if self.onlinePlayer ~= nil then 
        self.editBtn.view:removeChild( self.onlinePlayer ,true)
    end
    local colorStr
    if COLOR == MiyouRow.GRAY then
        colorStr = "#c5f5f5f"
    elseif COLOR == MiyouRow.WHITE then
        colorStr = "#cffffff"
    end
    self.onlinePlayer = UILabel:create_lable_2( colorStr .. self._roleName, 7, 6, 13, ALIGN_LEFT )
    self.editBtn.view:addChild( self.onlinePlayer )
end


function MiyouRow:update(times)

    -- 更新赠送领取按钮状态
    local is_enable = self:is_Btn_Enable()
    self:set_sendGift_btn_Continue_state( is_enable )
    self:set_getGift_btn_Continue_state ( is_enable )

    ----------------------

    if self._get_state ==  MiyouRow.ALREADY_SEND_GET then --已经领取过
        self:set_getGift_btn_state(false)
        self:set_getBtn_name(LangGameString[550]) -- [550]="已领取"
    end
    if self._send_state ==  MiyouRow.ALREADY_SEND_GET then --已经赠送过
        self:set_sendGift_btn_state(false)
        self:set_sendGift_Xialabtn_state(false)
        self:set_sendBtn_name(LangGameString[1566]) -- [1566]="已赠送"
        self:set_sendXialaText_Color(MiyouRow.GRAY)
    end
    ----------------------
    if self._SelRoleId ~= nil then  --更新选择的好友昵称
        self:setXialaText(self._SelRoleId)--,self._sel_index
    end

    --赠送礼物的槽
    local function show_friend_item_tip( )
        ActivityModel:show_mall_tips( self._send_item_id )
    end
    self.send_item_solt = MUtils:create_slot_item(self.view,UIPIC_ITEMSLOT,206,1,48,48,nil, show_friend_item_tip);
    self.send_item_solt:set_icon(self._send_item_id)
    self.send_item_solt:set_click_event(show_friend_item_tip)
    self.send_item_solt:set_color_frame(self._send_item_id, -3, -3, 42, 42 );
    self.send_item_solt:set_setScale(0.75)
    self.send_item_solt:set_item_count(self._send_item_num)

    ----------------------

    --领取礼物的槽
    local function show_my_item_tip( )
        ActivityModel:show_mall_tips( self._get_item_id )
    end
    self.get_item_solt = MUtils:create_slot_item(self.view,UIPIC_ITEMSLOT,self._width-120,1,48,48,nil, show_my_item_tip);
    self.get_item_solt:set_icon(self._get_item_id)
    self.get_item_solt:set_click_event(show_my_item_tip)
    self.get_item_solt:set_color_frame(self._get_item_id, -3, -3, 42, 42 );
    self.get_item_solt:set_Scale(0.75)
    self.get_item_solt:set_item_count(self._get_item_num)
end

function MiyouRow:setRoleID(roleId)
    self._SelRoleId = roleId
end

function MiyouRow:set_click_friend_func( fn )
    self.click_friend_func = fn;
end

