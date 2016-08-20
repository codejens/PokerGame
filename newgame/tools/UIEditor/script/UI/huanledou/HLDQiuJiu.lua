
-- HLDJieJiu.lua
-- created by hcl on 2013-9-25
-- 求救

super_class.HLDQiuJiu(Window)

-- 初始化
function HLDQiuJiu:__init( )

    -- 创建滑动条
    MUtils:create_zximg(self.view,UIPIC_GRID_nine_grid_bg3,12,12,366,378,500,500);
   	self:create_scroll_view();
    self.shuoming_lab = MUtils:create_ccdialogEx(self.view,"你暂时没有求救对象。求救对象为自己仙宗的玩家。",
                42,170,300,100,99,16)
    self.shuoming_lab:setIsVisible(false);
end


function HLDQiuJiu:create_scroll_view()
	local _scroll_info = { x = 20 , y = 24 , width = 342, height = 350, maxnum = 0, stype = TYPE_HORIZONTAL }
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

function HLDQiuJiu:create_scroll_item( parent,i )
    local info = self.scroll_data[i];
    -- 区域底
    ZImage:create(parent, UIResourcePath.FileLocate.common .. "top_button.png", 0, 2, 367, 114, 0, 500, 500)
    -- 头像背景
    MUtils:create_sprite(parent,UIResourcePath.FileLocate.task.."npc2_bg.png",60,60);
    local head_path = UIResourcePath.FileLocate.lh_normal .. "head/head"..info.job..info.sex..".png";
    -- 玩家头像
    MUtils:create_sprite(parent,head_path,60,60);
    -- 名字
   ZTextImage:create(parent, "#cfff000"..info.name, UIResourcePath.FileLocate.common.."test_bg.png", 15, 130, 80, -1, -1, 500, 500)
    -- 等级
    MUtils:create_zxfont(parent,"LV:"..info.level,133,55,1,16);
    -- 仙宗
    MUtils:create_zxfont(parent,LangGameString[1234]..info.guild_name,133,30,1,16); -- [1234]="#c66ff66仙宗:"
    local btn,lab = MUtils:create_common_btn(parent,"三个字",nil,250,14); -- [1235]="解救"
    -- 求救按钮
    local function btn_fun( eventType,args,msgid )
        if eventType == TOUCH_CLICK then
            HuanLeDouCC:req_help( info.id )
            GlobalFunc:create_screen_notic( string.format("已向%s发送求救申请",info.name) )
            btn:setCurState(CLICK_STATE_DISABLE);
            lab:setText("已求救")
        end
        return true;
    end
    btn:registerScriptHandler(btn_fun);

    local req_tab = HuanLeDouModel:get_my_hld_info().req_tab;
    for i,v in ipairs(req_tab) do
        if v == info.id then
            btn:setCurState(CLICK_STATE_DISABLE);
            lab:setText("已求救")
            return;
        end
    end
    lab:setText("求救")

    -- 分隔线
    -- local line = MUtils:create_sprite(parent,UIResourcePath.FileLocate.common .. "line.png", 175,98);
    -- line:setScaleX(1.4);
end

function HLDQiuJiu:active( show )
    if ( show ) then 
        HuanLeDouCC:req_get_my_guild_list(  )
    end
end

function HLDQiuJiu:update_scroll( data )
    print(" HLDQiuJiu:update_scroll( data )",#data)
    self.scroll_data = data;
    self.scroll:clear();
    self.scroll:setMaxNum(#self.scroll_data);
    self.scroll:refresh();
    if #self.scroll_data == 0 then
        self.shuoming_lab:setIsVisible(true);
    else
        self.shuoming_lab:setIsVisible(false);
    end
end
