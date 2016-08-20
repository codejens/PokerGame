-- LianhunWin.lua
-- created by fangjiehua on 2013-5-22
-- 法宝系统-炼魂窗口


super_class.LianhunWin(NormalStyleWindow)


-- 初始化
function LianhunWin:__init( )
	
	-- 标题
	local title = CCZXImage:imageWithFile(135,402,-1,-1,UIResourcePath.FileLocate.faBao .. "bag_title.png");
	self:addChild(title);

	-- 关闭按钮
	-- local close_btn = CCNGBtnMulTex:buttonWithFile(0, 0, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png")
 --    local exit_btn_size = close_btn:getSize()
 --    local spr_bg_size = self:getSize()
 --    close_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
 --  	close_btn:addTexWithFile(CLICK_STATE_DOWN,UIResourcePath.FileLocate.common .. "close_btn_s.png")
 --  	--注册关闭事件
 --  	local function close_fun( eventType )
 --  		if eventType == TOUCH_CLICK then
	-- 	  	UIManager:hide_window("lianhun_win");
	--   	end
	--   	return true
 --  	end
	-- close_btn:registerScriptHandler(close_fun) 
 --    self:addChild(close_btn)

    local bg = MUtils:create_zximg(self.view,UIPIC_GRID_nine_grid_bg3,10,12,366,376,500,500);
    
    -- 器魂列表
    self.xianhun_item_list = {};
    for i=1,20 do
    	
    	local x = 52 + ( (i-1) % 5 ) * ( 71 );
    	local y = 356 - ( math.floor( (i-1) / 5 )  ) * (74);
        local xianhun_item = XianhunCell:create_for_loop( x, y,87, 85,nil );

        local function equip_xianhun(  )
            self:equip_xianhun(i);
        end
        local function xianhun_tip(  )
            -- print("炼魂界面，器魂tip");
            -- TipsModel:show_shop_tip( 0, 0, _crystal_ids[i], TipsModel.LAYOUT_LEFT)
         
            local xianhun_list = FabaoModel:get_lianhun_xianhun_list( );
            if xianhun_list[i] then
                TipsModel:show_fabao_xianhun( 0,0, xianhun_list[i], TipsModel.LAYOUT_LEFT );
            end
        
        end

        local function drag_in_event( cur_cell, other_slot )
            -- 有格子拖进来

            FabaoModel:xiahun_swallow_logic( cur_cell, other_slot )
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
        end

        local lianhunshi = MUtils:create_one_slotItem( nil, 22+(i-1)*72, 107 );
        lianhunshi:set_click_event(click_lianshi);
    	self:addChild(lianhunshi);
    		
        
        --背景图案
        local lianhun_bg = ZCCSprite:create( lianhunshi,UIResourcePath.FileLocate.faBao .. "hunter_bg.png" , 24, 25 )
    	local str ;
        local hunter = FabaoConfig:get_lianhunshi( i );
    	if i == 1 then
    		str = LangGameString[970]..hunter.bindCoin; -- [970]="#cfff000仙币:#cffffff"
    	else
	    	str = "#cffffff"..hunter.bindCoin;
	    end
	    local lianhunshi_cost = UILabel:create_lable_2( str, 48/2, -26, 12, ALIGN_CENTER );
	    lianhunshi.view:addChild( lianhunshi_cost )

        
        lianhunshi:set_icon_texture( UIResourcePath.FileLocate.faBao .. "hunter"..(i-1)..".png");

        if i ~= 1 then
            lianhunshi:set_slot_disable();
        end

        self.lianhunshi_list[i] = lianhunshi;

    end

    for i=1,4 do
    	local img = MUtils:create_zximg(self.view, UIResourcePath.FileLocate.faBao .. "nest.png",21+(i-1)*73+49,123,-1,-1,nil,nil,99);
    end

    -- 分割线
    local split_img1 = CCZXImage:imageWithFile( 12,170,360,-1,UIResourcePath.FileLocate.common .. "fenge_bg.png");
    self:addChild(split_img1);
    local split_img2 = CCZXImage:imageWithFile( 12,75,360,-1,UIResourcePath.FileLocate.common .. "fenge_bg.png");
    self:addChild(split_img2);

    -- 一键合成按钮
    local function one_key_merge(  )
        
        local function sure_func(  )
            FabaoModel:req_one_key_hecheng( );
        end 

        NormalDialog:show(LangGameString[971],sure_func,1); -- [971]="自动吞噬背包里紫色以下器魂"
    end
    local one_key_merge_btn = TextButton:create(nil, 40+100+10, 42, 85, 30, LangGameString[972], UIResourcePath.FileLocate.common .. "button_four.png"); -- [972]="一键合成"
    one_key_merge_btn:setTouchClickFun(one_key_merge)
    self:addChild( one_key_merge_btn.view );

	-- 一键炼魂按钮
    local function one_key_lianhun(  )
        
        FabaoModel:req_one_key_lianhun(  )
    
    end
    self.one_key_lianhun_btn = TextButton:create(nil, 25, 42, 85, 30, LangGameString[973], UIResourcePath.FileLocate.common .. "button_four.png"); -- [973]="一键炼魂"
    self.one_key_lianhun_btn:setTouchClickFun(one_key_lianhun);
    self:addChild( self.one_key_lianhun_btn.view );
    

    --召唤阴阳印  
    local function call_yinyang_event(  )
        FabaoModel:req_lianhun( 4, true);
        self:req_call_yinyang_count()
    end
    self.call_yinyang_btn = TextButton:create(nil, 80+100+10+100+10, 42, 65, 30, LangGameString[974], UIResourcePath.FileLocate.common .. "button2.png"); -- [974]="阴阳印"
    self.call_yinyang_btn:setTouchClickFun(call_yinyang_event);
    self:addChild( self.call_yinyang_btn.view ); 

    -- 召唤阴阳印需要的费用以及次数
    local call_yinyang_cost = UILabel:create_lable_2( LangGameString[975], 275, 20, 14, ALIGN_LEFT ); -- [975]="#cffffff每次#cfff000200#cffffff元宝"
    self:addChild( call_yinyang_cost );

    self.call_yinyang_count = UILabel:create_lable_2( LangGameString[976], 130, 20, 14, ALIGN_LEFT ); -- [976]="#c38ff33次数:#cffffff50/50"
    self:addChild( self.call_yinyang_count );

end	
----------------------逻辑操作

-- 装备器魂
function LianhunWin:equip_xianhun( index )
    
    local xianhun_list = FabaoModel:get_lianhun_xianhun_list( );


    local equip_xianhun = xianhun_list[index];
    FabaoModel:equip_a_xianhun( equip_xianhun ); 

end

-- 请求今天召唤了多少次阴阳印
function LianhunWin:req_call_yinyang_count(  )
    FabaoModel:req_call_yinyang_count(  )
end



-----------------------界面更新
function LianhunWin:active( show )
    if show then
         -- 请求器魂包裹的器魂列表
        FabaoModel:req_lianhun_bag_list();
        self:req_call_yinyang_count()

        self:show_one_key_lianhun_btn();
        self:show_yinyang_btn();
        
    end
end


-- 更新器魂列表
function LianhunWin:update_xianhun_list(  )
    local xianhun_list = FabaoModel:get_lianhun_xianhun_list( );

    for i=1,20 do

        if xianhun_list[i] then
            if xianhun_list[i].level == 2 then
                -- print("器魂",xianhun_list[i].level,xianhun_list[i].value);
            end

            self.xianhun_item_list[i]:update_loop_cell( xianhun_list[i] );
        else 
            self.xianhun_item_list[i]:clear_loop_cell();
        end

    end
    --     local count = 13 --从服务器下发的数据
    --     for i,xianhun_item in ipairs( self.xianhun_item_list) do
        
    --     if i > count then
    --         print(i,count);
    --         xianhun_item:set_seal_visible(true);
    --     else 
    --         xianhun_item:set_seal_visible(false);
    --     end

    --     if xianhuns[i] then
            
    --         xianhun_item:update_loop_cell(xianhuns[i]);
    --     else
    --         xianhun_item:clear_loop_cell();
    --     end

    -- end




end

-- 更新炼魂师列表
function LianhunWin:update_lianhunshi_list(  )
        
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
function LianhunWin:update_yinyang_count( count, all_count )
    if count <= 0 then
        self.call_yinyang_btn.view:setCurState(CLICK_STATE_DISABLE);
    else 
        self.call_yinyang_btn.view:setCurState(CLICK_STATE_UP);
    end
    self.call_yinyang_count:setText(LangGameString[977]..count.."/"..all_count); -- [977]="#c38ff33次数:#cffffff"


end

function LianhunWin:show_one_key_lianhun_btn(  )
    if VIPModel:get_vip_info( ).level >= 4 then
        self.one_key_lianhun_btn.view:setIsVisible(true);
    else
        self.one_key_lianhun_btn.view:setIsVisible(false);
    end
end

-- 显示阴阳印
function LianhunWin:show_yinyang_btn(  )
    if VIPModel:get_vip_info( ).level >= 5 then
        self.call_yinyang_btn.view:setIsVisible(true);
        self.call_yinyang_count:setIsVisible(true);
       
    else
        self.call_yinyang_btn.view:setIsVisible(false);
         self.call_yinyang_count:setIsVisible(false);
    end
end
