-- FBResultWin.lua
-- created by Little White on 2014-8-23
-- 副本结算窗口  

super_class.FBResultWin(Window)

local c3_green  = "#c38ff33"
local c3_blue   = "#c00c0ff"
local c3_pink   = "#cff66cc"
local c3_yellow = "#cfff000"
local c3_orange = "#cfe8300"

local reward_config = { [0]={text=Lang.normal[1],path=UIPIC_ACTIVITY_056, name = "银两"},  --[1] = "银两"
                        [1]={text=Lang.normal[2],path=UIPIC_ACTIVITY_055, name = "忍币"},  --[2] = "忍币"
                        [2]={text=Lang.normal[3],path=""},                  --[3] = "礼券"
                        [3]={text=Lang.normal[4],path=""},                  --[4] = "元宝"
                        [4]={text=Lang.normal[5],path=UIPIC_ACTIVITY_054, name = "历练"},  --[5] = "历练"
                        [5]={text=Lang.normal[6],path=UIPIC_ACTIVITY_053, name = "经验"},  --[6] = "经验"
                      }

local grade_pic_config = {
                        [1]= { UILH_FUBEN.c_1, UILH_FUBEN.c_2, UILH_FUBEN.c_3, UILH_FUBEN.c_4 },
                        [2]= { UILH_FUBEN.b_1, UILH_FUBEN.b_2, UILH_FUBEN.b_3, UILH_FUBEN.b_4 },
                        [3]= { UILH_FUBEN.a_1, UILH_FUBEN.a_2, UILH_FUBEN.a_3, UILH_FUBEN.a_4 },
                        [4]= { UILH_FUBEN.a_1, UILH_FUBEN.a_2, UILH_FUBEN.a_3, UILH_FUBEN.a_4 },
                        }

function FBResultWin:__init( window_name, texture_name, is_grid, width, height )
    xprint("function FBResultWin:__init( window_name, texture_name, is_grid, width, height )")
    -- 背景
    self.bg_img = ZImage:create( self.view, UILH_FUBEN.result_bg, -150, -50, GameScreenConfig.ui_screen_width+200,GameScreenConfig.ui_screen_height+100,0, 500, 500)
    self.bg_img.view:setOpacity(0)

    -- 全部UI容器(历练副本)
    self.base_panel = ZBasePanel:create(self.view,"",25,20,857,592)
    self.base_panel.view:setIsVisible(false)

    -- 副本通关title
    self.title_img = MUtils:create_zximg(self.base_panel, UILH_FUBEN.title_result, 960*0.5-145*0.5, 640-75, -1, -1, 500, 500)
    self.title_img:setAnchorPoint(0.5,0.5)

    -- 右边评分动画(旋转动画图)
    self.grade_bg = MUtils:create_zximg(self.base_panel,UILH_FUBEN.bttm_layer, 680, 352,-1,-1, 500, 500)
    self.grade_bg:setAnchorPoint(0.5,0.5)
    self.two_layer = MUtils:create_zximg(self.grade_bg, UILH_FUBEN.two_layer, 214*0.5, 218*0.5,-1,-1, 500, 500)
    self.two_layer:setAnchorPoint(0.5,0.5)
    self.one_layer = MUtils:create_zximg(self.grade_bg, UILH_FUBEN.one_layer, 214*0.5, 218*0.5, -1, -1, 500, 500)
    self.one_layer:setAnchorPoint(0.5,0.5)

    local begin_x_lh = 30
    -- 时间title ，右下角置底 ================================================================
    MUtils:create_zximg(self.base_panel,UILH_FUBEN.title_time, 620, 100,-1,-1,500,500)

    -- 通关奖励 title +线 ===========================================================================
    local image_line = CCZXImage:imageWithFile( begin_x_lh, 510, 525, -1, UILH_FUBEN.line )
    self.base_panel:addChild(image_line)
    ZImageImage:create(self.base_panel, UILH_FUBEN.title_tong, "", begin_x_lh, 510, -1, -1)

    local begin_x = 80
    local offset_x = 50
    local interval_x = 200
    local begin_y = 360+105
    local interval_y = 45

    -- 动态显示奖励项
    self.type_label_t = {}
    self.type_text_t = {}
    self.type_value_t2 = {}   -- uilabel
    self.award_item_list = {}

    self:create_award_row_2(self.base_panel,UIPIC_ACTIVITY_053,begin_x + interval_x * 0,begin_y - interval_y * 0,1)
    self:create_award_row_2(self.base_panel,UIPIC_ACTIVITY_053,begin_x + interval_x * 0,begin_y - interval_y * 1,2)
    self:create_award_row_2(self.base_panel,UIPIC_ACTIVITY_053,begin_x + interval_x * 1,begin_y - interval_y * 0,3)
    self:create_award_row_2(self.base_panel,UIPIC_ACTIVITY_053,begin_x + interval_x * 1,begin_y - interval_y * 1,4)

    -- 评分奖励title + 线 ======================================================================
    image_line = CCZXImage:imageWithFile( begin_x_lh, 390, 525, -1, UILH_FUBEN.line )
    self.base_panel:addChild(image_line)
    ZImageImage:create(self.base_panel, UILH_FUBEN.title_pin, "", begin_x_lh, 390, -1, -1)
    
    self.grade_label = UILabel:create_lable_2( LH_COLOR[13] .. "经验：", begin_x + interval_x * 0, begin_y - interval_y * 3+5, 18, ALIGN_LEFT )
    self.base_panel:addChild( self.grade_label )
    self.grade_text_2 = UILabel:create_lable_2( "", begin_x + interval_x * 0+60, begin_y - interval_y * 3+5, 18, ALIGN_LEFT )
    self.base_panel:addChild( self.grade_text_2 )

    -- 经验加成title + 线===========================================================================
    image_line = CCZXImage:imageWithFile( begin_x_lh, 290, 525, -1, UILH_FUBEN.line )
    self.base_panel:addChild(image_line)
    ZImageImage:create(self.base_panel, UILH_FUBEN.title_jing, "", begin_x_lh, 290, -1, -1)

    -- self.extra_label = MUtils:create_zximg(self.base_panel,UIPIC_ACTIVITY_053,begin_x + interval_x * 0,begin_y - interval_y * 4.9,-1,-1,500,500)
    self.extra_label = UILabel:create_lable_2( LH_COLOR[13] .. "经验：", begin_x + interval_x * 0, begin_y - interval_y * 4.9-15, 18, ALIGN_LEFT )
    self.base_panel:addChild( self.extra_label )
    self.extra_text_2 = UILabel:create_lable_2( "", begin_x + interval_x * 0+60, begin_y - interval_y * 4.9+-15, 18, ALIGN_LEFT )
    self.base_panel:addChild( self.extra_text_2 )


    -- 材料奖励title + 线 ============================================================================
    image_line = CCZXImage:imageWithFile( begin_x_lh, 190, 525, -1, UILH_FUBEN.line )
    self.base_panel:addChild(image_line)
    ZImageImage:create(self.base_panel, UILH_FUBEN.title_cai, "", begin_x_lh, 190, -1, -1)

    -- 幸运宝箱 + 线
    -- image_line = CCZXImage:imageWithFile( begin_x_lh, 120, 525, -1, UILH_FUBEN.line )
    -- self.base_panel:addChild(image_line)
    -- ZImageImage:create(self.base_panel, UILH_FUBEN.title_xing, "", begin_x_lh, 120, -1, -1)

    -- 确定按钮
    local function btn_ok_fun()
        OthersCC:req_exit_fuben()
        UIManager:destroy_window("fb_result_win")
        local function open_activity_fun()
            UIManager:show_window( "activity_Win" )
            -- GlobalFunc:ask_npc( fuben_result.fubenId, 0 )  -- 再来一次，待做

            -- local win = UIManager:show_window("activity_Win")
            -- if win then
            --     win:change_page(2)
            --     local btn_index = FuBenModel:get_btn_index_by_list_id(FuBenModel:get_current_list_id())
            --     win:update_win("change_page",btn_index)
            --     -- win:update_win("fuben_times")
            -- end 
        end 
        local cb = callback:new()
        cb:start(1.5,open_activity_fun)    
    end

    self.btn_ok = ZTextButton:create(self.base_panel,"回  城", UILH_COMMON.lh_button_4_r,btn_ok_fun, 640, 20, -1, -1)
    self.btn_ok.view:setIsVisible(false)

    self._timer = timer()
    local function timer_fun()
        btn_ok_fun()
        -- self._timer:stop()
        -- self._timer = nil
    end
    self._timer:start(8,timer_fun)

    -- 注册背景事件，点击背景同点击确定是一样的效果
    local function click_func( eventType )
        if eventType == TOUCH_CLICK then
            btn_ok_fun()
        end
        return true
    end
    self.base_panel.view:registerScriptHandler(click_func)
end

-- title——2
function FBResultWin:create_award_row_2(parent,pic_path,pos_x,pos_y,index)
    -- local pic = MUtils:create_zximg(parent,pic_path,pos_x,pos_y,-1,-1,500,500)
    local pic = UILabel:create_lable_2( "经验：", pos_x, pos_y, 18, ALIGN_LEFT )
    parent:addChild( pic )
    self.type_label_t[index] = pic

    local pic_value = UILabel:create_lable_2( "", pos_x+60, pos_y, 18, ALIGN_LEFT )
    parent:addChild( pic_value )
    self.type_value_t2[index] = pic_value
    -- local lab = MUtils:create_zxfont(parent,"测试"..index,pos_x+80,pos_y+10,1,22)
    -- 特效字
    local text = RollingText(pos_x+85,pos_y+8,300,33,24)
    text:setPrefix('ui/fonteffect/fr')
    text:setValue(0)
    parent:addChild(text.view)
    self.type_text_t[index] = text
end

--创建副本成功界面
function FBResultWin:create_succss_panel(fuben_result)

    if fuben_result then
        self.fuben_result = fuben_result

        -- 副本时间 小于 1分钟
        if fuben_result.elapsed_time < 59 then
            self.lh_result_time = RollingText( 700, 100, 300,33,15)
            self.lh_result_time:setPrefix('ui/lh_other/number2_')
            self.lh_result_time:setValue( fuben_result.elapsed_time )
            self.base_panel:addChild(self.lh_result_time.view)

            local img_second_1 = CCZXImage:imageWithFile( 715, 110, -1, -1, UILH_FUBEN.douhao )
            local img_second_2 = CCZXImage:imageWithFile( 725, 110, -1, -1, UILH_FUBEN.douhao )
            self.base_panel:addChild( img_second_1 )
            self.base_panel:addChild( img_second_2 )
            if fuben_result.elapsed_time > 9 then
                img_second_1:setPosition( 730, 110)
                img_second_2:setPosition( 740, 110)
            end
        else  -- 大于1分钟 处理
            local minute = math.floor( fuben_result.elapsed_time/60 )
            local second = fuben_result.elapsed_time - minute*60
            self.lh_minute = RollingText( 700, 100, 300,33,15)
            self.base_panel:addChild(self.lh_minute.view)
            self.lh_minute:setPrefix('ui/lh_other/number2_')
            self.lh_minute:setValue( minute )
            local img_minute = CCZXImage:imageWithFile( 715, 110, -1, -1, UILH_FUBEN.douhao )
            self.base_panel:addChild( img_minute )

            self.lh_second = RollingText( 730, 100, 300,33,15)
            self.base_panel:addChild(self.lh_second.view)
            self.lh_second:setPrefix('ui/lh_other/number2_')
            self.lh_second:setValue( second )

            local img_second_1 = CCZXImage:imageWithFile( 745, 110, -1, -1, UILH_FUBEN.douhao )
            self.base_panel:addChild( img_second_1 )
            local img_second_2 = CCZXImage:imageWithFile( 755, 110, -1, -1, UILH_FUBEN.douhao )
            self.base_panel:addChild( img_second_2 )

            if minute > 9 then
                img_minute:setPosition( 730, 110)
            end
            if (minute>9 and second<9) or (minute<9 and second>9) then
                img_second_1:setPosition(760, 110)
                img_second_2:setPosition(770, 110)
            elseif minute > 9 and second> 9 then
                img_second_1:setPosition(775, 110)
                img_second_2:setPosition(785, 110)
            end
        end

        local fix_award = FubenConfig:get_fix_award_by_fubenId(fuben_result.fubenId)

        -- 固定奖励
        for i=1,#self.type_label_t do
            if fix_award[i] then
                local type = fix_award[i].type

                self.type_label_t[i]:setString( LH_COLOR[13] .. reward_config[type].name )
                self.type_label_t[i]:setIsVisible(true)
                self.type_value_t2[i]:setString( LH_COLOR[2] .. fix_award[i].count )

                self.type_text_t[i].view:setIsVisible(false)
                if type == 5 then
                    self.fix_exp_value = fix_award[i].count
                end 
            else
                self.type_label_t[i]:setIsVisible(false)
                self.type_text_t[i].view:setIsVisible(false)
            end 
        end

        -- 评级( 傲视群雄)  (傲, 视, 群, 雄)
        self.grade_pic = MUtils:create_zximg(self.base_panel, "", 680, 352,318,345,500,500)
        self.grade_pic:setAnchorPoint( 0.5, 0.5)
        self.grade_pic:setIsVisible(true)

        self.grade_pic_1 = MUtils:create_zximg( self.grade_pic,grade_pic_config[fuben_result.grade][1], 83, 250, -1, -1, 500, 500 )
        self.grade_pic_1:setAnchorPoint( 0.5, 0.5)
        self.grade_pic_1:setRotation(5)
        self.grade_pic_1:setIsVisible(false)

        self.grade_pic_2 = MUtils:create_zximg( self.grade_pic,grade_pic_config[fuben_result.grade][2], 225, 250, -1, -1, 500, 500 )
        self.grade_pic_2:setAnchorPoint( 0.5, 0.5)
        self.grade_pic_2:setRotation(5)
        self.grade_pic_2:setIsVisible(false)

        self.grade_pic_3 = MUtils:create_zximg( self.grade_pic,grade_pic_config[fuben_result.grade][3], 83, 97, -1, -1, 500, 500 )
        self.grade_pic_3:setAnchorPoint( 0.5, 0.5)
        self.grade_pic_3:setRotation(5)
        self.grade_pic_3:setIsVisible(false)

        self.grade_pic_4 = MUtils:create_zximg( self.grade_pic,grade_pic_config[fuben_result.grade][4], 225, 97, -1, -1, 500, 500 )
        self.grade_pic_4:setAnchorPoint( 0.5, 0.5)
        self.grade_pic_4:setRotation(5)
        self.grade_pic_4:setIsVisible(false)

        -- 评级奖励
        local grade_award = FubenConfig:get_grade_award_by_fubenId(fuben_result.fubenId,fuben_result.grade)

        self.grade_text_2:setString( LH_COLOR[2] .. grade_award.count)

        -- 经验丹加成
        print("(fuben_result.extra_param/100) * self.fix_exp_value",(fuben_result.extra_param/100) * self.fix_exp_value)
        self.extra_exp = math.ceil((fuben_result.extra_param/100) * self.fix_exp_value)
        self.extra_text_2:setString( LH_COLOR[2] ..  self.extra_exp) 

        -- 奖励列表
        for i=1,#self.award_item_list do
            self.award_item_list[i]:removeFromParentAndCleanup(true)
        end

        self.award_item_list = {}

        local slot_w = 72
        local slot_h = 72
        local slot_x = 54 + 25
        local slot_y = 25 + 60
        local slot_offset = 80

        local award_list = fuben_result.award_list

        for i=1,#award_list do
            local slot;
            if award_list[i].itemId == 3 then
                slot = MUtils:create_one_slotItem( nil, 
                    slot_x+slot_offset*(i-1), slot_y, 
                    slot_w, slot_h )
                slot:set_item_count(item.count)
                slot:set_money_icon(3)
            else
                print("@@@@@@@@@@@@@@@@@@@@award_list[i].itemId",award_list[i].itemId)
                slot = MUtils:create_one_slotItem( award_list[i].itemId, 
                    slot_x+slot_offset*(i-1), slot_y, 
                    slot_w, slot_h );
                slot:set_item_count(award_list[i].count)
            end

            local function tip_func( slot_obj,eventType, args, msgid )
                local click_pos = Utils:Split(args, ":")
                local world_pos = self.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) );
                if item.itemid == 3 then
                    -- 显示元宝tip
                    local data = {item_id = 3, item_count = item.count};
                    TipsModel:show_money_tip( world_pos.x,world_pos.y, data );
                else
                    TipsModel:show_shop_tip( world_pos.x,world_pos.y, item.itemid)
                end
            end

            -- slot:set_click_event(tip_func)
            self.base_panel:addChild(slot.view)
            self.award_item_list[i] = slot
        end
       
        -- 跑动画
        self:do_action()
    end
end

function FBResultWin:do_action()
    local time1 = 6
    local delaytime_1 = 2.9
    -- 第一步 背景图片慢慢显示
    self.bg_img.view:runAction(CCFadeOut:actionWithDuration(1))
    self.grade_bg:runAction(CCFadeIn:actionWithDuration(1.5))
    local _timer = timer()
    local opacity = 0
    local function timer_fun()
        opacity = opacity + 100
        self.bg_img.view:setOpacity(opacity)
        if opacity == 500 then
            _timer:stop()
        end
    end
    _timer:start(0.1,timer_fun)

    -- 第二步  转圈动画
    local a_array_2 = CCArray:array()
    local action2 = CCRepeatForever:actionWithAction(CCRotateBy:actionWithDuration(1.5,80))
    self.two_layer:runAction(action2)

    local a_array_3 = CCArray:array()
    local action3 = CCRepeatForever:actionWithAction(CCRotateBy:actionWithDuration(1.5,-80))
    self.one_layer:runAction(action3)

    -- 第三步 显示界面
    local array = CCArray:array()
    array:addObject(CCDelayTime:actionWithDuration(1))
    array:addObject(CCShow:action())
    self.base_panel.view:runAction(CCSequence:actionsWithArray(array))

    -- 第四步 通关标题
    self.title_img:setScale(10)
    -- self.title_img:setOpacity(50)
    self.title_img:setIsVisible(false)
    local array = CCArray:array()
    array:addObject(CCDelayTime:actionWithDuration(1.6))
    array:addObject(CCShow:action())
    local array2 = CCArray:array()
    array2:addObject(CCScaleTo:actionWithDuration(0.2,1))
    array2:addObject(CCFadeIn:actionWithDuration(0.2))
    local action = CCSpawn:actionsWithArray(array2)
    array:addObject(action)
    self.title_img:runAction(CCSequence:actionsWithArray(array))

    -- 第五步 出时间，固定奖励,评分奖励
    local array = CCArray:array()
    array:addObject(CCDelayTime:actionWithDuration(2))
    array:addObject(CCShow:action())
    local array2 = CCArray:array()
    array2:addObject(CCScaleTo:actionWithDuration(0.2,1))
    array2:addObject(CCFadeIn:actionWithDuration(0.2))
    local action = CCSpawn:actionsWithArray(array2)
    array:addObject(action)


    -- 第六步 物品奖励
    for i=1,#self.award_item_list do
        local slot = self.award_item_list[i]
        slot.view:setScale(4)
        slot.view:setOpacity(50)
        slot.view:setIsVisible(false)
        local array = CCArray:array()
        array:addObject(CCDelayTime:actionWithDuration(3.5+(i-1)*0.3 ))
        array:addObject(CCShow:action())
        local array2 = CCArray:array()
        array2:addObject(CCScaleTo:actionWithDuration(0.2,1))
        array2:addObject(CCFadeIn:actionWithDuration(0.2))
        local action = CCSpawn:actionsWithArray(array2)
        array:addObject(action);
        array:addObject(CCScaleTo:actionWithDuration(0.05,1.2))
        array:addObject(CCScaleTo:actionWithDuration(0.05,1))
        slot.view:runAction(CCSequence:actionsWithArray(array))
    end

    -- 第七步 评分(傲视群雄)
    print("---------#self.award_item_list:", #self.award_item_list)
    local inter_time = 2.5
    local t0 = CCScaleTo:actionWithDuration( 0.1, 2.5 )
    local t1 = CCScaleTo:actionWithDuration( 0.1, 2.6 )
    local t2 = CCScaleTo:actionWithDuration( 0.1, 0.5 )
    local t3 = CCScaleTo:actionWithDuration( 0.1, 1.1 ) 
    local t4 = CCScaleTo:actionWithDuration( 0.1, 1.0 ) 

    -- 1 -------------------------------
    local array_1 = CCArray:array()
    array_1:addObject(CCDelayTime:actionWithDuration(1.3 + #self.award_item_list * 0.3))
    array_1:addObject(CCShow:action())
    array_1:addObject(t0)
    array_1:addObject(t1)
    array_1:addObject(t2)
    array_1:addObject(t3)
    array_1:addObject(t4)
    local seq_1 = CCSequence:actionsWithArray(array_1)
    self.grade_pic_1:runAction( seq_1 )
    -- 2 -------------------------------
    local array_2 = CCArray:array()
    array_2:addObject(CCDelayTime:actionWithDuration(1.7 + #self.award_item_list * 0.3))
    array_2:addObject(CCShow:action())
    array_2:addObject(t0)
    array_2:addObject(t1)
    array_2:addObject(t2)
    array_2:addObject(t3)
    array_2:addObject(t4)
    local seq_2 = CCSequence:actionsWithArray(array_2)
    self.grade_pic_2:runAction( seq_2 )
    -- 3 -------------------------------
    local array_3 = CCArray:array()
    array_3:addObject(CCDelayTime:actionWithDuration(2.1 + #self.award_item_list * 0.3))
    array_3:addObject(CCShow:action())
    array_3:addObject(t0)
    array_3:addObject(t1)
    array_3:addObject(t2)
    array_3:addObject(t3)
    array_3:addObject(t4)
    local seq_3 = CCSequence:actionsWithArray(array_3)
    self.grade_pic_3:runAction( seq_3 )
    -- 4 ------------------------------
    local array_4 = CCArray:array()
    array_4:addObject(CCDelayTime:actionWithDuration(2.5 + #self.award_item_list * 0.3))
    array_4:addObject(CCShow:action())
    array_4:addObject(t0)
    array_4:addObject(t1)
    array_4:addObject(t2)
    array_4:addObject(t3)
    array_4:addObject(t4)
    local seq_4 = CCSequence:actionsWithArray(array_4)
    self.grade_pic_4:runAction( seq_4 )

    -- 第八步 出确定按钮
    local array = CCArray:array()
    array:addObject(CCDelayTime:actionWithDuration( 3.0))
    array:addObject(CCShow:action())
    local action = CCSequence:actionsWithArray(array)
    self.btn_ok.view:runAction(action)
end 

-- 创建一个道具展示的 scroll panel_table_para: itemid 表 ， scroll的坐标和宽高， colu_num: 列数， sight_num:可见行数， bg_name:背景图片的名称
function FBResultWin:create_item_scroll( panel_table_para , pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
    local row_num = math.ceil( #panel_table_para / colu_num )
    if row_num < 2 then
        row_num = 2
    end
    local _scroll_info = { x = pos_x, y = pos_y, width = size_w, height = size_h, maxnum = row_num, image = bg_name, stype= TYPE_HORIZONTAL }
    local scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, _scroll_info.image, _scroll_info.stype )
    local had_add_t = {}
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
            local index = x * colu_num 
            local row_h = size_h / sight_num
            local bg_vertical = CCBasePanel:panelWithFile( 0, 0, size_w, row_h, "")
            local colu_with = size_w / colu_num
            for i = 1, colu_num do
                local bg = self:create_item_show_panel( panel_table_para[index + i], (i - 1) * colu_with, 0, colu_with, row_h , i)
                bg_vertical:addChild(bg)
            end

            scroll:addItem(bg_vertical)
            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

-- 创建一个道具
function FBResultWin:create_item_show_panel( panel_date, x, y, w, h , index)
    local bg = CCBasePanel:panelWithFile( x, y , w, h , nil )
    if panel_date == nil then
        return bg
    end
    local slot_w, slot_h = 64, 64
    local slot = SlotItem( slot_w, slot_h )
    slot:set_icon_bg_texture( UIPIC_ITEMSLOT, -4, -4, 72, 72 )   -- 背框
    slot:set_icon( panel_date.itemId )
    slot:setPosition( 6, 6 )
    slot:set_gem_level( panel_date.itemId )      -- 宝石的等级
    slot:set_color_frame( panel_date.itemId, -2, -2, 68, 68 )    -- 边框颜色
    local function item_click_fun ()
        ActivityModel:show_mall_tips( panel_date.itemId )
    end
    slot:set_click_event(item_click_fun)

    bg:addChild( slot.view )
    return bg
end

function FBResultWin:destroy()
     for i=1,#self.type_text_t do
        if self.type_text_t[i] then
            self.type_text_t[i]:destroy()
        end 
    end

    self._timer:stop()
    self._timer = nil

    self.type_text_t={}
    self.type_label_t={}
    if self.text_effect_cb then
        self.text_effect_cb:cancel()
        self.text_effect_cb = nil
    end 

    Window.destroy(self)
end

function FBResultWin:active(show)
    if self.exit_btn then
        self.exit_btn.view:setIsVisible(false)
    end 
end