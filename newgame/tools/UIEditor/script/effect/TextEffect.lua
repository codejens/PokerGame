
-- 资源类型定义
FLOW_COLOR_TYPE_BLUE  = 1 			-- 蓝色字
FLOW_COLOR_TYPE_RED   = 2 			-- 红色字
FLOW_COLOR_TYPE_GREEN = 3 			-- 绿色字
FLOW_COLOR_TYPE_YELLOW = 4 			-- 黄色字
FLOW_COLOR_TYPE_YELLOW_COUNT = 5 	-- 小黄色字(用于显示数量)
FLOW_COLOR_TYPE_YELLOW_ENHANCE = 6 	-- 小黄色字(用于显示强化等级)
FLOW_COLOR_TYPE_YELLOW_GEM 	= 7 	-- 繁体黄色字(用于显示宝石等级)

--数字
local code_m = string.byte('-')
local code_p = string.byte('+')
local code_0 = string.byte('0')
local code_1 = string.byte('1')
local code_2 = string.byte('2')
local code_3 = string.byte('3')
local code_4 = string.byte('4')
local code_5 = string.byte('5')
local code_6 = string.byte('6')
local code_7 = string.byte('7')
local code_8 = string.byte('8')
local code_9 = string.byte('9')

--暴击
local code_a = string.byte('a')
--生命
local code_b = string.byte('b')
--法力
local code_c = string.byte('c')
--命中
local code_d = string.byte('d')
--闪避
local code_e = string.byte('e')

--物理攻击
local code_f = string.byte('f')
--物理防御
local code_g = string.byte('g')
--法力攻击
local code_h = string.byte('h')
--法力防御
local code_i = string.byte('i')

local textGap = 20
local signGap = 12
local textHeight = 38
local flow_text_z = 5

Flow_Text_Config = 
{
	[FLOW_COLOR_TYPE_BLUE] = 
	{ 
		[code_m] = 'ui/fonteffect/b-.png',
		[code_p] = 'ui/fonteffect/b+.png',
		[code_0] = 'ui/fonteffect/b0.png',
		[code_1] = 'ui/fonteffect/b1.png',
		[code_2] = 'ui/fonteffect/b2.png',
		[code_3] = 'ui/fonteffect/b3.png',
		[code_4] = 'ui/fonteffect/b4.png',
		[code_5] = 'ui/fonteffect/b5.png',
		[code_6] = 'ui/fonteffect/b6.png',
		[code_7] = 'ui/fonteffect/b7.png',
		[code_8] = 'ui/fonteffect/b8.png',
		[code_9] = 'ui/fonteffect/b9.png',
	},

	[FLOW_COLOR_TYPE_RED] = 
	{ 
		[code_m] = 'ui/fonteffect/r-.png',
		[code_p] = 'ui/fonteffect/r+.png',
		[code_0] = 'ui/fonteffect/r0.png',
		[code_1] = 'ui/fonteffect/r1.png',
		[code_2] = 'ui/fonteffect/r2.png',
		[code_3] = 'ui/fonteffect/r3.png',
		[code_4] = 'ui/fonteffect/r4.png',
		[code_5] = 'ui/fonteffect/r5.png',
		[code_6] = 'ui/fonteffect/r6.png',
		[code_7] = 'ui/fonteffect/r7.png',
		[code_8] = 'ui/fonteffect/r8.png',
		[code_9] = 'ui/fonteffect/r9.png',
	},


	[FLOW_COLOR_TYPE_GREEN] = 
	{ 
		[code_p] = 'ui/fonteffect/g+.png',
		[code_0] = 'ui/fonteffect/g0.png',
		[code_1] = 'ui/fonteffect/g1.png',
		[code_2] = 'ui/fonteffect/g2.png',
		[code_3] = 'ui/fonteffect/g3.png',
		[code_4] = 'ui/fonteffect/g4.png',
		[code_5] = 'ui/fonteffect/g5.png',
		[code_6] = 'ui/fonteffect/g6.png',
		[code_7] = 'ui/fonteffect/g7.png',
		[code_8] = 'ui/fonteffect/g8.png',
		[code_9] = 'ui/fonteffect/g9.png',
	},

	[FLOW_COLOR_TYPE_YELLOW] =
	{
		[code_m] = 'ui/fonteffect/y-.png',
		[code_p] = 'ui/fonteffect/y+.png',
		[code_0] = 'ui/fonteffect/y0.png',
		[code_1] = 'ui/fonteffect/y1.png',
		[code_2] = 'ui/fonteffect/y2.png',
		[code_3] = 'ui/fonteffect/y3.png',
		[code_4] = 'ui/fonteffect/y4.png',
		[code_5] = 'ui/fonteffect/y5.png',
		[code_6] = 'ui/fonteffect/y6.png',
		[code_7] = 'ui/fonteffect/y7.png',
		[code_8] = 'ui/fonteffect/y8.png',
		[code_9] = 'ui/fonteffect/y9.png',
	},

	[FLOW_COLOR_TYPE_YELLOW_COUNT] =
	{
		--[code_m] = 'ui/fontEffect/y-.png',
		--[code_p] = 'ui/fontEffect/y+.png',
		[code_0] = 'ui/fonteffect/sy0.png',
		[code_1] = 'ui/fonteffect/sy1.png',
		[code_2] = 'ui/fonteffect/sy2.png',
		[code_3] = 'ui/fonteffect/sy3.png',
		[code_4] = 'ui/fonteffect/sy4.png',
		[code_5] = 'ui/fonteffect/sy5.png',
		[code_6] = 'ui/fonteffect/sy6.png',
		[code_7] = 'ui/fonteffect/sy7.png',
		[code_8] = 'ui/fonteffect/sy8.png',
		[code_9] = 'ui/fonteffect/sy9.png',
	},

	[FLOW_COLOR_TYPE_YELLOW_ENHANCE] = 
	{
		[code_p] = "ui/fonteffect/e+.png",
		[code_0] = "ui/fonteffect/e0.png",
		[code_1] = "ui/fonteffect/e1.png",
		[code_2] = "ui/fonteffect/e2.png",
		[code_3] = "ui/fonteffect/e3.png",
		[code_4] = "ui/fonteffect/e4.png",
		[code_5] = "ui/fonteffect/e5.png",
		[code_6] = "ui/fonteffect/e6.png",
		[code_7] = "ui/fonteffect/e7.png",
		[code_8] = "ui/fonteffect/e8.png",
		[code_9] = "ui/fonteffect/e9.png",
	},

	-- 天降雄师添加：
	['hit'] = 
	{
		[code_m] = 'ui/fonteffect/b-.png',
		[code_p] = 'ui/fonteffect/b+.png',
		[code_0] = 'ui/fonteffect/b0.png',
		[code_1] = 'ui/fonteffect/b1.png',
		[code_2] = 'ui/fonteffect/b2.png',
		[code_3] = 'ui/fonteffect/b3.png',
		[code_4] = 'ui/fonteffect/b4.png',
		[code_5] = 'ui/fonteffect/b5.png',
		[code_6] = 'ui/fonteffect/b6.png',
		[code_7] = 'ui/fonteffect/b7.png',
		[code_8] = 'ui/fonteffect/b8.png',
		[code_9] = 'ui/fonteffect/b9.png',
	},
	['maxMp'] = 
	{
		[code_m] = 'ui/fonteffect/y-.png',
		[code_p] = 'ui/fonteffect/y+.png',
		[code_0] = 'ui/fonteffect/y0.png',
		[code_1] = 'ui/fonteffect/y1.png',
		[code_2] = 'ui/fonteffect/y2.png',
		[code_3] = 'ui/fonteffect/y3.png',
		[code_4] = 'ui/fonteffect/y4.png',
		[code_5] = 'ui/fonteffect/y5.png',
		[code_6] = 'ui/fonteffect/y6.png',
		[code_7] = 'ui/fonteffect/y7.png',
		[code_8] = 'ui/fonteffect/y8.png',
		[code_9] = 'ui/fonteffect/y9.png',
	},
	['outAttack'] = 
	{
		[code_m] = 'ui/fonteffect/f_g.png',
		[code_p] = 'ui/fonteffect/f_g+.png',
		[code_0] = 'ui/fonteffect/f_g0.png',
		[code_1] = 'ui/fonteffect/f_g1.png',
		[code_2] = 'ui/fonteffect/f_g2.png',
		[code_3] = 'ui/fonteffect/f_g3.png',
		[code_4] = 'ui/fonteffect/f_g4.png',
		[code_5] = 'ui/fonteffect/f_g5.png',
		[code_6] = 'ui/fonteffect/f_g6.png',
		[code_7] = 'ui/fonteffect/f_g7.png',
		[code_8] = 'ui/fonteffect/f_g8.png',
		[code_9] = 'ui/fonteffect/f_g9.png',
	},
	['outDefence'] = 
	{
		[code_m] = 'ui/fonteffect/f_g.png',
		[code_p] = 'ui/fonteffect/f_g+.png',
		[code_0] = 'ui/fonteffect/f_g0.png',
		[code_1] = 'ui/fonteffect/f_g1.png',
		[code_2] = 'ui/fonteffect/f_g2.png',
		[code_3] = 'ui/fonteffect/f_g3.png',
		[code_4] = 'ui/fonteffect/f_g4.png',
		[code_5] = 'ui/fonteffect/f_g5.png',
		[code_6] = 'ui/fonteffect/f_g6.png',
		[code_7] = 'ui/fonteffect/f_g7.png',
		[code_8] = 'ui/fonteffect/f_g8.png',
		[code_9] = 'ui/fonteffect/f_g9.png',
	},
	['innerAttack'] =
	{
		[code_m] = 'ui/fonteffect/zycm-.png',
		[code_p] = 'ui/fonteffect/zycm+.png',
		[code_0] = 'ui/fonteffect/zycm0.png',
		[code_1] = 'ui/fonteffect/zycm1.png',
		[code_2] = 'ui/fonteffect/zycm2.png',
		[code_3] = 'ui/fonteffect/zycm3.png',
		[code_4] = 'ui/fonteffect/zycm4.png',
		[code_5] = 'ui/fonteffect/zycm5.png',
		[code_6] = 'ui/fonteffect/zycm6.png',
		[code_7] = 'ui/fonteffect/zycm7.png',
		[code_8] = 'ui/fonteffect/zycm8.png',
		[code_9] = 'ui/fonteffect/zycm9.png',
	},
	['innerDefence'] =
	{
		[code_m] = 'ui/fonteffect/zycm-.png',
		[code_p] = 'ui/fonteffect/zycm+.png',
		[code_0] = 'ui/fonteffect/zycm0.png',
		[code_1] = 'ui/fonteffect/zycm1.png',
		[code_2] = 'ui/fonteffect/zycm2.png',
		[code_3] = 'ui/fonteffect/zycm3.png',
		[code_4] = 'ui/fonteffect/zycm4.png',
		[code_5] = 'ui/fonteffect/zycm5.png',
		[code_6] = 'ui/fonteffect/zycm6.png',
		[code_7] = 'ui/fonteffect/zycm7.png',
		[code_8] = 'ui/fonteffect/zycm8.png',
		[code_9] = 'ui/fonteffect/zycm9.png',
	},
	['maxHp'] =
	{
		[code_m] = 'ui/fonteffect/g-.png',
		[code_p] = 'ui/fonteffect/g+.png',
		[code_0] = 'ui/fonteffect/g0.png',
		[code_1] = 'ui/fonteffect/g1.png',
		[code_2] = 'ui/fonteffect/g2.png',
		[code_3] = 'ui/fonteffect/g3.png',
		[code_4] = 'ui/fonteffect/g4.png',
		[code_5] = 'ui/fonteffect/g5.png',
		[code_6] = 'ui/fonteffect/g6.png',
		[code_7] = 'ui/fonteffect/g7.png',
		[code_8] = 'ui/fonteffect/g8.png',
		[code_9] = 'ui/fonteffect/g9.png',
	},
	['dodge'] =
	{
		[code_m] = 'ui/fonteffect/b-.png',
		[code_p] = 'ui/fonteffect/b+.png',
		[code_0] = 'ui/fonteffect/b0.png',
		[code_1] = 'ui/fonteffect/b1.png',
		[code_2] = 'ui/fonteffect/b2.png',
		[code_3] = 'ui/fonteffect/b3.png',
		[code_4] = 'ui/fonteffect/b4.png',
		[code_5] = 'ui/fonteffect/b5.png',
		[code_6] = 'ui/fonteffect/b6.png',
		[code_7] = 'ui/fonteffect/b7.png',
		[code_8] = 'ui/fonteffect/b8.png',
		[code_9] = 'ui/fonteffect/b9.png',
	},
	['criticalStrikes'] =
	{
		[code_m] = 'ui/fonteffect/f_g.png',
		[code_p] = 'ui/fonteffect/f_g+.png',
		[code_0] = 'ui/fonteffect/f_g0.png',
		[code_1] = 'ui/fonteffect/f_g1.png',
		[code_2] = 'ui/fonteffect/f_g2.png',
		[code_3] = 'ui/fonteffect/f_g3.png',
		[code_4] = 'ui/fonteffect/f_g4.png',
		[code_5] = 'ui/fonteffect/f_g5.png',
		[code_6] = 'ui/fonteffect/f_g6.png',
		[code_7] = 'ui/fonteffect/f_g7.png',
		[code_8] = 'ui/fonteffect/f_g8.png',
		[code_9] = 'ui/fonteffect/f_g9.png',
	},
	['exp'] =
	{
		[code_m] = 'ui/fonteffect/f_g.png',
		[code_p] = 'ui/fonteffect/f_g+.png',
		[code_0] = 'ui/fonteffect/f_g0.png',
		[code_1] = 'ui/fonteffect/f_g1.png',
		[code_2] = 'ui/fonteffect/f_g2.png',
		[code_3] = 'ui/fonteffect/f_g3.png',
		[code_4] = 'ui/fonteffect/f_g4.png',
		[code_5] = 'ui/fonteffect/f_g5.png',
		[code_6] = 'ui/fonteffect/f_g6.png',
		[code_7] = 'ui/fonteffect/f_g7.png',
		[code_8] = 'ui/fonteffect/f_g8.png',
		[code_9] = 'ui/fonteffect/f_g9.png',
	},
}

Flow_Text_Prefix_Config = 
{
	['dodge'] = 	    'ui/fonteffect/dodge.png',
	['hit'] = 		    'ui/fonteffect/hit.png',
	['innerAttack'] =   'ui/fonteffect/innerAttack.png',
	['innerDefence'] =  'ui/fonteffect/innerDefence.png',
	['maxHp'] = 	    'ui/fonteffect/maxHp.png',
	['maxMp'] = 	    'ui/fonteffect/maxMp.png',
	['outAttack'] =     'ui/fonteffect/outAttack.png',
	['outDefence'] =    'ui/fonteffect/outDefence.png',
	['criticalStrikes']='ui/fonteffect/criticalStrikes.png',
	['critical']       ='ui/fonteffect/critical.png',
	['exp']			   ='ui/fonteffect/exp.png',
}

local _flowTextTimer = timer()
local _flow_text_queue = {}

local _flowAttrTimer = timer()
local _flow_attr_queue = {}

TextEffect = {}

local _createFlowAttr = effectCreator.createFlowAttr
local _createFlowCritical = effectCreator.createFlowCritical
local _createSkillName = effectCreator.createSkillName

function TextEffect:init(sceneroot, uiroot)
	self.sceneRoot = sceneroot
	self.uiRoot = CCNode:node()
	self.killSkillNamecallback = callback:new()

	--界面文字特效根
	uiroot:addChild(self.uiRoot,Z_UI_TEXT_EFFECT)
end

function TextEffect:scene_leave()
	_flowTextTimer:stop()
	_flow_text_queue = {}

	_flowAttrTimer:stop()
	_flow_attr_queue = {}

	self.killSkillNamecallback:cancel()

	self.sceneRoot:removeAllChildrenWithCleanup(true)
	self.uiRoot:removeAllChildrenWithCleanup(true)

end

function TextEffect:onPause()
	if self.sceneRoot then
		_flowTextTimer:stop()
		_flow_text_queue = {}

		_flowAttrTimer:stop()
		_flow_attr_queue = {}

		self.killSkillNamecallback:cancel()

		self.sceneRoot:removeAllChildrenWithCleanup(true)
		self.uiRoot:removeAllChildrenWithCleanup(true)
	end
end

function TextEffect:onResume()
end

function _flow_attr(entity_handle,prefix,colortype,numbermessage)
	
	local entity = EntityManager:get_entity( entity_handle );
	if not ( entity ) then
		return
	end

	local root = entity.model:getBillboardNode()
	local p = CCSpriteBatchNode:batchNodeWithFile(Flow_Text_Prefix_Config['exp'])
	local len = string.len(numbermessage) 
	local x = 0
	local ntable = Flow_Text_Config[prefix]
	if ntable == nil then
		ntable = Flow_Text_Config[colortype]
	end
	local cb = callback:new()

	if prefix then
		local pn = Flow_Text_Prefix_Config[prefix]
	--@debug_begin
			assert(pn)
	--@debug_end
		local b = CCSprite:spriteWithFile(pn)
		b:setPositionX(x)
		p:addChild(b)
		x = x + (b:getContentSize().width / 2)
	end

	for i=1, len do 
		local bytecode = numbermessage:byte(i)
		local name = ntable[bytecode]
		if bytecode == 32 then
			x = x + textGap
		else
--@debug_begin
			assert(name)
--@debug_end
			if name then
				local b = CCSprite:spriteWithFile(name)
				if bytecode == code_m or bytecode == code_p then
					x = x + signGap
				end
				b:setPositionX(x)
				p:addChild(b)
				x = x + textGap
			end
		end
	end

	p:setAnchorPoint(CCPointMake(0.5,0.5))
	p:setContentSize(CCSizeMake(len*textGap,textHeight))
	p:setPosition(0,16)

	--[[
	local delay = CCDelayTime:actionWithDuration(0.75)
	local sceleOut = CCScaleTo:actionWithDuration(0.25,0,0);
	local removeact = CCRemove:action();
	local array = CCArray:array();

	array:addObject(delay);
	array:addObject(sceleOut);
	array:addObject(removeact);


	local seq = CCSequence:actionsWithArray(array);
	local move = CCMoveBy:actionWithDuration(5,CCPointMake(0,280))
	local move_ease = CCEaseOut:actionWithAction(move,2.0);
	local spawn = CCSpawn:actionOneTwo(seq,move_ease)
	p:stopAllActions()
	]]--
	local spawn = _createFlowAttr(0.75,0.25,5,CCPointMake(0,280),2.0)
	p:runAction(spawn);
	root:addChild(p,flow_text_z)
end

function _flow_critical(px, py, prefix, colortype, numbermessage)

	local p = CCSpriteBatchNode:batchNodeWithFile(Flow_Text_Prefix_Config['exp'])
	local len = string.len(numbermessage) 
	local x = 0
	local ntable = Flow_Text_Config[colortype]
	local cb = callback:new()

	if prefix then
		local pn = Flow_Text_Prefix_Config[prefix]
	--@debug_begin
			assert(pn)
	--@debug_end
		local b = CCSprite:spriteWithFile(pn)
		b:setPositionX(x)
		p:addChild(b)
		x = x + b:getContentSize().width / 2
	end

	for i=1, len do 
		local bytecode = numbermessage:byte(i)
		local name = ntable[bytecode]
		if bytecode == 32 then
			x = x + textGap
		else
--@debug_begin
			assert(name)
--@debug_end
			if name then
				local b = CCSprite:spriteWithFile(name)
				b:setPositionX(x)
				p:addChild(b)
				x = x + textGap
			end
		end
	end
	local z = flow_text_z
	p:setAnchorPoint(CCPointMake(0.5,0.5))
	p:setContentSize(CCSizeMake(len*textGap,textHeight))
	p:setPosition(px,py)
	-- p:setScale(0)
	--[[
	local scaleIn = CCScaleTo:actionWithDuration(0.1,2,2);
	local scaleIn2 = CCScaleTo:actionWithDuration(0.1,1.2,1.2);
	local delay = CCDelayTime:actionWithDuration(0.5)
	local sceleOut = CCScaleTo:actionWithDuration(0.25,0,0);
	local removeact = CCRemove:action();
	local array = CCArray:array();

	array:addObject(scaleIn)
	array:addObject(scaleIn2)
	array:addObject(delay);
	array:addObject(sceleOut);
	array:addObject(removeact);

	local seq = CCSequence:actionsWithArray(array);

	local move = CCMoveBy:actionWithDuration(15,CCPointMake(0,300))
	local move_ease = CCEaseOut:actionWithAction(move,2.0);
	local spawn = CCSpawn:actionOneTwo(seq,move_ease)
	]]--

	p:setScale(1.5)

	local delay3 = CCDelayTime:actionWithDuration(0.2)
	local move1 = CCMoveBy:actionWithDuration(0.15,CCPointMake(0,90))
	local move_ease1 = CCEaseOut:actionWithAction(move1,2);
	local delay1 = CCDelayTime:actionWithDuration(0.3)
	local move2 = CCMoveBy:actionWithDuration(0.25,CCPointMake(0,90))
	local array1 = CCArray:array();
	array1:addObject(delay3);
	array1:addObject(move_ease1);
	array1:addObject(delay1)
	array1:addObject(move2);
	local seq1 = CCSequence:actionsWithArray(array1);

	local sceleOut1 = CCScaleTo:actionWithDuration(0.2,1,1);
	local delay2 = CCDelayTime:actionWithDuration(0.45)
	local sceleOut = CCScaleTo:actionWithDuration(0.25,0,0);
	local removeact = CCRemove:action();
	local array2 = CCArray:array();

	array2:addObject(sceleOut1);
	array2:addObject(delay2);
	array2:addObject(sceleOut);
	array2:addObject(removeact);
	local seq = CCSequence:actionsWithArray(array2);

	local spawn = CCSpawn:actionOneTwo(seq,seq1)

	-- local spawn = _createFlowCritical(0.1,2,
	-- 	                              0.1,1.2,
	-- 	                              0.5,
	-- 	                              0.25,0,
	-- 	                              15,CCPointMake(0,300),
	-- 	                              2.0)
	p:stopAllActions()
	p:runAction(spawn);

	z = 65535
	TextEffect.sceneRoot:addChild(p,z)
end

function _flow_text(px, py, prefix, colortype, numbermessage)
	local p = CCSpriteBatchNode:batchNodeWithFile(Flow_Text_Prefix_Config['exp'])
	local len = string.len(numbermessage) 
	local x = 0
	local ntable = Flow_Text_Config[colortype]
	local cb = callback:new()

	if prefix then
		local pn = Flow_Text_Prefix_Config[prefix]
	--@debug_begin
			assert(pn)
	--@debug_end
		--print("pn",pn)
		local b = CCSprite:spriteWithFile(pn)
		b:setPositionX(x)
		p:addChild(b,10)
		x = x + b:getContentSize().width / 2 
	end

	for i=1, len do 
		local bytecode = numbermessage:byte(i)
		local name = ntable[bytecode]
		if bytecode == 32 then
			x = x + textGap
		else
--@debug_begin
			assert(name)
--@debug_end
			if name then
				--print("name",name)
				local b = CCSprite:spriteWithFile(name)
				b:setPositionX(x)
				p:addChild(b)
				x = x + textGap
			end
		end
	end
	local z = flow_text_z

	p:setAnchorPoint(CCPointMake(0.5,0.5))
	p:setContentSize(CCSizeMake(len*textGap,textHeight))
	p:setPosition(px,py)
	--print("px,py",px,py)
	--[[
	local delay = CCDelayTime:actionWithDuration(0.5)
	local sceleOut = CCScaleTo:actionWithDuration(0.25,0,0);
	local removeact = CCRemove:action();
	local array = CCArray:array();

	array:addObject(delay);
	array:addObject(sceleOut);
	array:addObject(removeact);

	local seq = CCSequence:actionsWithArray(array);

	local move = CCMoveBy:actionWithDuration(15,CCPointMake(0,200))
	local move_ease = CCEaseOut:actionWithAction(move,2.0);
	local spawn = CCSpawn:actionOneTwo(seq,move_ease)
	]]--

	local move1 = CCMoveBy:actionWithDuration(0.15,CCPointMake(0,70))
	local move_ease1 = CCEaseOut:actionWithAction(move1,2);
	local delay1 = CCDelayTime:actionWithDuration(0.3)
	local move2 = CCMoveBy:actionWithDuration(0.25,CCPointMake(0,70))
	local array1 = CCArray:array();
	array1:addObject(move_ease1);
	array1:addObject(delay1)
	array1:addObject(move2);
	local seq1 = CCSequence:actionsWithArray(array1);

	local delay2 = CCDelayTime:actionWithDuration(0.45)
	local sceleOut = CCScaleTo:actionWithDuration(0.25,0,0);
	local removeact = CCRemove:action();
	local array2 = CCArray:array();

	array2:addObject(delay2);
	array2:addObject(sceleOut);
	array2:addObject(removeact);
	local seq = CCSequence:actionsWithArray(array2);

	local spawn = CCSpawn:actionOneTwo(seq,seq1)

	-- local spawn = _createFlowAttr(0.5,0.25,15,CCPointMake(0,200),2.0)
	p:stopAllActions()
	p:runAction(spawn);
	TextEffect.sceneRoot:addChild(p,z)
end


--必杀技能释放文字显示
--不允许重复
function TextEffect:SkillName(imagelist, item_size, y)
	if self.killSkillNamecallback:isIdle() then
		local d = 0.0
		local node = CCSpriteBatchNode:batchNodeWithFile(imagelist[1])
		local count = #imagelist
		local half = item_size * 0.5
		local x = item_size * 2 + (GameScreenConfig.standard_width - (item_size * count)) * 0.5

		for i=1,count do
			__SkillNameChar(x, y,  d, 1.0 - (i - 1) / ( count - 1) , node, imagelist[i])
			x = x + half
			d = d + 0.1
		end
		self.uiRoot:addChild(node)
		self.killSkillNamecallback:start(3,function() 
									node:removeFromParentAndCleanup(true) 
								end)
	else
		error('SkillName Running')
	end
end

function __SkillNameChar(x, y, delaytime ,anchoroffset, root, file)
    local s = CCSprite:spriteWithFile(file);
    s:setPosition(x,y)
    s:setOpacity(0)
    s:setScaleX(6)
    s:setScaleY(6)
    local r = root
    --[[
	local fade_in = CCFadeIn:actionWithDuration(0.1);
    local scaleIn = CCScaleTo:actionWithDuration(0.075,1,1);
	local scaleIn2 = CCScaleTo:actionWithDuration(0.1,0.6,0.6);
	local scaleIn3 = CCScaleTo:actionWithDuration(0.075,1.0,1.0);
	local delay = CCDelayTime:actionWithDuration(delaytime)
	local delay2 = CCDelayTime:actionWithDuration(anchoroffset)

	local showdelay = CCDelayTime:actionWithDuration(0.75)
	
	local array = CCArray:array();

	array:addObject(delay)
	array:addObject(fade_in)
	array:addObject(scaleIn)
	array:addObject(scaleIn2)
	array:addObject(scaleIn3)
	array:addObject(showdelay)
	array:addObject(delay2)

	local scaleOut = CCScaleTo:actionWithDuration(0.075,2,2);
	local fade_out = CCFadeOut:actionWithDuration(0.2);
	local spawn = CCSpawn:actionOneTwo(fade_out,scaleOut)
	array:addObject(spawn)

	
	local seq = CCSequence:actionsWithArray(array);
	]]--
	_createSkillName(delaytime,anchoroffset,0.75)
	s:setAnchorPoint(CCPointMake(anchoroffset,0.5))
	s:stopAllActions()
	s:runAction(seq);
    r:addChild(s,0)
end

local function doFlowTick( dt )
	-- body
	if #_flow_text_queue == 0 then
		_flowTextTimer:stop()
	else
		local _job = table.remove(_flow_text_queue, 1)
		_job()
	end
end

local function doAttrFlowTick( dt )
	-- body
	if #_flow_attr_queue == 0 then
		_flowAttrTimer:stop()
	else
		local _job = table.remove(_flow_attr_queue, 1)
		_job()
	end
end

function TextEffect:FlowText(actor, yOffset, prefix,colortype, numbermessage, isHeal)
	if AppGameMessages.isEnterBackGround then
		return
	end

	if _flowTextTimer:isIdle() then
		_flowTextTimer:start(0,doFlowTick)
	end
	if prefix == 'exp' then
		--print("prefix",prefix,colortype,numbermessage)
		local aX,aY = actor:getPosition()
		local px = math.random(-38,38) + aX
		local py = math.random(0,38) + aY + yOffset
		_flow_text_queue[#_flow_text_queue+1] = function() _flow_text(px, py, prefix, colortype, numbermessage) end
	elseif prefix == 'critical' then
		local aX,aY = actor:getPosition()
		local px = math.random(-38,38) + aX
		local py = math.random(0,38) + aY + yOffset
		_flow_text_queue[#_flow_text_queue+1] = function() _flow_critical(px, py, prefix, colortype, numbermessage) end
	else
		if isHeal then
			local px,py = actor:getPosition()
			py = py + yOffset
			--print("isHeal px,py",px,py)
			_flow_text_queue[#_flow_text_queue+1] = function() _flow_text(px, py, prefix, colortype, numbermessage) end
		else
			local aX,aY = actor:getPosition()
			local px = math.random(-38,38) + aX
			local py = math.random(0,38) + aY + yOffset
			--print("not isHeal px,py",px,py)
			_flow_text_queue[#_flow_text_queue+1] = function() _flow_text(px, py, prefix, colortype, numbermessage) end
		end
	end
	
end


function TextEffect:FlowAttr(entity_handle, prefix,colortype, numbermessage)
	
	if not AppGameMessages.isForeGround then
		return
	end

	--print('TextEffect:FlowAttr:',numbermessage)

	if _flowAttrTimer:isIdle() then
		_flowAttrTimer:start(0.2,doAttrFlowTick)
	end
	_flow_attr_queue[#_flow_attr_queue+1] = function() _flow_attr(entity_handle, prefix, colortype, numbermessage) end
end


RollingText = simple_class()

--"ui/fonteffect/exp.png"
function RollingText:__init(x,y,w,h,interval)
	self.effect_timer = timer();
	self.effect_callback = callback:new();

	self.view = CCBasePanel:panelWithFile(x,y,w,h,'',-1,-1);
	self.view:setAnchorPoint(0.0,0.0)
	
	self.textPanel = CCTouchPanel:touchPanel(0, 0, w, h);
	self.view:addChild(self.textPanel)

	self.interval = interval
end

function RollingText:setLabel( path, x, y )
	self.label = MUtils:create_sprite(self.view,path,x,y);
end

function RollingText:setPrefix( path, x,y )
	self.prefix = path
end

function RollingText:setValue(new_value)
	if not new_value then
		return
	end
	self.effect_timer:stop()
	self.effect_callback:cancel()

	local num_len = string.len(new_value)
	local size = { num_len*51,50 }
	local frame_time = 0.05;
	--self.view:setSize(size[1],size[2])
	--self.textPanel:setSize(size[1],size[2])
	self.textPanel:removeAllChildrenWithCleanup(true)

	local cur_panel = self.textPanel

	local ani_info_table = {}; 
	for i=1,num_len do
		local _value = new_value;
		if ( i~=1 ) then
			_value = _value % math.pow(10,num_len+1-i);
		end
		local pow_num = math.pow(10,num_len-i);
		local num = math.floor( _value/pow_num);
		-- print(fight_value,num,pow_num);
		local interval = self.interval or 25
		local x = (i-1)* interval;
		ani_info_table[i] = {};
		ani_info_table[i].spr = MUtils:create_sprite(cur_panel, self.prefix ..num..".png",x,0);
		ani_info_table[i].spr:setAnchorPoint(CCPoint(0,0));
	end
end

function RollingText:start(old_value,new_value)
	if not old_value or not new_value then
		return
	end
	self.effect_timer:stop()
	self.effect_callback:cancel()

	local num_len = string.len(new_value)
	local size = { num_len*51,50 }
	--self.view:setSize(size[1],size[2])
	--self.textPanel:setSize(size[1],size[2])
	self.textPanel:removeAllChildrenWithCleanup(true)

	local cur_panel = self.textPanel
	local frame_time = 0.05;
	-- 保存所有动画精灵
	local ani_info_table = {}; 
	for i=1,num_len do
		local _value = new_value;
		if ( i~=1 ) then
			_value = _value % math.pow(10,num_len+1-i);
		end
		local pow_num = math.pow(10,num_len-i);
		local num = math.floor( _value/pow_num);
		-- print(fight_value,num,pow_num);
		local interval = self.interval or 25
		local x = (i-1)*interval;
		ani_info_table[i] = {};
		ani_info_table[i].spr = MUtils:create_sprite(cur_panel, self.prefix ..num..".png",x,51*num);
		ani_info_table[i].spr:setAnchorPoint(CCPoint(0,0));
		ani_info_table[i].spr:setIsVisible(false);
		ani_info_table[i].time = frame_time*num;
		ani_info_table[i].num = num;
		if ( ani_info_table[i-1] ) then 
			ani_info_table[i].time = ani_info_table[i].time + ani_info_table[i-1].time;
		end
		for j=0,num-1 do
			local spr = MUtils:create_sprite(ani_info_table[i].spr,self.prefix..j..".png",0,-51*(num-j));
			spr:setAnchorPoint(CCPoint(0,0));
		end
	end

	local curr_time = 0;
	local index = 1;
	local next_ani_time = 0;
	local function ani_cb_fun()
		if ( curr_time >= next_ani_time ) then
			if ( index > #ani_info_table ) then
				self.effect_timer:stop();
				self:finalAction()
				return
			end
			local move_by_time = ani_info_table[index].num*frame_time;
			local moveto_action = CCMoveBy:actionWithDuration( move_by_time ,CCPoint(0,-51*ani_info_table[index].num) );
			local spr = ani_info_table[index].spr
			spr:setOpacity(255)
			spr:setIsVisible(true);
			spr:runAction(moveto_action);
			next_ani_time = ani_info_table[index].time;
			index = index + 1;
		end
		curr_time = curr_time + 0.05;
	end
	self.effect_timer:start(0.05,ani_cb_fun);
end

function RollingText:finalAction()
    local t0 = CCScaleTo:actionWithDuration( 0.2, 1.5 )
    local t1 = CCScaleTo:actionWithDuration( 0.1, 0.8 )
    local t2 = CCScaleTo:actionWithDuration( 0.1, 1.1 )
    local t4 = CCScaleTo:actionWithDuration( 0.1, 1.0 ) 
    local array = CCArray:array();
    array:addObject(t0)
    array:addObject(t1)
    array:addObject(t2)
    array:addObject(t4)
    local seq = CCSequence:actionsWithArray(array);
    self.view:runAction(seq)
end

function RollingText:destroy()
	self.effect_timer:stop()
	self.effect_callback:cancel()
end