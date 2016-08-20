-- CaiQuanCell.lua
-- create by fjh 2013-7-29

super_class.CaiQuanCell()


function CaiQuanCell:__init( x, y )
	
	self.view = CCBasePanel:panelWithFile( x, y, 164, 150, UIResourcePath.FileLocate.caiquan .. "img3.png",500,500);	

	self.name_bg = MUtils:create_zximg( self.view, UIResourcePath.FileLocate.caiquan .. "img1.png", 5, 150-44-5, 153, 44 );

	-- 名字
	self.name = UILabel:create_lable_2( LangGameString[667], 153/2-5, 10, 14, ALIGN_CENTER ); -- [667]="？？？"
	self.name_bg:addChild(self.name);

	-- 银两
	self.money = UILabel:create_lable_2( LangGameString[668], 25, 80, 14, ALIGN_LEFT ); -- [668]="#cffff00银两： #cffffff???"
	self.view:addChild(self.money);

	-- 胜利
	self.victory_count = UILabel:create_lable_2( LangGameString[669], 25, 50, 14, ALIGN_LEFT ); -- [669]="#cffff00胜利： #cffffff???"
	self.view:addChild(self.victory_count);

	-- 连胜数
	local img1 = MUtils:create_zximg( self.view, UIResourcePath.FileLocate.caiquan .. "img2.png", 83, 10, 49, 25 );
	self.mutable_win = ZXLabelAtlas:createWithString("12", UIResourcePath.FileLocate.caiquan );
	self.mutable_win:setPosition(CCPointMake( 83-40, 10 ));
	self.view:addChild(self.mutable_win);

end

-- 更新
function CaiQuanCell:update( data )
	
	print(" 刷新caiquancell ",data.camp);
	local camp = Lang.camp_info_ex[data.camp].name[3];

	self.name_bg:setIsVisible(true);
	self.name:setText( Lang.camp_info_ex[data.camp].color..camp.."#cffffff"..data.name );

	self.money:setText( LangGameString[670]..data.money ) -- [670]="#cffff00银两： #cffffff"

	self.victory_count:setText( LangGameString[671]..data.win_count.."/"..data.all_count ); -- [671]="#cffff00胜利： #cffffff"

	self.mutable_win:init(""..data.mutable_win);

end

-- 设置为未知
function CaiQuanCell:set_unknown_status(  )	

	-- self.name:setText( "？？？" );
	self.name_bg:setIsVisible(false);

	self.money:setText( LangGameString[668] ) -- [668]="#cffff00银两： #cffffff???"

	self.victory_count:setText( LangGameString[669]); -- [669]="#cffff00胜利： #cffffff???"

	self.mutable_win:init("0");

end
