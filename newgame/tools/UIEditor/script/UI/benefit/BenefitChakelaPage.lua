super_class.BenefitChakelaPage()
--天降雄狮中不用
-- 查克拉领取按钮皮肤
local image = {UIPIC_COMMOM_002, UIPIC_COMMOM_002}

-- 下一个可领取时间图片
local next_time_tips = {UIPIC_Benefit_028, UIPIC_Benefit_029, UIPIC_Benefit_030, UIPIC_Benefit_031}

-- 跑马灯提示信息
local function create_screen_notic(str)
	local winSize = ZXgetWinSize()
	local width   = winSize.width or 0
	local height  = winSize.height or 0
	if width > 0 and height > 0 then
		GlobalFunc:create_screen_notic( str, 14, width/2, height/2, 5)
	end
end

-- 免费领取按钮区创建
function BenefitChakelaPage:create_free_btn_area(panel)
	-- 免费领取按钮点击回调函数
	local function OnFreeBtnClicked()
		local curStage = LinggenModel:getCurLingqiStage()
		local curState = LinggenModel:getCurLingqiState()
		local is_get   = 0

		if curStage ~= 0 then
			is_get = Utils:get_bit_by_position(curState, curStage)
		end
		-- 如果当前不在可领取时间段,或者当前在领取时间段,但是已经领取
		if curStage == 0 or  is_get == 1 then
			local str
			if curStage == 0 then
				str = LangGameString[2482] or "亲,现在不是领取时间!"
			else
				str = LangGameString[2483] or "亲,您已领取过奖励,请下次再来吧~"
			end

			create_screen_notic(str)
			return
		end

		-- 向服务器发请求,请求领取灵气奖励
		local award_type = 1
		LingGenCC:request_lingqi_reward( curStage, award_type )
	end

	-- 免费领取标题
	local freeGetTitleBg = ZImage:create(panel, UIPIC_Benefit_008, 0, 240, -1, -1)
	ZImage:create(freeGetTitleBg, UIPIC_Benefit_033, 23, 3, -1, -1)

	-- 免费领取斜标签
	local freeContentImg = ZImage:create(panel, UIPIC_Benefit_025, 109, 126, -1, -1)
	freeContentImg.view:setAnchorPoint(0.5, 0)

	-- 获得多少查克拉("#cfff000获得：#c0edc0912345678查克拉")
	self.free_chakela_lab = ZLabel:create(panel, "", 23, 98, 14)

	-- VIP加成百分比("#c0096ffVIP加成：50%")
	self.free_vip_lab	  = ZLabel:create(panel, "", 74, 72, 14)
	
	-- 免费领取按钮
	self.freeGetBtn = ZButton:create(panel, image, OnFreeBtnClicked, 109, 7, -1, -1)
	self.freeGetBtn.view:setAnchorPoint(0.5, 0)
	self.freeGetBtn.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_003)
	-- 按钮上的文字
	ZLabel:create(self.freeGetBtn, "领 取", 63, 21, 16, ALIGN_CENTER)
end

-- 豪华领取按钮区域创建
function BenefitChakelaPage:create_haohua_btn_area(panel)
	-- 豪华领取按钮点击回调函数
	local function OnHaohuaBtnClicked()
		local curStage = LinggenModel:getCurLingqiStage()
		local curState = LinggenModel:getCurLingqiState()
		local is_get   = 0

		-- 是否可以向服务器发起请求获取灵气奖励
		local is_can_req = true
		-- 错误提示字符串
		local err_string = ""

		if curStage == 0 then
			err_string = LangGameString[2482] or "亲,现在不是领取时间!"
			is_can_req = false
		else
			is_get = Utils:get_bit_by_position(curState, curStage)
			if is_get == 1 then
				err_string = LangGameString[2483] or "亲,您已领取过奖励,请下次再来吧~"
				is_can_req = false
			else
				local count = ItemModel:get_item_count_by_id(self.zjldd_item_id)
				if count == 0 then
					err_string = LangGameString[2484] or "您没有龙地丹!"
					is_can_req = false
				end
			end
		end

		if is_can_req == false then
			create_screen_notic(err_string)
			return
		end

		-- 向服务器发请求,请求领取灵气奖励
		local award_type = 2
		LingGenCC:request_lingqi_reward( curStage, award_type )
	end

	-- 豪华领取标题
	local haohuaGetTitleBg = ZImage:create(panel, UIPIC_Benefit_008, 218, 240, -1, -1)
	ZImage:create(haohuaGetTitleBg, UIPIC_Benefit_026, 23, 3, -1, -1)

	-- 消耗龙地丹提示
	local str = "#cfff000消耗：#c0096ff中级龙地丹*1"
	local use_zjldd_lab = ZLabel:create(panel, str, 327, 206, 14, ALIGN_CENTER)

	-- "#cfff000获得：#c0edc09123456查克拉"
	self.haohua_chakela_lab = ZLabel:create(panel, "", 241, 98, 14)

	-- VIP加成百分比("#c0096ffVIP加成：50%")
	self.haohua_vip_lab	    = ZLabel:create(panel, "", 292, 72, 14)

	-- 豪华领取按钮
	self.haohuaGetBtn = ZButton:create(panel, image, OnHaohuaBtnClicked, 327, 7, -1, -1)
	self.haohuaGetBtn.view:setAnchorPoint(0.5, 0)
	self.haohuaGetBtn.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_003)
	ZLabel:create(self.haohuaGetBtn, "领 取", 63, 21, 16, ALIGN_CENTER)
end

-- 至尊领取按钮区域创建
function BenefitChakelaPage:create_zhizun_btn_area(panel)
	-- 至尊领取按钮点击回调函数
	local function OnZhizunBtnClicked()
		local curStage = LinggenModel:getCurLingqiStage()
		local curState = LinggenModel:getCurLingqiState()
		local is_get   = 0

		-- 是否可以向服务器发起请求获取灵气奖励
		local is_can_req = true
		-- 错误提示字符串
		local err_string = ""

		if curStage == 0 then
			err_string = LangGameString[2482] or "亲,现在不是领取时间!"
			is_can_req = false
		else
			is_get = Utils:get_bit_by_position(curState, curStage)
			if is_get == 1 then
				err_string = LangGameString[2483] or "亲,您已领取过奖励,请下次再来吧~"
				is_can_req = false
			else
				local count = ItemModel:get_item_count_by_id(self.gjldd_item_id)
				if count == 0 then
					err_string = LangGameString[2484] or "您没有龙地丹!"
					is_can_req = false
				end
			end
		end

		if is_can_req == false then
			create_screen_notic(err_string)
			return
		end

		-- 向服务器发请求,请求领取灵气奖励
		local award_type = 3
		LingGenCC:request_lingqi_reward( curStage, award_type )
	end

	-- 至尊领取标题
	local zhizunGetTitleBg = ZImage:create(panel, UIPIC_Benefit_008, 436, 240, -1, -1)
	ZImage:create(zhizunGetTitleBg, UIPIC_Benefit_036, 23, 3, -1, -1)

	-- 消耗高级龙地丹*1
	local str = "#cfff000消耗：#c0096ff高级龙地丹*1"
	ZLabel:create(panel, str, 545, 206, 14, ALIGN_CENTER)

	-- 获得多少查克拉("#cfff000获得：#c0edc09123456查克拉")
	self.zhizun_chakela_lab= ZLabel:create(panel, "", 459, 98, 14)

	-- VIP加成百分比("#c0096ffVIP加成：50%")
	self.zhizun_vip_lab	   = ZLabel:create(panel, "", 510, 72, 14)

	-- 至尊领取按钮
	self.zhizunGetBtn = ZButton:create(panel, image, OnZhizunBtnClicked, 545, 7, -1, -1)
	self.zhizunGetBtn.view:setAnchorPoint(0.5, 0)
	self.zhizunGetBtn.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_003)
	ZLabel:create(self.zhizunGetBtn, "领 取", 63, 21, 16, ALIGN_CENTER)
end

-- 创建右上区域
function BenefitChakelaPage:create_right_top_area(panel)
	-- 左边花纹、右边花纹
	local huawen_left = ZImage:create(panel, UIPIC_Benefit_027, 0, 448, -1, -1)
	local huawen_right= ZImage:create(panel, UIPIC_Benefit_027, 511, 448, -1, -1)
	huawen_right.view:setFlipX(true)

	-- 特效背景图(一个圆圈)
	local quanquan_bg = ZImage:create(panel, UIPIC_Benefit_034, 327, 318, -1, -1)
	quanquan_bg.view:setAnchorPoint(0.5,0)

	-- "下次领取时间提示"
	local tips_bg = ZImage:create(panel, UIPIC_Benefit_037, 327, 335, -1, -1)
	tips_bg.view:setAnchorPoint(0.5,0)
	self.next_time_img = ZImage:create(tips_bg, UIPIC_Benefit_028, 137, 15, -1, -1)
	self.next_time_img.view:setAnchorPoint(0.5, 0.5)

	-- "任选一种方式领取查克拉"
	local lingqu_title_bg = ZImage:create(panel, UIPIC_Benefit_035, 327, 274, -1, -1)
	lingqu_title_bg.view:setAnchorPoint(0.5, 0)
	local lingqu_title    = ZImage:create(lingqu_title_bg, UIPIC_Benefit_032, 325, 17, -1, -1)
	lingqu_title.view:setAnchorPoint(0.5, 0.5)
end

function BenefitChakelaPage:__init(x, y)
	local pos_x = x or 0
    local pos_y = y or 0
	self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 662, 540, nil, 500, 500 )
	local panel = CCBasePanel:panelWithFile( 0, 0, 655, 537, UIPIC_Benefit_003, 500, 500 )
	self.view:addChild( panel )

	-- 创建右上区域
	self:create_right_top_area(panel)
	-- 免费领取按钮区域
	self:create_free_btn_area(panel)
	-- 豪华领取按钮区域
	self:create_haohua_btn_area(panel)
	-- 至尊领取按钮区域
	self:create_zhizun_btn_area(panel)

	-- 免费领取与豪华领取之间的分割线
	local fenge_line1= ZImage:create(panel, UIPIC_Benefit_024, 216, 273, 273, -1)
	fenge_line1.view:setRotation(90)
	-- 豪华领取与至尊领取之间的分割线
	local fenge_line2  = ZImage:create(panel, UIPIC_Benefit_024, 434, 273, 273, -1)
	fenge_line2.view:setRotation(90)

	-- 龙地丹物品孔槽
	self.item_tab = {}
	-- 创建物品槽
	self.zjldd_item_id = LingQiLingQuConfig:get_item_id_by_index(2)
	self.gjldd_item_id = LingQiLingQuConfig:get_item_id_by_index(3)
	self.item_tab[1] = self:create_slot_item(panel, 297, 125, self.zjldd_item_id)
	self.item_tab[2] = self:create_slot_item(panel, 515, 125, self.gjldd_item_id)

	-- 两个获得按钮
	local function get_longdidan_func()
		-- 检查梦境系统是否已开启,如果已开启,则打开梦境窗口,切换到月华梦境页
		if GameSysModel:isSysEnabled(GameSysModel.LOTTERY, false) then
			local mengjingWin = UIManager:show_window("new_dreamland_win")
	        if mengjingWin then
	        	mengjingWin:change_dreamlandType(DreamlandModel.DREAMLAND_TYPE_YH)
	        	UIManager:hide_window("benefit_win")
	        end
	    else
	        local str = LangGameString[2481] or "尚未开启梦境系统！"
			create_screen_notic(str)
	    end
	end
	local get_zjldd_btn = ZButton:create(panel, UIPIC_COMMOM_001, get_longdidan_func, 335, 130, -1, -1)
	local get_gjldd_btn = ZButton:create(panel, UIPIC_COMMOM_001, get_longdidan_func, 553, 130, -1, -1)
	ZLabel:create(get_zjldd_btn, "获 得", 48, 21, 16, ALIGN_CENTER)
	ZLabel:create(get_gjldd_btn, "获 得", 48, 21, 16, ALIGN_CENTER)

	self.panel = panel
end

function BenefitChakelaPage:update()
	-- 计算VIP加成百分比
	local vipInfo  = VIPModel:get_vip_info()
	if vipInfo and vipInfo.level > 0 then
		local addtion = vipInfo.level * 10
		local desStr  = string.format("#c0096ffVIP加成：%d%%",addtion)
		self.free_vip_lab:setText(desStr)
		self.haohua_vip_lab:setText(desStr)
		self.zhizun_vip_lab:setText(desStr)
		-- 调整坐标
		self.free_chakela_lab.view:setPosition(23, 98)
		self.haohua_chakela_lab.view:setPosition(241, 98)
		self.zhizun_chakela_lab.view:setPosition(459, 98)
	else
		self.free_vip_lab:setText("")
		self.haohua_vip_lab:setText("")
		self.zhizun_vip_lab:setText("")
		self.free_chakela_lab.view:setPosition(23, 87)
		self.haohua_chakela_lab.view:setPosition(241, 87)
		self.zhizun_chakela_lab.view:setPosition(459, 87)
	end

	-- 计算可领取多少查克拉(根据当前的VIP等级、领取倍数,计算加成)
	-- 查克拉数量＝基础值*领取方式倍数*[1＋（vip等级*10%）]
	local vipAddCkl = 1
	local baseCkl   = LingQiLingQuConfig:getBaseChakelaNum() or 0
	if vipInfo then
		vipAddCkl = vipAddCkl + vipInfo.level * 0.1
	end
	self.free_chakela_lab:setText(string.format("#cfff000获得：#c0edc09%d查克拉",baseCkl * vipAddCkl))
	self.haohua_chakela_lab:setText(string.format("#cfff000获得：#c0edc09%d查克拉",baseCkl * 1.3 * vipAddCkl))
	self.zhizun_chakela_lab:setText(string.format("#cfff000获得：#c0edc09%d查克拉",baseCkl * 1.5 * vipAddCkl))

	-- 更新下次领取时间提示
	self:updateStageInfo()
end

function BenefitChakelaPage:destroy()
	-- body
end

function BenefitChakelaPage:create_slot_item(parent, x, y, item_id)
	local slot_item = SlotItem(64, 64)
	slot_item:set_icon_bg_texture( UIPIC_ITEMSLOT, -2, -2, 68, 68 )
    slot_item:setPosition( x, y )
    slot_item.view:setAnchorPoint(0.5, 0)

    if item_id then
    	slot_item:set_icon( item_id )
    	slot_item.item_id = item_id;
    	slot_item:set_color_frame( item_id, -2, -2, 68, 68 )
    	-- 更新物品数量
    	local count = ItemModel:get_item_count_by_id( item_id )
    	slot_item:set_item_count(count)
    	if count > 0 then
 			slot_item:set_icon_light_color()
 		else
 			slot_item:set_icon_dead_color()
 		end
    end

    if parent then
    	parent:addChild(slot_item.view)
    end

    return slot_item
end

function BenefitChakelaPage:play_bottle_effect(effect_id)
	if self.effect_id then
		LuaEffectManager:stop_view_effect( self.effect_id, self.panel )
		self.effect_id = nil
	end

	self.effect_id = effect_id
	LuaEffectManager:play_view_effect( self.effect_id, 330, 435, self.panel, true, 5 )
end

function BenefitChakelaPage:updateStageInfo()
	local curStage = LinggenModel:getCurLingqiStage()
	local nextStage= LinggenModel:getNextLingqiStage()
	local state    = LinggenModel:getCurLingqiState()
	local can_get  = false

	-- 如果当前时间处于领取时间段的某一段中
	if curStage ~= 0 then
		-- 是否已领取
		local is_get = Utils:get_bit_by_position(state, curStage)
		if is_get == 1 then
			self.next_time_img:setTexture(next_time_tips[curStage+1])
			-- 当前时间为可领取时间,且已领取,播放半瓶特效
			self:play_bottle_effect(414)
		else
			self.next_time_img:setTexture(UIPIC_Benefit_038)
			-- 当前有可领取的灵气未领取,播放满瓶特效
			self:play_bottle_effect(415)
			can_get = true
		end
	else
		self.next_time_img:setTexture(next_time_tips[nextStage])
		-- 当前时间不在领取时间段,播放半瓶特效
		self:play_bottle_effect(414)
	end

	-- 更新中级龙地丹数量
	local count1 = ItemModel:get_item_count_by_id(self.zjldd_item_id)
	local count2 = ItemModel:get_item_count_by_id(self.gjldd_item_id)

	self.item_tab[1]:set_item_count(count1)
	if count1 > 0 then
		self.item_tab[1]:set_icon_light_color()
	else
		self.item_tab[1]:set_icon_dead_color()
	end

	-- 更新高级龙地丹数量
	self.item_tab[2]:set_item_count(count2)
	if count2 > 0 then
		self.item_tab[2]:set_icon_light_color()
	else
		self.item_tab[2]:set_icon_dead_color()
	end

	-- 设置按钮的状态
	if can_get then
		self.freeGetBtn.view:setCurState(CLICK_STATE_UP)
		self.haohuaGetBtn.view:setCurState(CLICK_STATE_UP)
		self.zhizunGetBtn.view:setCurState(CLICK_STATE_UP)
	else
		self.freeGetBtn.view:setCurState(CLICK_STATE_DISABLE)
		self.haohuaGetBtn.view:setCurState(CLICK_STATE_DISABLE)
		self.zhizunGetBtn.view:setCurState(CLICK_STATE_DISABLE)
	end
end