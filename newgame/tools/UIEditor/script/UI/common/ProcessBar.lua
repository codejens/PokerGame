-- ProcessBar.lua
-- created by hcl on 2013/2/1
-- 通用的提示框

require "UI/component/Window"
require "utils/MUtils"
super_class.ProcessBar(Window)

function ProcessBar:show(time)
    -- 创建通用购买面板
    local win = UIManager:show_window("process_bar");
    if ( win ) then
	    win:init_with_arg(time);
	end
end

function ProcessBar:__init(window_name, texture_name)
	self.view:setAnchorPoint(0.5,0.5);
	-- MUtils:create_sprite(self.view,UIResourcePath.FileLocate.common .. "process_bg.png",128.5,19.5);
    local label  = UILabel:create_lable_2( LH_COLOR[2]..Lang.common.collection, 130, 69, 16, ALIGN_CENTER )
    self.view:addChild(label)
	local process_bar_bg = MUtils:create_sprite(self.view,UILH_NORMAL.collect_process_bar_bg,-70,30);
	process_bar_bg:setAnchorPoint(CCPoint(0,0));
    -- process_bar_bg:setScaleY(0.90)

    self.dismiss_callback = callback:new()
	-- self.process_bar = MUtils:create_sprite(self.view,"ui/common/process_bar.png",36,9);
	-- self.process_bar:setAnchorPoint(CCPoint(0,0));
end

function ProcessBar:init_with_arg(time)
  	local progressTo_action  = CCProgressTo:actionWithDuration(time, 100);
    self.progressTimer = CCProgressTimer:progressWithFile("nopack/collect_process_bar.png");
    self.progressTimer:setPosition(CCPoint(-52,36));
    self.progressTimer:setAnchorPoint(CCPoint(0,0));
    self.progressTimer:setPercentage(0);
    self.progressTimer:setType( kCCProgressTimerTypeHorizontalBarLR );
    self.view:addChild(self.progressTimer,5);
    self.progressTimer:runAction( progressTo_action );

    local star = MUtils:create_sprite(self.progressTimer, UILH_NORMAL.collect_process_cursor, 0, 10)
    star:setAnchorPoint(CCPoint(0.69,0.52))

    local size = self.progressTimer:getContentSize()
    local array = CCArray:array()
    local move = CCMoveBy:actionWithDuration(time, CCPoint(size.width, 0))
    array:addObject(move)
    -- local rotate = CCRotateBy:actionWithDuration(time, 720)
    -- array:addObject(rotate)
    local spawn = CCSpawn:actionsWithArray(array)
    star:runAction(spawn)

	-- self.process_bar:setScaleX(0);
	-- local action = CCScaleTo:actionWithDuration(time,1,1);
	-- self.process_bar:runAction(action);
	-- time秒后消失
    local function dismiss( dt )
    	self.progressTimer:removeFromParentAndCleanup(true);
        UIManager:hide_window("process_bar");
    end
    self.dismiss_callback:start(time, dismiss)
end

function ProcessBar:hide( )
    local win = UIManager:find_visible_window("process_bar");
    if ( win ) then
        win.dismiss_callback:cancel();
        win.progressTimer:removeFromParentAndCleanup(true);
        UIManager:hide_window("process_bar");
    end
end

