-- HLDZhuaBuXianPu.lua
-- created by hcl on 2013-9-25
-- 抓捕仙仆

super_class.HLDZhuaBuXianPu(Window)

local btn_str = { LangGameString[1262],LangGameString[1263] }; -- [1262]="抓捕仙仆" -- [1263]="夺仆之战"

-- 初始化
function HLDZhuaBuXianPu:__init( )

	local raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(25  ,358 , 256,50,nil);
    self.view:addChild(raido_btn_group);
	for i=1,2 do
		local function btn_fun(eventType,args,msg_id)
	        if eventType == TOUCH_CLICK then
	            self:do_tab_button_method(i);
	        end
	        return true
	    end
	    local btn = MUtils:create_radio_button(raido_btn_group,UIResourcePath.FileLocate.common .. "common_tab_n.png",UIResourcePath.FileLocate.common .. "common_tab_s.png",btn_fun, (i-1)*90,0,-1,-1,false);
	    MUtils:create_zxfont(btn,btn_str[i],41,11,2,14)
    end

    -- 创建滑动条
    MUtils:create_zximg(self.view,UIPIC_GRID_nine_grid_bg3,12,12,366,350,500,500);
   	self:create_scroll_view();

    local function enter_dft(eventType,arg)
        if eventType == TOUCH_CLICK then
            UIManager:show_window("doufatai_win");
        end
        return true;
    end

    self.shuoming_lab = MUtils:create_ccdialogEx(self.view,"想要雇佣仙仆，首先要有手下败将。点击进入斗法台击败一个玩家吧！",
                42,170,300,100,99,16)
    self.shuoming_lab:registerScriptHandler(enter_dft);
    self.shuoming_lab:setIsVisible(false);
end

function HLDZhuaBuXianPu:create_scroll_view()
	local _scroll_info = { x = 14 , y = 18 , width = 368, height = 330, maxnum = 0, stype = TYPE_HORIZONTAL }
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
            local panel = CCBasePanel:panelWithFile(0,0 ,310,110,"", 600, 600);
            self:create_scroll_item( panel,row )
            self.scroll:addItem(panel);
            self.scroll:refresh();
            return false
        end
    end
    self.scroll:registerScriptHandler(scrollfun);
    self.scroll:refresh() 
end

function HLDZhuaBuXianPu:create_scroll_item( parent,i )
    local info = self.scroll_data[i];
     -- 区域底
    local bg = ZImage:create(parent, UIResourcePath.FileLocate.common .. "top_button.png", 0, 2, 367, 114, 0, 500, 500)
    -- 头像背景
    MUtils:create_sprite(parent,UIResourcePath.FileLocate.task.."npc2_bg.png",60,60);
    local head_path = UIResourcePath.FileLocate.lh_normal .. "head/head"..info.job..info.sex..".png";
    -- 玩家头像
    MUtils:create_sprite(parent,head_path,60,60);
    -- 名字
    --MUtils:create_lab_with_bg(parent,nil,1,16,133,85,UIResourcePath.FileLocate.common.."test_bg.png");
    local use_name = ZTextImage:create(parent, "#cfff000"..info.name, UIResourcePath.FileLocate.common.."test_bg.png", 15, 130, 80, -1, -1, 500, 500)
    --ZLabel:create(parent, "#cfff000"..info.name, 190, 80, 15, nil, 1)
    -- 等级
    MUtils:create_zxfont(parent,LangGameString[940]..info.level,133,55,1,16); -- [940]="等级:"
    -- 仙宗
    MUtils:create_zxfont(parent,LangGameString[1234]..info.guild_name,133,30,1,16); -- [1234]="#c66ff66仙宗:"
    -- 抓捕按钮
    local function btn_fun( eventType,args,msgid )
        if eventType == TOUCH_CLICK then
            UIManager:hide_window("hld_main_win");
            HuanLeDouCC:req_catch( info.id, 0 );
        end
        return true;
    end
    local btn_str = "";
    if ( self.select_btn_index == 1 ) then
        btn_str = LangGameString[1264] -- [1264]="雇佣"
    elseif (self.select_btn_index == 2 ) then
        btn_str = LangGameString[1265] -- [1265]="掠夺"
    end
    MUtils:create_btn_and_lab(parent,UIResourcePath.FileLocate.common.."button2.png",nil,btn_fun,265,14,-1,-1,LangGameString[1264],16); -- [1264]="雇佣"

   
    --local line = MUtils:create_sprite(parent,UIResourcePath.FileLocate.common .. "top_button.png", 175,98);
    --line:setScaleX(1.4);
end

function HLDZhuaBuXianPu:do_tab_button_method( i )
    if ( i == 1 ) then
        HuanLeDouCC:req_loser_list(  )
    elseif ( i == 2 ) then
        HuanLeDouCC:req_duo_pu_list(  )
    end
    self.select_btn_index = i;
end

function HLDZhuaBuXianPu:update_scroll( data )
    self.scroll_data = data;
    self.scroll:clear();
    self.scroll:setMaxNum(#self.scroll_data);
    self.scroll:refresh();
    
    if #self.scroll_data == 0 and self.select_btn_index == 1 then
        self.shuoming_lab:setIsVisible(true);
    else
        self.shuoming_lab:setIsVisible(false);
    end
end

function HLDZhuaBuXianPu:active( show )
    if ( show ) then 
        -- 一开始默认选中第一个
        self:do_tab_button_method(1);
    end
end
