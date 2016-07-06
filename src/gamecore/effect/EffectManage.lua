--EffectManage.lua
--create by tjh on 2015-5-7
--特效类
-----------------------------------------------------------------------------
-- 特效类 提供一些特效播放方法
-- @author tjh
-- @release 1
-----------------------------------------------------------------------------

--!class EffectManage

EffectManage = {}

--默认动作id
local _default_action_id = 0 

--- 初始化函数
function EffectManage:init()

end

--- 播放特效函数
-- @param node 释放目标
-- @param path 特效路径
-- @param id 特效id
-- @param json 特效json
-- @param loop 是否循环 如果不循环的 播放一次会自动删除 默认不循环
-- @param x,y 释放位置 默认0,0
function EffectManage:play_effect( node,id,loop,x,y )

	-- local node = EffectManage:_create_effect(node,id,x,y)
	-- EffectManage:_playAction(node,loop)
	-- return node
end

--- 播放技能特效函数
-- @param node 释放目标
-- @param x,y 释放位置
-- @param path 特效路径
-- @param id 特效id
-- @param json 特效json
-- @param loop 是否循环 如果不循环的 播放一次会自动删除 默认不循环
-- @param dir 特效方向，基本没有方向不传，例如技能特效有方向就要传 默认0
-- @param isflip 是否翻转x 技能特效有些需要 默认false
function EffectManage:play_skill_effect( node,id,loop,x,y,action_id,isflip )
	--print(node,path,json,id,loop,x,y,action_id,isflip)
	local sprite = EffectManage:_create_effect(node,id,loop,x,y)
	sprite:setFlippedX(isflip or false)
	EffectManage:_playAction(sprite,loop,action_id)
end

--移除特效函数 移除一个节点上同一个特效ID的所有特效
-- @param node 移除目标
-- @param id特效ID
function EffectManage:remove_effect( ndoe,id )
	local effect = node:getChildByTag(id)
	
	while( effect )
	do
		effect:removeFromParent(true)
		effect = node:getChildByTag(id)
	end
end


--必杀技函数
function EffectManage:play_bs_effect(node,id)
	local x = 1
	local y = 1
	local time = math.random(1,10)*0.1
	for i=1,15 do
		x = (i%5)*220 - 400
		y = math.ceil(i/5)*220 - 430
		time = math.random(1,5)*0.2
		local sprite = EffectManage:_create_effect(node,id,false,x,y)

		local function cb_func( )
			EffectManage:_playAction(sprite,false)
		end
		local call_back = callback:create()
		call_back:start(time,cb_func)
	end

end

function EffectManage:_create_effect( node,id,loop,x,y )
	local sprite = ccsext.XAnimateSprite:create()
	local effect_config = EffectConfig:get_effect_by_id( id )
    --添加监听
    if not loop then
	    cocosEventHelper.listenFrameEvent(sprite,
	    function(id, event) 
	    	if id == cocosEventHelper.AnimateEvent.eFrameEnd then
	    		node:removeChild(sprite,true)
	    	end
	    end)
    end
    sprite:initWithActionJson(effect_config.path,effect_config.json)
	sprite:setPosition(x or 0,y or 0)
	node:addChild(sprite,255,id)
    return sprite
end

function EffectManage:_playAction( node,loop,action_id )
	node:playAction(action_id or _default_action_id,loop or false) 
end


--屏幕抖动
--@param dir 方向 (1,y方向  2 x方向 3两个方向以一起)
--@param 持续时间
--@param range 抖动幅度 
function EffectManage:play_screen_jitter( dir,times,range )
	SceneCamera:play_screen_jitter(  dir,times,range )
end