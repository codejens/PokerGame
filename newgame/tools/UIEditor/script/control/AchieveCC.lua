-- AchieveCC.lua
-- created by charles on 2012-12-31
-- 仙宗系统

-- super_class.AchieveCC()
AchieveCC = {}

-- c->s 28,1  获取成就列表
function AchieveCC:request_achieve_info()
	-- print("request_achieve_info")
	local pack = NetManager:get_socket():alloc(28, 1)
	
	NetManager:get_socket():SendToSrv(pack)
end 

-- s->c 28,1 获取成就的列表
function AchieveCC:do_request_achieve_info( pack )
	 -- print("服务器下发成就列表");
	AchieveModel:init_achieve_info( pack );
end

-- c->s 28,2  申请领取成就的奖励
function AchieveCC:get_award( id )
	local pack = NetManager:get_socket():alloc(28, 2)
	pack:writeWord(id);
	NetManager:get_socket():SendToSrv(pack);
end 

-- s->c 28,2 完成一个成就
function AchieveCC:do_finish_achieve( pack )
	 -- print("完成一个成就");
	AchieveModel:finish_achieve( pack:readWord() );
end

-- s->c 28,3 成就的一个事件触发了
function AchieveCC:do_progress( pack )
	 -- print("成就的一个事件触发了")
	AchieveModel:update_progress( pack:readWord(), pack:readWord(), pack:readInt() );
end

-- s->c 28,4 领取奖励
function AchieveCC:do_get_award( pack )
	 -- print("领取成就奖励")
	local id = pack:readWord();
	local result = pack:readByte()
	-- print("AchieveCC:do_get_award id,result", id, result)
	if result == 1 then
		AchieveModel:get_award( id );
	end
end

-- c->s 28,5  申请领取成就点奖励
function AchieveCC:get_point_award()
	local pack = NetManager:get_socket():alloc(28, 5)
	NetManager:get_socket():SendToSrv(pack);
end

-- 获取自身的头顶显示称号(32个byte, 每个byte有8个称号)
function AchieveCC:do_self_title( pack )
	for i=0,31 do
		local byte = pack:readByte()
		if byte ~= 0 then
			for j=0,7 do
				local have = ZXLuaUtils:isSysEnabled(byte, j)
				if have == true then
					local title_index = i * 8 + j
					EntityManager:get_player_avatar():add_title(title_index)
				end
			end
		end
	end
end

-- AOI的玩家获得一个称号
function AchieveCC:do_add_avatar_title( pack )
	local handler 		= pack:readUint64()
	local title_index	= pack:readWord()
	local entity 		= EntityManager:get_entity(handler)
	if entity then
		if entity.type == -1 then
			entity:add_title(title_index, MountsModel:get_is_shangma())
		elseif entity.type == 0 then
			local is_shangma;
			if entity.mount and entity.mount > 0 then
				is_shangma = true;
			end
			entity:add_title(title_index, is_shangma);
		else
			entity:add_title(title_index)
		end
	end
end

-- AOI的玩家失去一个称号
function AchieveCC:do_remove_avatar_title( pack )
	local handler 		= pack:readUint64()
	local title_index	= pack:readWord()
	local entity 		= EntityManager:get_entity(handler)
	if entity then
		entity:remove_title(title_index)
	end
end