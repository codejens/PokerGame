-- HLDZhuPuHuDong.lua
-- created by hcl on 2013-9-25
-- 主仆互动

super_class.HLDZhuPuHuDong(Window)

-- 初始化
function HLDZhuPuHuDong:__init( )

    self:create_close_btn_and_title();

    -- 创建滑动条
    MUtils:create_zximg(self.view,UIPIC_GRID_nine_grid_bg3,12,12,366,378,500,500);
   	self:create_scroll_view();
end

function HLDZhuPuHuDong:create_close_btn_and_title()
    -- 标题
    --local wing_title_sp = CCZXImage:imageWithFile(389/2-230/2+18,429-45,226,46,UIResourcePath.FileLocate.common .. "win_title1.png");
   --self.view:addChild(wing_title_sp,99);
    --MUtils:create_sprite(wing_title_sp,UIResourcePath.FileLocate.huanledou .."hld_t_zphd.png",113,23)
    local function close_fun(event_type,args,msgid )
        if event_type == TOUCH_CLICK then
            UIManager:hide_window("hld_zhupuhudong");
        end
        return true
    end

    -- 关闭按钮
    local close_btn = CCNGBtnMulTex:buttonWithFile(344, 370, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_z.png")
    local exit_btn_size = close_btn:getSize()
    local spr_bg_size = self:getSize()
    close_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    close_btn:addTexWithFile(CLICK_STATE_DOWN,UIResourcePath.FileLocate.common .. "close_btn_z.png")
    --注册关闭事件
    close_btn:registerScriptHandler(close_fun) 
    self.view:addChild(close_btn,99)
end

function HLDZhuPuHuDong:create_scroll_view()
	local _scroll_info = { x = 14 , y = 24 , width = 368, height = 350, maxnum = 0, stype = TYPE_HORIZONTAL }
    self.scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
    self.view:addChild(self.scroll);

    self.timer_lab_tab = {};

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
            local function panel_fun(eventType,args,msgid,self_item)
                if eventType == ITEM_DELETE then
                    print("-------------------ITEM_DELETE")
                    print("row = ",row);
                    if ( self.timer_lab_tab[row] ) then 
                        self.timer_lab_tab[row]:destroy();
                        self.timer_lab_tab[row] = nil;
                    end
                end
                return true;
            end
            panel:registerScriptHandler(panel_fun);
            return false
        end
    end
    self.scroll:registerScriptHandler(scrollfun);
    self.scroll:refresh() 
end

function HLDZhuPuHuDong:create_scroll_item( parent,i )
    local info = self.scroll_data[i];
      -- 区域底
    local bg = ZImage:create(parent, UIResourcePath.FileLocate.common .. "top_button.png", 0, 2, 367, 114, 0, 500, 500)
    -- 头像背景
    MUtils:create_sprite(parent,UIResourcePath.FileLocate.task.."npc2_bg.png",60,60);
    local head_path = UIResourcePath.FileLocate.lh_normal .. "head/head"..info.job..info.sex..".png";
    -- 玩家头像
    MUtils:create_sprite(parent,head_path,60,60);
    -- 名字
    --MUtils:create_lab_with_bg(parent,"#cfff000"..info.name,1,16,133,75,UIResourcePath.FileLocate.common.."title_bg_01_s.png");
    local use_name = ZTextImage:create(parent, "#cfff000"..info.name, UIResourcePath.FileLocate.common.."test_bg.png", 15, 130, 80, -1, -1, 500, 500)
    
    if ( info.interactiveCD > 0 ) then 
        -- 互动保护
        local hudong_lab = MUtils:create_zxfont(parent,LangGameString[1266],133,50,1,16); -- [1266]="互动保护中:"
        self.timer_lab_tab[i] = TimerLabel:create_label(hudong_lab, 100, 0, 16, info.interactiveCD-1, "#c66ff66", nil,false);
    end
    -- 释放
    local function btn_fun( eventType,args,msgid )
        if eventType == TOUCH_CLICK then
            HuanLeDouCC:req_free_kugong( info.id )
        end
        return true;
    end
    MUtils:create_btn_and_lab(parent,UIResourcePath.FileLocate.common.."button2.png",nil,btn_fun,133,15,-1,-1,LangGameString[1254],16); -- [1254]="释放"

    -- 互动
    local function btn_hudong_fun( eventType,args,msgid )
        if eventType == TOUCH_CLICK then
            HLDZhuPuHuDongAction:show( info );
        end
        return true;
    end
    MUtils:create_common_btn( parent,LangGameString[1267],btn_hudong_fun,270,15 ); -- [1267]="互动"

    -- 分隔线
    --local line = MUtils:create_sprite(parent,UIResourcePath.FileLocate.common .. "line.png", 175,98);
    --line:setScaleX(1.4);
end

function HLDZhuPuHuDong:active( show )
    if ( show ) then 
        HuanLeDouCC:req_kugong_list()
    else
        self.scroll:clear();
    end
end

function HLDZhuPuHuDong:update_scroll( data )
    self.scroll_data = data;
    self.scroll:clear();
    self.scroll:setMaxNum(#self.scroll_data);
    self.scroll:refresh();
end
