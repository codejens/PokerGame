-- UniqueSkillFBResultWin.lua
-- created by guozhinan on 2014-11-1
-- 必杀技副本结算窗口  

super_class.UniqueSkillFBResultWin(Window)

local grade_pic_config = {
                        [1]= { UILH_FUBEN.c_1, UILH_FUBEN.c_2, UILH_FUBEN.c_3, UILH_FUBEN.c_4 },
                        [2]= { UILH_FUBEN.b_1, UILH_FUBEN.b_2, UILH_FUBEN.b_3, UILH_FUBEN.b_4 },
                        [3]= { UILH_FUBEN.a_1, UILH_FUBEN.a_2, UILH_FUBEN.a_3, UILH_FUBEN.a_4 },
                        [4]= { UILH_FUBEN.a_1, UILH_FUBEN.a_2, UILH_FUBEN.a_3, UILH_FUBEN.a_4 },
                        }

--是否是必杀技结算
local is_unique = true
local real_array = {}
local pingji_array = {}
local drug_array = {}
function UniqueSkillFBResultWin:set_is_unique(flag)
    is_unique = flag
end

--创建必杀技结算面板
function  UniqueSkillFBResultWin:create_unieSkill( base_panel )
    
     local begin_x = 80
    local offset_x = 50
    local interval_x = 200
    local begin_y = 552
    local interval_y = 100
    local begin_x_lh = 30

    -- 通关奖励 title +线 ===========================================================================
    local image_line = CCZXImage:imageWithFile( begin_x_lh, 510, 525, -1, UILH_FUBEN.line )
    --为了动画
    self.image_line1 = image_line
    base_panel:addChild(image_line)
    -- ZImageImage:create(base_panel, UILH_FUBEN.title_tong, "", begin_x_lh, 510, -1, -1)

    local exp_title = UILabel:create_lable_2( LH_COLOR[13] .. "经验：", begin_x + interval_x * 0, begin_y - interval_y, 18, ALIGN_LEFT )
    base_panel:addChild( exp_title )
    self.exp_label = UILabel:create_lable_2( "", begin_x + interval_x * 0+60, begin_y - interval_y, 18, ALIGN_LEFT )
    base_panel:addChild( self.exp_label )

    -- 评分奖励title + 线 ======================================================================
    image_line = CCZXImage:imageWithFile( begin_x_lh, 410, 525, -1, UILH_FUBEN.line )
    self.image_line2 = image_line

    base_panel:addChild(image_line)
    ZImageImage:create(base_panel, UILH_FUBEN.title_pin, "", begin_x_lh, 410, -1, -1)
    
    self.grade_label = UILabel:create_lable_2( LH_COLOR[13] .. "经验：", begin_x + interval_x * 0, begin_y - interval_y * 2, 18, ALIGN_LEFT )
    base_panel:addChild( self.grade_label )
    self.grade_text_2 = UILabel:create_lable_2( "", begin_x + interval_x * 0+60, begin_y - interval_y * 2, 18, ALIGN_LEFT )
    base_panel:addChild( self.grade_text_2 )

    -- 经验加成title + 线===========================================================================
    image_line = CCZXImage:imageWithFile( begin_x_lh, 310, 525, -1, UILH_FUBEN.line )
    self.image_line3 = image_line

    base_panel:addChild(image_line)
    ZImageImage:create(base_panel, UILH_FUBEN.title_jing, "", begin_x_lh, 310, -1, -1)

    -- self.extra_label = MUtils:create_zximg(self.base_panel,UIPIC_ACTIVITY_053,begin_x + interval_x * 0,begin_y - interval_y * 4.9,-1,-1,500,500)
    self.extra_label = UILabel:create_lable_2( LH_COLOR[13] .. "经验：", begin_x + interval_x * 0, begin_y - interval_y * 3, 18, ALIGN_LEFT )
    base_panel:addChild( self.extra_label )
    self.extra_text_2 = UILabel:create_lable_2( "", begin_x + interval_x * 0+60, begin_y - interval_y * 3, 18, ALIGN_LEFT )
    base_panel:addChild( self.extra_text_2 )

    -- 材料奖励title + 线 ============================================================================
    image_line = CCZXImage:imageWithFile( begin_x_lh, 210, 525, -1, UILH_FUBEN.line )
    self.image_line4 = image_line

    base_panel:addChild(image_line)
    self.title_cai = ZImageImage:create(base_panel, UILH_FUBEN.title_cai, "", begin_x_lh, 210, -1, -1)

    base_panel.view:setIsVisible(false)


end

--通用创建label和数值
function UniqueSkillFBResultWin:create_label(width,height,lab_text,value,type,index)
    local real_value_p = CCBasePanel:panelWithFile(0,0,width,height,nil);
    local exp_title = UILabel:create_lable_2( LH_COLOR[13] .. lab_text, 0, 0, 18, ALIGN_LEFT )
    real_value_p:addChild( exp_title )

    local value_label = NumView:create(0,real_value_p,53,-2,6)
    -- real_value_p:addChild(value_label)

    -- self.label_dict.[index] = value_label;
    value_label:update_num(value)
    -- local show_value = UILabel:create_lable_2( value, 50, 0, 18, ALIGN_LEFT )
    -- real_value_p:addChild( show_value )

    return real_value_p
end

--创建通用结算面板通关奖励
function UniqueSkillFBResultWin:create_real_value(base_panel)
    local begin_x_lh = 30
        -- 通关奖励 title +线 ===========================================================================
    local image_line = CCZXImage:imageWithFile( begin_x_lh, 510, 525, -1, UILH_FUBEN.line )
    base_panel:addChild(image_line)
    self.title_tong = ZImageImage:create(base_panel, UILH_FUBEN.title_tong, "", begin_x_lh, 510, -1, -1)
    
end

--创建通用结算面板评分奖励
function UniqueSkillFBResultWin:create_pingfen_value( base_panel)
    local begin_x_lh = 30

    image_line = CCZXImage:imageWithFile( begin_x_lh, 410, 525, -1, UILH_FUBEN.line )
    base_panel:addChild(image_line)
    self.title_pin =ZImageImage:create(base_panel, UILH_FUBEN.title_pin, "", begin_x_lh, 410, -1, -1)
    
    -- self.grade_label = UILabel:create_lable_2( LH_COLOR[13] .. "经验：", begin_x + interval_x * 0, begin_y - interval_y * 2, 18, ALIGN_LEFT )
    -- base_panel:addChild( self.grade_label )
    -- self.grade_text_2 = UILabel:create_lable_2( "", begin_x + interval_x * 0+60, begin_y - interval_y * 2, 18, ALIGN_LEFT )
    -- base_panel:addChild( self.grade_text_2 )
end

--创建通用结算面板经验丹奖励
function UniqueSkillFBResultWin:create_drug_value( base_panel)
    local begin_x_lh = 30

     -- 经验加成title + 线===========================================================================
    image_line = CCZXImage:imageWithFile( begin_x_lh, 310, 525, -1, UILH_FUBEN.line )
    base_panel:addChild(image_line)
    self.title_jing =ZImageImage:create(base_panel, UILH_FUBEN.title_jing, "", begin_x_lh, 310, -1, -1)

    -- 材料奖励title + 线 ============================================================================
    image_line = CCZXImage:imageWithFile( begin_x_lh, 210, 525, -1, UILH_FUBEN.line )
    base_panel:addChild(image_line)
    self.title_cai = ZImageImage:create(base_panel, UILH_FUBEN.title_cai, "", begin_x_lh, 210, -1, -1)

    -- base_panel.view:setIsVisible(false)

end


function UniqueSkillFBResultWin:__init( window_name, texture_name, is_grid, width, height )
    -- 背景
    self.bg_img = ZImage:create( self.view, UILH_FUBEN.result_bg, -150, -50, GameScreenConfig.ui_screen_width+200,GameScreenConfig.ui_screen_height+100,0, 500, 500)
    self.bg_img.view:setOpacity(100)

    -- 全部UI容器
    self.base_panel = ZBasePanel:create(self.view,"",25,20,857,592)
    self.base_panel.view:setIsVisible(true)

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

    -- 时间title ，右下角置底 ================================================================
    MUtils:create_zximg(self.base_panel,UILH_FUBEN.title_time, 620, 100,-1,-1,500,500)

    -- 动态显示奖励项
    self.award_item_list = {}


    -- 这个定时器是预防作用，在极端异常情况下，我担心用户卡在宝箱界面出不了副本
    self._timer = timer()
    local function timer_fun()
        OthersCC:req_exit_fuben()
        UIManager:destroy_window("us_fb_result_win")
    end
    self._timer:start(45,timer_fun)

    -- 一次必杀技结算面板多次展示数据可能会有问题，timer太多了。还是一次次来处理不容易出问题
    self.has_create_succss_panel = false

    -- 幸运宝箱 + 线
    -- image_line = CCZXImage:imageWithFile( begin_x_lh, 120, 525, -1, UILH_FUBEN.line )
    -- self.base_panel:addChild(image_line)
    -- ZImageImage:create(self.base_panel, UILH_FUBEN.title_xing, "", begin_x_lh, 120, -1, -1)

    -- 注册背景事件，点击背景同点击确定是一样的效果
    -- local function click_func( eventType )
    --     if eventType == TOUCH_CLICK then
    --         btn_ok_fun()
    --     end
    --     return true
    -- end
    -- self.base_panel.view:registerScriptHandler(click_func)
    -- 动态显示奖励项
    self.type_label_t = {}
end



-- 创建副本成功界面，第一步先展示出开宝箱界面
function UniqueSkillFBResultWin:create_succss_panel(fuben_result)

    --首先隐藏结算页面
    self.base_panel.view:setIsVisible(false)

    --其次显示通关标题
    self.title_img2 = MUtils:create_zximg(self.view, UILH_FUBEN.title_result, 960*0.5-145*0.5+50, 640-75, -1, -1, 500, 500)
    self.title_img2:setAnchorPoint(0.5,0.5)

    if self.has_create_succss_panel == true then
        return
    end
    self.has_create_succss_panel = true


    -- 开始执行
    -- self.bg_img.view:setOpacity(255)
    if self.chest_timer then
        self.chest_timer:stop()
        self.chest_timer = nil
    end
    self.chest_timer = timer()
    self.chest_time = 15
    self.once_click = false
    local function timer_fun()
        self.chest_time = self.chest_time - 1
        if self.chest_time <= 0 then
            if self.count_down_view then
                self.count_down_view:removeFromParentAndCleanup(true);
                self.count_down_view = nil
            end
            self:click_chest(2,fuben_result)
        elseif self.chest_time <= 5 then
            if self.count_down_view then
                self.count_down_view:setTexture(string.format(UIResourcePath.FileLocate.lh_fuben .. "countdown_%d.png",self.chest_time));
            end
        end
    end
    self.chest_timer:start(1,timer_fun)



    self.chest_panels = {}

    for i=1,3 do
        local function panel_fun(eventType,arg,msgid,selfitem)
            if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
                return
            end
            if  eventType == TOUCH_BEGAN then
                return true;
            elseif eventType == TOUCH_CLICK then
                self:click_chest(i,fuben_result)
                return true;
            end
            return true;
        end

        self.chest_panels[i] = CCBasePanel:panelWithFile(120+(i-1)*240,280,182,177,nil);
        self.chest_panels[i]:registerScriptHandler(panel_fun)
        local spr = LuaEffectManager:play_view_effect( 11026,182/2,177/2,self.chest_panels[i],true,100 )
        self.view:addChild(self.chest_panels[i])
    end
    self.count_down_view = CCZXImage:imageWithFile(182/2-88/2,177,88,105,"");
    self.chest_panels[2]:addChild(self.count_down_view);

    
    --宝箱掉落动画
    for k=1,#self.chest_panels do
        self.chest_panels[k]:setPosition(120+(k-1)*240,800)


    local array1 = CCArray:array()
    array1:addObject(CCScaleTo:actionWithDuration(0.2,1))
    array1:addObject( CCMoveTo:actionWithDuration( 0.5, CCPoint(120+(k-1)*240,270)) )
    array1:addObject( CCMoveTo:actionWithDuration( 0.2, CCPoint(120+(k-1)*240,310)) ) 
    array1:addObject( CCMoveTo:actionWithDuration( 0.1, CCPoint(120+(k-1)*240,275)) ) 
    array1:addObject( CCMoveTo:actionWithDuration( 0.1, CCPoint(120+(k-1)*240,280)) )  
    self.chest_panels[k]:runAction(CCSequence:actionsWithArray(array1))


    end
    
   



    -- 说明区域
    MUtils:create_zxfont(self.chest_panels[2],Lang.fbresult[1],182/2,-100,2,18)
end


--xiehande 先结算后宝箱
function UniqueSkillFBResultWin:create_succss_panel2(fuben_result)
    self:transition_to_result_panel(fuben_result)
end

-- 宝箱点击后的动画。写那么乱，话说这里应该不会内存泄漏吧...
function UniqueSkillFBResultWin:click_chest(click_index,fuben_result)
    -- 只允许单次点击
    if self.once_click == true then
        return
    end
    self.once_click = true

    if self.chest_timer then
        self.chest_timer:stop()
        self.chest_timer = nil
    end
    self.chest_time = 0

    -- 要将服务器预先决定好用户会抽中的东西放在用户点击的slot上面,这里作一个数组调换
    if click_index ~= fuben_result.player_chest_index then
        local k = fuben_result.player_chest_index
        local item_id = fuben_result.chests[k].itemId
        local count = fuben_result.chests[k].count
        fuben_result.chests[k].itemId = fuben_result.chests[click_index].itemId
        fuben_result.chests[k].count = fuben_result.chests[click_index].count
        fuben_result.chests[click_index].itemId = item_id
        fuben_result.chests[click_index].count = count
        fuben_result.player_chest_index = click_index
    end

    for t=1,3 do
           LuaEffectManager:stop_view_effect(11026,self.chest_panels[t])
        if t==click_index then
            LuaEffectManager:play_view_effect(11027,182/2,177/2,self.chest_panels[t],false,100 )
        else
            LuaEffectManager:play_view_effect(11047,182/2,177/2,self.chest_panels[t],false,100 )
        end

        local slot = MUtils:create_one_slotItem(fuben_result.chests[t].itemId, 90,88, 64, 64 );
        slot.view:setAnchorPoint(0.5,0.5)
        slot:set_icon_bg_texture( UILH_COMMON.slot_bg, -9.5, -9.5, 83, 83 )
        slot:set_item_count(fuben_result.chests[t].count)
        self.chest_panels[t]:addChild(slot.view,101)
        
        slot.view:setScale(0.1)
        
        --物品名字
        local temp_name =  ItemConfig:get_item_name_by_item_id( fuben_result.chests[t].itemId )
        local slot_name = UILabel:create_lable_2( LH_COLOR[2] ..temp_name ,35,6, 18, ALIGN_LEFT)
        self.chest_panels[t]:addChild(slot_name)

        if t == fuben_result.player_chest_index then
            local array = CCArray:array()
            array:addObject(CCScaleTo:actionWithDuration(0.2,1))
            -- array:addObject(CCMoveTo:actionWithDuration(1,CCPoint(-480 + (3-t)*240, -230)))
            --120+(i-1)*240,280
            array:addObject(CCMoveTo:actionWithDuration(0.5,CCPoint(90,150)))
            -- array:addObject(CCRemove:action())
            slot.view:runAction(CCSequence:actionsWithArray(array))
        else
            slot.view:runAction(CCScaleTo:actionWithDuration(0.2,1))
        end
    end


   if self.count_down_view then
                self.count_down_view:removeFromParentAndCleanup(true);
                self.count_down_view = nil
    end


    -- 宝箱开启的动画播完后，播宝箱开启后的动画
    self.delay_cb = callback:new();
    local function callback_function()
        for t=1,3 do
            LuaEffectManager:play_view_effect(11025,182/2,177/2,self.chest_panels[t],true,100 )
        end
    end
    self.delay_cb:start(0.125*6,callback_function);



    -- 2秒后 显示两个按钮
    self.delay_cb2 = callback:new();
    local function callback_function2()

     function  create_time_label(  )
        self.timer_lab_2 = TimerLabel:create_label(self.view, 430, 82, 16, 5, "#cfff000");
     end

     self.delay_cb3 = callback:new()
     self.delay_cb3:start(10,create_time_label)

        --2秒后出按钮（回城  再来一次）
        local function btn_ok_fun_hui()
            if self.timer_lab_2 then
               self.timer_lab_2:destroy()
            end

            --如果倒计时定时器存在 需要销毁
            if self.delay_cb3 then
               self.delay_cb3:cancel() 
            end

                --确定按钮跳到宝箱页面
            OthersCC:req_exit_fuben()
            UIManager:destroy_window("us_fb_result_win")
        end

        self.btn_ok_hui = ZTextButton:create(self.view,"回 城", UILH_COMMON.lh_button_4_r,btn_ok_fun_hui, 540, 63, -1, -1)

        self.btn_ok_hui.view:setIsVisible(true)


        --如果15秒用户不点击  则默认执行回城
        if self._timer then
            self._timer:stop()
            self._timer = nil
        end


        self._timer = timer()
        local function timer_fun()
            btn_ok_fun_hui()
        end
        self._timer:start(15,timer_fun)
      


        -- 再来一次按钮
        local function btn_fight_again_fun()

        --如果存在倒计时 则销毁
            if self.timer_lab_2 then
               self.timer_lab_2:destroy()
            end

              if self.delay_cb3 then
                       self.delay_cb3:cancel() 
             end


        
            OthersCC:req_fight_again()
            UIManager:destroy_window("us_fb_result_win")
        end
        local btn_fight_again = ZTextButton:create(self.view,"再来一次", {UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},btn_fight_again_fun, 214, 63, -1, -1)
        btn_fight_again.view:setIsVisible(true)

    end


    self.delay_cb2:start(1,callback_function2);
end

function UniqueSkillFBResultWin:transition_to_result_panel(fuben_result)
  -- self.base_panel.view:setIsVisible(true)
    -- for t=1,3 do
    --     LuaEffectManager:stop_view_effect(11025,self.chest_panels[t])
    --     LuaEffectManager:stop_view_effect(11026,self.chest_panels[t])
    --     LuaEffectManager:stop_view_effect(11027,self.chest_panels[t])
    --     self.chest_panels[t]:removeFromParentAndCleanup(true)
    --     self.chest_panels[t] = nil
    -- end

    function  create_time_label(  )
        self.timer_lab = TimerLabel:create_label(self.view, 835-50, 60, 16, 5, "#cfff000");
    end
    self.delay_cb4 = callback:new()
    self.delay_cb4:start(10,create_time_label)



      -- 确定按钮
    local function btn_ok_fun()
        --确定按钮跳到宝箱页面
        self.base_panel.view:setIsVisible(false)
        if self.timer_lab then
           self.timer_lab:destroy()
        end

        --如果回调还存在 则需要取消
        if self.delay_cb4 then
             self.delay_cb4:cancel()
        end
        self:create_succss_panel(fuben_result)
    end

    
    --为了避免确定按钮出现太早 快速点击会出现页面重叠 故意让确定页面1秒后显示
    self.delay_cb5 = callback:new()
    local function callback_create_btn()
    self.btn_ok = ZTextButton:create(self.base_panel,"确 定", UILH_COMMON.lh_button_4_r,btn_ok_fun, 630, 20, -1, -1)
        if self.delay_cb5 then
            self.delay_cb5:cancel()
        end
    end

    self.delay_cb5:start(1,callback_create_btn);
   
    if self._timer then
        self._timer:stop()
        self._timer = nil
    end

    self._timer = timer()
    local function timer_fun()
        btn_ok_fun()
    end

    self._timer:start(15,timer_fun)

    self.bg_img.view:setOpacity(100)
    self:create_result_panel(fuben_result)
end


--更新必杀技结算界面 (限于必杀技)
function UniqueSkillFBResultWin:update_unique_result_panel(fuben_result)
              -- 通关经验
        self.exp_label:setString(LH_COLOR[2] .. fuben_result.exp_base)

        -- 评级奖励
        local grade_award = fuben_result.exp_grade
        self.grade_text_2:setString( LH_COLOR[2] .. grade_award)

        -- 经验丹加成
        self.extra_exp = fuben_result.exp_addExpItem
        self.extra_text_2:setString( LH_COLOR[2] ..  self.extra_exp) 


end


--更新通用的结算界面
function UniqueSkillFBResultWin:update_common_result_panel(base_panel, fuben_result )
     local begin_y = 438
     local begin_x = 87
     local gas_x = 110
     local gas_y =30
     local num = 1
     local width =70
     local  height = 20
     print("fuben_result.real_grade",fuben_result.real_grade)
      if fuben_result.real_grade == nil or fuben_result.real_grade == 0  then
        real_array[num]= self:create_label(width,height,"经验：",0)
      else

         for i=1,fuben_result.real_grade do
            if fuben_result.real_grade_array[i].itemId ==0  then  --铜币
                 real_array[i]= self:create_label(width,height,"铜币：",fuben_result.real_grade_array[i].count,"real",i)
                   i= i+1
            elseif fuben_result.real_grade_array[i].itemId == 1 then --银币
                 real_array[i]= self:create_label(width,height,"银币：",fuben_result.real_grade_array[i].count,"real",i)
                  i= i+1
            elseif fuben_result.real_grade_array[i].itemId == 2 then --礼券
                real_array[i]=  self:create_label(width,height,"礼券：",fuben_result.real_grade_array[i].count,"real",i)
                i= i+1
            elseif fuben_result.real_grade_array[i].itemId == 3 then --元宝
               real_array[i]=  self:create_label(width,height,"元宝：",fuben_result.real_grade_array[i].count,"real",i)
               i= i+1
            elseif fuben_result.real_grade_array[i].itemId == 11 then --经验
                real_array[i]= self:create_label(width,height,"经验：",fuben_result.real_grade_array[i].count,"real",i)
                i= i+1
            elseif fuben_result.real_grade_array[i].itemId == 12 then --历练
                 real_array[i]=self:create_label(width,height,"历练：",fuben_result.real_grade_array[i].count,"real",i)
                 i= i+1
            end
         end

       end
       
       for i=1,#real_array do
           if real_array[i] ~= nil then

               self.base_panel:addChild(real_array[i])
                   local row = (i+1)%2-1  -- 从0开始
                   local column = math.ceil(i/2)-1   -- 从0开始
                    real_array[i]:setPosition(begin_x+column*gas_x,begin_y-row*gas_y)
            end
       end



        --评分奖励
     if fuben_result.pingji_grade == nil or fuben_result.pingji_grade == 0  then
        pingji_array[num]= self:create_label(width,height,"经验：",0)
      else

         for i=1,fuben_result.pingji_grade do
            if fuben_result.pingji_grade_array[i].itemId ==0 then  --铜币
                 pingji_array[i]= self:create_label(width,height,"铜币：",fuben_result.pingji_grade_array[i].count,"pingji",i)
                   i= i+1
            elseif fuben_result.pingji_grade_array[i].itemId == 1 then --银币
                 pingji_array[i]= self:create_label(width,height,"银币：",fuben_result.pingji_grade_array[i].count,"pingji",i)
                  i= i+1
            elseif fuben_result.pingji_grade_array[i].itemId == 2 then --礼券
                pingji_array[i]=  self:create_label(width,height,"礼券：",fuben_result.pingji_grade_array[i].count,"pingji",i)
                i= i+1
            elseif fuben_result.pingji_grade_array[i].itemId == 3 then --元宝
               pingji_array[i]=  self:create_label(width,height,"元宝：",fuben_result.pingji_grade_array[i].count,"pingji",i)
               i= i+1
            elseif fuben_result.pingji_grade_array[i].itemId == 11 then --经验
                pingji_array[i]= self:create_label(width,height,"经验：",fuben_result.pingji_grade_array[i].count,"pingji",i)
                i= i+1
            elseif fuben_result.pingji_grade_array[i].itemId == 12 then --历练
                 pingji_array[i]=self:create_label(width,height,"历练：",fuben_result.pingji_grade_array[i].count,"pingji",i)
                 i= i+1
            end
         end

       end
       
       -- end
       begin_y = begin_y -100
       for i=1,#pingji_array do
          if pingji_array[i] ~= nil then
               self.base_panel:addChild(pingji_array[i])
               local row = (i+1)%2-1  -- 从0开始
               local column = math.ceil(i/2)-1   -- 从0开始
                pingji_array[i]:setPosition(begin_x+column*gas_x,begin_y-row*gas_y)
          end
       end

        
        --药包加成
      if fuben_result.drug_grade == nil or fuben_result.drug_grade == 0  then
        drug_array[num]= self:create_label(width,height,"经验：",0)
      else

         for i=1,fuben_result.drug_grade do
            if fuben_result.drug_grade_array[i].itemId==0  then  --铜币
                 drug_array[i]= self:create_label(width,height,"铜币：",fuben_result.drug_grade_array[i].count,"drug",i)
                   i= i+1
            elseif fuben_result.drug_grade_array[i].itemId == 1 then --银币
                 drug_array[i]= self:create_label(width,height,"银币：",fuben_result.drug_grade_array[i].count,"drug",i)
                  i= i+1
            elseif fuben_result.drug_grade_array[i].itemId == 2 then --礼券
                drug_array[i]=  self:create_label(width,height,"礼券：",fuben_result.drug_grade_array[i].count,"drug",i)
                i= i+1
            elseif fuben_result.drug_grade_array[i].itemId == 3 then --元宝
               drug_array[i]=  self:create_label(width,height,"元宝：",fuben_result.drug_grade_array[i].count,"drug",i)
               i= i+1
            elseif fuben_result.drug_grade_array[i].itemId == 11 then --经验
                drug_array[i]= self:create_label(width,height,"经验：",fuben_result.drug_grade_array[i].count,"drug",i)
                i= i+1
            elseif fuben_result.drug_grade_array[i].itemId == 12 then --历练
                 drug_array[i]=self:create_label(width,height,"历练：",fuben_result.drug_grade_array[i].count,"drug",i)
                 i= i+1
            end
         end

       end
       

       begin_y = begin_y -100
       for i=1,#drug_array do
          if drug_array[i] ~=nil then
               self.base_panel:addChild(drug_array[i])
               local row = (i+1)%2-1  -- 从0开始
               local column = math.ceil(i/2)-1   -- 从0开始
                drug_array[i]:setPosition(begin_x+column*gas_x,begin_y-row*gas_y)
         end
       end
   
end


--创建副本成功界面
function UniqueSkillFBResultWin:create_result_panel(fuben_result)
   --测试数据
 --      local  fuben_result = {}
 --                                             --测试数据
 --    fuben_result.player_chest_index = 3
 --    fuben_result.chests_num =  3
 --    fuben_result.elapsed_time = 3 
 --    fuben_result.chests = {}
    
 --    local  test_chest = {}
 --    test_chest.itemId = 18510
 --    test_chest.count = 1

 --    table.insert(fuben_result.chests,test_chest)

 --     test_chest.itemId = 18730
 --    test_chest.count = 1
 -- table.insert(fuben_result.chests,test_chest)
 --     test_chest.itemId = 28231
 --     test_chest.count = 1
 -- table.insert(fuben_result.chests,test_chest)


 --    fuben_result.grade =  1 
 --    fuben_result.fubenId  = 8 


 --    fuben_result.items = {}
 --    local test_item = {}
 --    test_item.itemId = 28231
 --    test_item.count = 1
 --    table.insert( fuben_result.items,test_item)


 --    fuben_result.real_grade = 0
 --    fuben_result.real_grade_array={}

 --    fuben_result.pingji_grade = 0
 --    fuben_result.pingji_grade_array={}

 --    fuben_result.drug_grade = 0
 --    fuben_result.drug_grade_array={}



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
                self.lh_second.view:setPosition(745,100)
                img_minute:setPosition( 730, 110)
                if second > 9 then
                    img_second_1:setPosition(775, 110)
                    img_second_2:setPosition(785, 110)
                else
                    img_second_1:setPosition(760, 110)
                    img_second_2:setPosition(770, 110)
                end
            else
                if second > 9 then
                    img_second_1:setPosition(760, 110)
                    img_second_2:setPosition(770, 110)
                end
            end
        end

        -- 评级( 傲视群雄)  (傲, 视, 群, 雄)
        self.grade_pic = MUtils:create_zximg(self.base_panel, "", 680, 352,318,345,500,500)
        self.grade_pic:setAnchorPoint( 0.5, 0.5)
        self.grade_pic:setIsVisible(true)
        
        --进入副本快速退出后，grade = 0 
        if fuben_result.grade == 0  then
            fuben_result.grade = 1
        end

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

       
       if is_unique then
            --更新必杀技的界面界面
            self:update_unique_result_panel(fuben_result)
       else
        --通用结算数据
         self:update_common_result_panel(self.base_panel,fuben_result)
       end

        -- 奖励列表
        for i=1,#self.award_item_list do
            self.award_item_list[i]:removeFromParentAndCleanup(true)
        end

        self.award_item_list = {}

        local slot_w = 64
        local slot_h = 64
        local slot_x = 85
        local slot_y = 100
        local slot_offset = 80

        local award_list = fuben_result.items

        for i=1,#award_list do
            local slot;
            if award_list[i].itemId == 3 then
                slot = MUtils:create_one_slotItem( nil, slot_x+slot_offset*(i-1), slot_y, slot_w, slot_h )
                slot:set_icon_bg_texture( UILH_COMMON.slot_bg, -9.5, -9.5, 83, 83 )
                slot:set_item_count(award_list[i].count)
                slot:set_money_icon(3)
            else
                slot = MUtils:create_one_slotItem( award_list[i].itemId, slot_x+slot_offset*(i-1), slot_y, slot_w, slot_h );
                slot:set_icon_bg_texture( UILH_COMMON.slot_bg, -9.5, -9.5, 83, 83 )
                slot:set_item_count(award_list[i].count)
            end

            local function tip_func( slot_obj,eventType, args, msgid )
                local click_pos = Utils:Split(args, ":")
                local world_pos = self.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) );
                if award_list[i].itemId == 3 then
                    -- 显示元宝tip
                    local data = {item_id = 3, item_count = award_list[i].count};
                    TipsModel:show_money_tip( world_pos.x,world_pos.y, data );
                else
                    TipsModel:show_shop_tip( world_pos.x,world_pos.y, award_list[i].itemId)
                end
            end

            slot:set_click_event(tip_func)
            self.base_panel:addChild(slot.view)
            self.award_item_list[i] = slot
        end
       
        -- 跑动画
        self:do_action()
    end
end

function UniqueSkillFBResultWin:do_action()
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


    local a_array_1 = CCArray:array()
    local a1 = CCScaleTo:actionWithDuration( 0.15, 0.5 )
    local a2 = CCScaleTo:actionWithDuration( 0.15, 1.2 ) 
    local a3 = CCScaleTo:actionWithDuration( 0.15, 1.0 ) 
    a_array_1:addObject(a1)
    a_array_1:addObject(a2)
    a_array_1:addObject(a3)
    local seq_1 = CCSequence:actionsWithArray(a_array_1)
    self.grade_bg:runAction( seq_1 )


    local array2 = CCArray:array()
    -- array2:addObject(CCScaleTo:actionWithDuration(0.2,1))
    -- array2:addObject(CCFadeIn:actionWithDuration(0.2))
    -- array2:addObject(CCDelayTime:actionWithDuration(0.5 ))
    array2:addObject(CCMoveTo:actionWithDuration(0.4,CCPoint(30,510)))
    -- array2:addObject(CCMoveTo:actionWithDuration(0.3,CCPoint(30,510)))

   --  array2:addObject(move_ease_out)
   --  array2:addObject(remove_act)
   -- array2:addObject(move_to)

    local action1 = CCSpawn:actionsWithArray(array2)

    
    local array2_1 = CCArray:array()
    -- array2_1:addObject(CCScaleTo:actionWithDuration(0.2,1))
    -- array2_1:addObject(CCFadeIn:actionWithDuration(0.2))
    array2_1:addObject(CCDelayTime:actionWithDuration(0.2 ))
    array2_1:addObject(CCMoveTo:actionWithDuration(0.3,CCPoint(30,410)))

    local action2 = CCSequence:actionsWithArray(array2_1)


    
    local array2_2 = CCArray:array()
    -- array2_2:addObject(CCScaleTo:actionWithDuration(0.2,1))
    -- array2_2:addObject(CCFadeIn:actionWithDuration(0.2))
    array2_2:addObject(CCDelayTime:actionWithDuration(0.3))
    array2_2:addObject(CCMoveTo:actionWithDuration(0.3,CCPoint(30,310)))

    local action3 = CCSequence:actionsWithArray(array2_2)


    local array2_3 = CCArray:array()
    -- array2_2:addObject(CCScaleTo:actionWithDuration(0.2,1))
    -- array2_2:addObject(CCFadeIn:actionWithDuration(0.2))
    array2_3:addObject(CCDelayTime:actionWithDuration(0.4 ))
    array2_3:addObject(CCMoveTo:actionWithDuration(0.3,CCPoint(30,210)))

    local action4 = CCSequence:actionsWithArray(array2_3)


    -- array:addObject(action)
    self.title_tong.view:setPosition(-100,510)
    self.title_tong.view:runAction(action1)
    self.title_pin.view:setPosition(-100,410)
    self.title_pin.view:runAction(action2)
    self.title_jing.view:setPosition(-100,310)
    self.title_jing.view:runAction(action3)

    self.title_cai.view:setPosition(-100,210)
    self.title_cai.view:runAction(action4)

    --让几条线也飘
    -- self.image_line1.view:setPosition(-100,510)
    -- self.image_line1.view:runAction(action1)
    -- self.image_line2.view:setPosition(-100,410)
    -- self.image_line2.view:runAction(action2)
    -- self.image_line3.view:setPosition(-100,310)
    -- self.image_line3.view:runAction(action3)

    -- self.image_line4.view:setPosition(-100,210)
    -- self.image_line4.view:runAction(action4)

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
    -- local array = CCArray:array()
    -- array:addObject(CCDelayTime:actionWithDuration( 3.0))
    -- array:addObject(CCShow:action())
    -- local action = CCSequence:actionsWithArray(array)
    -- self.btn_ok.view:runAction(action)
end 

-- 创建一个道具展示的 scroll panel_table_para: itemid 表 ， scroll的坐标和宽高， colu_num: 列数， sight_num:可见行数， bg_name:背景图片的名称
function UniqueSkillFBResultWin:create_item_scroll( panel_table_para , pos_x, pos_y, size_w, size_h, colu_num, sight_num, bg_name)
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
function UniqueSkillFBResultWin:create_item_show_panel( panel_date, x, y, w, h , index)
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

function UniqueSkillFBResultWin:destroy()
    if self._timer then
        self._timer:stop()
        self._timer = nil
    end

    if self.chest_timer then
        self.chest_timer:stop()
        self.chest_timer = nil
    end

    if self.timer_lab then
        self.timer_lab:destroy();
        self.timer_lab = nil; 
    end


    if self.timer_lab_2 then
        self.timer_lab_2:destroy();
        self.timer_lab_2 = nil; 
    end
    
    --销毁定时器
    if self.delay_cb then
        self.delay_cb:cancel()
    end

        if self.delay_cb2 then
        self.delay_cb2:cancel()
    end

        if self.delay_cb3 then
        self.delay_cb3:cancel()
    end

        if self.delay_cb4 then
        self.delay_cb4:cancel()
    end

      if delay_cb5 then
        self.delay_cb5:cancel()
    end


     for t=1,3 do
        LuaEffectManager:stop_view_effect(11025,self.chest_panels[t])
        LuaEffectManager:stop_view_effect(11026,self.chest_panels[t])
        LuaEffectManager:stop_view_effect(11027,self.chest_panels[t])
        LuaEffectManager:stop_view_effect(11047,self.chest_panels[t])
        self.chest_panels[t]:removeFromParentAndCleanup(true)
        self.chest_panels[t] = nil
    end


    Window.destroy(self)
end

function UniqueSkillFBResultWin:active(show,flag)
    -- self:set_is_unique(flag)
    
    if is_unique then
      --创建必杀技结算布局
       self:create_unieSkill(self.base_panel)
    else
        --通用的结算界面
       self:create_real_value(self.base_panel)
       self:create_pingfen_value(self.base_panel)
       self:create_drug_value(self.base_panel)
    end

    if self.exit_btn then
        self.exit_btn.view:setIsVisible(false)
    end
end