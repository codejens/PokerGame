require "gamecore.control.RoleCC"
require "gamecore.control.GameLogicCC"
require "gamecore.control.BagCC"
require "gamecore.control.DefaultSystemCC"
require "gamecore.control.EntityLogicCC"
require "gamecore.control.MoveSystemCC"
require "gamecore.control.CommonCC"
require "gamecore.control.MainPanelCC"
require "gamecore.control.RegisterCC"
require "gamecore.control.SkillSystemCC"
require "gamecore.control.ModalCC"
require "gamecore.control.ClickMenuCC"
require "gamecore.control.TaskCC"

--- 注册协议处理函数
local function register_protocol(  )
	BagCC:register_protocol(  )
	RoleCC:register_protocol()
end

register_protocol()