-- ActionGather.lua
-- created by hcl on 2013-1-27
-- 主角通过协议采集

ActionGather = simple_class(ActionBase)
--super_class.ActionGather(ActionBase)

-- require "action/ActionBase"
local currGatherCount=0

function ActionGather:__init(target_name,x,y,direction,gatherTime,gatherCount)
	ActionBase.__init(self)
	self.priority 	= ActionConfig.PRIORITY_NONE
	self.can_break	= true
	self.target_name = target_name;
	self.x = x;
	self.y = y; 
	self.direction = direction;
	self.gatherTime = gatherTime;
	self.gatherCount = gatherCount;

	self.is_start = false;
	if ( self.gatherCount >= 1 ) then 
		--生成一个timer
		self.gatherActionTimer = timer()
	end	

	-- 如果当前正在上坐骑的话，就先下坐骑
	if ( ZXLuaUtils:band( self.player.state , EntityConfig.ACTOR_STATE_RIDE) > 0 ) then
		-- 下坐骑
		MountsModel:ride_a_mount( )
	end
end

function ActionGather:do_action(  )
	self.target_handle = EntityManager:find_nearest_target( 12 ,false )
	if ( self.target_handle ) then
		if (self.is_start == false) then
			self.duration = (self.gatherTime + 1) * self.gatherCount * 1000 + 0.2;
			currGatherCount = 1;
			OthersCC:req_collection( self.target_handle,self.x,self.y,self.direction );
			-- 显示进度条
			--ProcessBar:show(self.gatherTime);
			if ( self.gatherCount >= 1 ) then
				-- time秒后消失
				local function dismiss( dt )
					if ( currGatherCount > self.gatherCount ) then
						OthersCC:req_collection( 0 );
						return
					end
					OthersCC:req_collection( self.target_handle,self.x,self.y,self.direction );
					-- 显示进度条
					--ProcessBar:show(self.gatherTime);
					-- self.currGatherCount = self.currGatherCount + 1;
				end
				self.gatherActionTimer:start(self.gatherTime +1, dismiss)
			end			
			self.is_start = true;
		end
	end
	return ActionBase.do_action( self )
end

 function ActionGather:do_secces_gather(  )
 	currGatherCount = currGatherCount + 1;
 end

function ActionGather:_on_end(  )
	--ProcessBar:hide();
	if ( self.gatherActionTimer ) then 
		self.gatherActionTimer:stop()
	end
--	AIManager:set_state( AIConfig.COMMAND_IDLE );
	-- print("结束采集=-===========================================",self.target_name)
end

function ActionGather:_on_fail(  )
	-- print("[ActionGather]没有找到采集对象",self.target_name);
	-- 请求停止采集
	OthersCC:req_collection( 0 )

	--ProcessBar:hide();
	if ( self.gatherActionTimer ) then 
		self.gatherActionTimer:stop()
	end
--	AIManager:set_state( AIConfig.COMMAND_IDLE ); 
	--OthersCC:req_collection( 0 );
end
