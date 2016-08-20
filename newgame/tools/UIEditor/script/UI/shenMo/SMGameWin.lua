-- SMGameWin.lua
-- created by hcl on 2014-3-7
-- 神魔之塔山寨

super_class.SMGameWin(Window)

local START_X = 15;
local START_Y = 15;
local GEM_WIDTH = 60;
local DRAG_PANEL_MAX_X = GEM_WIDTH*6+START_X-30;
local DRAG_PANEL_MAX_Y = GEM_WIDTH*5+START_Y-30;
local GEM_IMG_PATH = {"nopack/sm/di.png","nopack/sm/feng.png","nopack/sm/huo.png",
					"nopack/sm/shui.png","nopack/sm/xin.png","nopack/sm/yue.png"};

-- 宝石类型 1地2风3火4水5心6月

----------------------------------------------------------------------------------------------
-- 根据坐标计算出宝石索引
-- 宝石索引 左下角为1
local function cal_index( x,y )
	local index = math.floor((x - START_X)/GEM_WIDTH) + 1  + math.floor( (y-START_Y)/GEM_WIDTH )*6 ;
	print("根据坐标计算出宝石索引",index);
	return index;
end
-- 根据索引计算出宝石中心点坐标
local function cal_center_pos( index )
	local i = math.floor((index-1)/6)+1
	local j = (index-1)%6+1;
	print("cal_center_pos",index,i,j)
	return START_X + (j-1)*GEM_WIDTH + 30,START_Y+(i-1)*GEM_WIDTH + 30;
end

------------------------------------------------------------------------------



function SMGameWin:show()
	UIManager:show_window("sm_game_win")
end
-- 初始化
function SMGameWin:__init()
	-- 保存所有宝石的表
	self.gem_view_tab = {};
	-- 当前选中的宝石view
	self.select_gem_view = nil;
	-- 当前选中的宝石索引
	self.select_gem_index = nil;
	-- 拖动panel
	self.drag_panel = nil;
	-- 第一次拖动起时记录下x,y坐标
	self.last_x = nil;
	self.last_y = nil;
	-- 为了限制TOUCH_MOVE移动速度，要记录上次TOUCH_MOVE的坐标
	self.old_touch_move_x = 0;
	self.old_touch_move_y = 0;

	ZImage:create(self.view,"ui/common/nine_grid_bg5.png",10,10,GEM_WIDTH*6+10,GEM_WIDTH*5+10,0,500,500);
	for i=1,5 do
		for j=1,6 do
			local x = START_X + (j-1)*GEM_WIDTH;
			local y = START_Y+(i-1)*GEM_WIDTH;
			-- 背景
			ZCCSprite:create(self.view,"ui/normal/item_bg01.png",x+30,y+30);
			self.gem_view_tab[(i-1)*6+j] = self:create_baoshi(x+30,y+30);
		end
	end
	self:create_drag_panel();
end
-- 取得一个随机的宝石图片路径
function SMGameWin:get_random_baoshi(  )
	local num = math.random(1,6);
	return GEM_IMG_PATH[num],num;
end

-- 创建宝石拖动panel
function SMGameWin:create_drag_panel()
	self.drag_panel =  ZBasePanel:create(self.view, "", START_X, START_Y, GEM_WIDTH*6, GEM_WIDTH*5);
	local function fun(event_type,args)
		-- print("event_type",event_type)
		if event_type == TOUCH_BEGAN then 
			local temparg = Utils:Split(args,":")
		    local _x = tonumber(temparg[1]);
		    local _y = tonumber(temparg[2]);		
			local index = cal_index( _x,_y )
			local spr = self.gem_view_tab[index];
			-- 选中的宝石透明度降低
			spr.view:setOpacity(100);
			-- 生成一个新的宝石
			self.select_gem_view = ZImage:create(self.view,GEM_IMG_PATH[spr.gem_type],_x,_y)
			self.select_gem_view.view:setOpacity(200);
			self.select_gem_view.view:setAnchorPoint(0.5,0.5);	
			-- 记录当前选中的宝石索引
			self.select_gem_index = index;
			-- 记录当前选中的宝石的x,y坐标
			self.last_x,self.last_y = cal_center_pos( index );
			return true;
		elseif event_type == TOUCH_MOVED then 
			local temparg = Utils:Split(args,":")
		    local _x = tonumber(temparg[1]);
		    local _y = tonumber(temparg[2]);
		    print("x = ",_x,"y = ",_y);
		    if math.abs(_x - self.old_touch_move_x )< 1 and math.abs(_y - self.old_touch_move_y)<1 then
		    	return true;
		    end
		    -- 移动宝石
		    self.select_gem_view.view:setPosition(_x,_y);
		    self.old_touch_move_x = _x;
		    self.old_touch_move_y = _y;
		    -- 超出范围直接返回
		    if _x >= DRAG_PANEL_MAX_X or _x <= 0 or 
		    	_y >= DRAG_PANEL_MAX_Y or _y <= 0 then
		    	return true;
		    end

		    local r_x = _x - self.last_x;
		    local r_y = _y - self.last_y;
		    if math.abs(r_x) > 30 or math.abs(r_y) > 30 then
		    	local target_index = 0;
		    	-- 只要x或y超出30就需要调转两个宝石的位置
		    	if r_x > 30 then
		    		-- 右上
		    		if r_y > 30 then
		    			target_index = self.select_gem_index + 7 ;
		    			self:run_switch_action( target_index ,self.last_x + GEM_WIDTH,self.last_y + GEM_WIDTH )
		    		-- 右下
		    		elseif r_y < - 30 then 
		    			target_index = self.select_gem_index - 5 ;
		    			self:run_switch_action( target_index ,self.last_x + GEM_WIDTH,self.last_y - GEM_WIDTH )
		    		-- 右
		    		else
		    			target_index = self.select_gem_index + 1;
		    			self:run_switch_action( target_index , self.last_x + GEM_WIDTH,self.last_y  )
		    		end
		    	elseif r_x < -30 then
		    		-- 左上
		    		if r_y > 30 then
		    			target_index = self.select_gem_index + 5;
		    			self:run_switch_action( target_index , self.last_x - GEM_WIDTH,self.last_y + GEM_WIDTH )
		    		-- 左下
		    		elseif r_y < - 30 then 
		    			target_index = self.select_gem_index - 7 ;
		    			self:run_switch_action( target_index ,self.last_x - GEM_WIDTH,self.last_y - GEM_WIDTH )
		    		-- 左
		    		else
		    			target_index = self.select_gem_index - 1;
		    			self:run_switch_action( target_index , self.last_x - GEM_WIDTH,self.last_y )
		    		end 
		    	else
		    		-- 上
		    		if r_y > 30 then
		    			target_index = self.select_gem_index + 6;
		    			self:run_switch_action( target_index ,self.last_x ,self.last_y + GEM_WIDTH )
		    		-- 下
		    		elseif r_y < - 30 then 
		    			target_index = self.select_gem_index - 6 ;
		    			self:run_switch_action( target_index , self.last_x ,self.last_y - GEM_WIDTH )
		    		end 		    		
		    	end
		    	
		    end
		    return true;			
		elseif event_type == TOUCH_ENDED then 
			-- 删除新生成的宝石
			self.select_gem_view.view:removeFromParentAndCleanup(true);
			self.select_gem_view = nil;
			-- 恢复透明度
			self.gem_view_tab[self.select_gem_index].view:setOpacity(255);
			self.select_gem_index = nil;
			-- 每次移动过程中，检测当前宝石是否移动到了隔壁宝石的中间
			return true;
		end
	end
	self.drag_panel.view:registerScriptHandler(fun);

	-- 如果拖出了宝石的范围
	local function parent_fun( event_type )
		if event_type == TOUCH_ENDED then
			if self.select_gem_view then
				-- 删除新生成的宝石
				self.select_gem_view.view:removeFromParentAndCleanup(true);
				self.select_gem_view = nil;
				-- 恢复透明度
				self.gem_view_tab[self.select_gem_index].view:setOpacity(255);
				self.select_gem_index = nil;
			end
		end
		return true;
	end
	self.view:registerScriptHandler(parent_fun);
end
-- 执行交换两个宝石的action
function SMGameWin:run_switch_action( target_index ,target_x,target_y )
	local old_x = self.last_x;
	local old_y = self.last_y;
	print(old_x,old_y,target_x,target_y,target_index);
	-- 创建action
	local action1 = CCMoveTo:actionWithDuration(0.1,CCPoint( target_x,target_y ));
	local action2 = CCMoveTo:actionWithDuration(0.1,CCPoint( old_x,old_y ));
	-- 交换表里面的数据
	local old_spr = self.gem_view_tab[ self.select_gem_index ]
	local target_spr = self.gem_view_tab[ target_index ];
	self.gem_view_tab[ target_index ] = old_spr;
	self.gem_view_tab[ self.select_gem_index ] = target_spr;
	-- 执行action
	old_spr.view:runAction(action1)
	target_spr.view:runAction(action2)
	-- 目标索引变成当前选中的索引
	self.select_gem_index = target_index;
	-- 更新选中宝石的中心点
	self.last_x,self.last_y = cal_center_pos( self.select_gem_index );
end


--创建一个宝石按钮
function SMGameWin:create_baoshi(x,y )
	local path,gem_type = self:get_random_baoshi();
	local spr = ZCCSprite:create(self.view,path,x,y,10);
	spr.gem_type = gem_type;
	return spr;
end

