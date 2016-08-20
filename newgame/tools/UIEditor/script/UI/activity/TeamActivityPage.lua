-- TeamActivityPage.lua  
-- created by mwy on 2014-08-15
-- 组队副本页  
-- 这个页面是忍者学园项目组的，天将雄师已经没在用了。 note by gzn

super_class.TeamActivityPage(Window)
require "model/ActivityModel"


-- 增加挑战次数是否不再提示
local show_tip = true

function TeamActivityPage:create(  )
	return TeamActivityPage( "TeamActivityPage", nil , true, 857, 535 )
end

function TeamActivityPage:__init( window_name, texture_name )

    self.fuben_data = { }
	self:create_left_panel( )
    self:create_right_panel( )
    
    self:update_fuben_btn( )
    self:update()	
end
function TeamActivityPage:create_left_panel(  )
	-- 副本列表
    local list_panel = CCBasePanel:panelWithFile(5, 4, 256, 523,UIPIC_TeamActivity_001,500,500);
    self.view:addChild(list_panel);

    self.team_scroll = CCScroll:scrollWithFile( 3, 0, 256, 510, 1, "", TYPE_HORIZONTAL, 600, 600 )

    local btn_num = TeamActivityMode:get_fuben_num(  )
    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(0 ,0, 170, 100 * btn_num, nil)


    for i=1,btn_num do
        local function did_selected_act(  )
            self:change_page(i)
        end
        local act_button = self:create_a_button(3, 98 * (btn_num-i)+6, -1, -1, 
                                UIPIC_TeamActivity_005, UIPIC_TeamActivity_006, i, did_selected_act)
        self.raido_btn_group:addGroup(act_button)
    end
    self.team_scroll:addItem(self.raido_btn_group)
    self.team_scroll:refresh()
    list_panel:addChild(self.team_scroll)
end
function TeamActivityPage:create_a_button(pos_x, pos_y, size_w, size_h, image_n, image_s, index, func)
    local one_btn =  CCRadioButton:radioButtonWithFile(pos_x, pos_y, size_w, size_h, image_n)
    one_btn:addTexWithFile(CLICK_STATE_DOWN, image_s)

    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN  then 
            return true
        elseif eventType == TOUCH_CLICK then
            func(index)
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        end
    end
    one_btn:registerScriptHandler(but_1_fun)    --注册

    -- 按钮标题
    local fuben_info = TeamActivityMode:get_fuben_info( index )
    local btn_text = ZImage.new(fuben_info.title)
    btn_text:setPosition(51, 51)
    one_btn:addChild(btn_text.view)
    --产出
    local product_tab = fuben_info.product
    local product_title = ZImage.new(product_tab[1])
    product_title:setPosition(23, 19)
    one_btn:addChild(product_title.view)

    for i = 2,#product_tab do 
        local x,y = 75+36*(i-2),14
        local product = ZImage.new(product_tab[i])
        product:setPosition(x, y)
        one_btn:addChild(product.view)
    end 

    local times_bg  = CCZXImage:imageWithFile(185, 53, -1, -1,UIPIC_TeamActivity_023)
    one_btn:addChild(times_bg)
    local times_lable = UILabel:create_lable_2( "", 20, 11, 16, ALIGN_CENTER)
    times_bg:addChild( times_lable )

    local times_table = {}
    times_table.times_bg = times_bg
    times_table.times_lable = times_lable
    self.fuben_data[index] = times_table

    if fuben_info.if_open == false then 
        times_bg:setIsVisible(false)
    else 
        times_bg:setIsVisible( true)
    end 

    return one_btn
end
function TeamActivityPage:create_right_panel(  )
    self.right_panel = CCBasePanel:panelWithFile(250, 4, 608, 523,UIPIC_TeamActivity_001,500,500);
    self.view:addChild(self.right_panel);

    -- 副本显示图片部分
    self:show_fuben_picture( self.right_panel )

    --增加次数按钮 
    local function add_times_fun( eventType,x,y )
        ZXLog(" 未完成----------------发送服务器增加次数请求：")
        self:show_increase_dialog()
    end
    self.add_times_btn= ZImageButton:create(self.right_panel, UIPIC_TeamActivity_007,"",add_times_fun,380,118,-1,-1)
    self.add_times_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_TeamActivity_008)
    local text_lable = UILabel:create_lable_2( "#cffffff增加次数", 20, 20, 18, ALIGN_LEFT )
    self.add_times_btn.view:addChild(text_lable)

    -- 挑战副本按钮
    local function enter_fun( eventType,x,y )
        local fuben = TeamActivityMode:get_now_select_btn(  )
        TeamWin:show(fuben)
    end
    self.enter_btn= ZImageButton:create(self.right_panel, UIPIC_TeamActivity_009,"",enter_fun,329,10,-1,-1)
    self.enter_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_TeamActivity_010) 
    self.enter_image = CCZXImage:imageWithFile(59, 14, -1, -1,UIPIC_TeamActivity_011)
    self.enter_btn.view:addChild(self.enter_image)

    --兑换积分按钮
    local function exchange_fun( eventType,x,y )
         ZXLog(" 未完成----------------")
       -- self.exchange_btn:setCurState(CLICK_STATE_DISABLE);
    end
    self.exchange_btn= ZImageButton:create(self.right_panel, UIPIC_TeamActivity_007,"",exchange_fun,76,10,-1,-1)
    self.exchange_btn.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_TeamActivity_008)
    local text_lable_exchange = UILabel:create_lable_2( "#cffffff兑换积分", 20, 20, 18, ALIGN_LEFT )
    self.exchange_btn.view:addChild(text_lable_exchange)

    --副本次数
    self.fuben_times = UILabel:create_lable_2( "#cf1e7d4副本次数:", 372, 85, 20, ALIGN_LEFT )
    self.right_panel:addChild(self.fuben_times)

    -- 46 147 副本奖励
    self.reward = UILabel:create_lable_2( "#cf1e7d4副本奖励:", 46, 160, 20, ALIGN_LEFT )
    self.right_panel:addChild(self.reward)
    --奖励内容
    self.reward_text = CCDialogEx:dialogWithFile(70, 75, 186, 60, 15, "" , TYPE_VERTICAL,ADD_LIST_DIR_UP);
    self.reward_text:setAnchorPoint(0, 0)
    self.reward_text:setFontSize(20);
    self.right_panel:addChild(self.reward_text);
    self.reward_text:setText("");

end
function TeamActivityPage:show_fuben_picture( panel )
    --副本预览
    local show_fuben = CCBasePanel:panelWithFile( 11, 193, 572,314,UIPIC_TeamActivity_013,500,500)
    panel:addChild(show_fuben)
    --图片尺寸：563,305
    self.show_image = CCZXImage:imageWithFile(4, 5, 563, 305,"nopack/MiniMap/wyc3.jpg")
    show_fuben:addChild(self.show_image)

    --未开放标示
    self.open_activity = CCZXImage:imageWithFile(200, 100, -1, -1,UIPIC_TeamActivity_004)
    show_fuben:addChild( self.open_activity )
    self.open_activity:setIsVisible( false )
    -- 副本标题
    local line = CCZXImage:imageWithFile(140, 262, -1, -1,UIPIC_TeamActivity_014)
    self.show_image:addChild(line)
    self.picture_title = CCZXImage:imageWithFile(85, 6, -1, -1,"ui/teamActivity/activity_1_small.png")
    line:addChild(self.picture_title)

    --挑战等级
    local dengji_image = CCZXImage:imageWithFile(26, 9, -1, -1,UIPIC_TeamActivity_015)
    show_fuben:addChild(dengji_image)
    self.dengji_need = UILabel:create_lable_2( "", 153, 13, 18, ALIGN_LEFT )
    show_fuben:addChild(self.dengji_need)
    --队伍人数
    local duiwu_image = CCZXImage:imageWithFile(350, 9, -1, -1,UIPIC_TeamActivity_016)
    show_fuben:addChild(duiwu_image)
    self.duiwu_num = UILabel:create_lable_2( "", 470, 13, 18, ALIGN_LEFT )
    show_fuben:addChild(self.duiwu_num)
end
function  TeamActivityPage:show_increase_dialog(  )
    local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
    local fuben_listid = TeamActivityMode:get_fuben_listid(  )
    local price = TeamActivityMode:get_fuben_add_price(  )
    local param = { [1]= fuben_listid ,[2] = money_type}

    local increase_func = function( param )
        MiscCC:req_add_fuben_count(param[1],param[2])
    end

    print("param[1],param[2]",param[1],param[2])

    if ( show_tip ) then
        local function fun( _show_tip )
            MallModel:handle_auto_buy( price, increase_func, param )
        end
        local function swith_but_func ( _show_tip )
            show_tip = not _show_tip;
        end
        -- local str = string.format(LangGameString[2409],self.cost,self.fuben_name)
        local fuben_name = TeamActivityMode:get_fuben_name( )
        local str = string.format(LangGameString[2409],price,fuben_name)
        ConfirmWin2:show( 5, nil, str, fun, swith_but_func ) 
    else
        MallModel:handle_auto_buy( price, increase_func, param )
    end
end
-- 更新右侧显示的面板
function TeamActivityPage:change_right_panel( )
    local duiwu  = self.current_fuben_info.duiwu_num
    local dengji = self.current_fuben_info.challenge_dengji
    local if_open = self.current_fuben_info.if_open
    local picture = self.current_fuben_info.fuben_picture
    local title  = self.current_fuben_info.small_title
    local reward_text  = self.current_fuben_info.reward
    self.duiwu_num:setText(duiwu)
    self.dengji_need:setText(dengji)
    self.show_image:setTexture( picture )
    self.picture_title:setTexture(title )
    self.reward_text:setText(reward_text);
    --ZXLog("----------------------是否开启了副本：",if_open)
    if if_open then
        self.open_activity:setIsVisible( false )
        self.add_times_btn:setCurState(CLICK_STATE_UP);
        self.enter_btn:setCurState(CLICK_STATE_UP);
        --第一个组队副本没有兑换按钮
        local index = TeamActivityMode:get_now_select_btn(  )
        if index == 1 then 
            self.exchange_btn:setCurState(CLICK_STATE_DISABLE);
        else 
            self.exchange_btn:setCurState(CLICK_STATE_UP);
        end 
        self.enter_image:setTexture( UIPIC_TeamActivity_011 );
    else 
        local text = "#cf1e7d4副本次数:0/0"
        self.fuben_times:setText(text)

        self.open_activity:setIsVisible( true )
        self.add_times_btn:setCurState(CLICK_STATE_DISABLE);
        self.enter_btn:setCurState(CLICK_STATE_DISABLE);
        self.exchange_btn:setCurState(CLICK_STATE_DISABLE);
        self.enter_image:setTexture(UIPIC_TeamActivity_012);
    end  
end 
--切页
function TeamActivityPage:change_page( page_index )
    TeamActivityMode:set_now_select_btn( page_index )

    self.current_fuben_info = TeamActivityMode:get_select_fuben_info(  )
    --请求服务器信息 对应的副本信息
    TeamActivityMode:get_current_fuben_times( )

	self:change_right_panel(  )
    self.raido_btn_group:selectItem(page_index-1)
end
function TeamActivityPage:update_times( table,index )
    if table then 
        local text = "#cf1e7d4副本次数:"..table.had_enter_num.."/"..table.total_num
        local text1 = "#cf1e7d4"..table.can_enter_num
        self.fuben_times:setText(text)
        ZXLog("------------------------text1:",text1)
        self.fuben_data[index].times_lable:setText(text1)
        if table.can_enter_num <= 0 then 
            self.enter_btn:setCurState(CLICK_STATE_DISABLE);
        else 
            self.enter_btn:setCurState(CLICK_STATE_UP);
        end 
    end 
end
function TeamActivityPage:update_fuben_btn(  )
    TeamActivityMode:get_all_fuben(  )
    for i = 1,#self.fuben_data do 
        local table =TeamActivityMode:get_fuben_can_enter_times( i )
        local text1 = "#cf1e7d4"..table.can_enter_num
        self.fuben_data[i].times_lable:setText(text1)
    end 
end
function TeamActivityPage:update( update_type,fuben_times_table )
    -- ZXLog("update_type:",update_type)
    local index = TeamActivityMode:get_now_select_btn(  )
    if update_type == "update_fuben_num" then
        self:update_times(fuben_times_table,index)
    elseif update_type == "fuben_times" or update_type == "all" then 

    else 
       -- ZXLog("四季红id") 
        self:change_page( index )
    end 
end 
-- 销毁窗体
function TeamActivityPage:destroy()
    Window.destroy(self)
end
