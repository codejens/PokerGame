--DefaultSystemModel.lua
--create by tjh on 2015-5-4
--默认系统数据存储

DefaultSystemModel = {}

local _player_info = {} --玩家信息
local _player_pos = {} --玩家进入场景的位置

function DefaultSystemModel:init(  )
	_player_info = {}
end

function DefaultSystemModel:finish(  )
	_player_info = {}
	_player_pos = {}
end


--设置玩家属性
function DefaultSystemModel:set_player_info( info )
	_player_info = info
	_player_info.attribute.x = _player_pos.x
	_player_info.attribute.y = _player_pos.y
end

--设置玩家X,Y坐标 先创建的场景 再创建人物。先保存X,Y
function DefaultSystemModel:set_player_pos( x,y )
	print("x,y=======",x,y)
	_player_pos = cc.p(x,y)
end

--获取玩家属性
function DefaultSystemModel:get_player_info(  )
	return _player_info
end
