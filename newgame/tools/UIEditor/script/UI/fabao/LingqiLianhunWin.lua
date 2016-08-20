
-- LingqiLianhunWin.lua
-- created by fangjiehua on 2013-5-22
-- 灵器系统-灵器炼魂


super_class.LingqiLianhunWin(Window)

local lhs_array = {
    UILH_LINGQI.hunter0,
    UILH_LINGQI.hunter1,
    UILH_LINGQI.hunter2,
    UILH_LINGQI.hunter3,
    UILH_LINGQI.hunter4,
}

--
local word_image_t =       {UILH_BAG_AND_CANGKU.dian,    --"点击可扩展"图片路径
                            UILH_BAG_AND_CANGKU.ji,
                            UILH_BAG_AND_CANGKU.ke, 
                            UILH_BAG_AND_CANGKU.kuo,
                            UILH_BAG_AND_CANGKU.zhan}
--翻页按钮




--创建方法
function  LingqiLianhunWin:create( )
	return LingqiLianhunWin( "LingqiLianhunWin", UILH_COMMON.bottom_bg, true, 441, 497)
end

-- 初始化
function LingqiLianhunWin:__init( )	
    self.yyl_count = 0 
    -- 器魂列表
    self.xianhun_item_list = {};
    --20个槽位
    for i=1,20 do
    	
    	--炼魂背包坐
    	local x = 53 + ( (i-1) % 5 ) * ( 85 );
    	local y = 440 - ( math.floor( (i-1) / 5 )  ) * (78);

        local xianhun_item = XianhunCell:create_for_loop( x, y,85, 85,nil );

        local function equip_xianhun(  )
            self:equip_xianhun(i);
        end
        

        --弹出tip的回调
        local function xianhun_tip(  )
            -- TipsModel:show_shop_tip( 0, 0, _crystal_ids[i], TipsModel.LAYOUT_LEFT)
            local xianhun_data = FabaoModel:get_lianhun_xianhun_list( );
            --器魂背包中的个数
            local  xianhun_list = xianhun_data.xianhun_list
            if xianhun_list then
                if xianhun_list[i] then
                    TipsModel:show_fabao_xianhun( 0,0, xianhun_list[i], TipsModel.LAYOUT_LEFT );
                end
            end

            --请求购买
            local function confirm_fun(  )
                FabaoModel:req_open_xianhun_slot(5)
            end
 
              --如果灵器背包格子没解封 并且是点击可扩展
            if xianhun_item.seal_icon_visible and xianhun_item.seal_icon_buy  then

                   local player = EntityManager:get_player_avatar()
                    if (player == nil) then
                        player = {};
                        player.yuanbao = 0;
                        player.yinliang = 0;
                    end
                     -- 显示 元宝
                    if (player.yuanbao == nil) then
                        player.yuanbao = 0;
                    end
                    
                    --如果少于50元宝  则提示
                    if player.yuanbao < 50 then
                        GlobalFunc:create_screen_notic(Lang.screen_notic[3],16,700,250); 
                    else
                        ConfirmWin( "select_confirm", nil,LH_COLOR[2]..Lang.lingqi.lianhun[18], confirm_fun, nil, 450, 130)
                    end

            end
            
            --灵器格子未解封 不是点击可拓展  则提示
            if xianhun_item.seal_icon_visible and xianhun_item.seal_icon_buy ==false then
                local alert_text = Lang.lingqi.lianhun[17]
                GlobalFunc:create_screen_notic(alert_text,16,700,250);
            end
        end
        
        local function drag_in_event( cur_cell, other_slot )
            -- 添加了器魂背包解封判断
              if cur_cell.seal_icon_visible and xianhun_item.seal_icon_buy then
                local alert_text = Lang.lingqi.lianhun[20]
                GlobalFunc:create_screen_notic(alert_text,16,700,250);
            else 
                FabaoModel:xiahun_swallow_logic( cur_cell, other_slot )
            end
        end 
 

        xianhun_item:set_double_click_event(equip_xianhun);
        xianhun_item:set_click_event(xianhun_tip);
        xianhun_item:set_drag_in( drag_in_event );
        xianhun_item:set_win_name("lianhun_win");
    	
        xianhun_item.view:setAnchorPoint(0.5,0.5);
        self:addChild(xianhun_item.view);
        self.xianhun_item_list[i] = xianhun_item;


    end

    -- 炼魂师
    self.lianhunshi_list = {};
    for i=1,5 do

        local function click_lianshi(  )
        --炼魂
            FabaoModel:req_lianhun( i, false);
            --刷新炼魂背包
            FabaoModel:req_lianhun_bag_list()
            -- --更新元宝
            -- self:update_money()
        end
       local lianhunshi = MUtils:create_slot_item2( self,UILH_COMMON.slot_bg, 29+(i-1)*84, 90,46,46,nil,click_lianshi,17 );
         lianhunshi:set_icon_bg_texture( UILH_COMMON.slot_bg, -17, -17, 80, 80 )   -- 背框
   
    	local str ;
        local hunter = FabaoConfig:get_lianhunshi( i );
    	if i == 1 then
    		str =LH_COLOR[2]..Lang.lingqi[9]..LH_COLOR[15]..hunter.bindCoin; -- [970]="#cfff000仙币:#cffffff"
    	else
	    	str = "#cffffff"..hunter.bindCoin;
	    end
	    local lianhunshi_cost = UILabel:create_lable_2( str, 50/2, -20, 14, ALIGN_CENTER );
	    lianhunshi.view:addChild( lianhunshi_cost )
        lianhunshi:set_icon_texture(lhs_array[i]);
        if i ~= 1 then
            lianhunshi:set_slot_disable();
        end
        self.lianhunshi_list[i] = lianhunshi;

    end
   
    --四个箭头
    -- for i=1,4 do
    -- 	local img = MUtils:create_zximg(self.view, UILH_LINGQI.right_arrows,32+(i-1)*87+49,92,-1,-1,nil,nil,99);
    -- end

    -- 分割线
    local split_img1 = CCZXImage:imageWithFile( 12,62,410,3,UILH_COMMON.split_line);
    self:addChild(split_img1);

   local pos_y_btn = 10

    -- 一键合成按钮
    local function one_key_merge(  )
        local function sure_func(  )
            FabaoModel:req_one_key_hecheng( );
        end 
        NormalDialog:show(LH_COLOR[2]..Lang.lingqi.lianhun[1],sure_func,1); -- [971]="自动吞噬背包里紫色以下器魂"
    end

    local one_key_merge_btn = TextButton:create( nil, 156, pos_y_btn, -1, -1, LH_COLOR[2]..Lang.lingqi.lianhun[2], UILH_COMMON.btn4_nor ) 
    one_key_merge_btn:setTouchClickFun(one_key_merge)
    one_key_merge_btn.view:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.btn4_nor)
    self:addChild(one_key_merge_btn.view)


	-- 一键炼魂按钮
    local function one_key_lianhun(  )
        FabaoModel:req_one_key_lianhun(  )
        --刷新背包
        FabaoModel:req_lianhun_bag_list()
        --刷新元宝
        self:update_money()
    end

    self.one_key_lianhun_btn = TextButton:create( nil, 19, pos_y_btn, -1, -1, LH_COLOR[2]..Lang.lingqi.lianhun[3], UILH_COMMON.btn4_nor ) 
    self.one_key_lianhun_btn:setTouchClickFun(one_key_lianhun)
    self.one_key_lianhun_btn.view:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.btn4_nor)
    self:addChild(self.one_key_lianhun_btn.view)


    --召唤阴阳印  
    local function call_yinyang_event(  )

        if self.yyl_count == 0 then
            --如果次数用完 提示 今天阴阳印次数已用完
            GlobalFunc:create_screen_notic(Lang.lingqi.lianhun[16],16,700,250)
        else
            FabaoModel:req_lianhun( 4, true);
            self:req_call_yinyang_count()
                --刷新背包
            FabaoModel:req_lianhun_bag_list()
                    --刷新元宝
            self:update_money()
        end

    end
    self.call_yinyang_btn = TextButton:create( nil, 300, pos_y_btn, -1, -1, LH_COLOR[2]..Lang.lingqi.lianhun[4], UILH_COMMON.lh_button_4_r ) 
    self.call_yinyang_btn:setTouchClickFun(call_yinyang_event)
    self.call_yinyang_btn.view:addTexWithFile(CLICK_STATE_DOWN,UILH_COMMON.lh_button_4_r)
    self:addChild(self.call_yinyang_btn.view)

    
    local txt_pos = 4   --提示文字位置y

    -- 召唤阴阳印需要的费用以及次数
    self.call_yinyang_cost = UILabel:create_lable_2(Lang.lingqi.lianhun[5], 171, txt_pos, 14, ALIGN_LEFT ); -- [975]="#cffffff每次#cfff000200#cffffff元宝"
    self:addChild( self.call_yinyang_cost,99 );

    self.call_yinyang_count = UILabel:create_lable_2( Lang.lingqi.lianhun[6], 318, txt_pos, 14, ALIGN_LEFT ); -- [976]="#c38ff33次数:#cffffff50/50"
    self:addChild( self.call_yinyang_count );

    --创建铜币元宝
    self:init_money ()

    local hint = UILabel:create_lable_2(LH_COLOR[2]..Lang.lingqi[7],10, 476, 14, ALIGN_LEFT )
    self:addChild(hint)
end	

--初始化铜币
function LingqiLianhunWin:init_money( )
	local player = EntityManager:get_player_avatar();
    if (player == nil) then
        player = {};
        player.yuanbao = 0;
        player.bindYinliang = 0;
    end

	 -- 显示 元宝
    if (player.yuanbao == nil) then
        player.yuanbao = 0;
    end
    local lab = UILabel:create_lable_2(
        LH_COLOR[2]..Lang.lingqi[10], 377, 476, 14, ALIGN_RIGHT)
    self:addChild(lab)
    self.lab_yuanBao = UILabel:create_lable_2( player.yuanbao, 372, 476, 14, ALIGN_LEFT )
    self:addChild(self.lab_yuanBao);

   
    if (player.bindYinliang == nil) then
        player.bindYinliang = 0;
    end
    lab = UILabel:create_lable_2(LH_COLOR[2]..Lang.lingqi[9], 267-30, 476, 14, ALIGN_RIGHT)
    self:addChild(lab)
    self.lab_xianBi = UILabel:create_lable_2( player.bindYinliang, 262-23, 476, 14, ALIGN_LEFT )
    self:addChild(self.lab_xianBi);
end

------------------------逻辑操作-----------------------------------------------------
-- 装备器魂
function LingqiLianhunWin:equip_xianhun( index )
     --器魂
    local xianhun_data = FabaoModel:get_fabao_xianhun(  )
    local count = xianhun_data.count;
    local xianhuns = xianhun_data.xianhuns;
    
    if count == #xianhuns then
         GlobalFunc:create_screen_notic( LH_COLOR[2]..Lang.lingqi[14],16,700,250 );
    end
    --
    local xianhun_data = FabaoModel:get_lianhun_xianhun_list( );
    --背包中的仙魂
    local  xianhun_list = xianhun_data.xianhun_list
    local equip_xianhun = xianhun_list[index];
    FabaoModel:equip_a_xianhun( equip_xianhun ); 
end


-- 请求今天召唤了多少次阴阳印
function LingqiLianhunWin:req_call_yinyang_count(  )
    FabaoModel:req_call_yinyang_count(  )
end

-----------------------界面更新
function LingqiLianhunWin:active( show )
	print("function LingqiLianhunWin:active( show )")
    if show then
         -- 请求器魂包裹的器魂列表
        FabaoModel:req_lianhun_bag_list();
        self:req_call_yinyang_count()
        --显示一键炼魂
        self:show_one_key_lianhun_btn();
        --显示阴阳印
        self:show_yinyang_btn();    

        --更新器魂列表
         self:update_xianhun_list()    
    end
end


-- 更新器魂列表
function LingqiLianhunWin:update_xianhun_list(  )

    local xianhun_data = FabaoModel:get_lianhun_xianhun_list( );
    
    local xianhun_list =xianhun_data.xianhun_list
           --器魂背包中的打开格子
    local xianhun_open_count = xianhun_data.count
    
    if not xianhun_open_count then
        xianhun_open_count = 0
    end
    -- print("背包中的格子数",xianhun_open_count)

    --加上器魂背包的解封判断
     for i,xianhun_item in ipairs( self.xianhun_item_list ) do
        
        if i > xianhun_open_count then
            xianhun_item:set_seal_visible(true);
        else 
            xianhun_item:set_seal_visible(false);
        end
        xianhun_item.seal_icon_buy = false
        if xianhun_item.word_icon then 
             xianhun_item.word_icon:removeFromParentAndCleanup(true);
        end
       
        xianhun_item.word_icon = nil
       
       if xianhun_list then
           if xianhun_list[i] then
                if xianhun_list[i].level == 2 then
                    -- print("器魂",xianhun_list[i].level,xianhun_list[i].value);
                end

                self.xianhun_item_list[i]:update_loop_cell( xianhun_list[i] );
            else 
                self.xianhun_item_list[i]:clear_loop_cell();
            end
        end
    end
    


   --点击可扩展
   if xianhun_open_count < 20 then
       for i= xianhun_open_count+1,xianhun_open_count + 5  do
           local slot = self.xianhun_item_list[i]
           slot.seal_icon_buy =true
           if (i -xianhun_open_count <=5) and (i -xianhun_open_count >=1) then
              if slot.word_icon ==nil then
                 slot.word_icon = CCZXImage:imageWithFile( 12, 12, -1, -1, word_image_t[i -xianhun_open_count] )
                 slot.view:addChild(slot.word_icon)
              end
           end
       end
    end

       --更新钱
    self:update_money()


end

--清空点击可拓展
function LingqiLianhunWin:clear_click_open( slot )
    slot.seal_icon_buy = false
    slot.word_icon = nil
end
-- 更新炼魂师列表
function LingqiLianhunWin:update_lianhunshi_list(  )
        
    local data_list = FabaoModel:get_lianhunshi_list( );

    for index=2,#self.lianhunshi_list do
        -- 第一个炼魂师永远有效
        local lianhunshi = self.lianhunshi_list[index];
        lianhunshi:set_slot_disable( );

        for i,id in ipairs(data_list) do
            if id == index then
                lianhunshi:set_slot_enable( );
                break;
            end
        end

    end

end


-- 更新阴阳印的次数
function LingqiLianhunWin:update_yinyang_count( count, all_count )

    if count <= 0 then
        self.call_yinyang_btn.view:setCurState(CLICK_STATE_DISABLE);
    else 
        self.call_yinyang_btn.view:setCurState(CLICK_STATE_UP);
    end
    self.call_yinyang_count:setText(Lang.lingqi.lianhun[7]..count.."/"..all_count); -- [977]="#c38ff33次数:#cffffff"
    self.yyl_count = count
end

--update 铜币 元宝
function LingqiLianhunWin:update_money( )
   local player = EntityManager:get_player_avatar()
    if (player == nil) then
        player = {};
        player.yuanbao = 0;
        player.bindYinliang = 0;
    end
	 -- 显示 元宝
    if (player.yuanbao == nil) then
        player.yuanbao = 0;
    end
     
        if (player.bindYinliang == nil) then
        player.bindYinliang = 0;
    end
    
    if self.lab_yuanBao then       
      self.lab_yuanBao:setString(player.yuanbao) -- [649]="#c00c0ff元  宝: 
      self.lab_xianBi:setString(player.bindYinliang) 
    end

end


function LingqiLianhunWin:show_one_key_lianhun_btn(  )
    if VIPModel:get_vip_info( ).level >= 4 then
        self.one_key_lianhun_btn.view:setIsVisible(true);
    else
        self.one_key_lianhun_btn.view:setIsVisible(false);
    end
end

-- 显示阴阳印
function LingqiLianhunWin:show_yinyang_btn(  )
    if VIPModel:get_vip_info( ).level >= 5 then
        self.call_yinyang_btn.view:setIsVisible(true);
        self.call_yinyang_count:setIsVisible(true);
         self.call_yinyang_cost:setIsVisible(true)
       
    else
        self.call_yinyang_btn.view:setIsVisible(false);
         self.call_yinyang_count:setIsVisible(false);
          self.call_yinyang_cost:setIsVisible(false)
    end
end