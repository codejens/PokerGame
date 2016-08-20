-- MarriageQingyuanPage.lua
-- create by fjh on 2013-8-15
-- 结婚系统的情缘分页

super_class.MarriageQingyuanPage()

local pos_dict = {{176-62/2,279-58/2},{254-62/2,306-58/2},{254+67-62/2,306-51-58/2},{254+67-15-62/2,306-51-86-58/2},
						{254-62/2,306-51-91-56-58/2},{176-62/2,306-51-91-56-43-58/2},{254-145-62/2,306-51-91-56-58/2},
						{254+67-15-260-62/2,306-51-86-58/2},{254+67-286-62/2,306-51-58/2},{254-155-62/2,306-58/2},};


function MarriageQingyuanPage:__init( x, y, w, h )
	
	self.view = CCBasePanel:panelWithFile( x, y, w, h,"");

	self.btn_dict = {};

	for i=1,10 do
		local function click_event(  )
			local marriage_data = MarriageModel:get_marriage_data();
			local level = marriage_data.level;
			if i <= marriage_data.count then
				level = level + 1;
			end
			local data = { index = i, level = level };
			TipsModel:show_heart_tip( data );
		end
		local btn = TextButton:create( nil, pos_dict[i][1], pos_dict[i][2], 62, 58, "#cfff0000", UIResourcePath.FileLocate.marriage.."heart_d.png" );
		self.view:addChild( btn.view );
		btn:setTouchClickFun(click_event);
		self.btn_dict[i] = btn;
	end

	-- 倾注按钮
	self.qingzhu_btn = TextButton:create( nil, 130, 7, 87, 34, LangGameString[1509], UIResourcePath.FileLocate.marriage.."button.png" ); -- [1509]="#cfafed0倾注"
	self.view:addChild( self.qingzhu_btn.view );

	-- 倾注--升级仙缘
	local function qingzhu_btn_event(  )
		MarriageModel:req_uplevel_xianyuan(  )
	end
	self.qingzhu_btn:setTouchClickFun(qingzhu_btn_event);

	-- 帮助说明
	local help_btn = TextButton:create( nil, 130-106, 9, 87, 34, LangGameString[1510], nil); -- [1510]="#cfff000#u1帮助说明#u0"
	self.view:addChild( help_btn.view );
	local function help_btn_event(  )
		local str = LangGameString[1511]; -- [1511]="1、仙缘只有已婚玩家才能修炼，仙缘只对自己有效，仙侣修炼不会影响到自己#r2、仙缘修炼需要消耗与仙侣的亲密度#r3、亲密度可通过举办婚宴、情侣间的互赠鲜花和双修打坐、使用结婚戒指获得#r4、离婚之后，仙缘修炼效果保留，但是不能继续修炼#r5、离婚之后再婚，仙缘才可以继续修炼"
		HelpPanel:show( 3, UIResourcePath.FileLocate.marriage.."tip_title_2.png", str );
	end
	help_btn:setTouchClickFun( help_btn_event );

	--详细信息
	local info_btn = TextButton:create( nil, 130+123, 9, 87, 34, LangGameString[1512], nil); -- [1512]="#cfff000#u1详细信息#u0"
	self.view:addChild( info_btn.view );
	local function info_btn_event(  )
		local marriage_data = MarriageModel:get_marriage_data();
	
		TipsModel:show_XY_detail_tip( marriage_data );
	end
	info_btn:setTouchClickFun( info_btn_event );


	-- 当前亲密度
	local lab = UILabel:create_lable_2( LangGameString[1513], 355/2+5, 140, 16, ALIGN_CENTER ); -- [1513]="#cff00ff当前亲密度"
	self.view:addChild(lab);

	self.sweet_value = UILabel:create_lable_2( "0", 355/2+5, 140-25, 16, ALIGN_CENTER );
	self.view:addChild(self.sweet_value);

	-- 仙缘级别
	local function xianyuan_event( eventType )
		if eventType == TOUCH_CLICK then

			local data = MarriageModel:get_marriage_data(  );
			TipsModel:show_XY_tip( data );

		end
	end
	self.xianyuan_btn = MUtils:create_btn(self.view, UIResourcePath.FileLocate.marriage.."xianyuan_0.png", UIResourcePath.FileLocate.marriage.."xianyuan_0.png",
											xianyuan_event, 355/2-89/2, 190, 89, 54);

	-- 特效层
	self.effect_view = CCBasePanel:panelWithFile( 0, 0, w, h,"");
	self.view:addChild(self.effect_view);
end


------------------------------界面更新

function MarriageQingyuanPage:active( show )
	if show == false then
		self.effect_view:removeAllChildrenWithCleanup(true);
	end
end

-- 更新仙缘等级
function MarriageQingyuanPage:update_xianyuan_level( count, level )
	
	local ring_model = UserInfoModel:get_equip_by_type( ItemConfig.ITEM_TYPE_MARRIAGE_RING );
	if ring_model ~= nil then
		self.qingzhu_btn:setCurState(CLICK_STATE_UP);
	else
		self.qingzhu_btn:setCurState(CLICK_STATE_DISABLE);
	end

	for i,v in ipairs(self.btn_dict) do
		v:setText( ""..level );
		v.view:addTexWithFile(CLICK_STATE_UP, UIResourcePath.FileLocate.marriage.."heart_d.png")
		v.view:setCurState(CLICK_STATE_UP);

		if i <= count then
			
			v:setText( ""..(level+1) );
			v.view:addTexWithFile( CLICK_STATE_UP, UIResourcePath.FileLocate.marriage.."heart_n.png")
			v.view:setCurState(CLICK_STATE_UP);
		end
	end


	if level == 8 and count == 10 then
		-- 当然等级为8，且点亮的红心数为10，这时为满级，没有下发9级的，这时候做9级处理
		level = 9;
	end
	local str = string.format("xianyuan_%d.png",level);
	self.xianyuan_btn:addTexWithFile( CLICK_STATE_UP, UIResourcePath.FileLocate.marriage .. str )
	self.xianyuan_btn:addTexWithFile( CLICK_STATE_DOWN, UIResourcePath.FileLocate.marriage .. str )
	self.xianyuan_btn:setCurState( CLICK_STATE_UP );

end	

-- 更新亲密度
function MarriageQingyuanPage:update_sweet_value( sweet )
	print("更新亲密度",sweet);
	self.sweet_value:setText( ""..sweet );
end


-- 播放红心点亮成功的特效
function MarriageQingyuanPage:play_heart_effect( heart_index )

	local effectManager = ZXEffectManager:sharedZXEffectManager();

    effectManager:run_mount_xilian_action("frame/effect/jm/11016", "frame/effect/jm/11016", self.effect_view, pos_dict[heart_index][1]+62/2, pos_dict[heart_index][2]+58/2,
                                            355/2, 190+54/2,0.5);

end

-- 播放仙缘等级升级成功的特效
function MarriageQingyuanPage:play_xy_uplevel_effect(  )

	LuaEffectManager:play_view_effect( 408, 174, 185, self.effect_view, false);

end
