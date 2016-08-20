-- TransformCC.lua
-- created by aXing on 2014-5-8
-- 变身系统协议

TransformCC = {}

-- 申请变身系统初始化
function TransformCC:request_init(  )
	-- print("*********** TransformCC:request_init, 44 1")
	NetManager:get_socket():SendCmdToSrv(44, 1)
end

-- 申请激活变身
-- @param id : 变身id
function TransformCC:request_active_transform( id )
	local pack = NetManager:get_socket():alloc(44, 2)
	pack:writeWord(id)
	NetManager:get_socket():SendToSrv(pack)
end

-- 申请变身
-- @param id : 变身id
function TransformCC:request_transform( id )
	-- ZXLog('----------申请变身id---------------',id)
	local pack = NetManager:get_socket():alloc(44, 3)
	pack:writeWord(id)
	NetManager:get_socket():SendToSrv(pack)
end

-- 申请还原变身
-- @param id : 变身id 
-- 44,6
function TransformCC:request_recover_transform( )
	local pack = NetManager:get_socket():alloc(44, 6)
	NetManager:get_socket():SendToSrv(pack)
end


-- 申请变身培养
-- @param id : 申请培养的变身id
function TransformCC:request_develop( id )
	local pack = NetManager:get_socket():alloc(44, 4)
	pack:writeWord(id)
	NetManager:get_socket():SendToSrv(pack)
end

-- 申请秘籍进阶
-- @param id : 秘籍id
-- @param id : 是否动购买
function TransformCC:request_upgrade_skill( id,auto, money_type )
	local _auto = 0
	if auto then
		_auto=1
	else
		_auto=0
	end
	-- print("====request_upgrade_skill: ", id, _auto, money_type)
	local pack = NetManager:get_socket():alloc(44, 5)
	pack:writeWord(id)
	pack:writeByte(_auto)
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack)
end

-- 变身系统初始化
function TransformCC:do_init( pack )
	--解析变身信息结构
	local transform_info = transformStruct(pack);
	TransformModel:set_transform_data(transform_info)
end

-- 更新或添加某个变身数据
--44,2返回协议
function TransformCC:do_change_data( pack )
	local is_added = pack:readChar()	-- 0 表示更新， 1 表示添加
	local id 	   = pack:readWord()	--变身ID
	local level    = pack:readByte()    --变身等级，为0时为激活状态
	local pieces   = pack:readByte()
	local info     = pack:readInt()
	local stage    = Utils:low_word(info) 
	local stage_level    = Utils:high_word(info)
	local fight_val = pack:readInt()

	if is_added== 1 then
		-- ZXLog('---添加某个变身数据-----id,level,pieces,stage,stage_level----fight_val------------',id,level,pieces,stage,stage_level, fight_val)
		TransformModel:add_data(id,level,pieces,stage,stage_level,fight_val)
	else
		-- ZXLog('----更新某个变身数据-----id,level,pieces,stage,stage_level---------fight_val-------',id,level,pieces,stage,stage_level, fight_val)
		TransformModel:change_data(id,level,pieces,stage,stage_level,fight_val)
	end
end

-- 进阶结果
--44,3
function TransformCC:do_result_upgrade_stage( pack )
	local id 	= pack:readWord()		-- 变身id
	local level	= pack:readWord()		-- 变身等级
	local count	= pack:readWord()		-- 变身祝福值
	TransformModel:result_upgrade_stage(id, level, count)
end

-- 培养结果
--44,4
function TransformCC:do_result_develop( pack )
	local id 	= pack:readWord()		-- 变身id
	local info     = pack:readInt()
	local stage    = Utils:low_word(info) 
	local stage_level    = Utils:high_word(info)		-- 等级
	TransformModel:result_develop(id, stage_level, stage)     -- 阶级
end

-- 技能提升结果
--44,5
function TransformCC:do_result_upgrade_skill( pack )
	local skill_id	    = pack:readWord()		-- 技能id
	local skill_lvl     = pack:readWord()		-- 技能等级
	local skill_zhufu	= pack:readWord()	    -- 技能祝福
	TransformModel:result_upgrade_skill( skill_id, skill_lvl, skill_zhufu)
end

-- 获取总评分
--44,6
function TransformCC:do_get_total_point( pack )
	local point = pack:readInt()
	TransformModel:result_get_total_point(point)
end

-- 获取到一个新技能
--44,7
function TransformCC:do_get_new_skill( pack )
	local skill_id	    = pack:readWord()		-- 技能id
	local skill_lvl     = pack:readChar()		-- 技能等级
	local skill_zhufu	= pack:readWord()	    -- 技能祝福
	TransformModel:do_get_new_skill(skill_id,skill_lvl,skill_zhufu)
end

-- 获取开启变身系统的倒计时信息
-- s-->c (44,9)
function TransformCC:do_get_count_down( pack )
	-- 获取当前倒计时状态 0:倒计时结束,可以开启变身系统
	-- -1:未开启倒计时 -2:变身已开启，不需要倒计时了
	-- > 0 表示剩余倒计时时间数
	local curState		= pack:readInt()
	TransformModel:do_get_count_down( curState )
	-- if curState == 0 then
	-- 	TransformCC:request_begin_count_down( 2 );
	-- end
end

-- 请求开始进行变身倒计时
-- c-->s (44,7), countType == 1 : 开启倒计时, countType == 2 : 开启变身系统
function TransformCC:request_begin_count_down( countType )
	local pack = NetManager:get_socket():alloc(44, 7)
	pack:writeInt( countType )
	NetManager:get_socket():SendToSrv(pack)
end

-- 服务器返回申请开启变身系统
-- s--c (44,10)
function TransformCC:do_get_transform_system( pack )
	local result = pack:readInt();

	-- result为0: 成功开启变身系统
	if result == 0 then
		TransformModel:do_get_transform_system();
	end
end

-- 客户端请求体验变身
-- c-->s (44,9)
function TransformCC:request_experience_transform(experience_type)
	-- experience_type : 1-->副本体验  2-->体验卡
	local pack = NetManager:get_socket():alloc( 44, 9 );
	pack:writeChar( experience_type );
	NetManager:get_socket():SendToSrv( pack );
end

-- 客户端请求结束变身体验
-- c-->s (44,8)
function TransformCC:request_over_transform_experience()
	local pack = NetManager:get_socket():alloc( 44, 8 );
	NetManager:get_socket():SendToSrv( pack );
end

-- 下发单个变身或秘籍的评分
-- s->c
function TransformCC:do_get_point( pack )
	local super_or_miji = pack:readByte()
	local id = pack:readWord()
	local point = pack:readInt()
	if super_or_miji == 0 then
		TransformModel:set_transform_point_by_id( id, point )
	elseif super_or_miji == 1 then
		TransformModel:set_miji_point_by_id( id, point )
	end
end

-- 请求当前剩余的开启变身系统的倒计时时间
function TransformCC:request_transform_countdown()
	local pack = NetManager:get_socket():alloc(44, 10)
	NetManager:get_socket():SendToSrv(pack)
end