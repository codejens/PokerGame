-- DailyWelfarePage.lua  
-- created by lyl on 2013-3-5
-- 日常福利页  四页总页
super_class.DailyWelfarePage(Window)

--创建工厂方法
function DailyWelfarePage:create(  )
    return DailyWelfarePage( "DailyWelfarePage", UILH_COMMON.normal_bg_v2 , true, 890, 515 )
end

function DailyWelfarePage:__init( window_name, window_info )
    -- 背景
    local int_space=4
    -- local width = (860-11*2-int_space)/2
    -- local height = (500-11*2-int_space)/2
    local first_pos_x = 12
    local width = 214
    local height = 478

    self.left_up_panel = DailyWelfareLU:create(680,294)       -- 左上面板
    self:addChild( self.left_up_panel )
    self.left_up_panel:setPosition(195,190)

    -- self.left_down_panel    = DailyWelfareLD:create( width, height)         -- 左下面板
    -- self:addChild( self.left_down_panel )
    -- self.left_down_panel:setPosition(first_pos_x+2*width+2*int_space-3,20)

    self.right_up_panel     = DailyWelfareRU:create( 680, 150 )     -- 右上面板
    self:addChild( self.right_up_panel )
    -- self.right_up_panel:setPosition(first_pos_x+width+int_space,20)
    self.right_up_panel:setPosition(196,20)

    -- self.right_down_panel   = DailyWelfareRD:create( width, height )       -- 右下面板
-- self:addChild( self.right_down_panel)
    -- self.right_down_panel:setPosition(first_pos_x+3*width+3*int_space-4,20)

end



-- 更新数据
function DailyWelfarePage:update( update_type )
    -- xprint("===========         DailyWelfarePage:update( update_type )               ==================================")

    -- print("DailyWelfarePage:update", update_type)
    if update_type == "award_list" then
        if self.left_up_panel then
             self.left_up_panel:update_award_list(  )
        end
        
    elseif update_type == "award_state_list" then
         if self.left_up_panel then
             self.left_up_panel:update_get_award_state(  )
        end
    elseif update_type == "off_line_exp_consume" then
            --  if self.left_down_panel then
            --  self.left_down_panel:update_consume(  )    --更新消耗总量
            -- end
           
    elseif update_type == "off_line_expxp" then  
            --  if self.left_down_panel then
            --  self.left_down_panel:update_off_line_exp(  )  --更新离线经验值
            -- end


    elseif update_type == "off_lingqi" then             -- 离线灵气

        --                  if self.left_down_panel then
        --      self.left_down_panel:update_off_line_lingqi(  )
        -- end

    elseif update_type == "if_had_get_vip_award" then

                                 if self.right_up_panel then

          self.right_up_panel:update_get_but(  )
        end

    elseif update_type == "exp_back" then
        -- if self.right_down_panel then
        --      self.right_down_panel:update_exp_back_date(  )

        -- end
    elseif update_type == "change_to_lingqi" then
       --  if self.left_down_panel then 
       --  self.left_down_panel:update( update_type )
       -- end
    elseif update_type == "all" then
        self.left_up_panel:update_award_list(  )
        self.left_up_panel:update_get_award_state(  )
        -- self.left_down_panel:update_off_line_exp(  )
        -- self.left_down_panel:update_consume(  )
        --离线经验刷新
        -- self.left_down_panel:update( "all" )
        --更新VIP返利领取
        self.right_up_panel:update_get_but(  )
        --更新VIP返利说明
        self.right_up_panel:update_explain(  )
        --副本累积 日常任务累积刷新
        -- self.right_down_panel:update_exp_back_date(  )

    else

    end
    -- ActivityWin:update_page_tips()
end

-- 摧毁窗口，被UIManager调用
function DailyWelfarePage:destroy(  )
    Window.destroy(self)
    self.left_up_panel:destroy()
    -- self.left_down_panel:destroy()
    self.right_up_panel:destroy()
    -- self.right_down_panel:destroy()
end

function DailyWelfarePage:active( show )
    if show then
    end
end


function DailyWelfarePage:change_index_page(index)
    -- if self.left_down_panel ~= nil then
    --     self.left_down_panel:change_page(index)
    -- end
end
-- 更新分页按钮上的提示标志
function DailyWelfarePage:update_tips_count()
    if WelfareModel:get_longin_award_had_not_get() > 0 then
        -- print("每日登陆有未领取")
        return 1
    elseif WelfareModel:get_if_had_get_vip_award() == 0 then  --0：未领取  1：已领取  -1：非vip
        -- print("vip有未领取")
        return 1
    elseif WelfareModel:get_off_line_exp() > 0 then
        -- print("离线经验有未领取")
        return 1
    elseif WelfareModel:get_off_line_lingqi() > 0 then
        -- print("离线灵气有未领取")
        return 1
    else
        local a1,a2,a3,a4 = WelfareModel:get_exp_back_date_by_type(1)
        local b1,b2,b3,b4 = WelfareModel:get_exp_back_date_by_type(2)
        if a3 == false then
            -- print("副本累计有未领取")
            return 1
        elseif b3 == false then
            -- print("任务累计有未领取")
            return 1
        end
    end
    print("没有未领取状态")
    return 0
end



-- 创建一个空白回收任命框
-- function  DailyWelfarePage:create_bg_win(  )
--     local function self_view_func( eventType )
--         if eventType == TOUCH_BEGAN then
--            local win = UIManager:find_visible_window("benefit_win")
--            if win then

--                if win.all_page_t[BENEFIT_FULI_TAG] then
--                   win.all_page_t[BENEFIT_FULI_TAG].right_down_panel:hide_tip_win()
--                   --同时隐藏空白框
--                   win.all_page_t[BENEFIT_FULI_TAG]:hide_bg_win()
--                end
--            end
--             return true
--         end
--         return false
--     end

--     local conten = self.view:getSize()
--     self.basepanel = CCBasePanel:panelWithFile( 0, -20, conten.width,conten.height+60,nil);
--     self.basepanel:setAnchorPoint(0,0)
--     self.view:addChild(self.basepanel,999)
--     self.basepanel:registerScriptHandler(self_view_func)

-- end

-- function DailyWelfarePage:hide_bg_win(  )
--     local win = UIManager:find_visible_window("benefit_win")
--     if win then
--         win.all_page_t[BENEFIT_FULI_TAG].basepanel:setIsVisible(false)
--     end
-- end
