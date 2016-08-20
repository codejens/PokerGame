-- MarriageRecordCell.lua
-- created by fjh 2013-8-13
-- 结婚记录cell

super_class.MarriageRecordCell()

function MarriageRecordCell:__init( w, h, data )
	self.view = CCBasePanel:panelWithFile( 0, 0, w, h,"");

	-- 分割线
    local split_img = CCZXImage:imageWithFile(5,0-2,w-10,2,UILH_MARRIAGE.split_line_h);
    self.view:addChild(split_img);
    local split_img = CCZXImage:imageWithFile(5,h-2,w-10,2,UILH_MARRIAGE.split_line_h);
    self.view:addChild(split_img);

    
    local time_str = Utils:get_custom_format_time( "%Y-%m-%d" ,data.time );

    --时间
    local time_lab = UILabel:create_lable_2( "#cfff000"..time_str, 15, 12, 16, ALIGN_LEFT );
    self.view:addChild(time_lab);

    -- 结婚当事人
    local str = "#cfff000"..data.player_1_name..LangGameString[1514]..data.player_2_name; -- [1514]="#cffffff和#cfff000"
    local name_lab = UILabel:create_lable_2( str, 260, 12, 16, ALIGN_CENTER );
    self.view:addChild(name_lab);

end
