-- ActionDaPaoPao.lua
-- created by hcl on 2013-3-7
-- 主角打泡泡

--super_class.ActionDaPaoPao(ActionBase)
ActionDaPaoPao = simple_class(ActionBase)

function ActionDaPaoPao:__init()
	ActionBase.__init(self)
	self.is_need_duration 	= false
end


function ActionDaPaoPao:do_action(  )
	print(" ActionDaPaoPao:do_action...................")
	self:end_action()
	return self.state;
end

function ActionDaPaoPao:_on_end(  )
	print(" ActionDaPaoPao:_on_end...................")
	require "model/XianYuModel"
	XianYuModel:AI_play_action_callback();
end

function ActionDaPaoPao:_on_fail(  )
end
