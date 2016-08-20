-- OpenServerActivityWin.lua
-- created by fjh 2013-5-30 
-- 开服活动主界面

super_class.OpenServerActivityWin(NormalStyleWindow)


local _activity_index = 1;
local _first_selceted_bool = false;

local panel_award_h = 300
local cell_height = 100;

function OpenServerActivityWin:destroy( )
    if self.online_time then
        self.online_time:destroy();
        self.online_time = nil
    end
    if self.recharge_time_lab then
        self.recharge_time_lab:destroy()
        self.recharge_time_lab = nil
    end
    if self.seven_day_time_lab then
        self.seven_day_time_lab:destroy()
        self.seven_day_time_lab = nil
    end
    Window.destroy(self);
end


function OpenServerActivityWin:__init(  )
    -- 设定初始_activity_index
    _activity_index = 1

	-- 标题
    -- local win_title_bg = CCZXImage:imageWithFile(175, 535, 574, 80, UI_SclbWin_001)
    -- self.view:addChild(win_title_bg, 1000)
    -- local win_title = CCZXImage:imageWithFile(191, 22, 188, 58, UIResourcePath.FileLocate.openSer .. "open_serv_act(1).png")
    -- win_title_bg:addChild(win_title)

    -- 背景
    local page_bg = CCBasePanel:panelWithFile(10, 20, 880, 542, UILH_COMMON.normal_bg_v2, 500, 500)
    self.view:addChild(page_bg)

    -- 活动列表(左边)
    self:create_list_panel(page_bg)

    -- 活动预览(右边)
    self:create_detail_panel(page_bg)
end

function OpenServerActivityWin:create_detail_panel( parent )
    --活动详细
    local detail_panel = CCBasePanel:panelWithFile(246, 10, 615, 517, UILH_COMMON.bottom_bg, 500, 500)
    parent:addChild(detail_panel)
    self.detail_panel = detail_panel

    -- 活动介绍 
    local intro_panel = CCBasePanel:panelWithFile(0, 350, 598, 161, "", 500, 500)
    detail_panel:addChild(intro_panel)
    self.intro_panel = intro_panel

    -- 活动介绍标题底色
    local title_bg_l = CCBasePanel:panelWithFile(40, 90, -1, -1, UILH_OPENSER.title_bg)
    intro_panel:addChild(title_bg_l)
    local title_bg = CCBasePanel:panelWithFile(283, 90, -1, -1, UILH_OPENSER.title_bg)
    title_bg:setFlipX(true)
    intro_panel:addChild(title_bg)

    --活动title
    self.act_title = CCZXImage:imageWithFile(-92, 25, -1, -1, UILH_OPENSER.title_path .. 1 .. ".png")
    title_bg:addChild(self.act_title)

    -- 活动时间
    local lab = UILabel:create_lable_2( LH_COLOR[13] .. "活动时间:", 12, 80, 16, ALIGN_LEFT ); -- [1629]="#c38ff33活动时间:"
    intro_panel:addChild(lab);
    local str = OpenSerConfig:get_activity_time( _activity_index )
    self.act_time = UILabel:create_lable_2( str, 100, 80, 16, ALIGN_LEFT );
    intro_panel:addChild(self.act_time);

    -- 活动说明
    local lab_desc = UILabel:create_lable_2( LH_COLOR[13] .. "活动说明:", 12, 55, 16, ALIGN_LEFT )  -- [1630]="#c38ff33活动说明:"
    intro_panel:addChild(lab_desc);
    str = OpenSerConfig:get_activity_desc( _activity_index );
    self.act_desc = MUtils:create_ccdialogEx( intro_panel, str, 100, 73, 400, 20, 2, 16 )
    self.act_desc:setAnchorPoint( 0, 1 )

    -- 活动剩余时间
    local lab_time = UILabel:create_lable_2( LH_COLOR[13] .. "剩余时间:", 12, 10, 16, ALIGN_LEFT ); -- [1631]="#c38ff33剩余时间:"
    intro_panel:addChild(lab_time)
    self.left_time = UILabel:create_lable_2("", 100, 13, 16, ALIGN_LEFT)
    intro_panel:addChild(self.left_time)
    
    if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
      --开服活动
        local time = OpenSerModel:get_recharge_activity_time(  );

        local function finish_call(  )
            if self.recharge_time_lab then
              self.recharge_time_lab:setString( LH_COLOR[1] .. "活动已截止，请尽快领取所得奖励") -- [1632]="活动已截止，请尽快领取所得奖励"
            end
        end
        -- 充值奖励的倒计时
        self.recharge_time_lab = TimerLabel:create_label( intro_panel, 97, 10, 16, time, LH_COLOR[1], finish_call, false)  -- lyl ms

        if time <= 0 then
            finish_call()
        end
    elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
        self.left_time:setText( LH_COLOR[1] .. "封测期间"); -- [1633]="#c38ff33封测期间"

        -- cdkey
        self.cdkey_panel = CCBasePanel:panelWithFile( 12, 10, 530, 30, nil);
        intro_panel:addChild(self.cdkey_panel);
        self.cdkey_panel:setIsVisible(false);

        --提示只能领取一个礼包
        local lab_tip = UILabel:create_lable_2( "(每个账号仅限领取一个礼包)", 42+195, 10, 16, ALIGN_LEFT );  -- lyl ms -- [1634]="#cff0000(每个账号仅限领取一个礼包)"
        self.cdkey_panel:addChild(lab_tip);

        -- 在线时长
        self.online_panel = CCBasePanel:panelWithFile(12, 18, 300, 20, nil);
        intro_panel:addChild(self.online_panel);
        self.online_panel:setIsVisible(false);
        --提示只能领取一个礼包
        local lab_tip_line = UILabel:create_lable_2( "(此活动奖励需下线上线后才能领取)", 230, 0, 16, ALIGN_LEFT );  -- lyl ms -- [1635]="#cff0000(此活动奖励需下线上线后才能领取)"
        self.online_panel:addChild(lab_tip_line);
        local lab_online = UILabel:create_lable_2( "在线时长:", 0, 0, 16, ALIGN_LEFT ); -- [1636]="#c38ff33在线时长:"
        self.online_panel:addChild(lab_online);
    end

    -- 活动奖励预览
    self._award_title = CCBasePanel:panelWithFile( 0, panel_award_h+5, -1, -1, UILH_OPENSER.tips )
    detail_panel:addChild( self._award_title )

    -- 活动预览
    local preview_panel = CCBasePanel:panelWithFile(10, 10, 600, panel_award_h, "")
    detail_panel:addChild(preview_panel)

    -- 标题
    -- local fenchen = ZImageImage:create(detail_panel, UIResourcePath.FileLocate.openSer.."open_serv_act(2).png", UIResourcePath.FileLocate.forge.."lq_back_4.png", 28, 314, 540, -1, 500, 500);

    -- scrollView
    self.detail_scroll = CCScroll:scrollWithFile( 5, 0, 590, panel_award_h-10, 4, "", TYPE_HORIZONTAL, 600, 600 )
  
  --{ "1充值回馈","2展露头角", "3战力排行", "4等级排行",
      -- "5奇经八脉","6成就排行","7坐骑排行",
      -- "8灵灯排行","9最强军团", "10套装收集", "11军衔奖励" },
    local function scrollfun(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return false
        end
        -- print("---arg:", arg)
        local temparg = Utils:Split(arg,":")
        local row = temparg[1]  --列数
        if row == nil then 
            return false;
        end
        
        if eventType == SCROLL_CREATE_ITEM then
                  
            row = tonumber(row);
            -- 奖励的itemlist
            local awards = OpenSerModel:get_activity_config( _activity_index, row+1 );
            local data = { act_index = _activity_index, cell_index = row+1, award = awards,  };

            local style;
            if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
                if _activity_index == 1 then
                    --充值奖励、
                    -- style = OpSerActivityDetailCell.CELL_STYLE_DEFAULT;
                    style = OpSerActivityDetailCell.CELL_STYLE_CHONGZHI;
                    cell_height = 120
                    local max_lv, status = OpenSerModel:get_recharge_award_status( row+2 );
                    data.award_status = {max_lv,status};

                    -- print("-------award_status:", row, max_lv, status, data.award_status.max_lv, data.award_status.status)
                elseif _activity_index == 2 then
                    -- 崭露头角(修仙出成)
                    style = OpSerActivityDetailCell.CELL_STYLE_DEFAULT;
                    cell_height = 100
                    -- local xiuxian_award_list = OpenSerModel:get_xiuxian_award_list(  );
                    -- print("-------award_status:", xiuxian_award_list, #xiuxian_award_list)
                    -- print("-------award_status:", xiuxian_award_list[row+1])
                    -- print("-------award_status:", xiuxian_award_list[row+1].id, xiuxian_award_list[row+1].status)
                    -- if xiuxian_award_list then
                    --     data.award_status = {target_id = xiuxian_award_list[row+1].id, status = xiuxian_award_list[row+1].status };
                    -- end
                    -- style = OpSerActivityDetailCell.CELL_STYLE_DEFAULT;
                    -- cell_height = 100;
                    -- local has_award_, award_status = OpenSerModel:get_dujie_award(  );
                    local xiuxian_award_list = OpenSerModel:get_xiuxian_award_list(  );
                    if xiuxian_award_list then
                        -- print("-----------xiuxian_award_list[row+1].id--,",row, xiuxian_award_list[row+1].id, xiuxian_award_list[row+1].status )
                        data.award_status = xiuxian_award_list
                        -- data.award_status = {id = xiuxian_award_list[row+1].id, status = xiuxian_award_list[row+1].status };
                        -- print("-----data:", data.award_status.has_award, data.award_status.status )
                    end
                -- elseif _activity_index == 3 then

                --     style = OpSerActivityDetailCell.CELL_STYLE_DEFAULT;
                --     cell_height = 100;
                --     local target_id, award_status = OpenSerModel:get_guild_award(  );
                --     data.award_status = { target_id = target_id, status = award_status};

                -- elseif _activity_index == 4 then

                --     style = OpSerActivityDetailCell.CELL_STYLE_DEFAULT;
                --     cell_height = 100;
                --     local target_id, award_status = OpenSerModel:get_guild_award(  );
                --     data.award_status = { target_id = target_id, status = award_status};

                -- elseif _activity_index == 5 then

                --     style = OpSerActivityDetailCell.CELL_STYLE_DEFAULT;
                --     cell_height = 100;
                --     local target_id, award_status = OpenSerModel:get_guild_award(  );
                --     data.award_status = { target_id = target_id, status = award_status};

                -- elseif _activity_index == 9 then
                --     -- 家族大业
                --     style = OpSerActivityDetailCell.CELL_STYLE_GUILD;
                --     cell_height = 200;
                --     local lv,award_status = OpenSerModel:get_guild_award(  );
                --     data.award_status = { guild_lv = lv, status = award_status};

                elseif _activity_index > 2 and _activity_index < 9 then
                    --排行奖励
                    style = OpSerActivityDetailCell.CELL_STYLE_RANK;
                    cell_height = 100;
                    --是否上榜了 ,1表示上榜了，0表示没上榜
                    local has_award_ = OpenSerModel:get_rank_has_award(  );
                    has_award_ = Utils:get_bit_by_position( has_award_, _activity_index - 2 );
                    --上榜了的话，是否领取了，1为已经领取了
                    local award_status_ = OpenSerModel:get_rank_award_status(  );
                    award_status_ = Utils:get_bit_by_position( award_status_, _activity_index - 2 );
                    --榜单数据，10个人
    -- print("------------_activity_index:",(OpenSerModel:get_rank_award_dict())[_activity_index-2], _activity_index, row+1)
    local rank_data_ = ((OpenSerModel:get_rank_award_dict())[_activity_index-2])[row+1];

    data.award_status = {has_award = has_award_, award_status = award_status_, rank_data = rank_data_ };

                elseif _activity_index == 9 then
                    -- 仙盟奖励
                    style = OpSerActivityDetailCell.CELL_STYLE_GUILD;
                    cell_height = 200;
                    local lv,award_status = OpenSerModel:get_guild_award(  );
                    data.award_status = { guild_lv = lv, status = award_status};

                elseif _activity_index == 10 then
                    -- 套装收集、境界奖励
                    style = OpSerActivityDetailCell.CELL_STYLE_DEFAULT;
                    cell_height = 100;
                    local has_award_, award_status = OpenSerModel:get_suit_award(  );
                   
                    if has_award_ and award_status then
                        data.award_status = {has_award = has_award_, status = award_status };
                    end
                elseif _activity_index == 11 then
                    style = OpSerActivityDetailCell.CELL_STYLE_DEFAULT;
                    cell_height = 100;
                    local has_award_, award_status = OpenSerModel:get_dujie_award(  );
                    
                    if has_award_ and award_status then
                        data.award_status = {has_award = has_award_, status = award_status };
                    end
                end
            elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then

                style = OpSerActivityDetailCell.CELL_STYLE_DEFAULT;
                cell_height = 100;
                data.award_status = ClosedBateActivityModel:get_award_data_by_index( _activity_index );
                if _activity_index == 7 then
                  data.play_time_award_page = true 
                else
                  data.play_time_award_page = false
                end
            end

            local function get_award_event_1(  )
                --领奖按钮1
                self:click_get_award_btn_1( row + 1);
            end
            local function get_award_event_2(  )
                --领奖按钮2 在仙宗奖励才有这个按钮
               self:click_get_award_btn_2( row + 1); 
            end

            local cell = OpSerActivityDetailCell( style, 0, 0, 590, cell_height, data )
            cell:set_func_1(get_award_event_1);
            cell:set_func_2(get_award_event_2);

            self.detail_scroll:addItem( cell.view );
            self.detail_scroll:refresh( );   
        end
        return true
    end
    
    self.detail_scroll:registerScriptHandler(scrollfun)
    self.detail_scroll:refresh()
    preview_panel:addChild(self.detail_scroll);
end

function OpenServerActivityWin:create_list_panel( page_bg )
    -- 活动列表
    local list_panel = CCBasePanel:panelWithFile(10, 10, 232, 520, UILH_COMMON.bottom_bg, 500, 500);
    page_bg:addChild(list_panel);

    -- scrollView
    local btn_num = OpenSerConfig:get_activity_count()
    self.activity_scroll = CCScroll:scrollWithFile( 8, 10, 215, 500, 1, "", TYPE_HORIZONTAL, 600, 600 )

    local raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(0 ,0, 226, (92+4) * btn_num, nil)

    self.btn_sld = {}
    for i=1,btn_num do
        local function did_selected_act(  )
            _activity_index = i;
            self:selected_activity( _activity_index )
        end

        local act_button = self:create_a_button(0, 96 * (btn_num-i)+4, 215, 94, UILH_COMMON.bg_10, UILH_COMMON.bg_10, i, did_selected_act)
        raido_btn_group:addGroup(act_button)
    end

    self.activity_scroll:addItem(raido_btn_group)
    self.activity_scroll:refresh(  )
    list_panel:addChild(self.activity_scroll)
end

function OpenServerActivityWin:create_a_button(pos_x, pos_y, size_w, size_h, image_n, image_s, index, fn)
    -- local one_btn =  CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    -- one_btn:addTexWithFile(CLICK_STATE_DOWN, image_s)
    local one_btn = CCBasePanel:panelWithFile(pos_x, pos_y, size_w, size_h, image_n, 500, 500)
    -- one_btn:addTexWithFile(CLICK_STATE_DISABLE, image_s)
    self.btn_sld[index] = CCBasePanel:panelWithFile(0, 0, size_w, size_h, UILH_COMMON.select_focus, 500, 500)
    one_btn:addChild(self.btn_sld[index])
    self.btn_sld[index]:setIsVisible(false)

    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN  then 
            return true
        elseif eventType == TOUCH_CLICK then
            fn(index)
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        end
    end
    one_btn:registerScriptHandler(but_1_fun)    --注册

    -- 按钮内容
    local icon_img = OpenSerConfig:get_activity_icon( index )

    local function on_slot_click_fun()
        fn(index);
    end

    local slot_item = MUtils:create_one_slotItem_align( nil, 27, 16, 60, 60, 8 );
    -- local slot_item = MUtils:create_slot_item2( one_btn, UILH_COMMON.slot_bg, 27, 16, 83, 83, nil, on_slot_click_fun, 2);
    slot_item:set_icon_texture(icon_img)
    slot_item:set_select_effect_state(false)
    slot_item:set_click_event( on_slot_click_fun )
    one_btn:addChild(slot_item.view)

    -- 按钮标题
    -- local title_img = OpenSerConfig:get_activity_img_title( index )
    local title = ZImage.new( UILH_OPENSER.tips_path .. index .. ".png")
    title:setPosition(100, 25)
    one_btn:addChild(title.view)

    -- 获取主副标题
    local title_up, title_down = OpenSerConfig:get_activity_title( index )

    -- local activity_title_up = UILabel:create_lable_2( "#cfff000"..title_up, 100, 55, 18, ALIGN_LEFT )
    -- one_btn:addChild(activity_title_up)

    -- local activity_title_down = UILabel:create_lable_2( "#cffff00" .. title_down, 100, 20, 16, ALIGN_LEFT );
    -- one_btn:addChild(activity_title_down)

    return one_btn
end


----------------------------界面更新
function OpenServerActivityWin:active( show )
	
    if show then
        -- 每次重新显示开服活动节目总要更新一下奖励数据
        if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
            OpenSerModel:req_all_active_award(  )
        elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
            
            ClosedBateActivityModel:req_all_activity_award_status(  )
        end
        -- self:update_detail_scroll( _activity_index )
        self:selected_activity( 1 )
    end

end

function OpenServerActivityWin:update_detail_scroll( index )
    if index ~= 12 then
      self.detail_scroll:reinitScroll();
      -- print("媒体礼包个数", OpenSerConfig:get_activity_cell_count( index ) );
      self.detail_scroll:setMaxNum( OpenSerConfig:get_activity_cell_count( index ) );
      self.detail_scroll:refresh();
    end
end

function OpenServerActivityWin:update_online_time_label( time )
    if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
        if self.online_time then
            self.online_time:destroy();
        end
        self.online_time = TimerLabel:create_label( self.online_panel, 15, 20, 14, time, LH_COLOR[2], nil, true, ALIGN_LEFT, true);
    end
end


---------------------------操作逻辑

function OpenServerActivityWin:selected_activity( index )

    -- 选中效果
    for k,v in pairs(self.btn_sld) do
        v:setIsVisible(false)
    end
    self.btn_sld[index]:setIsVisible(true)

    -- 更新detail_scroll
    if index ~= 12 then
        self:update_detail_scroll( index )

        -- 活动描述 & 开服时间
        self.act_desc:setText( LH_COLOR[2] .. OpenSerConfig:get_activity_desc( index ) );
        self.act_time:setText( LH_COLOR[2] .. OpenSerConfig:get_activity_time( index ) );

        if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
            if _activity_index ~= 1 then
                --获取为期7天的活动剩余时间
                local time = OpenSerModel:get_seven_day_act_time( );

                if self.seven_day_time_lab == nil then
                    self.seven_day_time_lab = TimerLabel:create_label( self.intro_panel, 97, 10, 16, time, LH_COLOR[1], nil, false);
                else
                    self.seven_day_time_lab:setIsVisible(true);
                    self.seven_day_time_lab:setText(time);
                end

                if time <= 0 then
                    self.seven_day_time_lab:setString( LH_COLOR[1] .. "活动已截止，请尽快领取所得奖励" )
                end

                if self.recharge_time_lab then
                    self.recharge_time_lab:setIsVisible(false);
                    self.left_time:setIsVisible(false)
                end
            else
                -- 充值回馈活动是为期5天的
                local time = OpenSerModel:get_recharge_activity_time(  )

                self.recharge_time_lab:setIsVisible(true);
                self.recharge_time_lab:setText(time);

                if self.seven_day_time_lab then
                    self.seven_day_time_lab:setIsVisible(false);
                    self.left_time:setIsVisible(false)
                end

                if time <= 0 then
                    self.recharge_time_lab:setString( LH_COLOR[1] .. "活动已截止，请尽快领取所得奖励" );
                end
            end
        elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
            if index == 2 then
                -- 显示cdkey激活框
                self.cdkey_panel:setIsVisible(true);
            else
                self.cdkey_panel:setIsVisible(false);
            end

            if index == 7 then
                -- 显示在线时长
                self.online_panel:setIsVisible(true);
            else
                self.online_panel:setIsVisible(false);
            end
        end

        -- 更改标题
        local img = OpenSerConfig:get_activity_img_title( index )
        self.act_title:setTexture(img);

        if self.xsqg_img then
            self.xsqg_img:setIsVisible(false);
        end
    else
        self.detail_scroll:clear();

        if self.xsqg_img then
            self.xsqg_img:setIsVisible(true);
        else
            self.xsqg_img = CCBasePanel:panelWithFile(0, 20, -1, -1, "ui/openser/xsqg_bg.jpg");
            self.detail_panel:addChild(self.xsqg_img)
            local function go_to_shangcheng(eventType)
                if eventType == TOUCH_CLICK then
                    UIManager:show_window("mall_win");
                end
                return true;
            end
            --前去抢购按钮
            local btn = MUtils:create_btn(self.xsqg_img,UIResourcePath.FileLocate.openSer .. "buy.png",nil,go_to_shangcheng,418,10,110,41,1,39,19,39,19,39,19,39,19);
            --MUtils:create_sprite(btn,nil,50,20.5)
        end
    end
end


-- 领奖按钮 1
function OpenServerActivityWin:click_get_award_btn_1( cell_index )
    if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_OPEN then
        if _activity_index == 1 then
            --充值奖励
            WelfareModel:get_recharge_award( cell_index );
        elseif _activity_index == 2 then

            OpenSerModel:req_get_xiuxian_award( cell_index );
            -- OpenSerModel:req_get_dujie_award( cell_index-1  );
        -- elseif _activity_index == 3 then
        --     -- 最强家族
        --     OpenSerModel:req_get_guild_award( 1 );
        elseif _activity_index > 2 and _activity_index < 9 then

            OpenSerModel:req_get_rank_award( _activity_index - 2 );

        elseif _activity_index == 9 then
            --成员领奖，发0
            OpenSerModel:req_get_guild_award( 1 );

        elseif _activity_index == 10 then
            -- 领取奖励的索引， 0到2，所以减 1
            OpenSerModel:req_get_suit_award( cell_index-1 );
        elseif _activity_index == 11 then
            OpenSerModel:req_get_dujie_award( cell_index-1  );
        end
    elseif OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then

        if _activity_index == 1 then
            -- 修仙初成
            ClosedBateActivityModel:req_get_xiuxian_award( cell_index );
        elseif _activity_index == 2 then
            --封测礼包
          -- local cur_player = EntityManager:get_player_avatar()
          -- if cur_player.level >= 30 then
            ClosedBateActivityModel:get_meitilibao( cell_index );
          -- else
          --   GlobalFunc:create_screen_notic("礼包要30级才能领取")
          --   return false
          -- end
        elseif _activity_index == 3 then
            --等级奖励
            ClosedBateActivityModel:req_get_level_award( cell_index )
        elseif _activity_index == 4 then
            -- 登录奖励
            ClosedBateActivityModel:req_get_login_award( cell_index )
        elseif _activity_index == 5 then
            --时段奖励
            ClosedBateActivityModel:req_get_online_period_award( cell_index )
        elseif _activity_index == 6 then
            --活跃度奖励
            ClosedBateActivityModel:req_get_activity_award( cell_index )
        elseif _activity_index == 7 then
            --在线时长奖励
            ClosedBateActivityModel:req_get_online_duration_award( cell_index )
        end
    end
end

function OpenServerActivityWin:click_get_award_btn_2( cell_index )
    --调这个按钮的，一定是仙盟奖励
    if _activity_index == 9 then
        --盟主领奖，发1
        OpenSerModel:req_get_guild_award( 0 );
    end
end

function OpenServerActivityWin:force_update_scroll()
  self:selected_activity( _activity_index )
end
