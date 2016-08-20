-- UC平台接入登录界面
local dprint = lprint
local logopath = 'ui2/login/kuwu.png'
local labelpath = 'ui2/login/login_btn_label.png'
local LoginDepth = 1023
local fixtxt = LangGameString[1787] -- [1787]="问题修复"
PlatformUILoginWin = { visible_state = false }
local _screenSize = { GameScreenConfig.ui_screen_width, 
                      GameScreenConfig.ui_screen_height }
-- 创建按钮
local function create_btn(parent,filepath,selectedpath,func,pos_x,pos_y,width,height,z,lb_w,lb_h,rb_w,rb_h,lt_w,lt_h,rt_w,rt_h)
    local btn = nil;
    if (lb_w==nil or lb_h == nil) then
        btn = CCNGBtnMulTex:buttonWithFile(pos_x,pos_y,width,height,filepath);
    else
        btn = CCNGBtnMulTex:buttonWithFile(pos_x,pos_y,width,height,filepath,TYPE_MUL_TEX,lb_w,lb_h,rb_w,rb_h,lt_w,lt_h,rt_w,rt_h);
    end
    
    if (selectedpath) then
        btn:addTexWithFile(CLICK_STATE_DOWN,selectedpath);
    end
    if(func == nil) then
        func = function(eventType,x,y)
            if eventType == TOUCH_CLICK then
                --按钮抬起时处理事件.
                return true;
            end
        end
    end
    
    btn:registerScriptHandler(func);
    if(z == nil) then 
        z = 0;
    end
    return btn;
end

function PlatformUILoginWin:showLoginBtn(state)
    --如果要显示loginBtn，LoginWin也需要显示 LuShan 2014-06-23
    if state then
        if not PlatformUILoginWin.visible_state then
            PlatformUILoginWin:show(state)
        end
    end
    if self.enterGameBtn then
        self.enterGameBtn:setIsVisible(state)
    end
end

function PlatformUILoginWin:show(state)
    --require 'scene/WeatherSystem'
	--ZXLog("PlatformUILoginWin:show",PlatformUILoginWin,state,self.logo)
    --PlatformUILoginWin 是否处于显示状态
    --如果要显示loginBtn，LoginWin也需要显示 LuShan 2014-06-23
    PlatformUILoginWin.visible_state = state

	if state then
		if self.logo then
			return
		end

		local UIRoot = ZXLogicScene:sharedScene():getUINode()

		--让这个节点注册到事件分发流程里去
		local function ui_main_msg_fun(eventType,x,y)
			if eventType == CCTOUCHBEGAN then 
				return true
			elseif eventType == CCTOUCHENDED then
	            return true
			end
		end

		UIRoot:registerScriptTouchHandler(ui_main_msg_fun, false, 0, false)

		local logo = CCSprite:spriteWithFile(logopath);
		logo:setAnchorPoint(CCPointMake(0.5,0.5))
        logo:setPosition(393,
        				 _screenSize[2] + 70)
        

        local function btn_ok_fun(eventType,x,y)
            if eventType == TOUCH_BEGAN then
                return true;
            elseif eventType == TOUCH_CLICK then
                -- PlatformUC:dologin()
                
                PlatformInterface:doLogin()

                return true;
            elseif eventType == TOUCH_ENDED then
                return true;
            end
        end

        local function btn_fix(eventType,x,y)
            if eventType == TOUCH_BEGAN then
                return true;
            elseif eventType == TOUCH_CLICK then
                UpdateManager:AutofixDialog()
                return true;
            elseif eventType == TOUCH_ENDED then
                return true;
            end
            --
        end

        if Target_Platform ==  Platform_Type.QQHall then
            labelpath = "ui2/login/kaishiyouxi.png"
        end
        local btn1 = create_btn(nil,"ui/common/bubble_btn_n.png","ui/common/bubble_btn_n.png",btn_ok_fun,0,0,80,80);
        local btn1_size = btn1:getSize()

        --local btn2 = create_btn(nil,"ui2/login/autofix.png","ui2/login/autofix.png",
        --                        btn_fix,
        --                        0,0,64,64);

        local label = CCSprite:spriteWithFile(labelpath);
        local label_size = {width=42,height=37}
		--local p = CCParticleSystemQuadEx:particleWithFile('particle/roundButtonEffect.plist')
		--p:setPosition(40,44)
		label:setPosition((btn1_size.width-label_size.width)/2 + 20,(btn1_size.height-label_size.height) /2 + 20)
		--btn1:addChild(p)
        btn1:addChild(label)
        btn1:setAnchorPoint(0.5,0.5)
        btn1:setPosition(_screenSize[1] * 0.5,
        				 _screenSize[2] * 0.5 - 90)
    
        --btn2:setPosition(GameScreenFactors.standard_width - 72,
         --                GameScreenFactors.standard_height - 72)

        --local textLabel = CCZXLabel:labelWithText(-2,4,fixtxt,14);
        --btn2:addChild(textLabel)

        -- 把显示系统公告的代码抽了出来
        local _info_back = PlatformUILoginWin:show_announcement();

        UIRoot:addChild(_info_back,LoginDepth)
		UIRoot:addChild(logo,LoginDepth)
		UIRoot:addChild(btn1,LoginDepth)
        --UIRoot:addChild(btn2,LoginDepth)

        logo:setOpacity(0.0)
        local fade_in = CCFadeIn:actionWithDuration(0.5);
        logo:runAction(fade_in)

		self.enterGameBtn = btn1
		self.logo = logo
        self.info_back = _info_back
        --self.fixBtn = btn2

        local function btn_logout_fun(eventType,x,y)
            if eventType == TOUCH_BEGAN then
                return true;
            elseif eventType == TOUCH_CLICK then
                -- PlatformUC:dologin()
                PlatformInterface:logout()
                return true;
            elseif eventType == TOUCH_ENDED then
                return true;
            end
        end
        --[[
        local btn1 = create_btn(nil,"ui2/login/remove_but.png","ui2/login/remove_but.png",btn_logout_fun,0,0,80,80);
        --btn1:addChild(label)
        btn1:setAnchorPoint(0.5,0.5)
        btn1:setPosition(GameScreenFactors.standard_half_width,
                         GameScreenFactors.standard_half_height - 180)
        UIRoot:addChild(btn1,LoginDepth)
        ]]--
	else
		if self.logo then
			self.enterGameBtn:removeFromParentAndCleanup(true)
			self.logo:removeFromParentAndCleanup(true)
            --self.fixBtn:removeFromParentAndCleanup(true)
            self.info_back:removeFromParentAndCleanup(true)
			self.enterGameBtn = nil
			self.logo = nil
            --self.fixBtn = nil
            --self.weather:leave()
            --self.weather = nil
		end

	end
end

function PlatformUILoginWin:show_announcement()
    local _info_back = CCZXImage:imageWithFile( 0, 800, 244, 324, "ui2/update/bg_06.png", 500, 500 ) 
    local content = CCDialogEx:dialogWithFile( 8, -24, 228, 320, 200 , "", TYPE_VERTICAL, ADD_LIST_DIR_UP )

    local textLabel = CCZXLabel:labelWithText(120-40,296,LangGameString[1414],18); -- [1414]="#cffff00系统公告"
    local an = UpdateManager.announcement or ''
    content:setText(an)
    _info_back:addChild(textLabel)
    _info_back:addChild(content)

    local moveTo = CCMoveTo:actionWithDuration(0.5,CCPointMake(0,90))
    local move0  = CCEaseIn:actionWithAction(moveTo,0.7);
    local move1 = CCMoveTo:actionWithDuration(0.25,CCPointMake(0,105))
    local move2 = CCMoveTo:actionWithDuration(0.2,CCPointMake(0,100))
    local array = CCArray:array();
    array:addObject(move0);
    array:addObject(move1);
    array:addObject(move2);
    local seq = CCSequence:actionsWithArray(array);
    _info_back:runAction(seq)

    return _info_back;
end

