-- SJSLQ.lua
-- create by hcl on 2013-8-9
-- 上届十六强

super_class.SJSLQ()

local title_pos = { 55,55+100,55+100*2,55+100*3,55+100*4, 55+100*5,55+100*6,55+100*7}

function SJSLQ:__init()
	local panel = CCBasePanel:panelWithFile(12,12,875,510,nil,500,500);

    ZImage:create(panel, UILH_COMMON.bottom_bg, 5, 10, 865, 493, 0, 500, 500)
	local paiming_bg = ZImage:create(panel, UILH_NORMAL.title_bg5, 17, 457, 840, 36, 0, 500, 500)
    self.view = panel;

	MUtils:create_zxfont(self.view,Lang.xiandaohui[6],title_pos[1]+10,468,2,16); -- [1184]="排名"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[7],title_pos[2]+10,468,2,16); -- [2235]="姓名"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[8],title_pos[3]+10,468,2,16); -- [722]="阵营"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[9],title_pos[4]+10,468,2,16); -- [2246]="积分"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[10],title_pos[5]+10,468,2,16); -- [2236]="战力"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[11],title_pos[6]+10,468,2,16); -- [2247]="胜率"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[12],title_pos[7]+10,468,2,16); -- [2248]="比赛场次"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[13],title_pos[8]+10,468,2,16); -- [723]="仙宗"

    self:create_scroll();

    ---------测试代码begin-----------
    -- self:update_sjslq();
    ---------测试代码end-----------

    return panel;
end

function SJSLQ:create_scroll(  )
	local _scroll_info = { x = 10 , y = 20 , width = 840, height = 435, maxnum = 0, stype = TYPE_HORIZONTAL }
    self.scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
    self.view:addChild(self.scroll);

    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then

            local temparg = Utils:Split(args,":")
            local row = temparg[1] +1             -- 行

            -- 每行的背景panel
            local panel = CCBasePanel:panelWithFile(0,270 - (row-1) * 50,840,40,nil,0,0);
            self.scroll:addItem(panel);
            self:create_scroll_item( panel ,row )
            self.scroll:refresh();
            return false
        end
    end
    self.scroll:registerScriptHandler(scrollfun);
    self.scroll:refresh()
end

function SJSLQ:create_scroll_item( parent ,index )
	MUtils:create_zxfont(parent,index,title_pos[1],10,2,16);
    MUtils:create_zxfont(parent,self.slq_info[index].name,title_pos[2],10,2,16);
    local camp_info = Lang.camp_info_ex[self.slq_info[index].camp];
    MUtils:create_zxfont(parent,camp_info.color..camp_info.name[2],title_pos[3],10,2,16);
    MUtils:create_zxfont(parent,self.slq_info[index].score,title_pos[4],10,2,16);
    MUtils:create_zxfont(parent,self.slq_info[index].fight_value,title_pos[5],10,2,16);
    local rate = 0;
    if ( self.slq_info[index].match_num~=0 ) then
        rate = math.floor(self.slq_info[index].victory_num/self.slq_info[index].match_num*10000)/100;
    end
    MUtils:create_zxfont(parent,"#cd58a08"..rate.."%",title_pos[6],10,2,16);
    MUtils:create_zxfont(parent,"#c08d53d"..self.slq_info[index].match_num,title_pos[7],10,2,16); -- [2248]="比赛场次"
    MUtils:create_zxfont(parent,"#cd0cda2"..self.slq_info[index].guild_name,title_pos[8],10,2,16); -- [723]="仙宗"
    ZImage:create(parent,UILH_COMMON.split_line,0,0,840,-1)
end

function SJSLQ:active()
	XianDaoHuiCC:req_last_zbs_16_info(  )
end

function SJSLQ:update( _type )
	if ( _type == "sjslq" ) then
		self:update_sjslq();
    elseif ( _type == "sub_panel") then
        XianDaoHuiCC:req_last_zbs_16_info(  )
	end
end

function SJSLQ:update_sjslq(  )
	local slq_info = XDHModel:get_slq_info();
    self.slq_info = slq_info;

    ---------测试代码begin-----------
    -- self.slq_info = {}
    -- for i=1,16 do
    --     self.slq_info[i] = {}
    --     self.slq_info[i].top = i
    --     self.slq_info[i].name = "无线无线无线"
    --     self.slq_info[i].camp = 1
    --     self.slq_info[i].score = i
    --     self.slq_info[i].fight_value = i*100000
    --     self.slq_info[i].match_num = i
    --     self.slq_info[i].victory_num = i-1
    --     self.slq_info[i].guild_name = "无"
    -- end
    ---------测试代码end-----------

    self.scroll:clear();
    self.scroll:setMaxNum(#self.slq_info);
    self.scroll:refresh();
    print("#slq_info",#slq_info);
end
