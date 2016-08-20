-- SpriteModel.lua
-- created by mwy on 2014-5-12
-- 精灵信息模型 动态数据

local _has_sprite 	= false;	 --是否有精灵

local _sprite_info 	= nil;		 --精灵信息

local _is_show_other_sprite = false --查看他人式神flag

local _is_free_get = 0            --是否已免费领取

local _is_vip_get = 0             --是否已vip领取

SpriteModel = {}

function SpriteModel:fini(  )
	_has_sprite 	= false;
	_sprite_info 	= nil;
end
-- 设置用户坐骑信息
function SpriteModel:set_sprite_info(sprite_struct)
	-- body
	_sprite_info = sprite_struct;
end

-- 获取用户坐骑信息
function SpriteModel:get_sprite_info()
	-- body
	return _sprite_info;
end
-- 设置是否有坐骑
function SpriteModel:set_has_sprite( bool_var)
	_sprite_info = bool_var;
end
-- 获取是否有坐骑
function SpriteModel:get_has_sprite( bool_var)
	return _has_sprite;
end

-- 修改场景上坐骑外观
function SpriteModel:change_avatar_sprite( mounts_id )
	-- local player = EntityManager:get_player_avatar();
	-- player:change_mount( mounts_id );
end

--获取式神 
-- get_type:0免费，1元宝
function SpriteModel:req_fabao( get_type )
		SpriteCC:req_fabao( get_type )
end

-- local _dont_show_again = false
-- function SpriteModel:show_bindingYuanbao_tips( up_handler )
--     local function confirm_func(  )
--         up_handler()
--     end
--     local function switch_fun( if_select )
--         _dont_show_again = if_select
--     end
--     local content = "礼券不足，使用元宝代替"
--     ConfirmWin2:show(5, nil, content, confirm_func, switch_fun, nil)
-- end

-- 请求升级精灵等级
function SpriteModel:req_up_fabao_level( gem_type, used_yb )
	--获取所选择的晶石数量及对应元宝
		local count = nil;
		local need_yb = SpriteConfig:get_sprite_level_up_item(gem_type).ybCost;
		local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
		if gem_type == 1 then
			count = ItemModel:get_item_count_by_id( 18603 );
		elseif gem_type == 2 then
			count = ItemModel:get_item_count_by_id( 18604 );
		elseif gem_type == 3 then
			count = ItemModel:get_item_count_by_id( 18605 );
		end

	--优先使用晶石提升
	 if count > 0 then	
	 	SpriteCC:req_fabao_uplevel( gem_type, 0, money_type )
	 --晶石不足时，如果勾选使用元宝
	 elseif used_yb then
	 	local param = {gem_type, 1, money_type}
	 	local upgrade_func = function( param )
	 		SpriteCC:req_fabao_uplevel(param[1], param[2], param[3])
	 	end
	 	MallModel:handle_auto_buy( need_yb, upgrade_func, param )
	 	-- local player = EntityManager:get_player_avatar();
	 	-- local confirm_func = function(  )
	 	-- 	--元宝不足时，弹 快速充值 界面
			-- if need_yb > player.yuanbao then
			-- 	-- GlobalFunc:create_screen_notic( "元宝不足" );
			-- 	local function confirm2_func()
		 --            GlobalFunc:chong_zhi_enter_fun()
		 --            --UIManager:show_window( "chong_zhi_win" )
		 --    	end
		 --    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
		 --    --元宝充足时,使用元宝提升
		 --    else	    	
		 --    	SpriteCC:req_fabao_uplevel( gem_type, 1 )
		 --    end
	 	-- end
	 	-- if need_yb > player.bindYuanbao then
	 	-- 	if _dont_show_again == false then
	 	-- 		SpriteModel:show_bindingYuanbao_tips( confirm_func )
	 	-- 	else
	 	-- 		confirm_func()
	 	-- 	end
	 	-- else
	 	-- 	SpriteCC:req_fabao_uplevel( gem_type, 1 )
	 	-- end
		
	 --晶石不足，且未勾选使用元宝时
	else
		GlobalFunc:create_screen_notic( "神露不足" );
	end
end

-- 更新精灵升级经验
function SpriteModel:do_up_sprite_exp(got_exp,level,current_exp)
	-- 同步保存的精灵实体信息
	_sprite_info.level=level
	_sprite_info.exp=current_exp

	-- local _sprite_exp=_sprite_info.exp+got_exp
	-- 搞更新ui
	local win = UIManager:find_visible_window("genius_win");
	if win then
		win.info_panel:update_level_info(got_exp,level,current_exp);
		--xiehande  更新完毕之后  添加 式神成长特效
		win.info_panel:play_exp_success_effect();
	end
end
-- 更新精灵四个基本属性信息
function SpriteModel:do_sprite_info_change(life,attack,w_def,m_def)
	-- 同步保存的精灵实体信息数据
	_sprite_info.attr_life=life
	_sprite_info.attr_attack=attack
	_sprite_info.attr_wDefense=w_def
	_sprite_info.attr_mDefense=m_def
	-- ZXLog("--------------SpriteModel:do_sprite_info_change-------------",_sprite_info.attr_life,_sprite_info.attr_attack,_sprite_info.attr_wDefense,_sprite_info.attr_mDefense)
	local win = UIManager:find_visible_window("genius_win");
	if win then
		win.info_panel:update_stage_info_change();
	end
end

-------------------------------升阶--------------------------------------

-- 从背包中获取当前阶的羽翼晶石数量
function SpriteModel:get_yuli_crystal_count()
	local item_id = SpriteModel:get_curr_stage_crystal_item_id( );
	local count = ItemModel:get_item_count_by_id(item_id);	
	return count;
end

--获取翅膀的最高级
function SpriteModel:get_max_win_level( )
	return SpriteConfig:get_max_win_level()
end

-- 取得当前等级对应的羽翼晶石 id
function SpriteModel:get_curr_stage_crystal_item_id( )
	if _sprite_info.stage_level >= SpriteModel:get_max_win_level() then
		-- 最高级
		return  SpriteConfig:get_max_stageUpItem_id(  );
	end
	local _crystal_id =  SpriteConfig:get_item_id_by_level(_sprite_info.stage_level)
	return _crystal_id
end

-- 获取当前翅膀几星
function SpriteModel:get_curr_sprite_star()
	return _sprite_info.star_level;
end

-- 获取祝福值
function SpriteModel:get_blessing()
	return _sprite_info.blessing;
end

-- 获取精灵升阶“当前等级”基础成功率
function SpriteModel:get_curr_stage_success_rate()
	local level = _sprite_info.stage_level;
	local max_stage = #spirits_stages.stageUpItem
	if level>max_stage then
		return 0
	end
	return spirits_stages.stageUpItem[level].successRate;
end

-- 获取翅膀 “当前等级” 的
-- （100%－基础成功率）/10*服务器返回祝福值
function SpriteModel:get_curr_bless_ratio()
	-- _sprite_info.blessing 0-10
	local bless = _sprite_info.blessing
	if bless ==10 then
        return 100
    else
    	return bless*2
    end
end

-- 获取祝福值进度条比例
function SpriteModel:get_curr_bless()
	return _sprite_info.blessing;
end

-- 请求升级精灵等阶
--  gem_type, used_yb
function SpriteModel:req_upgrade_stage(selected )

	--获取所选择的晶石数量及对应元宝
	local count = SpriteModel:get_yuli_crystal_count()
	local sprite_info = SpriteModel:get_sprite_info( ) 
	local need_yb = SpriteConfig:get_UpItemInfo_by_stage(sprite_info.stage_level).ybCost;
	local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
	--优先使用晶石提升
	 if count > 0 then	
	 	SpriteCC:req_upgrade_stage(selected, money_type)
	 --晶石不足时，如果勾选使用元宝
	 elseif selected then
	 	local param = {selected, money_type}
	 	local upgrade_func = function( param )
	 		SpriteCC:req_upgrade_stage(param[1], param[2])
	 	end
	 	MallModel:handle_auto_buy( need_yb, upgrade_func, param )
	 	-- local player = EntityManager:get_player_avatar();
	 	-- local confirm_func = function(  )
	 	-- 	--元宝不足时，弹 快速充值 界面
			-- if need_yb > player.yuanbao then
			-- 	local function confirm2_func()
		 --            GlobalFunc:chong_zhi_enter_fun()
		 --    	end
		 --    	ConfirmWin2:show( 2, 2, "",  confirm2_func)
		 --    --元宝充足时,使用元宝提升
		 --    else
		 --    	SpriteCC:req_upgrade_stage(selected)
		 --    end
	 	-- end
	 	-- if need_yb > player.bindYuanbao then
	 	-- 	if _dont_show_again == false then
	 	-- 		SpriteModel:show_bindingYuanbao_tips( confirm_func )
	 	-- 	else
	 	-- 		confirm_func()
	 	-- 	end
	 	-- else
	 	-- 	SpriteCC:req_upgrade_stage(selected)
	 	-- end
	 --晶石不足，且未勾选使用元宝时
	else
	GlobalFunc:create_screen_notic( "材料不足" )
	end
end

function SpriteModel:do_upgrade_stage_change(result,stage,star_level,bless)
	-- if  tonumber(result)==1  then
		_sprite_info.stage_level=stage
		_sprite_info.star_level=star_level
		_sprite_info.blessing=bless

		local win = UIManager:find_visible_window("genius_win");
		if win then
			win.jinjie_panel:update_stage_info_change();
		end
	-- end	
end

 -- 根据精灵轮回等级获取模型ID
 function SpriteModel:get_sprite_modle_id(rebirth_level)
 	return spirits_rebirth[rebirth_level].modelId
 end

------------------------------技能---------------------------------

function SpriteModel:get_skill_name_by_index(skill_index)
	 return SpriteConfig:get_skill_by_index(skill_index).name
end

function SpriteModel:get_skill_by_index(skill_index)
	 return SpriteConfig:get_skill_by_index(skill_index,skill_level)
end

-- 获取加成属性
function SpriteModel:get_skill_rate_by_index(skill_index,skill_level)
	local cur_rate=SpriteConfig:get_skill_by_index(skill_index).addRate[skill_level]*100
	local max_rate=SpriteConfig:get_skill_by_index(skill_index).addRate[10]*100
	local cur_des =SpriteConfig:get_skill_by_index(skill_index).des..cur_rate..'%'
	local cur_max_des = SpriteConfig:get_skill_by_index(skill_index).des..max_rate..'%'

	 return cur_rate,cur_des,cur_max_des
end

-- 根据技能索引获取当前技能等级
function SpriteModel:get_skill_level(skill_index)
	-- ZXLog("-------------skill_index--------------",skill_index)
	if skill_index> #_sprite_info.skills_level then
		return 0
	end
	return _sprite_info.skills_level[skill_index]
end

-- 根据装备索引获取当前装备等级
function SpriteModel:get_equip_level(equip_index)
	if equip_index > #_sprite_info.equips_level then
		return 0
	end
	return _sprite_info.equips_level[equip_index]
end

function SpriteModel:do_upgrade_skill_change(skill_index,got_exp,current_level,current_exp)
	-- 开启技能数
	 if  skill_index > _sprite_info.skill_count then
	 	_sprite_info.skill_count=skill_index
	 end
	 -- 同步技能数据
	 _sprite_info.skills_level[skill_index]=current_level
	 _sprite_info.skills[skill_index] =SpriteConfig:get_skill_by_index(skill_index)
	 _sprite_info.skills[skill_index].exp=tonumber(current_exp)

	 --同步UI
	local win = UIManager:find_visible_window("genius_win");
	if win then
		win.jinjie_panel:update_stage_info_change();
	end
	-- 升级技能熟练度返回数据，更新UI
	local win = UIManager:find_visible_window("genius_win");
	if win then
		win.jineng_panel:update_sprite_info();
			--xiehande  更新数据完成后播放特效
		win.jineng_panel:play_jineng_success_effect();
	end
end

function SpriteModel:get_skill_count()
	return _sprite_info.skill_count
end

-- 通过“技能索引”获取翅膀效果值
function SpriteModel:get_effect_by_index(skill_index)

	local level = _sprite_info.skills_level[skill_index];
	if level == 0 then
		level = 1;
	end

	if level == nil then
		level = 0
	end

	local addRate = spirits_skill.skill[skill_index].addRate;
	local skill_desc = spirits_skill.skill[skill_index].des or "";
	local skill_desc1 = spirits_skill.skill[skill_index].des1 or "";
	local skill_desc2 = spirits_skill.skill[skill_index].des2 or ""
	-- local yhzcLevels = spirits_skill.yhzcLevels

	local ten_effect=addRate[#addRate];
	local next_effect = addRate[level]
	
	if (level < #addRate) then
	 	next_effect = addRate[level+1];
	end
	local curr_effect = addRate[level] or 1;

	local skill_t1 = {[1] = true, [3] = true,[6] = true, [7] = true} -- *100+%
	local skill_t2 = {[2] = true, [4] = true, [5] = true} -- /100+%
	local skill_t3 = {[3] = true} -- *1+%
	local skill_t4 = {[8] = true} -- *1
	local skill_t5 = {[9] = true} -- ...

	local cur_other_effect = ""
	local next_other_effect = ""
	local lv10_other_effect = ""
	if skill_t1[skill_index] then
		curr_effect = curr_effect * 100
		next_effect = next_effect * 100
		ten_effect = ten_effect * 100
	elseif skill_t2[skill_index] then
		curr_effect = curr_effect / 100
		next_effect = next_effect / 100
		ten_effect = ten_effect / 100
	elseif skill_t3[skill_index] then
		--
	elseif skill_t4[skill_index] then
		-- *1
	elseif skill_t5[skill_index] then
		local triggerRate = spirits_skill.yhzc.triggerRate
		local effectTime = spirits_skill.yhzc.effectTime

		cur_other_effect = effectTime[curr_effect]
		next_other_effect = effectTime[next_effect]
		lv10_other_effect = effectTime[ten_effect]
		curr_effect = triggerRate[curr_effect]
		next_effect = triggerRate[next_effect]
		ten_effect = triggerRate[ten_effect]
		-- cur_other_effect = yhzcLevels[curr_effect][2]
		-- next_other_effect = yhzcLevels[next_effect][2]
		-- lv10_other_effect = yhzcLevels[ten_effect][2]
		-- curr_effect = yhzcLevels[curr_effect][1]
		-- next_effect = yhzcLevels[next_effect][1]
		-- ten_effect = yhzcLevels[ten_effect][1]
	end

	local sign = ""
	if skill_t1[skill_index] or skill_t2[skill_index] or skill_t3[skill_index] then
		sign = "%"
	end

	return {skill_desc,skill_desc1,skill_desc2},
			{ curr_effect, next_effect,ten_effect}, 
			{cur_other_effect, next_other_effect, lv10_other_effect}, sign;
end

-- 通过“技能索引”获取翅膀熟练度
function SpriteModel:get_exp_values(skill_index)
	local level = _sprite_info.skills_level[skill_index];
	local shuLianDu = spirits_skill.skill[skill_index].shuLianDu;
	if (level == 0) then
		level = level + 1;
	end
	-- ZXLog('--------------SpriteModel:get_exp_values----------------',skill_index)
	local curr_exp = _sprite_info.skills[skill_index].exp;
	local curr_max_exp = shuLianDu[level];

	return {curr_exp, curr_max_exp};
end

-- 获得该技能对应羽翼技能卷数量
function SpriteModel:get_skill_book_count( skill_index  )
    --当前技能的等级
    local level = (SpriteModel:get_sprite_info()).skills_level[skill_index];
    local book_id = SpriteModel:get_skill_book_id_by_skill_level(level or 0);
    require "model/ItemModel"
    --羽翼卷的数量
    local count = ItemModel:get_item_count_by_id( book_id );
    return count;
end
--获取翅膀技能的等级对应羽翼技能卷的item id
function SpriteModel:get_skill_book_id_by_skill_level( level )
	if (level <= 3) then        
        return 18633;
    elseif (level <= 6) then        
        return 18634;
    else
        return 18635;
    end
end

--获取翅膀技能的等级对应羽翼技能卷的icon id
function SpriteModel:get_skill_book_icon_id_by_skill_level( level )
    if (level <= 3) then        
        return "00561";
    elseif (level <= 6) then        
        return "00562";
    else
        return "00563";
    end
end

-- 请求升级翅膀技能的熟练度
function SpriteModel:req_upgrade_skill(which_skill,if_selected)
	local need_xb = SpriteModel:get_xb_value_by_skill_index(which_skill)
	local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
	-- print("------------------which_skill------------------",need_xb,which_skill,if_selected)
	 -- 判断仙币是否足够
    if (need_xb and SpriteModel:get_user_xb() < need_xb ) then
        -- GlobalFunc:create_screen_notic( LangModelString[147] ); -- [147]="仙币不足"
        --天降雄狮修改  xiehande 如果是铜币不足/银两不足/经验不足 做我要变强处理
   	   ConfirmWin2:show( nil, 15, Lang.screen_notic[11],  need_money_callback, nil, nil )

        return ;
    end
    -- --羽翼技能卷
    -- local count = WingModel:get_skill_book_count(which_skill);
    -- if count <= 0 then
    --     GlobalFunc:create_screen_notic( LangModelString[479] ); -- [479]="没有羽翼技能卷,无法升级"
    --     return ;
    -- end
    local autobuy 
    if if_selected then
    	autobuy= 1
    else
    	autobuy=0
    end

    --获取所选择的晶石数量及对应元宝
	local count = SpriteModel:get_skill_book_count(which_skill)
	local sprite_info = SpriteModel:get_sprite_info( ) 
	local need_yb = SpriteConfig:get_UpItemInfo_by_stage(sprite_info.stage_level).ybCost;

	--优先使用晶石提升
	if count > 0 then
		SpriteCC:req_wing_skill(which_skill,0, money_type);
		_curr_skill_index = which_skill;
	--晶石不足时，如果勾选使用元宝
	elseif if_selected then
		local param = {which_skill, 1, money_type}
	 	local upgrade_func = function( param )
	 		SpriteCC:req_wing_skill(param[1], param[2], param[3])
	 	end
	 	MallModel:handle_auto_buy( need_yb, upgrade_func, param )
	 -- 	local player = EntityManager:get_player_avatar();
	 -- 	local confirm_func = function(  )
	 -- 		--元宝不足时，弹 快速充值 界面
		-- 	if need_yb > player.yuanbao then
		-- 		local function confirm2_func()
		--             GlobalFunc:chong_zhi_enter_fun()
		--     	end
		--     	ConfirmWin2:show( 2, 2, "",  confirm2_func)
		--     --元宝充足时,使用元宝提升
		--     else
		--     	SpriteCC:req_wing_skill(which_skill,1);
		--     	_curr_skill_index = which_skill;
		--     end
	 -- 	end
	 -- 	if need_yb > player.bindYuanbao then
	 -- 		if _dont_show_again == false then
	 -- 			SpriteModel:show_bindingYuanbao_tips( confirm_func )
	 -- 		else
	 -- 			confirm_func()
	 -- 		end
	 -- 	else
	 -- 		SpriteCC:req_wing_skill(which_skill, 1);
		_curr_skill_index = which_skill;
	 -- 	end
	 --晶石不足，且未勾选使用元宝时
	else
		GlobalFunc:create_screen_notic( "技能卷不足" );
	end
end

-- 获取当前升级所需要的仙币数
function SpriteModel:get_xb_value_by_skill_index(skill_index)
	local level = _sprite_info.skills_level[skill_index];
	if not level then
		return
	end

	if level == 0 or level == 10 then 
		return 0;
	else 
		local skillLevelUpCost = spirits_skill.skillLevelUp[level].xbCost;
		return skillLevelUpCost;	
	end
end

-- 获得用户当前仙币
function SpriteModel:get_user_xb( )
	local player = EntityManager:get_player_avatar();

	return player.bindYinliang;
end

---------------------------------轮回---------------------------------------

-- 获取当前轮回等级
function SpriteModel:get_curr_lunhui_stage()
	return _sprite_info.lunhui_level;
end
-- 获取当前轮回下一等级
function SpriteModel:get_next_lunhui_stage()
	local max_stage = #spirits_rebirth;
	local next_stage = _sprite_info.lunhui_level ;
	if (next_stage > max_stage) then
		next_stage = max_stage;
	end
	return next_stage;
end

-- 获取当前轮回“当前属性”属性加成
function SpriteModel:get_curr_attr_add_limit()
	return spirits_rebirth[_sprite_info.lunhui_level].addRate[_sprite_info.lunhui_star_level+1];
end

-- 获取当前轮回“当前属性”最高加成
function SpriteModel:get_curr_attr_max_add_limit()
	local max = #spirits_rebirth[_sprite_info.lunhui_level].addRate
	return spirits_rebirth[_sprite_info.lunhui_level].addRate[max];
end

-- 获取当前轮回“下阶属性”最高加成
function SpriteModel:get_next_attr_add_limit()
	local max_level = #spirits_rebirth;
	local curr_level = _sprite_info.lunhui_level;
	local next_level = 0
	if (curr_level < max_level) then
		next_level = curr_level;
		if next_level~=max_level then
			-- 读表需要把索引加1，因为服务器返回索引从0开始
			next_level=next_level+1
		end
	else
		next_level = max_level
	end
	-- return spirits_rebirth[next_level].addRate[_sprite_info.lunhui_star_level+1];
	return spirits_rebirth[next_level].addRate[#spirits_rebirth[next_level].addRate];
end

-- 获取轮回“当前阶”最高闪耀等级 
function SpriteModel:get_curr_stage_max_shanyao_level()
	return spirits_rebirth[_sprite_info.lunhui_level].maxEquipLevel;
end
-- 获取轮回“下一阶”最高闪耀等级
function SpriteModel:get_next_stage_max_shanyao_level()
	local max_stage = #spirits_rebirth;
	local stage = _sprite_info.lunhui_level;
	local next_stage = stage
	if (stage < #spirits_rebirth) then
		if next_stage~=max_stage then
			-- 读表需要把索引加1，因为服务器返回索引从0开始
			next_stage=next_stage+1
		end
	end
	return spirits_rebirth[next_stage].maxEquipLevel;
end

--获取轮回“当前阶”最高等阶
function SpriteModel:get_curr_max_stage_level()
	return spirits_rebirth[_sprite_info.lunhui_level].maxStages;
end

--获取轮回“下一阶”最高等阶
function SpriteModel:get_next_max_stage_level()
	local max_stage = #spirits_rebirth;
	local stage = _sprite_info.lunhui_level;
	local next_stage = stage
	if (stage < #spirits_rebirth) then
		if next_stage~=max_stage then
			-- 读表需要把索引加1，因为服务器返回索引从0开始
			next_stage=next_stage+1
		end
	end
	return spirits_rebirth[next_stage].maxStages;
end

--获取轮回“当前阶”技能数量
function SpriteModel:get_curr_stage_skillcount()
	for i=1, #spirits_skill.rebirthLimit do
		if spirits_skill.rebirthLimit[i] == _sprite_info.lunhui_level then
			return i
		end 
	end
	return 0
end

--获取轮回“下一阶”技能数量
function SpriteModel:get_next_stage_skillcount()
	local max_count = #spirits_skill.rebirthLimit

	for i=1, #spirits_skill.rebirthLimit do
		if spirits_skill.rebirthLimit[i] ==_sprite_info.lunhui_level then
			if i == max_count then
				return max_count
			else
				return i+1
			end 
		end 
	end
	return 0
end

-- 获取轮回"当前阶段"装备数量
function SpriteModel:get_curr_equip_count()
	-- return #spirits_rebirth[_sprite_info.lunhui_level+1].openEquip;
end
-- 获取轮回“下一阶”装备数量
function SpriteModel:get_next_equip_count()
	local max_stage = #spirits_rebirth;
	local stage = _sprite_info.lunhui_level;
	local next_stage = stage
	if (stage < #spirits_rebirth) then
		if next_stage~=max_stage then
			-- 读表需要把索引加1，因为服务器返回索引从0开始
			next_stage=next_stage+1
		end
	end
	-- return #spirits_rebirth[next_stage].openEquip;
end

-- 获取当前翅膀几星
function SpriteModel:get_curr_lunhui_star()
	return _sprite_info.lunhui_star_level;
end

-- 升星需要声望
function SpriteModel:need_renown_upgrade_star()
	if _sprite_info.lunhui_level >= 10 and _sprite_info.lunhui_star_level >= 10 then
		return 0
	end
	return spirits_rebirth[_sprite_info.lunhui_level].renownCost[_sprite_info.lunhui_star_level+1];
end

-- 升星需要仙币
function SpriteModel:need_xb_upgrade_star( )
	if _sprite_info.lunhui_level >= 10 and _sprite_info.lunhui_star_level >= 10 then
		return 0
	end
	return spirits_rebirth[_sprite_info.lunhui_level].xbCost[_sprite_info.lunhui_star_level+1];
end

-- 获得用户当前声望
function SpriteModel:get_user_renown( )
	local player = EntityManager:get_player_avatar();
	return player.renown;
end

-- 请求升级轮回阶级
function SpriteModel:req_upgrade_lunhui_stage( )
	SpriteCC:req_upgrade_lunhui_stage()
end
-- 轮回升阶返回
function SpriteModel:do_lunhui_stage_change(stage,star_level)
	 _sprite_info.lunhui_level=stage
	 _sprite_info.lunhui_star_level=star_level

	local win = UIManager:find_visible_window("genius_win");
	if win then
		win.lunhui_panel:update_sprite_info();
	end
end

--------------------------------装备------------------------------------------
-- 获取开启的装备个数
function SpriteModel:get_equip_count(  )
	return _sprite_info.equip_count
end
-- 获取当前闪耀值
-- 参数：技能序号（技能索引）
function SpriteModel:get_curr_shanyao_value( equip_index )
	return _sprite_info.equips[equip_index].exp
end

-- 获取当前技能别闪耀级别
-- 参数：技能序号（技能索引）
function SpriteModel:get_curr_equip_shanyao_stage( equip_index)
	return _sprite_info.equips_level[equip_index]
end

-- 获取装备当前级别下一闪耀级别
function SpriteModel:get_next_equip_shanyao_next_stage( equip_index)
	-- local max_level =spirits_rebirth[#spirits_rebirth].maxEquipLevel
	local max_level = 50
	local next_level = self:get_curr_equip_shanyao_stage(equip_index)
	-- print("SpriteModel:get_next_equip_shanyao_next_stage( get_curr_equip_shanyao_stage)",self:get_curr_equip_shanyao_stage(equip_index))
	if next_level>=max_level then
		next_level = max_level
	else
		next_level = next_level+1
	end
	return next_level
end

-- 获取技能当前级别下一闪耀级别
function SpriteModel:get_max_equip_by_index( equip_index)
	-- local max_level =spirits_rebirth[#spirits_rebirth].maxEquipLevel
	local max_level = 50
	return max_level
end

-- 获取当前闪耀值
-- 参数：技能序号（技能索引）
function SpriteModel:get_shanyao_value_by_skill_index( equip_index )
	local shanyao_value = _sprite_info.equips[equip_index].exp
	return shanyao_value
end
-- 获取升级需要最大闪耀值
-- 参数：闪耀等级
function SpriteModel:get_max_shanyao_value_by_shanyao_level( equip_index )
	local shanyao_value = spirits_equip.equipLevelUp.upExp[equip_index]
	return shanyao_value
end


-- 获取闪耀伤害追加值
-- 参数：技能序号（技能索引）、闪耀级别
function SpriteModel:get_shanyao_attr_add( equip_index, equip_shanyao_level)
	local attr_add = spirits_equip.equip[equip_index].addRate[equip_shanyao_level]
	local _type = spirits_equip.equip[equip_index].type
	local type_ddd = SpriteModel:get_shanyao_attr_by_type(_type)
	return {attr_add=attr_add,type_add=type_ddd}
end

-- 根据类型获取属性加成的类型
-- 参数:属性类别
function SpriteModel:get_shanyao_attr_by_type(type)
	local text = nil
	if type==37 then
		text='闪    避:'
	elseif type==39 then
		text='命    中:'
	elseif type==35 then
		text='暴    击:'
	elseif type==25 then
		text='抗 暴 击:'
	elseif type==17 then
		text='生    命:'
	elseif type==51 then
		text='物理免伤:'
	elseif type==49 then
		text='精神免伤:'
	elseif type==41 then
		text='伤害追加:'
	end
	return text
end

-- 获取一次提升所需要的仙币
function SpriteModel:get_xb_upda_stage()
	return spirits_equip.equipLevelUp.xbCost
end

-- 获取50次提升所需要的仙币
function SpriteModel:get_50xb_up_stage_const()
	return spirits_equip.equipLevelUp.xbCost * 50
end

-- 获取1次提升所需要的元宝
function SpriteModel:get_yb_up_stage_const()
	return spirits_equip.equipLevelUp.ybCost
end


-- 装备强化 
-- 参数：1.装备序号、2.强化类型(1仙币、2仙币20次、3元宝)
function SpriteModel:req_upgrade_equip_stage( which_skill,shich_type)
	local money_type = MallModel:get_only_use_yb() and 3 or 2

	local param = {which_skill, shich_type, money_type}
	local upgrade_func = function( param )
		SpriteCC:req_upgrade_equip_stage(param[1], param[2], param[3])
	end

	if shich_type == 1 or shich_type == 2 then
		local price = SpriteModel:get_xb_upda_stage()
		if shich_type == 2 then
			price = price * 20
		end
		local renbi = EntityManager:get_player_avatar().bindYinliang;
		if renbi < price then
			-- GlobalFunc:create_screen_notic( LangModelString[147] ); -- [147]="仙币不足"
		--天降雄狮修改 xiehande 如果是铜币不足/银两不足/经验不足 做我要变强处理
	     ConfirmWin2:show( nil, 15, Lang.screen_notic[11],  need_money_callback, nil, nil )

			return;
		end
		SpriteCC:req_upgrade_equip_stage(which_skill,shich_type, money_type)
	elseif shich_type == 3 then
		local price = SpriteModel:get_yb_up_stage_const()
		MallModel:handle_auto_buy( price, upgrade_func, param )
	end
	-- SpriteCC:req_upgrade_equip_stage(which_skill,shich_type)
end

-- 轮回升阶返回   装备（八门遁甲）返回

function SpriteModel:do_equip_stage_change(equip_index,get_shanyao_exp,curr_shanyao_level,curr_shanyao_exp)
	-- 开启技能数
	 if  equip_index > _sprite_info.equip_count then
	 	_sprite_info.equip_count=equip_index
	 end
	 -- 同步技能数据
	 _sprite_info.equips_level[equip_index]=curr_shanyao_level
	 _sprite_info.equips[equip_index]      =SpriteConfig:get_equip_by_index(equip_index)
	 _sprite_info.equips[equip_index].exp  =tonumber(curr_shanyao_exp)

	local win = UIManager:find_visible_window("genius_win");
	if win then
		win.zhuangbei_panel:update_sprite_info(false);
		--xiehande 添加八门遁甲 特效
		win.zhuangbei_panel:play_zhuangbei_success_effect();
	end

end

-- 每次元宝强化精灵技能次数发生变化时下发
function SpriteModel:do_equip_upstage_times_change(upstage_times)
	_sprite_info.upstage_times=upstage_times
end
-- 获取剩余元宝提升次数和总次数
 function SpriteModel:get_equip_upstage_times()
 	local max_times =  spirits_equip.equipLevelUp.ybLevelUpPerDay
 	return _sprite_info.upstage_times,max_times
 end

-- 模型改变
 function SpriteModel:do_sprite_model_change(model_id)
 	print("SpriteModel:do_sprite_model_change(model_id)",model_id)
 	_sprite_info.model_id=model_id
 	local win = UIManager:find_visible_window("genius_win");
	if win then
		--化形成功特效
		win:play_huaxing_effect();
		--让按钮灰化
		win.huanxing_panel:update_state();
		-- win.info_panel:update_sprite_info();
		-- win.jinjie_panel:update_sprite_info();
		-- win.jineng_panel:update_sprite_info();
		-- win.lunhui_panel:update_sprite_info();
		-- win.zhuangbei_panel:update_sprite_info(false);
		-- win.huanxing_panel:update_sprite_info();
		-- win.info_panel:selected_crystal()
		win:update("model", false)
	end
 end

-- 战力改变
 function SpriteModel:do_sprite_fight_value_change(fight_value)
 	_sprite_info.fight_value=fight_value
	local win = UIManager:find_visible_window("genius_win");
	if win then
		-- win.info_panel:update_sprite_info();
		-- win.jinjie_panel:update_sprite_info();
		-- win.jineng_panel:update_sprite_info();
		-- win.lunhui_panel:update_sprite_info();
		-- win.zhuangbei_panel:update_sprite_info(false);
		-- win.huanxing_panel:update_sprite_info();
		win:update("fight_value", false)
	end
 end

 --暴击改变,这里播放暴击特效
 function SpriteModel:do_sprite_baoji_value_change(baoji_type)
	-- 播放法宝升级暴击特效
	local win = UIManager:find_visible_window("GeniusWin")
	if ( win ) then
		win:play_cri_animation( baoji_type );
	end
 end

function SpriteModel:show_other_sprite_by_info(sprite_info)
	SpriteModel:set_show_other_sprite(true)
	local win = UIManager:show_window("genius_win");
	win:show_other_sprite(sprite_info);
end

function SpriteModel:is_show_other_sprite(  )
	return _is_show_other_sprite
end

function SpriteModel:set_show_other_sprite( is_show )
	_is_show_other_sprite = is_show
end

-- 炫耀式神
function SpriteModel:req_xuanyao_event(  )
	local sprite_info = self:get_sprite_info()
	local self_id = EntityManager:get_player_avatar().id
	local self_name = EntityManager:get_player_avatar().name

	-- print("SpriteModel:req_xuanyao_event(self_id,self_name)",self_id,self_name)

	local temp_info = string.format( "%s%d%s%d%s%d%s%s%s,%s,%s,%s%s",
		ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET,
		ChatConfig.ChatSpriteType.TYPE_TEXTBUTTON, 
		ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
		ChatConfig.ChatAdditionInfo.TYPE_SPRITE, 
		ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
		sprite_info.model_id, 
		ChatConfig.message_split_target.CHAT_INFO_HEAD_TARGET,
		Hyperlink:get_first_function_target(), 
		Hyperlink:get_third_open_sys_win_target(),
		--式神window id
		12,
		self_id,self_name,
		ChatConfig.message_split_target.CHAT_INFO_SPLITE_TARGET)
	print("******** temp_info",temp_info)
	-- print("ChatModel:get_cur_chanel_select()",ChatModel:get_cur_chanel_select())
	local cur_select_chanel = ChatModel:get_cur_chanel_select()
    if cur_select_chanel == 100 then
        cur_select_chanel = 6
    end 
    ChatCC:send_chat(cur_select_chanel, 0, temp_info)
end

-- 服务器下发式神领取状态
function SpriteModel:set_get_sprite_status(is_free_get,is_vip_get)
	_is_free_get=is_free_get
	_is_vip_get=is_vip_get

	print("SpriteModel:set_get_sprite_status(is_free_get,is_vip_get)",is_free_get,is_vip_get)
	-- if _is_free_get == 1 and _is_vip_get == 1 then
	-- 	local win = UIManager:find_visible_window( "right_top_panel" )
	-- 	if win then
	-- 		win:remove_btn(10)
	-- 	end
	-- 	UIManager:destroy_window("genius_get_win")
	-- else
	-- 	local win = UIManager:find_visible_window( "right_top_panel" )
	-- 	if win then
	-- 		win:insert_btn(10)
	-- 	end
	-- end

	local  win = UIManager:find_visible_window("genius_get_win")
	if win then
		win:update_btn_status()
	end
end

function SpriteModel:get_get_sprite_status()
	return _is_free_get,_is_vip_get
end

-- 向服务器请求式神化形
function SpriteModel:req_sprite_huaxing(sprite_model_id)
	SpriteCC:request_sprite_huaxing(sprite_model_id);
end

function  SpriteModel:get_spritename()
	if _sprite_info.model_id then
		-- print("SpriteModel:get_spritename(_sprite_info.model_id)",_sprite_info.model_id)
		for i=1,#spirits_rebirth do
			-- print("SpriteModel:get_spritename(i,spirits_rebirth[i].modelId)",i,spirits_rebirth[i].modelId)
			if spirits_rebirth[i].modelId == _sprite_info.model_id then
				return spirits_rebirth[i].name
			end 
		end 
	end
	return nil
end

function  SpriteModel:get_spritename_by_modelid(model_id)
	if model_id then
		-- print("SpriteModel:get_spritename(_sprite_info.model_id)",_sprite_info.model_id)
		for i=1,#spirits_rebirth do
			-- print("SpriteModel:get_spritename(i,spirits_rebirth[i].modelId)",i,spirits_rebirth[i].modelId)
			if spirits_rebirth[i].modelId == model_id then
				return spirits_rebirth[i].name
			end 
		end 
	end
	return nil
end