-- DFTZJStruct.lua
-- create by hcl on 2013-1-14
-- 宠物的数据结构

super_class.DFTZJStruct()

local function create_str( _type,result ,enemy_name,result_top )
	local base_str = "";

	if ( _type == 0 ) then
		if ( result == 0 ) then
			base_str = Lang.doufatai[16]..enemy_name..Lang.doufatai[17]; -- [523]="#c66ff66你挑战#cfff000" -- [524]="#c66ff66失败了,排名不变"
		elseif ( result == 1 ) then
			base_str = Lang.doufatai[16]..enemy_name..Lang.doufatai[18]..result_top..Lang.doufatai[19]; -- [523]="#c66ff66你挑战#cfff000" -- [525]="#c66ff66成功了,排名上升至#cfff000" -- [526]="#c66ff66位."
		elseif ( result == 2 ) then
			
		elseif ( result == 3 ) then
			base_str = Lang.doufatai[16]..enemy_name..Lang.doufatai[20]; -- [523]="#c66ff66你挑战#cfff000" -- [527]="#c66ff66成功了,排名不变"
		end
	else
		if ( result == 0 ) then
			base_str = Lang.doufatai[21].. enemy_name..Lang.doufatai[22]..result_top..Lang.doufatai[19]; -- [528]="#c66ff66你被#cfff000" -- [529]="#c66ff66击败了,排名下降至#cfff000" -- [526]="#c66ff66位."
		elseif ( result == 1 ) then
			base_str = "#cfff000".. enemy_name..Lang.doufatai[23]; -- [530]="#c66ff66挑战你#c66ff66失败了,排名不变"
		elseif ( result == 2 ) then
		
		elseif ( result == 4 ) then
			base_str = Lang.doufatai[21].. enemy_name..Lang.doufatai[24]; -- [528]="#c66ff66你被#cfff000" -- [531]="#c66ff66击败了,排名不变"
		end
	end

	return base_str;
end

function DFTZJStruct:__init( pack )
	self.time		 = pack:readInt();		--时间
	self.type		 = pack:readInt();		--类型，0表示挑战，1表示被挑战
	self.result		 = pack:readInt();		--结果,0表示失败，1表示胜利，2表示排名被抢，3挑战排名比自己低的玩家胜利后排名不变，4被挑战且自己失败了排名不变
	self.result_top	 = pack:readInt();		--结果排名
	self.enemy_id	 = pack:readInt();		--对手id
	self.enemy_clan	 = pack:readInt();		--对手阵营
	self.enemy_sex 	 = pack:readInt();		--对手性别
	self.enemy_job	 = pack:readInt();		--对手职业
	self.enemy_lv	 = pack:readInt();		--对手等级
	self.enemy_name  = pack:readString();	--对手名字
	--local time_str = Utils:get_custom_format_time("%Y年%m月%d日 %H时%M分" ,self.time )
	--print("DFTZJStruct:time:",time_str);
	-- 直接在这里生成好字符串
	self.str = create_str(self.type,self.result,self.enemy_name,self.result_top);
	-- print("type = ",self.type,"result = ",self.result,"result_top",self.result_top);
	-- print("self.str",self.str);
end

