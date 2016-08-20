-- LuopanModel.lua
-- created by lyl on 2013-9-4
-- 罗盘

LuopanModel = {}


local _remain_times = 0       -- 剩余次数
local _gold_num = 0           -- 角色元宝数
local _appear_item_t = {}     -- 珍品出先记录
local _my_appear_item_t = {}     -- 我的珍品出先记录
local _luopan_result_curr = 1 -- 当前罗盘返回结果
local _is_pass_ani = false;
local _is_key_to_ten = false; -- 一键十次抽取功能
local _AUTO_MAX = 10           -- 自动抽奖次数
local _auto_count = _AUTO_MAX         -- 自动抽奖计数
local _is_key_to_ten_running = false	-- 标记是否处于十连抽
local _NEED_GOLD_PER_TIME = 20;	-- 单次抽奖所需元宝

function LuopanModel:fini( ... )
    _remain_times = 0
    _gold_num = 0
    _appear_item_t = {}
    _my_appear_item_t = {}
    _luopan_result_curr = 1
    _is_pass_ani = false;
    _is_key_to_ten = false;
    _is_key_to_ten_running = false;
    UIManager:destroy_window( "luopan_win" )
end

function LuopanModel:get_need_gold_per_time()
	return _NEED_GOLD_PER_TIME;
end

function LuopanModel:get_is_pass_ani()
	return _is_pass_ani;
end

function LuopanModel:set_is_pass_ani( is_pass_ani )
	_is_pass_ani = is_pass_ani
	print("_is_pass_ani",_is_pass_ani)
end

function LuopanModel:get_is_key_to_ten()
	return _is_key_to_ten;
end

function LuopanModel:set_is_key_to_ten( is_key_to_ten )
	_is_key_to_ten = is_key_to_ten
end

-- 获取
function LuopanModel:get_luopan_awards(  )
    local luopan_awards = LuopanConfig:get_luopan_item(  )or {}
    return luopan_awards
end

-- 显示道具tips 
function LuopanModel:show_tips( item_id, x, y )
	TipsModel:show_shop_tip( x, y, item_id )
end

-- 设置幸运打转盘信息
function LuopanModel:set_luopan_data( remain_times, gold_num )
	print("设置幸运打转盘信息:::::::", remain_times, gold_num)
	_remain_times = remain_times
    _gold_num = gold_num
    LuoPanWin:update_static( "luopan_date" )
end

-- 获取剩余次数
function LuopanModel:get_remain_times(  )
	return _remain_times
end

-- 获取角色元宝数
function LuopanModel:get_gold_num(  )
	return _gold_num
end

--检查是否足够十次
function LuopanModel:check_can_ten(  )
    if _remain_times < _AUTO_MAX and _gold_num < _NEED_GOLD_PER_TIME * _AUTO_MAX then 
        local function confirm2_func()
            GlobalFunc:chong_zhi_enter_fun()
        end
        ConfirmWin2:show( 2, 2, Lang.luopan[7] .. _AUTO_MAX .. Lang.luopan[8],  confirm2_func)	--[7] = "所剩元宝不足",[8] = "次",
        return false
    else
        return true
    end
end

-- 设置珍品出现记录
function LuopanModel:set_appear_items( items )
	_appear_item_t = items or {}
	LuoPanWin:update_static( "appear_items" )
end

-- 获取珍品出现记录
function LuopanModel:get_appear_items(  )
	return _appear_item_t
end

-- 根据序号，获取珍品出现记录的某项
function LuopanModel:get_appear_item( index )
	local item = _appear_item_t[ index ] or {}
	return item
end

-- 设置我的珍品出现记录
function LuopanModel:set_my_appear_items( items )
	_my_appear_item_t = items or {}
	LuoPanWin:update_static( "my_appear_items" )
end

-- 获取我的珍品出现记录
function LuopanModel:get_my_appear_items(  )
	return _my_appear_item_t
end

-- 根据序号，获取我的珍品出现记录的某项
function LuopanModel:get_my_appear_item( index )
	local item = _my_appear_item_t[ index ] or {}
	return item
end

-- 增加一个珍品
function LuopanModel:add_appear_item( item )
    table.insert( _appear_item_t, 1, item )
    LuoPanWin:update_static( "appear_items" )
end

-- 设置当前罗盘返回结果
function LuopanModel:set_luopan_result( result_index )
	print("罗盘返回结果", result_index)
	_luopan_result_curr = result_index

    -- 如果自动抽奖计数还没到，继续自动抽奖。
    if  _auto_count < _AUTO_MAX then 
        LuopanModel:luopan_end(  )
        LuopanModel:req_luopan_get_award( 1 )
    else
    	-- 兼容一下斩仙和灭天的做法
    	if _is_key_to_ten_running == true then
    		-- 灭天做法
    		_is_key_to_ten_running = false
	        LuoPanWin:update_static( "luopan_result" )
	        LuopanModel:luopan_end(  )
	    else
	    	-- 斩仙做法
			LuoPanWin:update_static( "luopan_result" )
	    end
    end
end

-- 获取当前罗盘结果
function LuopanModel:get_luopan_result(  )
	return _luopan_result_curr
end

-- 检查是否还有抽奖道具，如果没有，就弹出提示
function LuopanModel:check_remain_times(  )
	if _remain_times < 1 then 

	end
	return true;
end

-- 打开罗盘窗口
function LuopanModel:open_luopan(  )
	local remain_time = SmallOperationModel:get_act_time( SmallOperationModel.ACT_TYPE_LUOPAN ) or 0
	if remain_time > 1 then 
        UIManager:show_window( "luopan_win" )
    else 
    	local show_content = "活动已经结束"
        GlobalFunc:create_screen_notic( show_content )
	end
end

-- 自动十次
function LuopanModel:key_to_ten(  )
    _auto_count = 0
    _is_key_to_ten_running = true;
    LuopanModel:req_luopan_get_award( 1 )
end

-- ***************************************
--  与服务器通讯
-- ***************************************
-- 请求幸运大转盘活动信息
function LuopanModel:req_luopan_data(  )
	MiscCC:req_luopan_data(  )
end

-- 请求幸运大转盘珍品列表记录
function LuopanModel:req_luopan_item_record(  )
	MiscCC:req_luopan_item_record(  )
end

-- 请求幸运大转盘我的抽奖列表记录
function LuopanModel:req_luopan_my_item_record(  )
	MiscCC:req_luopan_my_item_record(  )
end

-- 幸运大转盘活动请求抽奖
function LuopanModel:req_luopan_get_award( show_animation )
	-- if _remain_times < 1 then 
	-- 	local show_content = "没有抽奖道具，无法进行抽奖。"
 --        GlobalFunc:create_screen_notic( show_content )
 --        return 
	-- end
	MiscCC:req_luopan_get_award( show_animation )

    -- 因为只要 _auto_count 超过最大次数，就不会自动抽奖。 所以在这里计数+1
    _auto_count = _auto_count + 1       
end

-- 通知服务器，罗盘转动已经停止 （珍品列表）
function LuopanModel:luopan_end(  )
	MiscCC:luopan_end(  )
	-- 罗盘停止时，刷新我的珍品记录.十连抽时，最后再请求，避免连续十次请求
	if _is_key_to_ten_running == false then
		MiscCC:req_luopan_my_item_record(  )
	end
end