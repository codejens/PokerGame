-- PetStruct.lua
-- create by hcl on 2012-12-10
-- 宠物的数据结构

super_class.PetStruct()

require "struct/PetSkillStruct"

function PetStruct:__init( pack )
	if pack ~=nil then
		self.tab_attr = {};

		self.tab_attr[1] 	   		= pack:readInt() -- id
		-- print("-------------------------------------pet_id = ",self.tab_attr[1]);
		self.tab_attr[2] 			= pack:readInt() -- 怪物id
		self.tab_attr[3]				= pack:readInt() -- 生命值
		self.tab_attr[4]				= pack:readInt() -- 寿命
		self.tab_attr[5]				= pack:readInt() -- 快乐值
		self.tab_attr[6]				= pack:readInt() -- 等级
		self.tab_attr[7]				= pack:readInt() -- 战斗类型
		self.tab_attr[8]				= pack:readInt() -- 血包
		self.tab_attr[9]				= pack:readInt() -- 当前经验
		self.tab_attr[10]			= pack:readInt() -- 最大经验
		self.tab_attr[11]			= pack:readInt() -- 悟性
		self.curr_wx 			= ZXLuaUtils:lowByte(self.tab_attr[11]);
		self.high_wx 			= ZXLuaUtils:highByte(self.tab_attr[11]);
		self.tab_attr[12]			= pack:readInt() -- 成长值
		self.curr_grow 			= ZXLuaUtils:lowByte(self.tab_attr[12]);
		self.high_grow 			= ZXLuaUtils:highByte(self.tab_attr[12]);
		self.tab_attr[13] 			= pack:readInt() -- 宠物类型
		self.tab_attr[14]			= pack:readInt() -- 攻击类型
		self.tab_attr[15]			= pack:readInt() -- 等级称号
		self.tab_attr[16]			= pack:readInt() -- 兽阶称号
		-- 战斗属性
		self.tab_attr[17]			= pack:readInt() -- 最大血
		self.tab_attr[18]      		= pack:readInt() -- 攻击
		self.tab_attr[19]			= pack:readInt() -- 内防御
		self.tab_attr[20]			= pack:readInt() -- 外防御
		self.tab_attr[21]	        = pack:readInt() -- 暴击
		self.tab_attr[22]     		= pack:readInt() -- 命中
		self.tab_attr[23]			= pack:readInt() -- 闪避
		self.tab_attr[24]			= pack:readInt() -- 抗暴击
		-- 资质值
		self.tab_attr[25]			= pack:readInt() -- 攻击资质
		self.tab_attr[26]			= pack:readInt() -- 防御资质
		self.tab_attr[27]			= pack:readInt() -- 灵巧资质
		self.tab_attr[28]			= pack:readInt() -- 身法资质
		-- 基础资质
		self.tab_attr[29]			= pack:readInt() -- 攻击基础资质
		self.tab_attr[30]			= pack:readInt() -- 防御基础资质
		self.tab_attr[31]			= pack:readInt() -- 灵巧基础资质
		self.tab_attr[32]			= pack:readInt() -- 身法基础类型
		self.tab_attr[33]			= pack:readInt() -- 战斗力
		self.tab_attr[34]			= pack:readInt() -- 技能槽
		self.tab_attr[35] 			= pack:readInt() -- max
		self.base_name			= pack:readString() --名字
		-- 更新宠物名字颜色
		local pet_name_color = MUtils:get_pet_name_color( self );
		self.pet_name = pet_name_color .. self.base_name;
		self.pet_skill_num  	= pack:readInt() -- 技能数量
		-- print("------pet_struct---------");
		-- print("pet_id = ".. self.pet_id .. " pet_monser_id = " .. self.pet_monser_id .. " pet_hp = " .. self.pet_hp .. " pet_live = " .. self.pet_live .. " pet_funny = " .. self.pet_funny.. " pet_level = " .. self.pet_level.. " fight_type = " .. self.fight_type);
		-- print("hp_store = ".. self.hp_store .. " exp = " .. self.exp .. " exp2 = " .. self.exp2 .. " wx = " .. self.wx .. " grow = " .. self.grow);
		-- print("type = ".. self.type .. " attack_type = " .. self.attack_type .. " title_wx = " .. self.title_wx .. " title_grow = " .. self.title_grow .. " max_hp = " .. self.max_hp);
		-- print("attack = ".. self.attack .. " in_defen = " .. self.in_defen .. " out_defen = " .. self.out_defen .. " cri = " .. self.cri .. " hitrate = " .. self.hitrate);
		-- print("dod = ".. self.dod .. " def_cri = " .. self.def_cri .. " zz_attack = " .. self.zz0 .. " zz_defen = " .. self.zz1 .. " zz_lq = " .. self.zz2);
		-- print("zz_sf = ".. self.zz3 .. " zz_atk_base = " .. self.zzb0 .. " zz_def_base = " .. self.zzb1 .. " zz_lq_base = " .. self.zzb2 .. " zz_sf_base = " .. self.zzb3);
		-- print("zz_fight_v = ".. self.zz_fight_v .. " skill_slot = " .. self.skill_slot .." max = "..self.max .. " pet_name = " .. self.pet_name .. " pet_skill_num = " .. self.pet_skill_num );
		-- print("------pet_struct---------");
		self.tab_pet_skill_info = {};		 -- 当前宠物的技能数据表
		
		for i=1,self.pet_skill_num do
			self.tab_pet_skill_info[i] = PetSkillStruct(pack);
		end
		-- 添加宠物普通攻击
		self.normal_skill = PetSkillStruct(nil,78,0,0);
		-- print("\n");
		-- print("pet_id = " .. self.tab_attr[1]);
	end
	return self;
end
-- 添加一个技能到宠物技能表的最后
function PetStruct:addSkill( _skill_id,_skill_lv,_skill_keyin)
   -- require "struct/PetSkillStruct"
   
    local is_find = false;
    for i=1,#self.tab_pet_skill_info do
    	if ( self.tab_pet_skill_info[i].skill_id == _skill_id ) then
    		if( self.tab_pet_skill_info[i].skill_lv + 1 == _skill_lv ) then
    			self.tab_pet_skill_info[i].skill_lv = _skill_lv;
    			self.tab_pet_skill_info[i].skill_keyin = 0;
    			is_find = true;
    			return i;
    		end
    	end
    end
    local len = #self.tab_pet_skill_info + 1;
    if (not(is_find)) then 
    	self.tab_pet_skill_info[ len ] = PetSkillStruct(nil,_skill_id,_skill_lv,_skill_keyin);
	    -- 技能数加一
	    self.pet_skill_num = self.pet_skill_num + 1;
    end
    return self.pet_skill_num;
end

-- 删除指定索引的宠物技能表的技能
function PetStruct:deleteSkill(index)
	--print ("deleteSkill skill_id =" .. self.tab_pet_skill_info[index].skill_id);
	table.remove(self.tab_pet_skill_info,index);
	self.pet_skill_num = self.pet_skill_num - 1;
end

function PetStruct:updateWx()

	local old_value = self.tab_attr[15];
	self.curr_wx 			= ZXLuaUtils:lowByte(self.tab_attr[11]);
	self.high_wx 			= ZXLuaUtils:highByte(self.tab_attr[11]);
	if ( self.curr_wx >= 42 ) then
		self.tab_attr[15] = 4;
	elseif ( self.curr_wx >= 30 ) then
		self.tab_attr[15] = 3;
	elseif ( self.curr_wx >= 20 ) then
		self.tab_attr[15] = 2;
	elseif ( self.curr_wx >= 10 ) then
		self.tab_attr[15] = 1;
	else
		self.tab_attr[15] = 0;
	end
	-- 如果悟性等级发生变化
	if ( old_value ~= self.tab_attr[15] and PetModel:get_current_pet_id() == self.tab_attr[1] ) then
		local player_pet = EntityManager:get_player_pet();
		if player_pet then
			player_pet:update_pet_pj( self.tab_attr[15],self.tab_attr[16] );
		end
		
	end

end

function PetStruct:updateCz()
	local old_value = self.tab_attr[16];
	self.curr_grow 			= ZXLuaUtils:lowByte(self.tab_attr[12]);
	self.high_grow 			= ZXLuaUtils:highByte(self.tab_attr[12]);
	if ( self.curr_grow >= 42 ) then
		self.tab_attr[16] = 4;
	elseif ( self.curr_grow >= 30 ) then
		self.tab_attr[16] = 3;
	elseif ( self.curr_grow >= 20 ) then
		self.tab_attr[16] = 2;
	elseif ( self.curr_grow >= 10 ) then
		self.tab_attr[16] = 1;
	else
		self.tab_attr[16] = 0;
	end

	-- 如果成长等级发生变化
	if ( old_value ~= self.tab_attr[16] and PetModel:get_current_pet_id() == self.tab_attr[1] ) then
		local player_pet = EntityManager:get_player_pet();
		if ( player_pet ) then 
			player_pet:update_pet_pj( self.tab_attr[15],self.tab_attr[16] );
		end
	end
end

function PetStruct:update_pet_name_color()
	local name_color = MUtils:get_pet_name_color( self );
	self.pet_name = name_color .. self.base_name;
	local win = UIManager:find_visible_window("pet_win");
	if ( win ) then
		--print("更新名字和战斗力name_color = ",name_color);
		win:update_name_and_fight_value( self.tab_attr[1] );
	end
end

-- 更新宠物数据 并且更新相应的界面
function PetStruct:change_pet_attr( attr_id,attr_value,is_open_pet_win,is_fight_pet )
	--print("change_pet_attr:attr_id = ",attr_id,"attr_value",attr_value);
	local old_value = self.tab_attr[attr_id]
	self.tab_attr[attr_id] = attr_value;
	if ( attr_id == 11 ) then
		self:updateWx()
	elseif ( attr_id == 12 ) then
		self:updateCz()
	-- 因为宠物融合成功后会发29-32
	elseif ( attr_id == 32 ) then
		-- 资质改变时要更新宠物名字颜色
		self:update_pet_name_color()
	end
	-- 宠物界面是否打开
	if ( is_open_pet_win ) then
		local curr_pet_info = PetWin:get_current_pet_info();
		-- 如果pet_id 等于 当前选中的id
		if ( self.tab_attr[1] == curr_pet_info.tab_attr[1]  ) then
			local pet_win = UIManager:find_visible_window("pet_win");
			if ( pet_win ) then
				if ( attr_id == 3 ) then 
					pet_win:cb_change_pet_attr( attr_id,attr_value,self.tab_attr[17] );
				elseif ( attr_id == 17 ) then
					pet_win:cb_change_pet_attr( 3,self.tab_attr[3],attr_value );
				elseif ( attr_id == 9 ) then
					pet_win:cb_change_pet_attr( attr_id,attr_value,PetConfig:get_exp_by_lv(self.tab_attr[6]) );
				-- 更新战斗力
				elseif ( attr_id == 33 ) then
					pet_win:cb_change_pet_attr( attr_id,self.tab_attr[1])
				else
					pet_win:cb_change_pet_attr( attr_id,attr_value ,old_value);
				end
			end
		end
	end
	if ( is_fight_pet ) then
		-- 战斗类型变化
		if (  attr_id == 7 ) then
			local win = UIManager:find_window("user_panel");
			if ( win ) then
				-- 更新宠物战斗类型
				win:set_pet_fight_type( attr_value );
				-- 更新宠物ai
				PetAI:set_fight_type( attr_value );
			end
		end
		-- 快乐度变化
		if (  attr_id == 5 ) then
			local win = UIManager:find_window("user_panel");
			if ( win ) then
				-- 更新宠物快乐度
				win:update_pet( 3,{ attr_value,100 } );
			end
		end
	end
end

function PetStruct:update_pet_name( pet_name )
	self.base_name = pet_name;
	local name_color = MUtils:get_pet_name_color( self );
	self.pet_name = name_color .. self.base_name;
end