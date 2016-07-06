--MainPanelWin.lua
--created by liubo on 2015-04-27
--主界面窗口

require "gamecore.ui.window.main.bag.MainPanelBag"              --背包
require "gamecore.ui.window.main.chat.MainPanelChat"            --聊天
require "gamecore.ui.window.main.exp.MainPanelExp"              --经验
require "gamecore.ui.window.main.head.MainPanelHead"            --头部
require "gamecore.ui.window.main.icon.MainPanelIcon"            --图标
require "gamecore.ui.window.main.map.MainPanelMap"              --地图
require "gamecore.ui.window.main.skill.MainPanelSkill"          --技能
require "gamecore.ui.window.main.task.MainPanelTask"            --任务
require "gamecore.ui.window.main.joystick.MainPanelJoystick"    --摇杆

MainPanelWin = simple_class(GUIWindow)

--模块索引
local _MODULES = {
    bag = MainPanelBag,
    chat = MainPanelChat,
    exp = MainPanelExp,
    head = MainPanelHead,
    icon = MainPanelIcon,
    map = MainPanelMap,
    skill = MainPanelSkill,
    task = MainPanelTask,
    joystick = MainPanelJoystick,
}

---对外接口---

--------------

--构造函数
function MainPanelWin:__init( view )
    self.modules = {} --模块
end

--初始化窗口
function MainPanelWin:viewCreateCompleted()
    GUIWindow.viewCreateCompleted(self)

    self:create_all_block()
    
    self:register_listener()
end

--创建所有模块
function MainPanelWin:create_all_block()
    for k,v in pairs(_MODULES) do
        self.modules[k] = v:create()
        self:addChild(self.modules[k])
    end
end


--注册监听
function MainPanelWin:register_listener( ... )

end

-- 更新
-- @param block_name 模块名字
-- @param update_type 更新类型
-- @param data 更新的数据 
function MainPanelWin:update(block_name, update_type, data)
    local modules = self.modules[block_name]
    if modules then
        modules:update(update_type, data)
    end
end

--- 变成激活（显示）情况调用
function MainPanelWin:active(  )

end

-- 变成 非激活
function MainPanelWin:unActive(  )
 
end