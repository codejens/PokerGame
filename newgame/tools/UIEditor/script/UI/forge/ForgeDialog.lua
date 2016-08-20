-- ForgeDialog.lua
-- created by liangyongrui on 2014-5-22
-- 获得材料窗口

-- 使用方法：静态调用 ForgeDialog:show(  )

super_class.ForgeDialog(  )

local _ui_width = GameScreenConfig.ui_screen_width 
local _ui_height = GameScreenConfig.ui_screen_height

local _win_width  = 416
local _win_height = 331

local _title_image_t = {
    [1] = { path = UIResourcePath.FileLocate.forge .. "lq_clhd.png", x = 10, y = 0 }, -- 材料获得
    [2] = { path = UIResourcePath.FileLocate.forge .. "lq_clhd.png", x = 10, y = 0 }, -- 材料获得
    [3] = { path = UIResourcePath.FileLocate.forge .. "lq_clhd.png", x = 10, y = 0 }, -- 材料获得
    [4] = { path = UIResourcePath.FileLocate.forge .. "lq_clzy.png", x = 10, y = 0 }, -- 材料注入
    [5] = { path = UIResourcePath.FileLocate.forge .. "lq_clhd.png", x = 10, y = 0 }, -- 材料获得
    [6] = { path = UIResourcePath.FileLocate.forge .. "lq_clhd.png", x = 10, y = 0 }, -- 材料获得
}

local _button_name_t = {
    [1] = { LangGameString[2408], LangGameString[2408], },  -- 前往
    [2] = { LangGameString[2408], LangGameString[2408], },
    [3] = { LangGameString[2408], LangGameString[2408], },
    [4] = {},
    [5] = { LangGameString[2408], LangGameString[2408], },
    [6] = { LangGameString[2408], LangGameString[2408], },
}

local _content_t = {
    [1] = {
        [1] = LangGameString[2389],  -- "#cffff00梦境探宝可获得大量宝石材料"
        [2] = LangGameString[2390],  -- "#cffff00保卫木叶副本可获得少量宝石材料"
    },
    [2] = {
        [18800] = {  -- 天劫石
            [1] = LangGameString[2391],  -- "#cffff00梦境探宝可获得大量升级材料",
            [2] = LangGameString[2392],  -- "#cffff00历练副本获得大量历练，可兑换天劫石",
        },
        [18801] = { -- 补天石
            [1] = LangGameString[2393],  -- "#cffff00梦境探宝可获得大量升级材料",
            [2] = LangGameString[2394],  -- "#cffff00兑换足够天劫石，可合成补天石",
        },
        [18810] = { -- 星幻玉
            [1] = LangGameString[2395],  -- "#cffff00心魔幻境副本可获得大量防具升级材料",
        },
        [18811] = { -- 轮回玉
            [1] = LangGameString[2396],  -- "#cffff00心魔幻境副本获得的低级材料，可合成轮回玉",
        },
    },
    [3] = {
        [18750] = { -- 紫薇极玉
            [1] = LangGameString[2397],  -- "#cffff00击杀世界boss可获得稀有升阶材料",
        },
        [18830] = { -- 龙纹赤金
            [1] = LangGameString[2398],  -- "#cffff00敬请期待",
        },
    },
    [4] = {
        [1] = LangGameString[2384],  -- "#cfff000注入背包所有的附灵材料："
        [2] = LangGameString[2385],  -- "#cfff000注入背包所有的火之精："
        [3] = LangGameString[2386],  -- "#cfff000注入背包所有的风之精："
        [4] = LangGameString[2387],  -- "#cfff000注入背包所有的山之精："
        [5] = LangGameString[2388],  -- "#cfff000注入背包所有的林之精："
    },
    [5] = {
        [18730] = { -- 焚离珠
            [1] = LangGameString[2399],  -- "cfff000通过完成死亡森林的任务可以获得"
        },
        [18740] = { -- 幽煌珠
            [1] = LangGameString[2399],  -- "cfff000通过完成死亡森林的任务可以获得"
        }
    },
    [6] = {
        [1] = LangGameString[2452],  -- "超俊魂淡，查克拉怎么获得"
    },
}

-- 去梦境
function to_dreamland(  )
    ForgeDialog:close_win(  )
    if GameSysModel:isSysEnabled( GameSysModel.LOTTERY, true ) then
        UIManager:show_window("new_dreamland_win")
    end
end

-- 去兑换
function to_exchange_win(  )
    ForgeDialog:close_win()
    if GameSysModel:isSysEnabled( GameSysModel.EXCHANGE, true ) then
        UIManager:show_window("exchange_win")
    end
end

-- 去保卫木叶副本
function to_fuben_1(  )
    ForgeDialog:close_win(  )
    if GameSysModel:isSysEnabled( GameSysModel.DAILY_ACTIVITY, true ) then
        local win = UIManager:show_window("activity_Win")
        if win then
            win:change_page(2)
            win:update_win("change_page", 7)
        end 
    end
end

-- 去历练副本
function to_fuben_2(  )
    ForgeDialog:close_win()
    if GameSysModel:isSysEnabled( GameSysModel.DAILY_ACTIVITY, true ) then
        ActivityWin:win_change_page(1)
    end
end

-- 去心魔幻境副本
function to_fuben_3(  )
    ForgeDialog:close_win()
    if GameSysModel:isSysEnabled( GameSysModel.DAILY_ACTIVITY, true ) then
        ActivityWin:win_change_page(1)
    end
end

-- 去boss副本
function to_boss_fuben(  )
    ForgeDialog:close_win()
    if GameSysModel:isSysEnabled( GameSysModel.DAILY_ACTIVITY, true ) then
        ActivityWin:win_change_page(1)
    end
end

-- 去仙道会
function to_xiandaohui(  )
    ForgeDialog:close_win()
    UIManager:show_window("xiandaohui_win")
end

-- 去死亡森林
function to_dead_forest(  )
    ForgeDialog:close_win()
    if GameSysModel:isSysEnabled( GameSysModel.DAILY_ACTIVITY, true ) then
        ActivityWin:win_change_page(3)
    end
end

-- 去仙术修炼
function to_lingqilingqu( )
    ForgeDialog:close_win()
    local win = UIManager:show_window("benefit_win")
    if win then
        win:change_page(4)
    end
end

local _handler_t = {
    [1] = {
        [1] = to_dreamland,
        [2] = to_fuben_1,
    },
    [2] = {
        [18800] = {
            [1] = to_dreamland,
            [2] = to_fuben_2,
        },
        [18801] = {
            [1] = to_dreamland,
            [2] = to_exchange_win,
        },
        [18810] = {
            [1] = to_fuben_3,
        },
        [18811] = {
            [1] = to_fuben_3,
        },
    },
    [3] = {
        [18750] = {
            [1] = to_boss_fuben,
            -- [2] = to_xiandaohui,
        },
        [18830] = {
            -- [1] = to_xiandaohui,
        },
    },
    [4] = {
    },
    [5] = {
        [18730] = {
            [1] = to_dead_forest,
        },
        [18740] = {
            [1] = to_dead_forest,
        },
    },
    [6] = {
        [1] = to_lingqilingqu,
    },
}

-- typeee: 1.宝石材料获得
-- typeee: 2.升级材料获得
-- typeee: 3.升阶材料获得
-- typeee: 4.注入材料
-- typeee: 5.提品材料获得
-- typeee: 6.查克拉获得


-- win_type：typeeee
-- meta_id: 所需材料的id (类型1, 2, 3用到)
function ForgeDialog:show( win_type, meta_id )
    
    local ForgeDialog_temp = ForgeDialog( _ui_width/2 , _ui_height/2, win_type, meta_id )

    AlertWin:show_new_alert( ForgeDialog_temp.view )   -- 显示到alertwin， 点击其他地方可以关闭

    return ForgeDialog_temp
end

function ForgeDialog:__init( x, y, typeee, meta_id )
    self.typeee = typeee
    -- self.equip_type = equip_type
    -- self.equip_level = equip_level
    self.meta_id = meta_id

    -- 窗口背景
    self.view = CCBasePanel:panelWithFile( x, y, _win_width, _win_height, UIPIC_ConfirmWin_001, 500, 500 )
    self.view:setAnchorPoint(0.5, 0.5)
    local bg = CCBasePanel:panelWithFile( 18, 71, 380, 200, UIPIC_GRID_nine_grid_bg3, 500, 500 )
    self.view:addChild(bg)

    -- 标头
    self:create_title(  )

    -- 提示内容
    self:create_content(  )

    -- 关闭按钮
    local function close_but_CB( )
        Instruction:handleUIComponentClick(instruct_comps.CLOSE_BTN)
    	self:close_win(  )
    end
    self.close_but = UIButton:create_button_with_name( 0, 0, 60, 60, UIPIC_ConfirmWin_002, UIPIC_ConfirmWin_002, nil, "", close_but_CB )
    local close_but_size = self.close_but.view:getSize()
    local self_size = self.view:getSize()
    self.close_but.view:setPosition(363,278)
    self.view:addChild( self.close_but.view )

    -- 设置不可击穿
    self.view:setDefaultMessageReturn(true)
end

-- 创建标题
function ForgeDialog:create_title(  )
    local title_bg = CCBasePanel:panelWithFile( _win_width / 2 - 48, _win_height - 39, 1, 1, "" )
    local title_info = nil
    if self.typeee and _title_image_t[ self.typeee ] then
        title_info = _title_image_t[ self.typeee ]
    else
        title_info = _title_image_t[ 1 ]
    end

    local title = CCZXImage:imageWithFile( title_info.x, title_info.y, -1, -1, title_info.path  )
    title_bg:addChild( title )
    self.view:addChild( title_bg )
end

-- 显示内容
function ForgeDialog:create_content(  )
    local scroll = nil
    local x = 30
    local y = 36
    local w = 355
    local h = 220
    if self.typeee == 1 then  -- 宝石材料获得
        local contents = _content_t[self.typeee]
        local handlers = _handler_t[self.typeee]
        local btn_text = _button_name_t[self.typeee]
        scroll = self:create_scroll(contents, handlers, btn_text, x, y, w, h, nil)
    elseif self.typeee == 2 then  -- 升级材料获得
        local contents = _content_t[self.typeee][self.meta_id]
        local handlers = _handler_t[self.typeee][self.meta_id]
        local btn_text = _button_name_t[self.typeee]
        scroll = self:create_scroll(contents, handlers, btn_text, x, y, w, h, nil)
    elseif self.typeee == 3 then  -- 升阶材料获得
        local contents = _content_t[self.typeee][self.meta_id]
        local handlers = _handler_t[self.typeee][self.meta_id]
        local btn_text = _button_name_t[self.typeee]
        scroll = self:create_scroll(contents, handlers, btn_text, x, y, w, h, nil)
    elseif self.typeee == 4 then  -- 材料注入
        scroll = self:create_put_meta_panel()
        ForgeModel:set_update_type("forge_dialog")
        ForgeModel:req_get_gem_meta(  )
        self:update(5)
    elseif self.typeee == 5 then  -- 提品材料获得
        local contents = _content_t[self.typeee][self.meta_id]
        local handlers = _handler_t[self.typeee][self.meta_id]
        local btn_text = _button_name_t[self.typeee]
        scroll = self:create_scroll(contents, handlers, btn_text, x, y, w, h, nil)
    elseif self.typeee == 6 then  -- 查克拉获得
        local contents = _content_t[self.typeee]
        local handlers = _handler_t[self.typeee]
        local btn_text = _button_name_t[self.typeee]
        scroll = self:create_scroll(contents, handlers, btn_text, x, y, w, h, nil)
    end
    if scroll then
        self.view:addChild(scroll)
    end
end

function ForgeDialog:create_scroll( contents, handlers, btn_text_t, x, y, w, h, bg )
    if contents == nil then
        return nil
    end

    local row_num = #contents

    local scroll = CCScroll:scrollWithFile( x, y, w, h, row_num, bg, TYPE_HORIZONTAL)

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
            local i = temparg[1]              -- 行
            local index = i
            local row_h = 80
            local row_w = w
            if contents[index + 1] then
                local row = self:create_row( contents[index+1], handlers[index+1], btn_text_t[index+1], 0, 3, row_w, row_h, index+1 )
                local item = CCBasePanel:panelWithFile(0, 0, row_w, row_h + 6, "", 500, 500)
                item:addChild(row)
                scroll:addItem(item)
                scroll:refresh()
            end
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

function ForgeDialog:create_row( content, handler, btn_text, x, y, w, h, i )
    local panel = CCBasePanel:panelWithFile(x, y, w, h, "", 500, 500)

    local notice_dialog = CCDialogEx:dialogWithFile( 15, 64, 230, 45, 50, nil, 1 ,ADD_LIST_DIR_UP)
    notice_dialog:setText( content )
    notice_dialog:setAnchorPoint(0,1)
    panel:addChild( notice_dialog )

    if handler then
        local callback = function(  )
            handler(i)
        end
       --xiehande  通用按钮修改  --btn_lang2.png ->button2.png
        local btn = UIButton:create_button_with_name(246, 20, -1, -1, 
            UIResourcePath.FileLocate.common .. "button2.png",  
            UIResourcePath.FileLocate.common .. "button2.png", 
            nil, "", callback)
        panel:addChild(btn.view)
        local btn_text = UILabel:create_lable_2(btn_text, 96/2, 22, 16, ALIGN_CENTER)
        btn.view:addChild(btn_text)
    end

    return panel
end

local meta_icon_t = {
    [1] = {
        img = UIResourcePath.FileLocate.forge .. "lq_gemmeta_gold.png", -- 攻击材料
        x = 15, y = 92+50
    },
    [2] = {
        img = UIResourcePath.FileLocate.forge .. "lq_gemmeta_water.png", -- 物防材料
        x = 340/2+15, y = 92+50
    },
    [3] = {
        img = UIResourcePath.FileLocate.forge .. "lq_gemmeta_soil.png", -- 法防材料
        x = 15, y = 30+50
    },
    [4] = {
        img = UIResourcePath.FileLocate.forge .. "lq_gemmeta_wood.png", -- 生命材料
        x = 340/2+15, y = 30+50
    },
}

local meta_label_t = {
    [1] = {text = "+0", x = 15+34, y = 95+50},
    [2] = {text = "+0", x = 340/2+15+34, y = 95+50},
    [3] = {text = "+0", x = 15+34, y = 33+50},
    [4] = {text = "+0", x = 340/2+15+34, y = 33+50},
}

local meta_switch_t = {
    [1] = {text = "", x = 340/2-33-5, y = 88+50},
    [2] = {text = "", x = 340-33-5, y = 88+50},
    [3] = {text = "", x = 340/2-33-5, y = 27+50,},
    [4] = {text = "" , x = 340-33-5, y = 27+50},
}

-- 根据附灵材料等级获得多少宝石材料
local meta_lv_t = {6, 24, 96, 384, 1536}

local _switch_btn_t = {}
local _meta_label_t = {}

function ForgeDialog:create_put_meta_panel(  )
    local panel = CCBasePanel:panelWithFile(30, 30, 356, 168+46, nil, 500, 500)
    local bg = CCBasePanel:panelWithFile(28, 82, 360, 180, "", 500, 500)
    self.view:addChild(bg)

    local content = LangGameString[2407]  -- "#cfff000选择注入背包中的所有对应材料："
    local title = ZLabel.new(content)
    title:setPosition(15, 192)
    title:setFontSize(18)
    panel:addChild(title.view)

    for i=1,4 do
        local data = meta_icon_t[i]
        local icon = CCZXImage:imageWithFile(data.x, data.y, 26, 23, data.img)
        panel:addChild(icon)

        data = meta_label_t[i]
        local label = UILabel:create_lable_2(data.text, data.x, data.y, 16, ALIGN_LEFT)
        panel:addChild(label)
        _meta_label_t[i] = label

        data = meta_switch_t[i]
        local switch_btn = UIButton:create_switch_button(data.x, data.y, 40, 40, 
            UIPIC_FORGE_031, 
            UIPIC_FORGE_032, 
            data.text, 36, font_size, nil, nil, nil, nil, 
            auto_buy_fun )
        panel:addChild(switch_btn.view, 2);
        _switch_btn_t[i] = switch_btn
    end

    local put_all_meta = function( )
        Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
        self:close_win()
        local gem_meta_t = ForgeModel:get_put_gem_meta_t(  )
        local x = 0
        for i,v in ipairs(gem_meta_t) do
            x = x + v
        end
        if x > 0 then
            MiscCC:req_put_gem_meta( 15 )
        end
    end
     --xiehande 通用按钮  btn_hong.png ->button3
    local btn_1 = UIButton:create_button_with_name(55, 17, -1, -1, 
            UIResourcePath.FileLocate.common .. "button3.png", 
            UIResourcePath.FileLocate.common .. "button3.png", 
            nil, "", put_all_meta)
    self.view:addChild(btn_1.view)
    local btn_text = UILabel:create_lable_2(LangGameString[2405], 126/2, 22, 16, ALIGN_CENTER)  -- 全部注入
    btn_1.view:addChild(btn_text)

    local put_some_meta = function( )
        Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
        self:close_win()
        local gem_meta_t = ForgeModel:get_put_gem_meta_t(  )
        local x = 0
        local meta_type = 0
        for i,v in ipairs(_switch_btn_t) do
            if v.if_selected then
                x = x + gem_meta_t[i]
                meta_type = meta_type + math.pow(2, i-1)
            end
        end
        if x > 0 then
            -- print("========x, meta_type: ", x, meta_type)
            MiscCC:req_put_gem_meta( meta_type )
        end
    end
     --xiehande 通用按钮  btn_hong.png ->button3
    local btn_2 = UIButton:create_button_with_name(230, 17, -1, -1, 
            UIResourcePath.FileLocate.common .. "button3.png", 
            UIResourcePath.FileLocate.common .. "button3.png", 
            nil, "", put_some_meta)
    self.view:addChild(btn_2.view)
    local btn_text = UILabel:create_lable_2(LangGameString[2406], 126/2, 22, 16, ALIGN_CENTER)  -- 注入材料
    btn_2.view:addChild(btn_text)

    return panel
end

-- 关闭窗口
function ForgeDialog:close_win(  )
    AlertWin:close_alert(  )
end

function ForgeDialog:update(update_type)
    if update_type == 5 then
        local gem_meta_t = ForgeModel:get_put_gem_meta_t(  )
        if gem_meta_t == nil then
            return
        end
        for i,v in ipairs(_meta_label_t) do
            v:setString("+" .. gem_meta_t[i])
        end
    end
end

function ForgeDialog:get_meta_icon_path( meta_type )
    if meta_icon_t[meta_type] then
        return meta_icon_t[meta_type].img
    end
    return nil
end