-- ActionCallBack.lua
-- created by hcl on 2013-3-7
-- 用于主角做完action后的callback

ActionCallBack = simple_class(ActionBase)

function ActionCallBack:__init( cb )
	self.cb = cb
end


function ActionCallBack:do_action(  )
	self:end_action()
	return self.state;
end

function ActionCallBack:_on_end(  )
	self.cb();
end

function ActionCallBack:_on_fail(  )

end
