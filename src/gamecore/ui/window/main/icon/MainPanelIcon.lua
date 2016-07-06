--MainPanelIcon.lua
--created by liubo on 2015-05-14
--主界面图标模块

MainPanelIcon = simple_class(GUIStudioView)

local _LAYOUT_FILE = "layout/studio/mainpanel/icon/stu_mainpanel_icon.lua"     -- 本页的布局文件

---对外接口---

--图标点击回调
local function icon_cb_func(id)
    MainPanelCC:icon_cb(id)
end

--------------

function MainPanelIcon:__init( view )
	self.btn_icon = {}
end

--初始化页
function MainPanelIcon:viewCreateCompleted() 
	self.view:setPosition(520,488)
	self.icon_bg = self:findLayoutViewByName("P_Icon_Bg") --图标背景
end

-- 创建接口
function MainPanelIcon:create(  )
	return self:createWithLayout( _LAYOUT_FILE )
end

--更新图标组
function MainPanelIcon:update_icon_group(data)
    local bg_width = self.icon_bg:getContentSize().width
    local bg_height = self.icon_bg:getContentSize().height

    local begin_x = bg_width - 40       --起始X轴坐标
    local begin_y = bg_height - 40      --起始Y轴坐标
    local row_num = 3                   --每行坐标数量
    local interval = 75                 --每个图标之间的间隔
    local pos_x, pos_y = 0, 0

    for _,v in ipairs(self.btn_icon) do
        v.bg:removeFromParent()
    end
    self.btn_icon = {}
    for i,v in ipairs(data) do
        pos_x = begin_x - ((i - 1) % row_num) * interval
        pos_y = begin_y - math.floor((i - 1) / row_num) * interval
        self.btn_icon[i] = self:create_one_icon(pos_x, pos_y, v.normal_path, v.press_path, v.msg_text)
        local function cb_func( sender,eventType )
            if eventType == ccui.TouchEventType.ended then
                icon_cb_func(v.id)
            end
        end 
        self.btn_icon[i].btn:addTouchEventListener(cb_func)

        self.icon_bg:addChild(self.btn_icon[i].bg.view)
    end
end

--创建图标
function MainPanelIcon:create_one_icon(pos_x, pos_y, normal_path, press_path, msg_text)
    local icon = {}
    icon.bg = GUIImg:create(_PATH_MAIN_PANEL_ACTIVITY_BG)
    icon.msg_bg = GUIImg:create(_PATH_MAIN_PANEL_PROMPT_BG)
    icon.msg = GUIText:create(msg_text or "", FONT_SIZE_14, cc.TEXT_ALIGNMENT_CENTER)
    icon.btn = GUIButton:create(normal_path)
    icon.btn:setTexturePressed(press_path)
    icon.btn:setAnchorPoint(0, 0)
    icon.bg:setPosition(pos_x, pos_y)
    icon.msg_bg:setAnchorPoint(0, 0)
    icon.msg_bg:setPosition(42, 42)
    icon.msg:setAnchorPoint(0, 0)
    icon.msg:setPosition(8, 8)
    icon.bg:addChild(icon.btn)
    icon.msg_bg:addChild(icon.msg)
    icon.bg:addChild(icon.msg_bg)
    icon.msg_bg:setVisible(msg_text == true)
    return icon
end

--设置图标背景
function MainPanelIcon:set_icon_bg(index, texture)
    local icon = self.btn_icon[index]
    if not icon then
        return
    end
    icon.bg:loadTexture(texture)
end

--设置图标
function MainPanelIcon:set_icon(index, normal_path, press_path)
    local icon = self.btn_icon[index]
    if not icon then
        return
    end
    icon.btn:setTextureNormal(normal_path)
    icon.btn:setTexturePressed(press_path)
end

--设置图标消息
function MainPanelIcon:set_icon_msg(index, msg_text)
    local icon = self.btn_icon[index]
    if not icon then
        return
    end
    icon.msg:setString(msg_text)
end

--设置图标背景
function MainPanelIcon:set_icon_msg_bg(index, texture)
    local icon = self.btn_icon[index]
    if not icon then
        return
    end
    icon.msg_bg:loadTexture(texture)
end

--设置图标消息的显示状态
function MainPanelIcon:set_icon_msg_bg_state(index, state)
    local icon = self.btn_icon[index]
    if not icon then
        return
    end
    icon.msg_bg:setVisible(state)
end

--设置图标的显示状态
function MainPanelIcon:se_icont_bg_state(index, state)
    local icon = self.btn_icon[index]
    if not icon then
        return
    end
    icon.bg:setVisible(state)
end

-- 更新
-- @param update_type 更新类型
-- @param data 更新的数据 
function MainPanelIcon:update( update_type, data )
	if update_type == "group" then 
        self:update_icon_group(data)
    else

	end
end

--- 变成激活（显示）情况调用
function MainPanelIcon:active(  )

end

-- 变成 非激活
function MainPanelIcon:unActive(  )

end