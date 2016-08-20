-- MarriagePageHunChe.lua
-- create by guozhinan 2015-2-3
-- 结婚系统的第三个分页

super_class.MarriagePageHunChe()



function MarriagePageHunChe:__init( x, y, w, h )
	
	self.view = CCBasePanel:panelWithFile( x, y, w, h,"");

	local img = MUtils:create_zximg( self.view, UILH_MARRIAGE.subtitle3_1, 83, 437, -1, -1 );

    --巡游规则
    local desc_dict = {{LangGameString[1533],LangGameString[1534],LangGameString[1535]}, -- [1533]="1、#c66ff66普通巡游#cffffff获得1500点情意;" -- [1534]="2、需要花费21314仙币开启;" -- [1535]="3、普通巡游云车无喜糖可撒。"
    					{LangGameString[1536],LangGameString[1537],LangGameString[1538]}, -- [1536]="1、#c66ff66浪漫巡游#cffffff获得3500点情意;" -- [1537]="2、需要花费58元宝开启;" -- [1538]="3、浪漫云车会自动撒1次喜糖。"
    					{LangGameString[1539],LangGameString[1540],LangGameString[1541]},}; -- [1539]="1、#c66ff66豪华巡游#cffffff获得10000点情意;" -- [1540]="2、需要花费258元宝开启;" -- [1541]="3、豪华云车会自动撒3次喜糖。"
    local icon_dict = {"pt_xy.png","lm_xy.png","hh_xy.png"};
    for i=1,3 do

        local function selected_panel( eventType,x,y )
            if eventType == TOUCH_CLICK then
                self:selected_panel(i);
            end
            return true;
        end
        local panel = CCBasePanel:panelWithFile( 15, 330-(i-1)*105, 320, 70, "" );
        panel:registerScriptHandler(selected_panel);
        self.view:addChild(panel);

        MUtils:create_zximg( panel, UILH_MARRIAGE.item_bg, 27, 21, 72, 72 );
    	local img = MUtils:create_zximg( panel, UIResourcePath.FileLocate.lh_marriage..icon_dict[i], 28, 22, 70, 70 );

 
    	local lab = UILabel:create_lable_2( desc_dict[i][1], 130, 75, 16, ALIGN_LEFT );
    	panel:addChild(lab);
    	local lab = UILabel:create_lable_2( desc_dict[i][2], 130, 50, 16, ALIGN_LEFT );
    	panel:addChild(lab);
    	local lab = UILabel:create_lable_2( desc_dict[i][3], 130, 25, 16, ALIGN_LEFT );
    	panel:addChild(lab);

        local split_img = CCZXImage:imageWithFile( 0, 0, 420, 2, UILH_MARRIAGE.split_line_h );
        panel:addChild(split_img);
    end
    self.selected_index = 1;
     -- 选中框
    -- self.select_frame = MUtils:create_zximg(self.view, "nopack/ani_corner.png", 35, 230, 320, 75, 3, 3);
    -- self.select_frame:setIsVisible(false);

    -- 我要巡游
    local function begin_xunyou(  )
        
        if self.xunyou_status then

            -- MarriageModel:req_yunche_xunyou( self.selected_index );

        else
            local function func_1( )
                GlobalFunc:ask_npc( 3, Lang.marriage[5]  ); -- [1543]="仙缘月老"
                UIManager:hide_window("marriage_win_new");
            end
            local function func_2(  )
               GlobalFunc:teleport( 3, Lang.marriage[5] ); -- [1543]="仙缘月老"
               UIManager:hide_window("marriage_win_new");
            end
            local confirmWin2_temp = ConfirmWin2:show( 6, nil, Lang.marriage[6],  func_1, nil, nil ) -- [1544]="是否确定前往天元城仙缘月老处开启巡游?"
            confirmWin2_temp:set_yes_but_func_2( func_2 )
        end
    end
    ZImageButton:create(self.view,UILH_MARRIAGE.btn1,UILH_MARRIAGE.woyaoxunyou,begin_xunyou,150, 49);
    -- local xunyou_btn = TextButton:create( nil, 150, 49, 87, 34, LangGameString[1542], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1542]="#cfafed0我要巡游"
    -- self.view:addChild( xunyou_btn.view );
    -- xunyou_btn:setTouchClickFun(begin_xunyou);
	-- 提示
	local lab = UILabel:create_lable_2( LangGameString[1545], 211,27, 16, ALIGN_CENTER ); -- [1545]="#cfff000(每天仅1次,3选1)"
    self.view:addChild(lab);

    -- 是否具备举办云车巡游功能
    self.xunyou_status = false;

    -- 分割线
    local line = CCZXImage:imageWithFile( 438, 10, 4, 480, UILH_MARRIAGE.split_line_v)
    self.view:addChild(line)

    local logo_img = CCZXImage:imageWithFile( 499, 437,-1,-1,UILH_MARRIAGE.subtitle3_2 );
    self.view:addChild(logo_img);

    local lab_1 = CCZXImage:imageWithFile( 484, 400,-1,-1,UILH_MARRIAGE.shijian ); -- [1515]="#cff66cc时间"
    self.view:addChild( lab_1 );
    local lab_2 = CCZXImage:imageWithFile(  665, 400,-1,-1,UILH_MARRIAGE.jiehunjilu )-- [1516]="#cff66cc结婚记录"
    self.view:addChild( lab_2 );

    --首页按钮
    local function frist_page_event(  )
        -- 请求首页
        local record_list = MarriageModel:get_marriage_record_list(  )
        if record_list.curr_page > 1 then
            MarriageModel:req_marriage_record_list( 1 );
        end
    end
    ZImageButton:create(self.view,UILH_MARRIAGE.btn2,UILH_MARRIAGE.shouye,frist_page_event,450, 17);
    -- local first_page_btn = TextButton:create( nil, 10, 17, 60, 34, LangGameString[1517], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1517]="#cfafed0首页"
    -- self.view:addChild( first_page_btn.view );
    -- first_page_btn:setTouchClickFun(frist_page_event)

    -- 前一页按钮
    local function forward_page_event(  )
        local record_list = MarriageModel:get_marriage_record_list(  )
        if record_list.curr_page > 1 then
            MarriageModel:req_marriage_record_list( record_list.curr_page - 1 );
        end
    end
    ZImageButton:create(self.view,UILH_MARRIAGE.btn2,UILH_MARRIAGE.shangye,forward_page_event,530, 17);
    -- local forward_page_btn = TextButton:create( nil, 10+60+4, 17, 60, 34, LangGameString[1518], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1518]="#cfafed0上页"
    -- self.view:addChild( forward_page_btn.view );
    -- forward_page_btn:setTouchClickFun(forward_page_event)

    -- 当前页数
    self.page_lab = UILabel:create_lable_2( "1/1", 648, 30, 18, ALIGN_CENTER );
    self.view:addChild(self.page_lab);

    -- 下一页按钮
    local function next_page_event(  )
        local record_list = MarriageModel:get_marriage_record_list(  )
        if record_list.curr_page > 0 and record_list.curr_page < record_list.sum_page then 
            print("下一页",record_list.curr_page, record_list.sum_page);
            MarriageModel:req_marriage_record_list( record_list.curr_page + 1 );
        end
    end
    ZImageButton:create(self.view,UILH_MARRIAGE.btn2,UILH_MARRIAGE.xiaye,next_page_event,777-80, 17);
    -- local next_page_btn = TextButton:create( nil, w-60*2-4-10, 17, 60, 34, LangGameString[1519], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1519]="#cfafed0下页"
    -- self.view:addChild( next_page_btn.view );
    -- next_page_btn:setTouchClickFun(next_page_event);

    -- 末页按钮
    local function last_page_event(  )
        local record_list = MarriageModel:get_marriage_record_list(  )
        if record_list.curr_page < record_list.sum_page then
            MarriageModel:req_marriage_record_list( record_list.sum_page );
        end
    end
    ZImageButton:create(self.view,UILH_MARRIAGE.btn2,UILH_MARRIAGE.moye,last_page_event, 777, 17);
    -- local last_page_btn = TextButton:create( nil, w-60-10, 17, 60, 34, LangGameString[1520], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1520]="#cfafed0末页"
    -- self.view:addChild( last_page_btn.view );
    -- last_page_btn:setTouchClickFun(last_page_event);

    -- 结婚记录
    self.record_scroll = CCScroll:scrollWithFile( 447, 65, 405 , 325, 0, "", TYPE_HORIZONTAL, 600, 600 )
    -- local size = self.record_scroll:getSize();
    -- local color_rect =  CCArcRect:arcRectWithColor(0, 0, size.width, size.height, 0xffffffff);
    -- self.record_scroll:addChild(color_rect);     
    
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
            local cell = MarriageRecordCell( 405, 45, data.record_list[row] );
            self.record_scroll:addItem(cell.view)
            self.record_scroll:refresh()
            
        end
        return true
    end
    
    self.record_scroll:registerScriptHandler(scrollfun)
    self.record_scroll:refresh()
    self.view:addChild(self.record_scroll);
end

-------------------------界面更新

function MarriagePageHunChe:active( show )
    if show then
        MarriageModel:req_marriage_record_list( 1 );
    else
        self:set_xunyou_enable( false ); 
    end
end

-- 选择云车巡游类型
function MarriagePageHunChe:selected_panel( index )
    if self.xunyou_status then
        -- local move_to = CCMoveTo:actionWithDuration(0.3, CCPointMake(35,230-(index-1)*70));
        -- local act_easa = CCEaseExponentialOut:actionWithAction(move_to);
        -- self.select_frame:runAction(act_easa);
        -- self.selected_index = index;
    else

    end
end

-- 激活云车巡游功能
function MarriagePageHunChe:set_xunyou_enable( bool )
--     self.select_frame:setIsVisible(bool);
--     self.xunyou_status = bool;
end

-- 更新结婚记录
function MarriagePageHunChe:update_marriage_record(  )
    
    local data = MarriageModel:get_marriage_record_list(  );
    print("更新结婚记录",data)
    -- 当前页数
    if data ~= nil then

        self.page_lab:setText( data.curr_page.."/"..data.sum_page );
        self.record_scroll:clear();
        self.record_scroll:setMaxNum( #data.record_list );
        self.record_scroll:refresh();
    end

end