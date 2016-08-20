-- NinjiaIconHead.lua
-- created by mwy on 2014-5-27
-- 忍者头像icon

super_class.NinjiaIconHead(  )


function NinjiaIconHead:__init( data, x, y, w, h, callback )
    local pos_x = x or 0
    local pos_y = y or 0
    self.model_id = data.id

    self.view = CCBasePanel:panelWithFile( pos_x, pos_y, w, h, nil, 500, 500 )  

    local function click_fun(eventType,arg,msgid,selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if  eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_CLICK then
            callback()
            return true;
        end
        return true;
    end
    self.view:registerScriptHandler(click_fun)

    ZImage:create(self.view, "ui/common/jgt_line.png", 0, 0, w, 3, 1)

    -- 匹配
    local icon_path = "icon/bianshen/"..TransformConfig:get_ninja_modelid_by_id( self.model_id )..".pd"
    -- slot
    self.item = self:create_slot_item( nil, 40, 40, 64, 64 );

    local function tip_func(  )
       callback(self.model_id,self.item)
    end
    self.item:set_click_event(tip_func);
    self.view:addChild(self.item.view);
    self.item:set_icon_texture(icon_path)

    local rowBg = ZImage:create(nil, "ui/common/ht_bg.png", 20, 5, 90, 36, 0, 500, 500).view
    self.view:addChild(rowBg)

    self.name = ZLabel.new(data.name)
    self.name:setFontSize(16)
    self.name.view:setAnchorPoint(CCPointMake(0.5, 0.5))
    self.name:setPosition(90/2, 44/2)
    rowBg:addChild(self.name.view)

    self.actived_panel = ZImage:create(nil, nil, 0, 0, w, h, 0).view
    self.actived_panel:setIsVisible(false)
    self.view:addChild(self.actived_panel)

    ZImage:create(self.actived_panel, "ui/transform/new1.png", 124, 60, -1, -1, 0)

    self.fight_val = ZLabel.new("+0")
    self.fight_val:setFontSize(20)
    self.fight_val:setPosition(220, 30)
    self.actived_panel:addChild(self.fight_val.view)

    self.inactive_panel = ZImage:create(nil, nil, 0, 0, w, h, 0).view
    self.view:addChild(self.inactive_panel)

    ZImage:create(self.inactive_panel, "ui/transform/new2.png", 158, 64, -1, -1, 0)

    -- self.get_way = ZLabel.new("")
    -- self.get_way:setFontSize(15)
    -- self.get_way:setPosition(126+78, 30)
    -- self.get_way.view:setAnchorPoint(CCPointMake(0.5, 0))
    -- self.inactive_panel:addChild(self.get_way.view)

    self.getway = ZDialog.new( "", 180, 40, 50, 15 )
    self.getway:setPosition(120, 20)
    self.view:addChild(self.getway.view)
    self.getway.view:registerScriptHandler(click_fun)
    self.getway.view:setMessageCut(true)

    self.selected = MUtils:create_zximg(self.view, "ui/transform/new28.png", 0, 0, w, h, 500, 500)
    self.selected:setIsVisible(false)

   return self.view,self.item
end

function NinjiaIconHead:set_name( name )
    self.name:setText(name or "")
end

function NinjiaIconHead:set_icon_texture()
    -- self.match_btn
end

function NinjiaIconHead:set_selected( flag )
    self.selected:setIsVisible(flag)
end

function NinjiaIconHead:set_enable( flag )
    if flag then
        self.item:set_icon_light_color()
        self.actived_panel:setIsVisible(true)
        self.inactive_panel:setIsVisible(false)
        self.getway.view:setIsVisible(false)
    else
        self.item:set_icon_dead_color()
        self.actived_panel:setIsVisible(false)
        self.inactive_panel:setIsVisible(true)
        self.getway.view:setIsVisible(true)
    end
end

function NinjiaIconHead:set_fight_val( text )
    self.fight_val:setText(text)
end

function NinjiaIconHead:set_get_way( text )
    -- self.get_way:setText(text)
    self.getway:setText(text)
end

function NinjiaIconHead:create_slot_item( father, pos_x, pos_y, width, height, item_id )
    local _width  = width or 64
    local _height = height or 64
    local slot_item = SlotItem( _width, _height );

    -- slot_item:set_icon_bg_texture( "ui/guild/family_47.png", -7.5, -7.5, _width+15, _height+15 )
    slot_item.icon_bg = ZImage.new("ui/guild/family_47.png").view
    slot_item.icon_bg:setAnchorPoint(0.5, 0.5)
    slot_item.icon_bg:setPosition(width/2, height/2)
    slot_item.view:addChild(slot_item.icon_bg)

    slot_item:setPosition( pos_x, pos_y )
--    slot_item.view:setAnchorPoint( 0.5,0.5 )

    -- slot_item:set_color_frame( item_id, -4, -4, _width+8, _height+8 )
    --slot_item.color_frame = CCZXImage:imageWithFile(-4, -4, width+8, height+8, nil)
    --slot_item.view:addChild(slot_item.color_frame, 9)

    slot_item.view:setScale( 0.8 )

    if item_id then
        slot_item:set_icon( item_id )
        slot_item.item_id = item_id;
    end

    if father then
        father:addChild( slot_item.view )
    end

    return slot_item;
end