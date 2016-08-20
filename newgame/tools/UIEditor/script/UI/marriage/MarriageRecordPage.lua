-- MarriageRecordPage.lua
-- create by fjh 2013-8-16
-- 结婚记录分页

super_class.MarriageRecordPage()

function MarriageRecordPage:__init( x, y, w, h )
	
	self.view = CCBasePanel:panelWithFile( x, y, w, h,"");

	local logo_img = CCZXImage:imageWithFile( 20,285,304,105,UIResourcePath.FileLocate.marriage .. "yunche_lab_2.png" );
    self.view:addChild(logo_img);


    local lab_1 = UILabel:create_lable_2( LangGameString[1515], 43, 300, 14, ALIGN_LEFT ); -- [1515]="#cff66cc时间"
    self.view:addChild( lab_1 );

    local lab_2 = UILabel:create_lable_2( LangGameString[1516], 43+150, 300, 14, ALIGN_LEFT ); -- [1516]="#cff66cc结婚记录"
    self.view:addChild( lab_2 );

    --首页
    local first_page_btn = TextButton:create( nil, 10, 17, 60, 34, LangGameString[1517], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1517]="#cfafed0首页"
	self.view:addChild( first_page_btn.view );
    local function frist_page_event(  )
        -- 请求首页
        local record_list = MarriageModel:get_marriage_record_list(  )
        if record_list.curr_page > 1 then
            MarriageModel:req_marriage_record_list( 1 );
        end

    end
    first_page_btn:setTouchClickFun(frist_page_event)
    

    -- 前一页按钮
	local forward_page_btn = TextButton:create( nil, 10+60+4, 17, 60, 34, LangGameString[1518], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1518]="#cfafed0上页"
	self.view:addChild( forward_page_btn.view );
    local function forward_page_event(  )
        local record_list = MarriageModel:get_marriage_record_list(  )
        if record_list.curr_page > 1 then
            MarriageModel:req_marriage_record_list( record_list.curr_page - 1 );
        end
    end
    forward_page_btn:setTouchClickFun(forward_page_event)

    -- 当前页数
    self.page_lab = UILabel:create_lable_2( "1/1", w-150-25, 22, 18, ALIGN_CENTER );
    self.view:addChild(self.page_lab);

    -- 下一页按钮
	local next_page_btn = TextButton:create( nil, w-60*2-4-10, 17, 60, 34, LangGameString[1519], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1519]="#cfafed0下页"
	self.view:addChild( next_page_btn.view );
    local function next_page_event(  )
        local record_list = MarriageModel:get_marriage_record_list(  )
        if record_list.curr_page > 0 and record_list.curr_page < record_list.sum_page then 
            print("下一页",record_list.curr_page, record_list.sum_page);
            MarriageModel:req_marriage_record_list( record_list.curr_page + 1 );
        end
    end
    next_page_btn:setTouchClickFun(next_page_event);

    -- 末页按钮
	local last_page_btn = TextButton:create( nil, w-60-10, 17, 60, 34, LangGameString[1520], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1520]="#cfafed0末页"
	self.view:addChild( last_page_btn.view );
    local function last_page_event(  )
        local record_list = MarriageModel:get_marriage_record_list(  )
        if record_list.curr_page < record_list.sum_page then
            MarriageModel:req_marriage_record_list( record_list.sum_page );
        end
    end
    last_page_btn:setTouchClickFun(last_page_event);

	-- 结婚记录
	self.record_scroll = CCScroll:scrollWithFile( 1, 55, 330 , 235, 0, "", TYPE_HORIZONTAL, 600, 600 )
    -- self.record_scroll:setScrollLump( UIResourcePath.FileLocate.common .. "common_progress.png", 8, 50, 72)
    
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
        	local data = MarriageModel:get_marriage_record_list(  );
	        local cell = MarriageRecordCell( 330, 33, data.record_list[row] );
	        self.record_scroll:addItem(cell.view)
	        self.record_scroll:refresh()
	        
        end
        return true
    end
    
    self.record_scroll:registerScriptHandler(scrollfun)
    self.record_scroll:refresh()
    self.view:addChild(self.record_scroll);
end

-- 更新结婚记录
function MarriageRecordPage:update_marriage_record(  )
    
    local data = MarriageModel:get_marriage_record_list(  );
    -- 当前页数
    if data ~= nil then

        self.page_lab:setText( data.curr_page.."/"..data.sum_page );
        self.record_scroll:clear();
        self.record_scroll:setMaxNum( #data.record_list );
        self.record_scroll:refresh();
    end

end
