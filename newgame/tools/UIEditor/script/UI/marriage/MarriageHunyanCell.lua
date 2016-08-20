-- MarriageHunyanCell.lua
-- created by fjh 2013-8-15
-- 婚宴详细的cell

super_class.MarriageHunyanCell()

function MarriageHunyanCell:__init( w, h, data )
	
	self.view = CCBasePanel:panelWithFile( 0, 0, w, h,"");

	-- 分割线
    local split_img = CCZXImage:imageWithFile(5,0-2,385,2,UILH_MARRIAGE.split_line_h);
    self.view:addChild(split_img);
    local split_img = CCZXImage:imageWithFile(5,h-2,385,2,UILH_MARRIAGE.split_line_h);
    self.view:addChild(split_img);

    --- 婚宴时间
    local time_str = Utils:get_custom_format_time( "%H:%M" ,data.time );
    --描述文字    
	local str = "#cfff000"..data.lovers[1].name..LangGameString[1489]..data.lovers[2].name..LangGameString[1490]..time_str..LangGameString[1491]; -- [1489]="#cffffff与#cfff000" -- [1490]="#cffffff于#cfff000" -- [1491]="#cffffff举行婚宴，恭请各位"
	
	local desc_dialog = MUtils:create_ccdialogEx( self.view, str, 10, 60, 260, 20, 2, 16 );
	desc_dialog:setAnchorPoint(0,1);

	local join_btn = TextButton:create( nil, 279, 5, 123, 58, LangGameString[1492], UILH_MARRIAGE.btn1 ); -- [1492]="#cfafed0立即参加"
	self.view:addChild( join_btn.view );
	local function join_now_event(  )
		-- 传入婚礼id
		print("进入婚礼",data.type);
		MarriageModel:req_join_wedding( data.id );
		
		UIManager:hide_window("marriage_win_new");
	end
	join_btn:setTouchClickFun(join_now_event);


end
