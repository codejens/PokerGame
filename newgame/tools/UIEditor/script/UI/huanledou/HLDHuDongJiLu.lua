-- HLDHuDongJiLu.lua
-- created by hcl on 2013-9-25
-- 互动记录

super_class.HLDHuDongJiLu(Window)

-- 初始化
function HLDHuDongJiLu:__init( )

    -- 创建滑动条
    MUtils:create_zximg(self.view,UIPIC_GRID_nine_grid_bg3,12,12,366,378,500,500);
    self:create_scroll_view();
end


function HLDHuDongJiLu:create_scroll_view()
    local _scroll_info = { x = 16 , y = 20 , width = 356, height = 358, maxnum = 0, stype = TYPE_HORIZONTAL }
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
            local panel = CCBasePanel:panelWithFile(0,0 ,310,93,"", 600, 600);
            self:create_scroll_item( panel,row )
            self.scroll:addItem(panel);
            self.scroll:refresh();
            return false
        end
    end
    self.scroll:registerScriptHandler(scrollfun);
    self.scroll:refresh() 
end

function HLDHuDongJiLu:create_scroll_item( parent,i )
    local info = self.scroll_data[#self.scroll_data-i+1];
    local str = HLDHuDongJiLu:parse_str( info );
    local ccdialog = MUtils:create_ccdialogEx(parent,str,15,0,320,0,255,16);
    -- ccdialog:setAnchorPoint(0,1);
    local dialog_text_size = ccdialog:getInfoSize()
    -- dialog:setSize(dialog_text_size.width, dialog_text_size.height)
    -- 分隔线
    local line = MUtils:create_sprite(parent,UIResourcePath.FileLocate.common .. "fenge_bg.png", 25,dialog_text_size.height+8);
    line:setScaleX(20);
    parent:setSize(344,dialog_text_size.height+16);
end

function HLDHuDongJiLu:parse_str( msg_info )
    local msg_str_tab = HuanLeDouModel.MSG_STR[ msg_info.msg_id ];
    local base_str = msg_str_tab[1];
    for i=1,#msg_str_tab-1 do
        local rep_str = "#cd5c241"..msg_info.target_info_table[ msg_str_tab[i+1] ].name.."#c33a6ee";
        if i == 1 then 
            base_str = string.gsub(base_str, "xx", rep_str)
        elseif i == 2 then 
            base_str = string.gsub(base_str, "yy", rep_str)
        end
    end
    print("msg_info.msg_id = ",msg_info.msg_id,base_str);
    return base_str;
end

function HLDHuDongJiLu:active( show )
    if ( show ) then 
        HuanLeDouCC:req_msg_info(  )

    else

    end
end

function HLDHuDongJiLu:update_scroll( data )
    self.scroll_data = data;
    self.scroll:clear();
    self.scroll:setMaxNum(#self.scroll_data);
    self.scroll:refresh();
end

