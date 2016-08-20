-- ZhanYiFuben.lua  
-- created by xiehande on 2014-11-18
-- 战役副本

super_class.ZhanYiFuben(NormalStyleWindow)

-- 副本图标尺寸
local icon_width = 102
local icon_height = 112
-- 副本图标间隔
local icon_space_x = 54+14
local icon_space_y = 22-8
-- 每行显示的图标个数
local icon_count_per_line = 4
-- 建议等级坐标
local sugLv_x = 60
local sugLv_y = 38
-- 页面期望宽度
local exp_width = 743

-- ui param
local panel_w = 890
local panel_h = 560 
local panel_bttm_h =164
local panel_up_h = 560 - panel_bttm_h -24

local line_y = 80

local fb_item_imgs = {
--破狱之战
[58] = {"nopack/MiniMap/poyu1.jpg", "nopack/MiniMap/poyu2.jpg", "nopack/MiniMap/poyu3.jpg", "nopack/MiniMap/poyu4.jpg",
                     "nopack/MiniMap/poyu5.jpg", "nopack/MiniMap/poyu6.jpg",},
--皇陵秘境
[65] = {"nopack/MiniMap/huanglin1.jpg", "nopack/MiniMap/huanglin2.jpg", "nopack/MiniMap/huanglin3.jpg", "nopack/MiniMap/huanglin4.jpg",
                     "nopack/MiniMap/huanglin5.jpg", "nopack/MiniMap/huanglin6.jpg",},
                     --天魔塔              
[64] = {"nopack/MiniMap/tianmota1.jpg", "nopack/MiniMap/tianmota2.jpg", "nopack/MiniMap/tianmota3.jpg", "nopack/MiniMap/tianmota4.jpg",
                     "nopack/MiniMap/tianmota5.jpg",
                      -- "nopack/MiniMap/tianmota6.jpg",
                     },
    }
local fb_item_imgs_d = {
     [58] = {"nopack/MiniMap/poyu1_d.jpg", "nopack/MiniMap/poyu2_d.jpg", "nopack/MiniMap/poyu3_d.jpg", "nopack/MiniMap/poyu4_d.jpg",
                     "nopack/MiniMap/poyu5_d.jpg", "nopack/MiniMap/poyu6_d.jpg",},
    [65] = {"nopack/MiniMap/huanglin1_d.jpg", "nopack/MiniMap/huanglin2_d.jpg", "nopack/MiniMap/huanglin3_d.jpg", "nopack/MiniMap/huanglin4_d.jpg",
 "nopack/MiniMap/huanglin5_d.jpg", "nopack/MiniMap/huanglin6_d.jpg",},
 --天魔塔
    [64] = {"nopack/MiniMap/tianmota1_d.jpg", "nopack/MiniMap/tianmota2_d.jpg", "nopack/MiniMap/tianmota3_d.jpg", "nopack/MiniMap/tianmota4_d.jpg",

 "nopack/MiniMap/tianmota5_d.jpg", 
 -- "nopack/MiniMap/tianmota6_d.jpg",
 },
                 }

local panel_bg = nil ;
--各个副本分层后对应的层数图片  1-3...
local fb_item_floor_img = { 
    --破狱之战
    [58] = {
        [1] =UILH_ACTIVITY.flower_1_to_3 ,
        [2] =UILH_ACTIVITY.flower_4_to_6 ,
        [3] =UILH_ACTIVITY.flower_7_to_10,
        [4] =UILH_ACTIVITY.flower_11_to_13,
        [5] =UILH_ACTIVITY.flower_14_to_16,
        [6] =UILH_ACTIVITY.flower_17_to_19,
     },
    --皇陵秘境
    [65] = {
        [1] =UILH_ACTIVITY.flower_1_to_3 ,
        [2] =UILH_ACTIVITY.flower_4_to_6 ,
        [3] =UILH_ACTIVITY.flower_7_to_9,
        [4] =UILH_ACTIVITY.flower_10_to_12,
        [5] =UILH_ACTIVITY.flower_13_to_15,
        [6] =UILH_ACTIVITY.flower_16_to_18,
    },
    --天魔塔
     [64] = {
        [1] =UILH_ACTIVITY.flower_1_to_4 ,
        [2] =UILH_ACTIVITY.flower_5_to_8 ,
        [3] =UILH_ACTIVITY.flower_9_to_12,
        [4] =UILH_ACTIVITY.flower_13_to_16,
        [5] =UILH_ACTIVITY.flower_17_to_20,
        -- [6] =UILH_ACTIVITY.flower_21_to_23,
    },

}

--副本ID，把大副本分层之后，计算最大通过层只能通过以前的副本ID来获得 ，即现在分层配置文件中的第一个
local for_max_can_fuben_id = nil 
--更改活动的ID  通过活动ID拿到分层的各层副本
function ZhanYiFuben:change_current_activity( activity_id )
    self.current_activity_id = activity_id

    -- 副本配置数据
    local fuben_list_data = ActivityModel:get_activity_info_by_class( "fuben" )
    --某活动详细数据   
    self.activity_info = nil
     -- --找出对应的活动
     -- print("当前活动",self.current_activity_id)
     for i=1,#fuben_list_data do
        if self.current_activity_id == fuben_list_data[i].id then
            self.activity_info = fuben_list_data[i]
            break
        end
     end
   --分层的副本ID集合
    self.fuben_fenceng_list  = ActivityModel:get_activity_info_by_id_fenceng(self.current_activity_id).FBFCID
    self.current_fuben_id = self.fuben_fenceng_list[1]
    for_max_can_fuben_id = self.fuben_fenceng_list[1]
    -- 上面板界面，副本列表
    self:create_up_panel(panel_bg)
    self:create_bttm_panel(panel_bg)
    self:slt_fb_item(1)
    -- EntrustModel:request_entrust_fuben_info(for_max_can_fuben_id)
    MiscCC:req_fuben_pass_info(for_max_can_fuben_id)
    self:update("all")

end

function ZhanYiFuben:__init( window_name, window_info )
    panel_bg = CCBasePanel:panelWithFile(5, 10, panel_w, panel_h, UILH_COMMON.normal_bg_v2, 500, 500)
    self.view:addChild(panel_bg)

            -- 副本item以及选中的item
    self._t_fb_item = {}
    self._index_sld = nil  -- 选择的index
    self._act_id_sld = nil -- 选择的部分id
end

-- 上部面板 ===========================================
function ZhanYiFuben:create_up_panel(panel )
    self.panel_up = CCBasePanel:panelWithFile(12, panel_bttm_h+14, panel_w-24, panel_up_h-15, UILH_COMMON.bottom_bg, 500, 500);
    panel:addChild(self.panel_up);

    -- title 
    -- self.title_up = CCBasePanel:panelWithFile( -9, 335, panel_w-6, 31, UILH_NORMAL.title_bg4 )
    self.title_up = CCBasePanel:panelWithFile( 254, 328, -1, -1, UILH_NORMAL.title_bg3 )
    self.panel_up:addChild( self.title_up )
    local title_txt = ZLabel:create(self.title_up, self.activity_info.location.entityName, 178, 18, 16, 2)

    -- self.title_up:addChild( title_txt )
    -- 创建 scrollview
    self:create_scroll_area(self.panel_up, 17, line_y+5, (panel_w-60), panel_up_h-line_y-40, "", self.activity_info,self.fuben_fenceng_list )
    -- 分割线
    local line = CCZXImage:imageWithFile( 5, line_y, panel_w-35, 3, UILH_COMMON.split_line )
    self.panel_up:addChild(line)
    ZLabel:create(self.panel_up, LH_COLOR[2] .. Lang.wanfadating[4], 15, 35, 16, 1, 1)
    -- 道具
    -- local item_t = ActivityModel:get_fuben_activity_award_items( self._fuben_list_data[1].id )
    -- if #item_t > 0 then
    --     self.award_item_list = self:create_item_scroll( item_t , 225, 10, 55, 55, 3, "")
    --     self.panel_up:addChild( self.award_item_list )
    -- end
end

-- 创建可拖动区域                  
function ZhanYiFuben:create_scroll_area( panel , pos_x, pos_y, size_w, size_h, bg_name, activity_info,fuben_fenceng_list)
    -- ui param
    local row_h = 220 
    local row_w = 160
    local row_inter_h = 20
    local row_num = 10
    local item_num = #fuben_fenceng_list
    local line_num = math.ceil(item_num/row_num)
    local panel_scr_h = row_h*line_num+row_inter_h*line_num

    --总行数，每列的最大值
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = 1, image = bg_name, stype= TYPE_VERTICAL }
    -- local scroll = CCScrollDynamicArea:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype, 500, 500 )
    -- scroll:setEnableScroll(false)
      local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )   

    scroll:setScrollLump(UILH_COMMON.up_progress, UILH_COMMON.down_progress, 30, 10, 502)
    scroll:setScrollLumpPos(8)
    local arrow_left = CCZXImage:imageWithFile(10, 8, -1, 10 , UILH_COMMON.scrollbar_up, 500, 500)
    arrow_left:setRotation(270)
    local arrow_right = CCZXImage:imageWithFile(830, 8, -1, 10, UILH_COMMON.scrollbar_down, 500 , 500)
    arrow_right:setRotation(-90)
    scroll:addChild(arrow_left)
    scroll:addChild(arrow_right)

       -- scroll:setScrollLump(UIResourcePath.FileLocate.common .. "common_progress.png", UIResourcePath.FileLocate.common .. "input_frame_bg.png", 10, 40, 42)
    --scroll:setEnableCut(true)
    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then

            local temparg = Utils:Split(args,":")
            local x = temparg[1]              -- 行
            local y = temparg[2]              -- 列
            local index = x + 1
            -- print(#fuben_fenceng_list/6*(panel_w-10+115))
            -- print((panel_w-10+115-150))
            local panel_items  = nil
            if  #fuben_fenceng_list == 5 then
                panel_items = CCBasePanel:panelWithFile( 0, 0, (panel_w-10+115-150), panel_scr_h, "" )
            elseif #fuben_fenceng_list == 6 then
                 panel_items = CCBasePanel:panelWithFile( 0, 0, (panel_w-10+115), panel_scr_h, "" )
            end
            scroll:addItem(panel_items)

            for i=1, item_num do
                local num_y = math.ceil(i/row_num)
                local num_x = math.mod(i,row_num)
                if num_x == 0 then
                    num_x = row_num
                end
                self:create_fb_item( panel_items, 6+(num_x-1)*(row_w+5), panel_scr_h - num_y*(row_h+row_inter_h)+28, row_w, row_h, i , fuben_fenceng_list[i],activity_info)
            end

            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    panel:addChild( scroll )

    return scroll
end

-- 创建副本item -----------------
function ZhanYiFuben:create_fb_item( panel, x, y, w, h, index, item_data,activity_info )
    local fb_item = {}
    -- 背景框
    local fb_item_gb = CCBasePanel:panelWithFile( x, y, w, h, "ui2/login/lh_ser_bg.png", 500, 500 )
    panel:addChild( fb_item_gb )

    fb_item.bg = fb_item_gb

    -- 地图
    local lttl_map = CCBasePanel:panelWithFile( 12, 13, 160, 220, fb_item_imgs[for_max_can_fuben_id][index] )
    -- lttl_map:setScale(0.85,0.9)
    lttl_map:setScaleX(0.85)
     lttl_map:setScaleY(0.89)
    fb_item_gb:addChild(lttl_map)
    fb_item.lttl_map = lttl_map

    -- 标志
    -- fb_item.item_sign = CCZXImage:imageWithFile( 3, 93, -1, -1, UILH_ACTIVITY.un_start )
    -- fb_item.item_sign:setAnchorPoint(0, 1)
    -- fb_item.bg:addChild( fb_item.item_sign )

    -- 副本名字背景
    fb_item.name_bg = CCBasePanel:panelWithFile( 10, 10, 114, 22, "") -- 114， 22
    fb_item.bg:addChild( fb_item.name_bg)

    -- 副本名字
    -- fb_item.name = ZLabel:create(fb_item.name_bg, LH_COLOR[1] .. activity_info.location.entityName, 140*0.5, 5, 14, 2)

    -- 选中标志
    fb_item.frame_sld = CCZXImage:imageWithFile( -3, -3, w+6, h+6, UILH_COMMON.slot_focus, 500, 500 )
    fb_item.bg:addChild(fb_item.frame_sld)
    fb_item.frame_sld:setIsVisible(false)
    
    --锁
    -- fb_item.lock = CCZXImage:imageWithFile( 19, 0, -1, -1, UILH_ACTIVITY.lock_link )
    -- fb_item.bg:addChild(fb_item.lock)
    -- fb_item.lock:setIsVisible(false)

    --当前多少层 层数
    fb_item.floor = CCZXImage:imageWithFile( 47, 192, -1, -1,fb_item_floor_img[self.current_fuben_id][index])
    fb_item.bg:addChild(fb_item.floor)

    --可通关/可挑战
    fb_item.can_pass = CCZXImage:imageWithFile( 0, 50, -1, -1,UILH_ACTIVITY.can_difiant)
    fb_item.bg:addChild(fb_item.can_pass)



    -- 副本item事件 ------------------------------------------------------
    local function fb_item_func(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            self:slt_fb_item( index )
            return true
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
    end
    fb_item.bg:registerScriptHandler( fb_item_func )  --注册 -------------

    self._t_fb_item[index] = fb_item
    return fb_item
end

-- 创建可拖动区域   参数：放入scroll的panel的集合, 坐标， 区域大小，列数，可见行数， 背景名称
function ZhanYiFuben:create_item_scroll( panel_table_para , pos_x, pos_y, item_w, item_h, item_inter, img_bg)
    require "UI/activity/ActivityCommon"
    local item_panel = ActivityCommon:create_item_horizontal(panel_table_para, pos_x, pos_y, item_w, item_h, item_inter, img_bg)
    return item_panel
end

-- 底部列表 ===========================================
function ZhanYiFuben:create_bttm_panel( panel )
    self.panel_bttm = CCBasePanel:panelWithFile(12, 11, panel_w-24, panel_bttm_h, UILH_COMMON.bottom_bg, 500, 500);
    panel:addChild(self.panel_bttm);

    -- 分割线
    local line = CCZXImage:imageWithFile( (panel_w-20)*0.5, 5, 3, 155, UILH_COMMON.split_line_v )
    self.panel_bttm:addChild(line)

    -- 左边title --------------
    self.title_left = CCBasePanel:panelWithFile( 0, 130, 425, -1, UILH_NORMAL.title_bg4, 500, 500 )
    self.panel_bttm:addChild( self.title_left )
    local title_txt_left = ZLabel:create(self.title_left, Lang.wanfadating[34], 425*0.5, 10, 16, 2)

    -- 活动介绍
    self.act_desc = CCDialogEx:dialogWithFile( 15, 130, 380, 75, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    self.act_desc:setAnchorPoint(0,1);
    self.act_desc:setFontSize(16);
    self.act_desc:setText( "" );  -- "#cffff00当前效果:#cffffff:"
    self.act_desc:setTag(0)
    self.act_desc:setLineEmptySpace (5)
    self.panel_bttm:addChild(self.act_desc)

    -- 是否自动购买材料勾选按钮
    -- self.transmit_but = UIButton:create_switch_button(10, 10, 150, 44, 
    --     UILH_COMMON.dg_sel_1, 
    --     UILH_COMMON.dg_sel_2, 
    --     Lang.wanfadating[6], 40, 16, nil, nil, nil, nil, 
    --     autoBuyFunc )
    -- self.panel_bttm:addChild(self.transmit_but.view, 2);

    -- ZLabel:create(self.panel_bttm, LH_COLOR[2] .. "", 50, 22, 16, 1, 1)
    -- self.trans_item = ZLabel:create(self.panel_bttm, LH_COLOR[15] .. "(小飞鞋剩余5个)", 170, 22, 16, 1, 1)

    -- 右边title --------------
    self.title_right = CCBasePanel:panelWithFile( 430, 130, 425, -1, UILH_NORMAL.title_bg4, 500, 500 )
    self.panel_bttm:addChild( self.title_right )
    local title_txt_right = ZLabel:create(self.title_right, Lang.wanfadating[35], 425*0.5, 10, 16, 2)

    -- 经验 & 道具 & 剩余次数
    -- self.star_name_1 = ZLabel:create(self.panel_bttm, LH_COLOR[2] .. "经验：", 445, 105, 14, 1, 1)
    -- self.star_name_2 = ZLabel:create(self.panel_bttm, LH_COLOR[2] .. "道具：", 445, 77, 14, 1, 1)
    -- -- -- 经验5颗星
    -- self.exp_star = CCBasePanel:panelWithFile(495, 93, 185, 45, "")
    -- self.panel_bttm:addChild( self.exp_star )
    -- MUtils:drawStart3(self.exp_star, 5)
    -- -- 道具5颗星
    -- self.exp_star = CCBasePanel:panelWithFile(495, 60, 185, 45, "")
    -- self.panel_bttm:addChild( self.exp_star )
    -- MUtils:drawStart3(self.exp_star, 5)

    -- 星星 第一列
    self.star_name_1   = ZLabel:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[8], 445, 105, 14, 1, 1)
    self.star_range_1  = MUtils:create_star_range( self.panel_bttm, 495, 100, 25, 25, 4 ) 
    self.star_range_1.change_star_interval( 10 )

    -- 星星 第二列
    self.star_name_2 = ZLabel:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[9], 445, 77, 14, 1, 1)
    self.star_range_2  = MUtils:create_star_range( self.panel_bttm, 495, 70, 25, 25, 5 ) 
    self.star_range_2.change_star_interval( 10 )


    -- 剩余次数
    ZLabel:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[10], 680, 60, 14, 1, 1)
    self.go_num = ZLabel:create(self.panel_bttm, LH_COLOR[15] .. "0/3", 765, 60, 14, 1, 1)

    -- btn 委托 & 前往副本
    local function entrust_func()
        if self.current_fuben_id then
            ActivityModel:open_fuben_entrust( self.current_fuben_id )
        end
    end
    self.btn_entrust = ZTextButton:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[11], UILH_COMMON.btn4_nor, 
        entrust_func, 451, 3, -1, -1)

    --增加次数
    local function add_num(  )
         --分层副本增加次数时 使用的是139,149协议 传入的是分层副本的第一层
         ActivityModel:apply_add_enter_fuben_count(for_max_can_fuben_id,true)
         -- ActivityModel:apply_add_enter_fuben_count( self.current_fuben_id )
    end
    self.btn_add_num = ZTextButton:create(self.panel_bttm, LH_COLOR[2] .. Lang.activity.fuben[8], UILH_COMMON.btn4_nor, 
        add_num, 589, 3, -1, -1)

     local function goto_func()
        -- local item_data = self._fuben_list_data[self._index_sld]
        -- #1
         GameLogicCC:req_talk_to_npc( 0, string.format("OnEnterFubenFunc, %d",self.current_fuben_id ))
        -- #2
        -- local if_transmit = self.transmit_but.if_selected     -- 是否选择了传送
        -- print("self.activity_info.location.sceneid",self.activity_info.location.sceneid, self.activity_info.location.entityName,if_transmit)
        -- ActivityModel:go_to_activity( self.activity_info.location.sceneid, self.activity_info.location.entityName, if_transmit )
    end
    self.btn_goto = ZTextButton:create(self.panel_bttm, LH_COLOR[2] .. Lang.wanfadating[12], UILH_COMMON.btn4_nor, 
        goto_func, 728, 3, -1, -1)
end

-- =====================================================================================================================
-- 更新 数据
-- =====================================================================================================================
function ZhanYiFuben:update( update_type )
    if update_type == "all" then
        -- self:update_fuben_status()
        -- 请求各个副本次数
        ActivityModel:request_enter_fuben_times()
        self:update_time(self.current_fuben_id)
    elseif update_type == "fuben_times" then
        -- self:update_fuben_status()
        self:update_time(self.current_fuben_id)
    end

    --打完副本都需要更新最大层数
        --请求副本委托信息，获得访问的最大层数
    -- EntrustModel:request_entrust_fuben_info(for_max_can_fuben_id)
    MiscCC:req_fuben_pass_info(for_max_can_fuben_id)
    self:update_fuben_status()

end

-- 更新各个副本item的状态
function ZhanYiFuben:update_fuben_status()
    local max_can_array = ActivityModel:get_fenceng_fuben_pass()

    local flag = true
    for i=1,#self._t_fb_item do
        -- if i ~= self._fb_item_sld then
            local require_level = self.activity_info.level

            local player_level = EntityManager:get_player_avatar().level
            if player_level<require_level then
                -- self._t_fb_item[i].times_bg:setIsVisible(false)
                -- self._t_fb_item[i].view:setCurState(CLICK_STATE_DISABLE)
                -- self._t_fb_item[i].item_sign:setIsVisible(false)
                self._t_fb_item[i].name_bg:setIsVisible(false)
                self._t_fb_item[i].lttl_map:setTexture( fb_item_imgs_d[for_max_can_fuben_id][i] )
                -- self._t_fb_item[i].lock:setIsVisible(true)
                self._t_fb_item[i].can_pass:setTexture(UILH_ACTIVITY.can_difiant)
                -- if  i == 1 then
                    self._t_fb_item[i].can_pass:setIsVisible(false)
                -- else
                --     self._t_fb_item[i].can_pass:setIsVisible(false)
                -- end
            else
                -- self._t_fb_item[i].times_bg:setIsVisible(true)
                -- self._t_fb_item[i].view:setCurState(CLICK_STATE_UP)
                -- self._t_fb_item[i].item_sign:setIsVisible(true)
                self._t_fb_item[i].name_bg:setIsVisible(true)
                self._t_fb_item[i].lttl_map:setTexture( fb_item_imgs[for_max_can_fuben_id][i] )
                -- self._t_fb_item[i].lock:setIsVisible(false)
              
                if max_can_array[i] == 1 then  --已通关
                    flag = i
                    self._t_fb_item[i].can_pass:setTexture(UILH_ACTIVITY.can_pass)
                    self._t_fb_item[i].lttl_map:setTexture( fb_item_imgs[for_max_can_fuben_id][i] )

                elseif max_can_array[i] == 0 then --未通关 
                    self._t_fb_item[i].can_pass:setTexture(UILH_ACTIVITY.can_difiant)
                    self._t_fb_item[i].lttl_map:setTexture( fb_item_imgs_d[for_max_can_fuben_id][i] )
                     if flag then
                        flag = false
                        self._t_fb_item[i].can_pass:setIsVisible(true)
                     else
                        self._t_fb_item[i].can_pass:setIsVisible(false)
                     end
                end

            end 
            -- self._t_fb_item[i].frame_sld:setIsVisible(false)
        -- else
            -- self._t_fb_item[i].frame_sld:setIsVisible(true)
        -- end 
    end

end

-- 副本选择
function ZhanYiFuben:slt_fb_item( index )

    -- GameLogicCC:req_talk_to_npc( 0, string.format("OnEnterFubenFunc, %d",58 ))


    -- self._act_id_sld = self.fuben_fenceng_list[index]
    self.current_fuben_id = self.fuben_fenceng_list[index]
    for i=1, #self._t_fb_item do
        self._t_fb_item[i].frame_sld:setIsVisible(false)
    end
    self._t_fb_item[index].frame_sld:setIsVisible(true)
    -- self:update_introduce( self._act_id_sld ) 
    -- self:update_award( self._act_id_sld )
    -- self:update_time( self._act_id_sld )
     self:update_introduce( self.current_activity_id ) 
    self:update_award( self.current_activity_id )
    self:update_time( self.current_fuben_id )   
    -- self:update_cloud_num()
end

-- 更新介绍
function ZhanYiFuben:update_introduce( activity_id )
    local activity_introduce = ActivityModel:get_activity_introduce_by_id( activity_id )
    -- local activity_introduce = self.activity_info.desc
    self.act_desc:setText( "" )
    self.act_desc:setText( activity_introduce )
end

-- 更新副本奖励
function ZhanYiFuben:update_award( activity_id )
    -- 星星
    local stars_info_ret_t = ActivityModel:get_activity_star( activity_id )
    if stars_info_ret_t[1] then
        self.star_name_1:setText( LH_COLOR[2] ..stars_info_ret_t[1].name .. ": " )
        self.star_range_1.change_star_num( stars_info_ret_t[1].num )
    else
        self.star_name_1:setText("")
        self.star_range_1.change_star_num( 0 )
    end
    if stars_info_ret_t[2] then
        self.star_name_2:setText( LH_COLOR[2] .. stars_info_ret_t[2].name .. ": " )
        self.star_range_2.change_star_num( stars_info_ret_t[2].num )
    else
        self.star_name_2:setText("")
        self.star_range_2.change_star_num( 0 )
    end

    self.panel_up:removeChild( self.award_item_list, true)
    -- 道具
    local item_t = ActivityModel:get_fuben_activity_award_items( self.current_activity_id )
    if #item_t > 0 then
        self.award_item_list = self:create_item_scroll( item_t , 225, 10, 55, 55, 7, "")
        self.panel_up:addChild( self.award_item_list )
    end
end

-- 更新次数
function ZhanYiFuben:update_time( fuben_id )
    local enter_times, max_times, extra_award = ActivityModel:get_enter_fuben_count(fuben_id ) 
    self.go_num:setText( string.format("%d/%d", enter_times, max_times) )
end

-- 更新筋斗云个数
function ZhanYiFuben:update_cloud_num(  )
    local cloud_num = ActivityModel:get_cloud_num(  )
    -- self.transmit_but.setString( LangGameString[545]..cloud_num..LangGameString[546] ) -- [545]="自动传送(筋斗云剩余" -- [546]="个)"
    -- self.trans_item:setText( Lang.wanfadating[13] .. cloud_num .. Lang.wanfadating[14] )
end

function ZhanYiFuben:update_selected( activity_id )

end

--更新 锁定标志的显示
function ZhanYiFuben:update_locks(  )

end

-- 更新活动图标上的提示剩余次数的标志
function ZhanYiFuben:update_tips_count()

end

function ZhanYiFuben:destroy()
    Window.destroy(self)
    self.fuben_list_data = nil

end
