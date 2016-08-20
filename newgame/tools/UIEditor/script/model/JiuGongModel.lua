-- JiuGongModel.lua
-- created by lxm on 2014-7-21
-- 九宫神藏 动态数据

JiuGongModel = {}

local _gezi_info = {} --格子信息
local _shuaxin_count = 0  -- 刷新次数
local _has_chou_item ={}  --已经抽取的物品序号


function JiuGongModel:fini( ... )
	_gezi_info = {}
end

-- 设置格子信息
function JiuGongModel:set_gezi_info( gezi_info)
	_gezi_info = gezi_info
end
-- 获取格子信息
function JiuGongModel:get_gezi_info( )
	return _gezi_info 
end

-- 设置刷新次数
function JiuGongModel:set_shuaxin_count( shuaxin_count)
	_shuaxin_count = shuaxin_count
end
-- 获取刷新次数
function JiuGongModel:get_shuaxin_count( )
	return _shuaxin_count 
end

-- 获取已经抽取的物品序号
function JiuGongModel:get_has_chou_item( ... )
	_has_chou_item = {}
	for i=1,9 do
	    if _gezi_info[i].status==1 then
	        table.insert( _has_chou_item , i )
	    end
	end
	return _has_chou_item
end

-- 设置某个格子状态为灰色
function JiuGongModel:set_gezi_status( index)
	if #_gezi_info >0 then
		_gezi_info[index].status = 1
	end
end

-- 获取还没抽取的物品序号
function JiuGongModel:get_no_chou_item( ... )
	_no_chou_item = {}
	for i=1,9 do
	    if _gezi_info[i].status==0 then
	        table.insert( _no_chou_item , i )
	    end
	end
	return _no_chou_item
end








