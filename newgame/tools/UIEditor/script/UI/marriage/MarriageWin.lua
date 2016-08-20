-- MarriageWin.lua
-- create by fjh on 2013-8-13
-- 结婚系统

super_class.MarriageWin(NormalStyleWindow)



function MarriageWin:__init(  )
    --普通背景	
    local bg_img = MUtils:create_zximg( self.view, UIResourcePath.FileLocate.marriage.."tip_bg.png", 15, 18, 350, 390 ,5,5);
    
    --情缘背景
    self.qingyuan_bg = CCBasePanel:panelWithFile( 15, 5, 355, 388, UIResourcePath.FileLocate.marriage.."qingyuan_bg.png");
    self.view:addChild(self.qingyuan_bg);


    local img = MUtils:create_zximg( self.view, UIResourcePath.FileLocate.marriage.."img.png", -30, 98, 222, 350 );
    img:setFlipX(true);
    local img = MUtils:create_zximg( self.view, UIResourcePath.FileLocate.marriage.."img.png", 185+6.5, 98, 222, 350 );

    --hcl
    -- self.window_title_bg.view:removeFromParentAndCleanup(true);

    local title = MUtils:create_zximg(self.view, UIResourcePath.FileLocate.marriage.."title.png", 143, 395, 101, 29)

    -- 关闭按钮
   --  local close_btn = CCNGBtnMulTex:buttonWithFile(0, 0, -1, -1, UIResourcePath.FileLocate.marriage .. "close_btn.png")
   --  local exit_btn_size = close_btn:getSize()
   --  local spr_bg_size = self:getSize()
   --  close_btn:setPosition( spr_bg_size.width - exit_btn_size.width-5, spr_bg_size.height - exit_btn_size.height-5 )
   --  close_btn:addTexWithFile( CLICK_STATE_DOWN,UIResourcePath.FileLocate.marriage .. "close_btn.png" )
   --    	--注册关闭事件
   --  local function close_fun( eventType )
   --  		if eventType == TOUCH_CLICK then
  	-- 		  UIManager:hide_window("marriage_win");
  	-- 	  end
  	-- 	  return true
  	-- end
	  -- close_btn:registerScriptHandler(close_fun) 
   --  self:addChild(close_btn,99)

    -- 帮助按钮
	local close_btn = CCNGBtnMulTex:buttonWithFile(0, 0, -1, -1, UIResourcePath.FileLocate.marriage .. "help_btn.png")
    local exit_btn_size = close_btn:getSize()
    local spr_bg_size = self:getSize()
    close_btn:setPosition( spr_bg_size.width - exit_btn_size.width-5-40, spr_bg_size.height - exit_btn_size.height-5 )
  	close_btn:addTexWithFile(CLICK_STATE_DOWN,UIResourcePath.FileLocate.marriage .. "help_btn.png")
  	--点击事件
  	local function close_fun( eventType )
    	if eventType == TOUCH_CLICK then
            local str = LangGameString[1532]; -- [1532]="1、准备一枚#cfff000求婚戒指(通过深海之恋获得或者商城购买获得)#r#cffffff2、你与你的心仪对象等级均在#cfff00041级#cffffff以上#r3、你与你的心仪对象#cfff000彼此单身#r#cffffff4、你与你的心仪对象是#cfff000好友#r#cffffff5、你与你的心仪对象是#cfff000互为异性#r#cffffff6、具备以上条件，选中他（她）勇敢的点击求婚吧"
  			HelpPanel:show( 3, UIResourcePath.FileLocate.marriage.."tip_title_1.png", str );
  		end
  		return true
  	end
  	close_btn:registerScriptHandler(close_fun) 
    self:addChild(close_btn,99)

    -- tab 按钮
    self.radio_btn_dict = {};
  	self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(0, 0, 40, 370,nil);
    self:addChild(self.raido_btn_group);
    local img = {UIResourcePath.FileLocate.marriage.."qingyuan.png", UIResourcePath.FileLocate.marriage.."hunyang.png", UIResourcePath.FileLocate.marriage.."yunche.png"};
    for i=1,3 do
        local function btn_fun(eventType,x,y)
            if eventType == TOUCH_CLICK then
                MarriageModel:changed_page_type( i );
            end
            return true;
        end
        local x = -23;
        local y = 390 - i * 125;
        local btn = MUtils:create_radio_button(self.raido_btn_group,UIResourcePath.FileLocate.marriage.."tab_btn.png",UIResourcePath.FileLocate.marriage.."tab_btn_d.png",btn_fun,x,y,53,134,false);

     	  local lab = MUtils:create_zximg(btn,img[i],20,20,23,70);
        self.radio_btn_dict[i] = {button = btn, label = lab};

    end

    -----------仙侣情缘
    self.qingyuan_page = MarriageQingyuanPage(0,0,355,388);
    self.qingyuan_bg:addChild(self.qingyuan_page.view);

    -----------举办婚宴
    self.hunyang_page = MarriageHunYanPage( 0, 0, 350, 390 );
    self:addChild(self.hunyang_page.view);
    -- self.hunyang_page.view:setIsVisible(false);

    -----------云车巡游
    self.yunche_page = MarriageYunchePage( 0,0,350,390);
    self:addChild(self.yunche_page.view);
    -- self.yunche_page.view:setIsVisible(false);

    

end


function MarriageWin:selected_tab_btn( type )
    
  
    if type == MarriageModel.PAGE_TYPE_QINGYUAN then

        self.raido_btn_group:selectItem(0);

        self.qingyuan_page.view:setIsVisible(true);
        self.qingyuan_bg:setIsVisible(true);
        self.hunyang_page.view:setIsVisible(false);
        self.yunche_page.view:setIsVisible(false);

        -- 切换的该分页时需要请求更新数据
        MarriageCC:req_observor_xianyuan( )
        self:update_sweet_value(  )

    elseif type == MarriageModel.PAGE_TYPE_HUNYAN then

        self.raido_btn_group:selectItem(1);

        self.qingyuan_page.view:setIsVisible(false);
        self.qingyuan_bg:setIsVisible(false);
        self.hunyang_page.view:setIsVisible(true);
        self.yunche_page.view:setIsVisible(false);

    elseif type == MarriageModel.PAGE_TYPE_YUNCHE then

        self.raido_btn_group:selectItem(2);

        self.qingyuan_page.view:setIsVisible(false);
        self.qingyuan_bg:setIsVisible(false);
        self.hunyang_page.view:setIsVisible(false);
        self.yunche_page.view:setIsVisible(true);
        
    end

    local win = UIManager:find_visible_window("marriage_right_win")
    if win == nil then
        win = UIManager:show_window("marriage_right_win");
    end
    win:change_page(type);
end

-------------------------界面更新
function MarriageWin:active( show )
    
    if show then
        -- self:update_sweet_value(  );
        -- 选择第一个分页
        UIManager:show_window("marriage_right_win");
        self:selected_tab_btn( MarriageModel.PAGE_TYPE_QINGYUAN );
    else
        
        self:open_win_for_xunyou( false );
        UIManager:hide_window("marriage_right_win");
    end
    
    self.qingyuan_page:active(show);
    self.yunche_page:active(show)
end

-- 更新仙缘等级
function MarriageWin:update_xianyuan_level( )

    local data = MarriageModel:get_marriage_data();
    print("MarriageWin更新仙缘等级", data.count, data.level);
    if data.count ~= nil  and data.level ~= nil then
       -- print("MarriageWin更新仙缘等级", data.count, data.level);
        self.qingyuan_page:update_xianyuan_level( data.count, data.level );
    end

    -- 同时更新亲密度
    self:update_sweet_value();

end
-- 播放升级特效
function MarriageWin:play_uplevel_effect( type )
    if 1 == type then 
        --类型1是小红心特效
        local data = MarriageModel:get_marriage_data();
        self.qingyuan_page:play_heart_effect( data.count )
    elseif 2 == type then
        --类型2是大红心特效
        self.qingyuan_page:play_xy_uplevel_effect(  )
    end
end


-- 更新亲密度
function MarriageWin:update_sweet_value(  )

    local data = MarriageModel:get_marriage_data();
    if data.sweet ~= nil then
        -- print( "更新亲密度", data.sweet );
        self.qingyuan_page:update_sweet_value( data.sweet );
    end

end

-- 特殊函数，用于从仙缘月老打开云车巡游的窗口
function MarriageWin:open_win_for_xunyou( bool )
    if bool then
        self.raido_btn_group:setIsVisible(false);
        self:selected_tab_btn( MarriageModel.PAGE_TYPE_YUNCHE );
        UIManager:hide_window("marriage_right_win");
        self.yunche_page:set_xunyou_enable(true);
    else
        
        self:selected_tab_btn( MarriageModel.PAGE_TYPE_QINGYUAN );
        self.raido_btn_group:setIsVisible(true);
        
        -- UIManager:hide_window("marriage_right_win");
    end
end
