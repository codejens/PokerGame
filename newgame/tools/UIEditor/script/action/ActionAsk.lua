-- ActionAsk.lua
-- created by hcl on 2013-1-24
-- 主角通过协议访问npc

ActionAsk = simple_class(ActionBase)
-- require "action/ActionBase"

function ActionAsk:__init(npc_name,str)
	ActionBase.__init(self)
	
	self.npc_name = npc_name;
	self.content = str;
	self.is_need_duration = false;
end

function ActionAsk:do_action(  )
	print("-----------------------------ActionAsk:do_action(  )------------------------------",self.npc_name );
	-- local npc_handle = EntityManager:get_handler( self.npc_name );
    
    --added by xiehande 2014-12-26 添加王城之主判断
	local get_entities  = EntityManager:get_entities()
	local temp_array = {}
	for handler,entity in pairs(get_entities) do
		if entity.name == self.npc_name then
			temp_array[handler] = entity
		end
	end
  
  local   count = 0
  for k,v in pairs(temp_array) do
  	count = count+1
  end

  local npc_handle  = nil
	if count ==2 then
	-- 解决王城之主本人与雕像同时存在引起的雕像NPC对话不了的问题
    --其他情况不会出现名字重叠问题
	   for  handler_t,entity_t in pairs(temp_array) do
	   	 	if entity_t.npc_name ==nil then
	  	    else
	  	       npc_handle = handler_t
	  	       break
	  	    end
	   end
	elseif count ==1 then
	  	npc_handle = EntityManager:get_handler(self.npc_name);
	elseif count>2 then
		print("出问题，有三个以上相同名字的人物或NPC")
	else
		print("出问题，没有相应的NPC")
		npc_handle = EntityManager:get_handler(self.npc_name);
	end

	if (npc_handle ) then
		-- 成功
		self.npc_handle = npc_handle;	
		self:end_action()
	else
		-- 失败
		self:stop_action(  )
	end
--	print("ActionAsk:do_action(  )", self.state)
	return self.state
end

function ActionAsk:_on_end(  )
	-- print("-----------------------------ActionAsk:_on_end(self.npc_handle, self.content)",self.npc_handle, self.content);
	GameLogicCC:req_talk_to_npc( self.npc_handle, self.content );
end

function ActionAsk:_on_fail(  )
end
