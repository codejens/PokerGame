-- CaiQuanWin.lua
-- create by fjh 2013-7-27

super_class.CaiQuanWin(Window)

function CaiQuanWin:__init(  )

	-- 标题
    -- local title_sp = CCZXImage:imageWithFile(764/2-230/2,441-45-15,226,46,UIResourcePath.FileLocate.common .. "win_title1.png");
    -- self:addChild(title_sp,99);
    -- local title = CCZXImage:imageWithFile(226/2-55/2-8, 46/2-30/2+2, 55, 30, UIResourcePath.FileLocate.caiquan .. "title.png");
    -- title_sp:addChild(title);

	-- -- 关闭按钮
	-- local close_btn = CCNGBtnMulTex:buttonWithFile(764-50, 441-56, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png")
 --    local exit_btn_size = close_btn:getSize()
 --    local spr_bg_size = self:getSize()
 --    close_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
 --  	close_btn:addTexWithFile(CLICK_STATE_DOWN,UIResourcePath.FileLocate.common .. "close_btn_s.png")
 --  	--注册关闭事件
 --  	local function close_fun(eventType,x,y )
	-- if eventType == TOUCH_CLICK then
 --            if CaiQuanModel:get_game_state() == CaiQuanModel.GAME_STATE_MATCHING then
 --                -- 取消匹配
 --                CaiQuanModel:req_cancel_match(  )
 --                UIManager:hide_window("caiquan_win");
	-- 		elseif CaiQuanModel:get_game_state() == CaiQuanModel.GAME_STATE_WAITE then
 --                UIManager:hide_window("caiquan_win");
 --            end
	-- 	end
	-- 	return true
	-- end
	-- close_btn:registerScriptHandler(close_fun) 
 --    self:addChild(close_btn,99)
	


	local main_panel = CCBasePanel:panelWithFile( 20,20+123,713,240,UIResourcePath.FileLocate.common.."bg_blue.png",500,500);
    self:addChild(main_panel);
    local bg_img = MUtils:create_zximg( main_panel,UIResourcePath.FileLocate.caiquan.."bg.png",4.5,4.5,703,234 );

    -- 自己的形象
    self.avatar = MUtils:create_zximg( bg_img, "nopack/half_body10.png", 100, 0, 264, 294 );
    self.avatar:setScale(0.8);
    -- 自己的信息
    self.mine_info_cell = CaiQuanCell( 5, 56);
    main_panel:addChild(self.mine_info_cell.view);

    -- vs
    self.vs = MUtils:create_zximg( bg_img, UIResourcePath.FileLocate.caiquan.."vs.png", 703/2-115/2,234/2-122/2, 115, 122 );
   
    -- 对手的形象
    self.match_avatar = MUtils:create_zximg( bg_img, UIResourcePath.FileLocate.caiquan.."unknown.png", 100+310, 0, 264, 294 );
    self.match_avatar:setScale(0.8);
    
    -- 对手的信息
    self.match_info_cell = CaiQuanCell( 5+500+34+3, 56);
    main_panel:addChild(self.match_info_cell.view);

    --等待匹配
    self.waite_match_img = MUtils:create_zximg( self.match_info_cell.view, UIResourcePath.FileLocate.caiquan.."match1.png", 25,150-45, 98, 27 );
    -- 配对成功
    self.match_succesed = MUtils:create_zximg( main_panel, UIResourcePath.FileLocate.caiquan.."match_3.png", 288, 0, 144, 65 );
    self.match_succesed:setIsVisible(false);

    -- 出拳
    self.self_quan = MUtils:create_zximg( bg_img, UIResourcePath.FileLocate.caiquan.."shitou_img.png", 703/2-109/2-77,234/2-91/2, 109, 81 );
    self.self_quan:setIsVisible(false);
    -- 出拳
    self.match_quan = MUtils:create_zximg( bg_img, UIResourcePath.FileLocate.caiquan.."shitou_img.png", 703/2-109/2+77,234/2-91/2, 109, 81 );    
    self.match_quan:setIsVisible(false);

    -- 匹配时间
    self.match_time = TimerLabel:create_label( main_panel, 347+10, 90+90, 14, 1, nil, nil, false, ALIGN_CENTER, true);
    self.match_time:setString("");

    -- 当前银两 
    self.money_bg = MUtils:create_zximg( bg_img, UIResourcePath.FileLocate.caiquan.."img4.png", 93-60, 0, 120, 39 );
    local img = MUtils:create_zximg( self.money_bg, "icon/money/1.pd", 0, 2, 48, 48 );
    --local img = MUtils:create_zximg( self.money_bg, "icon/money/1.png", 0, 2, 48, 48 );
    self.money_lab = UILabel:create_lable_2( "#cffff001000000", 50, 11, 14, ALIGN_LEFT );
    self.money_bg:addChild(self.money_lab);

    -- 匹配
    local function match_btn_click( eventType )
    	if TOUCH_CLICK == eventType then
    		CaiQuanModel:req_match_event(  )
    	end
    	return true;
    end
    -- 匹配按钮
    self.match_btn = MUtils:create_btn( main_panel,UIResourcePath.FileLocate.caiquan.."match_btn.png" ,UIResourcePath.FileLocate.caiquan.."match_btn.png",
    				match_btn_click,713/2-60/2,240/2-60/2-80,60,60);
    -- self.match_btn:setIsVisible(false);

    -- 取消匹配
    local function cancel_match_btn_click( eventType )
    	if TOUCH_CLICK == eventType then
    		CaiQuanModel:req_cancel_match(  )
    	end
    end
    -- 取消匹配按钮
    self.cancel_btn = MUtils:create_btn( main_panel,UIResourcePath.FileLocate.caiquan.."cancel_btn.png" ,UIResourcePath.FileLocate.caiquan.."cancel_btn.png",
    				cancel_match_btn_click,713/2-60/2,240/2-60/2-80,60,60);
    self.cancel_btn:setIsVisible(false);


    -- 剪刀石头布
    self.btn_dict = {};
    local imgs = {"shitou_btn.png","jiandao_btn.png","bu_btn.png"};
    
    for i=1, 3 do
    	local function caiquan_event( eventType )
	    	if TOUCH_CLICK == eventType then
	    		CaiQuanModel:req_take_caiquan( i )
                for index,v in ipairs(self.btn_dict) do
                    if i ~= index then
                        v:setCurState(CLICK_STATE_DISABLE);
                    end 
                end
	    	end
	    end
    	local btn = MUtils:create_btn( main_panel,UIResourcePath.FileLocate.caiquan..imgs[i], UIResourcePath.FileLocate.caiquan..imgs[i],
    				caiquan_event,242+(i-1)*81,240/2-66/2-80, 66, 66);
    	btn:setIsVisible(false);
    	self.btn_dict[i] = btn;
    end



    -- 提示内容
	local tip_panel = CCBasePanel:panelWithFile( 20,20,713,119,UIResourcePath.FileLocate.common.."bg_blue.png",500,500);
    self:addChild(tip_panel);

    local lab = UILabel:create_lable_2( LangGameString[672], 17, 91-5, 14, ALIGN_LEFT ); -- [672]="#cffff00提示:"
    tip_panel:addChild(lab);

    local labs = {LangGameString[673], -- [673]="1.点击匹配按钮，系统将随机为您选取互动玩家，匹配未成功不需要消耗任何银两."
                LangGameString[674], -- [674]="2.配对成功后自动缴纳2000银两，游戏结束后系统按照玩家所得进行返还."
                LangGameString[675], -- [675]="3.配对后5秒内未做出选择或掉线，系统将为您随机选取出拳方式."
                LangGameString[676]}; -- [676]="4.猜拳胜利可获得4000银两，平局获得2000银两，败北不能获得银两."
    for i=1 , 4 do
        local lab = UILabel:create_lable_2( "#cffff00"..labs[i], 17+65, 112-5-(i-1)*25, 14, ALIGN_LEFT );
        self:addChild(lab);
    end


    -- local str = "#cffff00#r#cffff00#r#cffff00#r#cffff00"
    -- local desc_dialog = MUtils:create_ccdialogEx( tip_panel, str, 66, 90, 670, 20, 4, 14 );
    -- desc_dialog:setAnchorPoint(0,1);

end


----------------------界面更新
function CaiQuanWin:active( show )
    if show then
        CaiQuanModel:req_self_info( )
    end
end

-- 更新自己的信息
function CaiQuanWin:update_self_info(  )
	local self_info = CaiQuanModel:get_self_info(  )
    self.mine_info_cell:update( self_info );

    local player = EntityManager:get_player_avatar();
    local texture_path = string.format( "nopack/half_body%d%d.png", player.job, player.sex );
    self.avatar:setTexture( texture_path );

    self.money_lab:setText(self_info.money);

end

-- 进入等待匹配状态
function CaiQuanWin:enter_waite_for_match(  )
	-- 显示匹配按钮
	self.match_btn:setIsVisible(true);
	-- 隐藏取消按钮
    self.cancel_btn:setIsVisible(false);

    -- 显示猜拳按钮
	for i,v in ipairs(self.btn_dict) do
		v:setIsVisible(false);
	end

    -- 隐藏一些该隐藏的
    self.vs:setIsVisible(true);
    self.mine_info_cell.view:setIsVisible(true);
    self.match_info_cell.view:setIsVisible(true);

    self.self_quan:setIsVisible(false);
    self.match_quan:setIsVisible(false);
    self.match_quan:setFlipX(false);
    -- 显示银两
    self.money_bg:setIsVisible(false);

    --设置对手形象
    self.match_avatar:setFlipX(false);
    self.match_avatar:setTexture(UIResourcePath.FileLocate.caiquan.."unknown.png")

    self.waite_match_img:setIsVisible(true);
    self.waite_match_img:setTexture(UIResourcePath.FileLocate.caiquan.."match1.png");
    -- 隐藏计时
    self.match_time:setString("");

    self.avatar:setPosition(100, 0)
    self.match_avatar:setPosition(100+320, 0);

    --更新信息
    self:update_self_info();

    -- 设置为未知
    self.match_info_cell:set_unknown_status();

end


-- 进入匹配中状态
function CaiQuanWin:enter_match_ing_status(  )
	-- 隐藏匹配按钮
	self.match_btn:setIsVisible(false);
	-- 显示取消按钮
    self.cancel_btn:setIsVisible(true);
    -- 显示猜拳按钮
	for i,v in ipairs(self.btn_dict) do
		v:setIsVisible(false);
	end

    self.waite_match_img:setIsVisible(true);
    self.waite_match_img:setTexture(UIResourcePath.FileLocate.caiquan.."match2.png");

    self.match_time:setText(1);

end

-- 进入匹配成功状态
function CaiQuanWin:enter_match_succesed( data )
    
    -- 隐藏匹配按钮
    self.match_btn:setIsVisible(false);
    -- 隐藏取消按钮
    self.cancel_btn:setIsVisible(false);
    -- 隐藏计时
    self.match_time:setString("");
    -- 隐藏匹配图片
    self.waite_match_img:setIsVisible(false);
    -- 匹配成功
    self.match_succesed:setIsVisible(true);

    -- 更新对手信息
    self.match_info_cell:update( data );

    -- 更新对手形象
    local texture_path = string.format("nopack/half_body%d%d.png", data.job, data.sex);
    self.match_avatar:setFlipX(false);
    self.match_avatar:setTexture( texture_path );
    self.match_avatar:setFlipX(true);

     -- 播放闪电特效
    LuaEffectManager:play_view_effect( 11011, 713/2,240,self.view,false );

    local ck = callback:new( )
    local function call_back(  )
        self:enter_waite_for_caiquan_status( )
        ck:cancel();
    end
    -- 2秒钟后进入出拳匹配状态
    ck:start( 2, call_back );

end



-- 进入出拳状态
function CaiQuanWin:enter_waite_for_caiquan_status( )
	

	-- 显示猜拳按钮
	for i,v in ipairs(self.btn_dict) do
		v:setIsVisible(true);
        v:setCurState(CLICK_STATE_UP);
	end
    -- 匹配成功
    self.match_succesed:setIsVisible(false);
    --显示vs图片
    self.vs:setIsVisible(false);
    -- 显示银两
    self.money_bg:setIsVisible(true);

    -- 倒计时
    MUtils:create_big_count_down( self.view, 760/2-40, 429/2+20,5, nil, true)

    self.avatar:setPosition(0, 0)
    self.match_avatar:setPosition(500, 0);
    self.mine_info_cell.view:setIsVisible(false);
    self.match_info_cell.view:setIsVisible(false);
end


-- 进入猜拳结果显示状态
function CaiQuanWin:enter_show_result_status( data )
	
    print(" 进入猜拳结果显示状态");
	local ck = callback:new()

	local function result_call_back(  )
		-- self:enter_waite_for_match(  )
        CaiQuanModel:req_self_info( )
		ck:cancel();
	end
    -- 5秒钟后进入等待匹配状态
	ck:start( 5, result_call_back );

    -- 隐藏掉一些东西
    self.vs:setIsVisible(false);
  
    --显示出拳
    self.self_quan:setIsVisible(true);
    self.match_quan:setIsVisible(true);

    local self_sele, match_sele;
    if data.self_sele == 1 then
        self_sele = "shitou_img.png"
    elseif data.self_sele == 2 then
        self_sele = "jiandao_img.png"
    elseif data.self_sele == 3 then
        self_sele = "bu_img.png"
    end
    self.self_quan:setTexture( UIResourcePath.FileLocate.caiquan..self_sele );

    if data.matcher_sele == 1 then
        match_sele = "shitou_img.png"
    elseif data.matcher_sele == 2 then
        match_sele = "jiandao_img.png"
    elseif data.matcher_sele == 3 then
        match_sele = "bu_img.png"
    end
    self.match_quan:setTexture( UIResourcePath.FileLocate.caiquan..match_sele )
    self.match_quan:setFlipX(true);
    -- 

    if data.result == -1 then
        -- 输了
        LuaEffectManager:play_view_effect( 11014, 713/2+22,240+36,self.view,false );
    elseif data.result == 0 then
        -- 平局
        LuaEffectManager:play_view_effect( 11012, 713/2+22,240+36,self.view,false );
    elseif data.result == 1 then
        -- 赢了
        LuaEffectManager:play_view_effect( 11013, 713/2+22,240+36,self.view,false );
    end
     
end
