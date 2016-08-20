-- 新手副本(离线副本)
NewerCampCC = {}

function NewerCampCC:do_newercamp_progress(pack)
	-- current progress(1,2,3)
	local progress = pack:readInt()
	-- x position
	local posX	   = pack:readInt()
	-- y position
	local posY     = pack:readInt()

	NewerCampModel:init_by_progress(progress,posX,posY)

	-- 拿到进度之后,开始初始化怪物、任务、技能
end

-- 上报当前新进度 c-->s(158, 1)
function NewerCampCC:report_new_progress(progress)
	local pack = NetManager:get_socket():alloc(158,1)
	pack:writeInt(progress)
	NetManager:get_socket():SendToSrv(pack)
end

-- 请求离开新手体验副本
function NewerCampCC:request_exit_newercamp()
	local pack = NetManager:get_socket():alloc(158,2)
	NetManager:get_socket():SendToSrv(pack)
end