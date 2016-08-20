-- VipCellView.lua 
-- created by fangjiehua on 2013-6-29
-- vip仙尊系统 cell
 super_class.VipCellView()

VipCellView.CELL_STYLE_NONE	= 0;
 VipCellView.CELL_STYLE_DEFAULT = 1;
 VipCellView.CELL_STYLE_NEXT = 2;
 VipCellView.CELL_STYLE_ALL = 3;

 function VipCellView:__init( style, x,y,w,h )

 	self.style = style;
 	--
 	self.view = CCBasePanel:panelWithFile(x, y, w, h, UI_VIPSysWin_001, 500, 500)

 	--列表文字描述
 	-- self.vip_detail = MUtils:create_ccdialogEx( self.view,"的好地方",30,375, 416,225, 11,16 );
 	-- self.vip_detail:setAnchorPoint(0,1);
 	
 	if self.style == VipCellView.CELL_STYLE_NONE then
 		local silk_img = ZImage:create(self.view, UI_VIPSysWin_015, 5, h-33, -1, -1)
 		-- MUtils:create_zximg( self.view,UIResourcePath.FileLocate.common .. "wzd-1.png", 5, h-33, 410, -1);
 		self.lab_img = MUtils:create_zximg( silk_img, UIResourcePath.FileLocate.vip .. "6.png", 26, 2, -1, -1);
 		-- self.vip_detail:setText(LangGameString[2127]); -- [2127]="充值成为仙尊后，您能享受到各种仙尊特权"
 		self.vip_detail_panel = CCBasePanel:panelWithFile(0, 0, 416, 370, "", 500, 500)
		self.view:addChild(self.vip_detail_panel)

		local item = CCBasePanel:panelWithFile(0, 370-40, 416, 40, "", 500, 500)
 		self.vip_detail_panel:addChild(item)

 		local text = ZLabel.new(LangGameString[2127])
 		text:setFontSize(16)
 		text:setPosition(10, 10)
 		item:addChild(text.view)

 		local line = ZImage.new(UIResourcePath.FileLocate.common .. "jgt_line.png")
 		line:setPosition(8, 0)
 		line:setSize(400, 2)
 		item:addChild(line.view)

 	elseif self.style == VipCellView.CELL_STYLE_DEFAULT then
 		local silk_img = MUtils:create_zximg( self.view,UIResourcePath.FileLocate.common .. "wzd-1.png", 4, h-33, 410, -1);
 		self.lab_img = MUtils:create_zximg( silk_img, UIResourcePath.FileLocate.vip .. "6.png", 26, 2, -1, -1);
 		--当前vip等级
 		local temp_vip_img = ZImage:create( silk_img, UIResourcePath.FileLocate.vip .. "vip_1.png", 156, 4 )
 		self.vip_level = temp_vip_img.view
 		self.vip_level:setAnchorPoint(0.5, 0)
 		--self.vip_level = MUtils:create_zximg( silk_img, UIResourcePath.FileLocate.vip .. "vip_litte_lab_1.png",98-10, 1, 79, 26)

 	elseif self.style == VipCellView.CELL_STYLE_NEXT then
 		self.silk_img = MUtils:create_zximg( self.view,UIResourcePath.FileLocate.common .. "wzd-1.png", 4, h-33, 410, -1);
 		local lab_img = MUtils:create_zximg( self.silk_img, UIResourcePath.FileLocate.vip .. "7.png", 26, 2, -1, -1);
 		--再充值多少元宝
 		self.cost_yb = UILabel:create_lable_2( "#cfff000200", 106, 7, 14, ALIGN_CENTER );
 		self.silk_img:addChild(self.cost_yb);
 		--下级vip
 		local temp_next_vip_img = ZImage:create( self.silk_img, UIResourcePath.FileLocate.vip .. "vip_1.png",235, 4 )
 		self.next_vip_level = temp_next_vip_img.view
 		--self.next_vip_level = MUtils:create_zximg( self.silk_img, UIResourcePath.FileLocate.vip .. "vip_litte_lab_2.png",98+157, 1, 79, 26);
 	
 	elseif self.style == VipCellView.CELL_STYLE_ALL then
 		local silk_img = ZImage:create(self.view, UI_VIPSysWin_015, 4, h-33, -1, -1)	
 		-- local silk_img = MUtils:create_zximg( self.view,UIResourcePath.FileLocate.common .. "wzd-1.png", 4, h-33, 410, -1);
 		--self.vip_flag = MUtils:create_zximg( self.view,UIResourcePath.FileLocate.vip .. "vip_flag_1.png", 0, h-61, 61, 61);
 		self.lab_img = ZImage:create(silk_img, UI_VIPSysWin_018, 26, 2, -1, -1)
 		-- local lab_img = MUtils:create_zximg( silk_img, UIResourcePath.FileLocate.vip .. "3.png", 26, 2, -1, -1);
 		-- self.cost_yb = UILabel:create_lable_2( "#cfff000200", 91, 7, 14, ALIGN_CENTER );
 		-- silk_img:addChild(self.cost_yb);
 	end
 end

 function VipCellView:update_cell( data )

	if self.vip_detail_panel then
		self.view:removeChild(self.vip_detail_panel, true)
		self.vip_detail_panel = nil
	end

 	if data and data[1] > 10 then
 		self.next_vip_level:setIsVisible(false);
 		-- self.vip_detail:setIsVisible(false);
 		if self.silk_img then
 			self.silk_img:setIsVisible(false);
 		end
 		return;
 	end
 	if self.style == VipCellView.CELL_STYLE_NONE then
 		self.lab_img:setTexture(UIResourcePath.FileLocate.vip .. "1.png");
 		self.lab_img:setSize(101, 26);
 		self.lab_img:setPosition(26, 0);
 		-- self.vip_detail:setText(LangGameString[2127]); -- [2127]="充值成为仙尊后，您能享受到各种仙尊特权"
 		if self.vip_level then
 			self.vip_level:setTexture("");
 		end

 		self.vip_detail_panel = CCBasePanel:panelWithFile(0, 0, 416, 370, "", 500, 500)
		self.view:addChild(self.vip_detail_panel)

		local item = CCBasePanel:panelWithFile(0, 370-40, 416, 40, "", 500, 500)
 		self.vip_detail_panel:addChild(item)

 		local text = ZLabel.new(LangGameString[2127])
 		text:setFontSize(16)
 		text:setPosition(10, 10)
 		item:addChild(text.view)

 		local line = ZImage.new(UIResourcePath.FileLocate.common .. "jgt_line.png")
 		line:setPosition(8, 0)
 		line:setSize(400, 2)
 		item:addChild(line.view)

 		return;
 	elseif self.style == VipCellView.CELL_STYLE_DEFAULT then
 		self.lab_img:setTexture(UIResourcePath.FileLocate.vip .. "6.png");
 		self.lab_img:setSize(319,23);
 		self.lab_img:setPosition(26, 2);

 		self.vip_level:setTexture(string.format(UIResourcePath.FileLocate.vip .. "vip_%d.png",data[1]));

 	elseif self.style == VipCellView.CELL_STYLE_NEXT then

 		self.next_vip_level:setTexture(string.format(UIResourcePath.FileLocate.vip .. "vip_%d.png",data[1]));
 		self.cost_yb:setText("#cffff00"..data[2]);

 	elseif self.style == VipCellView.CELL_STYLE_ALL then
 		--vip等级
 		--self.vip_flag:setTexture(string.format(UIResourcePath.FileLocate.vip .. "vip_flag_%d.png",data[1]));
 		-- self.cost_yb:setText("#cffff00"..data[2]);
 		self.lab_img:setTexture("ui/vip/viptt_" .. data[1] .. ".png");
 	end

 	-- -- vip特权
 	-- local vip_desc = "";
 	-- if self.style == VipCellView.CELL_STYLE_ALL then
	 	--列表中每张图片
	 	-- local img_path = string.format("vip_litte_lab_%d.png",data[1])
	 	-- local vip_logo = ZCCSprite:create(self.view,UIResourcePath.FileLocate.vip .. img_path , 325, 60 )
	-- end

	-- self.vip_detail:setText("")

	self.vip_detail_panel = CCBasePanel:panelWithFile(0, 0, 310, 365, "", 500, 500)
	self.view:addChild(self.vip_detail_panel)

 	local vip_dict = FubenConfig:get_vip_detail_by_level( data[1] );
 	for i,v in ipairs(vip_dict) do
 		local item = CCBasePanel:panelWithFile(0, 335-i*40, 310, 40, "", 500, 500)
 		self.vip_detail_panel:addChild(item)

 		local text = ZLabel.new(v)
 		text:setFontSize(16)
 		text:setPosition(10, 10)
 		item:addChild(text.view)

 		local line = ZImage:create(item, UI_VIPSysWin_020, 8, 0, 302, 2)

 		-- vip_desc = vip_desc..v.."#r";
 	end
 	-- self.vip_detail:setText(vip_desc);
 end

