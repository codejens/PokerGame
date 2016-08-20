-- PetConfig.lua
-- create by hcl on 2012-12-26
-- 读取宠物系统配置

-- require "../data/std_pet"
-- require "../data/std_items"

-- super_class.PetConfig();

PetConfig = {}

--取得提升悟性需要的信息
function PetConfig:get_wxtisheng_info_by_level(lv, p_s)
	require "../data/std_pet"
	local tab = {};
	local curr_lv = lv - 1;
	local next_lv = lv;
	local pet_attrs = p_s.tab_attr;
	-- 如果满级
	if ( lv == 51) then 
		tab.lv_need = LangGameString[289]; -- [289]="悟性已经是满级"
		tab.lv_rate = nil;
		tab.money = nil;
		-- 显示50级的数值
		curr_lv = 50;
		next_lv = curr_lv;
	else
		if ( lv < 10) then
			tab.lv_need = LangGameString[290]; -- [290]="升级需要初级悟性丹"
		elseif (lv < 20) then
			tab.lv_need = LangGameString[291]; -- [291]="升级需要中级悟性丹"
		elseif (lv < 30) then
			tab.lv_need = LangGameString[292]; -- [292]="升级需要高级悟性丹"
		elseif (lv < 41) then
			tab.lv_need = LangGameString[293]; -- [293]="升级需要特级悟性丹"
		elseif (lv < 51) then
			tab.lv_need = LangGameString[294]; -- [294]="升级需要完美悟性丹"
		end

		tab.lv_rate = std_pet.wxLevelRate[lv];
		tab.money = std_pet.wxMoney[lv];

		tab.wxd_item_id = std_pet.wxItemId[lv];
		tab.bhd_item_id = nil;
		tab.wxd_num = ItemModel:get_item_count_by_id( tab.wxd_item_id );

		-- 暂时先这样 静态表或者网页版有错
		if (lv >=12) then
			tab.bhd_item_id = std_pet.wxPro[ lv ]
			if ( tab.bhd_item_id ~= 0) then
				tab.bhd_num = ItemModel:get_item_count_by_id( tab.bhd_item_id );
			end
		end
		
	end

	
	tab.tab_attr = {};
	tab.tab_attr2 = {};
	tab.tab_attr3 = {};

	local n = 0;
	local next_n = 0;
	if ( curr_lv > 41 ) then
		n = 0.5;
		next_n = 0.5;
	elseif ( curr_lv > 29) then
		n = 0.3;
		if (curr_lv == 41) then
			next_n = 0.5;
		else
			next_n = n;
		end
	elseif ( curr_lv > 19) then
		n = 0.15;
		if (curr_lv == 29) then
			next_n = 0.3;
		else
			next_n = n;
		end
	elseif ( curr_lv > 9) then
		n = 0.05;
		if (curr_lv == 19) then
			next_n = 0.15;
		else
			next_n = n;
		end
	else
		if (curr_lv == 9) then
			next_n = 0.05;
		else
			next_n = n;
		end
	end
	-- 物理攻击，物理防御，法术防御，暴击，命中，闪避，抗暴击，生命
	local zz_tab = { pet_attrs[25],pet_attrs[26],pet_attrs[26],pet_attrs[28],pet_attrs[28],pet_attrs[27],pet_attrs[27],pet_attrs[26] };
	-- 计算属性值
	for i=1,8 do
		--string.format("%s%05d.png", icon_path, item.icon)
		local base_value = zz_tab[i] * std_pet.zzRate[i] * pet_attrs[6];
		local color = "#c00ff12+";
		local num0 = math.floor( base_value + std_pet.typeVal[1][i] );
		local num1 = math.floor( base_value * ( curr_lv * 0.02 + n ) );
		local num2 =  math.floor( base_value * ( next_lv  * 0.02 + next_n ) );
		tab.tab_attr[i] = tostring(num0) ;
		tab.tab_attr2[i] = color .. num1;
		tab.tab_attr3[i] = color .. num2;
		
	end
	
	return tab;
end

-- 取得悟性丹数量
function PetConfig:get_wx_item_count_by_wx_lv( wx_lv )
	print("wx_lv",wx_lv);
	local wxd_item_id = std_pet.wxItemId[wx_lv];
	print("wxd_item_id",wxd_item_id);
	local bhd_item_id = nil;
	local wxd_num = ItemModel:get_item_count_by_id( wxd_item_id );
	local bhd_num = nil;

	-- 暂时先这样 静态表或者网页版有错
	if (wx_lv >=12) then
		bhd_item_id = std_pet.wxPro[ wx_lv ]
		if ( bhd_item_id ~= 0) then
			bhd_num = ItemModel:get_item_count_by_id( bhd_item_id );
		end
	end
	return wxd_num,bhd_num;
end
-- 取得成长丹和保护珠的数量
function PetConfig:get_cz_item_count_by_cz_lv( cz_lv )
	local czd_item_id = std_pet.growItemId[cz_lv];

	local bhd_item_id = nil;
	local czd_num = ItemModel:get_item_count_by_id( czd_item_id );
	local bhd_num = nil;

	-- 暂时先这样 静态表或者网页版有错
	if (cz_lv >=12) then
		bhd_item_id = std_pet.growPro[ cz_lv ]
		if ( bhd_item_id ~= 0) then
			bhd_num = ItemModel:get_item_count_by_id( bhd_item_id );
		end
	end
	return czd_num,bhd_num;	
end

-- 取得悟性丹item_id
function PetConfig:get_wxd_item_id(wx_value)
	require "../data/std_pet"
	wx_value = math.min(wx_value,50);
	local wxd_id = std_pet.wxItemId[wx_value ];
	return wxd_id
end
-- 取得悟性保护丹item_id
function PetConfig:get_wxbhd_item_id(wx_value)
	require "../data/std_pet"
	wx_value = math.min(wx_value,50);
	local wxbhd_id = std_pet.wxPro[wx_value ];
	return wxbhd_id
end
-- 取得成长丹item_id
function PetConfig:get_czd_item_id(cz_value)
	require "../data/std_pet"
	cz_value = math.min(cz_value,50);
	local czd_id = std_pet.growItemId[cz_value ];
	return czd_id
end
-- 取得成长保护丹item_id
function PetConfig:get_czbhd_item_id(cz_value)
	require "../data/std_pet"
	cz_value = math.min(cz_value,50);
	local czbhd_id = std_pet.growPro[cz_value ];
	return czbhd_id
end

-- 取得提升成长需要的信息
function PetConfig:get_cztisheng_info_by_level(lv, p_s)
	require "../data/std_pet"
	local tab = {};
	local curr_lv = lv - 1;
	local next_lv = lv;
	local pet_attrs = p_s.tab_attr;
	-- 如果满级
	if ( lv == 51) then 
		tab.lv_need = LangGameString[295]; -- [295]="成长已经是满级"
		tab.lv_rate = nil;
		tab.money = nil;
		-- 显示50级的数值
		curr_lv = 50;
		next_lv = curr_lv;
	else
		if ( lv < 10) then
			tab.lv_need = LangGameString[296]; -- [296]="升级需要初级成长丹"
		elseif (lv < 20) then
			tab.lv_need = LangGameString[297]; -- [297]="升级需要中级成长丹"
		elseif (lv <30) then
			tab.lv_need = LangGameString[298]; -- [298]="升级需要高级成长丹"
		elseif (lv < 41) then
			tab.lv_need = LangGameString[299]; -- [299]="升级需要特级成长丹"
		elseif (lv < 51) then
			tab.lv_need = LangGameString[300]; -- [300]="升级需要完美成长丹"
		end

		tab.lv_rate = std_pet.growLevelRate[lv];
		tab.money = std_pet.growMoney[lv];

		tab.wxd_item_id = std_pet.growItemId[lv];
		tab.wxd_num = ItemModel:get_item_count_by_id( tab.wxd_item_id );
		tab.bhd_item_id = nil;
		
		-- 暂时先这样 静态表或者网页版有错
		if (lv >=12) then
			tab.bhd_item_id =  std_pet.growPro[ lv ];
			if (  tab.bhd_item_id ~= 0) then
				tab.bhd_num = ItemModel:get_item_count_by_id( tab.bhd_item_id );
			end
		end
		
	end

	tab.tab_attr = {};
	tab.tab_attr2 = {};
	tab.tab_attr3 = {}; 

	local n = 0;
	local next_n = 0;
	if ( curr_lv > 41 ) then
		n = 500;
		next_n = 500;
	elseif ( curr_lv > 29) then
		n = 300;
		if (curr_lv == 41) then
			next_n = 500;
		else
			next_n = n;
		end
	elseif ( curr_lv > 19) then
		n = 150;
		if (curr_lv == 29) then
			next_n = 300;
		else
			next_n = n;
		end
	elseif ( curr_lv > 9) then
		n = 50;
		if (curr_lv == 19) then
			next_n = 150;
		else
			next_n = n;
		end
	else
		if (curr_lv == 9) then
			next_n = 50;
		else
			next_n = n;
		end
	end
	local zz_tab = { pet_attrs[29],pet_attrs[30],pet_attrs[31],pet_attrs[32]};
	-- 计算属性值
	for i=1,4 do

		local base_value = zz_tab[i] ;
		local color = "#c66ff66+";
		local num0 = math.floor( base_value);
		local num1 = math.floor( base_value * ( curr_lv *  std_pet.growRate ) ) + n;
		local num2 = math.floor(base_value * ( next_lv  * std_pet.growRate ) )  + next_n;
		tab.tab_attr[i] = tostring(num0) ;
		tab.tab_attr2[i] = color .. num1;
		tab.tab_attr3[i] = color .. num2;
		
	end
	
	return tab;
end

local pet_skill_data = 
{ [1] = {  [1] = 18904,  [2] = 18908,  [3] = 18912,  [4] = 18916,  [5] = 18920,  [6] = 18924,  [7] = 18928,  [8] = 18932,  [9] = 18936,  [10] = 18944,  [11] = 18948,  [12] = 18952,  [13] = 18956,  [14] = 18960,  [15] = 18964,  [16] = 18968,  [17] = 18980,  [18] = 18996,  [19] = 28900,  [20] = 18900,  [21] = 18940,   [22] = 18988, }
, [2] = {  [1] = 18905,  [2] = 18909,  [3] = 18913,  [4] = 18917,  [5] = 18921,  [6] = 18925,  [7] = 18929,  [8] = 18933,  [9] = 18937,  [10] = 18945,  [11] = 18949,  [12] = 18953,  [13] = 18957,  [14] = 18961,  [15] = 18965,  [16] = 18969,  [17] = 18981,  [18] = 18997,  [19] = 28901,  [20] = 18901,  [21] = 18941,   [22] = 18989,}
, [3] = {  [1] = 18906,  [2] = 18910,  [3] = 18914,  [4] = 18918,  [5] = 18922,  [6] = 18926,  [7] = 18930,  [8] = 18934,  [9] = 18938,  [10] = 18946,  [11] = 18950,  [12] = 18954,  [13] = 18958,  [14] = 18962,  [15] = 18966,  [16] = 18970,  [17] = 18982,  [18] = 18998,  [19] = 28902,  [20] = 18902,  [21] = 18942,   [22] = 18990,}
, [4] = {  [1] = 18907,  [2] = 18911,  [3] = 18915,  [4] = 18919,  [5] = 18923,  [6] = 18927,  [7] = 18931,  [8] = 18935,  [9] = 18939,  [10] = 18947,  [11] = 18951,  [12] = 18955,  [13] = 18959,  [14] = 18963,  [15] = 18967,  [16] = 18971,  [17] = 18983,  [18] = 18999,  [19] = 28903,  [20] = 18903,  [21] = 18943,   [22] = 18991,}
, }

-- 取得宠物技能书等级数据
function PetConfig:get_skill_book_lv()
	return pet_skill_data;
end

-- 取得宠物唤魂玉的item_id
function PetConfig:get_hhy_item_id()
	require "../data/std_pet"
	return std_pet.yhs;
end

-- 取得宠物技能书的等级
function PetConfig:get_lv_by_item_id( item_id )
	require "../data/std_pet"
	local tab = std_pet.skillBoolLevel;
	for i=1,4 do
		local lv_tab = tab[i];
		for j=1,#lv_tab do
			if ( lv_tab[j] == item_id ) then
				return i;
			end
		end
	end
end

-- 取得控制系，攻击系，辅助系对应的技能id
function PetConfig:get_skill_type_group()
	require "../data/std_pet"
	return std_pet.skillTypeGroup;
end 

-- 取得经验值
function PetConfig:get_exp_by_lv(lv)
	require "../data/std_pet"
	return std_pet.LevelUpExp[lv + 1];
end

-- 取得遗忘之水id
function PetConfig:get_forget_water_item_id()
	require "../data/std_pet"
	return std_pet.delSkillItem;
end

-- 取得兽魂印id
function PetConfig:get_shy_item_id(lv)
	require "../data/std_pet"
	return std_pet.shy[lv];
end

-- 取得洗髓丹的id
function PetConfig:get_xsd_item_id()
	require "../data/std_pet"
	return std_pet.changeAttackItemId;
end

-- 取得技能类型和范围
function PetConfig:get_skill_type_and_range(skill_id)
	require "../data/std_pet"
	for i=1,3 do
		local skill_struct = std_pet.skillTypeGroup[i];

		for j=1,#skill_struct do
			if ( skill_struct[j] == skill_id ) then
				return PetConfig:get_skill_type( i , skill_id );
			end
		end
	end
	return nil,nil;
end

-- 计算技能类型和范围
function PetConfig:get_skill_type( index,skill_id )
	require "../data/std_pet"
	if ( index == 1 )then
		return LangGameString[301],10; -- [301]="控制系"
	end
	if ( index == 2 )then
		local range = 60;
		if ( skill_id ==  62 or skill_id == 63) then
			range = 10;
		end
		return LangGameString[302],range; -- [302]="攻击系"
	end
	if ( index == 3 )then
		return LangGameString[303],10; -- [303]="辅助系"
	end
	return nil,nil;
end

-- 判断一个悟性丹数量及保护珠是否足够并弹出提示框
function PetConfig:is_have_wuxing_item( curr_wx_lv ,is_need_bhd)
	require "../data/std_pet"
	curr_wx_lv = curr_wx_lv + 1;
	local wxd_num = ItemModel:get_item_count_by_id( std_pet.wxItemId[curr_wx_lv] );
	-- print("wxd_num = ",wxd_num);
	-- 弹出提示框
	if ( wxd_num <=0 ) then
		GlobalFunc:create_screen_notic( LangGameString[304]) -- [304]="背包中没有悟性丹，请补充!"
		return false;
	end
	-- 如果悟性等级大于12并且勾选了使用保护珠则要弹提示
	if ( is_need_bhd == 1  and curr_wx_lv >=12  ) then
		local bhd_num = ItemModel:get_item_count_by_id( std_pet.wxPro[curr_wx_lv] );
		-- print("bhd_num = ",bhd_num);
		if ( bhd_num <=0 ) then
			GlobalFunc:create_screen_notic( LangGameString[305]) -- [305]="背包中没有保护珠，请补充!"
			return false;
		end
	end
	return true;
end

-- 判断一个成长丹数量及保护珠是否足够并弹出提示框
function PetConfig:is_have_chengzhang_item( curr_cz_lv , is_need_bhd )
	require "../data/std_pet"
	curr_cz_lv = curr_cz_lv + 1;
	local czd_num = ItemModel:get_item_count_by_id( std_pet.growItemId[curr_cz_lv] );
	-- 弹出提示框
	if ( czd_num <=0 ) then
		GlobalFunc:create_screen_notic(LangGameString[306]); -- [306]="背包中没有成长丹，请补充!"
		return false;
	end
	if ( is_need_bhd == 1 and curr_cz_lv >=12 ) then
		local bhd_num = ItemModel:get_item_count_by_id( std_pet.growPro[curr_cz_lv] );
		if ( bhd_num <=0 ) then
			GlobalFunc:create_screen_notic(LangGameString[305]); -- [305]="背包中没有保护珠，请补充!"
			return false;
		end
	end
	return true;
end

-- -- 取得悟性或成长丹，保护珠的数量
-- function PetConfig:get_wx_or_cz_ts_info( wx_or_cz , lv )
-- 	require "../data/std_pet"
-- 	if wx_or_cz == 1 then

-- 	elseif wx_or_cz == 2 then
-- 		curr_cz_lv = curr_cz_lv + 1;
-- 		local czd_num = ItemModel:get_item_count_by_id( std_pet.growItemId[curr_cz_lv] );
-- 	end
-- end

-- 取得提升悟性需要的钱
function PetConfig:get_wxts_need_money( lv )
	require "../data/std_pet"
	return std_pet.wxMoney[lv];
end

-- 取得提升成长需要的钱
function PetConfig:get_czts_need_money( lv )
	require "../data/std_pet"
	return std_pet.growMoney[lv];
end

-- 取得宠物的头像
function PetConfig:get_pet_head( p_s )
	-- print("PetConfig:get_pet_head p_s.tab_attr[2]",p_s.tab_attr[2])
	return "icon/pet/" .. string.format("%05d",p_s.tab_attr[2]) .. ".pd";
	--return "icon/pet/" .. string.format("%05d",p_s.tab_attr[2]) .. ".png";
end

-- 取得宠物的头像
function PetConfig:get_pet_head_by_id( monster_id )
	-- print("PetConfig:get_pet_head_by_id monster_id",monster_id)
	return "icon/pet/" .. string.format("%05d",monster_id).. ".pd";
	--return "icon/pet/" .. string.format("%05d",monster_id).. ".png";
end

-- 获取宠物蛋的表
function PetConfig:get_pet_egg_tabel( )
	require "../data/std_pet"
	return std_pet.petItem
end

-- 获取宠物技能对应的数据
function PetConfig:get_pet_skill_strs(pet_skill_struct)
	  -- 静态表的技能信息
    local skill_info2 = SkillConfig:get_skill_by_id( pet_skill_struct.skill_id );

    local base_name = self:get_pet_skill_name_by_skill_lv(pet_skill_struct.skill_lv,skill_info2.name);


    local skill_type,range = PetConfig:get_skill_type_and_range(pet_skill_struct.skill_id);
    local cooldown_t =  skill_info2.skillSubLevel[pet_skill_struct.skill_lv].cooldownTime/1000 ;
    local skill_str = LangGameString[307] .. skill_info2.skillSubLevel[pet_skill_struct.skill_lv].desc; -- [307]="施法效果:"

    -- 技能图标
    local path =  SkillConfig:get_skill_icon_path(pet_skill_struct.skill_id ,pet_skill_struct.skill_lv);
    return {icon_path = path,skill_name = base_name,skill_type = skill_type,skill_range = range,skill_cd = cooldown_t,skill_desc = skill_str};
end

-- if quality == 1 then
-- 		return "#c38ff33";
-- 	elseif quality == 2 then
-- 		return "#c00c0ff";
-- 	elseif quality == 3 then
-- 		return "#cff66cc";
-- 	elseif quality == 4 then
-- 		return "#cfff000";
-- 	end

-- 取得宠物技能的名字
function PetConfig:get_pet_skill_name_by_skill_lv(skill_lv,skill_name)
	local result_skill_name = nil;
	if ( skill_lv == 1) then
        result_skill_name = LangGameString[308].. skill_name; -- [308]="#c38ff33初级"
    elseif ( skill_lv == 2 ) then
        result_skill_name = LangGameString[309].. skill_name; -- [309]="#c00c0ff中级"
    elseif ( skill_lv == 3 ) then 
        result_skill_name = LangGameString[310].. skill_name; -- [310]="#cff66cc高级"
    elseif ( skill_lv == 4 ) then  
        result_skill_name = LangGameString[311].. skill_name; -- [311]="#cfff000顶级"
    end
    return result_skill_name;
end

-- 52:离火燎原,53:蛮击,60:撕裂,66:灭魂,67:破甲,提神(68)、鼓舞(69)，提灵(70)，固若金汤(71)4个技能的资质系数和常数n，用于计算概率，这里配8个数字，分别是4个技能的系数和常数
local petSkillRate =
	{
		{52, 1, 0, 15000},
		{53, 4, 8, 6000},
		{60, 3, 8, 6000},
		{66, 3, 8, 6000},
		{67, 4, 8, 6000},
		{68, 4, 8, 6000},
		{69, 3, 8, 6000},
		{70, 4, 8, 6000},
		--{71, 3, 8, 6000},
	};

-- 56,神力,57,强体,58,固体,59,塑身 63,荆棘护体64,培元,65,活泼,72沉默免疫被动技能

-- 1技能id,2-5是技能1-4级的概率
-- 54 击晕术 61 连击 62 吸血
local petSkillRate2 = {
	{54,0.06,0.08,0.1,0.15},
	{61,0.06,0.08,0.1,0.15},
	{62,0.15,0.15,0.15,0.15},
};
-- 取得宠物技能的施放概率  一共12个主动技能需要计算概率去施放 ,如果返回0则说明这个技能是被动技能
function PetConfig:get_pet_skill_rate( skill_id ,skill_lv)
	local curr_pet_info = PetModel:get_current_pet_info(  );
	require "../data/std_pet"

	for i=1,#petSkillRate do
		if ( skill_id == petSkillRate[i][1] ) then
			local zz_id = petSkillRate[i][2];			--资质id
			local zz_rate = petSkillRate[i][3];		--资质系数
			local const_rate = petSkillRate[i][4];	-- 常数
			return (curr_pet_info.tab_attr[24 + zz_id] * zz_rate + const_rate)/ 100000 
		end
	end

	for i=1,#petSkillRate2 do
		if ( skill_id == petSkillRate2[i][1] ) then
			return petSkillRate2[i][1 + skill_lv ];
		end
	end

	return 0;
end

-- 取得宠物技能cd时间
function PetConfig:get_pet_skill_cd( skill_id,skill_lv )
	local skill_info = SkillConfig:get_skill_by_id( skill_id );
	local cooldown =  skill_info.skillSubLevel[skill_lv].cooldownTime/1000 ;
	return cooldown;
end


local pet_animation_pos = {
	[389] = {x=99,y=178+20},
	[404] = {x=99,y=178},
	[326] = {x=99,y=178},
	[329] = {x=99,y=178},
	[327] = {x=99,y=178},
	[323] = {x=99,y=168},
	[325] = {x=99,y=178-70+55},
	[324] = {x=99+10,y=178-35+40},
	[328] = {x=99,y=178},
	[330] = {x=99,y=178-35},
	[331] = {x=99+15,y=178+35+24},
	[332] = {x=99+15,y=178-35},
	[333] = {x=99,y=178-20},
	[334] = {x=99,y=178-35},
	[335] = {x=99+10,y=178-20},
	[336] = {x=99+10,y=178+20},
	[402] = {x=99,y=178-18},
};
function PetConfig:get_pet_animate_position( pet_id )
	return pet_animation_pos[pet_id];
end
