-- ZiYouSaiView.lua
-- created by hcl on 2013-12-19
-- 自由赛统计

super_class.ZiYouSaiView(Window)


function ZiYouSaiView:destroy(  )
	if self.ziyousai_timer then
		self.ziyousai_timer:stop();
		self.ziyousai_timer = nil;
	end
	Window.destroy(self);
end

local title_table = {Lang.xiandaohui.tongji[1],Lang.xiandaohui.tongji[2],Lang.xiandaohui.tongji[3],Lang.xiandaohui.tongji[4],Lang.xiandaohui.tongji[5],Lang.xiandaohui.tongji[6], }
--local title_table = { "名    次:","积    分:","比赛次数:","胜利次数:","胜    率:","荣    誉:", }

function ZiYouSaiView:update( fb_id,data )
	if data ~= nil then
		self.rank:setText(string.format("%s%s",title_table[1],data.rank))
		self.score:setText(string.format("%s%s",title_table[2],data.score))
		self.match_count:setText(string.format("%s%s",title_table[3],data.match_num))
		self.win_count:setText(string.format("%s%s",title_table[4],data.victory_num))
		local win_rate = 0;
		if data.match_num ~= 0 then
			win_rate = math.floor(data.victory_num/data.match_num*100)
		end
		self.win_rate:setText(string.format("%s%s%%",title_table[5],win_rate))
		local player = EntityManager:get_player_avatar();
		self.honor:setText(string.format("%s%s",title_table[6],player.honor))
	end
end

local _y = 200;

function ZiYouSaiView:__init( )
	XianDaoHuiCC:req_match_info()
	-- self.view:setTexture(UILH_COMMON.bg_06);
 	
 	MUtils:create_zxfont(self.view,Lang.xiandaohui.tongji[7],3,_y-20,1,16);
 	self.rank = MUtils:create_zxfont(self.view,"",3,_y-40,1,16);
 	self.score = MUtils:create_zxfont(self.view,"",3,_y-60,1,16);
 	self.match_count = MUtils:create_zxfont(self.view,"",3,_y-80,1,16);
 	self.win_count = MUtils:create_zxfont(self.view,"",3,_y-100,1,16);
 	self.win_rate = MUtils:create_zxfont(self.view,"",3,_y-120,1,16);
 	self.honor = MUtils:create_zxfont(self.view,"",3,_y-140,1,16);
 	MUtils:create_zxfont(self.view,Lang.xiandaohui.tongji[8],3,_y-160,1,16);

 	self.ziyousai_timer = timer();
 	local function fun()
 		XianDaoHuiCC:req_match_info()
 	end
 	self.ziyousai_timer:start(60,fun);
end

function ZiYouSaiView:create( data )
	
	self.data = data;
	return ZiYouSaiView("ZiYouSaiView", "", true, 150, 200);

end
