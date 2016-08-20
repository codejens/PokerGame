-- ZhenYaoTaCC.lua
-- created by tjh on 2014-5-23
-- 镇妖塔

ZhenYaoTaCC = {}

--c->s 48,5 请求玩家通关信息
function ZhenYaoTaCC:req_player_clearance_info(  )
	--print("--请求玩家通关信息")
	local pack = NetManager:get_socket():alloc(48, 5)
	
	NetManager:get_socket():SendToSrv(pack)
end

--s->c 48,5 下发玩家通关信息
function ZhenYaoTaCC:do_player_clearance_info( pack )
	--print("--下发玩家通关信息")
	local date = {}
	date.max_floor  = pack:readInt()  --最大通关层
	date.my_floor 	 = pack:readInt()  --我的楼层
	date.time       = pack:readInt()  --通关时间

	ZhenYaoTaModel:set_player_clearance_info( date)
end

--c->s 48,6 请求进入副本
function ZhenYaoTaCC:req_enter_fuben( index )
	--print("--请求进入副本",index)
	local pack = NetManager:get_socket():alloc(48, 6)
	pack:writeInt(index)
	NetManager:get_socket():SendToSrv(pack)
end

--c->s 48,7 请求进入下一关
function ZhenYaoTaCC:req_next_fuben(  )
	--print("--请求进入下一关")
	local pack = NetManager:get_socket():alloc(48, 7)
	NetManager:get_socket():SendToSrv(pack)
end

--c->s 48,8 重新挑战
function ZhenYaoTaCC:req_again_challenge(  )
	--print("--c->s 48,8重新挑战")
	local pack = NetManager:get_socket():alloc(48, 8)
	NetManager:get_socket():SendToSrv(pack)
end

--s->c 48,9 下发挑战成功结果
function ZhenYaoTaCC:do_challenge_result( pack )
	--print("s->c 48,9 下发挑战成功结果")
	local challengeResults = ZYTChallengeResultsStruct(pack)
	ZhenYaoTaModel:set_challenge_result( challengeResults )
end

--s->c 48,10 下发挑战失败结果
function ZhenYaoTaCC:do_challenge_fail( pack )
	--print("s->c 48,10 下发挑战失败结果")
	ZhenYaoTaModel:challenge_fail(  )

end
--s->c 48,11 下发层主改变
function ZhenYaoTaCC:do_floor_master_change( pack )
	--print("s->c 48,11 下发层主改变")
	local floor_index  = pack:readInt()  --层数
	local name = pack:readString()   --名字
	ZhenYaoTaModel:floor_master_change( floor_index,name)
end

--c->s 48,12 查看所有层主
function ZhenYaoTaCC:req_floor_master(  )
	--print("---c->s 48,12 查看所有层主")
	local pack = NetManager:get_socket():alloc(48, 12)
	NetManager:get_socket():SendToSrv(pack)
end

--s->c 48,12 下发所有层主
function ZhenYaoTaCC:do_floor_master( pack )
	--print("--s->c 48,12 下发所有层主")
	local count = pack:readInt()  --层主数量
	local floor_master = {}
	for i=1,count do
		floor_master[i]= {}
		floor_master[i].name = pack:readString()   --名字
		floor_master[i].user_id = pack:readInt()   --角色ID
		floor_master[i].sex = pack:readInt()      --角色性别
		floor_master[i].head_id = pack:readInt()   --角色头像ID
		floor_master[i].time = pack:readInt()    --用时
		-- print("第",i,"层",floor_master[i].name,floor_master[i].time)
	end

	ZhenYaoTaModel:set_floor_master(floor_master)
end