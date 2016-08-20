-- BigActivityWin.lua
-- created by hcl 2013-12-19
-- 大活动面板

super_class.BigActivityWin(NormalStyleWindow);

-- 子面板的类型
local ACTIVITY_SUB_TYPE_1 = 1; 
local ACTIVITY_SUB_TYPE_2 = 2; 
local ACTIVITY_SUB_TYPE_3 = 3; 
local ACTIVITY_SUB_TYPE_4 = 4; 
local ACTIVITY_SUB_TYPE_5 = 5; 
-- 子活动对应的标签文字
local EXPAND_PARAM_TITLE = { [1] = "#cd0cda2登录天数:#cffffff",[2] = "#cd0cda2充值元宝:#cffffff",[3] = "#cd0cda2消费元宝:#cffffff",[9] = "#cd0cda2今日充值元宝:#cffffff",[10] = "#c66ff66消费元宝#cffffff" };
local scroll_panel = {x = 0, y = 0, width = 588+35, height = 131}
function BigActivityWin:show( activity_id )
    local win = UIManager:show_window("big_activity_win")
    if win then
        win.activity_id = activity_id;
        win:update_view()
    end
end

function BigActivityWin:destroy( )
     self.slot_item_array = {}
    if self.online_time then
      self.online_time:destroy();
    end
    if self.recharge_time_lab then
      self.recharge_time_lab:destroy();
      self.recharge_time_lab = nil;
    end
    Window.destroy(self);
end

local LEFT_SCROLL_ITEM_WIDTH = 220;
local RIGHT_SCROLL_ITEM_WIDTH = 598+20;

function BigActivityWin:__init(  )

  local bg_size = self.view:getSize()                           
  --页面总底板
  ZImage:create(self.view, UILH_COMMON.normal_bg_v2, 10,20, 880,542, 0, 500, 500)
  self.slot_item_array = {}
self.btn_lab = {}
  --左边活动列表背景================================================================================
  local list_panel = CCZXImage:imageWithFile(20, 31, 232, 520,UILH_COMMON.bottom_bg,500,500);
	self:addChild(list_panel);    

	-- 左边的scroll里面只装一个ZRadioButtonGroup
  self.activity_scroll = CCScroll:scrollWithFile( 25, 42, LEFT_SCROLL_ITEM_WIDTH, 500, 0, "", TYPE_HORIZONTAL, 600, 600 )

  local function scrollfun(eventType, arg, msgid)
      if eventType == nil or arg == nil or msgid == nil then
          return false
      end
      local temparg = Utils:Split(arg,":")
      local row = temparg[1]  --列数
      if row == nil then 
          return false;
      end
      row = tonumber(row) + 1;
      if eventType == SCROLL_CREATE_ITEM then
			    local panel = self:create_activity_scroll_item(row)
    			self.activity_scroll:addItem( panel );
          self.activity_scroll:refresh();
      end
      return true
  end
  
  self.activity_scroll:registerScriptHandler(scrollfun)
  self.activity_scroll:refresh()
  self:addChild(self.activity_scroll);




	--右边活动详情背景============================================================================================
  local detail_panel = CCBasePanel:panelWithFile( 257-7, 33, 615+15, 517, UILH_COMMON.bottom_bg,500,500)
  self.view:addChild(detail_panel)
  -- 活动奖励预览
  ZImage:create(detail_panel,UILH_OPENSER.tips,5,272,-1,-1);
  ZImage:create(detail_panel,UILH_COMMON.split_line,5,267,570,1);
  -- scrollView
  self.detail_scroll = CCScroll:scrollWithFile( 6, 5, RIGHT_SCROLL_ITEM_WIDTH, 257, 3, "", TYPE_HORIZONTAL, 600, 600 )
  
  local function scrollfun2(eventType, arg, msgid)
      if eventType == nil or arg == nil or msgid == nil then
          return false
      end

      local temparg = Utils:Split(arg,":")
      local row = temparg[1]  --行
      if row == nil then 
          return false;
      end
      
      if eventType == SCROLL_CREATE_ITEM then
          row = tonumber(row) + 1;
          if self.data then 
      			local panel = self:create_scroll_item(row);
            self.detail_scroll:addItem( panel.view );
    	      self.detail_scroll:refresh( );   
            return false
          end
      end
  end
    
  self.detail_scroll:registerScriptHandler(scrollfun2)
  self.detail_scroll:refresh()
  detail_panel:addChild(self.detail_scroll);

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
    self.act_title = CCZXImage:imageWithFile(-92, 25, -1, -1, UILH_OPENSER.title_img[1])
    title_bg:addChild(self.act_title)


    -- 活动时间
    local lab = UILabel:create_lable_2( LH_COLOR[5] .. "活动时间:", 12, 80, 16, ALIGN_LEFT ); -- [1629]="#c38ff33活动时间:"
    intro_panel:addChild(lab);
    -- local str = OpenSerConfig:get_activity_time( _activity_index )
    local timeStr = SmallOperationModel:getActivityTimeDescEx(self.activity_id) or ""
    self.act_time = UILabel:create_lable_2( timeStr, 100, 80, 16, ALIGN_LEFT );
    intro_panel:addChild(self.act_time);

 -- 活动说明
    local lab_desc = UILabel:create_lable_2( LH_COLOR[5] .. "活动说明:", 12, 55, 16, ALIGN_LEFT )  -- [1630]="#c38ff33活动说明:"
    intro_panel:addChild(lab_desc);
    str = OpenSerConfig:get_activity_desc( _activity_index );
    self.act_desc = MUtils:create_ccdialogEx( intro_panel, str, 100, 73, 400, 20, 2, 16 )
    self.act_desc:setAnchorPoint( 0, 1 )

  -- 活动剩余时间
    local lab_time = UILabel:create_lable_2( LH_COLOR[5] .. "剩余时间:", 12, -10, 16, ALIGN_LEFT ); -- [1631]="#c38ff33剩余时间:"
    intro_panel:addChild(lab_time)

  -- 附加参数的标题
  self.expand_param_title = ZLabel:create(self.view,"",723,320,16,1);

  -- 查看排名按钮===============================================================================
  -- local function show_top_player()
  --     local paihang_id = self:get_activity_sub_data( self.select_index ).top_type;
  --     local rand_data_t = BigActivityModel:get_rank_data( self.activity_id ,paihang_id)
  --     local info_tab = nil;
  --     -- 天元之战的数据有些不同
  --     if self.data.activity_sub_id == 995 then
  --         info_tab = rand_data_t.guild_names;
  --     else 
  --         info_tab = rand_data_t;
  --     end
  --     if info_tab and #info_tab > 0 then
  --         local str = BigActivityModel:create_rank_str( info_tab )
  --         HelpPanel:show(4,UILH_COMMON.title_bg,str)
  --     else
  --        GlobalFunc:create_screen_notic( "名单将在活动结束后发布" )
  --     end
  -- end
  -- self.show_top_player_btn = ZImageButton:create(self.view, {UILH_COMMON.button3,UILH_COMMON.button3}, UILH_COMMON.bg_10, show_top_player, 618+10,347-10-25-40);
    -- 查看排名按钮===============================================================================
  -- 奖励按钮要保存下来
  self.award_btn_tab = {};
end


----------------------------界面更新
function BigActivityWin:active( show )
	
    if show then
   
    end
end


function BigActivityWin:update_online_time_label( time )
    if OpenSerModel:get_activity_type() == OpenSerModel.ACTIVITY_TYPE_CLOSE_TEST then
        if self.online_time then
            self.online_time:destroy();
        end
        self.online_time = TimerLabel:create_label( self.online_panel, 83, 3, 16, time, "#c33ff33", nil, true, ALIGN_LEFT, true);

    end
end


---------------------------操作逻辑

function BigActivityWin:selected_activity( index )
 for i=1,#self.slot_item_array do
  if i == index then
    if self.slot_item_array[i].select_frame then
       self.slot_item_array[i].select_frame:setIsVisible(true)
      end
  else
    if  self.slot_item_array[i].select_frame then
        self.slot_item_array[i].select_frame:setIsVisible(false)
      end
  end
end


    self.data = self:get_activity_sub_data( index );
    self.select_index = index;
    -- 更新右上角的面板
    self:update_right_top_panel();
    -- 更新scrollview
    self.detail_scroll:reinitScroll();
    self.detail_scroll:setMaxNum( 1 );
    self.detail_scroll:refresh(); 
end


-- 选中左边选项时更新右上角的面板
function BigActivityWin:update_right_top_panel()

    -- 更新活动描述
    self.act_desc:setText( self.data.content );

    -- 更新活动时间
    local timeStr = SmallOperationModel:getActivityTimeDescEx(self.activity_id) or ""
    if self.act_time then
    self.act_time:setText( timeStr );
    end

    -- 更新标题
    if self.data.title_img_path then
      self.act_title:setTexture(self.data.title_img_path);
    end

    -- 清除附加信息
    self.expand_param_title:setText("")

    -- 特殊处理，运营要求某些子活动要显示全面板的宣传图
    -- if self.xuanchuantu then
    --    self.xuanchuantu.view:removeFromParentAndCleanup(true);
    --    self.xuanchuantu = nil;
    -- end
    -- if self.activity_sub_type == ACTIVITY_SUB_TYPE_3 then
    --    local img_path = string.format("ui/openser/%s",self.data.img[1]);
    --     -- ZImage:create(panel.view,img_path,0,0);   
    --    self.xuanchuantu = ZImage:create(self.view,img_path,200,20);
    -- end

    -- 子活动id6是排名活动，需要特殊显示一个排名按钮
    -- if self.data.activity_sub_id == 6 or self.data.activity_sub_id == 997 or self.data.activity_sub_id == 995 then
        
    --     self.show_top_player_btn.view:setIsVisible(true);
    -- else
    --     self.show_top_player_btn.view:setIsVisible(false);
    -- end
end


-- 取得子活动面板的数据
function BigActivityWin:get_activity_sub_data( index )
  -- print("self.activity_id   index",self.activity_id,index)
    local data = SmallOperationModel:get_data( self.activity_id )[index]
    local activity_sub_id = data.activity_sub_id;
    -- print("BigActivityWin:get_activity_sub_data( index )",activity_sub_id);
    -- 请求领奖状态数据
    if activity_sub_id  then
        if activity_sub_id <= 10 then
          if activity_sub_id == 6 then
              local paihang_id = data.top_type;
              OnlineAwardCC:req_get_activity_rank_com( self.activity_id ,paihang_id)
          else
              BigActivityModel:req_activity_data( self.activity_id, activity_sub_id );
          end
          self.activity_sub_type = ACTIVITY_SUB_TYPE_1;
        else 
          -- 圣诞送礼活动(对应协议 138,96)
          if activity_sub_id == 24 then
            BigActivityModel:req_sdsl_data(  )
            self.activity_sub_type = ACTIVITY_SUB_TYPE_1; 
          -- 995:合服天元之战活动(对应协议　149,7)
          elseif activity_sub_id == 994 then --清明节 --add by liuguowang
            self.activity_sub_type = ACTIVITY_SUB_TYPE_5;
          elseif activity_sub_id == 995 then
            OtherActivitiesCC:req_tyzz_info(  )
            self.activity_sub_type = ACTIVITY_SUB_TYPE_1;
          -- 996:合服首冲活动(对应协议　149,5)
          elseif activity_sub_id == 996 then
            OtherActivitiesCC:req_recharge_gift_info(  )
            self.activity_sub_type = ACTIVITY_SUB_TYPE_1; 
          -- 997:合服阵营试炼活动(对应协议　149,3)
          elseif activity_sub_id == 997 then
            OtherActivitiesCC:req_camp_battle_rank_info( )
            self.activity_sub_type = ACTIVITY_SUB_TYPE_1; 
          -- 998:合服登录活动(对应协议　149,1)
          elseif activity_sub_id == 998 then
            OtherActivitiesCC:req_login_gift()
            self.activity_sub_type = ACTIVITY_SUB_TYPE_1; 
          -- 999:情人元宵活动(对应协议 151,2)  
          elseif activity_sub_id == 999 then
            QingrenjieCC:req_award_state();
            self.activity_sub_type = ACTIVITY_SUB_TYPE_1;  
          elseif activity_sub_id == 1000 then
            self.activity_sub_type = ACTIVITY_SUB_TYPE_2;
          elseif activity_sub_id == 1001 then
            self.activity_sub_type = ACTIVITY_SUB_TYPE_3;
          elseif activity_sub_id >1001 then
            self.activity_sub_type = ACTIVITY_SUB_TYPE_4;
          end
        end
    end
    
    return data;
end

-- 创建scroll的item
function BigActivityWin:create_scroll_item(  )

    local panel = nil;    
    local item_count = #self.data;
    -- 清除掉上一次的奖励按钮
    self.award_btn_tab = {};
    if self.activity_sub_type == ACTIVITY_SUB_TYPE_1 then

        local each_h = scroll_panel.height
        local height = each_h * item_count
        panel = ZBasePanel:create(nil,"", 0, 0,548, height);
        for i=1,item_count do
            local y = height - i*each_h;
            local sub_panel = ZBasePanel:create(panel.view,"",scroll_panel.x,y,scroll_panel.width,scroll_panel.height,0,500,500);

        --创建子项标题背景
            ZImage:create(sub_panel,UILH_NORMAL.title_bg4, 30, 95, 300,-1)
        --创建子项标题
            local title = ZLabel:create(sub_panel.view,LH_COLOR[2]..self.data.title[i], 175,103,16);
            title.view:setAnchorPoint(CCPointMake(0.5,0))
            local award_count = #self.data[i]
            for j=1,award_count do
                local slot_item_info = self.data[i][j];
                  --计算横坐标
                local t_awardX = 3 + (j - 1) * 65
                local t_award = slot_item_info
                local t_awardId = t_award.id
                local slot_width  = 60
                local slot_height = 60
                local t_awardSlot = SlotItem(slot_width, slot_height)               --创建slotitem  
                t_awardSlot:set_icon_bg_texture( UILH_COMMON.slot_bg2, -6, -6, 70, 70 )
                t_awardSlot:setPosition(t_awardX, 20)
                t_awardSlot:set_icon(t_awardId)
                t_awardSlot:set_color_frame(t_awardId, -1, -1, 60, 60);
                --设置回调单击函数
                    local function f1( ... )
                        if ( t_awardId ) then 
                            local a, b, arg = ...
                            local click_pos = Utils:Split(arg, ":")
                            local world_pos = t_awardSlot.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
                            TipsModel:show_shop_tip( world_pos.x, world_pos.y, t_awardId );
                        end
                        
                    end
                    t_awardSlot:set_click_event( f1 )
                --设置道具数量
                local t_awardCount = t_award.count
                t_awardSlot:set_item_count(t_awardCount)
                sub_panel.view:addChild(t_awardSlot.view)
            end

            local function get_award(eventType, arg, msgid, selfitem)

                if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
                    return
                end
                if eventType == TOUCH_BEGAN then
                     
                          if self.data.activity_sub_id <= 10 then
                                if self.data.activity_sub_id == 6 then
                                  local award_data = BigActivityModel:get_rank_data( self.activity_id ,self.data.top_type)
                                  local index = BigActivityWin:get_award_index( award_data )
                                  BigActivityModel:req_get_award( self.activity_id, self.data.activity_sub_id, index ,self.data.top_type)
                                else
                                  BigActivityModel:req_get_award( self.activity_id, self.data.activity_sub_id, i )
                                end
                          elseif self.data.activity_sub_id == 24 then
                                OnlineAwardCC:req_get_sdsl_data( i )
                          elseif self.data.activity_sub_id == 995 then
                                if i == 1 then
                                  -- 第一个参数 领取奖励类型    0成员奖励 1第一名宗主奖励 
                                  -- 第二个参数 仙宗排名
                                  OtherActivitiesCC:req_get_tyzz_award( 1,i )
                                else
                                  local award_data = BigActivityModel:get_rank_data( self.activity_id ,15)
                                  local can_get_award_index = self:get_tyzz_my_award_index( award_data )
                                  OtherActivitiesCC:req_get_tyzz_award( 0,can_get_award_index )
                                end
                          elseif self.data.activity_sub_id == 996 then
                                OtherActivitiesCC:req_recharge_gift()
                          elseif self.data.activity_sub_id == 997 then
                                local data = BigActivityModel:get_rank_data( self.activity_id ,14)
                                local index = BigActivityWin:get_award_index( data )
                                if index~=nil then
                                    if index >0 then
                                      OtherActivitiesCC:req_camp_battle_rank__award( index )
                                    else
                                        GlobalFunc:create_screen_notic("领取索引有错")
                                    end
                                end
                          elseif self.data.activity_sub_id == 998 then
                                OtherActivitiesCC:req_get_login_gift_award()
                          elseif self.data.activity_sub_id == 999 then
                               QingrenjieCC:req_flower_award( i )
                          end
                    return true;
                elseif eventType == TOUCH_CLICK then
                    return true;
                end
                return true;
            end

            self.award_btn_tab[i] = MUtils:create_btn( sub_panel.view,
                UILH_COMMON.lh_button_4_r, 
                UILH_COMMON.lh_button_4_r, 
                get_award, 520, 29,-1,-1 )
            self.award_btn_tab[i]:setScale(0.8)

            self.award_btn_tab[i]:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)
            self.award_btn_tab[i]:setCurState( CLICK_STATE_DISABLE )
            self.btn_lab[i] = MUtils:create_zximg(self.award_btn_tab[i], UI_WELFARE.lingqu, 36, 15, -1, -1)

            --分割线
            ZImage:create(sub_panel.view,UILH_COMMON.split_line,5,0,570,1);
        end
    elseif self.activity_sub_type == ACTIVITY_SUB_TYPE_5 then --清明节聚宝盆
        panel = ZBasePanel:create(nil,"", 0, 0,RIGHT_SCROLL_ITEM_WIDTH, 240);
        for i=1,item_count do
            local slot_item_info = self.data[i];
            local slot_item = MUtils:create_slot_item(panel.view,UILH_COMMON.slot_item,40 + (i-1)%6*80 ,160 - math.floor((i-1)/6)*80,60,60,slot_item_info.id);
            slot_item:set_item_count(slot_item_info.count)
            slot_item:play_activity_effect();            
        end
        local function ljqw()--立即前往  ，打开聚宝台窗口
          local time = SmallOperationModel:get_act_time( 35 ); --聚宝袋 活动id=35
          print("time=",time)
          if time ~= nil and time > 0 then
            UIManager:show_window("jubao_bag_win")
          else
            GlobalFunc:create_screen_notic("活动已结束")
          end
        end
        ZImageButton:create(panel.view,{UILH_COMMON.button3,UILH_COMMON.button3}, UILH_COMMON.bg_10,ljqw,202,10)
    elseif self.activity_sub_type == ACTIVITY_SUB_TYPE_4 then
        panel = ZBasePanel:create(nil,"", 0, 0,RIGHT_SCROLL_ITEM_WIDTH, 240);
        for i=1,item_count do
            local slot_item_info = self.data[i];
            local slot_item = MUtils:create_slot_item(panel.view,UILH_COMMON.slot_item,40 + (i-1)%6*80 ,160 - math.floor((i-1)/6)*80,60,60,slot_item_info.id);
            slot_item:set_item_count(slot_item_info.count)
            slot_item:play_activity_effect();            
        end


        if self.data.npc_pos then
            local function ljqw()
                local npc_pos = self.data.npc_pos;
                GlobalFunc:move_to_target_scene( npc_pos.sceneid,npc_pos.x*SceneConfig.LOGIC_TILE_WIDTH,npc_pos.y *SceneConfig.LOGIC_TILE_HEIGHT)
                -- GlobalFunc:ask_npc( self.data.sceneid,self.data.x,self.data.y  )
                -- if npc_pos.name ~= nil then
                --   npc_pos.name = "清明节副本"
                --   AIManager:ask_npc(npc_pos.sceneid,npc_pos.name)
                -- end 

            end
            ZImageButton:create(panel.view,{UILH_COMMON.button3,UILH_COMMON.button3}, UILH_COMMON.bg_10,ljqw,320,10)
            local function ljcs()
                local npc_pos = self.data.npc_pos;
                GlobalFunc:teleport_to_target_scene( npc_pos.sceneid,npc_pos.x,npc_pos.y ) 
                if npc_pos.name ~= nil then--拉起对话面板
                  AIManager:set_after_pos_change_command( npc_pos.sceneid , AIConfig.COMMAND_ASK_NPC, npc_pos.name  ); 
                
                end 
            end
            ZImageButton:create(panel.view,{UILH_COMMON.button3,UILH_COMMON.button3}, UILH_COMMON.bg_10,ljcs,100,10)
        end
    elseif self.activity_sub_type == ACTIVITY_SUB_TYPE_2 then
        panel = ZBasePanel:create(nil,"", 0, 0,RIGHT_SCROLL_ITEM_WIDTH, 240);
        local count = #self.data.str;
        for i=1,count do
            ZLabel:create(panel.view,self.data.str[i],10,240 - i*40,16,1);
        end
    elseif self.activity_sub_type == ACTIVITY_SUB_TYPE_3 then
        panel = ZBasePanel:create(nil,"", 0, 0,RIGHT_SCROLL_ITEM_WIDTH, 240);
        -- print("self.data.img[1]",self.data.img[1])
        -- local img_path = string.format("ui/openser/%s",self.data.img[1]);
        -- ZImage:create(panel.view,img_path,0,0);     
    end
    return panel;
end






-- 创建左边下拉选框
function BigActivityWin:create_activity_scroll_item(index)
      -- 取得活动标题信息
    self.activity_title_info = self:get_activity_info();
    local item_count = #self.activity_title_info;
    local int_h = 100
    local panel_height = int_h *item_count
    local t_panelBg = ZBasePanel:create(nil, "", 0, 0, 220, panel_height, 0, 500, 500)
    local beg_y = 0
              --功能：滑动框的子项视图动作
              local function scroll_item_view_action(self,itemIndex,eventType)
                --如果是删除事件，删除相对应滑动框的玩家名字和玩家充值UI
                if eventType == ITEM_DELETE and self._currentIndex == itemIndex then
                  self._selectActivitySlot = nil
                end
              end

              local function scroll_item_click(self,activitySlot,itemIndex,eventType)
                  --点击事件
                      --保存当前导航图标
                    self._selectActivitySlot = activitySlot
                    --切换点击页
                    self:selected_activity( itemIndex )
                    -- end
                end

          --解析子项导航数据
          for i, v in ipairs(self.activity_title_info) do
                local t_directlyData = self.activity_title_info[i]
                --创建视图背景
                local t_viewBg = ZBasePanel:create(nil,"",3,0,220, 100)
                t_viewBg.view:registerScriptHandler(bind(scroll_item_view_action,self,itemIndex))
                --创建子行背景
                local t_itemBg = CCBasePanel:panelWithFile(3,0,215,95, UILH_COMMON.bg_10,500,500)
                t_viewBg.view:addChild(t_itemBg)
                --创建子活动图标
                local item = MUtils:create_slot_item2(t_viewBg,UILH_COMMON.slot_bg,15,12,72,72,nil,nil,9.5);
                item:set_icon_texture( t_directlyData.iconPath,  -8, -8, 80, 80 )
                --选中框t_directlyScroll
                t_viewBg.select_frame = MUtils:create_zximg(t_viewBg,UILH_COMMON.select_focus2, -2, -5, 223, 103);
                t_viewBg.select_frame:setIsVisible(false)
                local function click_event( eventTpye )
                    scroll_item_click(self,item,i,eventType); 
                    return true;
                end
                item:set_click_event(click_event);
                  -- t_viewBg 触发事件
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
                --如果当前创建的索引等于当前索引，使图标表现动态,使按钮呈现高亮状态，保存选中图标
                if i == self._currentIndex then
                   t_viewBg.select_frame:setIsVisible(true)
                end
                self.slot_item_array[i] = t_viewBg
                t_panelBg:addChild(t_viewBg.view)
                t_viewBg.view:setPosition(0, panel_height - i * int_h)
          end
    return t_panelBg.view
end

-- 取得活动描述信息
function BigActivityWin:get_activity_info()
    local data = SmallOperationModel:get_data( self.activity_id )
    return data.mini_title;
end
-- 更新界面
function BigActivityWin:update_view()
    self.activity_scroll:reinitScroll();
    self.activity_scroll:setMaxNum( 1 );
    self.activity_scroll:refresh(); 
    self:selected_activity( 1 ) 

    if self.recharge_time_lab then 
        self.recharge_time_lab:destroy();
        self.recharge_time_lab = nil;
    end
    local time = SmallOperationModel:get_act_time( self.activity_id );
    print("time",time);
    local function finish_call(  )
        if self.recharge_time_lab then
          self.recharge_time_lab:setString("活动已截止，请尽快领取所得奖励")
        end
    end
    if time~=nil  then
    -- 充值奖励的倒计时
      self.recharge_time_lab = TimerLabel:create_label( self.view, 359, 373 , 16, time, nil, finish_call, false);  -- lyl ms
        if time <= 0 then
        finish_call();
         end     

    end

  
end
-- 根据服务器下发的奖励信息来更新按钮状态
function BigActivityWin:update_get_award_btn_state( award_data )
  if award_data then
    print("award_data存在  self.data.activity_sub_id ", self.data.activity_sub_id )
      if self.data.activity_sub_id <= 10 then
        -- 活动6是排行奖励，服务器下发的奖励数据与其他活动不同
        if self.data.activity_sub_id == 6 then
            local self_award_state,index = self:get_award_index_data( award_data  )
            if self_award_state then 
                self:set_btn_state( self.award_btn_tab[index],index,self_award_state )
            end
        elseif self.data.activity_sub_id == 9 then
              for i=1, #self.award_btn_tab do --had_get_record
                  local state = award_data.had_get_record[i]
                  -- if state == 0 then  --不能领取
                  -- elseif state == 1 then--能领取
                  -- elseif state == 2 then--已领取
                  print("state=",state)
                  if state >= 1 then
                    state = 1
                  end 
                  self:set_btn_state( self.award_btn_tab[i],i,state)
              end
              print("self.data.activity_sub_id",self.data.activity_sub_id)
              if award_data.arg then 
                local title = EXPAND_PARAM_TITLE[ self.data.activity_sub_id ];
                self.expand_param_title:setText(title..award_data.arg)
              end
        else
            for i=1,#self.award_btn_tab do
              -- 是否可以领取
              local can_get_record = Utils:get_bit_by_position( award_data.can_get_record, i );
              -- 是否领取过了
              local had_get_record = Utils:get_bit_by_position( award_data.had_get_record, i );
              print("can_get_record,had_get_record",can_get_record,had_get_record,self.award_btn_tab[i],i)
              if can_get_record == 0 then
                  self:set_btn_state( self.award_btn_tab[i],i,0 )
              else
                -- 已达到
                if had_get_record == 0 then
                    -- 未领取
                    self:set_btn_state( self.award_btn_tab[i],i,1 )
                elseif had_get_record == 1 then
                    --已经领取
                    self:set_btn_state( self.award_btn_tab[i],i,2 )
                end
              end
            end
            if award_data.arg then 
              local title = EXPAND_PARAM_TITLE[ self.data.activity_sub_id ];
              self.expand_param_title:setText(title..award_data.arg)
            end
        end
      elseif self.data.activity_sub_id == 24 or self.data.activity_sub_id == 999 
        or self.data.activity_sub_id == 998 or self.data.activity_sub_id == 996 then
            for i=1,#self.award_btn_tab do
                print("award_data[i]",award_data[i])
                --0不可领取1可领取2已领取
                self:set_btn_state( self.award_btn_tab[i],i,award_data[i] )
            end
      -- 997:合服阵营试炼活动(对应协议　149,3)
      elseif self.data.activity_sub_id == 997 then
            local self_award_state,index = self:get_award_index_data( award_data  )
            if self_award_state then 
                self:set_btn_state( self.award_btn_tab[index],index,self_award_state )
            end
      -- -- 995:合服天元之战活动(对应协议　149,7)
      elseif self.data.activity_sub_id == 995 then
          local zongzhu_award_state = Utils:get_bit_by_position( award_data.guild_master_award_state, 1 ); 
          -- 第0位表示是否有这个奖励 0没有 1有
          self:set_btn_state( self.award_btn_tab[1],1,zongzhu_award_state )
          -- 第1位表示是否已领取这个奖励 0没有 1有
          zongzhu_award_state = Utils:get_bit_by_position( award_data.guild_master_award_state, 2 );
          if zongzhu_award_state == 1 then
              self:set_btn_state( self.award_btn_tab[1],1,2 )
          end
          -- 1-10位的仙宗成员奖励
          -- 自己能领的奖励索引 
          local can_get_award_index,had_get_award = self:get_tyzz_my_award_index( award_data )
          print("can_get_award_index",can_get_award_index,had_get_award)
          if can_get_award_index ~= 0 then 
            local index = self:get_index( can_get_award_index )
            for i=1,3 do
                if i == index then
                    self:set_btn_state( self.award_btn_tab[i+1],i+1,had_get_award + 1 )
                else
                    self:set_btn_state( self.award_btn_tab[i+1],i+1,0 )
                end
            end
          end
      end
  end
end
-- 取得天元之战我的奖励索引
function BigActivityWin:get_tyzz_my_award_index( data )
    if data~=nil then
         local count = 0;
         if data.guild_names ~=nil then
          count = #data.guild_names
         end
          -- 是否已经领取过奖励 0没有 1有
          local had_get_award = Utils:get_bit_by_position( data.guild_member_award_state, 11 );
          for i=1,count do
              local can_get_award = Utils:get_bit_by_position( data.guild_member_award_state, i );
              if can_get_award == 1 then
                  return i,had_get_award;
              end
          end
          return 0,had_get_award;
    end
end
-- 转换index 1=1,2-5 = 2 ,6-10 = 3
function BigActivityWin:get_index( num )
    if num == 1 then
        return 1;
    elseif num < 6 then 
      return 2;
    elseif  num <11 then
      return 3;
    end
end

-- 取得通用排行奖励索引
function BigActivityWin:get_award_index_data( data  )
    if #data > 0 then
      local i = BigActivityWin:get_award_index( data );
      if i then
          local index = 1;
          if i == 1 or i == 2 or i == 3 then
              return data[i].state,i;
          elseif i < 7 then
              return data[i].state,4;
          else
              return data[i].state,5;
          end
      end
    end
end

function BigActivityWin:get_award_index( data )
    local player_id = EntityManager:get_player_avatar().id;
    for i=1,#data do
        if data[i].player_id == player_id then
            return i;
        end
    end
end


-- 设置按钮状态
function BigActivityWin:set_btn_state( btn,i,state )
  --print("BigActivityWin:set_btn_state( btn,index,state )",i,state);
    if state == 0 or state == 2 then 
        btn:setCurState( CLICK_STATE_DISABLE )
        if state == 0 then
            self.btn_lab[i]:setTexture( UI_WELFARE.lingqu)
            self.btn_lab[i]:setSize(52,22);
            self.btn_lab[i]:setPosition(36, 15);
        else
            self.btn_lab[i]:setTexture( UI_WELFARE.yilingqu)
            self.btn_lab[i]:setSize(60,24);
            self.btn_lab[i]:setPosition(32, 15);
        end
    else
        btn:setCurState( CLICK_STATE_UP )
        self.btn_lab[i]:setTexture( UI_WELFARE.lingqu)
        self.btn_lab[i]:setSize(52,22);
        self.btn_lab[i]:setPosition(36, 15);
    end
end