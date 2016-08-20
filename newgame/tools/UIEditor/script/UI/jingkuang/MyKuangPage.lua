    -- MyKuangPage.lua
    -- modified by xiehande on 2015-1-22
    -- 我的矿脉

    super_class.MyKuangPage()

    local node_pet_tuoyin = nil;
    require "../data/jingkuang_config"

    --窗体大小
    local window_width =880
    local window_height = 520
    local kuang_row = 4

    --矿配置
    local kuang_array = {UILH_MAINACTIVITY.kuang_1,UILH_MAINACTIVITY.kuang_2,UILH_MAINACTIVITY.kuang_3,
    UILH_MAINACTIVITY.kuang_4,UILH_MAINACTIVITY.kuang_5,UILH_MAINACTIVITY.kuang_6,
    UILH_MAINACTIVITY.kuang_7,UILH_MAINACTIVITY.kuang_8}

    local head_id_array = {"ui2/role/card_10_s.png","ui2/role/card_21_s.png","ui2/role/card_31_s.png","ui2/role/card_40_s.png"}
    --创建方法
    function MyKuangPage:create( )
        return MyKuangPage( "MyKuangPage", "", true, window_width,window_height )
    end

    --初始化方法
    function MyKuangPage:__init(window_name, texture_name, pos_x, pos_y, width, height)
         
        --大背景
        local panel_bg = CCBasePanel:panelWithFile(0, 0, window_width, window_height, UILH_COMMON.normal_bg_v2,500,500)
        self.view = panel_bg
       --保存 我的矿坑
        self.kuang_keng_array = {}
        --保存头像
        self.xiezhu_btn ={}
       --左页面
        self.left_panel = CCBasePanel:panelWithFile(15, 13, window_width/2-15, window_height-25, UILH_COMMON.bottom_bg,500,500)
        panel_bg:addChild(self.left_panel)

          --右页面
        self.right_panel = CCBasePanel:panelWithFile(window_width/2, 13, window_width/2-15, window_height-25, UILH_COMMON.bottom_bg,500,500)
        panel_bg:addChild(self.right_panel)

        --创建左右
        self:create_left(self.left_panel)
        self:create_right(self.right_panel)
        
        --请求数据
        -- JingKuangCC:req_kuangchang_list(  )
        JingKuangCC:req_kai_kuang(  )
        JingKuangCC:req_kaikuang_info(  )
          JingKuangCC:req_kuangchang_list(  )
                -- JingKuangCC:req_kaikuang_info(  )

    end

    -- 选矿按钮回调
    function xuankuang_btn_fun( ... )
        local win = UIManager:find_visible_window("jing_kuang_win")
        if win then
            win:change_page(2)
        end
    end

    -- 招募按钮回调
    function zhaomu_btn_fun( ... )
        JingKuangCC:req_send_zhaomu_info(  )
    end

    --提前收矿回调
    function shou_kuang_btn( ... )
        JingKuangCC:req_shouhuo_kuang(  )
    end


    function MyKuangPage:buy_item( price )
        print("花费的元宝",price)
        local avatar = EntityManager:get_player_avatar();--角色拥有元宝
        if avatar.yuanbao < price then --如果元宝不足
            local function confirm2_func()
                GlobalFunc:chong_zhi_enter_fun()
            end
            ConfirmWin2:show( 2, 2, "",  confirm2_func)  --
        else
            JingKuangCC:req_zhaohuan_miner(  )
        end
    end

    -- 召唤镜像按钮
    function MyKuangPage:make_zhaohuan_btn( panel )
        
        for i=1,4 do
            --矿坑底图
            -- local my_kuang_keng =  ZImage:create(panel,UILH_COMMON.slot_bg,20+130*(i-1),170,100,100,nil)
            local my_kuang_keng = {}
            local keng_bg = CCBasePanel:panelWithFile(250-(i%2)*180,280+(-120)*(math.ceil(i/2)-1),-1,-1, UILH_NORMAL.item_bg, 500, 500 )
            my_kuang_keng.keng_bg = keng_bg
            panel:addChild(my_kuang_keng.keng_bg )
            
            --空缺的背景图片 
            my_kuang_keng.kongque_bg = ZImage:create(my_kuang_keng.keng_bg,UILH_NORMAL.level_bg,2,61,-1,-1,nil)
            my_kuang_keng.kongque    = ZImage:create(my_kuang_keng.kongque_bg,UILH_MAINACTIVITY.kongque,26,10,-1,-1,nil)

            --矿坑头像
            my_kuang_keng.head_img = ZImage:create(my_kuang_keng.keng_bg,UILH_NORMAL.slot_bg2,5,9,-1,-1,nil)
            --矿坑消耗
            my_kuang_keng.pay_lab = UILabel:create_lable_2("消耗100元宝", 5, -16, 14, ALIGN_LEFT )
            my_kuang_keng.keng_bg:addChild(my_kuang_keng.pay_lab)

        --召唤镜像按钮
        function btn_fun( )

            local price = JingkuangModel:get_pay_zhaohuan( )
            self:buy_item( price )
        end 
              -- my_kuang_keng.keng_bg:registerScriptHandler(btn_fun)  
            my_kuang_keng.zhaohuan_btn =ZTextButton:create(nil,"",{UILH_COMMON.button8,UILH_COMMON.button8},btn_fun,9,24,-1,-1)
            local zhaohuan_lab = UILabel:create_lable_2(LH_COLOR[2].."召唤镜像", 3, -16, 14, ALIGN_LEFT )
            my_kuang_keng.zhaohuan_btn:addChild(zhaohuan_lab)
            local btn_size = my_kuang_keng.zhaohuan_btn.view:getSize()
            local zhaohuan_lab_size = zhaohuan_lab:getSize()
            zhaohuan_lab:setPosition(btn_size.width/2 - zhaohuan_lab_size.width/2,btn_size.height/2 - zhaohuan_lab_size.height/2+3)
            my_kuang_keng.zhaohuan_btn:setFontSize(14)
            my_kuang_keng.keng_bg:addChild(my_kuang_keng.zhaohuan_btn.view) 
            -- my_kuang_keng.zhaohuan_btn:setTouchClickFun(btn_fun);
            table.insert( self.kuang_keng_array, my_kuang_keng )
        end

    end


    function  MyKuangPage:create_left(panel )
        --今日剩余次数
        self.shengyu_lab =UILabel:create_lable_2(LH_COLOR[2].."今日剩余选矿次数：", 31, 466, 16, ALIGN_LEFT )
        panel:addChild( self.shengyu_lab )

        --左边底图  
        local panel_img = ZImage:create(panel, UILH_COMMON.bg_10, 9, 96+30, 408,330,nil,500,500)
        --背景图片
        local jingkuang_bg = ZImage:create(panel_img, UILH_MAINACTIVITY.jingkuang_bg, 1, -13, 408,340,nil,500,500)

        --当前矿脉种类
        self.kuang_type_lab = UILabel:create_lable_2(LH_COLOR[2].."当前矿脉种类：", 31, 410, 16, ALIGN_LEFT )
        panel:addChild(self.kuang_type_lab)
        
         -- local function btn_fun( )
         -- end 

        --当前的矿
        -- self.current_kuang_btn = ZTextButton:create(panel, "", UILH_COMMON.slot_bg2, 
        -- btn_fun, 203,382,-1,-1)
        self.current_kuang_bg = ZImage:create(panel,UILH_COMMON.slot_bg2,168,367,82,82,nil,500,500)
        self.kuang_img = ZImage:create(self.current_kuang_bg,kuang_array[1],9,7,82,82,nil)

        self.current_kuang_lab = UILabel:create_lable_2(LH_COLOR[2].."当前精矿", 5, 36, 16, ALIGN_LEFT)
        self.current_kuang_bg.view:addChild(self.current_kuang_lab)


        --矿坑标题
        -- local keng_bg = ZImage:create(panel,UILH_NORMAL.title_bg4,39,290,200,50,nil,500,500)
        -- local kuang_keng = UILabel:create_lable_2("矿坑",10,10,16,ALIGN_LEFT)
        -- keng_bg:addChild(kuang_keng)
        

        --四大 召唤映像 按钮
        self:make_zhaohuan_btn( panel )  -- 召唤镜像按钮


        --说明文字
        -- self.shuoming_lab = UILabel:create_lable_2("这是说明", 200, 100, 14, ALIGN_CENTER )
        -- panel:addChild(self.shuoming_lab)


        self.shuoming_lab = ZDialog:create(nil, nil, 10, 85, 400, 85 ,14)
        self.shuoming_lab.view:setAnchorPoint(0, 0.5)
        self.shuoming_lab:setText(LH_COLOR[2].."说明文字")
        panel:addChild( self.shuoming_lab.view )




        --选矿四大按钮
        -- 马上选矿
        self.xuankuang_btn = ZImageButton:create(panel, UILH_COMMON.btn4_nor, "", xuankuang_btn_fun, 57, 10, -1, -1)
          local zhao_lab = UILabel:create_lable_2(LH_COLOR[2].."马上选矿", 62, 22, 14, ALIGN_CENTER )
        self.xuankuang_btn:addChild(zhao_lab)


        -- 招募矿工
        self.zhaomu_btn = ZImageButton:create(panel, UILH_COMMON.btn4_nor, "", zhaomu_btn_fun, 249, 10, -1, -1)
        self.zhaomu_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.btn4_dis)

        local zhao_lab = UILabel:create_lable_2(LH_COLOR[2].."招募矿工",  62, 22, 14, ALIGN_CENTER )
        self.zhaomu_btn:addChild(zhao_lab)
        -- 完美收矿
        self.wanmei_shou_kuang = ZImageButton:create(panel, UILH_COMMON.btn4_nor, "", shou_kuang_btn, 57, 10, -1, -1)
        local zhao_lab = UILabel:create_lable_2(LH_COLOR[2].."完美收矿",  62, 22, 14, ALIGN_CENTER )
        self.wanmei_shou_kuang:addChild(zhao_lab)

        -- 提前收矿
        self.tiqian_shou_kuang = ZImageButton:create(panel, UILH_COMMON.btn4_nor, "", shou_kuang_btn, 57, 10, -1, -1)
        local zhao_lab = UILabel:create_lable_2(LH_COLOR[2].."提前收矿", 62, 22, 14, ALIGN_CENTER )
        self.tiqian_shou_kuang:addChild(zhao_lab)


    end


    --当界面被UIManager:show_window, hide_window的时候调用
    function MyKuangPage:active(show)
        if show then
            --PetCC:req_get_pet_history( )

        end
    end


    function MyKuangPage:create_right(panel_bg)
        local right_bg = CCBasePanel:panelWithFile(10,8,405,448,UILH_COMMON.bg_10,500,500);
        panel_bg:addChild(right_bg)

        self.time_panel = CCBasePanel:panelWithFile(0, 445, 400, 40, "",500,500)
        right_bg:addChild(self.time_panel)
        local time_txt = UILabel:create_lable_2(LH_COLOR[2].."距离下次协助挖掘剩余时间：", 3, 14, 16, ALIGN_LEFT )
        self.time_panel:addChild(time_txt)

        self:create_friend_scroll(panel_bg)
    end

    function MyKuangPage:create_friend_scroll(panel_bg)
        local all_kuangchang_info = JingkuangModel:get_all_kuangchang_info( )

        -- self.scroll = ZScroll:create(parent, scrollfun, 34 , 35 , 825, 450, xiafei_row);
        -- self.scroll:setScrollCreatFunction(scrollfun)
        -- self.scroll:setMaxNum(xiafei_row)  
        

        local function scrollfun( _self, row )
            row = row + 1;
             local all_kuangchang_info = JingkuangModel:get_all_kuangchang_info( )
            --print("row = ",row)
            local panel = CCBasePanel:panelWithFile(0,0,150,50,nil);
            self:create_one_group( panel,row,all_kuangchang_info[row])    
            return panel;
        end

        self.friends_scroll = ZScroll:create(panel_bg, scrollfun, 11 , 11 , 400, 440, kuang_row);

        local all_miner_count = 0
        for i=1,#all_kuangchang_info do
            all_miner_count = all_miner_count + all_kuangchang_info[i].miner_count
        end

        -- local all_mount_lab = UILabel:create_lable_2(string.format(LH_COLOR[2].."今日剩余协助好友次数：%d",all_miner_count), 14, 466, 16, ALIGN_LEFT )
        -- panel_bg:addChild(all_mount_lab)


       local arrow_up = CCZXImage:imageWithFile(389 , 429, 11, -1 , UILH_COMMON.scrollbar_up, 500, 500)
       local arrow_down = CCZXImage:imageWithFile(389, 0, 11, -1, UILH_COMMON.scrollbar_down, 500 , 500)
       self.friends_scroll:addChild(arrow_up,1)
       self.friends_scroll:addChild(arrow_down,1)

        self.friends_scroll:setScrollCreatFunction(scrollfun)
        self.friends_scroll:setMaxNum(kuang_row)    
        self.friends_scroll:setScrollLump( 10, 30, 502)

        self.friends_scroll:setScrollLumpPos( 390 )
        self.friends_scroll:refresh()
        return self.friends_scroll
    end

    function MyKuangPage:create_one_group( panel,rowk,kuangchang_info)
        -- %s的矿脉   %d/%d
        local str = nil
        -- print("kuangchang_info.kuangzhu_name,kuangchang_info.miner_count,kuangchang_info.max",kuangchang_info.kuangzhu_name,kuangchang_info.miner_count,kuangchang_info.max)
         local str = nil
        if kuangchang_info then
            str = string.format(LH_COLOR[2].."%s的矿脉       #c08d53d%d/%d",kuangchang_info.kuangzhu_name,kuangchang_info.miner_count,kuangchang_info.max)

            ZLabel:create(panel, str, 20, 20, 16, ALINE_LEFT)
            -- 协助挖掘
            local z_btn = ZTextButton:create( nil, "",{UILH_COMMON.button4,UILH_COMMON.button4}, nil, 290, 6, 90, -1 )

            local z_btn_lab = UILabel:create_lable_2(LH_COLOR[2].."协助挖掘", 3, -16, 14, ALIGN_LEFT )
            z_btn:addChild(z_btn_lab)
            local btn_size = z_btn.view:getSize()
            local zhaohuan_lab_size = z_btn_lab:getSize()
            z_btn_lab:setPosition(btn_size.width/2 - zhaohuan_lab_size.width/2,btn_size.height/2 - zhaohuan_lab_size.height/2+3)
            z_btn_lab:setFontSize(14)
            panel:addChild( z_btn.view )
            local function btn_fun( ... )
                JingKuangCC:req_yingping_miner( kuangchang_info.kuangchang_id )
            end
            z_btn:setTouchClickFun(btn_fun);

         -- 分割线
          local line = CCZXImage:imageWithFile( 5, 0, 380, 3, UILH_COMMON.split_line )
         panel:addChild(line)
            

            if kuangchang_info then
               self.xiezhu_btn[kuangchang_info.kuangchang_id ] =z_btn
            end



        end








        -- 线
        -- ZImage:create(panel, UIResourcePath.FileLocate.common .. "fenge_bg.png", 0, 0, 360,1)
    end

    function MyKuangPage:update_my_kuang()
        print("更新四大坑等")

        --获取矿工信息
        local all_miner_info = JingkuangModel:get_all_miner_info( )
        --选矿剩余次数
        local shengyu_count = JingkuangModel:get_shengyu_count( )

        --获取挖矿品质
        -- local cur_kuang = JingkuangModel:get_wakuang_pinzhi( )
        local cur_kuang = JingkuangModel:get_pin_zhi()

        -- 今天剩余挖矿次数：
         self.shengyu_lab:setString(LH_COLOR[2].."今天剩余挖矿次数："..shengyu_count)
        print("#all_miner_info",#all_miner_info)

        if self.kuang_img then
            self.kuang_img:setTexture(kuang_array[cur_kuang])
        end
     -- 身份
        local shen_fen = JingkuangModel:get_shenfen(  )
        local str = ""
        if shen_fen~= 2 then
            str =LH_COLOR[2].."你还未挖矿"  --你还未挖矿
            self:set_nokuang_status(  )
            self.current_kuang_bg.view:setIsVisible(false)
            self.zhaomu_btn:setCurState(CLICK_STATE_DISABLE)


        else
            str = LH_COLOR[2].."当前矿脉种类：" --当前矿脉种类：   #cffd700
            self.current_kuang_bg.view:setIsVisible(true)
            self.zhaomu_btn:setCurState(CLICK_STATE_UP)

        end
          --当前的矿类说明
        self.kuang_type_lab:setString(str)


        --更新当前矿的按钮名字
        local name = ""
        if _jingkuang_config[cur_kuang] then
            name = _jingkuang_config[cur_kuang].name
        end
        -- self.current_kuang_lab:setString("当前矿坑")
        self.current_kuang_lab:setString(LH_COLOR[2]..name)

        -- self.zhaomu_btn:setCurState(CLICK_STATE_UP)


        --更新四大坑
        for i=1,#self.kuang_keng_array do
            --名字底图
            self.kuang_keng_array[i].head_img.view:setIsVisible(true)
            -- print("头像ID",all_miner_info[i].touxiang_id)
            local path = ""
            local head_id = nil
            if all_miner_info[i] then
                head_id = all_miner_info[i].touxiang_id
                self.kuang_keng_array[i].kongque_bg.view:setIsVisible(false)
                self.kuang_keng_array[i].zhaohuan_btn.view:setIsVisible(false)
            else
                self.kuang_keng_array[i].zhaohuan_btn.view:setIsVisible(true)
                self.kuang_keng_array[i].kongque_bg.view:setIsVisible(true)

            end
            if head_id ~= nil then
                if head_id == -1 or head_id==255 then
                    path = UILH_MAINACTIVITY.kuang_gong
                else
                    local job = head_id+1
                    path = head_id_array[job]
                end
                self.kuang_keng_array[i].head_img.view:setIsVisible(true)
                self.kuang_keng_array[i].head_img:setTexture(path)
            else
                self.kuang_keng_array[i].head_img.view:setIsVisible(false)
            end

            --消耗元宝
            local pay = string.format("#cffd700消耗%s元宝",JingkuangModel:get_pay_zhaohuan())  --#cffd700消耗%s元宝
            self.kuang_keng_array[i].pay_lab:setString(pay)
        end


        
        --晶矿说明  计算声望
        self:jisuan_shengwang( #all_miner_info ,cur_kuang )
        
        --招募按钮更新
        if #all_miner_info == 4 then
            self.zhaomu_btn:setCurState(CLICK_STATE_DISABLE)
        end
      
        --更新四大按钮
        self:update_btn_status(  )

    end


    -- 设置没挖矿按钮图标状态
    function MyKuangPage:set_nokuang_status(  )
        self.zhaomu_btn:setCurState(CLICK_STATE_DISABLE)

        --更新四大坑
        for i=1,#self.kuang_keng_array do
            --名字底图
            self.kuang_keng_array[i].head_img.view:setIsVisible(false)
            --召唤镜像按钮
            self.kuang_keng_array[i].zhaohuan_btn.view:setIsVisible(false)
            --消耗元宝
            self.kuang_keng_array[i].pay_lab:setString("")
        end

    end



    --更新协助列表
    function MyKuangPage:update_fiend_scroll( ... )
        local all_kuangchang_info = JingkuangModel:get_all_kuangchang_info( )
    print("是否进入")
        if self.friends_scroll == nil then
            self.friends_scroll = self:create_friend_scroll(  )
            self.right_panel:addChild( self.friends_scroll.view )
              self.friends_scroll:refresh()
              -- self.item_scroll:setMaxNum(30)
            
        else
              self.friends_scroll:refresh()
        end
        
        if self.time then 
            self.time:destroy();
            self.time = nil;
        end
        
        local the_time = 0
        if all_kuangchang_info[1] then
            the_time = all_kuangchang_info[1].kuang_time
        end

        local function finish_call(  )
            if self.time then
              self.time:setString(LH_COLOR[10].."0秒")
            end
        end

        self.time = TimerLabel:create_label( self.time_panel, 250,13 , 16,the_time,LH_COLOR[10], finish_call, false,ALIGN_LEFT);   -- lyl ms
         self.time_panel:setIsVisible(true)
        if the_time == nil or the_time <= 0 then
            self.time_panel:setIsVisible(false)
            finish_call();
        end 

        self.friends_scroll.view:reinitScroll();
        self.friends_scroll:clear()

        self.friends_scroll:setMaxNum(#all_kuangchang_info)  
        self.friends_scroll:refresh()
    end

    --更新方法
    function MyKuangPage:update(  )
        
    end

    function MyKuangPage:on_active()
        print("MyKuangPage:on_active()")
        self:update_my_kuang()
        self:update_fiend_scroll( )
        -- JingKuangCC:req_kaikuang_info(  )
    end

    -- 计算可获得多少声望
    function MyKuangPage:jisuan_shengwang( count,cur_kuang )
        print("count,cur_kuang",count,cur_kuang)
        local shengwang = 0
        if cur_kuang ~= 0 then
            shengwang = math.ceil((1+count*0.1)*tonumber(cur_kuang))
        end
        local str = string.format("可获得%d声望",shengwang)

        --说明
        -- self.shuoming_lab:setText(LH_COLOR[2].."选择好矿脉种类后，好友可以参与一同挖掘！每个协助的好友将为你的最终收益#cd58a08增加10%！#cd0cda2请先选矿！"..str)
            self.shuoming_lab:setText(LH_COLOR[2].."选择好矿脉种类后，好友可以参与一同挖掘！每个协助的好友将为你的最终收益#cd58a08增加10%！#cd0cda2通过挖矿可获得声望")


    end

    -- 更新按钮状态
    function MyKuangPage:update_btn_status(  )

        self.xuankuang_btn.view:setIsVisible(false);
        self.wanmei_shou_kuang.view:setIsVisible(false);
        self.tiqian_shou_kuang.view:setIsVisible(false);

        local shen_fen = JingkuangModel:get_shenfen(  )
        local str = ""
        if shen_fen~= 2 then
            --选矿
            self.xuankuang_btn.view:setIsVisible(true);
        else
            local all_miner_info = JingkuangModel:get_all_miner_info( )

            if #all_miner_info == 4 then
                --完美收矿
                 self.wanmei_shou_kuang.view:setIsVisible(true);
            else
                --提前收矿
                self.tiqian_shou_kuang.view:setIsVisible(true);

            end
        end
    end


    function MyKuangPage:fini( )
            if self.time then 
            self.time:destroy();
            self.time = nil;
        end
    end