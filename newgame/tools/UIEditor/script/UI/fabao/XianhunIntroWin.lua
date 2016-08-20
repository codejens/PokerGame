-- XianhunIntroWin.lua
-- created by fangjiehua on 2013-5-23
-- 法宝系统--仙魂介绍窗口

super_class.XianhunIntroWin(NormalStyleWindow)

function XianhunIntroWin:__init(  )

	--背景低图
    local base_bg = CCBasePanel:panelWithFile(10,12,366,376,UILH_COMMON.bottom_bg,500,500);
    self:addChild(base_bg);

	-- 标题
	-- local title = CCZXImage:imageWithFile(135,402,-1,-1,UIResourcePath.FileLocate.faBao .. "intro_title.png");
	-- self:addChild(title);
    
    -- 仙魂数据
    local xianhun_infos = FabaoConfig:get_xianhun_intro_info( );
    local split_img = CCZXImage:imageWithFile(4,25+322,358,-1,UIResourcePath.FileLocate.common .. "nice_bg.png" ,500 ,500);
    base_bg:addChild(split_img);
    --
    local lab_1 = UILabel:create_lable_2( LangGameString[942], 50-13, 350, 15, ALIGN_LEFT ); -- [942]="#cfff000装备仙魂"
    base_bg:addChild(lab_1);
    local lab_2 = UILabel:create_lable_2( LangGameString[943], 50+135-13, 350, 15, ALIGN_LEFT ); -- [943]="#cfff000仙魂效果"
    base_bg:addChild(lab_2);

    ---- 仙魂列表 panel
    local xianhun_panel = CCBasePanel:panelWithFile(40-17,37-28,324,340,"")
    base_bg:addChild(xianhun_panel);
    
    -- scrollView
    self.xianhun_scroll = CCScroll:scrollWithFile( 1, 1, 336 , 315, #xianhun_infos, "", TYPE_HORIZONTAL, 600, 600 )
    self.xianhun_scroll:setScrollLump(UIResourcePath.FileLocate.common .. "up_progress.png", UIResourcePath.FileLocate.common .. "down_progress.png", 4, 40, 35)
    
    local function scrollfun(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return false
        end
        local temparg = Utils:Split(arg,":")
        local row = temparg[1]  --列数
        if row == nil then 
            return false;
        end
        
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then
        	
	        local cell = XianhunCell:create_for_intro_scroll(0, 0, 320, 63,xianhun_infos[row+1] );
	        self.xianhun_scroll:addItem(cell.view)
	        self.xianhun_scroll:refresh()
	        return true

        end
    end
    
    self.xianhun_scroll:registerScriptHandler(scrollfun)
    self.xianhun_scroll:refresh()
    xianhun_panel:addChild(self.xianhun_scroll);


end
