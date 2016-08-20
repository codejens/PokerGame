-- DayChongZhiWin.lua
-- created by chj on 2015-3-10
-- 每日充值

super_class.DayChongZhiWin(NormalStyleWindow)

local font_size = 16

function DayChongZhiWin:__init( window_name, texture_name )


	-- 大背景
	self.panel_bg = CCBasePanel:panelWithFile( 10, 10, 880, 550, UILH_COMMON.normal_bg_v2, 500, 500 )
    self.view:addChild( self.panel_bg)

    -- 右面板背景
    self.panel_right = CCBasePanel:panelWithFile( 273, 25, 600, 520, UILH_COMMON.bottom_bg, 500, 500)
    self.view:addChild( self.panel_right)

    -- 美人图片
    self.meiren_body = CCBasePanel:panelWithFile( -105, -5, -1, -1, "nopack/girl.png")
    self.view:addChild( self.meiren_body)

    -- 大字体tip
    self.tip_1 = CCBasePanel:panelWithFile( 30, 440, -1, -1, UILH_MRCZ.mrcz_tips_2)
    self.panel_right:addChild( self.tip_1)

    self.tip_2 = CCBasePanel:panelWithFile( 143, 375, -1, -1, UILH_MRCZ.mrcz_tips_1)
    self.panel_right:addChild( self.tip_2)

    -- 目标元宝数
    local yuanbao_should = DayChongZhiModel:get_chongzhi_yuanbao( )
    self.fightVal = ZXLabelAtlas:createWithString( yuanbao_should, "ui/lh_other/number2_" )
    self.fightVal:setPosition(CCPointMake( 440, 440) )
    self.fightVal:setAnchorPoint( CCPointMake(0.5, 0) )
    self.fightVal:setScale(1.7)
    self.panel_right:addChild( self.fightVal )

    -- 元宝
    self.img_yuanbao = CCBasePanel:panelWithFile( 480, 440, -1, -1, UILH_MRCZ.mrcz_yuanbao)
    self.panel_right:addChild( self.img_yuanbao)

    -- 剩余时间
    ZLabel:create( self.panel_right, LH_COLOR[6] .. Lang.DayCZ[1], 190, 330, font_size, ALIGN_RIGHT)
    local time_remain = SmallOperationModel:get_act_time( DayChongZhiModel.ACTIVITY_ID ) or 0
    print("----time_remain:", time_remain)
    if time_remain == 0 then
        ZLabel:create( self.panel_right, LH_COLOR[6] .. Lang.DayCZ[2], 192, 330, font_size, ALIGN_LEFT )
    else
        local function end_call_func()
            ZLabel:create( self.panel_right, LH_COLOR[6] .. Lang.DayCZ[2], 192, 330, font_size, ALIGN_LEFT )
        end
        if self.timer_label then
			self.timer_label:destroy()
			self.timer_label = nil
		end
        self.timer_label = TimerLabel:create_label( self.panel_right, 192, 330, 16, time_remain, LH_COLOR[6], end_call_func )
    end

    -- 当前充值元宝
    self.lab_yuanbao = ZLabel:create( self.panel_right, LH_COLOR[13] .. Lang.DayCZ[3] .. 123 .. Lang.DayCZ[4], 402, 330, font_size, ALIGN_LEFT)

    -- 道具展示 ------------------------
    -- 背景 & title
    self.slot_bg = CCBasePanel:panelWithFile( 15, 110, 570, 155, UILH_COMMON.bg_11, 500, 500)
    self.panel_right:addChild( self.slot_bg)
    self.slot_title_1 = CCBasePanel:panelWithFile( 71, 135, -1, -1, UILH_MRCZ.mrcz_title_bg)
    self.slot_bg:addChild(self.slot_title_1)
    self.slot_title_2 = CCBasePanel:panelWithFile( 283, 135, -1, -1, UILH_MRCZ.mrcz_title_bg)
    self.slot_title_2:setFlipX(true)
    self.slot_bg:addChild(self.slot_title_2)

    -- title
    ZLabel:create( self.slot_bg, LH_COLOR[1] .. Lang.DayCZ[5], 284, 147, font_size, ALIGN_CENTER )

    -- 道具
    local slot_item_f = DayChongZhiModel:get_item_conf()
	self.slot_item_t = {}
    for i=1, #slot_item_f do
    	self.slot_item_t[i] = SlotItem( 65, 65 )
        self.slot_item_t[i]:setPosition( 30+(i-1)*90, 45)
        self.slot_item_t[i]:set_icon_bg_texture( UILH_COMMON.slot_bg, -8, -8, 83, 83 )
        self.slot_item_t[i]:set_color_frame( slot_item_f[i].id, -2, -2, 70, 70 )
        self.slot_item_t[i]:set_icon( slot_item_f[i].id )
        self.slot_item_t[i]:set_item_count(  slot_item_f[i].count )
        -- self.slot_sld_t[i] = CCBasePanel:panelWithFile(-8, -8, 70, 70, UILH_COMMON.slot_focus)
        -- self.slot_item_t[i].view:addChild(self.slot_sld_t[i])
        self.slot_bg:addChild( self.slot_item_t[i].view )

        local function item_tips_fun(...)
            local a, b, arg = ...
            local click_pos = Utils:Split(arg, ":")
            local world_pos = self.slot_item_t[i].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
            if slot_item_f[i].itemid ~= 0 then
                TipsModel:show_shop_tip( world_pos.x/2, world_pos.y+130, slot_item_f[i].id )
            else
                local temp_data = { item_id = 1, item_count = slot_item_f[i].id }
                TipsModel:show_money_tip( world_pos.x/2, world_pos.y+30, temp_data )
            end
        end
        self.slot_item_t[i]:set_click_event(item_tips_fun)
    end

    -- 立即充值按钮
    local function chongzhi_func( eventType)
        UIManager:show_window("pay_win")
    end
    self.btn_chongzhi = ZTextButton:create(self.panel_right, LH_COLOR[2] .. Lang.DayCZ[6], UILH_COMMON.lh_button_4_r, chongzhi_func, 242, 35, -1, -1, 1)

    -- 领取大礼
    local function gift_func( eventType)
        DayChongZhiModel:req_get_gift()
    end
    self.btn_gift = ZTextButton:create(self.panel_right, LH_COLOR[2] .. Lang.DayCZ[7], UILH_COMMON.btn4_nor, gift_func, 242, 35, -1, -1, 1)
	self.btn_gift.view:setIsVisible(false)


end

-- 更新数据： 参数：更新的类型
function DayChongZhiWin:update( update_type )
	if update_type == "init" then
		local data_t = DayChongZhiModel:get_data( )
		self.lab_yuanbao.view:setText( LH_COLOR[13] .. Lang.DayCZ[3] .. data_t.yuanbao_cz .. Lang.DayCZ[4])
        if data_t.is_get_gift > 0 then
            self.btn_chongzhi.view:setIsVisible(false)
            self.btn_gift.view:setIsVisible(true)
        else
            self.btn_chongzhi.view:setIsVisible(true)
            self.btn_gift.view:setIsVisible(false)
        end
	end
end

function DayChongZhiWin:active( show )
    if show then
    	DayChongZhiModel:req_acti_info( )
    end
end

function DayChongZhiWin:destroy()
	if self.timer_label then
		self.timer_label:destroy()
		self.timer_label = nil
	end
    Window.destroy(self)
end
