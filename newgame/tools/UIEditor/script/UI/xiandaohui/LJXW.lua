-- LJXW.lua
-- create by hcl on 2013-8-9
-- 上届十六强

super_class.LJXW()

local title_pos = { 65+10,190+10,305+10,400+10,510+10, 620+10,740+10}

function LJXW:__init()
	local panel = CCBasePanel:panelWithFile(12,12,875,510,nil,500,500);

    ZImage:create(panel, UILH_COMMON.bottom_bg, 5, 10, 865, 493, 0, 500, 500)
	local paiming_bg = ZImage:create(panel, UILH_NORMAL.title_bg5, 17, 457, 840, 36, 0, 500, 500)
    self.view = panel;

	MUtils:create_zxfont(self.view,Lang.xiandaohui[14],title_pos[1]+10,468,2,16); -- [2234]="序号"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[7],title_pos[2]+10,468,2,16); -- [2235]="姓名"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[8],title_pos[3]+10,468,2,16); -- [722]="阵营"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[13],title_pos[4]+10,468,2,16); -- [723]="仙宗"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[10],title_pos[5]+10,468,2,16); -- [2236]="战力"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[15],title_pos[6]+10,468,2,16); -- [2237]="宠物战力"
    MUtils:create_zxfont(self.view,Lang.xiandaohui[16],title_pos[7]+10,468,2,16); -- [2238]="时间"

    self:create_scroll();
    ---------测试代码begin-----------
    -- self:update_sjslq();
    ---------测试代码end-----------

    return panel;
end

function LJXW:create_scroll(  )
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

function LJXW:create_scroll_item( parent ,index )
    local max_num = #self.ljxw_info;
	MUtils:create_zxfont(parent,string.format(Lang.xiandaohui[29],max_num - index + 1),title_pos[1],10,2,16);  --Lang.xiandaohui[29]= "第%d届"
    MUtils:create_zxfont(parent,self.ljxw_info[index].name,title_pos[2],10,2,16);
    -- print("self.ljxw_info[index].camp",self.ljxw_info[index].camp);
    local camp_info = Lang.camp_info_ex[self.ljxw_info[index].camp];
    MUtils:create_zxfont(parent,camp_info.color..camp_info.name[2],title_pos[3],10,2,16);
    MUtils:create_zxfont(parent,self.ljxw_info[index].guild_name,title_pos[4],10,2,16);
    MUtils:create_zxfont(parent,self.ljxw_info[index].fight_value,title_pos[5],10,2,16);
    MUtils:create_zxfont(parent,self.ljxw_info[index].pet_value,title_pos[6],10,2,16);
    MUtils:create_zxfont(parent, Utils:format_time_to_data(self.ljxw_info[index].time, "/"),title_pos[7],10,2,16);
    ZImage:create(parent,UILH_COMMON.split_line,0,0,840,-1)
end

function LJXW:active()
	XianDaoHuiCC:req_xw_info()
end

function LJXW:update( _type )
	if ( _type == "ljxw" ) then
		self:update_sjslq();
    elseif ( _type == "sub_panel") then
        XianDaoHuiCC:req_xw_info()
	end
end

function LJXW:update_sjslq(  )
	local ljxw_info = XDHModel:get_ljxw_info();
    self.ljxw_info = ljxw_info;

    ---------测试代码begin-----------
    -- self.ljxw_info = {};
    -- for i=1,16 do
    --     self.ljxw_info[i] = {}
    --     self.ljxw_info[i].id = i;               --玩家id
    --     self.ljxw_info[i].name = "无线无线无线";          --玩家名字
    --     self.ljxw_info[i].camp = 1;            --玩家职业
    --     self.ljxw_info[i].guild_name = "无"
    --     self.ljxw_info[i].fight_value = i*100000;      --玩家战斗力
    --     self.ljxw_info[i].pet_value = i*100000;        --宠物战斗力
    --     self.ljxw_info[i].time = 50000;            --时间
    -- end
    ---------测试代码end-----------


    print("#ljxw_info",#ljxw_info);
    self.scroll:clear();
    self.scroll:setMaxNum(#self.ljxw_info);
    self.scroll:refresh();
end
