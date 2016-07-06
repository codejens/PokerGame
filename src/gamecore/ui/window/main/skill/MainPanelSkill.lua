--MainPanelSkill.lua
--created by liubo on 2015-05-14
--主界面技能模块

MainPanelSkill = simple_class(GUIStudioView)

local _LAYOUT_FILE = "layout/studio/mainpanel/skill/stu_mainpanel_skill.lua"     -- 本页的布局文件

---对外接口---

--技能点击回调
local function skill_cn_func(index)
    MainPanelCC:skill_cb(index)
end

--主要攻击点击回调
local function inevitable_cb_func()
    MainPanelCC:inevitable_cb()
end

--------------

function MainPanelSkill:__init( view )
	self.skill_bg = {}
	self:register_listener()
end

--初始化页
function MainPanelSkill:viewCreateCompleted() 
	self.view:setPosition(750,20)
    for i = 1, 4 do
        self.skill_bg[i] = self:findLayoutViewByName("I_Skill_Bg_" .. i)
    end
    self.attack_bg = self:findLayoutViewByName("I_Attack_Bg")
end

-- 注册事件回调
function MainPanelSkill:register_listener( ... )
	--技能点击监听
    for i = 1,4 do
        local function cb_func_skill( sender,eventType )
            if eventType == ccui.TouchEventType.ended then
                skill_cn_func(i)
            end
        end 
        self:widgetTouchEventListener('I_Skill_Bg_' .. i,cb_func_skill)
    end

    --主要攻击监听
    local function cb_func_3( sender,eventType )
            if eventType == ccui.TouchEventType.ended then
                inevitable_cb_func()
            end
        end 
    self:widgetTouchEventListener('I_Attack_Bg',cb_func_3)
end

-- 创建接口
function MainPanelSkill:create(  )
	return self:createWithLayout( _LAYOUT_FILE )
end

-- 更新
-- @param update_type 更新类型
-- @param data 更新的数据 
function MainPanelSkill:update( update_type, data )
	if update_type == "skill" then 
        
    elseif update_type == "attack" then 

	end
end

--- 变成激活（显示）情况调用
function MainPanelSkill:active(  )

end

-- 变成 非激活
function MainPanelSkill:unActive(  )

end