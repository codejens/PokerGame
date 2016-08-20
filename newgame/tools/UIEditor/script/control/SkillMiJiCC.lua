-- SkillMiJiCC.lua
-- created by tjh on 2014-6-3
-- 技能秘籍系统

SkillMiJiCC = {}

-- c->s 5,21 申请秘籍信息
function SkillMiJiCC:req_miji_info(  )
	print(" c->s 5,21 申请秘籍信息")
	local pack = NetManager:get_socket():alloc(5,21);
	NetManager:get_socket():SendToSrv(pack);
end

-- s->c 5,21 申请秘籍信息
function SkillMiJiCC:do_miji_info( pack )
	print(" s->c 5,21 下发秘籍信息")
	local mijiDate = MiJiStruct(pack)
	SkillMiJiModel:do_miji_info( mijiDate )
end

-- c->s 5,16 附带秘籍
function SkillMiJiCC:req_fudai_miji( guid )
	print("  c->s 5,16 附带秘籍",guid)
	local pack = NetManager:get_socket():alloc(5,16);
	pack:writeInt64(guid)
	NetManager:get_socket():SendToSrv(pack);
end

-- s->c 5,16 附带秘籍结果
function SkillMiJiCC:do_fudai_result( pack )
	print("  s->c 5,16 附带秘籍结果")
	local guid = pack:readInt64()
	local result =  pack:readByte()
	local fight = pack:readInt()
	local date = {result = result,skill_id =nil,guid = guid}
	SkillMiJiModel:do_fudai_miji( date )
end

-- c->s 5,17 卸载秘籍
function SkillMiJiCC:req_xiezai_miji( skill_id )
	print("  c->s 5,17 卸载秘籍")
	local pack = NetManager:get_socket():alloc(5,17);
	pack:writeWord(skill_id)
	NetManager:get_socket():SendToSrv(pack);
end

-- s->c 5,17 附带秘籍结果
function SkillMiJiCC:do_xiezai_result( pack )
	print("  s->c 5,17 卸载秘籍结果")
	local skill_id = pack:readWord()
	local result =  pack:readByte()
	local fight = pack:readInt()
 	local date = {result = result,skill_id =skill_id,guid = nil}
	SkillMiJiModel:do_xiaxia_miji(date)
end

-- c->s 5,18 升级秘籍
function SkillMiJiCC:req_shengji_miji( guid,items )
	print("  c->s 5,18 升级秘籍")
	local pack = NetManager:get_socket():alloc(5,18);
	pack:writeUint64(guid)

	local num = 0
	for i=1,#items do
		if items[i].guid then
			num = num + 1
		end
	end
	if num > 0 then
		pack:writeByte(num)
		if num > 0 then 
			for i=1,#items do
				if items[i].guid then
					pack:writeUint64(items[i].guid)
					pack:writeShort(items[i].count)
				end
			end
		end
		NetManager:get_socket():SendToSrv(pack);
	end
end

-- s->c 5,18 升级秘籍结果
function SkillMiJiCC:do_shengji_result( pack )
	print("  s->c 5,18 升级秘籍结果")
	local guid = pack:readInt64()
	local result =  pack:readByte()
	local fight = pack:readInt()
	 local date = {result = result,skill_id =nil,guid = guid}
	SkillMiJiModel:do_shengji_miji( date )
end

-- c->s 5,19 合成秘籍
function SkillMiJiCC:req_hecheng_miji( dest_guid,items )
	print("  c->s 5,18 合成秘籍")
	local pack = NetManager:get_socket():alloc(5,19);
	local num = 0
	for i=1,#items do
		if items[i].guid then
			num = num + 1
		end
	end
	pack:writeByte(num+1)
	pack:writeUint64(dest_guid)
	for i=1,num do
		if items[i].guid then
			pack:writeUint64(items[i].guid)
		end
	end
	NetManager:get_socket():SendToSrv(pack);
end

-- s->c 5,19 合成秘籍结果
function SkillMiJiCC:do_hecheng_result( pack )
	print("  s->c 5,19 合成秘籍结果")
	local result =  pack:readByte()
	local guid = pack:readInt64()
	local date = {result = result,skill_id =nil,guid = guid}
	 SkillMiJiModel:do_hecheng_miji( date )
end

-- c ->s 5，20 查看其他玩家秘籍
-- function SkillMiJiCC:req_look_others_miji( player_id,player_name)
-- 	local pack = NetManager:get_socket():alloc(5,20);
-- 	pack:writeInt(player_id)
-- 	pack:writeString(player_name)
-- 	NetManager:get_socket():SendToSrv(pack);
-- end

--s->c 5.20 下发其他玩家秘籍信息
-- function SkillMiJiCC:do_others_miji( pack )
-- 	local is_opensys = pack:readByte()
-- 	local jop = pack:readByte()
-- 	local fight = pack:readInt()
-- 	local skill_num = pack:readByte()
-- 	local miji_info = {}
-- 	for i=1,skill_num do
-- 		miji_info[i].skill_id = pack:readWord()
-- 		miji_info[i].skill_level = pack:readByte()
-- 		miji_info[i].is_have_miji = pack:readByte()
-- 		miji_info[i].userItem = UserItem(pack)
-- 	end
-- end