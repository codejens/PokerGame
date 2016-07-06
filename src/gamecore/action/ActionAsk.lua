-- ActionAsk.lua
-- created by hcl on 2013-1-24
-- 主角通过协议访问npc

ActionAsk = simple_class(ActionBase)

function ActionAsk:__init(npc_name)
	self.npc_name = npc_name;
end

function ActionAsk:do_action(  )
	
	local npc_handle = EntityManager:get_handler( self.npc_name );

	if (npc_handle ) then
		-- 成功
		self.npc_handle = npc_handle;	
		self:end_action()
	else
		-- 失败
		self:stop_action(  )
	end

	return self.state
end

function ActionAsk:_on_end(  )
	TaskCC:req_talk_to_npc( self.npc_handle, self.content );
end

function ActionAsk:_on_fail(  )
end
