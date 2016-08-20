-- ActionGuaji.lua
-- created by hcl on 2013-1-27
-- 主角通过协议采集

--super_class.ActionGuaji(ActionBase)
ActionGuaji = simple_class(ActionBase)

-- require "action/ActionBase"

function ActionGuaji:__init()
	ActionBase.__init(self)
end


function ActionGuaji:do_action(  )
	self:end_action()
	return self.state;
end

function ActionGuaji:_on_end(  )
	--print("ActionGuaji:_on_end")
	AIManager:set_state( AIConfig.COMMAND_GUAJI );
end

function ActionGuaji:_on_fail(  )
end
