-- TransformIconCell.lua
-- created by mwy on 2014-5-26
-- 精灵显示单个icon

super_class.TransformIconCell(  )


function TransformIconCell:__init( x, y,width,height,skill_text,skill_level,callback )
    local pos_x = x or 0
    local pos_y = y or 0
    self.view = CCBasePanel:panelWithFile( pos_x, pos_y, width, height, nil, 500, 500 )  
    local bg = CCBasePanel:panelWithFile( 0, 15, width, height-30, nil, 500, 500 ) 
    self.view:addChild(bg)

    ZImage:create(self.view, "ui/common/jgt_line.png", 0, 0, width, 3, 1)

    self.skill_lab = ZLabel.new(skill_text)
    -- self.skill_lab.view:setAnchorPoint(CCPointMake(0.5, 0.5))
    self.skill_lab:setFontSize(18)
    self.skill_lab:setPosition(60+40, 38)
    bg:addChild(self.skill_lab.view)

    ZImage:create(bg, "ui/transform/new24.png", 92, -8, -1, -1, 0, 500, 500)

    self.skill_level = ZLabel.new(skill_level)
    self.skill_level.view:setAnchorPoint(CCPointMake(1.0, 0))
    self.skill_level:setFontSize(15)
    self.skill_level:setPosition(width-20, 0)
    bg:addChild(self.skill_level.view)

    -- slot
    self.item = MUtils:create_one_slotItem( nil, 20, 18, 72, 72 );
    local function tip_func(  )
       callback()
    end
    self.item:set_click_event(tip_func)
    self.view:addChild(self.item.view)
    -- self.item:set_color_frame( 38202, -2, -2, 68, 68)

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

    self.selected = MUtils:create_zximg(self.view, "ui/transform/new28.png", 0, 0, width, height, 500, 500)
    self.selected:setIsVisible(false)
    -- self.view:addChild(self.selected)

   return self.view
end

-- 设置slot的图标
function TransformIconCell:set_item_texture(icon_texture)
    self.item:set_icon_texture( icon_texture )
end

function TransformIconCell:set_icon( item_id )
    self.item:set_icon(item_id)
end
-- 设置cell的文本
function TransformIconCell:set_item_text(text)
    self.skill_lab:setText( string.format("%s%s", "#cfff000", text) )
end

function TransformIconCell:set_item_level( level )
    if not level or level == 0 then
        self.skill_level:setText("#cfff未激活")
    elseif level == 10 then
        self.skill_level:setText(level .. "阶（满）")
    else
        self.skill_level:setText(level .. "阶")
    end
end

function TransformIconCell:set_level_text( str )
    self.skill_level:setText(str)
end

function TransformIconCell:set_selected( flag )
    self.selected:setIsVisible(flag)
end