-- XunRenShuangXiuWin.lua
-- create by hcl on 2013-2-16
-- 主动邀请别人双修窗口

-- 左边距
local l_m = 9;
-- 下边距
local b_m = 43;

require "UI/component/Window"
super_class.XunRenShuangXiuWin(Window)

-- type 1 邀请别人双修界面,2被邀请双修界面 
function XunRenShuangXiuWin:show(  )

	local win = UIManager:show_window("xunrenshuangxiu_win");
	if ( win ) then
		-- 请求可邀请双修的列表
		ShuangXiuCC:req_can_invite_shuangxiu_players( );
	end

end

function XunRenShuangXiuWin:__init( window_name, texture_name)

	-- 标题和关闭按钮
	-- MUtils:create_sprite(self.view,UIResourcePath.FileLocate.common .. "win_title1.png",194-l_m,480-25-b_m);
    
 --    MUtils:create_sprite(self.view,UIResourcePath.FileLocate.other .. "xrsx_title.png",194-l_m,480-22-b_m);

    -- 九宫格背景
    MUtils:create_zximg(self.view,UIPIC_GRID_nine_grid_bg3,24-l_m,480-371-b_m,349,323,500,500);
    -- 说明背景
    MUtils:create_zximg(self.view,UIResourcePath.FileLocate.common .. "jishou_test_bg.png",50-l_m,480-365-b_m,296,51,500,500);
    -- 说明文字
    MUtils:create_zxfont(self.view,LangGameString[1900],42 - l_m,140 - b_m,1,16); -- [1900]="#c35C3F7双修说明:"
    MUtils:create_zxfont(self.view,LangGameString[1901],194 - l_m,120 - b_m,2,16); -- [1901]="#c35C3F7双修可以获得更多经验和灵气"

    -- 三个分隔条
    ZImage:create(self.view,UIResourcePath.FileLocate.common .. "fenge_bg.png",39-l_m,480-365-b_m,318,-1);
    ZImage:create(self.view,UIResourcePath.FileLocate.common .. "fenge_bg.png",39-l_m,480-314-b_m,318,-1);
    ZImage:create(self.view,UIResourcePath.FileLocate.common .. "fenge_bg.png",39-l_m,480-91-b_m,318,-1);


    require "UI/component/ToggleView"
    -- 是否自动接收他人邀请双修
    local function auto_fun()
        local is_auto = SetSystemModel:get_date_value_by_key( SetSystemModel.ACCEPT_COUPLE_ZAZEN_INVITATION );
        SetSystemModel:set_one_date( SetSystemModel.ACCEPT_COUPLE_ZAZEN_INVITATION, not is_auto );
    end
    self.toggle_view = ToggleView:create(1,self.view,29 - l_m,75 - b_m,25,25,auto_fun,CCPoint(0,0),nil,UIResourcePath.FileLocate.common .. "dg-2.png",UIResourcePath.FileLocate.common .. "dg-1.png");
    -- 根据系统配置去显示正确的帧数
    local show_index = 2;
    if ( SetSystemModel:get_date_value_by_key( SetSystemModel.ACCEPT_COUPLE_ZAZEN_INVITATION ) ) then
        show_index = 1;
    end
    self.toggle_view:show_frame( show_index );
    
    self.toggle_view_text = MUtils:create_zxfont(self.view,LangGameString[1902],55 - l_m,80 - b_m,1,14); -- [1902]="#c66ff66打坐时自动接收他人邀请双修"

    -- 存放附近可以双修的人的数据
    self.can_shuangxiu_infos = {};

    -- 创建滚动条
    self:create_scroll_view();

    -- 一键邀请
    local function btn_fun(eventType,args,msgid)
    	if eventType == TOUCH_CLICK then
            for i=1,#self.can_shuangxiu_infos do
                print("邀请"..self.can_shuangxiu_infos[ i ].name.."双修");
                ShuangXiuCC:req_shuangxiu( self.can_shuangxiu_infos[ i ].name , 1);
                self.scroll:setMaxNum(0);
                self.scroll:clear();
                self.scroll:refresh();
            end
        end
        return true
    end
    self.invite_btn = MUtils:create_btn_and_lab(self.view,UIResourcePath.FileLocate.common .. "button4.png",UIResourcePath.FileLocate.common .. "button4.png",btn_fun,274 - l_m,65 - b_m,-1,-1,LangGameString[1903]); -- [1903]="一键邀请"

end


function XunRenShuangXiuWin:create_scroll_view()

	-- 滚动条上面的标题
  	MUtils:create_zxfont(self.view,LangGameString[1904],70,400-b_m,2,15); -- [1904]="#cfff000姓名"
    MUtils:create_zxfont(self.view,LangGameString[1905],155,400-b_m,2,15); -- [1905]="#cfff000等级"
    MUtils:create_zxfont(self.view,LangGameString[1906],200,400-b_m,2,15); -- [1906]="#cfff000性别"
    MUtils:create_zxfont(self.view,LangGameString[867],245,400-b_m,2,15); -- [867]="#cfff000阵营"

	--#self.can_shuangxiu_infos
	 -- 创建滚动条
    self.scroll = CCScroll:scrollWithFile(30-l_m,184-b_m,335,200,#self.can_shuangxiu_infos,nil,TYPE_HORIZONTAL,500,500);
    self.view:addChild(self.scroll);

    --self.scroll:setEnableCut(true)

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
            --print("row = " .. row);

            -- 每行的背景panel
            local panel = CCBasePanel:panelWithFile(0,180 - row * 40,335,40,nil,0,0);
            self.scroll:addItem(panel);
            local struct = self.can_shuangxiu_infos[row];
            -- 姓名，等级，性别，阵营，按钮
            MUtils:create_zxfont(panel,"#c66ff66" .. struct.name,50,7,2,14);
            MUtils:create_zxfont(panel,"Lv" .. struct.lv,135,7,2,14);
            MUtils:create_zxfont(panel,MUtils:get_sex_str(struct.sex),180,7,2,14);
            MUtils:create_zxfont(panel,MUtils:get_zhenying_name(struct.camp),225,7,2,14);

            self:create_btn_by_show_type( panel ,row );

            self.scroll:refresh();
            return false
        end
    end
    self.scroll:registerScriptHandler(scrollfun);
    self.scroll:refresh()
end

function XunRenShuangXiuWin:update( type, arg_table )
	if ( type == 1 ) then
		self.can_shuangxiu_infos = SXModel:get_can_invite_shuangxiu_player_table();
        self.scroll:clear();
		self.scroll:setMaxNum(#self.can_shuangxiu_infos);
		self.scroll:refresh();
	end
end

function XunRenShuangXiuWin:create_btn_by_show_type( parent ,index )
  	-- 邀请
    local function invite_fun(eventType,args,msgid)
    	if eventType == TOUCH_CLICK then
    		-- 邀请别人双修
            print("self.can_shuangxiu_infos[ index ].name",self.can_shuangxiu_infos[ index ].name)
            ShuangXiuCC:req_shuangxiu( self.can_shuangxiu_infos[ index ].name , 1);
            SXModel:remove_can_invite_shuangxiu_player_table( index )
            self.can_shuangxiu_infos = SXModel:get_can_invite_shuangxiu_player_table();
            self.scroll:setMaxNum(#self.can_shuangxiu_infos);
            self.scroll:clear();
            self.scroll:refresh();
        end
        return true
    end
    -- MUtils:create_btn_and_lab(parent,UIResourcePath.FileLocate.common .. "button_bg_n.png",UIResourcePath.FileLocate.common .. "button2_bg.png",invite_fun,260,0,61,29,"双修");
    MUtils:create_common_btn(parent,"双修",invite_fun,260,0)
end

function XunRenShuangXiuWin:get_is_auto()
    return is_auto;
end

function XunRenShuangXiuWin:active( show )

end
