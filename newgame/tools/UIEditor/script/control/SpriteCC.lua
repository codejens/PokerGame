-- SpriteCC.lua
-- created by mwy on 2014-5-12
-- 精灵实体对象逻辑处理类

SpriteCC = {}


-- 获取式神
-- c->s 45,1
-- get_type:0免费,1元宝
function SpriteCC:req_fabao( get_type )
	local pack = NetManager:get_socket():alloc(45, 1)
	pack:writeChar(get_type);
	NetManager:get_socket():SendToSrv(pack)
end

-- s->c 45,2 获取精灵信息
function SpriteCC:do_sprite_info( pack )
	print("++++++++++++++++++++++++SpriteCC:do_sprite_info( pack )")
	local hasSprite = pack:readChar(); --是否有精灵
	--排行版查看
	local top_list_win = UIManager:find_visible_window("top_list_win")
	--聊天框超链查看
	local chat_win = UIManager:find_visible_window("chat_win")
	local sprite_info = SpriteStruct(pack);
	if top_list_win ~= nil or chat_win ~= nil then
		--查看其他人式神	
		if sprite_info then
			SpriteModel:show_other_sprite_by_info(sprite_info)
		end
	else
		if hasSprite == 1 then
		    --填充到model里去
			SpriteModel:set_has_sprite(true);
			SpriteModel:set_sprite_info(sprite_info);
		else
			SpriteModel:set_has_sprite(false);
		end
	end
end

-- c->s 45,2 请求其他玩家精灵信息
-- check other sprite info
-- @pram id,name:玩家id，玩家名字
function SpriteCC:send_check_other_sprite( id, name )
	-- print("SpriteCC:send_check_other_sprite( id, name )",id,name)
	local pack = NetManager:get_socket():alloc(45,2);
	pack:writeInt(id)
	pack:writeString(name)
	NetManager:get_socket():SendToSrv(pack);	
end


-- 使用法宝晶石提升法宝, 发送后，服务器通过45,3协议来更新法宝的信息
-- c->s 45,3
-- gem_type:	晶石类型，1=初级晶石, 2=中级晶石, 3=高级晶石
-- used_yb:		是否使用元宝提升
function SpriteCC:req_fabao_uplevel( gem_type, used_yb, money_type )
	local pack = NetManager:get_socket():alloc(45, 3)
	pack:writeByte(gem_type);
	pack:writeByte(used_yb);
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack)
end

-- 通过45,3协议来更新法宝的信息
-- s->c 45,3
function SpriteCC:do_sprite_up_level_info (pack)
	local got_exp     = pack:readInt();	   --获得经验
	local level       = pack:readInt();    --当前等级
	local current_exp = pack:readInt();	   --当前经验

	SpriteModel:do_up_sprite_exp(got_exp,level,current_exp)
end

-- 通过45,9协议来更新精灵4个基本属性的信息
-- s->c 45,9
function SpriteCC:do_sprite_info_change (pack)
	local life    	= pack:readInt();	   --生命
	local attack    = pack:readInt();      --攻击
	local w_def 	= pack:readInt();	   --物防
	local m_def 	= pack:readInt();	   --魔防	
	-- ZXLog("--------------SpriteCC:do_sprite_info_change-------------",life,attack,w_def,m_def)
	SpriteModel:do_sprite_info_change(life,attack,w_def,m_def)
end

-- 使用晶石升级等阶
-- c->s 45,4
-- used_yb:		是否使用元宝提升
function SpriteCC:req_upgrade_stage(used_yb, money_type)
	print("used_yb",used_yb)
	local pack = NetManager:get_socket():alloc(45, 4)
	local t = 0
	if used_yb == true then
		t = 1
	end
	pack:writeByte(t);
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack)
end

-- 通过45,4协议来更新升级等阶回调
-- s->c
function SpriteCC:do_upgrade_stage_change (pack)
	-- ZXLog("----------do_upgrade_stage_change----------",pack)
	local result    	= pack:readChar();	   --进阶结果
	local stage    		= pack:readInt();      --阶级
	local star_level 	= pack:readInt();	   --星级
	local bless 		= pack:readInt();	   --当前祝福值	
	-- print("--------------SpriteCC:do_upgrade_stage_change-------------result,stage,star_level,bless",result,stage,star_level,bless)
	SpriteModel:do_upgrade_stage_change(result,stage,star_level,bless)
end

--化形，model_id 哪一阶的外观 	
--c->s 45,5

function SpriteCC:request_sprite_huaxing(rebirth_level) 
	print("---------SpriteCC:request_sprite_huaxing(rebirth_level) ",rebirth_level)
	local pack = NetManager:get_socket():alloc(45,5)
	pack:writeInt(rebirth_level)
	NetManager:get_socket():SendToSrv(pack)
end

--升阶成功返回一个打开的技能
-- 或者45,6协议返回数据
--45,6
function SpriteCC.do_upgrade_skill_change(self,pack)
	local skill_index    	= pack:readInt();	   --技能序号
	local got_exp    		= pack:readInt();      --获得熟炼度
	local current_level 	= pack:readInt();	   --当前等级
	local current_exp 		= pack:readInt();	   --当前熟炼度

	-- ZXLog("----------技能序号,获得熟炼度,当前等级,当前熟炼度----------",skill_index,got_exp,current_level,current_exp)

	SpriteModel:do_upgrade_skill_change(skill_index,got_exp,current_level,current_exp)
end

-- 45.6, C->S
-- 升级翅膀技能
-- which_skill(int): 升的是哪个技能
function SpriteCC:req_wing_skill(which_skill,auto_buy, money_type)
	local pack = NetManager:get_socket():alloc (45, 6);
	pack:writeInt(which_skill);
	pack:writeChar(auto_buy);
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);
end
-- 45.7, C->S
-- 请求升级轮回阶级
function SpriteCC:req_upgrade_lunhui_stage()
	-- body
	local pack = NetManager:get_socket():alloc (45, 7);
	NetManager:get_socket():SendToSrv(pack);
end

-- 45.7, S->C
-- 请求升级轮回阶级结果返回
function SpriteCC:do_lunhui_stage_change(pack)
	-- body
	local stage    		= pack:readInt();        --轮回转数阶级
	local star_level 	= pack:readInt();	     --当前星级
	-- ZXLog("--------------SpriteCC:do_lunhui_stage_change-------------",stage,star_level)
	SpriteModel:do_lunhui_stage_change(stage,star_level)
end

-- 45.8, C->S
-- 请求装备强化
-- 参数：1.装备序号、2.强化类型(1仙币、2仙币20次、3元宝)
function SpriteCC:req_upgrade_equip_stage(which_skill,which_type, money_type)
	local pack = NetManager:get_socket():alloc (45, 8);
	pack:writeInt(which_skill);
	pack:writeChar(which_type);
	pack:writeByte(money_type)
	NetManager:get_socket():SendToSrv(pack);

end

-- 45.8, S->C
-- 请求装备强化返回
function SpriteCC:do_equip_stage_change(pack)
	-- body
	local equip_index   		= pack:readInt();        --装备序号
	local get_shanyao_exp 		= pack:readInt();	     --获得闪耀值
	local curr_shanyao_level 	= pack:readInt();	     --当前闪耀级别
	local curr_shanyao_exp 		= pack:readInt();	     --当前闪耀值
	print("dgaf");
	SpriteModel:do_equip_stage_change(equip_index,get_shanyao_exp,curr_shanyao_level,curr_shanyao_exp)
end
-- 45.12, S->C
-- 每次元宝强化精灵技能次数发生变化时下发
function SpriteCC:do_equip_upstage_times_change(pack)
	-- body
	local upstage_times   	= pack:readInt();        --可以元宝强化的次数
	SpriteModel:do_equip_upstage_times_change(upstage_times)
end

-- 45.5, S->C
-- 模型id改变
function SpriteCC.do_sprite_model_change(self,pack)
	local model_id   	= pack:readInt();
	print("SpriteCC.do_sprite_model_change(model_id)",model_id)
	SpriteModel:do_sprite_model_change(model_id)
end

-- 45.10, S->C
-- 战力改变
 function SpriteCC:do_sprite_fight_value_change(pack)
 	local fight_value   	= pack:readInt();
	SpriteModel:do_sprite_fight_value_change(fight_value)
 end

-- 45.11, S->C
--暴击改变
 function SpriteCC:do_sprite_baoji_value_change(pack)
 	local baoji_type  	= pack:readChar();
	SpriteModel:do_sprite_baoji_value_change(baoji_type)
 end

 --45,13 s->c 服务器下发式神领取状态
 --@params
 --is_free_get 是否已免费领取
 --is_vip_get 是否vip领取
 function SpriteCC:do_get_sprite_condition(pack)
 	local is_free_get		= pack:readChar()
 	local is_vip_get 		= pack:readChar()
 	-- print("------------><SpriteCC:do_get_sprite_condition(pack)",is_free_get,is_vip_get)
 	SpriteModel:set_get_sprite_status(is_free_get,is_vip_get)
 end