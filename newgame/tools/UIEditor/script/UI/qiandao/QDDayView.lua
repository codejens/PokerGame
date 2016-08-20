-- QDDayView.lua
-- created by hcl on 2013/5/21
-- 签到的每日控件

super_class.QDDayView()
-- is_qd 是否签到
-- is_current_month 是否当月
-- is_zhoumo 是否周末
-- year,month,day 这个控件的年月日
-- today 今天的天数
function QDDayView:__init( parent,pos_x,pos_y,is_qd,is_current_month,is_zhoumo,year,month,day,today)
	-- 背景图片
	--self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 71,37 , "ui/common/nine_grid_bg.png", 500, 500 );
	-- 面板注册补签函数
	local function bq_function(event_type,args,msgid)
		if ( event_type == TOUCH_CLICK ) then 
			-- TODO 补签
			-- 删除补签两个字 增加勾图片
			if ( self.bq_text ) then
				MiscCC:req_bq( day );
			end
			return true;
		end
	end
	self.view = MUtils:create_btn(parent,
		UILH_BENEFIT.day_bg_normal,
		UILH_BENEFIT.day_bg_normal,
		bq_function,
		pos_x, pos_y, 83, 38);
	self.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_BENEFIT.day_bg_gray)

	-- 是否当前
	if ( is_current_month and today == day ) then
		self.is_today = ZImage:create(self.view,
			UILH_BENEFIT.jian,
			44, -5, -1, -1);
	end

	-- 是否当月
	if ( is_current_month ) then
			-- 是否已经签到
		if ( is_qd ) then
			-- 签到的钩
			self.qd_gou = ZImage:create(self.view,
				UILH_BENEFIT.signed,
				35, 2, -1, -1);
		else
			-- 判断指定日期是否在今天之前
			if ( day < today ) then 
				-- 显示补签
				if ActivityModel:get_today_point() >= 50 then 
					self.bq_text = ZImage:create(self.view, 
						UILH_BENEFIT.buqian, 
						32, 5, -1, -1);
				else
					self.bq_text = ZImage:create(self.view, 
						UILH_BENEFIT.buqian,
						 32, 5, -1, -1);
				end
				table.insert( QianDaoModel:get_buquan_btns(), self)
			end
		end
	else
		-- 不是当月的按钮变灰
		self.view:setCurState( CLICK_STATE_DISABLE );
	end
	-- 设置天数
	local color = "#cffffff"
	if ( is_zhoumo ) then
		color = "#cfff000";
	end
	self.day_font = MUtils:create_zxfont(self.view, color..day, 7, 14, 1, 16);
end

-- 切换补签状态显示 
-- pram=false  不能补签，灰色状态
-- pram=true   能补签，彩色状态
function QDDayView:set_buqian( pram )
	-- if pram == true then 
	-- 	if self.bq_text and self.bq_text then 
	-- 		self.bq_text:setTexture(UIResourcePath.FileLocate.qianDao .. "qiandao(30).png")
	-- 	end
	-- else
	-- 	if self.bq_text and self.bq_text.view then 
	-- 		self.bq_text:setTexture(UIResourcePath.FileLocate.qianDao .. "qiandao(30).png")
	-- 	end
	-- end
end

-- 签到后显示钩
function QDDayView:qd()
	print("QDDayView:qd()")
	if ( self.qd_gou == nil ) then
		self.qd_gou = ZImage:create(self.view,
				UILH_BENEFIT.signed,
				35, 2, -1, -1);
	end
	if ( self.bq_text ) then
		self.bq_text.view:removeFromParentAndCleanup(true);
		self.bq_text = nil;
	end
end