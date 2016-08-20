-- MoneyTipView.lua 
-- createed by fangjiehua on 2013-7-4
-- MoneyTipView 面板

super_class.MoneyTipView(Window)


function MoneyTipView:__init(  )
	
	local type;
	if self.data.item_id == 0 then
		type = LangGameString[411]; -- [411]="仙币"
	elseif self.data.item_id == 1 then
		type = LangGameString[412]; -- [412]="银两"
	elseif self.data.item_id == 2 then
		type = LangGameString[1998]; -- [1998]="礼卷"
	elseif self.data.item_id == 3 then
		type = LangGameString[414]; -- [414]="元宝"
	end

	local money_type_name = UILabel:create_lable_2( type..LangGameString[1999], 20, 17+5, 16, ALIGN_LEFT ); -- [1999]="："
	self.view:addChild( money_type_name );

	local money_type_count = UILabel:create_lable_2( ""..self.data.item_count, 20+45, 17+5, 16, ALIGN_LEFT );
	self.view:addChild( money_type_count );

end

function MoneyTipView:create( data )

	-- self.data 为 MailStruct 附件的信息结构
	self.data = data;
	local temp_info = { texture = "", x = 0, y = 0, width = 210, height = 60 }
	return MoneyTipView("xianhunTip", "", true, 210,60);

end
