-- TransformModel.lua
-- created by aXing on 2014-5-9
-- 变身系统逻辑层

TransformModel = {}

TransformModel.TRANSFORM = 1
TransformModel.DEVELOP = 2
TransformModel.TUJIAN_ATTR = 3
TransformModel.AOYI_UPGRADE = 4
TransformModel.AOYI_ATTR = 5
TransformModel.TUJIAN_INACTIVE = 6
TransformModel.AOYI_INACTIVE = 7

TransformModel.TU_JIAN = 1
TransformModel.AO_YI = 2

local _transform_info = {}		-- 变身的原始数据，{id:TransformStruct, ...}
local _transform_index = -1     --变身所在位置
local _transform_points = 0
local _transform_countdown = -1	-- 变身倒计时
local _begin_countdown_time= 0
local _current_miji_level = 0
local _is_auto_upgrade_skill = false
local _is_auto_buy = false

local _current_selected_ninja = 1
local _current_selected_aoyi = 1
local _current_left_page = TransformModel.TU_JIAN
local _current_tujian_page = TransformModel.TRANSFORM
local _current_aoyi_page = TransformModel.AOYI_UPGRADE	

local _AOYI_MAX_LEVEL = 10

-- 是否需要更新变身倒计时
local _is_need_update_countdown = false

-- 申请初始化变身系统数据
function TransformModel:init(  )
	TransformCC:request_init()
end

function TransformModel:init_page( )
	_current_selected_ninja = 1
	_current_selected_aoyi = 1
	_current_left_page = TransformModel.TU_JIAN
	_current_tujian_page = TransformModel.TRANSFORM
	_current_aoyi_page = TransformModel.AOYI_UPGRADE	
end

-- 析构
function TransformModel:fini(  )
	_transform_info = {}
	_transform_countdown = -1

	_current_selected_ninja = 1
	_current_selected_aoyi = 1

	_current_left_page = TransformModel.TU_JIAN
	_current_tujian_page = TransformModel.TRANSFORM
	_current_aoyi_page = TransformModel.AOYI_UPGRADE
	_is_need_update_countdown = false
end

-- 初始化变身系统数据
function TransformModel:set_transform_data(sprite_struct)
	_transform_info=sprite_struct;
end

-- 获取变身系统数据
function TransformModel:get_transform_data( )
	return _transform_info
end
function TransformModel:get_yuli_crystal_count()
	local item_id = TransformConfig:get_curr_stage_crystal_item_id( )
	local count = ItemModel:get_item_count_by_id(item_id)
	return count;
end
-- 获取变身阶段等级
function TransformModel:get_transform_stage_level_by_id(model_id )
	local transforms_ = _transform_info.transforms
	for k,v in pairs(transforms_) do
		if model_id==v.id then
			return v.stage_level
		end
	end
	return 0
end

-- 获取变身阶段
function TransformModel:get_transform_stage_by_id(model_id )
	local transforms_ = _transform_info.transforms
	for k,v in pairs(transforms_) do
		if model_id==v.id then
			return v.stage
		end
	end
	return 0
end

-- 获取变身的等级
function TransformModel:get_transform_level_by_id(model_id )
	local transforms_ = _transform_info.transforms
	for k,v in pairs(transforms_) do
		if model_id==v.id then
			return transforms_[k].level
		end
	end
	return 0
end

-- 是否已激活变身
-- @param id:变身模型ID
function TransformModel:is_transform_active( id,level)
	local transforms_ = _transform_info.transforms
	for k,v in pairs(transforms_) do
		if id==v.id and level~=0 then
			-- ZXLog('-------------------变身id已经激活-----------------------',id)
			return true
		end
	end
	return false
end

-- 获取已有的碎片
function TransformModel:get_transform_pieces( id )
	for k,v in pairs(_transform_info.transforms) do
		if id == v.id then
			return v.pieces
		end
	end
	return 0
end

-- 是否已经获取得某个变身
-- @param id:变身ID
function TransformModel:is_has_transformm(id)
	local piece = TransformConfig:get_piece_num_by_id(id)
	local transforms_ = _transform_info.transforms
	for k,v in pairs(transforms_) do
		if id==v.id then
			if v.level > 0 or (v.level == 0 and v.pieces >= piece) then
			-- ZXLog('-------------------已经获得该变身-----------------------',id)
				return true
			else
				return false
			end
		end
	end
	-- ZXLog('-------------------尚未获得该变身-----------------------',id)
	return false
end

-- 取得正在变身ID
function TransformModel:get_cur_transform_id(  )
	return _transform_info.current_transform_id
end

-- 是否正在变身状态
-- @param id:变身模型ID
function TransformModel:is_transformming()
	local transforms_id = _transform_info.current_transform_id
	if transforms_id==0 then
		-- ZXLog('-------------未变身----------------',transforms_id)
		return false
	end
	-- ZXLog('-------------已在变身状态----------------',transforms_id)
	return true
end

-- 还原变身
function TransformModel:request_recover_transform( )
	TransformCC:request_recover_transform( )
end

-- 申请激活变身
-- @param id : 变身id
function TransformModel:request_active_transform( id )
	TransformCC:request_active_transform( id )
end

-- 申请变身
-- @param id : 变身id
function TransformModel:request_transform( id )
	 TransformCC:request_transform( id )
end

-- 申请变身培养
-- @param id : 申请培养的变身id
function TransformModel:request_develop( id )
	TransformCC:request_develop( id )
end

-- 申请秘籍进阶
-- @param id : 秘籍id
function TransformModel:request_upgrade_skill( id,auto )
	TransformCC:request_upgrade_skill( id ,auto)
end

-- 添加一个变身属性
function TransformModel:add_data( id,level,pieces,stage,stage_level,fight_value )
	-- ZXLog('---------------id,level,pieces,stage,level-----------------',id,level,pieces,stage,level)
	local _transform_count = _transform_info.transform_count+1
	_transform_info.transform_count=_transform_count
	_transform_info.transforms[_transform_count] 	      		= TransformConfig:get_ninja_model_by_id(id) 
	_transform_info.transforms[_transform_count].id     		=id
	_transform_info.transforms[_transform_count].level  		=level
	_transform_info.transforms[_transform_count].pieces 		=pieces
	_transform_info.transforms[_transform_count].stage  		=stage
	_transform_info.transforms[_transform_count].stage_level    =stage_level
	_transform_info.transforms[_transform_count].fight_value	=fight_value
	-- self:update_win()
	TransformModel:update_left_win()
	TransformModel:update_right_win()
end

-- 修改一个变身属性
function TransformModel:change_data(  id,level,pieces,stage,stage_level, fight_value )
	for k,v in pairs(_transform_info.transforms) do
		if v.id==id then
			v.level=level
			v.pieces=pieces
			v.stage=stage
			v.stage_level=stage_level
			v.fight_value = fight_value
			-- self:update_win()
			TransformModel:update_left_win()
			TransformModel:update_right_win()
			return
		end 
	end
end

-- 修改一个属性
function TransformModel:change_a_attr( id, key, val )
	for k,v in pairs(_transform_info.transforms) do
		if v.id == id then
			v[key] = val
			return
		end 
	end
end

-- 进阶结果
-- @id 变身id
-- @level 变身等级
-- @count 变身祝福值
function TransformModel:result_upgrade_stage( id, level, count )
	--print("***********result_upgrade_stage", id, level, count)
end

-- 培养结果
-- @id 变身id
-- @level 等级
-- @stage 阶级
function TransformModel:result_develop( id, level, stage )
	--print("***********result_develop", id, level, stage)
	self:change_a_attr(id, "stage", stage)
	self:change_a_attr(id, "stage_level", level)
	TransformModel:update_left_win()
	TransformModel:update_right_win()
	--xiehande 播放变身培养成功特效
	 local win = UIManager:find_visible_window("transform_right")
	 if win then
	 	win:play_trans_effect();
	 end

	-- local win = UIManager:find_visible_window("transform_dev_win")
	-- if win then
	-- 	win:set_transform_info(id)
	-- end
end

-- 秘籍升级结果
-- @skill_id  技能id
-- @skill_lvl 技能等级
-- @skill_exp 技能经验
function TransformModel:result_upgrade_skill(  skill_id, skill_lvl, skill_zhufu )
	--print("-------秘籍升级结果 kill_id, skill_lvl, skill_zhufu------", skill_id, skill_lvl, skill_zhufu )
	local _transform_info = TransformModel:get_transform_data( )
	for i,v in ipairs(_transform_info.mijis) do
		if v.id==skill_id then
			v.level=skill_lvl
			v.Zhufu=skill_zhufu
		end
	end

	-- local win = UIManager:find_visible_window("transform_win")
	-- if win then
	-- 	win.transformSkillPage:update_miji_info(skill_id,false)
	-- 	-- win.transformSkillPage:auto_up_skill(  )
	-- end
	TransformModel:update_left_win()
	TransformModel:update_right_win()

    --xiehande  进阶与一键进阶特效 播放
    if skill_lvl>TransformModel:get_current_miji_level() then   --进阶
     local win = UIManager:find_visible_window("transform_right")
	 if win then
	 	win:play_trans_effect()
	 end
    end

	if _is_auto_upgrade_skill and skill_lvl == TransformModel:get_current_miji_level() then
		TransformModel:auto_upgrade(skill_id, _is_auto_buy)
	elseif not _is_auto_upgrade_skill and skill_lvl == TransformModel:get_current_miji_level() then
		GlobalFunc:create_screen_notic("进阶失败")
	end
end

-- 获取技能提升限制
-- @remain_times 剩余提升次数
-- @money_times 元宝购买次数
-- @cd_time cd时间
function TransformModel:result_get_skill_limit( remain_times, money_times, cd_time )
	--print("*************result_get_skill_limit", remain_times, money_times, cd_time)
end

-- 获取总评分
-- @point 总评分
function TransformModel:result_get_total_point( point )
	-- print("*************result_get_total_point", point)
	_transform_info.fight_value = point

	-- local win = UIManager:find_visible_window("transform_win")
	-- if win ~= nil then
	-- 	win:update_point()
	-- 	return
	-- end
	TransformModel:update_left_win()
end

function TransformModel:get_total_point(  )
	return _transform_info.fight_value or 0
end

function TransformModel:get_point_by_id( id )
	for i,v in ipairs(_transform_info.transforms) do
		if v.id == id then
			-- print('=======id, v.fight_value: ', id, v.fight_value)
			return v.fight_value or 0
		end
	end
	return 0
end

function TransformModel:set_transform_point_by_id( id, val )
	for i,v in ipairs(_transform_info.transforms) do
		if v.id == id then
			v.fight_value = val
			return
		end
	end
end

function TransformModel:set_miji_point_by_id( id, val )
	for i,v in ipairs(_transform_info.mijis) do
		if v.id == id then
			v.fight_value = val
			return
		end
	end
end

-- 获取某秘籍
function TransformModel:get_miji_info_by_id( id )
	local mijis = _transform_info.mijis
	for k,v in pairs(mijis) do
		if v.id == id then
			return v
		end
	end
	return nil
end

function TransformModel:set_current_miji_level( lv )
	_current_miji_level = lv
end

function TransformModel:get_current_miji_level(  )
	return _current_miji_level
end

function TransformModel:set_auto_upgrade_skill( flag )
	_is_auto_upgrade_skill = flag
end

function TransformModel:get_auto_upgrade_skill(  )
	return _is_auto_upgrade_skill
end

-- 自动升级秘籍
function TransformModel:auto_upgrade( id, auto_buy )
	_is_auto_buy = auto_buy

    TransformModel:up_grade_miji(id, auto_buy)

end

--升级秘籍
function TransformModel:up_grade_miji( id, auto_buy )

    local _miji_info = TransformModel:get_miji_info_by_id(id)
    local skill_level = _miji_info.level
    local money_type = MallModel:get_only_use_yb() and 3 or 2

	local count = TransformModel:get_yuli_crystal_count()
	
	if auto_buy then
		-- 自动购买道具
		local yb_cost = TransformConfig:get_upgrad_cost_by_level(skill_level)
		-- if  PlayerAvatar:check_is_enough_money(4, yb_cost) then
		-- 	TransformCC:request_upgrade_skill( id, auto_buy )
		-- end
		local param = {id, auto_buy, money_type}
		local upgrade_func = function( param )
			TransformCC:request_upgrade_skill(param[1], param[2], param[3])
		end
		MallModel:handle_auto_buy( yb_cost, upgrade_func, param )
    else
    	--纯道具升阶
    	-- 从背包获取当前阶级晶片的数量
		local ciritical_count = TransformConfig:get_upgrad_need_critical(skill_level)
		if  ciritical_count > count then
			GlobalFunc:create_screen_notic( "进阶丹不足." );
		else
			TransformCC:request_upgrade_skill( id, auto_buy, money_type )
		end
	end
end

-- 获取新技能
function TransformModel:do_get_new_skill( skill_id,skill_lvl,skill_zhufu )
	-- print("-------获取新秘籍 kill_id, skill_lvl, skill_zhufu------", skill_id, skill_lvl, skill_zhufu )
	local _transform_info = TransformModel:get_transform_data( )
	local miji_count =_transform_info.miji_count+1
	_transform_info.miji_count=miji_count
	_transform_info.mijis[miji_count]=TransformConfig:get_miji_info_by_id( miji_count )
	_transform_info.mijis[miji_count].id=skill_id
	_transform_info.mijis[miji_count].level=skill_lvl
	_transform_info.mijis[miji_count].Zhufu=skill_zhufu

	-- local win = UIManager:find_visible_window("transform_win")
	-- if win then
	-- 	win.transformSkillPage:update()
	-- end
	TransformModel:update_left_win()
	TransformModel:update_right_win()
end

function TransformModel:get_miji_level_by_id( id )
	for i,v in ipairs(_transform_info.mijis) do
		if v.id == id then
			return v.level
		end
	end
	return 0
end

function TransformModel:check_aoyi_max_level( id )
	for i,v in ipairs(_transform_info.mijis) do
		if v.id == id then
			return v.level >= _AOYI_MAX_LEVEL
		end
	end
	return false
end

function TransformModel:get_aoyi_max_level( )
	return _AOYI_MAX_LEVEL
end

------------------------------------------
--
-- 与界面交互
--
------------------------------------------

-- 更新界面
function TransformModel:update_win(  )
	-- local win = UIManager:find_visible_window("transform_win")
	-- if win ~= nil then
	-- 	win:update()
	-- 	return
	-- end
end

-- 从服务器端获取变身倒计时
function TransformModel:do_get_count_down( countDown )
	self:SetTransformIsNeedUpdateState(false)
	_transform_countdown = countDown
	-- 变身倒计时已开启(倒计时已结束还未领取变身,或者倒计时还未结束)
	local rightTopPanel = UIManager:find_window("right_top_panel")
	if rightTopPanel then
		rightTopPanel:show_expe_transform_btn(countDown)
	end
	local transPreWin = UIManager:find_visible_window("transform_preview_win")
	if transPreWin then
		transPreWin:updateTime(countDown)
	end
end

-- 提供给外部使用的后去变身系统倒计时的方法
function TransformModel:get_count_down()
	return _transform_countdown;
end

function TransformModel:get_begin_count_timer()
	return _begin_countdown_time;
end

-- 提供给外部调用的更新倒计时之间的方法
function TransformModel:update_count_down( countDown )
	_transform_countdown = countDown;
end

-- 向服务器请求变身系统倒计时剩余时间
function TransformModel:request_transform_count_down()
	-- TODO
end

function TransformModel:do_get_transform_system()
	_transform_countdown = -2;

	-- 移出倒计时按钮
	local rightTopPanel = UIManager:find_window( "right_top_panel" )
	if rightTopPanel then
		rightTopPanel:remove_btn( 12 );
	end

	-- 删除变身预览窗口
	UIManager:destroy_window( "transform_preview_win" );

	-- 掉落变身系统图标
	--Instruction:open_new_sys( GameSysModel.TRANSFORM, false )
	EventSystem.postEvent('openSystem',GameSysModel.TRANSFORM)

	-- 3.5s后显示变身系统窗口
	--local cb = callback:new();
	--local function func()
		--local win = UIManager:show_window( "transform_left" )
		-- if Instruction then
		-- 	Instruction:fini()
		-- end
		-- Instruction:init(false)
		-- Instruction:start( 6 );
	--end

	--cb:start(3.2,func);
end

function TransformModel:add_transform_fuben_instruction()
	-- if Instruction then
	-- 	Instruction:fini()
	-- end
	-- Instruction:init(false)
	Instruction:start( 19 );
end

function TransformModel:check_aoyi_actived( id )
	local _transform_info = TransformModel:get_transform_data( )
 	for i,v in pairs(_transform_info.mijis) do
 		if v.id == id then
 			return true
 		end
 	 end
 	 return false
end

function TransformModel:set_current_selected_ninja( id )
	_current_selected_ninja = id
end

function TransformModel:get_current_selected_ninja( )
	return _current_selected_ninja
end

function TransformModel:set_current_selected_aoyi( id )
	_current_selected_aoyi = id
end

function TransformModel:get_current_selected_aoyi( )
	return _current_selected_aoyi
end

function TransformModel:set_current_left_page( page )
	_current_left_page = page
end

function TransformModel:get_current_left_page( )
	return _current_left_page
end

function TransformModel:set_current_tujian_page( page )
	_current_tujian_page = page
end

function TransformModel:get_current_tujian_page( )
	return _current_tujian_page
end

function TransformModel:set_current_aoyi_page( page )
	_current_aoyi_page = page
end

function TransformModel:get_current_aoyi_page( )
	return _current_aoyi_page
end

function TransformModel:update_right_win( )
	local left_win = UIManager:find_visible_window("transform_left")
	local right_win = UIManager:find_visible_window("transform_right")
	if left_win and not right_win then
		right_win = UIManager:show_window("transform_right")
	end
	if right_win and right_win.update then
		right_win:update("all")
	end
end

function TransformModel:update_left_win( )
	local win = UIManager:find_visible_window("transform_left")
	-- if not win then
	-- 	win = UIManager:show_window("transform_left")
	-- end
	if win and win.update then
		win:update("all")
	end
end

function TransformModel:change_right_win( win_type )
	local win = UIManager:find_visible_window("transform_right")
	if not win then
		win = UIManager:show_window("transform_right")
	end
	if win and win.update then
		win:update(win_type)
	end
end

-- 测试当前状态是否可以申请，重新发送变身倒计时
function TransformModel:CheckIsCanUpdateState()
	-- -1:未开启倒计时 -2:变身已开启，不需要倒计时了
	if _transform_countdown == -1 or _transform_countdown == -2 or _transform_countdown == 0 then
		return
	elseif _transform_countdown > 0 then
		self:SetTransformIsNeedUpdateState(true)
	end
end

-- 设置变身体验倒计时是否需要更新,如果需要,就发送请求到服务器,获取最新的剩余倒计时
function TransformModel:SetTransformIsNeedUpdateState(isNeed)
	_is_need_update_countdown = isNeed
end

-- 获取是否需要更新变身倒计时的状态
function TransformModel:GetTransformIsNeedUpdateState()
	return _is_need_update_countdown
end