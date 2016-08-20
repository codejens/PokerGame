-- HLDYaZhaXianPu.lua
-- created by hcl on 2013-9-25
-- 压榨仙仆

super_class.HLDYaZhaXianPu(Window)

local is_next_show_yazha_tip = false;
local is_next_show_chougan_tip = false;

-- 初始化
function HLDYaZhaXianPu:__init( )

    -- 创建滑动条
    MUtils:create_zximg(self.view,UIPIC_GRID_nine_grid_bg3,12,12,366,378,500,500);
   	self:create_scroll_view();
end


function HLDYaZhaXianPu:create_scroll_view()

	local _scroll_info = { x = 14 , y = 44 , width = 368, height = 350, maxnum = 0, stype = TYPE_HORIZONTAL }
    self.scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, "", _scroll_info.stype )
    self.view:addChild(self.scroll);

    self.timer_lab_tab = {};

    local function scrollfun(eventType, args, msg_id  )
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
            print("-------------------SCROLL_CREATE_ITEM",row)
            -- 每行的背景panel
            local panel = CCBasePanel:panelWithFile(0,0 ,310,167,"", 600, 600);
            self:create_scroll_item( panel,row )
            self.scroll:addItem(panel);
            self.scroll:refresh();

            local function panel_fun(eventType,args,msgid,self_item)
                if eventType == ITEM_DELETE then
                    print("-------------------ITEM_DELETE")
                    local index = tonumber( self_item:getDataInfo() );
                    print("index = ",index);
                    if ( self.timer_lab_tab[index] ) then 
                        if self.timer_lab_tab[index].work_time_lab then
                            self.timer_lab_tab[index].work_time_lab:destroy();
                        end
                        self.timer_lab_tab[index] = nil;
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

function HLDYaZhaXianPu:create_scroll_item( parent,i )
    local info = self.scroll_data[i];
    -- 区域底
    local bg = ZImage:create(parent, UIResourcePath.FileLocate.common .. "top_button.png", 0, 2, 367, 148, 0, 500, 500)
    -- 头像背景
    MUtils:create_sprite(parent,UIResourcePath.FileLocate.task.."npc2_bg.png",60,50+42);
    local head_path = UIResourcePath.FileLocate.lh_normal .. "head/head"..info.job..info.sex..".png";
    -- 玩家头像
    MUtils:create_sprite(parent,head_path,60,52+42);
    -- 名字
    local use_name = ZTextImage:create(parent, "#cfff000"..info.name, UIResourcePath.FileLocate.common.."test_bg.png", 15, 132, 116, -1, -1, 500, 500)
    --MUtils:create_lab_with_bg(parent,"#cfff000"..info.name,1,16,133,127+10,UIResourcePath.FileLocate.common.."title_bg_01_s.png");
    -- 干活时间
    local work_time = MUtils:create_zxfont(parent,LangGameString[1251],133,82+15,1,15); -- [1251]="干活时间:"
    print("info.catchTime-1",info.catchTime-1)
    self.timer_lab_tab[i] = {};
    local time = info.catchTime - 61;
    if time > 0 then
        self.timer_lab_tab[i].work_time_lab = TimerLabel:create_label(work_time, 75, 0, 15, info.catchTime-61, "#cd5c241", nil,false);
    end
    -- 累积经验
    self.timer_lab_tab[i].exp_lab = MUtils:create_zxfont(parent,LangGameString[1252]..info.curExp,133,58+15,1,16); -- [1252]="累计经验:"
    -- 冷却时间
    MUtils:create_zxfont(parent,LangGameString[1253],133,34+15,1,15); -- [1253]="提取冷却:"

    -- 释放
    local function btn_free_fun( eventType,args,msgid )
        HuanLeDouCC:req_free_kugong( info.id );
    end
    local shifang = ZButton:create(parent, UIResourcePath.FileLocate.huanledou.."shifang.png", btn_free_fun, 80,90, -1, -1)
    --MUtils:create_common_btn( parent,LangGameString[1254],btn_free_fun,105,110 ); -- [1254]="释放"

    -- 提取
    local function btn_tiqu_fun( eventType,args,msgid )
        if eventType == TOUCH_CLICK then
            HuanLeDouCC:req_get_exp( info.id )
        end
        return true;
    end
    MUtils:create_btn_and_lab(parent,UIResourcePath.FileLocate.common.."button2.png",nil,btn_tiqu_fun,30,12,-1,-1,LangGameString[1255],16); -- [1255]="提取"

    -- 压榨
    local function btn_yazha_fun( eventType,args,msgid )
        if eventType == TOUCH_CLICK then
            if ( info.catchTime <= 60 ) then
                GlobalFunc:create_screen_notic( LangGameString[1256] ) -- [1256]="当前没有可以压榨的经验！"
            else
                local function cb()
                    HuanLeDouCC:req_yazha( info.id )
                end
                local function cb2( _is_show_next )
                    is_next_show_yazha_tip = _is_show_next;
                end
                MUtils:create_not_tip_dialog( 5,is_next_show_yazha_tip,cb,cb2,LangGameString[1257] ); -- [1257]="是否确认使用#cfff0005元宝#cffffff压榨仙仆1小时干活经验?"
            end
        end
        return true;
    end
    local yz_btn = MUtils:create_btn_and_lab(parent,UIResourcePath.FileLocate.common.."button2.png",nil,btn_yazha_fun,150,12,-1,-1,LangGameString[1258],16); -- [1258]="压榨"

    -- 抽干
    local function btn_chougan_fun( eventType,args,msgid )
        if eventType == TOUCH_CLICK then
            if ( info.catchTime <= 60 ) then
                GlobalFunc:create_screen_notic( LangGameString[1259] ) -- [1259]="该仆人不能再抽干"
            else
                local function cb()
                    HuanLeDouCC:req_chougan( info.id )
                end
                local function cb2( _is_show_next )
                    is_next_show_chougan_tip = _is_show_next;
                end
                local hour = (info.catchTime-61)/3600;
                local str = string.format( "是否确认使用#cfff000%d元宝#cffffff压榨仙仆剩余的干活经验?",math.ceil(hour)*5 );
                MUtils:create_not_tip_dialog( 120,is_next_show_chougan_tip,cb,cb2,str ); -- [1260]="是否确认使用#cfff000120元宝#cffffff压榨仙仆1小时干活经验?"
            end
        end
        return true;
    end
    local cg_btn = MUtils:create_btn_and_lab(parent,UIResourcePath.FileLocate.common.."button2.png",nil,btn_chougan_fun,260,12,-1,-1,LangGameString[1261],16); -- [1261]="抽干"

    -- if ( info.catchTime <= 60 ) then 
    --     -- yz_btn:setCurState( CLICK_STATE_DISABLE )
    --     -- cg_btn:setCurState( CLICK_STATE_DISABLE )
    -- end

    -- 分隔线
    --local line = MUtils:create_sprite(parent,UIResourcePath.FileLocate.common .. "line.png", 175,165);
    --line:setScaleX(1.4);

    parent:setDataInfo(i);
end

function HLDYaZhaXianPu:active( show )

    if ( show ) then 
        HuanLeDouCC:req_kugong_list()
    else
        self.scroll:clear();
        self.exp_timer:stop();
        self.exp_timer = nil;
    end
end

function HLDYaZhaXianPu:update_scroll( data )
    self.scroll_data = data;
    self.scroll:clear();
    self.scroll:setMaxNum(#self.scroll_data);
    self.scroll:refresh();
    print("HLDYaZhaXianPu:update_scroll",#self.scroll_data)
    self:start_exp_timer()
end

function HLDYaZhaXianPu:start_exp_timer()
    if ( self.exp_timer ) then
        self.exp_timer:stop();
        self.exp_timer = nil;
    end
    local function timer_fun()
        for i,v in ipairs(self.timer_lab_tab) do
            if ( v ) then
                local info = self.scroll_data[i];
                local make_exp = HLDYaZhaXianPu:get_slave_make_exp( info.level );
                -- print("info.baseExp",info.baseExp);
                info.curExp = info.curExp + make_exp;
                v.exp_lab:setText(LangGameString[1252]..info.curExp); -- [1252]="累计经验:"
            end
        end
    end
    self.exp_timer = timer();
    self.exp_timer:start( 10,timer_fun );
end

function HLDYaZhaXianPu:get_slave_make_exp( slave_lv )
    local exp = 0;
    for i,v in ipairs(HuanLeDouModel.slaveMakeExp) do
        if slave_lv >= v[1] and slave_lv <= v[2] then
            exp = math.floor((400*slave_lv *slave_lv + slave_lv*200+1000000)*v[3]*10)
            print("苦工每秒创造exp = ",exp)
            return exp;
        end
    end
end