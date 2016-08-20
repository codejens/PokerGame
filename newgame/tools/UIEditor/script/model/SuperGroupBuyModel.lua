--SuperGroupBuyModel.lua
--内容：超级团购活动的单体数据逻辑类
--作者：陈亮
--时间：2014.08.18

--加载团购活动的配置对象
require "config/SuperGroupBuyConfig"

--创建超级团购数据逻辑类
SuperGroupBuyModel = {}

-- 活动倒计时
local t_remainTime = nil

--定义常量
local _HAD_GAIN_CONTENT = "已领取"														--已领取字体
local _CAN_GAIN_CONTENT = "可领取"														--可领取字体
local _ACTIVITY_BIG_ID = 0                                                          -- 大活动ID
local _ACTIVITY_ID		= 81														--活动ID
local _DESCRIBE_TITLE_PATH = UILH_NORMAL.title_tips	--描述标题图片路径
local _SUPER_GIFT_BUY_WARNING = "你还需要购买%s个优惠礼包才可以购买超值礼包"			--购买超值礼包提示信息
local _BUY_LIMIT_TIP_CONTENT = "购买%d个实惠#r礼包后才能购#r买超值礼包"

--定义类的静态变量
local _configType = nil				--活动配置类型，如1、2、3、4
local _isShowBuyTip = false			--是否显示购买确认提示框
local _consumeCheapCount = 0 		--优惠礼包消费数量


--功能：确认到充值回调函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.21
local function comfirm_spend_money()
	GlobalFunc:chong_zhi_enter_fun()
end

--功能：根据礼包索引购买礼包，1、实惠礼包；2、超值礼包
--参数：1、giftIndex	礼包索引
--返回：无
--作者：陈亮
--时间：2014.08.21
local function comfirm_buy_gift(giftIndex)
	OnlineAwardCC:reqBuyGift(giftIndex)
end

--功能：根据提示购买确认框的复选框选择设置是否提示购买确认框
--参数：1、isSelected	复选框选择设置，false、提示复选框；true、不再提示复选框
--返回：无
--作者：陈亮
--时间：2014.08.21
local function set_buy_tip_status(isSelected)
	_isShowBuyTip = isSelected
end

--功能：数据逻辑对象结束复位
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyModel:finish()
	_configType = nil
	_isShowBuyTip = false
	_consumeCheapCount = 0
end


-- 设置绑定的大活动id(春节, 元宵, 白色情人节)
function SuperGroupBuyModel:set_ACTIVITY_ID( act_id )
	_ACTIVITY_BIG_ID = act_id
end

-- by chj 根据不同的大活动获取不同的团购tip(每天288) not use
function SuperGroupBuyModel:get_ui_main_tip( configType)
	if _ACTIVITY_ID == 9 then
		return UILH_MAINACTIVITY.tg_everyday
	elseif _ACTIVITY_ID == 10 then
		return UILH_MAINACTIVITY.tg_everyday_158
	elseif _ACTIVITY_ID == 12 then
		return UILH_MAINACTIVITY.tg_everyday_228
	elseif _ACTIVITY_ID == 81 then
		return UILH_MAINACTIVITY.tg_everyday_228
	end
end

-- by chj 根据绑定的大活动配置语言
function SuperGroupBuyModel:get_buy_txt( configType)
	local num_cheapGift = SuperGroupBuyConfig:getCheapGiftMax(_configType)
	return "购买" .. num_cheapGift .. "个实惠礼包后才能购买超值礼包"
end

-- by chj 根据configType 配置yb图片
function SuperGroupBuyModel:get_yb_img( configType )
	local yb_path = SuperGroupBuyConfig:get_yb_img_path( configType)
	return yb_path
end


--功能：根据配置类型更新团购活动的基础信息
--参数：configType		配置类型
--返回：无
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyModel:updateGroupBuyBaseInfo(configType,isShowQueue)
	--保存配置类型
	_configType = configType

	--如果团购界面显示,对界面进行任何操作
	local win = UIManager:find_visible_window("super_tuangou_win")
	local t_groupBuyWin = nil
	if win then
		t_groupBuyWin = win:get_page_by_index(1)
	end
	print("-----------t_groupBuyWin:", t_groupBuyWin, _configType, isShowQueue)
	if t_groupBuyWin then 
		--设置购买礼包和积分礼包
		local t_cheapGiftId = SuperGroupBuyConfig:getCheapGiftId(_configType)
		t_groupBuyWin:setCheapGiftId(t_cheapGiftId)
		local t_superGiftId = SuperGroupBuyConfig:getSuperGiftId(_configType)
		t_groupBuyWin:setSuperGiftId(t_superGiftId)
		local t_pointGiftId = SuperGroupBuyConfig:getPointGiftId(_configType)
		t_groupBuyWin:setPointGiftId(t_pointGiftId)

		--设置购买礼包和积分礼包的按钮内容
		local t_cheapBuyContent = SuperGroupBuyConfig:getCheapContent(_configType)
		t_groupBuyWin:setCheapBuyContent(t_cheapBuyContent)
		local t_superBuyContent = SuperGroupBuyConfig:getSuperContent(_configType)
		t_groupBuyWin:setSuperBuyContent(t_superBuyContent)
		local t_giftGainContent = SuperGroupBuyConfig:getGainContent(_configType)
		t_groupBuyWin:setGiftGainContent(t_giftGainContent)

		--设置进度条最大值
		local t_maxPoint = SuperGroupBuyConfig:getMaxPoint(_configType)
		t_groupBuyWin:setProgressMax(t_maxPoint)

		--设置元宝路径
		local t_moneyImagePath = SuperGroupBuyConfig:getMoneyImagePath(_configType)
		local t_moneyImageSize = SuperGroupBuyConfig:getMoneyImageSize(_configType)
		local t_moneyNum = SuperGroupBuyConfig:getMoneyNum(_configType)
		t_groupBuyWin:setMoneyImagePath(t_moneyImagePath,t_moneyImageSize, t_moneyNum)

		-- 设置中间描述
		local txt = SuperGroupBuyModel:get_buy_txt( _configType)
		t_groupBuyWin:set_buy_txt( txt )
	end

	--标志位为1，显示排行榜，需要设置排行榜数据的奖励设置
	if isShowQueue == 1 then
		--如果积分排行界面没有显示,即显示排行榜
		local win = UIManager:find_visible_window("super_tuangou_win")
		local t_countPointsWin = nil
		if win then -- 第二个分页
			t_countPointsWin = win:get_page_by_index(2)
		end
		if t_countPointsWin then
		--设置排行榜数据
			local t_awardGroup = SuperGroupBuyConfig:getAwardGroup(_configType)
			local t_awardCount = #t_awardGroup
			--遍历奖励组设置排行奖励
			for t_queueIndex = 1,t_awardCount do
				local t_awardId = t_awardGroup[t_queueIndex]
				t_countPointsWin:setQueueAwardInfo(t_queueIndex,t_awardId)
			end
		end
	--标志位为0，不显示排行榜
	else
		--如果积分排行界面显示,即隐藏排行榜
		-- local t_countPointsWin = UIManager:find_visible_window("countPointsWin")
		-- if t_countPointsWin then
		-- 	t_countPointsWin:clearQueueData()
		-- 	UIManager:hide_window("countPointsWin")
		-- end
	end
end

--功能：根据实惠礼包和超值礼包的剩余数量更新购买按钮状态
--参数：1、cheapGiftCount		实惠礼包剩余数量
--		2、superGiftCount		超值礼包剩余数量
--返回：无
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyModel:updateBuyButtonStatus(cheapGiftCount,superGiftCount)
	--如果团购界面不显示,不对界面进行任何操作
	local win = UIManager:find_visible_window("super_tuangou_win")
	if not win then
		return 
	end
	local t_groupBuyWin = nil
	if win then
		t_groupBuyWin = win:get_page_by_index(1)
	end
	if t_groupBuyWin then
		--首先判断实惠礼包的购买情况,实惠礼包剩余次数大于0，还可以购买
		print("----------t_groupBuyWin:", t_groupBuyWin, cheapGiftCount)
		if cheapGiftCount > 0 then
			t_groupBuyWin:clickedCheapBuyButton()
		else
			t_groupBuyWin:unclickedCheapBuyButton()
		end

		--计算优惠礼包消费数量
		local t_cheapGiftCount = SuperGroupBuyConfig:getCheapGiftMax(_configType)
		_consumeCheapCount = t_cheapGiftCount - cheapGiftCount

		--更新购买过度提示
		local t_consumeCheapCount = SuperGroupBuyConfig:getConsumeCheapCount(_configType)
		--提示还要购买XX个实惠礼包再购买超值礼包
		if _consumeCheapCount <  t_consumeCheapCount then
			--计算还需要购买的优惠礼包数量
			local t_cheapNeedBuyCount = t_consumeCheapCount - _consumeCheapCount
			local t_buyLimitContent = string.format(_BUY_LIMIT_TIP_CONTENT,t_cheapNeedBuyCount)
			t_groupBuyWin:showBuyTip()
			t_groupBuyWin:setBuyTipContent(t_buyLimitContent)
			t_groupBuyWin:hideOpenTip()
		else
			t_groupBuyWin:hideBuyTip()
			t_groupBuyWin:showOpenTip()
		end
		

		--判断超值礼包的购买情况,超值礼包剩余次数大于0，还可以购买
		if superGiftCount > 0 then
			t_groupBuyWin:clickedSuperBuyButton()
		else
			t_groupBuyWin:unclickedSuperBuyButton()
		end
	end
end

--功能：根据我的积分和积分礼包状态更新积分视图组
--参数：1、myPoint				我的积分
--		2、pointGiftStatus		积分礼包状态
--返回：无
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyModel:updateMyPointViewGroup(myPoint,pointGiftStatus)
	--如果团购界面不显示,不对界面进行任何操作
	local win = UIManager:find_visible_window("super_tuangou_win")
	-- if not win then
	-- 	return 
	-- end
	local t_groupBuyWin = nil
	if win then
		t_groupBuyWin = win:get_page_by_index(1)
	end
	if t_groupBuyWin then
		--设置进度条和我的积分
		t_groupBuyWin:setProgressCurrent(myPoint)
		t_groupBuyWin:setMyPoint(myPoint)

		--根据领取状态设置领取按钮状态
		--不可领取
		if pointGiftStatus == 0 then
			local t_giftGainContent = SuperGroupBuyConfig:getGainContent(_configType)
			t_groupBuyWin:setGiftGainContent(t_giftGainContent)
			t_groupBuyWin:unclickedGiftGainButton()
		--可领取
		elseif pointGiftStatus == 1 then
			t_groupBuyWin:setGiftGainContent(_CAN_GAIN_CONTENT)
			t_groupBuyWin:clickedGiftGainButton()
		--已领取
		else
			t_groupBuyWin:setGiftGainContent(_HAD_GAIN_CONTENT)
			t_groupBuyWin:unclickedGiftGainButton()
		end
	end

	-- 春节活动窗口(团购分页，显示积分)
	win = UIManager:find_visible_window("lonelyDayWin")
	if win then
		if win._pageGroup[6] then
			win._pageGroup[6]:setMyPoint(myPoint)
		end
	end
	-- 元宵节活动窗口(团购分页，显示积分)
	win = UIManager:find_visible_window("lanternDayWin")
	if win then
		if win._pageGroup[4] then
			win._pageGroup[4]:setMyPoint(myPoint)
		end
	end
    
    --白色情人节活动窗口(团购分页，显示积分)
	win = UIManager:find_visible_window("valentineWhiteDayWin")
	if win then
		if win._pageGroup[5] then
			win._pageGroup[5]:setMyPoint(myPoint)
		end
	end
end

--功能：根据仙宗排行和积分更新我的仙宗信息
--参数：1、myGuildQueue		仙宗排行
--		2、myGuildPoint		仙宗积分
--返回：无
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyModel:updateMyGuildInfo(myGuildQueue,myGuildPoint)
	--如果积分排行界面没有显示,不对界面进行任何操作
	local win = UIManager:find_visible_window("super_tuangou_win")
	if not win then
		return 
	end
	local t_countPointsWin = nil
	if win then
		t_countPointsWin = win:get_page_by_index(2)
	end

	--设置我的仙宗排名和积分
	if t_countPointsWin then
		t_countPointsWin:setMyGuildQueue(myGuildQueue)
		t_countPointsWin:setMyGuildPoint(myGuildPoint)
	end
end

--功能：根据排行榜数量和排行榜数据更新积分排行榜
--参数：1、queueCount			排行榜数量
--		2、queueDataGroup		排行榜数据
--返回：无
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyModel:updatePointQueue(queueCount,queueDataGroup)
	--如果积分排行界面没有显示,不对界面进行任何操作
	local win = UIManager:find_visible_window("super_tuangou_win")
	if not win then
		return 
	end
	local t_countPointsWin = nil
	if win then
		t_countPointsWin = win:get_page_by_index(2)
	end

	if t_countPointsWin then
		--清除排行榜数据
		t_countPointsWin:clearQueueData()

		--根据排行数量编辑排行榜数据，设置排行榜
		for t_queueIndex = 1,queueCount do
			--创建每个排行数据
			local t_queueItemData = {
				guildName = nil,
				guildPoint = nil
			}
			t_queueItemData.guildName = queueDataGroup.guildName[t_queueIndex]
			t_queueItemData.guildPoint = queueDataGroup.guildPoint[t_queueIndex]
			--设置排行榜
			t_countPointsWin:setPointQueueInfo(t_queueIndex,t_queueItemData)
		end

		--设置排行榜数据
		local t_awardGroup = SuperGroupBuyConfig:getAwardGroup(_configType)
		local t_awardCount = #t_awardGroup
		--遍历奖励组设置排行奖励
		for t_queueIndex = 1,t_awardCount do
			local t_awardId = t_awardGroup[t_queueIndex]
			t_countPointsWin:setQueueAwardInfo(t_queueIndex,t_awardId)
		end
	end

end

--设置活动倒计时
function SuperGroupBuyModel:set_remain_time( )
	t_remainTime = SmallOperationModel:get_act_time(_ACTIVITY_ID)

	if self.timer_cd then
		self.timer_cd:stop()
		self.timer_cd = nil
	end

	local function time_cd_func( dt )
		t_remainTime = t_remainTime -1
	end
	self.timer_cd= timer()
	self.timer_cd:start(1, time_cd_func)
end


-- 清除活动剩余时间
function SuperGroupBuyModel:clear_remain_time()
	if self.timer_cd then
		self.timer_cd:stop()
		self.timer_cd = nil
	end
	t_remainTime = nil
end

--功能：打开团购窗口
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyModel:openGroupBuyWin()
	--设置活动剩余时间
	-- local t_remainTime = SmallOperationModel:get_act_time(_ACTIVITY_ID)
	if not t_remainTime then
		t_remainTime = 0
	end
	--因为打开窗口才会调用这个方法，所以不用判断团购窗口是否显示
	local win = UIManager:find_visible_window("super_tuangou_win")
	local gb_page = nil
	if win then  -- 第一个分页
		gb_page = win:get_page_by_index(1)
	end
	if gb_page then 
		gb_page:setRemainTime(t_remainTime)
	end
	--请求团购活动信息
	OnlineAwardCC:reqGroupBuyInfo()
end

--功能：打开团购窗口
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyModel:openCountPointWin()
	--请求团购积分排行榜
	OnlineAwardCC:reqGroupBuyPointQueue()
end

--功能：关闭团购活动的活动窗口
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyModel:closeActivityWin()
	--如果团购窗口在显示，关闭团购窗口
	local win = UIManager:find_visible_window("super_tuangou_win")
	if win then
		UIManager:close_window("super_tuangou_win") 
	end
	-- local t_groupBuyWin = UIManager:find_visible_window("groupBuyWin")
	-- if t_groupBuyWin then
	-- 	UIManager:hide_window("groupBuyWin")
	-- end

	-- --如果积分排行窗口在显示，关闭积分排行窗口
	-- local t_countPointWin = UIManager:find_visible_window("countPointsWin")
	-- if t_countPointWin then
	-- 	UIManager:hide_window("countPointsWin")
	-- end
end

--功能：根据礼包索引购买礼包
--参数：1、giftIndex	礼包索引购买礼包
--返回：无
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyModel:buyGroupBuyGift(giftIndex)
	--根据礼包索引获取所需元宝数量，1代表实惠礼包，2代表超值礼包
	local t_giftGlod = nil
	if giftIndex == 1 then
		t_giftGlod = SuperGroupBuyConfig:getCheapGold(_configType)
	else
		local t_consumeCheapCount = SuperGroupBuyConfig:getConsumeCheapCount(_configType)
		--根据优惠礼包消费数量判断是否可以购买超值礼包,如果不可以购买，直接提示返回
		if _consumeCheapCount <  t_consumeCheapCount then
			local t_differCheapCount = t_consumeCheapCount - _consumeCheapCount
			local t_buySuperWarning = string.format(_SUPER_GIFT_BUY_WARNING,t_differCheapCount)
			GlobalFunc:create_screen_notic( t_buySuperWarning, 15, 570, 100 )
			return
		end

		t_giftGlod = SuperGroupBuyConfig:getSuperGold(_configType)
	end

	--获取角色元宝数量
	local t_playRole = EntityManager:get_player_avatar()
	local t_roleGold = t_playRole.yuanbao
	--当元宝不足时，提示充值
	if t_giftGlod > t_roleGold then
		ConfirmWin2:show( 2, 2, "", comfirm_spend_money)
	--元宝够买礼包时，如果要提示确认购买框，弹出提示框
	elseif (not _isShowBuyTip) then
		--弹出提示购买确认框
		local t_warningContent = "您确认消费" .. t_giftGlod .. "元宝购买该物品吗？"
		ConfirmWin2:show( 5, 2, t_warningContent, bind(comfirm_buy_gift,giftIndex),set_buy_tip_status)
	--元宝够买礼包时，不需要提示确认购买框，直接购买礼包
	else
		OnlineAwardCC:reqBuyGift(giftIndex)
	end
end

--功能：领取积分礼包
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyModel:gainPointGift()
	OnlineAwardCC:reqGainPointGift()
end

--功能：显示排行描述提示
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.18
function SuperGroupBuyModel:showQueueDescirbe()
	--获取说明内容
	local t_describe = ""
	--显示说明窗口
	HelpPanel:show(3,_DESCRIBE_TITLE_PATH,t_describe)
end