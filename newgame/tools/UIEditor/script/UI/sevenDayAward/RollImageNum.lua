---------CHJ
---------2014-01-17
--------- 数字有上往下滚动
require "UI/component/AbstractBase"
----------------------------------------------------------------------
----------------------------------------------------------------------
---------
---------单选按钮组

-- 控件状态

super_class.RollImageNum(AbstractBasePanel)
---------

RollImageNum.STATE_IDLE = 0
RollImageNum.STATE_RUN = 1
---------
local function RollImageNum_CreateFunction( self, x, y, width, height, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)
	local tPosX = x or 0
    local tPosY = y or 0
    local tWidth = width or 0
    local tHeight = height or 0
    local tImage = image or ''
    local tTopLeftWidth = topLeftWidth or 0
    local tTopLeftHeight = topLeftHeight or 0
    local tTopRightWidth = topRightWidth or 0
    local tTopRightHeight = topRightHeight or 0 
    local tBottomLeftWidth = bottomLeftWidth or 0
    local tBottomLeftHeight = bottomLeftHeight or 0
    local tBottomRightWidth = bottomRightWidth or 0
    local tBottomRightHeight = bottomRightHeight or 0
    ---------
    local base_anel = CCBasePanel:panelWithFile(tPosX, tPosY, tWidth, tHeight, tImage, tTopLeftWidth, tTopLeftHeight, tTopRightWidth, tTopRightHeight, tBottomLeftWidth, tBottomLeftHeight, tBottomRightWidth, tBottomRightHeight)
    return base_anel
end

function RollImageNum:create( fatherPanel, num, imageNumPath, x, y, width, height, image,topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight )
	-- 创建 base面板
	local sprite = RollImageNum(fatherPanel, width, height)
	sprite.imageNumPath = imageNumPath
	sprite.view = RollImageNum_CreateFunction(sprite, x, y, width, height, image, topLeftWidth, topLeftHeight, topRightWidth, topRightHeight, bottomLeftWidth, bottomLeftHeight, bottomRightWidth, bottomRightHeight)

	-- 创建cctouchPanel 截取面板
	sprite.touchPanel = CCTouchPanel:touchPanel( 0, 0, width, height)
	sprite.view:addChild(sprite.touchPanel)

	-- panel, 存放10个数字的长度 
	sprite.numPanel[1] = sprite:create_num_panel( sprite.touchPanel )
	sprite:set_cur_num_panel(sprite.numPanel[1])
	sprite.numPanel[2] = sprite:create_num_panel( sprite.touchPanel )
	sprite.numPanel[2]:setPosition(0, height)
	sprite.numPanel[3] = sprite:create_num_panel( sprite.touchPanel, true )
	sprite.numPanel[3]:setPosition(0, height)

	-- 设置数字
	sprite.num = num or 0
	sprite:set_num_direct(sprite.num)

	fatherPanel:addChild(sprite.view)
	return sprite 
end

----------------------
-- item_h, item_w:一个数字面板的高, 宽
-- num : 控件当前的数字
-- speed: 控件，一个数字的面板移动所用的时间
function RollImageNum:__init( fatherPanel, width, height )
	-- 初始化数据
	self.item_w = width
	self.item_h = height
	self.num = 0
	self.speed_time = 0.07
	self.imageNumPath = nil

	-- 数字面板 & 当前面板
	self.numPanel = {}
	self.cur_num_panel = nil

	-- 计数当前圈数
	self.num_roll_count = 0

	-- 定时器(一圈交接点的定时器) & (9字下滑消失重新设置坐标的定时器)
	self.cb_t = {}
	self.cb_9_t = {}
	self.cb_last = nil

	-- 控件是否删掉
	self.is_destroy = false

	-- 状态
	self.state = RollImageNum.STATE_IDLE
end

-- 清除，恢复一些计数的数据
function RollImageNum:clear_count_data()
	self.num_roll_count = 0
	self.state = RollImageNum.STATE_IDLE
end

-- 清除所有的callback
function RollImageNum:clear_callback()
	if self.cb_t then
		for k,v in pairs(self.cb_t) do
			v:cancel()
			v = nil
		end
	end
	if self.cb_9_t then
		for k,v in pairs(self.cb_9_t) do
			v:cancel()
			v = nil
		end
	end
	if self.cb_last then
		self.cb_last:cancel()
		self.cb_last = nil
	end
end

-- 设置当前面板
function RollImageNum:set_cur_num_panel( panel )
	self.cur_num_panel = panel
end

-- 设置另一个为当前num_panel
function RollImageNum:set_other_as_cur_num_panle( old_panel, is_last )
	if is_last then
		self.cur_num_panel = self.numPanel[3]
		return 
	end
	if old_panel == self.numPanel[1] then
		self.cur_num_panel = self.numPanel[2]
	elseif old_panel == self.numPanel[2] then
		self.cur_num_panel = self.numPanel[1]
	end
end

-- 直接设置数字
function RollImageNum:set_num_direct( num )
	self.numPanel[1]:setPosition(0, -self.item_h*num)
	self.num = num
end

-- 滚动设置数字(向下滚动)
-- num , 需要摇出的数字
-- num_roll, 滚动n圈后，出数字
function RollImageNum:set_num_roll( num, num_roll )

	if self.state == RollImageNum.STATE_IDLE then
		self.state = RollImageNum.STATE_RUN
		if num_roll then
			self.num_roll_count = self.num_roll_count + 1
			-- 应该移动多少个数字
		    local num_item = 9 - self.num
			local target_y = -self.item_h*9
			local time_move = self.speed_time*num_item
			local act_move_to = CCMoveTo:actionWithDuration( time_move, CCPoint(0, target_y))
			-- local act_move_to_e = CCEaseIn:actionWithAction(act_move_to, 0.2);
			self.cur_num_panel:runAction( act_move_to )

			-- 创建callback定时调用
			self.cb_t[self.num_roll_count] = callback:new()
			local function callback_1_func()
				self:do_roll(self.cur_num_panel, num, num_roll )
				self.cb_t[self.num_roll_count] = nil
			end
			self.cb_t[self.num_roll_count]:start( time_move, callback_1_func)
		end
	end

	-- -- 应该移动多少个数字
	-- local num_item = num - self.num
	-- local target_y = -self.item_h*num
	-- local act_move_to = CCMoveTo:actionWithDuration(self.speed_time*num_item, CCPoint(0, target_y))
	-- local act_move_to_e = CCEaseIn:actionWithAction(act_move_to, 0.2);
	-- self.numPanel[1]:runAction( act_move_to_e )
end

function RollImageNum:do_roll( panel, num, num_roll )
	self.num_roll_count = self.num_roll_count + 1

	-- 处理 第九个数字 滑下去后的事情
	if not self.is_destroy then
		local act_move_9 = CCMoveTo:actionWithDuration( self.speed_time, CCPoint(0, -self.item_h*10) )
		print("-----------panel:", panel, panel.runAction)
		if panel then
			panel:runAction(act_move_9)
		end
		self.cb_9_t[self.num_roll_count] = callback:new()
		local function callback_func( )
			if panel then
				panel:setPosition(0, self.item_h)
			end
			self.cb_9_t[self.num_roll_count] = nil
		end
		self.cb_9_t[self.num_roll_count]:start(self.speed_time, callback_func)

		local is_last_roll = false
		if num_roll == self.num_roll_count then
			is_last_roll = true
		end

		-- 设置当前num_panel
		self:set_other_as_cur_num_panle(panel, is_last_roll)
		-- 如果当前圈 == 目标圈，结束！同时初始化原来的数据 =======================end
		if is_last_roll then
			-- 20格的距离，分两个动作执行，第一个动作(匀速)，到第一个当前数字，第二个动作(变速)移动10格巨鹿(第2个当前数字)
			local target_y_1 = - self.item_h*num
			local act_move_to_1 = CCMoveTo:actionWithDuration( self.speed_time*num, CCPoint(0, target_y_1) )
			-- self.cur_num_panel:runAction( act_move_to_1 )

			-- 第二个动作
			-- local function callback_last_func( )
			local target_y_2 = - self.item_h*(10+num)
			local act_move_to_2 = CCMoveTo:actionWithDuration( self.speed_time*10*3, CCPoint(0, target_y_2) )
			local act_move_to_e = CCEaseOut:actionWithAction(act_move_to_2, 3)

			local act_arr = CCArray:array()
			act_arr:addObject(act_move_to_1)
			act_arr:addObject(act_move_to_e)
			local act_seq = CCSequence:actionsWithArray(act_arr)
				-- self.cur_num_panel:runAction( act_move_to_e )
			self.cur_num_panel:runAction( act_seq )
			-- end
			-- if self.cb_last then
			-- 	self.cb_last:cancel()
			-- 	self.cb_last = nil
			-- end
			-- self.cb_last = callback:new()
			-- self.cb_last:start(self.speed_time*num, callback_last_func)

			-- 清除计算数据
			self:clear_count_data()
		else
			local target_y = - self.item_h*9
			local time_9 = self.speed_time*9
			local act_move_to = CCMoveTo:actionWithDuration( time_9, CCPoint(0, target_y))
			self.cur_num_panel:runAction( act_move_to )

			-- 创建callback定时调用
			self.cb_t[self.num_roll_count] = callback:new()
			local function callback_func()
				self:do_roll(self.cur_num_panel, num, num_roll )
				self.cb_t[self.num_roll_count] = nil
			end
			self.cb_t[self.num_roll_count]:start( time_9, callback_func)

		end
	end
end

-- 创建一个数组面板
function RollImageNum:create_num_panel( panel, last_flag )
	local panel_num = nil
	if last_flag then
		panel_num = CCBasePanel:panelWithFile( 0, 0, self.item_w, self.item_h*20, "", 500, 500 )
		panel:addChild( panel_num, 2 )
		for i=0, 19 do
			local numItem = CCBasePanel:panelWithFile( 0, i*self.item_h, self.item_w, self.item_h, UILH_AWARD.la_bg_3, 500, 500)
			panel_num:addChild(numItem)
			local img_num = i
			if i > 9 then
				img_num = img_num - 10
			end 
			local numSpr = ZCCSprite:create( numItem, string.format(self.imageNumPath, img_num), self.item_w*0.5, self.item_h*0.5, 1 )
		end	
	else
		panel_num = CCBasePanel:panelWithFile( 0, 0, self.item_w, self.item_h*10, "", 500, 500 )
		panel:addChild( panel_num )
		for i=0, 9 do
			local numItem = CCBasePanel:panelWithFile( 0, i*self.item_h, self.item_w, self.item_h, UILH_AWARD.la_bg_3, 500, 500)
			panel_num:addChild(numItem)
			local numSpr = ZCCSprite:create( numItem, string.format(self.imageNumPath, i), self.item_w*0.5, self.item_h*0.5, 1 )
		end	
	end
	return panel_num
end

----------------------
function RollImageNum:destroy()
	self:clear_callback()
	self.is_destroy = true
end
