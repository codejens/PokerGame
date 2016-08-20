--CCommonActivityBaseWin.lua
--内容：通用活动基础窗口类
--作者：陈亮
--时间：2014.08.27

--加载布局文件
require "../data/layouts/Activity/Common/CommonActivityBaseWinLayout"

--定义常量
local _INIT_INDEX = 1

--定义通用活动基础窗口类
super_class.CommonActivityBaseWin(NormalStyleWindow)

--功能：定义通用活动基础窗口的属性
--参数：1、self		通用活动基础窗口对象
--返回：无
--作者：陈亮
--时间：2014.08.27
local function create_self_params(self)
	self._currentIndex = nil
	self._selectActivitySlot = nil
	self._directlyDataGroup = nil
	self._directlyScroll = nil
	self._currentPage = nil
	self._pageClassGroup = nil
	self._pageGroup = {}
	self._isInit = true
	self.slot_item_array = {}
end

--功能：切换页
--参数：1、self			通用活动基础窗口对象
--		2、itemIndex	子活动索引
--返回：无
--作者：陈亮
--时间：2014.08.28
local function change_page(self,itemIndex)
	--如果正在显示当前页，不需要切页
	if itemIndex == self._currentIndex then
		return
	end

	--获取当前要切换页
	local t_currentPage = self._pageGroup[itemIndex]
	--如果没有创建过该页，创建该页
	if not t_currentPage then
		local t_pageClass = self._pageClassGroup[itemIndex]
		t_currentPage = t_pageClass()
		--保存该页
		self._pageGroup[itemIndex] = t_currentPage
		--加载入视图
		local t_pageView = t_currentPage:getPageView()
		self.view:addChild(t_pageView)
	end
	--保存当前页并显示出来
	self._currentPage = t_currentPage
	t_currentPage:showPage()

	--获取当前被切换页
	local t_lastPage = self._pageGroup[self._currentIndex]
	if t_lastPage then
		t_lastPage:hidePage()
	end

	--保存当前选中索引
	self._currentIndex = itemIndex
end

--功能：定义通用活动基础窗口的属性
--参数：1、self		通用活动基础窗口对象
--返回：无
--作者：陈亮
--时间：2014.08.27
local function scroll_item_click(self,activitySlot,itemIndex,eventType)
	--点击事件
	-- if eventType == TOUCH_CLICK then
		print("itemIndex",itemIndex)

    	-- SlotEffectManager.play_effect_by_slot_item(activitySlot)
    	--保存当前导航图标
		self._selectActivitySlot = activitySlot
      
		--切换点击页
		change_page(self,itemIndex)
		for i=1,#self.slot_item_array do
			if i == itemIndex then
				if self.slot_item_array[i].select_frame then
				   self.slot_item_array[i].select_frame:setIsVisible(true)
			    end
			else
				if  self.slot_item_array[i].select_frame then
				    self.slot_item_array[i].select_frame:setIsVisible(false)
		     	end
			end
		end
     
    -- end
end

--功能：滑动框的子项视图动作
--参数：1、self			窗口对象
--		2、itemIndex	子项索引
--		3、eventType	事件类型
--返回：无
--作者：陈亮
--时间：2014.12.22
local function scroll_item_view_action(self,itemIndex,eventType)
	--如果是删除事件，删除相对应滑动框的玩家名字和玩家充值UI
	if eventType == ITEM_DELETE and self._currentIndex == itemIndex then
		self._selectActivitySlot = nil
	end
end


--功能：创建导航滑动框子行
--参数：1、self			窗口对象
--		2、itemIndex	子行索引
--返回：无
--作者：陈亮
--时间：2014.08.27
local function create_scroll_item(self,itemIndex)
	local int_h = 100
	local panel_height = int_h * #self._directlyDataGroup
	local t_panelBg = ZBasePanel:create(nil, "", 0, 0, 220, panel_height, 0, 500, 500)
	local beg_y = 0
	--解析子项导航数据
	for i, v in ipairs(self._directlyDataGroup) do
		local t_directlyData = self._directlyDataGroup[i]
		--创建视图背景
		local t_viewBgLayout = CommonActivityBaseWinLayout.viewBg
		local t_viewBg = ZBasePanel:create(nil,t_viewBgLayout.path,t_viewBgLayout.x,t_viewBgLayout.y,t_viewBgLayout.width,t_viewBgLayout.height,0,500,500)
		t_viewBg.view:registerScriptHandler(bind(scroll_item_view_action,self,itemIndex))


		--创建子行背景
		local t_itemBgLayout = CommonActivityBaseWinLayout.itemBg
		local t_itemBg = CCBasePanel:panelWithFile(t_itemBgLayout.x,t_itemBgLayout.y,t_itemBgLayout.width,t_itemBgLayout.height,t_itemBgLayout.path,500,500)
		t_viewBg.view:addChild(t_itemBg)

		--创建子活动图标
		local t_activitySlotLayout = CommonActivityBaseWinLayout.activitySlot
	   
	    local item = MUtils:create_slot_item2(t_viewBg,t_activitySlotLayout.bgPath,t_activitySlotLayout.x,t_activitySlotLayout.y,t_activitySlotLayout.width,t_activitySlotLayout.height,nil,nil,9.5);
	    item:set_icon_texture( t_directlyData.iconPath,  -8, -8, 80, 80 )
	    --选中框t_directlyScroll
	    t_viewBg.select_frame = MUtils:create_zximg(t_viewBg,UILH_COMMON.select_focus2, -2, -5, 223, 103);
	    t_viewBg.select_frame:setIsVisible(false)

	    local function selected_change( eventType )
	        scroll_item_click(self,item,i,eventType); 
	        return true;
	    end 
	    item:set_click_event(selected_change);

	    -- t_viewBg 出发事件
	    local function item_sld_func(eventType, arg, msgid, selfitem)
	    	if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
	            return
	        end
	        if eventType == TOUCH_BEGAN then
	            scroll_item_click(self,item,i,eventType); 
	            return true;
	        elseif eventType == TOUCH_CLICK then
	            return true;
	        end
	        return true;
	    end
	    t_itemBg:registerScriptHandler(item_sld_func)

		--创建主标题
		-- local t_mainTitleContent = t_directlyData.mainTitleContent
		-- local t_mainTitleLayout = CommonActivityBaseWinLayout.mainTitle
		-- ZLabel:create(t_viewBg,t_mainTitleContent,t_mainTitleLayout.x,t_mainTitleLayout.y,t_mainTitleLayout.fontSize)

		-- --创建副标题
		-- local t_subTitleContent = t_directlyData.subTitleContent
		-- local t_subTitleLayout = CommonActivityBaseWinLayout.subTitle
		-- ZLabel:create(t_viewBg,t_subTitleContent,t_subTitleLayout.x,t_subTitleLayout.y,t_subTitleLayout.fontSize)

	    local main_title_img =MUtils:create_zximg(t_viewBg,t_directlyData.txtPath, 97, 25, -1, -1);
		--注册子行背景点击事件
		-- t_itemBg:registerScriptHandler(bind(scroll_item_click,self,item,itemIndex))
		--暂时屏蔽 避免子页面在修改时麻烦
	    
		--如果当前创建的索引等于当前索引，使图标表现动态,使按钮呈现高亮状态，保存选中图标
	    if i == self._currentIndex then
	       	-- SlotEffectManager.play_effect_by_slot_item(item)
	       	-- self._selectActivitySlot = item
	       t_viewBg.select_frame:setIsVisible(true)

	    end
	    self.slot_item_array[i] = t_viewBg
	    t_panelBg:addChild(t_viewBg.view)
	    t_viewBg.view:setPosition(0, panel_height - i * int_h)
	end
	return t_panelBg
end

--功能：导航滑动框动作
--参数：1、self			窗口对象
--		2、eventType	事件类型
--		3、args			参数
--		4、msgId		信息ID
--返回：无
--作者：陈亮
--时间：2014.08.27
local function direct_scroll_action(self,eventType,args,msgId)
	if eventType == nil or args == nil or msgId == nil then 
        return false
    end

    if eventType == SCROLL_CREATE_ITEM then
        -- 计算创建的 序列号
        local temparg = Utils:Split_old(args,":")
        local x = temparg[1]              -- 行
        local y = temparg[2]              -- 列
        local t_itemIndex = x + 1

        --创建每行子行
        local t_itemView = create_scroll_item(self,t_itemIndex)
        -- print("第%d个插入",t_itemIndex)
		self._directlyScroll:addItem(t_itemView.view)
        self._directlyScroll:refresh()

        return false
    end
end


--功能：创建通用活动窗口对象时的初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.27
function CommonActivityBaseWin:__init()
	--声明成员变量
	create_self_params(self)
    
    --页面底板
    local bg_layout = CommonActivityBaseWinLayout.panel_bg_img
    ZImage:create(self.view, bg_layout.path, bg_layout.x, bg_layout.y, bg_layout.width, bg_layout.height, 0, 500, 500)
    --标题底框
    -- local layout = CommonActivityBaseWinLayout.titleDk
    -- ZImage:create(self.view, layout.path, layout.x, layout.y, layout.width, layout.height, 0, 500, 500)
	--创建左侧子活动导航背景图
	local t_directlyBgLayout = CommonActivityBaseWinLayout.directlyBg
	local t_directlyBg = ZBasePanel:create(self.view,t_directlyBgLayout.path,t_directlyBgLayout.x,t_directlyBgLayout.y,t_directlyBgLayout.width,t_directlyBgLayout.height,0,500,500)

	--创建左侧子活动导航滑动框
	local t_directlyScrollLayout = CommonActivityBaseWinLayout.directlyScroll
	local t_directlyScroll =CCScroll:scrollWithFile(t_directlyScrollLayout.x,t_directlyScrollLayout.y,t_directlyScrollLayout.width,t_directlyScrollLayout.height,0,"",TYPE_HORIZONTAL)
	self._directlyScroll = t_directlyScroll

	--为了实现选中  不能使用单个滑动创建的方法
	t_directlyScroll:registerScriptHandler(bind(direct_scroll_action,self))
	t_directlyScroll:refresh()
    t_directlyBg.view:addChild(t_directlyScroll)
    

    -- local btn_num = 9
    -- --改用单选按钮组来实现
    -- local raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(0 ,0, 226, (92+4) * btn_num, nil)
    
    -- print("总数",#self._pageClassGroup)
    -- self.btn_sld = {}
    -- for itemIndex=1,btn_num do

    -- 	    local function selected_change(  )
			 --        scroll_item_click(self,item,itemIndex,eventType);   
			 --        return true;
   	-- 		 end 

    --  local act_button = self:create_a_button(0, 96 * (btn_num-itemIndex)+4, 215, 94, UILH_COMMON.bg_10, UILH_COMMON.bg_10, itemIndex, selected_change)
    --  raido_btn_group:addGroup(act_button)

    -- end

    -- self._directlyScroll:addItem(raido_btn_group)
    -- self._directlyScroll:refresh(  )
    -- t_directlyBg.view:addChild(t_directlyScroll)

    --左边的灯笼
    -- local layout = CommonActivityBaseWinLayout.leftLantern
    -- ZImage:create(self.view, layout.path, layout.x, layout.y, layout.width, layout.height, 0, 500, 500)
    --右边的灯笼
    -- local layout = CommonActivityBaseWinLayout.rightLantern
    -- local rightLanternImg = ZImage:create(nil, layout.path, layout.x, layout.y, layout.width, layout.height, 0, 500, 500)
    -- rightLanternImg.view:runAction(CCOrbitCamera:actionWithDuration(0, 1, 0, 0, 180, 0, 0));
    -- self.view:addChild(rightLanternImg.view, 5)
end


function CommonActivityBaseWin:create_a_button(pos_x, pos_y, size_w, size_h, image_n, image_s, index, fn)


    for i=1,#self._directlyDataGroup do
    	print("self._directlyDataGroup[index]",self._directlyDataGroup[i])
    end
    		--解析子项导航数据
	local t_directlyData = self._directlyDataGroup[index]

	-- --创建视图背景
	-- local t_viewBgLayout = CommonActivityBaseWinLayout.viewBg
	-- local t_viewBg = ZBasePanel:create(nil,t_viewBgLayout.path,t_viewBgLayout.x,t_viewBgLayout.y,t_viewBgLayout.width,t_viewBgLayout.height,0,500,500)
	-- t_viewBg.view:registerScriptHandler(bind(scroll_item_view_action,self,itemIndex))


	-- --创建子行背景
	-- local t_itemBgLayout = CommonActivityBaseWinLayout.itemBg
	-- local t_itemBg = CCBasePanel:panelWithFile(t_itemBgLayout.x,t_itemBgLayout.y,t_itemBgLayout.width,t_itemBgLayout.height,t_itemBgLayout.path,500,500)
	-- t_viewBg.view:addChild(t_itemBg)



 --    local main_title_img =MUtils:create_zximg(t_viewBg,t_directlyData.txtPath, 97, 25, -1, -1);
	-- --注册子行背景点击事件
	-- -- t_itemBg:registerScriptHandler(bind(scroll_item_click,self,item,itemIndex))
	-- --暂时屏蔽 避免子页面在修改时麻烦
    
	-- --如果当前创建的索引等于当前索引，使图标表现动态,使按钮呈现高亮状态，保存选中图标
 --    if itemIndex == self._currentIndex then
 --       	-- SlotEffectManager.play_effect_by_slot_item(item)
 --       	-- self._selectActivitySlot = item
 --       -- t_viewBg.select_frame:setIsVisible(true)

 --    end


    local one_btn = CCBasePanel:panelWithFile(pos_x, pos_y, size_w, size_h, image_n, 500, 500)
    -- one_btn:addTexWithFile(CLICK_STATE_DISABLE, image_s)
    self.btn_sld[index] = CCBasePanel:panelWithFile(0, 0, size_w, size_h, UILH_COMMON.select_focus, 500, 500)
    one_btn:addChild(self.btn_sld[index])
    self.btn_sld[index]:setIsVisible(false)

    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN  then 
            return true
        elseif eventType == TOUCH_CLICK then
            fn()
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        end
    end
    one_btn:registerScriptHandler(but_1_fun)    --注册


    local function on_slot_click_fun()
        fn();
    end


	-- --创建子活动图标
	local t_activitySlotLayout = CommonActivityBaseWinLayout.activitySlot
   
    local item = MUtils:create_slot_item2(one_btn,t_activitySlotLayout.bgPath,t_activitySlotLayout.x,t_activitySlotLayout.y,t_activitySlotLayout.width,t_activitySlotLayout.height,nil,nil,9.5);
    item:set_icon_texture( t_directlyData.iconPath,  -8, -8, 80, 80 )
    --选中框
    -- t_viewBg.select_frame = MUtils:create_zximg(t_viewBg,UILH_COMMON.select_focus2, -2, -5, 223, 103);
    -- t_viewBg.select_frame:setIsVisible(false)


    item:set_click_event(on_slot_click_fun);

  local main_title_img =MUtils:create_zximg(t_viewBg,t_directlyData.txtPath, 97, 25, -1, -1);

    -- local slot_item = MUtils:create_one_slotItem_align( nil, 27, 16, 60, 60, 8 );
       -- local item = MUtils:create_slot_item2(t_viewBg,t_activitySlotLayout.bgPath,t_activitySlotLayout.x,t_activitySlotLayout.y,t_activitySlotLayout.width,t_activitySlotLayout.height,nil,nil,9.5);
    -- item:set_icon_texture( t_directlyData.iconPath,  -8, -8, 80, 80 )

    -- slot_item:set_icon_texture(icon_img)
    -- slot_item:set_select_effect_state(false)
    -- slot_item:set_click_event( on_slot_click_fun )
    -- one_btn:addChild(slot_item.view)

    -- 按钮标题
    -- local title_img = OpenSerConfig:get_activity_img_title( index )
    -- local title = ZImage.new( UILH_OPENSER.tips_path .. index .. ".png")
    -- title:setPosition(100, 25)
    -- one_btn:addChild(title.view)

    -- 获取主副标题
    -- local title_up, title_down = OpenSerConfig:get_activity_title( index )
    return one_btn
end


--功能：通用活动窗口对象的析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.27
function CommonActivityBaseWin:destroy()
	--销毁所有页面
	local t_pageClassCount = #self._pageClassGroup
	--遍历所有页面，如果存在，销毁页面
	for t_index = 1,t_pageClassCount do
		local t_page = self._pageGroup[t_index]
		if t_page then
			t_page:destroy()
		end
	end
    self.slot_item_array = {}
	--销毁父类
	Window.destroy(self)
end

--功能：窗口是否显示
--参数：1、status	窗口状态
--返回：无
--作者：陈亮
--时间：2014.08.27
function CommonActivityBaseWin:active(status)
	--打开窗口
	if status then
		self:showWinAction()
        
        
		--如果当前选中图标存在,设置图标动作
		if self._selectActivitySlot then
			-- SlotEffectManager.play_effect_by_slot_item(self._selectActivitySlot.view)
		end
		--如果存在当前页，显示出来
		if self._currentPage then
			self._currentPage:showPage()
		end
	--关闭窗口
	else
		self:hideWinAction()

		SlotEffectManager.stop_current_effect()
		--如果存在当前页，隐藏出来
		if self._currentPage then
			self._currentPage:hidePage()
		end
	end
end

--功能：设置导航子活动数据组
--参数：1、dataGroup	导航子活动数据组
--返回：无
--作者：陈亮
--时间：2014.08.28
function CommonActivityBaseWin:setDataGroup(dataGroup)
	self._directlyDataGroup = dataGroup
end

--功能：重置导航滑动框的内容
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function CommonActivityBaseWin:resetDirectlyScroll()
	local t_directlyScrollCount = #self._directlyDataGroup
	self._directlyScroll:clear()
	self.slot_item_array = {}
	self._directlyScroll:setMaxNum(1)
	self._directlyScroll:refresh()
end

--功能：在初始化窗口的时候初始化页面
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function CommonActivityBaseWin:initWindow()
	--初始化为第一页
    change_page(self,_INIT_INDEX)
end

--功能：设置页面标题
--参数：1、titleImagePath	页面标题路径
--		2、titleImageSize	图标大小
--返回：无
--作者：陈亮
--时间：2014.08.28
function CommonActivityBaseWin:setPageTitle(titleImagePath,titleImageSize)
	self._currentPage:setTitleImagePath(titleImagePath,titleImageSize)
end

function CommonActivityBaseWin:setPageTitle_1(titleImagePath,titleImageSize)
	self._currentPage:setTitleImagePath_1(titleImagePath,titleImageSize)
end

--功能：初始化完成，设置初始化标识为false，不需要继续初始化
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function CommonActivityBaseWin:initFinished()
	self._isInit = false
end

--功能：页面完成初始化
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.28
function CommonActivityBaseWin:pageInitFinish()
	self._currentPage:initFinished()
end

--功能：获取当前页面的页面类型
--参数：无
--返回：1、t_pageType	当前页面的页面类型
--作者：陈亮
--时间：2014.08.28
function CommonActivityBaseWin:getCurrentPageType()
	local t_pageType = self._currentPage:getPageType()
	return t_pageType
end

----------------------------------------------------------------------
--
--继承NormalInfoPage的通用页面调用函数
--
----------------------------------------------------------------------
--功能：设置活动时间
--参数：1、time		活动时间
--返回：无
--作者：陈亮
--时间：2014.08.30
function CommonActivityBaseWin:setActivityTime(time)
	self._currentPage:setActivityTime(time)
end

--功能：设置活动说明
--参数：1、describe		活动说明
--返回：无
--作者：陈亮
--时间：2014.08.30
function CommonActivityBaseWin:setActivityDescribe(describe)
	self._currentPage:setActivityDescribe(describe)
end


--功能：设置活动剩余时间
--参数：1、remainTime	剩余时间
--		2、isTimeOut	是否没有剩余时间
--返回：无
--作者：陈亮
--时间：2014.08.29
function CommonActivityBaseWin:setActivityRemainTime(remainTime,isTimeOut)
	if isTimeOut then
		self._currentPage:remainTimeOut()
	else
		self._currentPage:setRemainTime(remainTime)
	end
end

--功能：设置活动剩余时间
--参数：1、remainTime	剩余时间
--		2、isTimeOut	是否没有剩余时间
--返回：无
--作者：chj
--时间：2014.08.29
function CommonActivityBaseWin:setActivityTitlePageEx( title_page )
	if title_page then
		self._currentPage:setTitlePageEx(title_page)
	end
end

----------------------------------------------------------------------
--
--副本活动或者BOSS活动的页面，可以传送和可以前往的页面调用函数
--
----------------------------------------------------------------------
--功能：刷新副本活动或者BOSS活动的奖励视图
--参数：1、awardDataGroup	奖励数据组
--返回：无
--作者：陈亮
--时间：2014.08.29
function CommonActivityBaseWin:refreshMovePlacePageAward(awardDataGroup)
	self._currentPage:createAwardGroupView(awardDataGroup)
end

----------------------------------------------------------------------
--
--重复获取活动的页面调用函数
--
----------------------------------------------------------------------
--功能：刷新重复获取活动的奖励视图
--参数：1、awardDataGroup	奖励数据组
--返回：无
--作者：陈亮
--时间：2014.08.29
function CommonActivityBaseWin:refreshRepeatGainPageAward(awardDataGroup)
	self._currentPage:createAwardGroupView(awardDataGroup)
end

--功能：设置全部按钮可以点击
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
function CommonActivityBaseWin:setAllButtonClick()
	self._currentPage:clickedGainAllAwardButton()
	self._currentPage:clickedGainAwardButton()
end

--功能：设置全部按钮不可以点击
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.29
function CommonActivityBaseWin:setAllButtonUnclick()
	self._currentPage:unclickedGainAllAwardButton()
	self._currentPage:unclickedGainAwardButton()
end

--功能：设置可领取数量
--参数：1、count	可领取数量
--返回：无
--作者：陈亮
--时间：2014.08.29
function CommonActivityBaseWin:setGainAwardCount(count)
	self._currentPage:setGainAwardCount(count)
end

----------------------------------------------------------------------
--
--超级团购活动的页面调用函数
--
----------------------------------------------------------------------
--功能：设置团购活动页面的基础信息
--参数：1、awardTitleGroup	奖励标题组
--		2、awardDataGroup	奖励数据组
--返回：无
--作者：肖进超
--修改：陈亮
--时间：2014.09.18
function CommonActivityBaseWin:setGroupBuyPageBaseInfo(itemTitleGroup,awardDataGroup)
	--设置滑动框的标题组、奖励数据组、获取状态组
	-- self._currentPage:setItemTitleGroup(itemTitleGroup)
	-- self._currentPage:setAwardDataGroup(awardDataGroup)
	-- --重置滑动框
	-- self._currentPage:resetScroll()
end

----------------------------------------------------------------------
--
--兑换活动活动的页面调用函数
--
----------------------------------------------------------------------
--功能：设置兑换活动页面的奖励基础信息
--参数：1、awardTitleGroup	奖励标题组
--		2、awardDataGroup	奖励数据组
--返回：无
--作者：陈亮
--时间：2014.09.23
function CommonActivityBaseWin:setExchangeAwardBaseInfo(awardTitleGroup,awardDataGroup)
	--设置设置标题
	self._currentPage:setItemTitleGroup(awardTitleGroup)
	--设置这是奖励组
	self._currentPage:setAwardDataGroup(awardDataGroup)
end

--功能：设置兑换活动页面的状态基础信息
--参数：1、exchangeStatusGroup	兑换状态组
--		2、exchangeTitleGroup	兑换标题组
--		3、exchangeContentGroup	兑换内容组
--返回：无
--作者：陈亮
--时间：2014.09.23
function CommonActivityBaseWin:setExchangeStatusBaseInfo(exchangeStatusGroup,exchangeTitleGroup,exchangeContentGroup)
	--设置兑换状态组
	self._currentPage:setExchangeStatusGroup(exchangeStatusGroup)
	--设置兑换标题组
	self._currentPage:setExchangeTitleGroup(exchangeTitleGroup)
	--设置兑换内容组
	self._currentPage:setExchangeContentGroup(exchangeContentGroup)
end

--功能：设置兑换活动页面的奖励基础信息
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.23
function CommonActivityBaseWin:resetExchangeScroll()
	--重置兑换滑动框
	self._currentPage:resetScroll()
end

--功能：刷新兑换状态
--参数：1、cur_item_num	当前所需道具数量
--		2、exchangeContentGroup	兑换内容组
--返回：无
--作者：陈亮
--时间：2014.09.23
function CommonActivityBaseWin:refreshExchangeStatus(cur_item_num,exchangeContentGroup)
	--设置兑换状态组并刷新
	self._currentPage:setExchangeStatusGroup(cur_item_num)
	-- self._currentPage:flushAllExchangeStatus()
	--设置兑换内容组并刷新
	self._currentPage:setExchangeContentGroup(exchangeContentGroup)
	self._currentPage:flushAllExchangeContent()
end

--功能：设置兑换活动页面的奖励基础信息
--参数：无
--返回：无
--作者：陈亮
--时间：2014.09.23
function CommonActivityBaseWin:resetExchangeScroll()
	--重置兑换滑动框
	self._currentPage:resetScroll()
end

----------------------------------------------------------------------
--
--获取奖励活动的页面调用函数
--
----------------------------------------------------------------------
--功能：重置获取奖励页面的信息数据
--参数：1、itemTitleGroup	标题组
--		2、awardDataGroup	奖励数据组
--		3、gainStatusGroup	获取状态组
--返回：无
--作者：陈亮
--时间：2014.09.22
function CommonActivityBaseWin:resetGainAwardInfoData(itemTitleGroup,awardDataGroup,gainStatusGroup)
	--设置滑动框的标题组、奖励数据组、获取状态组
	self._currentPage:setItemTitleGroup(itemTitleGroup)
	self._currentPage:setAwardDataGroup(awardDataGroup)
	self._currentPage:setGainStatusGroup(gainStatusGroup)
	--重置滑动框
	self._currentPage:resetScroll()
end

--功能：刷新获取状态
--参数：1、gainStatusGroup	获取状态组
--返回：无
--作者：陈亮
--时间：2014.09.22
function CommonActivityBaseWin:refreshGainAwardStatus(gainStatusGroup)
	self._currentPage:setGainStatusGroup(gainStatusGroup)
	self._currentPage:flushAllGainStatus()
end

--功能：累计消费页面刷新玩家消费元宝数
--参数：1、yuanbao          玩家消费元宝数
--返回：无
--作者：肖进超
--时间：2014.12.25
function CommonActivityBaseWin:refreshConsumeYuanbao(yuanbao)
    self._currentPage:setConsumeYuanbao(yuanbao)
end


function CommonActivityBaseWin:refreshChongzhiYuanbao(yuanbao)
    self._currentPage:setChongzhiYuanbao(yuanbao)
end


----------------------------------------------------------------------
--
--排行榜活动的页面调用函数
--
----------------------------------------------------------------------
--功能：设置排行榜页面的排行信息数据
--参数：1、itemTitleGroup	标题组
--		2、awardDataGroup	奖励数据组
--		3、gainStatusGroup	获取状态组
--返回：无
--作者：陈亮
--时间：2014.10.27
function CommonActivityBaseWin:setQueueInfoData(itemTitleGroup,awardDataGroup)
	--设置滑动框的标题组、奖励数据组
	self._currentPage:setItemTitleGroup(itemTitleGroup)
	self._currentPage:setAwardDataGroup(awardDataGroup)
	--重置滑动框
	self._currentPage:resetScroll()
end

----------------------------------------------------------------------
--
--消费排行活动的页面调用函数
--
----------------------------------------------------------------------
--功能：重置消费排行页面的排行信息数据
--参数：1、awardDataGroup	奖励数据组
--		2、roleNameGroup	角色名字组
--		2、consumeGoldGroup	消费元宝组
--返回：无
--作者：陈亮
--时间：2014.10.31
function CommonActivityBaseWin:resetConsumeQueueInfo(awardDataGroup,roleNameGroup,consumeGoldGroup)
	--设置奖励数据组
	self._currentPage:setAwardDataGroup(awardDataGroup)
	--设置角色名字组
	self._currentPage:setScrollRoleName(roleNameGroup)
	--设置消费元宝组
	self._currentPage:setScrollConsuemGold(consumeGoldGroup)
	--重置滑动框
	self._currentPage:resetScroll()
end

--功能：设置消费排行的角色名字组
--参数：1、count			上榜角色数量
--		2、roleNameGroup	角色名字组
--		3、consumeGoldGroup	消费元宝组
--返回：无
--作者：陈亮
--时间：2014.10.31
function CommonActivityBaseWin:refreshConsumeQueueInfo(count,roleNameGroup,consumeGoldGroup)
	--刷新角色名字组
	self._currentPage:refreshScrollRoleName(count,roleNameGroup)
	--刷新消费元宝组
	self._currentPage:refreshScrollConsuemGold(count,consumeGoldGroup)
end

--功能：设置我的消费排行信息
--参数：1、myQueue			我的排名
--		2、myConsumeGold	我的消费元宝
--返回：无
--作者：陈亮
--时间：2014.10.31
function CommonActivityBaseWin:setMyQueueInfo(myQueue,myConsumeGold)
	--设置我的排名
	self._currentPage:setMyQueue(myQueue)
	--设置我的消费元宝
	self._currentPage:setMyConsumeGold(myConsumeGold)
end

----------------------------------------------------------------------
--
--跳转活动的页面调用函数
--
----------------------------------------------------------------------
--功能：刷新跳转活动的页面奖励视图
--参数：1、awardDataGroup	奖励数据组
--返回：无
--作者：陈亮
--时间：2014.09.22
function CommonActivityBaseWin:refreshGotoActivityPageAward(awardDataGroup)
	self._currentPage:createAwardGroupView(awardDataGroup)
end

----------------------------------------------------------------------
--以下函数需要子类进行重写
----------------------------------------------------------------------
--功能：显示窗口时候的行为
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.27
function CommonActivityBaseWin:showWinAction()

end

--功能：关闭窗口时候的行为
--参数：无
--返回：无
--作者：陈亮
--时间：2014.08.27
function CommonActivityBaseWin:hideWinAction()

end