-- SelectCard.lua
-- created by aXing on 2013-7-10
-- 选择职业的卡牌

super_class.SelectCard()

SelectCard.BODY_PHOTO_X = 18 + 10           -- 身体照片的x
SelectCard.BODY_PHOTO_Y = 17 + 10           -- 身体照片的y
SelectCard.BODY_PHOTO_Z = 10           -- 身体照片的层级
local DISCOVER_NEED_TIME = 1           -- 消失时间

local _word_interval_time = 0.5        -- 每个字显示的时间

function SelectCard:__init( path )
    self.being_focus = false       -- 是否正在焦点（根据play和stop被调用）
    self.can_show_action = true-- 在播放图片移动或者文字的时候，不能播放动作的标识

    self.body_name = nil           -- avatar body名称
    self.weapon_name = nil         -- avatar 武器名称
    self.wing_name = nil           -- 翅膀名称

    self.avatar = nil              -- 
    self.body_photo_path = nil     -- 身体照片路径
    self.body_photo = nil          -- 身体照片
    self.discover_timer = nil      -- 照片消失时的timer
    self.discover_forward = -1      -- 照片消失的方向 -1：左   1 右

    self.callback_temp = callback:new() -- 播放系列动作的callback

    self.word_timer = nil          -- 文字播放timer
    self.show_words = {LangGameString[1343],LangGameString[1344],LangGameString[1345],LangGameString[1346],LangGameString[1347],LangGameString[1348],LangGameString[1349],LangGameString[1350]} -- [1343]="谁" -- [1344]="敢" -- [1345]="惹" -- [1346]="我" -- [1347]="一" -- [1348]="抢" -- [1349]="捅" -- [1350]="死"

    
    -- local temp_bg = ZImage:create( nil, path, 0, 0, -1, -1)
    -- local temp_bg_size = temp_bg:getSize()
    self.view = CCBasePanel:panelWithFile( 0, 0, -1, -1, path )
    --self.view = CCBasePanel:panelWithFile( 0, 0, temp_bg_size.width, temp_bg_size.height, "" )
    self.view:setAnchorPoint(0.5,0.5)
    -- self.view:addChild(temp_bg.view)
    --self.touch_panel = CCTouchPanel:touchPanel( SelectCard.BODY_PHOTO_X, SelectCard.BODY_PHOTO_Y, 265, 360 )  -- 裁剪区域
    self.touch_panel = CCTouchPanel:touchPanel( SelectCard.BODY_PHOTO_X, SelectCard.BODY_PHOTO_Y, 265, 360 )  -- 裁剪区域
    self.view:addChild( self.touch_panel, SelectCard.BODY_PHOTO_Z )
end



function SelectCard:setAttr( atk,hp,def,ctrl )
    if self.line0 then
        return
    end
    local function addStars(n,r,path,sx,sy)
        local x = sx
        local y = sy
        for i=1,n do 
            local c = nil
            if i <= n then
                c = CCSprite:spriteWithFile(path)
            else
                c = CCSprite:spriteWithFile('ui/normal/star_green_d.png')
            end
            c:setScale(0.7)
            c:setAnchorPoint(CCPointMake(0,0))
            c:setPosition(CCPointMake(x,y))
            r:addChild(c)

            x = x + 12
        end
    end
    local PowOffsetX =  80

    self.line0 = CCNode:node()
    self.line1 = CCNode:node()
    self.line2 = CCNode:node()
    self.line3 = CCNode:node()


    self.hplable     =  CCSprite:spriteWithFile('ui/normal/hp.png')
    self.attacklabel =  CCSprite:spriteWithFile("ui/normal/atk.png")
    self.defendlabel =  CCSprite:spriteWithFile("ui/normal/def.png")
    self.controllabel = CCSprite:spriteWithFile("ui/normal/ctrl.png")


    self.attacklabel:setAnchorPoint(CCPointMake(0,0))
    self.attacklabel:setPosition(CCPointMake(70 - 45,38))
    self.hplable:setAnchorPoint(CCPointMake(0,0))
    self.hplable:setPosition(CCPointMake(70 + 80,38))
    self.defendlabel:setAnchorPoint(CCPointMake(0,0))
    self.defendlabel:setPosition(CCPointMake(70 - 45,8))
    self.controllabel:setAnchorPoint(CCPointMake(0,0))
    self.controllabel:setPosition(CCPointMake(70 + 80,8))

    self.line0:addChild(self.attacklabel)
    self.line1:addChild(self.hplable)
    self.line2:addChild(self.defendlabel)
    self.line3:addChild(self.controllabel)


    self.touch_panel:addChild(self.line0)
    self.touch_panel:addChild(self.line1)
    self.touch_panel:addChild(self.line2)
    self.touch_panel:addChild(self.line3)
    
    addStars(atk,self.line0,'ui/normal/star_red.png', 72, 42)
    addStars(hp,self.line1,'ui/normal/star_green.png', 196, 42)
    addStars(def,self.line2,'ui/normal/star_yellow.png', 72, 12)
    addStars(ctrl,self.line3,'ui/normal/star_purple.png', 196, 12)
    


    local sline = { self.line0, self.line1, self.line2, self.line3 }
    for i,v in ipairs(sline) do
        v:setIsVisible(false)
    end

    self.sline = sline
end

function SelectCard:payTextAnimation()

    local sline =  self.sline
    local t = 0.25
    for i,v in ipairs(sline) do
        v:setIsVisible(true)
        v:setPositionX(-300)
        local delay = CCDelayTime:actionWithDuration(t)
        local show =  CCMoveTo:actionWithDuration(0.5,CCPointMake(0.0,0.0));
        local array = CCArray:array();
        array:addObject(delay);
        array:addObject(show)
        local seq = CCSequence:actionsWithArray(array);
        v:runAction(seq)
        t = t + 0.2
    end


end

function SelectCard:resetText()

    print('SelectCard:resetText')
    self.text0:setIsVisible(false)
    self.text1:setIsVisible(false)

end
-- 设置单机事件
function SelectCard:set_click_event( fn )
    local function message_func( eventType, args, msgid, selfItem )
        if eventType == nil or args == nil or msgid == nil or selfItem == nil then
            return 
        end

        if eventType == TOUCH_ENDED then
            fn()
            return true
        end

        return false
    end
    self.view:registerScriptHandler(message_func)
end

-- 创建avatar
function SelectCard:create_center_avatar(  )
    if self.avatar == nil then 
        self.avatar = ZXAvatar:createShowAvatar()
        -- ZXEntityMgr:toAvatar(attri_value)
        self.avatar:setPosition( 155, 140 )
        self.view:addChild( self.avatar )
    end

    if self.body_name then                              -- 身体
        self.avatar:changeBody( self.body_name )
    end
    if self.weapon_name then                            -- 武器
        self.avatar:putOnWeapon( self.weapon_name )
    end
    if self.wing_name then                              -- 翅膀
        self.avatar:putOnWing( self.wing_name )
    end
    local shadow = CCSprite:spriteWithFile('nopack/shadow.png');
    
    self.avatar:addChild(shadow,-1)
end

-- 创建身体照片
function SelectCard:create_body_photo(  )
    if self.body_photo_path and self.body_photo == nil  then 
        self.body_photo = CCZXImage:imageWithFile( 0, 0, -1, -1, self.body_photo_path )
        self.touch_panel:addChild( self.body_photo, SelectCard.BODY_PHOTO_Z )
    end
end

-- 卡片到焦点，开始播放动画
function SelectCard:play( ... )
    self:stop_role_action(  )  -- 先停止之前的动作

    -- 人物 显示
    if self.avatar then 
        self.avatar:setIsVisible( true )
    end

    -- 文字播放结束后播放一系列人物动作
    local function play_role_action(  )
        self.can_show_action = true
        self:play_role_action()
    end

    -- 照片消失后，开始播放文字
    local function show_words_func()
        -- self:play_word( play_role_action )  -- 不要文字显示
        play_role_action(  )
    end

    if self.being_focus then  -- 如果本身已经是焦点，就直接播放系列动作
        -- 正在播放文字或消失效果的时候，点击一下当前图片，代码到这里。所以要确保文字已经播完才重播动作
        if self.can_show_action then   
            self:play_role_action()
        end
    else
        self.can_show_action = false
        self.being_focus = true
        self:play_dazuo(  )
        self:photo_discover_animation( show_words_func )     -- 照片消失  播放从照片消失开始
    end
    
    self:playText()
    self:payTextAnimation()
end

function SelectCard:playText()
    self.text0:stopAllActions()
    self.text1:stopAllActions()
    
    self.text0:setIsVisible(true)
    self.text1:setIsVisible(true)

    self.text0:setOpacity(0)
    self.text1:setOpacity(0)

    local fade_in = CCFadeIn:actionWithDuration(1.0);
    local delay = CCDelayTime:actionWithDuration(0.5)

    local array = CCArray:array();
    array:addObject(delay);
    array:addObject(fade_in)
    local seq = CCSequence:actionsWithArray(array);

    local fade_in0 = CCFadeIn:actionWithDuration(1.0);
    self.text0:runAction(fade_in0)
    self.text1:runAction(seq)
end

-- 卡片失去焦点，停止一切动画，用半身相替换
function SelectCard:stop( ... )
    self.being_focus = false
    -- 人物 不显示
    if self.avatar then 
        self.avatar:setIsVisible( false )
        self:play_dazuo(  )
    end

    -- 照片恢复
    if self.body_photo then 
        self.body_photo:setIsVisible( true )
        self:reset_photo(  )
        if self.discover_timer then 
            self.discover_timer:stop()
        end
    end

    -- 文字显示去除
    if self.word_timer then 
        self.word_timer:stop()
    end
    if self.words_bg then 
        print("删除文字背景。。。。。")
        self.view:removeChild( self.words_bg, true )
        self.words_bg = nil
    end

    -- 停止 系列动作 
    self:stop_role_action(  )

    self.text0:setIsVisible(false)
    self.text1:setIsVisible(false)

    local sline =  self.sline
    for i,v in ipairs(sline) do
        v:setIsVisible(false)
    end
end

-- 人物photo消失动画  参数：结束后的回调函数
function SelectCard:photo_discover_animation( cb_func )
    if self.body_photo == nil then 
        return
    end

    local begin_time = os.clock()

    if self.discover_timer == nil or self.discover_timer.scheduler_id == nil then 
        self.discover_timer = timer()
    end
    local function do_discover_animation(  )
        local now_time = os.clock()
        if now_time - begin_time > DISCOVER_NEED_TIME then                    -- 如果已经到时间，就消失
            self.body_photo:setIsVisible( false )
            self:reset_photo(  )
            self.discover_timer:stop()
            -- 时间到以后，回调
            if cb_func then 
                cb_func()
            end
        else
            local ratio = ( now_time - begin_time ) / ( DISCOVER_NEED_TIME )  -- 计算位置
            local curr_x = 264 * self.discover_forward * ratio
            local curr_y = 0
            self.body_photo:setPosition( curr_x, curr_y )
        end
    end
    self.discover_timer:start( 0.0, do_discover_animation ) 

end

-- 重置照片
function SelectCard:reset_photo(  )
    if self.body_photo then 
        self.body_photo:setPosition( 0, 0 )
    end
end

-- 播放文字  参数：播放完以后回调
function SelectCard:play_word( cb_func )
    print("播放文字")
    if self.word_timer then 
        self.word_timer:stop()
    end
    self.word_timer = timer()

    if self.words_bg then 
        self.view:removeChild( self.words_bg, true )
    end
    self.words_bg = CCZXImage:imageWithFile( 0, 0, 300, 340, "" )
    self.view:addChild( self.words_bg )

    local begin_x = 250
    local begin_y = 230
    local interval_x = 200
    local interval_y = 45
    local font_size = 20
    local word_index = 1
    local row_num = 4

    local function show_words_func(  )
        local word = self.show_words[ word_index ]

        if not word or word == "" then 
            self.word_timer:stop()
            self.view:removeChild( self.words_bg, true )
            self.words_bg = nil
            -- 结束以后，回调
            if cb_func then 
                cb_func()
            end
            return 
        end

        local curr_x = begin_x - interval_x * math.floor( (word_index - 1) / row_num )
        local curr_y = begin_y - interval_y * ( (word_index - 1) % row_num )
        local word_lable = UILabel:create_lable_2( "#cff49f4"..word, curr_x, curr_y, font_size, ALIGN_CENTER )
        self.words_bg:addChild( word_lable )
        word_index = word_index + 1
    end
    self.word_timer:start( _word_interval_time, show_words_func )
end

-- 打坐
function SelectCard:play_dazuo(  )
    if self.avatar then 
        self.avatar:takeOffWeapon()
        self.avatar:playAction( ZX_ACTION_PRACTICE, 1, true )  -- 打坐
    end
end

-- 播放一系列动作
function SelectCard:play_role_action(  )
    print("播放一些列动作...")
    local action_info_t = {
        { time = 1, action_type = ZX_ACTION_IDLE, if_repeat = true, forward = 1 },      -- 待机
        { time = 2, action_type = ZX_ACTION_MOVE, if_repeat = true, forward = 1 },      -- 跑
        -- { time = 2, action_type = ZX_ACTION_MOVE, if_repeat = true, forward = 4 },
        { time = 0.6, action_type = ZX_ACTION_HIT, if_repeat = false, forward = 1 },    -- 攻击
        { time = 0.6, action_type = ZX_ACTION_HIT_2, if_repeat = false, forward = 1 },
        { time = 0.6, action_type = ZX_ACTION_HIT, if_repeat = false, forward = 1 },
        { time = 0.6, action_type = ZX_ACTION_HIT, if_repeat = false, forward = 1 },
        { time = 0.6, action_type = ZX_ACTION_HIT_2, if_repeat = false, forward = 1 },
        { time = 0.6, action_type = ZX_ACTION_HIT, if_repeat = false, forward = 4 },
        { time = 0.6, action_type = ZX_ACTION_HIT_2, if_repeat = false, forward = 4 },
        { time = 0.6, action_type = ZX_ACTION_HIT, if_repeat = false, forward = 4 },
        { time = 0.6, action_type = ZX_ACTION_HIT_2, if_repeat = false, forward = 4 },
        { time = 0.6, action_type = ZX_ACTION_HIT_2, if_repeat = false, forward = 4 },
        { time = 1, action_type = ZX_ACTION_IDLE, if_repeat = true, forward = 1 },      -- 待机
    }
    local action_index = 1
    
    if self.avatar then 
        self.avatar:putOnWeapon( self.weapon_name )
    else
        return 
    end

    self:stop_role_action(  )   -- 先停止之前的动作
    local function play_action_func(  )
        local action_info = action_info_t[ action_index ]
        if action_info == nil or self.avatar == nil then 
            return 
        end
        local forward = action_info.forward or 1       -- forward 可以不配置，默认为1
        self.avatar:playAction( action_info.action_type, forward, action_info.if_repeat )

        -- 下一个动作
        action_index = action_index + 1
        self.callback_temp:cancel()
        self.callback_temp:start( action_info.time, play_action_func )
    end
    self.callback_temp:start( 0.0, play_action_func )

end

-- 停止系列动作
function SelectCard:stop_role_action(  )
    if self.callback_temp then 
        self.callback_temp:cancel()
    end
end


-- 销毁
function SelectCard:destroy(  )
    if self.discover_timer then 
        self.discover_timer:stop()
    end

    if self.word_timer then 
        self.word_timer:stop()
    end

    if self.callback_temp then 
        self.callback_temp:cancel()
    end
end
