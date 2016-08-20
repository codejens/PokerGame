-- ShenMiSellPanel.lua
-- created by lxm on 2014-5-19
-- 商城出售一件物品的panel区域


super_class.ShenMiSellPanel(  ) 

-- 参数：出售物品信息
function ShenMiSellPanel:__init( item_info,i )
    -- print("打印物品信息",item_info.id)
    local pos_x =  0
    local pos_y =  0
    self.view = CCBasePanel:panelWithFile( pos_x, pos_y, 250, 160, UILH_COMMON.bg_11, 500, 500 )
    local item_base = ItemConfig:get_item_by_id( item_info.id )
    if item_base == nil then
        return 
    end

    -- slot
    self.slot = SlotItem( 70, 70 )
    self.slot:set_icon_bg_texture( UILH_COMMON.slot_bg, -7, -8, 84, 84 )   -- 背框
    -- self.slot:setPosition( 13, 13 )
    self.slot:set_icon_ex( item_info.id )

    self.slot:setPosition( 12, 34 )
    self.slot:set_icon(  item_info.id )
    self.slot:set_color_frame(  item_info.id, 1, 1, 68, 68 )    -- 边框颜色
    self.view:addChild( self.slot.view )

    self.select_img = CCZXImage:imageWithFile( -2, -3, 255, 165, UILH_COMMON.select_focus2,500,500 )
    self.view:addChild(self.select_img)
    self.select_img:setIsVisible(false)
    self.selected = false
     local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            self.selected = true
            local win = UIManager:find_visible_window("shenmi_shop_win")
             win:change_select()
            return true
        elseif eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_ENDED then
            return true;
        end
    end


    self.view:registerScriptHandler(but_1_fun)



    -- slot单击
    local function item_click_fun (slot_obj, eventType, arg, msgid)
        local position = Utils:Split(arg,":");
        -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local pos = self.slot.view:convertToWorldSpace( CCPointMake(position[1],position[2]) );
        MallModel:show_mall_tips( item_info.id, pos.x, pos.y)
    end
    self.slot:set_click_event(item_click_fun)


    --名字的底板
    local title_bg = CCZXImage:imageWithFile( 0, 128, 250, 31, UILH_NORMAL.title_bg4 )
    local name_color = MallModel:get_item_color( item_info.id )
    self.name = UILabel:create_lable_2( name_color..item_base.name, 92, 8, 16, ALIGN_LEFT )
    local title_size = title_bg:getSize()
    local name_size = self.name:getSize()
    self.name:setPosition(title_size.width/2-name_size.width/2,title_size.height/2- name_size.height/2)
    title_bg:addChild( self.name )
    self.view:addChild(title_bg)


    -- self.prince_name = _static_money_type[ item_info.type ] or ""  -- 金钱类型
    local money_type_img = nil 
    local money_type_img2 = nil 

    -- print("item_info.type",item_info.type)

    --根据策划要求  又做特殊处理   更改第一行，原价全改成元宝
    if i ==1 or i ==2 then
       money_type_img =UILH_MAINACTIVITY.xiaoyuanbao 

        if item_info.type == 3 then
             money_type_img2 =UILH_MAINACTIVITY.xiaoyuanbao 
            elseif item_info.type == 0 then
             money_type_img2 =UILH_MAINACTIVITY.xiaotongbi 
        end


    else

        if item_info.type == 3 then
             money_type_img =UILH_MAINACTIVITY.xiaoyuanbao 
             money_type_img2 =UILH_MAINACTIVITY.xiaoyuanbao 
            elseif item_info.type == 0 then
             money_type_img =UILH_MAINACTIVITY.xiaotongbi 
             money_type_img2 =UILH_MAINACTIVITY.xiaotongbi 
        end
    end
    self.prime_cost_value = item_info.before_price                  -- 原价
    self.prime_cost_lable = UILabel:create_lable_2(  LH_COLOR[12].."原价："..self.prime_cost_value, 98, 91, 14, ALIGN_LEFT ) -- [1476]="#cffff00原价"
    self.view:addChild( self.prime_cost_lable )

    local xiao_tongbi = CCZXImage:imageWithFile( 208, 88, -1, -1, money_type_img )
    self.view:addChild(xiao_tongbi)
    
    local line = CCZXImage:imageWithFile( -5, 5, 110, 2, UILH_COMMON.split_line_3)
    self.prime_cost_lable:addChild(line)
    -- 划线
    -- local line = CCZXImage:imageWithFile( 67, 58, 102, 2, UIResourcePath.FileLocate.other .. "white_line.png")
    -- self.view:addChild( line )


    -- local line = CCZXImage:imageWithFile( 99, 16, 3, 75, UILH_COMMON.split_line )     
    -- self.view:addChild( line )  

    -- 现价
    self.now_cost_value = item_info.now_price                         -- 现价 
    self.now_cost_lable = UILabel:create_lable_2( LH_COLOR[10].."现价："..self.now_cost_value, 99, 65, 14, ALIGN_LEFT ) -- [1477]="#cffff00现价"
    self.view:addChild( self.now_cost_lable )

    local xiao_tongbi2 = CCZXImage:imageWithFile( 208, 59, -1, -1, money_type_img2)
    self.view:addChild(xiao_tongbi2)
    -- -- 购买按钮
    local function buy_but_callback()
        local if_select = ShenMiShopModel:get_select(  )
        if not if_select then
            print(1)
            self:con_buy( item_info ,name_color..item_base.name)
        else
            print(2)

            --MiscCC:req_buy_item(item_info.id,1)
            self:buy_item( item_info.now_price ,item_info.id, item_info.type)
        end
        --MiscCC:req_buy_item(item_info.id,1)
    end
    self.buy_but = ZButton:create(self.view, UILH_COMMON.button4, buy_but_callback, 94, 7, -1, -1)  -- [1016]="购买"
    local buy_name = UILabel:create_lable_2( LH_COLOR[2].."购买", 10, 10, 16, ALIGN_LEFT )
    local  buy_size = self.buy_but:getSize()
    local  buy_name_size = buy_name:getSize()
    buy_name:setPosition(buy_size.width/2-buy_name_size.width/2+1,buy_size.height/2- buy_name_size.height/2+3)
    self.buy_but:addChild(buy_name)
end

-- 确认购买
function ShenMiSellPanel:con_buy(item_info ,name)
    print(1)
    local function confirm_func(  )
        --MiscCC:req_buy_item(item_info.id,1)
        self:buy_item( item_info.now_price ,item_info.id,item_info.type)
    end
    local function swith_but_func( is_select )
        ShenMiShopModel:set_select( is_select )
    end

    local money_type = Lang.normal[2]
    if item_info.type == 3 then
     money_type = Lang.normal[4]
    elseif item_info.type == 0 then
     money_type = Lang.normal[2]
    end
    

    local confirm_word = "确定花费#cd5c241"..item_info.now_price..money_type.."#cffffff购买"..name.."#cffffff吗?"
    ConfirmWin2:show( 5, 0, confirm_word, confirm_func,swith_but_func )
end

function ShenMiSellPanel:buy_item( price ,id,type)
    local avatar = EntityManager:get_player_avatar();--角色拥有元宝

    if type == 0 then --铜币
          if avatar.bindYinliang <price then
             ConfirmWin2:show( nil, 13, Lang.screen_notic[11],  need_money_callback, nil, nil )
          else
             MiscCC:req_buy_item(id,1)
          end

    elseif type == 3 then  --元宝
      
        if avatar.yuanbao < price then --如果元宝不足
            local function confirm2_func()
                GlobalFunc:chong_zhi_enter_fun()
            end
            ConfirmWin2:show( 2, 2, "",  confirm2_func)  --打开元宝不足界面
        else
            MiscCC:req_buy_item(id,1)
        end

    end


        --MiscCC:req_refresh_item( 0 ) --如果元宝足 ！

end



