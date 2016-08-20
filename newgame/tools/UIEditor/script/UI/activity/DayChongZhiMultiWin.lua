-- DayChongZhiMultiWin.lua
-- created by chj on 2015-3-10
-- 每日充值

super_class.DayChongZhiMultiWin(NormalStyleWindow)

local font_size = 16

function DayChongZhiMultiWin:__init( window_name, texture_name )


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
    self.tip_1 = CCBasePanel:panelWithFile( 40, 475, -1, -1, UILH_MRCZ.day_cz_multi)
    self.panel_right:addChild( self.tip_1)

    -- 领取大礼按钮
    self.btn_gift = {}
    self.slot_row = {}


    -- self.tip_2 = CCBasePanel:panelWithFile( 143, 375, -1, -1, UILH_MRCZ.mrcz_tips_1)
    -- self.panel_right:addChild( self.tip_2)

    -- -- 目标元宝数
    -- local yuanbao_should = DayChongZhiMultiModel:get_chongzhi_yuanbao( )
    -- self.fightVal = ZXLabelAtlas:createWithString( yuanbao_should, "ui/lh_other/number2_" )
    -- self.fightVal:setPosition(CCPointMake( 440, 440) )
    -- self.fightVal:setAnchorPoint( CCPointMake(0.5, 0) )
    -- self.fightVal:setScale(1.7)
    -- self.panel_right:addChild( self.fightVal )

    -- 元宝
    -- self.img_yuanbao = CCBasePanel:panelWithFile( 480, 440, -1, -1, UILH_MRCZ.mrcz_yuanbao)
    -- self.panel_right:addChild( self.img_yuanbao)

    -- 剩余时间
    ZLabel:create( self.panel_right, LH_COLOR[6] .. Lang.DayCZ[1], 140, 445, font_size, ALIGN_RIGHT)
    local time_remain = SmallOperationModel:get_act_time( DayChongZhiMultiModel.ACTIVITY_ID ) or 0
    print("----time_remain:", time_remain)
    if time_remain == 0 then
        ZLabel:create( self.panel_right, LH_COLOR[6] .. Lang.DayCZ[2], 142, 445, font_size, ALIGN_LEFT )
    else
        local function end_call_func()
            ZLabel:create( self.panel_right, LH_COLOR[6] .. Lang.DayCZ[2], 142, 445, font_size, ALIGN_LEFT )
        end
        if self.timer_label then
			self.timer_label:destroy()
			self.timer_label = nil
		end
        self.timer_label = TimerLabel:create_label( self.panel_right, 142, 445, 16, time_remain, LH_COLOR[6], end_call_func )
    end

    -- 当前充值元宝
    self.lab_yuanbao = ZLabel:create( self.panel_right, LH_COLOR[13] .. Lang.DayCZ[3] .. 123 .. Lang.DayCZ[4], 352, 445, font_size, ALIGN_LEFT)

    -- 道具展示 ------------------------
    -- 背景 & title
    self.slot_bg = CCBasePanel:panelWithFile( 15, 70, 570, 350, UILH_COMMON.bg_11, 500, 500)
    self.panel_right:addChild( self.slot_bg)
    self.slot_title_1 = CCBasePanel:panelWithFile( 71, 330, -1, -1, UILH_MRCZ.mrcz_title_bg)
    self.slot_bg:addChild(self.slot_title_1)
    self.slot_title_2 = CCBasePanel:panelWithFile( 283, 330, -1, -1, UILH_MRCZ.mrcz_title_bg)
    self.slot_title_2:setFlipX(true)
    self.slot_bg:addChild(self.slot_title_2)

    -- title
    ZLabel:create( self.slot_bg, LH_COLOR[1] .. Lang.DayCZ[5], 284, 343, font_size, ALIGN_CENTER )

    -- 道具
    local slot_item_f = DayChongZhiConfig:get_multi_item_conf( )
	self.slot_item_t = {}
    for i=1, #slot_item_f do
        self:create_one_row( self.slot_bg, i, slot_item_f[i])
    end

    -- 立即充值按钮
    local function chongzhi_func( eventType)
        UIManager:show_window("pay_win")
    end
    self.btn_chongzhi = ZTextButton:create(self.panel_right, LH_COLOR[2] .. Lang.DayCZ[6], UILH_COMMON.lh_button_4_r, chongzhi_func, 242, 10, -1, -1, 1)
end

-- 创建一排
function DayChongZhiMultiWin:create_one_row( panel, index, item_conf)
    local slot_base = CCBasePanel:panelWithFile(0, 330-110*index, 560, 110, "")
    panel:addChild( slot_base)

    -- 充值提示
    local t_desc = DayChongZhiConfig:get_multi_item_desc( )
    ZLabel:create( slot_base, LH_COLOR[1] .. t_desc[index], 20, 85, font_size, ALIGN_LEFT )

    for i=1, #item_conf do
        self.slot_item_t[i] = SlotItem( 65, 65 )
        self.slot_item_t[i]:setPosition( 20+(i-1)*70, 15)
        self.slot_item_t[i]:set_icon_bg_texture( UILH_COMMON.slot_bg, -8, -8, 83, 83 )
        self.slot_item_t[i]:set_color_frame( item_conf[i].id, -2, -2, 70, 70 )
        self.slot_item_t[i]:set_icon( item_conf[i].id )
        self.slot_item_t[i]:set_item_count(  item_conf[i].count )
        self.slot_item_t[i].view:setScale(0.85)
        -- self.slot_sld_t[i] = CCBasePanel:panelWithFile(-8, -8, 70, 70, UILH_COMMON.slot_focus)
        -- self.slot_item_t[i].view:addChild(self.slot_sld_t[i])
        slot_base:addChild( self.slot_item_t[i].view )

        local function item_tips_fun(...)
            local a, b, arg = ...
            local click_pos = Utils:Split(arg, ":")
            local world_pos = self.slot_item_t[i].view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
            if item_conf[i].itemid ~= 0 then
                TipsModel:show_shop_tip( world_pos.x/2, world_pos.y+130, item_conf[i].id )
            else
                local temp_data = { item_id = 1, item_count = item_conf[i].id }
                TipsModel:show_money_tip( world_pos.x/2, world_pos.y+30, temp_data )
            end
        end
        self.slot_item_t[i]:set_click_event(item_tips_fun)
    end

    -- 按钮领取
    local function gift_func( eventType)
        DayChongZhiMultiModel:req_get_gift(index)
    end
    self.btn_gift[index] = ZTextButton:create(slot_base, LH_COLOR[2] .. Lang.DayCZ[7], UILH_COMMON.btn4_nor, gift_func, 435, 20, -1, -1, 1)
    self.btn_gift[index].view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
    self.btn_gift[index].view:setCurState(CLICK_STATE_DISABLE)

    -- 分割线
    local line = CCZXImage:imageWithFile( 10, 0, 550, 3, UILH_COMMON.split_line )
    slot_base:addChild(line)
end

-- 更新数据： 参数：更新的类型
function DayChongZhiMultiWin:update( update_type )
	if update_type == "init" then
        -- local t_cz_req = DayChongZhiConfig:get_multi_item_cz_req( )
		local data_t = DayChongZhiMultiModel:get_data( )
        local act_data = data_t.act_data
        print("data_t:", data_t.yuanbao_cz)
		self.lab_yuanbao.view:setText( LH_COLOR[13] .. Lang.DayCZ[3] .. data_t.yuanbao_cz .. Lang.DayCZ[4])
        for i=1, act_data.can_get_record do
            print("------act_data.had_get_record[i]:", act_data.had_get_record[i])
            if act_data.had_get_record[i] == 0 then
                self.btn_gift[i].view:setCurState(CLICK_STATE_DISABLE)
                -- if data_t.yuanbao_cz > t_cz_req[i] or data_t.yuanbao_cz == t_cz_req[i] then
                self.btn_gift[i]:setText( LH_COLOR[2] .. "不可领取") 
                -- else
                --    self.btn_gift[i]:setText( LH_COLOR[2] .. "领取奖励") 
                -- end
            else
                self.btn_gift[i].view:setCurState(CLICK_STATE_UP)
                self.btn_gift[i]:setText( LH_COLOR[2] .. "领取奖励") 
            -- elseif act_data.had_get_record[i] == 2 then
            --     self.btn_gift[i].view:setCurState(CLICK_STATE_DISABLE)
            --     self.btn_gift[i]:setText( LH_COLOR[2] .. "领取奖励") 
            end
        end
	end
end

function DayChongZhiMultiWin:active( show )
    if show then
    	DayChongZhiMultiModel:req_acti_info( )
    end
end

function DayChongZhiMultiWin:destroy()
	if self.timer_label then
		self.timer_label:destroy()
		self.timer_label = nil
	end
    Window.destroy(self)
end
