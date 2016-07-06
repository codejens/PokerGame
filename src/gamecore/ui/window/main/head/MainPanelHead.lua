--MainPanelHead.lua
--created by liubo on 2015-05-14
--主界面头像模块

MainPanelHead = simple_class(GUIStudioView)

local _LAYOUT_FILE = "layout/studio/mainpanel/head/stu_mainpanel_head.lua"     -- 本页的布局文件

---对外接口---

--头像点击回调
local function user_cb_func()
    MainPanelCC:user_cb()
end

--------------

function MainPanelHead:__init( view )
    self:register_listener()
end

--初始化页
function MainPanelHead:viewCreateCompleted() 
	self.view:setPosition(0,542)
	self.icon_bg = self:findLayoutViewByName("P_Icon_Bg") --图标背景
    self.head_bg = self:findLayoutViewByName("P_Head") --头像模块背景
    self.head_btn = self:findLayoutViewByName("B_USer") --用户头像按钮
    self.hp = self:findLayoutViewByName("LB_HP") --生命值进度条
    self.hp_text = self:findLayoutViewByName("T_HP") --生命值文本
    self.mp = self:findLayoutViewByName("LB_MP") --内力值进度条
    self.role_name = self:findLayoutViewByName("T_Role_Name") --角色名文本
    self.level = self:findLayoutViewByName("T_Level") --等级文本
    self.anger_bg = self:findLayoutViewByName("I_User_Bg") --怒气背景

    self:create_fighting_label()
    self:create_anger()
end

-- 注册事件回调
function MainPanelHead:register_listener( ... )

    --头像监听
    local function cb_func( sender,eventType )
        if eventType == ccui.TouchEventType.ended then
             user_cb_func()
        end
    end 
    self:widgetTouchEventListener('B_User',cb_func)
end

-- 创建接口
function MainPanelHead:create(  )
	return self:createWithLayout( _LAYOUT_FILE )
end

--创建战斗力组件
function MainPanelHead:create_fighting_label()
    self.fighting = FightingLabel:create()
    self.head_bg:addChild(self.fighting.view)
    self.fighting:setBgPosition(135, 28)
end

--创建怒气控件
function MainPanelHead:create_anger()
    self.anger = ProgressExpand:create(_PATH_MAIN_PANEL_ANGER, cc.PROGRESS_TIMER_TYPE_RADIAL, 
        false, 0, 0.5, 0.2, 1, 1, 0, 0)
    self.anger:setPosition(3, 5)
    self.anger_bg:addChild(self.anger.view)
end

--设置战斗力
function MainPanelHead:set_fighting(fighting_value)
    self.fighting:setString(fighting_value)
end

--设置用户头像
function MainPanelHead:set_user_avatar(path)
	if path then
    	self.head_btn:loadTexture(path)
    end
end

--设置生命值
function MainPanelHead:set_hp(current_value,max_value)
    self.hp:setPercent((current_value / max_value) * 100)
    self.hp_text:setString(current_value .. "/" .. max_value)
end

--设置内力值
function MainPanelHead:set_mp(current_value,max_value)
    self.mp:setPercent((current_value / max_value) * 100)
end

--设置名字
function MainPanelHead:set_name(name)
    self.role_name:setString(name)
end

--设置等级
function MainPanelHead:set_level(level_value)
    self.level:setString(level_value)
end

--设置怒气
function MainPanelHead:set_anger(value)
    self.anger:setPercentage(value)
    --self.anger:setActionPercentage(2,value)
end

-- 更新
-- @param update_type 更新类型
-- @param data 更新的数据 
function MainPanelHead:update( update_type, data )
	if update_type == "fighting" then
        self:set_fighting(data.fightValue)
    elseif update_type == "avatar" then
    	self:set_user_avatar()
    elseif update_type == "hp" then
    	self:set_hp(data.hp,data.maxHp)
    elseif update_type == "mp" then
    	self:set_mp(data.mp,data.maxMp)
    elseif update_type == "name" then
    	self:set_name(data.name)
    elseif update_type == "level" then
    	self:set_level(data.level)
    elseif update_type == "anger" then
    	self:set_anger(data.anger)
    elseif update_type == "all" then
    	self:set_fighting(data.fightValue)
    	self:set_user_avatar()
    	self:set_hp(data.hp,data.maxHp)
    	self:set_mp(data.mp,data.maxMp)
    	self:set_name(data.name)
    	self:set_level(data.level)
    	self:set_anger(data.anger)
    else

	end
end

--- 变成激活（显示）情况调用
function MainPanelHead:active(  )

end

-- 变成 非激活
function MainPanelHead:unActive(  )

end