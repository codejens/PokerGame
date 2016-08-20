-- DialogManager.lua
-- created by hcl on 2013/3/14
-- 用于创建多个对话框,有些对话框会同时存在多个


-- 更好的道具，金元宝，开启必杀技3个对话框大小 330,230 
-- 3件极品套装的提示框 350,320

require "UI/component/Window"
require "utils/MUtils"
super_class.DialogManager(Window)

DialogManager.DIALOG_BETTER_ITEM = 1;
DialogManager.DIALOG_JIN_YUANBAO = 2;
DialogManager.DIALOG_BISHAJI = 3;

-- 记录当前显示的对话框数量

function DialogManager:show(use_item , type )

    local user_equip_prompt_win = UIManager:find_visible_window("user_equip_win") 
    if user_equip_prompt_win then 
        return 
    end 
    
    -- 创建通用购买面板
    local win = UIManager:show_window("dialog_manager");
    if ( win.dialog_num ) then 
        win.dialog_num = win.dialog_num + 1;
    else
        win.dialog_num = 1;
    end
    win:init_with_arg(use_item, type);
end

-- 
function DialogManager:__init(window_name, texture_name, is_grid, width, height,title_text)
    local bg = ZImage:create( self.view, UILH_COMMON.dialog_bg, 0, 0, width, height - 25, -1,500,500 )

    --标题背景
    local title_bg = ZImage:create( self.view,UILH_COMMON.title_bg, 0, 0, -1, -1 )
    local title_bg_size = title_bg:getSize()
    title_bg:setPosition( ( width - title_bg_size.width ) / 2, height - title_bg_size.height-10 )

    local t_width = title_bg:getSize().width
    local t_height = title_bg:getSize().height
    self.window_title = ZImage:create(title_bg, title_text , t_width/2,  t_height-27, -1,-1,999 );
    self.window_title.view:setAnchorPoint(0.5,0.5)

    --关闭按钮
    local _exit_btn_info = { img = UILH_COMMON.close_btn_z, z = 1000, width = 60, height = 60 }
    local function _close_btn_fun()
        Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
        UIManager:hide_window(window_name)
    end
    self._exit_btn = ZButton:create(self.view, _exit_btn_info.img, _close_btn_fun,0,0,_exit_btn_info.width,_exit_btn_info.height,_exit_btn_info.z);
    local exit_btn_size = self._exit_btn:getSize()
    self._exit_btn:setPosition( width - exit_btn_size.width+11 , height - exit_btn_size.height-20)
end

function DialogManager:setExitBtnFun(tFun)
    self._exit_btn:setTouchClickFun(tFun)
end

local bangding_yuanbao = { [18212] = 50,[18213] = 50,[18214] = 100,
                [18215] = 100,[18216] = 200,[18217] = 250,[18218] = 300};
-- 根据参数初始化
function DialogManager:init_with_arg(use_item ,type )
    local spr_bg = CCBasePanel:panelWithFile    ( 0, 0, 420, 331, nil);

    local bgPanel = CCBasePanel:panelWithFile( 18, 71, 380, 200, UILH_COMMON.bottom_bg, 500, 500 )
    spr_bg:addChild( bgPanel )

    -- local bgPanel = CCBasePanel:panelWithFile( 28, 82, 360, 180, "", 500, 500 )
    -- spr_bg:addChild( bgPanel )
    
    local function panel_fun( eventType,args,msg_id )
        if ( eventType == TOUCH_BEGAN) then
            return true;
        elseif ( eventType == TOUCH_CLICK ) then
            -- print("panel_fun...................................TOUCH_CLICK")
            spr_bg:removeFromParentAndCleanup(true);
            self.dialog_num = self.dialog_num -1;
            if ( self.dialog_num == 0 ) then
                UIManager:hide_window("dialog_manager");
            end
            if ( type ~= DialogManager.DIALOG_BISHAJI ) then
                -- 装备
                ItemModel:use_one_item( use_item );
            else
                LuaEffectManager:play_bishaji_create_effect()
            end
            DialogManager:on_dialog_close( type )
            Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
            return true;
        end
    end
    spr_bg:registerScriptHandler( panel_fun );

    self.view:addChild( spr_bg,self.dialog_num );
    -- 标题背景
    -- MUtils:create_sprite(spr_bg,UIResourcePath.FileLocate.common .. "title_bg_b.png",165 ,215 );
    -- local title = MUtils:create_sprite(spr_bg,UIResourcePath.FileLocate.common .. "title_tips.png",210 ,302 );
    -- title:setAnchorPoint(CCPointMake(0.5, 0.5))

    if ( type ~= DialogManager.DIALOG_BISHAJI ) then 
        -- 关闭按钮
        local function btn_close_fun(eventType,x,y)
            -- if eventType == TOUCH_BEGAN then
            --     return true;
            -- elseif eventType == TOUCH_CLICK then
                spr_bg:removeFromParentAndCleanup(true);
                self.dialog_num = self.dialog_num -1;
                if ( self.dialog_num == 0 ) then
                    UIManager:hide_window("dialog_manager");
                end
                DialogManager:on_dialog_close( type )
                -- return true;
            -- elseif eventType == TOUCH_ENDED then
                -- return true;
            -- end
        end
        self:setExitBtnFun(btn_close_fun)
        -- local exit_btn = MUtils:create_btn(spr_bg,UIResourcePath.FileLocate.common .. "close_btn_z.png",UIResourcePath.FileLocate.common .. "close_btn_z.png",btn_close_fun,0,0,60,60);
        -- local exit_btn_size = exit_btn:getSize()
        -- local spr_bg_size = spr_bg:getSize()
        -- exit_btn:setPosition(363,278)

        -- 道具icon
        local function show_item_tip( )
            TipsModel:show_tip(400,240,use_item);
        end

        self.item_icon =  MUtils:create_slot_item(spr_bg,UIPIC_ITEMSLOT,134+30+8,105+25,72,72,use_item.item_id, show_item_tip);

    else
        local anger_bg = MUtils:create_sprite(spr_bg,UILH_MAIN.m_anger_bg,420/2,100+25);
        anger_bg:setAnchorPoint(CCPoint(0,0));
        local anger_spr = MUtils:create_sprite( anger_bg ,UILH_MAIN.m_anger,96.5,12);
        anger_spr:setAnchorPoint(CCPoint(0.5,0));
        -- 播放燃烧的特效
        LuaEffectManager:play_view_effect( 10011,40,41,anger_spr ,true);
    end
    -- 
    local function btn_ok_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_CLICK then
            -- print("btn_ok_fun.....................................TOUCH_CLICK")
            spr_bg:removeFromParentAndCleanup(true);
            self.dialog_num = self.dialog_num -1;
            if ( self.dialog_num == 0 ) then
                UIManager:hide_window("dialog_manager");
            end
            if ( type ~= DialogManager.DIALOG_BISHAJI ) then
                -- 装备
                ItemModel:use_one_item( use_item );
            else
                LuaEffectManager:play_bishaji_create_effect()
            end
            DialogManager:on_dialog_close( type )

            Instruction:handleUIComponentClick(instruct_comps.DIALOG_USE_OPEN)
            return true;
        end
    end
    if ( type ~= DialogManager.DIALOG_BISHAJI ) then
        -- 道具名字标题
        -- MUtils:create_sprite(spr_bg,UIResourcePath.FileLocate.common .. "tishi_test_bg.png",420/2,90+25)
        --放右边
        --self.view:setPosition(270,160);
    else
        --放中间
        --self.view:setPosition(270,160);
    end

	-- 标题
    --xiehande 通用按钮修改 btn_lv->button3
	if ( type == DialogManager.DIALOG_BETTER_ITEM ) then
        MUtils:create_zxfont(spr_bg,LangGameString[811],420/2,170+40,2,16); -- [811]="#cfff000获得更好的装备"
        MUtils:create_zxfont(spr_bg,self:get_item_name(use_item.item_id),420/2,80+25,2,16);
        local btn1 = MUtils:create_btn(spr_bg,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_nor,btn_ok_fun,142,17,-1,-1,1);
        -- MUtils:create_sprite(btn1,UIResourcePath.FileLocate.other .. "dialog_t_1.png",65.5 ,21 );
        MUtils:create_zxfont(btn1, "立即穿戴", 126/2,15+5,2,16)
    elseif ( type == DialogManager.DIALOG_JIN_YUANBAO ) then
        MUtils:create_zxfont(spr_bg,LangGameString[812]..bangding_yuanbao[use_item.item_id]..LangGameString[413],420/2,170+40,2,16); -- [812]="#cfff000使用后获得" -- [413]="礼券"
        MUtils:create_zxfont(spr_bg,self:get_item_name(use_item.item_id),420/2,80+25,2,16);
        local btn1 = MUtils:create_btn(spr_bg,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_nor,btn_ok_fun,142,17,126,43,1);
        -- MUtils:create_sprite(btn1,UIResourcePath.FileLocate.other .. "dialog_t_2.png",65.5 ,21 );
        MUtils:create_zxfont(btn1, "打开礼包", 126/2,15,2,16)
    elseif ( type == DialogManager.DIALOG_BISHAJI ) then
        MUtils:create_zxfont(spr_bg,LangGameString[813],420/2,170+40,2,16); -- [813]="#cfff000恭喜你学会必杀技"
        MUtils:create_zxfont(spr_bg,LangGameString[814],420/2,80+25,2,16); -- [814]="#cfff000怒气燃烧,全屏必杀"
        local btn1 = MUtils:create_btn(spr_bg,UILH_COMMON.btn4_nor,UILH_COMMON.btn4_nor,btn_ok_fun,142,17,126,43,1);
        -- MUtils:create_sprite(btn1,UIResourcePath.FileLocate.other .. "dialog_t_3.png",65.5 ,21 );
        MUtils:create_zxfont(btn1, "开启必杀技", 126/2,15,2,16)
    end

    -- self:on_xszy(type,use_item,spr_bg)
end

-- 取得item的名字
function DialogManager:get_item_name(item_id)

    local item = ItemConfig:get_item_by_id( item_id )     --获取item基本信息
    local color_str = _static_quantity_color[ item.color + 1 ]
    local item_name = color_str .. item.name;
    return item_name;

end

-- 判断是否需要新手指引
function DialogManager:on_xszy(type,use_item,spr_bg)

    -- -- 新手指引状态1是 装备指引任务
    if ( Instruction:get_state() == XSZYConfig.ZHUANG_BEI_ZY and type == DialogManager.DIALOG_BETTER_ITEM) then
        Instruction:play_jt_animation(412, 171, 120, 53, 2, 5, "nopack/ani_xszy.png", "nopack/xszy/5.png")
        LuaEffectManager:play_view_effect(418, 202, 44, self.view, true, 9999)
        -- local tag = XSZYConfig.BETTER_SELECT_TAG;
        -- if ( type == DialogManager.DIALOG_JIN_YUANBAO ) then
        --     tag = XSZYConfig.JINYUANBAO_SELECT_TAG;
        -- end
        --XSZYManager:play_jt_and_kuang_animation_by_id(XSZYConfig.ZHUANG_BEI_ZY,1,tag);
        -- local function cb()
        --     spr_bg:removeFromParentAndCleanup(true);
        --     self.dialog_num = self.dialog_num -1;
        --     if ( self.dialog_num == 0 ) then
        --         UIManager:hide_window("dialog_manager");
        --     end
        --     -- 装备
        --     ItemModel:use_one_item( use_item );
        --     self:on_dialog_close( type )
        -- end
        -- XSZYManager:lock_screen_by_id( XSZYConfig.ZHUANG_BEI_ZY, 1, cb )
    -- elseif XSZYManager:get_state() == XSZYConfig.BISHAJI_ZY then      
    --     XSZYManager:play_jt_and_kuang_animation_by_id(XSZYConfig.BISHAJI_ZY,1, XSZYConfig.OTHER_SELECT_TAG);
    end
end

function DialogManager:on_dialog_close( type )
    --[[if ( XSZYManager:get_state() == XSZYConfig.ZHUANG_BEI_ZY or XSZYManager:get_state() == XSZYConfig.BISHAJI_ZY ) then
        local tag = nil;
        if ( type == 1  ) then
            tag = XSZYConfig.BETTER_SELECT_TAG;
        elseif ( type == 2 ) then
            tag = XSZYConfig.JINYUANBAO_SELECT_TAG;
        elseif ( type == 3 ) then
            tag = XSZYConfig.OTHER_SELECT_TAG;
        end
        if ( XSZYManager:get_state() == XSZYConfig.BISHAJI_ZY ) then
            -- 清除新手引导的东西
            XSZYManager:destroy_jt( tag );
  
        elseif ( XSZYManager:get_state() == XSZYConfig.ZHUANG_BEI_ZY  ) then
            -- XSZYManager:unlock_screen();
            AIManager:do_quest( TaskModel:get_zhuxian_quest() );
            -- 清除新手引导的东西
            XSZYManager:destroy( tag );
        else
            AIManager:do_quest( TaskModel:get_zhuxian_quest() );
            -- 清除新手引导的东西
            XSZYManager:destroy( tag );
        end
    end--]]
end

function DialogManager:destroy()
    if Instruction:get_state() == XSZYConfig.ZHUANG_BEI_ZY then
        LuaEffectManager:stop_view_effect(418, self.view)
        Instruction:clear_jt_animation()
        Instruction:set_state(XSZYConfig.NONE)
    end
    self.dialog_num = nil;
    Window.destroy(self);
end
