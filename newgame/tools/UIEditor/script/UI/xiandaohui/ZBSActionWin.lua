-- ZBSActionWin.lua 
-- created by hcl on 2013-8-29
-- 争霸赛动作界面

super_class.ZBSActionWin(Window)

-- local _flower_str = "#cfff000送飞吻#r  ";
-- local _egg_str = "#cfff000扔鸡蛋#r ";
--local _match_str = "#cfff000争霸赛进程 ";

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _winShowY = {205+64, 125+64}

function ZBSActionWin:__init( )

  self.flower_cd = false;
  self.egg_cd = false;

	--让面板可击穿
	self.view:setDefaultMessageReturn(false);

  --打泡泡事件
  local function play_paopao_event( eventType,arg, msgid, selfItem )
    if eventType == TOUCH_CLICK then

        if self.target_name == nil then
          GlobalFunc:create_screen_notic(Lang.xiandaohui.play_win[1])--"只能对十六强玩家使用"
          return;
        end
        if self.flower_cd == true then
          GlobalFunc:create_screen_notic(Lang.xiandaohui.play_win[2])--"送飞吻冷却时间未结束"
          return;
        end
        if (self.target_name) then
            XianDaoHuiCC:req_flower( 0,self.target_name )
        else
          
        end
    end
    return true;
  end

  --打戏水事件
  local function play_xishui_event( eventType,arg, msgid, selfItem )
    if eventType == TOUCH_CLICK then
        if self.target_name == nil then
          GlobalFunc:create_screen_notic(Lang.xiandaohui.play_win[1])--"只能对十六强玩家使用"
          return;
        end
        if self.egg_cd == true then
          GlobalFunc:create_screen_notic(Lang.xiandaohui.play_win[3])--"扔鸡蛋冷却时间未结束"
          return;
        end
        if (self.target_name) then
            XianDaoHuiCC:req_flower( 1,self.target_name )
        end
    end
    return true;
  end

	--送花按钮
	self.flower_btn = CCNGBtnMulTex:buttonWithFile(70, 0, 65, 65, UILH_XIANDAOHUI.zbs_action1)
  --self.flower_btn:addTexWithFile(CLICK_STATE_DOWN,UIResourcePath.FileLocate.common .. "bubble_btn_s.png")
	self.flower_btn:registerScriptHandler(play_paopao_event);
	self.flower_btn:setMessageCut(true);
	
  self:addChild(self.flower_btn);
  
  -- local str = _flower_str.."5次";
  -- MUtils:create_sprite(self.flower_btn,UILH_XIANDAOHUI.zbs_action1,31,39);
  self.flower_text = MUtils:create_zxfont(self.flower_btn,"",32.5,28,2,18);

  --扔鸡蛋按钮
	self.egg_btn = CCNGBtnMulTex:buttonWithFile(140, 0, 65, 65, UILH_XIANDAOHUI.zbs_action2)
  -- self.egg_btn:addTexWithFile(CLICK_STATE_DOWN,UIResourcePath.FileLocate.common .. "bubble_btn_s.png")
	self.egg_btn:registerScriptHandler(play_xishui_event);
	self.egg_btn:setMessageCut(true);
  self:addChild(self.egg_btn);
  -- local str = _egg_str.."5次"
  self.egg_text = MUtils:create_zxfont(self.egg_btn,"",32.5,28,2,18);
  -- MUtils:create_sprite(self.egg_btn,UILH_XIANDAOHUI.zbs_action2,31,39);
  
  self.flower_call = callback:new();
  self.egg_call = callback:new();

  -- 查看比赛进程
  local function caiquan_click( eventType )
      if TOUCH_CLICK == eventType then
          local zbs_info = XDHModel:get_zbs_info();
          print("当前状态....",zbs_info.lt_state,zbs_info.turn);
          if ( zbs_info.turn == 4 and zbs_info.lt_state==3 ) then
              GlobalFunc:create_screen_notic( Lang.xiandaohui.play_win[4] ); -- [2261]="争霸赛已经结束"
          else
              if ( zbs_info.lt_state == 1 ) then
                  ZBSZB:show();
              else
                  ZBSJC:show();
              end
          end
          
      end
      return true;
  end
  local caiquan_btn = MUtils:create_btn( self.view,UILH_XIANDAOHUI.zbs_action3 ,UILH_XIANDAOHUI.zbs_action3,
            caiquan_click,0,0,65,65);
  -- local lab = UILabel:create_lable_2( _match_str, 12, 27, 14, ALIGN_LEFT );
  -- caiquan_btn:addChild(lab);
   -- MUtils:create_sprite(caiquan_btn,UILH_XIANDAOHUI.zbs_action3,31,30);

  -- self:update_btn_state( CLICK_STATE_DISABLE ,nil);

  -- 根据菜单栏是否显示来校正位置，UIManager中关于这个window的位置配置其实是没打算去使用的。
  local win = UIManager:find_visible_window("menus_panel")
  if win then
    local is_menus_show = win:get_is_show()
    if is_menus_show ~= nil then
          if is_menus_show == true then
              self.view:setPosition(_refWidth(0.5),_winShowY[1])
          else
            self.view:setPosition(_refWidth(0.5),_winShowY[2]) 
          end
      end
  end

end


function ZBSActionWin:update_play_action_count( paopao_count, xishui_count )
	--_paopao_str..
  self.flower_text:setText("#c35c3f7"..tostring(paopao_count)..LangGameString[618]); -- [618]="次"
  if paopao_count == 0 then
      self.flower_btn:setCurState(CLICK_STATE_DISABLE);
  end
  --_xishui_str..
	self.egg_text:setText("#c35c3f7"..tostring(xishui_count)..LangGameString[618]); -- [618]="次"
  if xishui_count == 0 then
      self.egg_btn:setCurState(CLICK_STATE_DISABLE);
  end
end

function ZBSActionWin:update_btn_state( state ,target_name)
    if self.flower_cd == false then
      -- self.flower_btn:setCurState(CLICK_STATE_UP);
      self.target_name = target_name;
    end
    if self.egg_cd == false then
      -- self.egg_btn:setCurState(CLICK_STATE_UP);
      self.target_name = target_name;
    end
end

-- 开始冷却时间
function ZBSActionWin:cd_time( btn_index,cooltime )
  
  local progressTo_action  = CCProgressTo:actionWithDuration(cooltime, 0);
  local progressTimer = CCProgressTimer:progressWithFile("nopack/skill_cd.png");
  progressTimer:setPercentage(99);
  progressTimer:setType( kCCProgressTimerTypeRadialCCW );
  progressTimer:setPosition(CCPointMake(30, 32));
  progressTimer:runAction( progressTo_action );

  if btn_index == 1 then
    self.flower_btn:addChild(progressTimer,5);
    -- self.flower_btn:setCurState(CLICK_STATE_DISABLE);

  else
    self.egg_btn:addChild(progressTimer,5);
    -- self.egg_btn:setCurState(CLICK_STATE_DISABLE);
  end
    

    local function dismiss( dt )
        if progressTimer then
          progressTimer:removeFromParentAndCleanup(true);
        end
        if btn_index == 1 then
          self.flower_cd = false;
        else
          self.egg_cd = false;
        end
    end

    if btn_index == 1 then
      self.flower_call:cancel();
      self.flower_call:start(cooltime,dismiss)
      self.flower_cd = true;
    else 
      self.egg_call:cancel();
      self.egg_call:start(cooltime,dismiss)
      self.egg_cd = true;
    end
end

function ZBSActionWin:active( show )
  if show then
      local xh_count, jd_count = XDHModel:get_xh_and_jd_count();
      self:update_flower_and_egg_count(xh_count,jd_count)
  end
end

function ZBSActionWin:update_flower_and_egg_count(xh_count, jd_count)
    self.flower_text:setText("#c35c3f7"..string.format(Lang.xiandaohui.play_win[5],xh_count))--"%s次"
    self.egg_text:setText("#c35c3f7"..string.format(Lang.xiandaohui.play_win[5],jd_count))--"%s次"
end

function ZBSActionWin:menuChangeVisible(is_menus_show)
    local win = UIManager:find_visible_window("zbs_action_win")
    if ( win ) then
        if is_menus_show then
            local p = CCPointMake(_refWidth(0.5),_winShowY[1])
            win.view:runAction(CCMoveTo:actionWithDuration(0.3,p))   
        else
            local p = CCPointMake(_refWidth(0.5),_winShowY[2])
            win.view:runAction(CCMoveTo:actionWithDuration(0.3,p))    
        end
    end
end