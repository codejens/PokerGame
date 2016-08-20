-- MarriageRightWin.lua
-- created by fjh 2013-8-15
-- 结婚系统的右窗口

super_class.MarriageRightWin(NormalStyleWindow)


function MarriageRightWin:__init(  )
	--普通背景	

    local bg_img = MUtils:create_zximg( self.view, UIResourcePath.FileLocate.marriage.."tip_bg.png", 15, 18, 350, 380, 5,5 );
    
	-- 关闭按钮
 --    local close_btn = CCNGBtnMulTex:buttonWithFile(0, 0, -1, -1, UIResourcePath.FileLocate.marriage .. "close_btn.png")
 --    local exit_btn_size = close_btn:getSize()
 --    local spr_bg_size = self:getSize()
 --    close_btn:setPosition( spr_bg_size.width - exit_btn_size.width-5, spr_bg_size.height - exit_btn_size.height-5 )
 --    close_btn:addTexWithFile( CLICK_STATE_DOWN,UIResourcePath.FileLocate.marriage .. "close_btn.png" )
	
	-- --注册关闭事件
 --    local function close_fun( eventType )
 --    		if eventType == TOUCH_CLICK then
 --  			  UIManager:destroy_window("marriage_right_win");
 --  		  end
 --  		  return true
 --  	end
 --    close_btn:registerScriptHandler(close_fun) 
    
 --    self:addChild(close_btn,99)

    self:change_page( MarriageModel.PAGE_TYPE_QINGYUAN )

end

-- 
function MarriageRightWin:change_page( page_type )

    if page_type == MarriageModel.PAGE_TYPE_QINGYUAN then
        
        
        if self.ring_page == nil then
            self.ring_page = MarriageUpRingPage( 15, 18, 350, 380 );
            self.view:addChild(self.ring_page.view);
        else
            self.ring_page.view:setIsVisible(true);
        end
        if self.hunyan_page then
            self.hunyan_page.view:setIsVisible(false);
        end
        if self.yunche_page then
            self.yunche_page.view:setIsVisible(false);
        end
        
        -- 更新当前情意值
        self:update_curr_qingyi_value(  );
    elseif page_type == MarriageModel.PAGE_TYPE_HUNYAN then
        
        if self.ring_page then
            self.ring_page.view:setIsVisible(false);
        end
        if self.hunyan_page == nil then
            self.hunyan_page = MarriageHunYanInfoPage( 15, 18, 350, 380 );
            self.view:addChild(self.hunyan_page.view);
        else
            self.hunyan_page.view:setIsVisible(true);
        end
        if self.yunche_page then
            self.yunche_page.view:setIsVisible(false);
        end

        -- 拉去婚宴列表
        MarriageModel:req_get_wedding_list(  )

    elseif page_type == MarriageModel.PAGE_TYPE_YUNCHE then
        if self.ring_page then
            self.ring_page.view:setIsVisible(false);
        end
        if self.hunyan_page then
            self.hunyan_page.view:setIsVisible(false);
        end
        if self.yunche_page == nil then
            self.yunche_page = MarriageRecordPage( 15, 18, 350, 380 );
            self.view:addChild(self.yunche_page.view);
        else
            self.yunche_page.view:setIsVisible(true);
        end

        MarriageModel:req_marriage_record_list( 1 );
    end

end

-----------------------界面更新
function MarriageRightWin:active( show )
    if show then
        -- self:update_curr_qingyi_value(  );
    end
    self.ring_page:active(show);
end

-- 更新情意值
function MarriageRightWin:update_curr_qingyi_value(  )

    local data = MarriageModel:get_marriage_data( );
    
    if data.qingyi ~= nil then
        self.ring_page:update_curr_qingyi_value( data.qingyi )
    end

end

-- 更新婚宴列表
function MarriageRightWin:update_wedding_list(  )
    if self.hunyan_page then
        self.hunyan_page:update_wedding_list(  )
    end
end
-- 选择婚宴列表
function MarriageRightWin:selected_wedding_list( index )
    if self.hunyan_page then
        self.hunyan_page:selected_tab( index );
    end
end


-- 更新结婚记录列表
function MarriageRightWin:update_marriage_record_list(  )
    
    if self.yunche_page then
        self.yunche_page:update_marriage_record(  );
    end

end