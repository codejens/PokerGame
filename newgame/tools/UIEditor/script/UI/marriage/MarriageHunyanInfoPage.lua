-- MarriageHunYanInfoPage.lua
-- create by fjh on 2013-8-16
-- 结婚系统的婚宴详细分页

super_class.MarriageHunYanInfoPage()


function MarriageHunYanInfoPage:__init( x, y, w, h )
	
	self.view = CCBasePanel:panelWithFile( x, y, w, h,"");
    self.tab_index = 1;

	-- tab 按钮
    self.radio_btn_dict = {};
  	self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(25, 315, 320, 50,nil);
    self.view:addChild(self.raido_btn_group);
    local img = {UIResourcePath.FileLocate.marriage.."putong_lab.png", UIResourcePath.FileLocate.marriage.."haohua_lab.png"};
    for i=1,2 do
        local function btn_fun(eventType,x,y)
            if eventType == TOUCH_CLICK then
               self.tab_index = i;
               self:update_wedding_list();
            end
            return true;
        end
        local x = (i-1)*164;
        local y = 0;
        local btn = MUtils:create_radio_button(self.raido_btn_group,UIResourcePath.FileLocate.marriage.."tab_btn_h.png",UIResourcePath.FileLocate.marriage.."tab_btn_h_d.png",
        										btn_fun, x, y, 134, 53, false);

     	local lab = MUtils:create_zximg(btn,img[i],42,10,72,23);
        self.radio_btn_dict[i] = {button = btn, label = lab};
    end

    --  婚宴列表
     -- scrollView
    self.hunyan_scroll = CCScroll:scrollWithFile( 1, 16, 330 , 292, 5, "", TYPE_HORIZONTAL, 600, 600 )
    self.hunyan_scroll:setScrollLump( UILH_COMMON.up_progress, UILH_COMMON.down_progress, 8, 50, 72)
    local function scrollfun(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return false
        end
        local temparg = Utils:Split(arg,":")
        local row = tonumber(temparg[1])+1  --行数
        if row == nil then 
            return false;
        end
    	if eventType == SCROLL_CREATE_ITEM then
            
        	local wedding_list = MarriageModel:get_wedding_list( );
            -- print("婚礼列表长度", #wedding_list[self.tab_index]);

            if #wedding_list > 0 and #wedding_list[self.tab_index] > 0 then
    	        local cell = MarriageHunyanCell( 330, 72, wedding_list[self.tab_index][row]);
    	        self.hunyan_scroll:addItem(cell.view)
    	        self.hunyan_scroll:refresh()
            end
	        
        end
        return true
    end
    
    self.hunyan_scroll:registerScriptHandler(scrollfun)
    self.hunyan_scroll:refresh()
    self.view:addChild(self.hunyan_scroll);

    self.no_hunyan_img = MUtils:create_zximg( self.view, UIResourcePath.FileLocate.marriage .. "no_hunyan.png", 350/2-183/2, 380/2-43/2 , 183, 43 );

end

-- 选择分页
function MarriageHunYanInfoPage:selected_tab( index )
    self.tab_index = index;
    self.raido_btn_group:selectItem(index-1);
    self:update_wedding_list();
end


function MarriageHunYanInfoPage:update_wedding_list(  )
    
    local wedding_list = MarriageModel:get_wedding_list( );
    print("更新婚礼列表", #wedding_list[self.tab_index]);
    if #wedding_list > 0 and #wedding_list[self.tab_index] > 0 then
    
        self.hunyan_scroll:setIsVisible(true);
        self.no_hunyan_img:setIsVisible(false);
        self.hunyan_scroll:clear();
        self.hunyan_scroll:setMaxNum(#wedding_list[self.tab_index]);    
        self.hunyan_scroll:refresh();

    else
        self.hunyan_scroll:setIsVisible(false);
        self.no_hunyan_img:setIsVisible(true);
    end

end