-- FabaoDetailWin.lua
-- created by fangjiehua on 2013-5-22
-- 法宝系统--详细信息窗口

super_class.FabaoDetailWin(NormalStyleWindow)

-- 初始化
function FabaoDetailWin:__init( )
    

    --背景低图
    local base_bg = CCBasePanel:panelWithFile(10,12,366,376,UIPIC_GRID_nine_grid_bg3,500,500);
    self:addChild(base_bg);

	-- 标题
	local title = CCZXImage:imageWithFile(135,402,-1,-1,UIResourcePath.FileLocate.faBao .. "detail_title.png");
	self:addChild(title);

    local split_img = CCZXImage:imageWithFile(14,20+340,358,-1,UIResourcePath.FileLocate.common .. "nice_bg.png",500,500);
    self:addChild(split_img);
    local lab_1 = UILabel:create_lable_2( LangGameString[942], 40, 363, 15, ALIGN_LEFT ); -- [942]="#cfff000装备仙魂"
    self:addChild(lab_1);
    local lab_2 = UILabel:create_lable_2( LangGameString[943], 40+135, 363, 15, ALIGN_LEFT ); -- [943]="#cfff000仙魂效果"
    self:addChild(lab_2);
    ---- 仙魂列表 panel
    local xianhun_panel = CCBasePanel:panelWithFile(24,27,394,335,"")
    self:addChild(xianhun_panel);
    
    -- scrollView 拖动区域
    self.xianhun_scroll = CCScroll:scrollWithFile( 1, 1, 338 , 315, 1, "", TYPE_HORIZONTAL, 600, 600 )
    self.xianhun_scroll:setScrollLump(UIResourcePath.FileLocate.common .. "up_progress.png", UIResourcePath.FileLocate.common .. "down_progress.png", 4, 40, 35)
    
    local function scrollfun(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return false
        end
        local temparg = Utils:Split(arg,":")
        local row = temparg[1]  --行数
        
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
            
            local xianhun_data = FabaoModel:get_fabao_xianhun(  )
            local xianhun_list = xianhun_data.xianhuns;
            local xianhun = nil;
            if #xianhun_list > 0 then
                xianhun = xianhun_list[row+1];
            end
            print("FabaoDetailWin-- 创建第",row+1);
            local cell = XianhunCell:create_for_scroll(0, 0, 320, 63, xianhun);
            self.xianhun_scroll:addItem(cell.view)
            self.xianhun_scroll:refresh()
        return true

        end
    end
    
    self.xianhun_scroll:registerScriptHandler(scrollfun)
    self.xianhun_scroll:refresh()
    xianhun_panel:addChild(self.xianhun_scroll);

end


---------------------界面更新
function FabaoDetailWin:active( show )
    
    if show then
        self:update_xianhun_list();
    end

end

function FabaoDetailWin:update_xianhun_list(  )
    local xianhun_data = FabaoModel:get_fabao_xianhun(  )
    local xianhun_list = xianhun_data.xianhuns;

    
    if #xianhun_list == 0 then
        self.xianhun_scroll:setIsVisible(false);
    else
        print("已经装备的仙魂个数",#xianhun_list);
        self.xianhun_scroll:setIsVisible(true);
        self.xianhun_scroll:clear();
        self.xianhun_scroll:setMaxNum(#xianhun_list);
        self.xianhun_scroll:refresh();
    end
end
