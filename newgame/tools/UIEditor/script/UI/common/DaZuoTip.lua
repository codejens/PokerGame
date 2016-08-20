-- DaZuoTip.lua
-- created by hcl on 2013/1/8
-- 打坐指引对话框

require "UI/component/Window"
require "utils/MUtils"
super_class.DaZuoTip(Window)

function DaZuoTip:__init()

    local function panel_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	print("run DaZuoTip destroy_window--------------------------")
            UIManager:destroy_window("dazuo_tip");
           	return true;
        end
        return true
    end
  	self.view:registerScriptHandler(panel_fun);

	local spr_bg = CCZXImage:imageWithFile( 235, 140, 330, 200, UIResourcePath.FileLocate.common .. "bg_blue.png",  120,88,120,88,120,74,120,74 );
    self.view:addChild( spr_bg );

    -- 标题
    -- local title_bg = CCZXImage:imageWithFile( 330 / 2 - 81, 200 - 35, -1, -1, UIResourcePath.FileLocate.common .. "dialog_title_bg.png"  )
    -- MUtils:create_sprite(title_bg,UIResourcePath.FileLocate.normal .. "dialog_title_t.png",81,23)
    -- spr_bg:addChild(title_bg,2);

    MUtils:create_ccdialogEx(self.view,LangGameString[810],340,220,200,65,10,14); -- [810]="向下滑动可以进行打坐，打坐可以获得大量灵气和经验"

    local function btn_ok_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
     		UIManager:hide_window("dazuo_tip");
        end
        return true
    end
    local btn = MUtils:create_btn(self.view,UIResourcePath.FileLocate.common .. "tishi_button.png", UIResourcePath.FileLocate.common .. "tishi_button.png",btn_ok_fun,235 + 124.5,165,-1,-1);
    MUtils:create_sprite(btn,UIResourcePath.FileLocate.normal .. "queding.png",55,20.5)

    local drag_out_bg = CCProgressTimer:progressWithFile("nopack/down.png");
	drag_out_bg:setAnchorPoint(CCPoint(0.5,1.0));
	drag_out_bg:setType( kCCProgressTimerTypeVerticalBarTB );
	drag_out_bg:setPosition(CCPoint(60,160));

	local spr_hand = CCSprite:spriteWithFile("nopack/ani/hand1.png");
	spr_hand:setAnchorPoint(CCPoint(0.5,1.0))
	spr_hand:setPosition(CCPoint(60,160));

	spr_bg:addChild(drag_out_bg,5)
	spr_bg:addChild(spr_hand,5)

    local moveto1 = CCMoveTo:actionWithDuration(1.2,CCPoint(60,88))
	local delay_time = CCDelayTime:actionWithDuration(0.49);
	local moveto   = CCMoveTo:actionWithDuration(0.01,CCPoint(60,160));
	
	local _array = CCArray:array();
	_array:addObject(moveto1)
	_array:addObject(delay_time)
	_array:addObject(moveto);

	local sequence = CCSequence:actionsWithArray(_array);
	local repeatForever = CCRepeatForever:actionWithAction(sequence);

	local progressTo_action  = CCProgressTo:actionWithDuration(1.2, 100);
	local delay_time2 = CCDelayTime:actionWithDuration(0.5);
	local _array2 = CCArray:array();
	_array2:addObject(progressTo_action)
	_array2:addObject(delay_time2)

	local sequence2 = CCSequence:actionsWithArray(_array2);
	local repeatForever2 = CCRepeatForever:actionWithAction(sequence2);
	
	drag_out_bg:runAction(repeatForever2);
	spr_hand:runAction(repeatForever);

end	
