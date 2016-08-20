-- ZhengBaSaiView.lua
-- created by hcl on 2013-12-19
-- 自由赛统计

super_class.ZhengBaSaiView(Window)


function ZhengBaSaiView:update( fb_id,data )
	if data ~= nil then
		for i=1,16 do
			-- self.name_tabel[i] = data[i].name
			self.sub_name_lab_tab[i]:setText(data[i].name);
			local value_str = nil;
			if data[i].value >= 10000 then
				value_str = math.floor( data[i].value/10000 )..Lang.xiandaohui.tongji[9]	-- [9] = "万",
			else
				value_str = data[i].value;
			end
 			self.sub_value_lab_tab[i]:setText(value_str);
		end
	end
end

local _y = 400;

function ZhengBaSaiView:__init( )
	XianDaoHuiCC:req_match_info()
	-- self.view:setTexture(UILH_COMMON.bg_06);
 	
 	MUtils:create_zxfont(self.view,Lang.xiandaohui.tongji[10],52,_y-20,2,16);	-- [10] = "#cfff000名称",
 	MUtils:create_zxfont(self.view,Lang.xiandaohui.tongji[11],130,_y-20,2,16);	-- [11] = "#cfff000身价",
 	self.sub_name_lab_tab = {};
 	self.sub_value_lab_tab = {};
 	-- self.name_tabel = {}
 	for i=1,16 do
 		self.sub_name_lab_tab[i] = MUtils:create_zxfont(self.view,"六个字的名字",52,_y-(i+1)*23,2,14);
 		self.sub_value_lab_tab[i] = MUtils:create_zxfont(self.view,9999,130,_y-(i+1)*23,2,14);

	    -- local function btn_action_fun(eventType,args,msgid)
	    --     if ( eventType == TOUCH_BEGAN ) then
	    --         return true;
	    --     elseif ( eventType == TOUCH_CLICK ) then
	    --     	if self.name_tabel[i] ~= nil then
		   --      	local win = UIManager:show_window( "xdh_tongji_action_panel" )
		   --      	if win then
		   --      		win:set_select_name(self.name_tabel[i])
		   --      	end
		   --      end
	    --         return true;
	    --     end
	    --     return true
	    -- end

	    -- --操作按钮,点击后打开送花，扔鸡蛋等
	    -- self.btn_action = MUtils:create_btn(self.view,UILH_COMMON.right_arrows,UILH_COMMON.right_arrows,btn_action_fun,200,_y-(i+1)*23,-1,-1);
 	end

end

function ZhengBaSaiView:create( data )
	
	self.data = data;
	return ZhengBaSaiView( "ZhengBaSaiView", "",true, 150, 400 );

end
