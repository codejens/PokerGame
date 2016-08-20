-- YQSXWin.lua
-- create by hcl on 2013-2-16
-- 主动邀请别人双修窗口
-- 左边距
local l_m = 9;
-- 下边距
local b_m = 43;

require "UI/component/Window"
super_class.YQSXWin(Window)

-- type 2被邀请双修界面 
function YQSXWin:show(  )

	local win = UIManager:show_window("yqsx_win");
	if ( win ) then
		-- 更新scrollview;
		win:update(1);
	end

end

function YQSXWin:__init( window_name, texture_name)

	-- 标题和关闭按钮
	-- MUtils:create_sprite(self.view,UIResourcePath.FileLocate.common .. "win_title1.png",194-l_m,480-25-b_m);
    
 --    MUtils:create_sprite(self.view,UIResourcePath.FileLocate.other .. "yqsx_title.png",194-l_m,480-22-b_m);

 --    local function btn_close_fun(eventType,x,y)
 --        if eventType == TOUCH_CLICK then
 --            local function close_fun()
 --                for i=1,#self.invite_shuangxiu_infos do
 --                    ShuangXiuCC:req_shuangxiu_response( self.invite_shuangxiu_infos[i].name,0 )
 --                end
 --                UIManager:hide_window("yqsx_win");
 --            end
 --            NormalDialog:show(LangGameString[1908],close_fun); -- [1908]="关闭窗口自动拒绝所有邀请,是否关闭?"
 --            return true;
 --        end
 --        return true
 --    end
 --    local exit_btn = MUtils:create_btn(self.view,UIResourcePath.FileLocate.common .. "close_btn_n.png",UIResourcePath.FileLocate.common .. "close_btn_s.png",btn_close_fun,340-l_m,480-54-b_m,-1,-1);
 --    local exit_btn_size = exit_btn:getSize()
 --    local spr_bg_size = self.view:getSize()
 --    exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
  
    -- 九宫格背景
    MUtils:create_zximg(self.view,UIPIC_GRID_nine_grid_bg3,24-l_m,480-371-b_m,349,323,500,500);
    -- 说明背景
    MUtils:create_zximg(self.view,UIResourcePath.FileLocate.common .. "jishou_test_bg.png",50-l_m,480-365-b_m,296,51,500,500);
    -- 说明文字
    MUtils:create_zxfont(self.view,LangGameString[1900],42 - l_m,140 - b_m,1,16); -- [1900]="#c35C3F7双修说明:"
    MUtils:create_zxfont(self.view,LangGameString[1909],194 - l_m,120 - b_m,2,16); -- [1909]="#c35C3F7双修可以获得经验和灵气"

    -- 三个分隔条
    ZImage:create(self.view,UIResourcePath.FileLocate.common .. "fenge_bg.png",39-l_m,480-365-b_m,318,-1);
    ZImage:create(self.view,UIResourcePath.FileLocate.common .. "fenge_bg.png",39-l_m,480-314-b_m,318,-1);
    ZImage:create(self.view,UIResourcePath.FileLocate.common .. "fenge_bg.png",39-l_m,480-91-b_m,318,-1);

    -- 存放邀请双修的人的数据
    self.invite_shuangxiu_infos = {};

    -- 创建滚动条
    self:create_scroll_view();
end


function YQSXWin:create_scroll_view()

	-- 滚动条上面的标题
  	MUtils:create_zxfont(self.view,"#cfff000姓名",70,400-b_m,2,15);
    MUtils:create_zxfont(self.view,"#cfff000等级",155,400-b_m,2,15);
    MUtils:create_zxfont(self.view,"#cfff000性别",200,400-b_m,2,15);
    -- MUtils:create_zxfont(self.view,"#cfff000阵营",245,400-b_m,2,15);

	 -- 创建滚动条
    self.scroll = CCScroll:scrollWithFile(30-l_m,184-b_m,335,200,#self.invite_shuangxiu_infos,"",TYPE_HORIZONTAL);
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
            print("row = " .. row);

            -- 每行的背景panel
            local panel = CCBasePanel:panelWithFile(0,180 - row * 40,335,40,nil,0,0);
            self.scroll:addItem(panel);
            local struct = self.invite_shuangxiu_infos[row];
            -- 姓名，等级，性别，阵营，按钮
            MUtils:create_zxfont(panel,"#c66ff66" .. struct.name,50,7,2,14);
            MUtils:create_zxfont(panel,"Lv" .. struct.lv,135,7,2,14);
            MUtils:create_zxfont(panel,MUtils:get_sex_str(struct.sex),180,7,2,14);
            -- MUtils:create_zxfont(panel,MUtils:get_zhenying_name(struct.camp),225,7,2,14);

            self:create_btn_by_show_type( panel ,row ,struct.name);

            self.scroll:refresh();
            return false
        end
    end
    self.scroll:registerScriptHandler(scrollfun);
    self.scroll:refresh()
end

function YQSXWin:update( type, arg_table )
	if ( type == 1 ) then
		self.invite_shuangxiu_infos = SXModel:get_invite_shuangxiu_player_table();
        local len = #self.invite_shuangxiu_infos;
        print("len = ",len);
		self.scroll:setMaxNum(len);
		self.scroll:refresh();
	end
end

function YQSXWin:create_btn_by_show_type( parent ,index ,name)

	-- 接受邀请
    local function accept_fun(eventType,args,msgid)
    	if eventType == TOUCH_CLICK then
            ShuangXiuCC:req_shuangxiu_response( name,1 )
            SXModel:remove_invite_shuangxiu_player_table( index );
            self.invite_shuangxiu_infos = SXModel:get_invite_shuangxiu_player_table();
            self.scroll:setMaxNum(#self.invite_shuangxiu_infos);
            self.scroll:clear();
            self.scroll:refresh();
        end
        return true;
    end
    -- MUtils:create_btn_and_lab(parent,UIResourcePath.FileLocate.common .. "button_bg_n.png",UIResourcePath.FileLocate.common .. "button2_bg.png",accept_fun,250,0,40,29,"接受");
	MUtils:create_common_btn( parent,"接受",accept_fun,200,0)
    -- 拒绝邀请
    local function refuse_fun(eventType,args,msgid)
    	if eventType == TOUCH_CLICK then
            ShuangXiuCC:req_shuangxiu_response( name,0 )
            SXModel:remove_invite_shuangxiu_player_table( index );
            self.invite_shuangxiu_infos = SXModel:get_invite_shuangxiu_player_table();
            self.scroll:setMaxNum(#self.invite_shuangxiu_infos);
            self.scroll:clear();
            self.scroll:refresh();
        end
        return true;
    end
    -- MUtils:create_btn_and_lab(parent,UIResourcePath.FileLocate.common .. "button_bg_n.png",UIResourcePath.FileLocate.common .. "button2_bg.png",refuse_fun,295,0,40,29,"拒绝");
    MUtils:create_common_btn( parent,"拒绝",refuse_fun,270,0)
end
