--- SpecialSceneEffect.lua
-- created by jiajia
-- 3个职业的必杀技

SpecialSceneEffect = {}
-- InkSceneEffect = {}

local _DEFAULT_KILL_TIME = 0.2 + 1.5 + 0.2 + 0.5 ;

local SkillNameConfig =
{
	[33] = 	{ 
				'ui/skilltext/ao.png',
				'ui/skilltext/yi.png',
				'ui/skilltext/dian.png',
				'ui/skilltext/huang.png',
				'ui/skilltext/yan.png',
				'ui/skilltext/sha1.png',
			},
	[34] = { 
				'ui/skilltext/ao.png',
				'ui/skilltext/yi.png',
				'ui/skilltext/dian.png',
				'ui/skilltext/tian.png',
				'ui/skilltext/zhu.png',
				'ui/skilltext/shi.png',
			},
	[35] = { 
				'ui/skilltext/ao.png',
				'ui/skilltext/yi.png',
				'ui/skilltext/dian.png',
				'ui/skilltext/zi.png',
				'ui/skilltext/lei.png',
				'ui/skilltext/sha4.png',
			},
	[36] = { 
				'ui/skilltext/ao.png',
				'ui/skilltext/yi.png',
				'ui/skilltext/dian.png',
				'ui/skilltext/han.png',
				'ui/skilltext/jing.png',
				'ui/skilltext/jie.png',
			},
}

local BiShaConfig = 
{
	src = 'frame/effect/skill/bisha/99999',
	tag = 7546,
	count = 1,
	type_ =  4,
	speed = 0.78/6.0,
	t = 0.0,
	z =500,
	x = 4,
	y = 0,
}

-- function InkSceneEffect:init()

-- 	if not self.source then
-- 		self.source = "nopack/RageBackGround.png"
-- 		self.uvsource = "nopack/RageUVAnimation.png"
-- 		self.component = nil

-- 		self.backtexture = CCTextureCache:sharedTextureCache():addImage(self.source);
-- 		safe_retain(self.backtexture)

-- 		self.uvtexture = CCTextureCache:sharedTextureCache():addImage(self.uvsource);
-- 		safe_retain(self.uvtexture)

-- 		self.textTexture = CCSprite:spriteWithFile('ui/skilltext/ao.png')
-- 		safe_retain(self.textTexture)

--     	local fade_out = CCFadeOut:actionWithDuration(0.25);
--         local fade_in = CCFadeIn:actionWithDuration(0.25);
--         local delay = CCDelayTime:actionWithDuration(1.0)
-- 		local remove_act = CCRemove:action()

-- 		local array = CCArray:array();
-- 		array:addObject(fade_in);
-- 		array:addObject(delay)
-- 		array:addObject(fade_out);
-- 		array:addObject(remove_act);

-- 		local seq = CCSequence:actionsWithArray(array);
-- 		self.seqBackGround = seq
-- 		safe_retain(self.seqBackGround)

--     	local fade_out = CCFadeOut:actionWithDuration(0.25);
--     	local fade_in = CCFadeIn:actionWithDuration(0.25);
-- 		local delay = CCDelayTime:actionWithDuration(1.0)
-- 		local uvAnimation = CCUVAnimation:actionWithDuration(5,15.0,0);
-- 		local remove_act = CCRemove:action()

-- 		local array = CCArray:array();
-- 		array:addObject(fade_in);
-- 		array:addObject(delay)
-- 		array:addObject(fade_out);
-- 		array:addObject(remove_act);

-- 		local seq = CCSequence:actionsWithArray(array);
-- 		local spawn = CCSpawn:actionOneTwo(seq,uvAnimation)

-- 		self.seqUVAnimation = spawn
-- 		safe_retain(self.seqUVAnimation)

-- 		-- self.killtime = 0.2 + 1.5 + 0.2 + 0.5 ;
-- 		self.callback_start = callback:new()
-- 		self.killcallback   = callback:new()
-- 		self.callback_end   = callback:new()
-- 	end
-- end


-- function InkSceneEffect:perform()
-- 	if self.component == nil then
-- 		self.callback_start:cancel()
-- 		self.callback_end:cancel()

-- 		local s = CCSprite:spriteWithFile(self.source);
-- 		local s2 = CCSprite:spriteWithFile(self.uvsource);
-- 		s:setAnchorPoint(CCPointMake(0,0))
-- 		s2:setAnchorPoint(CCPointMake(0,0))
-- 		s:addChild(s2)
-- 	    local r = SceneManager.SpecialSceneEffect
--         s:setOpacity(0)
-- 	    s2:setOpacity(0)
-- 	    local sx =  
-- 	    s:reSize(GameScreenConfig.viewPort_width,GameScreenConfig.viewPort_height)
-- 	    s2:reSize(GameScreenConfig.viewPort_width,GameScreenConfig.viewPort_height)
	    
-- 	    r:addChild(s,1000)
-- 		self.component = s

-- 		self.callback_start:start(0.0, function() 		
-- 											SceneEffectManager : onPause()
-- 										end)

-- 		self.callback_end:start(self.killtime - 0.5, function() 
-- 												   self.component = nil
-- 							                       SceneEffectManager : onResume()
-- 							                    end )
-- 		s:stopAllActions()
-- 		s2:stopAllActions()
-- 		s:runAction(self.seqBackGround)
-- 		s2:runAction(self.seqUVAnimation)
-- 	else
-- 		error('effect not finish')
-- 	end
-- end


-- function InkSceneEffect:destory()
-- 	if self.seqBackGround then
-- 		safe_release(self.seqBackGround)
-- 		self.seqBackGround = nil
-- 		safe_release(self.seqUVAnimation)
-- 		self.seqUVAnimation = nil

-- 		safe_release(self.backtexture)
-- 		self.backtexture = nil
-- 		safe_release(self.uvtexture)
-- 		self.uvtexture = nil
-- 		safe_release(self.textTexture)
-- 		self.textTexture = nil
-- 	end
-- end


--缁ф壙
function SpecialSceneEffect:init( )
	-- InkSceneEffect.init(self)
end


function SpecialSceneEffect:perform(skill)
	-- local n = SkillNameConfig[skill]
	-- if n then
	-- 	self.killtime = _DEFAULT_KILL_TIME;
	-- 	local c = callback:new()
	-- 	c:start(0.25, function()
	-- 				self:_perform( n,60,360)
	-- 			end)
	-- 	return true
	-- end
	-- return false
	if skill == 33 then
        self:perform_daoke()
		-- self:perform_tishu()
        -- 显示文字
        local win = UIManager:find_visible_window("right_top_panel")
        if win then
            win:show_bsj_animation()
        end
    elseif skill == 34 then
        self:perform_qiangshi()
        -- 显示文字
        local win = UIManager:find_visible_window("right_top_panel")
        if win then
            win:show_bsj_animation()
        end
	elseif skill == 35 then
        self:perform_gongshou()
		-- self:perform_renshu()
        -- 显示文字
        local win = UIManager:find_visible_window("right_top_panel")
        if win then
            win:show_bsj_animation()
        end
	elseif skill == 36 then
        -- 职业贤儒
        -- self:perform_huanshu()
		self:perform_xianru()
        -- 显示文字
        local win = UIManager:find_visible_window("right_top_panel")
        if win then
            win:show_bsj_animation()
        end
	end
end

function SpecialSceneEffect:perform_renshu()
	local root = ZXLogicScene:sharedScene()

    local zOrder = -1
    uiRoot = CCNode:node()
    root:getUINode():addChild(uiRoot,zOrder)
    local sx = GameScreenConfig.ui_screen_width / GameScreenConfig.ui_design_width
    local sy = GameScreenConfig.ui_screen_height / GameScreenConfig.ui_design_height
    uiRoot:setScaleX(sx)
    uiRoot:setScaleY(sy)
    

    --创建精灵
    local thunderSp0 = CCSprite:spriteWithFile('nopack/bisha/renshu/uvsource.png')
    --创建动画
    local fade_out = CCFadeOut:actionWithDuration(0.1);
    local fade_in  = CCFadeIn:actionWithDuration(0.3);
    local remove_act = CCRemove:action()
    --生成队列
    local array = CCArray:array();
    array:addObject(fade_in);
    array:addObject(fade_out);
    array:addObject(remove_act);
    local seq = CCSequence:actionsWithArray(array);
    --初始化，alpha = 0
    thunderSp0:setOpacity(0)
    thunderSp0:runAction(seq)
    thunderSp0:setAnchorPoint(CCPointMake(0,0))
    uiRoot:addChild(thunderSp0,zOrder)

    local textSp0 = CCSprite:spriteWithFile('nopack/bisha/renshu/word.png')
    --创建动画
    local delay1 = CCDelayTime:actionWithDuration(0.2)
    local fade_out1 = CCFadeOut:actionWithDuration(0.5)
    local fade_in1  = CCFadeIn:actionWithDuration(0.5)
    local delay2 = CCDelayTime:actionWithDuration(0.5)
    local remove_act = CCRemove:action()
    --生成队列
    local array = CCArray:array();
    array:addObject(delay1);
    array:addObject(fade_in1);
    array:addObject(fade_out1);
    array:addObject(delay2)
    array:addObject(remove_act);
    local seq = CCSequence:actionsWithArray(array);
    --初始化，alpha = 0
    textSp0:setOpacity(0)
    textSp0:runAction(seq)
    textSp0:setAnchorPoint(CCPointMake(0,0))
    uiRoot:addChild(textSp0,zOrder)

    --创建精灵
    local thunderSp1 = CCSprite:spriteWithFile('nopack/bisha/renshu/uvsource.png')
    --创建动画
    local delay = CCDelayTime:actionWithDuration(0.5)
    local fade_out = CCFadeOut:actionWithDuration(0.5);
    local fade_in  = CCFadeIn:actionWithDuration(0.5);
    local remove_act = CCRemove:action()
    --生成队列
    local array = CCArray:array();
    array:addObject(delay);
    array:addObject(fade_in);
    array:addObject(fade_out);
    array:addObject(remove_act);
    local seq = CCSequence:actionsWithArray(array);
    --初始化，alpha = 0
    thunderSp1:setOpacity(0)
    thunderSp1:setFlipX(true)
    thunderSp1:runAction(seq)
    thunderSp1:setAnchorPoint(CCPointMake(0,0))
    uiRoot:addChild(thunderSp1,zOrder)
end

function SpecialSceneEffect:perform_tishu()
	local root = ZXLogicScene:sharedScene()
    local uiRoot = root:getUINode()
    local zOrder = -1

    local player = EntityManager:get_player_avatar()
    if player then
        local effect_animation_table = effect_config[8007];
        EffectBuilder:playEntityEffect( 5,
                                        effect_animation_table,
                                        1000,
                                        player,
                                        player,
                                        8007)
        local effect_animation_table = effect_config[8008];
        local _dir = player.dir
        player.dir = 1
        EffectBuilder:playEntityEffect( 5,
                                        effect_animation_table,
                                        1000,
                                        player,
                                        player,
                                        8008)
        player.dir = _dir
    end
end

function SpecialSceneEffect:perform_huanshu()
	local root = ZXLogicScene:sharedScene()
    local zOrder = -1
    uiRoot = CCNode:node()
    root:getUINode():addChild(uiRoot,zOrder)
    local sx = GameScreenConfig.ui_screen_width / GameScreenConfig.ui_design_width
    local sy = GameScreenConfig.ui_screen_height / GameScreenConfig.ui_design_height
    uiRoot:setScaleX(sx)
    uiRoot:setScaleY(sy)

    -- 创建移动的文字
    local word  = CCSprite:spriteWithFile('nopack/bisha/huanshu/word.png')
    local array = CCArray:array()
    local moveTo= CCMoveTo:actionWithDuration(0.5,CCPoint(500,200));
    local moveBy= CCMoveBy:actionWithDuration(0.1,CCPoint(-60,0))
    local fadeOut = CCFadeOut:actionWithDuration(0.5)
    local remove= CCRemove:action()
    array:addObject(moveTo)
    array:addObject(moveBy)
    array:addObject(fadeOut)
    array:addObject(remove)
    local seq = CCSequence:actionsWithArray(array)
    word:runAction(seq)
    word:setAnchorPoint(CCPointMake(0.5,0))
    word:setPosition(CCPointMake(-500,200))
    uiRoot:addChild(word,zOrder)

    -- 创建黑条
    local black = CCSprite:spriteWithFile('nopack/bisha/huanshu/back.png')
    local array = CCArray:array();
    local fadeIn= CCFadeIn:actionWithDuration(0.1);
    array:addObject(fadeIn)
    array:addObject(CCDelayTime:actionWithDuration(2.0))
    array:addObject(CCHide:action())
    array:addObject(CCRemove:action())
    local seq = CCSequence:actionsWithArray(array);
    black:setOpacity(0)
    black:runAction(seq)
    black:setAnchorPoint(CCPointMake(0,0))
    black:setPosition(CCPointMake(0,368))
    uiRoot:addChild(black,zOrder)

    -- 创建眼角
    local eye1 = CCSprite:spriteWithFile('nopack/bisha/huanshu/eye1.png')
    eye1:setAnchorPoint(CCPointMake(0,0))
    eye1:setPosition(CCPointMake(540,439))
    uiRoot:addChild(eye1,zOrder)

    local array= CCArray:array()
    array:addObject(CCDelayTime:actionWithDuration(0.5))
    array:addObject(CCHide:action())
    array:addObject(CCRemove:action())
    local seq = CCSequence:actionsWithArray(array);
    eye1:runAction(seq)

    local eye11= CCSprite:spriteWithFile('nopack/bisha/huanshu/eye1.png')
    eye11:setFlipX(true)
    eye11:setAnchorPoint(CCPointMake(0,0))
    eye11:setPosition(CCPointMake(253,439))
    uiRoot:addChild(eye11,zOrder)

    local array= CCArray:array()
    array:addObject(CCDelayTime:actionWithDuration(0.5))
    array:addObject(CCHide:action())
    array:addObject(CCRemove:action())
    local seq = CCSequence:actionsWithArray(array);
    eye11:runAction(seq)

    local function create_eye()
        -- 创建左眼白
        local eye2 = CCSprite:spriteWithFile('nopack/bisha/huanshu/eye2.png')
        eye2:setFlipX(true)
        eye2:setAnchorPoint(CCPointMake(0,0))
        eye2:setPosition(CCPointMake(253,459))
        uiRoot:addChild(eye2,zOrder)

        local array= CCArray:array()
        array:addObject(CCDelayTime:actionWithDuration(1.2))
        array:addObject(CCShow:action())
        array:addObject(CCDelayTime:actionWithDuration(0.3))
        array:addObject(CCHide:action())
        local seq = CCSequence:actionsWithArray(array);
        eye2:runAction(seq)

        -- 创建右眼白
        local eye22 = CCSprite:spriteWithFile('nopack/bisha/huanshu/eye2.png')
        eye22:setAnchorPoint(CCPointMake(0,0))
        eye22:setPosition(CCPointMake(540,459))
        uiRoot:addChild(eye22,zOrder)

        local array = CCArray:array()
        array:addObject(CCDelayTime:actionWithDuration(1.2))
        array:addObject(CCShow:action())
        array:addObject(CCDelayTime:actionWithDuration(0.3))
        array:addObject(CCHide:action())
        local seq = CCSequence:actionsWithArray(array);
        eye22:runAction(seq)

        -- 创建左眼珠
        local eye3 = CCSprite:spriteWithFile('nopack/bisha/huanshu/eye3.png')
        eye3:setFlipX(true)
        eye3:setScale(0.8)
        eye3:setAnchorPoint(CCPointMake(0.5,0.5))
        eye3:setPosition(CCPointMake(343,515))
        uiRoot:addChild(eye3,zOrder)
        -- 添加旋转帧
        local delay  = CCDelayTime:actionWithDuration(1.2)
        local show   = CCShow:action()
        local rotate = CCRotateBy:actionWithDuration(0.3,-120)
        local scale  = CCScaleTo:actionWithDuration(0.1,1,1)
        local remove = CCRemove:action()
        local array  = CCArray:array()
        array:addObject(delay)
        array:addObject(show)
        array:addObject(rotate)
        array:addObject(scale)
        array:addObject(remove)
        local seq = CCSequence:actionsWithArray(array)
        eye3:runAction(seq)

        -- 创建右眼珠
        local eye33 = CCSprite:spriteWithFile('nopack/bisha/huanshu/eye3.png')
        eye33:setScale(0.8)
        eye33:setAnchorPoint(CCPointMake(0.5,0.5))
        eye33:setPosition(CCPointMake(620,515))
        uiRoot:addChild(eye33,zOrder)
        -- 添加旋转帧
        local delay  = CCDelayTime:actionWithDuration(1.2)
        local show   = CCShow:action()
        local rotate = CCRotateBy:actionWithDuration(0.3,-120)
        local scale  = CCScaleTo:actionWithDuration(0.1,1,1)
        local remove = CCRemove:action()
        local array  = CCArray:array()
        array:addObject(delay)
        array:addObject(show)
        array:addObject(rotate)
        array:addObject(scale)
        array:addObject(remove)
        local seq = CCSequence:actionsWithArray(array)
        eye33:runAction(seq)

        -- 创建眼血
        local function play_eye_brood()
            local playTime = 0.20
            local sp = effectCreator.createEffect_fo('frame/effect/bishaji/huanshu/brood', playTime, 1, 0.1)
            sp:setAnchorPoint(CCPointMake(0,0))
            sp:setPosition(CCPointMake(-40,-58))
            uiRoot:addChild(sp,zOrder)
        end
        local call_back = callback:new()
        call_back:start(0.4, play_eye_brood)
    end

    local call_back = callback:new()
    call_back:start(0.5, create_eye)
end

-- 
function SpecialSceneEffect:perform2( killtime )
	self.killtime = killtime;
	self:_perform( nil,60,360,1000)
end

function SpecialSceneEffect:test()
	-- InkSceneEffect.perform(self)
end

function SpecialSceneEffect:_perform(namelist, item_size,y, player,index_num)
	if namelist then
		TextEffect:SkillName(namelist, item_size, y)
	end
	-- InkSceneEffect.perform(self)

	local _max_index = 30;
	if index_num then
		_max_index = index_num
	end

    local x = math.random(-4,4);
    local y = 0;
    local z = 0;
    local timer = timer();
    local index = 0;
    local r = SceneManager.logicScene
    local player = EntityManager:get_player_avatar();
    
	player.model:playEffect( BiShaConfig.src,
						 BiShaConfig.tag, 
						 BiShaConfig.type_, 
						 BiShaConfig.count,
						 nil,
						 player.dir,
						 BiShaConfig.t,
						 BiShaConfig.z,
						 BiShaConfig.speed,
						 BiShaConfig.x,
						 BiShaConfig.y);

    --闇囧姩
    local function cb()
        z = math.random(1,4);
        if ( z== 1 ) then 
            x = math.random(-5,5);
            y = math.random(-5,5);
           r:moveCameraMap(player.x + x, player.y + y);
        end
        index = index + 1;
        if ( index == _max_index ) then 
            timer:stop();
        end
    end
    timer:start(0.01,cb);
end

--激活变身的特效
--addby mwy@2014-08-14
function SpecialSceneEffect:playTransformAnimate(entity)
    local root = ZXLogicScene:sharedScene()
    local uiRoot = root:getUINode()
    local zOrder = -1
    -- local entity = EntityManager:get_player_avatar()
    if entity then

        local effect_animation_table = effect_config[18];
        EffectBuilder:playEntityEffect( 5,
                                        effect_animation_table,
                                        1000,
                                        entity,
                                        entity,
                                        8007)
        local effect_animation_table = effect_config[19];
        local _dir = entity.dir
        entity.dir = 1
        EffectBuilder:playEntityEffect( 5,
                                        effect_animation_table,
                                        1000,
                                        entity,
                                        entity,
                                        8008)
        entity.dir = _dir

        SpecialSceneEffect:play_scale_action(entity)
    end
end

--变身放大效果
--@param1:实体
function SpecialSceneEffect:play_scale_action(entity)
    local scale1 = CCScaleTo:actionWithDuration(0.2, 1.5)
    local scale2 = CCScaleTo:actionWithDuration(0.6, 1.0)
    local action = CCSequence:actionOneTwo(scale1, scale2)
    entity.model:runAction(action)
end                    

-- 震动和背景穿梭动画，其实只是_perform动画的简单版。 note by guozhinan
function SpecialSceneEffect:_perform_shake()
    -- self.killtime = 0.2 + 1.5 + 0.2 + 0.5
    -- InkSceneEffect.perform(self) -- 背景穿梭动画

    local x = math.random(-4,4);
    local y = 0;
    local z = 0;
    local timer = timer();
    local index = 0;
    local r = SceneManager.logicScene
    local player = EntityManager:get_player_avatar();

    --震动
    local function cb()
        z = math.random(1,4);
        if ( z== 1 ) then 
            x = math.random(-5,5);
            y = math.random(-5,5);
           r:moveCameraMap(player.x + x, player.y + y);
        end
        index = index + 1;
        if ( index == 60 ) then 
            timer:stop();
        end
    end
    timer:start(0.01,cb);
end

-- 刀客动画
function SpecialSceneEffect:perform_daoke()

    -- 纯黑背景淡入淡出效果
    local fade_in = CCFadeIn:actionWithDuration(0.8)
    local delay = CCDelayTime:actionWithDuration(1.4)
    local fade_out = CCFadeOut:actionWithDuration(0.8);
    local remove_act = CCRemove:action()
    local array = CCArray:array();
    array:addObject(fade_in);
    array:addObject(delay);
    array:addObject(fade_out);
    array:addObject(remove_act);
    local seq = CCSequence:actionsWithArray(array);

    local s = CCSprite:spriteWithFile("nopack/RageBackGround.png");
    s:setAnchorPoint(CCPointMake(0,0))
    local r = SceneManager.SpecialSceneEffect  -- 其实是SceneUINode的别名，名字太有迷惑性了
    s:setOpacity(0)
    s:reSize(GameScreenConfig.viewPort_width,GameScreenConfig.viewPort_height)
    r:addChild(s,1000)
    s:runAction(seq)

    local function call_back( )
        self:_perform_shake()
    end
    local cb = callback:new();
    cb:start(1.6,call_back);

    -- 蓄气动画
    local player = EntityManager:get_player_avatar();
    if player and player.model then
        local effect_animation_table = effect_config[40002];
        player.model:playEffect( effect_animation_table[1],40002, 2, effect_animation_table[3],nil,player.dir,0,500,effect_animation_table[2],effect_animation_table[4],effect_animation_table[5]);
    end
end

-- 贤儒必杀技动画
function SpecialSceneEffect:perform_xianru()

    -- 纯黑背景淡入淡出效果
    local fade_in = CCFadeIn:actionWithDuration(0.8)
    local delay = CCDelayTime:actionWithDuration(1.4)
    local fade_out = CCFadeOut:actionWithDuration(0.8);
    local remove_act = CCRemove:action()
    local array = CCArray:array();
    array:addObject(fade_in);
    array:addObject(delay);
    array:addObject(fade_out);
    array:addObject(remove_act);
    local seq = CCSequence:actionsWithArray(array);

    local s = CCSprite:spriteWithFile("nopack/RageBackGround.png");
    s:setAnchorPoint(CCPointMake(0,0))
    local r = SceneManager.SpecialSceneEffect  -- 其实是SceneUINode的别名，名字太有迷惑性了
    s:setOpacity(0)
    s:reSize(GameScreenConfig.viewPort_width,GameScreenConfig.viewPort_height)
    r:addChild(s,1000)
    s:runAction(seq)

    -- local function call_back( )
        self:_perform_shake()
    -- end
    -- local cb = callback:new();
    -- cb:start(0,call_back);

    local player = EntityManager:get_player_avatar();
    if player and player.model then
        local effect_animation_table = effect_config[40002];
        player.model:playEffect( effect_animation_table[1],40002, 2, effect_animation_table[3],nil,player.dir,0,500,effect_animation_table[2],effect_animation_table[4],effect_animation_table[5]);
    end
end

-- 枪士必杀技动画
function SpecialSceneEffect:perform_qiangshi()

    -- 纯黑背景淡入淡出效果
    local fade_in = CCFadeIn:actionWithDuration(0.8)
    local delay = CCDelayTime:actionWithDuration(1.0)
    local fade_out = CCFadeOut:actionWithDuration(0.8);
    local remove_act = CCRemove:action()
    local array = CCArray:array();
    array:addObject(fade_in);
    array:addObject(delay);
    array:addObject(fade_out);
    array:addObject(remove_act);
    local seq = CCSequence:actionsWithArray(array);

    local s = CCSprite:spriteWithFile("nopack/RageBackGround.png");
    s:setAnchorPoint(CCPointMake(0,0))
    local r = SceneManager.SpecialSceneEffect  -- 其实是SceneUINode的别名，名字太有迷惑性了
    s:setOpacity(0)
    s:reSize(GameScreenConfig.viewPort_width,GameScreenConfig.viewPort_height)
    r:addChild(s,1000)
    s:runAction(seq)

    -- local function call_back( )
        self:_perform_shake()
    -- end
    -- local cb = callback:new();
    -- cb:start(0,call_back);

    local player = EntityManager:get_player_avatar();
    if player and player.model then
        local effect_animation_table = effect_config[40002];
        player.model:playEffect( effect_animation_table[1],40002, 2, effect_animation_table[3],nil,player.dir,0,500,effect_animation_table[2],effect_animation_table[4],effect_animation_table[5]);
    end
end

-- 弓手必杀技动画
function SpecialSceneEffect:perform_gongshou()

    -- 纯黑背景淡入淡出效果
    local fade_in = CCFadeIn:actionWithDuration(0.8)
    local delay = CCDelayTime:actionWithDuration(1.6)
    local fade_out = CCFadeOut:actionWithDuration(0.8);
    local remove_act = CCRemove:action()
    local array = CCArray:array();
    array:addObject(fade_in);
    array:addObject(delay);
    array:addObject(fade_out);
    array:addObject(remove_act);
    local seq = CCSequence:actionsWithArray(array);

    local s = CCSprite:spriteWithFile("nopack/RageBackGround.png");
    s:setAnchorPoint(CCPointMake(0,0))
    local r = SceneManager.SpecialSceneEffect  -- 其实是SceneUINode的别名，名字太有迷惑性了
    s:setOpacity(0)
    s:reSize(GameScreenConfig.viewPort_width,GameScreenConfig.viewPort_height)
    r:addChild(s,1000)
    s:runAction(seq)

    -- local function call_back( )
        self:_perform_shake()
    -- end
    -- local cb = callback:new();
    -- cb:start(0,call_back);

    local player = EntityManager:get_player_avatar();
    if player and player.model then
        local effect_animation_table = effect_config[40002];
        player.model:playEffect( effect_animation_table[1],40002, 2, effect_animation_table[3],nil,player.dir,0,500,effect_animation_table[2],effect_animation_table[4],effect_animation_table[5]);
    end
end

function SpecialSceneEffect:destory()
	-- InkSceneEffect.destory(self)
end

