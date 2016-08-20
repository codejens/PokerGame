-- BattlePage.lua
-- created by fjh on 2013-2-26
-- 战场分页

super_class.BattlePage(Window)

function BattlePage:active( show )
	-- body
end

--设置战场序号，id
function BattlePage:set_num( num )
	if self.battle_id_lab ~= nil then
		print("BattlePage:set_num( num )",num)
		--战场id
		self.battle_id = num
		local img = UIResourcePath.FileLocate.normal .. "num"..tostring(num)..".png";
		self.battle_id_lab:setTexture(img);
	end
end

--更新战场数据
function BattlePage:update( data )
	if data == nil then
		return ;
	end
	for i,v in ipairs(data) do
		local lab = self.count_dict[i];
		lab:setText(string.format("(%d/80)",v));
	end

end

function BattlePage:setIsVisible( visible )
	self.view:setIsVisible(visible);
end

function BattlePage:__init(  )
	
	local page_bg = CCZXImage:imageWithFile(0,0,178,200,UIResourcePath.FileLocate.camp .. "camp_frame.png",500,500);
	self:addChild(page_bg);
	
	--标题
	local page_title = CCZXImage:imageWithFile(178/2-94/2,160,94,19,UIResourcePath.FileLocate.camp .. "camp_battleTitle.png");
	self:addChild(page_title);
	--第几个战场
	self.battle_id_lab = CCZXImage:imageWithFile(178/2-94/2+94,162,10,16, UIResourcePath.FileLocate.normal .. "num0.png");
	self:addChild(self.battle_id_lab);

	--require "language/CN/Lang"
	self.count_dict = {};
	local xiaoyao_camp = UILabel:create_lable_2(Lang.camp_info[1], 30, 133, 14, ALIGN_LEFT);
	self:addChild(xiaoyao_camp);
	local xiaoyao_count = UILabel:create_lable_2("(0/80)", 100, 133, 14, ALIGN_LEFT);
	self:addChild(xiaoyao_count);
	self.count_dict[1] = xiaoyao_count;

	local xingchen_camp = UILabel:create_lable_2(Lang.camp_info[2], 30, 133-36, 14, ALIGN_LEFT);
	self:addChild(xingchen_camp);
	local xingchen_count = UILabel:create_lable_2("(0/80)", 100, 133-36, 14, ALIGN_LEFT);
	self:addChild(xingchen_count);
	self.count_dict[2] = xingchen_count;

	local yixian_camp = UILabel:create_lable_2(Lang.camp_info[3], 30, 133-36*2, 14, ALIGN_LEFT);
	self:addChild(yixian_camp);
	local yixian_count = UILabel:create_lable_2("(0/80)", 100, 133-36*2, 14, ALIGN_LEFT);
	self:addChild(yixian_count);
	self.count_dict[3] = yixian_count;

	local function req_enter_battle()
		CampBattleModel:req_enter_battle( self.battle_id )
	end 

	--进入战场事件
	local function enter_battle(eventType,x,y  )
		if eventType == TOUCH_CLICK then
			if self.battle_id then
				local battle_info = CampBattleModel:get_battle_info( )
				-- for i=1,battle_info.battle_count do
				-- 	if i~= self.battle_id then
				-- 		local flag = Utils:get_bit_by_position(battle_info.enter_flag,i)
				-- 		if flag == 1 then
				-- 			has_enter = true
				-- 		end 
				-- 	end 	
				-- end 
				if battle_info.enter_flag ~=0 and battle_info.enter_flag ~= self.battle_id then
					--进入过其他战场
					--LangGameString[2460]="进入别的战场会导致之前的战场积分清0。#r你确定进入新的战场么？"
					NormalDialog:show(LangGameString[2460], req_enter_battle, 1 )
				else
					req_enter_battle()
				end 

			end
		end
		return true
	end


	--enter 按钮  
	--xiehande 通用按钮
	local enter_btn = CCNGBtnMulTex:buttonWithFile(178/2-96/2, 5, 96, 43, UIResourcePath.FileLocate.common .. "button2.png") --btn_lang2.png	
  	enter_btn:addTexWithFile(CLICK_STATE_DOWN,UIResourcePath.FileLocate.common .. "button2.png")  -- btn_lang2.png
	enter_btn:registerScriptHandler(enter_battle) 
    self:addChild(enter_btn)

    local btn_lab = CCZXImage:imageWithFile(96/2-34/2, 15,34,17,UIResourcePath.FileLocate.camp .. "camp_enter.png");
	enter_btn:addChild(btn_lab);

end

function BattlePage:create()
	return BattlePage("BattlePage", "", false, 178, 200);
end