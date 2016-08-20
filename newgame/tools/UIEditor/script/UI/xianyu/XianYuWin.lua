-- XianYuWin.lua 
-- created by fjh on 2013-3-7
-- 灵泉仙浴的窗口

super_class.XianYuWin(Window)

local _paopao_str = "#cfff000" -- LangGameString[2279]; -- [2279]="#cfff000打泡泡#r#cfff000  "
local _xishui_str = "#cffffff" -- LangGameString[2280]; -- [2280]="#cfff000戏 水#r#cfff000 "

--打泡泡事件
local function play_paopao_event( eventType,arg, msgid, selfItem )
	if eventType == nil or arg == nil or msgid == nil or selfItem == nil then
    return
  end
	if eventType == TOUCH_CLICK then
		XianYuModel:play_paopao_action( );
	end
	return true;
end

--打戏水事件
local function play_xishui_event( eventType,arg, msgid, selfItem )
	if eventType == nil or arg == nil or msgid == nil or selfItem == nil then
    return
  end
	if eventType == TOUCH_CLICK then
	 
		XianYuModel:play_xishui_action( );
	end
	return true;
end

function XianYuWin:__init( )
	--让面板可击穿
	self.view:setDefaultMessageReturn(false);
  self.view:setPosition(397, 230)

	--打泡泡按钮
	self.paopao_btn = CCNGBtnMulTex:buttonWithFile(0, 0, 62, 63, UIResourcePath.FileLocate.common .. "feizao.png")
  self.paopao_btn:addTexWithFile(CLICK_STATE_DISABLE, UIResourcePath.FileLocate.common .. "feizao_d.png")
	self.paopao_btn:registerScriptHandler(play_paopao_event);
	self.paopao_btn:setMessageCut(true);
	
  self:addChild(self.paopao_btn);
  
  local str = _paopao_str..LangGameString[2281]; -- [2281]="5次"
  self.paopao_text = MUtils:create_ccdialogEx(self.paopao_btn,str,15,-10,62,63,3,14);

    --戏水按钮
	self.xishui_btn = CCNGBtnMulTex:buttonWithFile(126, 0, 62, 63, UIResourcePath.FileLocate.common .. "huanggua.png")
  self.xishui_btn:addTexWithFile(CLICK_STATE_DISABLE, UIResourcePath.FileLocate.common .. "huanggua_d.png")
	self.xishui_btn:registerScriptHandler(play_xishui_event);
	self.xishui_btn:setMessageCut(true);
  self:addChild(self.xishui_btn);
  local str = _xishui_str..LangGameString[2281] -- [2281]="5次"
  self.xishui_text = MUtils:create_ccdialogEx(self.xishui_btn,str,15,-10,62,63,3,14);
  
  self.paopao_call = callback:new();
  self.xishui_call = callback:new();


  -- 猜拳  暂时屏蔽猜拳
  -- local function caiquan_click( eventType )
  --     if TOUCH_CLICK == eventType then
  --         UIManager:show_window("caiquan_win");
  --     end
  --     return true;
  -- end

  -- local caiquan_btn = MUtils:create_btn( self.view,UIResourcePath.FileLocate.common.."bubble_btn_n.png" ,UIResourcePath.FileLocate.common.."bubble_btn_s.png",
  --           caiquan_click,126,0,62,63);
  -- local lab = UILabel:create_lable_2( "#cffff00猜拳", 12, 27, 14, ALIGN_LEFT );
  -- caiquan_btn:addChild(lab);

end

-- 开始冷却时间
function XianYuWin:cd_time( btn_index,cooltime )
  
  local progressTo_action  = CCProgressTo:actionWithDuration(cooltime, 0);
  local progressTimer = CCProgressTimer:progressWithFile("nopack/skill_cd.png");
  progressTimer:setPercentage(99);
  progressTimer:setType( kCCProgressTimerTypeRadialCCW );
  progressTimer:setPosition(CCPointMake(30, 32));
  progressTimer:runAction( progressTo_action );

  if btn_index == 1 then
  	self.paopao_btn:addChild(progressTimer,5);
  	self.paopao_btn:setCurState(CLICK_STATE_DISABLE);

  else
  	self.xishui_btn:addChild(progressTimer,5);
  	self.xishui_btn:setCurState(CLICK_STATE_DISABLE);
  end
    

  local function dismiss( dt )
      if progressTimer then
        local xianYuWin = UIManager:find_window("xianyu_win");
        if not xianYuWin then
          return
        end

        progressTimer:removeFromParentAndCleanup(true);
        
        local paopao_count, xishui_count = XianYuModel:get_play_action_count();
        print("次数",paopao_count,xishui_count);
       	if btn_index == 1 then
          if paopao_count > 0 then
       		   self.paopao_btn:setCurState(CLICK_STATE_UP);
          end
       	else
          if xishui_count > 0 then
       		   self.xishui_btn:setCurState(CLICK_STATE_UP);
          end
       	end
       end
  end

  if btn_index == 1 then
    self.paopao_call:cancel();
    self.paopao_call:start(cooltime,dismiss)
  else 
    self.xishui_call:cancel();
    self.xishui_call:start(cooltime,dismiss)
  end

end


function XianYuWin:update_play_action_count( paopao_count, xishui_count )
	
  self.paopao_text:setText(_paopao_str..tostring(paopao_count)..LangGameString[618]); -- [618]="次"
  if paopao_count == 0 then
      self.paopao_btn:setCurState(CLICK_STATE_DISABLE);
  end
	self.xishui_text:setText(_xishui_str..tostring(xishui_count)..LangGameString[618]); -- [618]="次"
  if xishui_count == 0 then
      self.xishui_btn:setCurState(CLICK_STATE_DISABLE);
  end
end
