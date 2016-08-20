-- JubaoBagWin.lua
-- created by liuguowang on 2014-4-6
-- 角色属性窗口  user_attr_win

require "UI/component/Window"
super_class.JubaoBagWin(Window)

-- require "UI/jubaobag/TujianPage"
-- require "UI/jubaobag/StarPage"

local BTN_STR_PATH = {"ui/jubaobag/jubao_rank_text.png","ui/jubaobag/jubao_msg_text.png"}

 require "../data/activity_config/jubaobag_conf"
local tanbao_btn_1
local tanbao_btn_2
local tanbao_btn_3
local tanbao_label_1
local tanbao_label_2
local tanbao_label_3

local taobao_btn_x = {0,93,93*2}

--根据vip等级显示探宝按钮
function JubaoBagWin:showTanbaoBtn_by_vip_level( vip_level )
    if tanbao_label_2 == nil or  tanbao_label_3 == nil then
        return
    end

    print("vip等级",vip_level)
    if vip_level <= 3 then 
        tanbao_label_2.view:setIsVisible(false);
        tanbao_btn_2.view:setIsVisible(false);
        tanbao_label_3.view:setIsVisible(false);
        tanbao_btn_3.view:setIsVisible(false);

        tanbao_label_1.view:setPosition(taobao_btn_x[2],45);
        tanbao_btn_1.view:setPosition(taobao_btn_x[2],0);

    elseif vip_level >= 4 and vip_level <6 then
        tanbao_label_2.view:setIsVisible(true);
        tanbao_btn_2.view:setIsVisible(true);
        tanbao_label_3.view:setIsVisible(false);
        tanbao_btn_3.view:setIsVisible(false);

        tanbao_label_1.view:setPosition((taobao_btn_x[1]+taobao_btn_x[2])/2-15,45);
        tanbao_btn_1.view:setPosition((taobao_btn_x[1]+taobao_btn_x[2])/2,0);
        tanbao_label_2.view:setPosition((taobao_btn_x[2]+taobao_btn_x[3])/2+5,45);
        tanbao_btn_2.view:setPosition((taobao_btn_x[2]+taobao_btn_x[3])/2,0);
    elseif vip_level >=6 then
        tanbao_label_2.view:setIsVisible(true);
        tanbao_btn_2.view:setIsVisible(true);
        tanbao_label_3.view:setIsVisible(true);
        tanbao_btn_3.view:setIsVisible(true);

        tanbao_label_1.view:setPosition(taobao_btn_x[1]-15,45);
        tanbao_btn_1.view:setPosition(taobao_btn_x[1],0);
        tanbao_label_2.view:setPosition(taobao_btn_x[2]+5,45);
        tanbao_btn_2.view:setPosition(taobao_btn_x[2],0);
        tanbao_label_3.view:setPosition(taobao_btn_x[3],45);
        tanbao_btn_3.view:setPosition(taobao_btn_x[3],0);
    end

end



function JubaoBagWin:create_left_bgPanel(self)
    self.left_bgPanel = ZBasePanel:create(self,nil,142-57,69, 368,358, 500, 500)

    function jubao_1_times_fun( )
        DreamlandModel:set_dreamland_type(DreamlandModel.DREAMLAND_TYPE_JBD);
        DreamlandModel:req_tao_bao(1);
    end
    tanbao_label_1 = ZLabel:create( self.left_bgPanel, Lang.jubao.jubao_1_text, taobao_btn_x[1], 45,14)
    tanbao_btn_1 = ZButton:create(self.left_bgPanel,UIResourcePath.FileLocate.jubaobag .. "jubao_1.png",jubao_1_times_fun,taobao_btn_x[1],0,-1,-1)

    function jubao_10_times_fun( )
        DreamlandModel:set_dreamland_type(DreamlandModel.DREAMLAND_TYPE_JBD);
        DreamlandModel:req_tao_bao(10);
    end    
    tanbao_label_2 = ZLabel:create( self.left_bgPanel, Lang.jubao.jubao_10_text, taobao_btn_x[2], 45,14)
    tanbao_btn_2 = ZButton:create(self.left_bgPanel,UIResourcePath.FileLocate.jubaobag .. "jubao_10.png",jubao_10_times_fun,taobao_btn_x[2],0,-1,-1)

    function jubao_50_times_fun( )
        DreamlandModel:set_dreamland_type(DreamlandModel.DREAMLAND_TYPE_JBD);
        DreamlandModel:req_tao_bao(50);
    end    
    tanbao_label_3 = ZLabel:create( self.left_bgPanel, Lang.jubao.jubao_50_text, taobao_btn_x[3], 45,14)
    tanbao_btn_3 = ZButton:create(self.left_bgPanel,UIResourcePath.FileLocate.jubaobag .. "jubao_50.png",jubao_50_times_fun,taobao_btn_x[3],0,-1,-1)
------------------------------------------------------------------------------------------------------------------------------
    
    self.get_item_paihang_solt = {}
    for i=1,#_jubao_bag_slot_id.xiyou do
        local item_data = _jubao_bag_slot_id.xiyou[i]
        local function show_my_paihang_item_tip( )--稀有宝物道具显示
            ActivityModel:show_mall_tips( item_data.id )
        end
        local x
        if i >= 6 then
            x = 30+51*(i-6)
        else
            x = 30+51*(i-1)
        end
        local y = 122-52*math.floor(i/6)
        self.get_item_paihang_solt= MUtils:create_slot_item(self.left_bgPanel,UIResourcePath.FileLocate.jubaobag .. "jubao_solt_bk.png",x,y,40,40,nil, show_my_paihang_item_tip);
        self.get_item_paihang_solt:set_icon(item_data.id)
        self.get_item_paihang_solt:set_setScale(58/62)
        self.get_item_paihang_solt:set_item_count(item_data.num)

    end
------------------------------------------------------------------------------------------------------------------------------
    self.get_item_rank_solt = {}
    for i=1,#_jubao_bag_slot_id.paihang do
        local item_data = _jubao_bag_slot_id.paihang[i]
        local function show_my_paihang_item_tip( )--排行奖励
            ActivityModel:show_mall_tips( item_data.id )
        end
        self.get_item_rank_solt = MUtils:create_slot_item(self.left_bgPanel,UIResourcePath.FileLocate.jubaobag .. "jubao_solt_bk.png",35+63*(i-1),216,50,50,nil, show_my_paihang_item_tip);
        self.get_item_rank_solt:set_icon(item_data.id)
        self.get_item_rank_solt:set_item_count(item_data.num)
    end

    local vip = VIPModel:get_vip_info();
    self:showTanbaoBtn_by_vip_level(vip.level);

end


function JubaoBagWin:create_right_bgPanel(self)
    self.right_bgPanel = ZBasePanel:create(self,nil,431-55, 69, 210,386, 500, 500)

    self.right_panel_radio_guoup = ZRadioButtonGroup:create(self.right_bgPanel,0 ,270 ,95*2,35,0);

    for i=1,2 do --排行榜 聚宝战报
        local function btn_fun()
            self:change_page_index( i )             -- 重新布局界面
        end
        local btn = ZImageButton:create(nil,{"ui/jubaobag/tab_n.png","ui/jubaobag/tab_s.png"},BTN_STR_PATH[i],btn_fun)
        self.right_panel_radio_guoup:addItem(btn,3);
    end
    self:change_page_index(1)

    ZLabel:create( self.right_bgPanel, Lang.jubao.myself_score, 15, 66,14)--你目前总积分:
    self.my_score = ZLabel:create( self.right_bgPanel, "", 15+104, 66,14)
    
    ZLabel:create( self.right_bgPanel, Lang.jubao.myself_rand, 15+0, 44,14)--你目前的排行:
    self.my_rank = ZLabel:create( self.right_bgPanel, "", 15+104, 44,14)

    --聚宝仓库
    function jubao_cangku_fun(  )
        UIManager:show_window("dreamland_cangku_win")
    end
    ZButton:create(self.right_bgPanel,UIResourcePath.FileLocate.jubaobag .. "jubao_cangku.png",jubao_cangku_fun,34,0,-1,-1)

end
--
function JubaoBagWin:__init( window_name, texture_name )
    self.all_page_t = {}
    self:create_left_bgPanel(self)
    self:create_right_bgPanel(self)

    function jubao_question_btn( )  --疑问btn
        local win = HelpPanel:show( 3, "ui/common/rule_explan.png",  Lang.jubao.question_btn_text  )
        win:set_bk_img("ui/common/nine_grid_bg5.png")
        return true
       
    end
    ZButton:create(self,UIResourcePath.FileLocate.jubaobag .. "jubao_question.png",jubao_question_btn,587,275,-1,-1)
    
    function jubao_close_btn( )
        UIManager:hide_window("jubao_bag_win");
    end
    ZButton:create(self,UIResourcePath.FileLocate.jubaobag .. "jubao_close.png",jubao_close_btn,587,362,-1,-1)
end


--切换功能窗口:   1:排行榜  2：聚宝战报
function JubaoBagWin:change_page_index( but_index )
   --先清除当前界面
    self.right_panel_radio_guoup:selectItem(but_index-1)
    if self.current_panel then
        self.current_panel.view.view:setIsVisible(false)     -- 最终要使用这个来隐藏
        print("hide ni mei")
    end
    if but_index == 1 then--聚宝排行
        if self.all_page_t[1] == nil then
            self.all_page_t[1] = RankPage( self.right_bgPanel )
        end
        self.current_panel = self.all_page_t[1]

    elseif  but_index == 2 then
        if self.all_page_t[2] == nil then--聚宝战报
            self.all_page_t[2] = JubaoFightPage( self.right_bgPanel )
        end
        self.current_panel = self.all_page_t[2]
    end
    self.current_panel.view.view:setIsVisible(true)
    self.current_panel:active(true)
    -- buff
end

--
function JubaoBagWin:create( texture_name )
  

end

-- 供外部调用，刷新所有数据
function JubaoBagWin:update_win( update_type )

end

--刷新所有属性数据
function JubaoBagWin:update( Type ,my_data,other_data ) -- Type 1：排行榜   2：聚宝战报
    ZXLog("Type ,my_data,other_data",Type ,my_data,other_data)
    if Type == 1 then--Type 1 更新排行榜  
        if self.current_panel then
            self.current_panel:update(other_data)
        end

        self.my_score:setText("#cba387a" .. my_data.score)
        self.my_rank:setText("#cba387a" .. my_data.rank)
    elseif Type == 2 then--Type 2 聚宝战报
        if self.current_panel then
            self.current_panel:update()
        end    
    elseif Type == 3 then  --更新时间
        if self.recharge_time_lab then 
            self.recharge_time_lab:destroy();
            self.recharge_time_lab = nil;
        end
        local time = SmallOperationModel:get_act_time( 35 ); --聚宝袋 活动id=35
        print("time",time);
        local function finish_call(  )
            if self.recharge_time_lab then
              self.recharge_time_lab:setString("活动已截止，请尽快领取所得奖励")
            end
        end
        -- 充值奖励的倒计时
        self.recharge_time_lab = TimerLabel:create_label( self.view, 260, 30 , 16, time, nil, finish_call, false);  -- lyl ms

        if time == nil or time <= 0 then
            finish_call();
        end  
    end



end



-- 打开或者关闭是调用. 参数：是否激活
function JubaoBagWin:active( show )
    local vip = VIPModel:get_vip_info();
    self:showTanbaoBtn_by_vip_level(vip.level);
    -- if self.current_panel then
    --     self.current_panel:active(show)
    -- end
    if show then--更新时间
        self:update(3)
        DreamlandCC:request_cangku_list();
    end
end



function JubaoBagWin:destroy()
    if self.recharge_time_lab then
      self.recharge_time_lab:destroy();
      self.recharge_time_lab = nil;
    end
    Window.destroy(self)
    -- for key, page in pairs(self.all_page_t) do
    --     page:destroy()
    -- end

end

