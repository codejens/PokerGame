-- UseItemDialog.lua
-- created by hcl on 2013/1/7
-- 通用的消耗道具提示框

require "UI/component/Window"
require "utils/MUtils"
super_class.UseItemDialog(Window)

local _cb_fun = nil;

local panel = nil; 

local update_view = {};

local item_num = -1;

local _item_id = nil;


function UseItemDialog:show(item_id,cb_fun,type,title_str,title_path)
    -- 创建通用购买面板
    local win = UIManager:show_window("use_item_dialog",true);
    win:init_with_arg(item_id,type,title_str);
    win:reset_title(title_path)
    _cb_fun = cb_fun;
    _item_id = item_id;
end

-- function UseItemDialog:create(texture_name)
--     --return BuyKeyboardWin("ui/common/bg01.png",152,114,529,269);
--     return UseItemDialog(nil,235,127,330,226);
-- end

-- 
function UseItemDialog:__init(window_name, texture_name)
	panel = self.view;

    -- local bg = CCBasePanel:panelWithFile(1,1,414,329, UILH_COMMON.bg_03, 500, 500)
    -- self.view:addChild(bg,-1)

    local bg_1 = CCBasePanel:panelWithFile(13, 71, 390, 205,UILH_COMMON.bottom_bg, 500, 500)
    panel:addChild(bg_1)

    -- 标题背景
    local bg_size = self.view:getSize()
    self.title_bg = ZImage:create( self.view, UILH_COMMON.title_bg, 0, 0, -1, -1 )
    local title_bg_size = self.title_bg:getSize()
    self.title_bg:setPosition( ( bg_size.width - title_bg_size.width ) / 2, 294 )
    self.title = CCZXImage:imageWithFile(0, 0, -1, -1,UILH_NORMAL.title_tips)
    self.title_bg:addChild(self.title)
    local title_size = self.title:getSize()
    self.title:setPosition(title_bg_size.width/2-title_size.width/2,title_bg_size.height/2-title_size.height/2 )

    -- 道具icon背景
    self.item_icon =  MUtils:create_slot_item2(panel,UIPIC_ITEMSLOT,51,124,64,64,nil,nil,9.5);
    -- self.item_icon:set_icon_bg_texture( UIPIC_ITEMSLOT, -4, -4, 72,72)

    update_view[1] = MUtils:create_zxfont(panel,LangGameString[842],416/2,226,2,16); -- [842]="#cfff000你确定遗忘宠物名字的技能吗"
    update_view[2] = MUtils:create_ccdialogEx(panel,LangGameString[843],139,131,220,50,10,16); -- [843]="#c66ff66消耗10元宝使用遗忘之水封印宠物技能"
    --update_view[2]:setAnchorPoint(0.5,1.0);
   -- update_view[3] = MUtils:create_label(panel,"技能遗忘后将永久消失，请谨慎操作","Arial",13,165,60,ccc3(255,0,0));

    -- 
    local function btn_ok_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
     		UIManager:hide_window("use_item_dialog");
            if ( item_num ~= 0) then
         		if ( _cb_fun ) then
         			_cb_fun(_item_id);
         		end
                -- local callback = function( param )
                --     if _cb_fun then
                --         _cb_fun(param[1])
                --     end
                -- end
                -- MallModel:handle_shopping( _item_id, 1, callback, {_item_id} )
            else
                -- if ( PlayerAvatar:check_is_enough_money( 4,self.price ) ) then
                    BuyKeyboardWin:send_buy_item_and_use( _item_id , _cb_fun,self.price )
                -- end
            end
        end
        return true
    end
    local btn1 = MUtils:create_btn(panel,UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s,btn_ok_fun,55,10,-1,-1);
    MUtils:create_zxfont(btn1, Lang.common.confirm[0], 99/2, 20, 2, 16)    -- Lang.common.confirm[0] = 确定

    local function btn_cancel_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	UIManager:hide_window("use_item_dialog");
        end
        return true
    end
    local btn2 = MUtils:create_btn(panel,UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s,btn_cancel_fun,262,10,-1,-1);
 	MUtils:create_zxfont(btn2, Lang.common.confirm[9], 99/2, 20, 2, 16)  -- Lang.common.confirm[9] = 取消

    -- title
    -- self.window_title = CCZXImage:imageWithFile( 0, 0, -1, -1, UIPIC_ConfirmWin_007);
    -- self.window_title:setAnchorPoint( 0.5, 0 )
    -- local window_size = self.view:getSize();
    -- self.window_title:setPosition( window_size.width / 2, window_size.height - 37 );
    -- self:addChild( self.window_title )
end

function UseItemDialog:init_with_arg(item_id,type,title_str)
    
    item_num = ItemModel:get_item_count_by_id( item_id );
    if ( item_id ) then 
        self.item_icon:update( item_id ,item_num);
    end
	
    -- if ( self.title ) then
    --     self.title:removeFromParentAndCleanup(true);
    -- end
	-- 标题
	--self.title = MUtils:create_sprite(panel,UIResourcePath.FileLocate.pet .. "pet_t_d".. type..".png",165 ,218 );
	update_view[1]:setText( title_str);
    update_view[2]:setText("");
	update_view[2]:setText(self:get_item_name_and_price_string(item_id,item_num,type));

end


function UseItemDialog:get_item_name_and_price_string(item_id,item_num,type)
    local money_name = Lang.dialog[2] --元宝
    self.price = 0
    local store_item = StoreConfig:get_store_info_by_id( item_id )
    if store_item then
        self.price = store_item.price[1].price
        money_name = _static_money_type[store_item.price[1].type]
    end

    local item = ItemConfig:get_item_by_id( item_id )     --获取item基本信息
    local item_name = item.name;

    local str = "";
    if ( item_num == 0 ) then
        str = Lang.dialog[1]..self.price..money_name .. Lang.dialog[3] ..item_name; -- [844]="#c66ff66消耗" -- [845]="元宝使用"
    else
        str = "#cd0cda2"..item_name.."\n"..Lang.dialog[4]..self.price..money_name; -- [846]="单价:" -- [414]="元宝"
    end

    return str;
end

function UseItemDialog:active(show)
    if self.exit_btn then
        self.exit_btn:setPosition(363,278)
    end 
end

function UseItemDialog:reset_title(title_path)
    if title_path then
        if self.title then
            self.title:removeFromParentAndCleanup(true);
            self.title = nil;
        end

        self.title = CCZXImage:imageWithFile(0, 0, -1, -1,title_path)
        self.title_bg:addChild(self.title)
        local title_size = self.title:getSize()
        local title_bg_size = self.title_bg:getSize()
        self.title:setPosition(title_bg_size.width/2-title_size.width/2,title_bg_size.height/2-title_size.height/2 )
    end
end