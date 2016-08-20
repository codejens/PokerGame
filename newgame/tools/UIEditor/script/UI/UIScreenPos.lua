ZXLog('UIScreenPos loaded')
UIScreenPos = {}
--------------------------------------
--
-- 换算屏幕9宫格
--
--------------------------------------
UI_TAG_ACTION_SHOW_WIN            = 200

local window9GridPos = nil
local _POS_I = 1
local _ANCHOR_I = 2
local _OFFSCREEN_I = 3
local _NEAR_POS_I = 4
local _OFFSET = 6

local _SCALE_ACT1_I = 3

local _MOVE = 1
local _SCALE = 2
local _screenOffsetX = 0
local _screenOffsetY = 0

local function _ActionMove(tWin,pos)
    local _pos = pos[_OFFSCREEN_I]
    local _anchor = pos[_ANCHOR_I]

    tWin.view:setPosition(_pos.x,_pos.y)
    tWin.view:setAnchorPoint(_anchor.x,_anchor.y)
    local move_to_act1 = CCMoveTo:actionWithDuration(0.5, pos[_NEAR_POS_I]);
    local act_easa = CCEaseExponentialOut:actionWithAction(move_to_act1);
    --偏差
    local move_to_act2 = CCMoveTo:actionWithDuration(0.1, pos[_POS_I]);
    local seq_act = CCSequence:actionOneTwo(act_easa, move_to_act2);
    seq_act:setTag(UI_TAG_ACTION_SHOW_WIN)
    tWin.view:stopActionByTag(UI_TAG_ACTION_SHOW_WIN)
    tWin.view:runAction(seq_act);
end

local function _ActionScale(tWin, pos)
    local _pos = pos[_POS_I]
    local _anchor = pos[_ANCHOR_I]
    tWin.view:setPosition(_pos.x,_pos.y)
    tWin.view:setAnchorPoint(_anchor.x,_anchor.y)
    tWin.view:setScale(0.0)

    local scale_act1 = CCScaleTo:actionWithDuration(0.25, pos[_SCALE_ACT1_I]);
    local act_easa = CCEaseExponentialOut:actionWithAction(scale_act1);

    local scale_act2 = CCScaleTo:actionWithDuration(0.1, 1.0);
    local seq_act = CCSequence:actionOneTwo(act_easa, scale_act2);
    seq_act:setTag(UI_TAG_ACTION_SHOW_WIN)
    tWin.view:stopActionByTag(UI_TAG_ACTION_SHOW_WIN)
    tWin.view:runAction(seq_act);
end

function _initScreen9GridPos()
    if not window9GridPos then
        _screenOffsetX = (GameScreenConfig.ui_screen_width - GameScreenConfig.ui_design_width ) * 0.5
        _screenOffsetY = (GameScreenConfig.ui_screen_height - GameScreenConfig.ui_design_height ) * 0.5


        window9GridPos = {}
        local w  = GameScreenConfig.ui_screen_width
        local hw = GameScreenConfig.ui_screen_width * 0.5
        local h  = GameScreenConfig.ui_screen_height 
        local hh = GameScreenConfig.ui_screen_height * 0.5

        window9GridPos[1] = {  
                               action = nil,
                               CCPointMake(0, 0), 
                               CCPointMake(0, 0)             
                            }
        -------------------------------------------------------------------------
        window9GridPos[2] = {  action = nil,
                               CCPointMake(hw, 0), 
                               CCPointMake(0.5, 0)          
                            }
        -------------------------------------------------------------------------
        window9GridPos[3] = {  action = nil,
                               CCPointMake(w, 0), 
                               CCPointMake(1.0, 0)           
                            }
        -------------------------------------------------------------------------
        --左窗口
        window9GridPos[4] = {  action = _ActionMove,
                               CCPointMake(15, hh+5), 
                               CCPointMake(0, 0.5),    
                               CCPointMake(-w, hh+5),  
                               CCPointMake(6+15, hh+5) 
                            }
        -------------------------------------------------------------------------
        --对话框居中
        window9GridPos[10] = {  action = _ActionScale,
                               CCPointMake(hw, hh), --CCPointMake(hw, hh+5), 为了使复活对话框居中，不加5
                               CCPointMake(0.5, 0.5),
                               1.1 }
        -------------------------------------------------------------------------
        --右窗口
        window9GridPos[6] = {  action = _ActionMove,
                               CCPointMake(w-15, hh+5), 
                               CCPointMake(1.0, 0.5), 
                               CCPointMake(w*2, hh+5),
                               CCPointMake(w - _OFFSET-15, hh+5) }
        -------------------------------------------------------------------------
        window9GridPos[7] = {  action = nil,
                               CCPointMake(0, h), 
                               CCPointMake(0, 1.0) }
        -------------------------------------------------------------------------
        window9GridPos[8] = {  action = nil,
                               CCPointMake(hw, h), 
                               CCPointMake(0.5, 1.0) }
        -------------------------------------------------------------------------
        window9GridPos[9] = {  action = nil,
                               CCPointMake(w, h), 
                               CCPointMake(1.0, 1.0) }
        ----------
        --全屏居中
        window9GridPos[5] = {  action = _ActionMove,
                                CCPointMake(hw, hh), 
                                CCPointMake(0.5, 0.5), 
                                CCPointMake(hw, -h),
                                CCPointMake(hw, hh + _OFFSET) }
    end 
end

------------------------
--
--@param tWin              窗口
--@param grid9index        按照小键盘换算的9宫格位置和anchor
--
------------------------
function UIScreenPos.screen9GridPos(tWin,grid9index)
    _initScreen9GridPos()
    local pos = window9GridPos[grid9index]
    tWin.view:setPosition(pos[_POS_I].x,pos[_POS_I].y)
    tWin.view:setAnchorPoint(pos[_ANCHOR_I].x,pos[_ANCHOR_I].y)
end

------------------------
--这个是带动画的
--@param tWin              窗口
--@param grid9index        按照小键盘换算的9宫格位置和anchor
--
------------------------
function UIScreenPos.screen9GridPosWithAction(tWin,grid9index)
    _initScreen9GridPos()

    local pos = window9GridPos[grid9index]
    if pos.action == nil then
        UIScreenPos.screen9GridPos(tWin,grid9index)
        return
    else
        pos.action(tWin,pos)
    end


end

------------------------
--
--@param tWin              窗口
--@param fx                屏幕坐标百分比            
--@param fy                屏幕坐标百分比
--@param grid9index        按照小键盘换算的9宫格位置和anchor
--
------------------------
function UIScreenPos.screenPos(tWin,fx,fy,grid9index)
    _initScreen9GridPos()
    local pos = window9GridPos[grid9index]
    local x = GameScreenConfig.ui_screen_width * fx
    local y = GameScreenConfig.ui_screen_height * fy
    local anchor = pos[2]
    tWin.view:setPosition(x,y)
    tWin.view:setAnchorPoint(anchor.x,anchor.y)
end


function UIScreenPos.relativeWidth(fValue)
  return GameScreenConfig.ui_screen_width * fValue
end

function UIScreenPos.relativeHeight(fValue)
  return GameScreenConfig.ui_screen_height * fValue
end

--设计SizeConvert to OutputSize
function UIScreenPos.designToRelativeWidth(nValue)
  return nValue / GameScreenConfig.ui_design_width * GameScreenConfig.ui_screen_width
end

function UIScreenPos.designToRelativeHeight(nValue)
  return nValue / GameScreenConfig.ui_design_height * GameScreenConfig.ui_screen_height
end


function UIScreenPos.calculateCenterScreenPos(x,y,w,h,anchor)
  local px = x
  local py = y
  if anchor == 2 or anchor == 5 or anchor == 8 then 
    px = _screenOffsetX + x
  end

  if anchor == 4 or anchor == 5 or anchor == 6 then
    py = _screenOffsetY + y
  end

  if anchor == 3 or anchor == 6 or anchor == 9 then
    px = GameScreenConfig.ui_screen_width - (GameScreenConfig.ui_design_width - x)
  end

  if anchor == 7 or anchor == 8 or anchor == 9 then
    py = GameScreenConfig.ui_screen_height - (GameScreenConfig.ui_design_height - y)
  end

  px = px + w * 0.5
  py = py + h * 0.5
  return px,py
end

function UIScreenPos.calculateScreenPos(x,y, anchor)
  local px = x
  local py = y
  if anchor == 2 or anchor == 5 or anchor == 8 then 
    px = _screenOffsetX + x
  end

  if anchor == 4 or anchor == 5 or anchor == 6 then
    py = _screenOffsetY + y
  end

  if anchor == 3 or anchor == 6 or anchor == 9 then
    px = GameScreenConfig.ui_screen_width - (GameScreenConfig.ui_design_width - x)
  end

  if anchor == 7 or anchor == 8 or anchor == 9 then
    py = GameScreenConfig.ui_screen_height - (GameScreenConfig.ui_design_height - y)
  end

  return px,py
end
