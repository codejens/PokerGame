--SysMsgDialog.lua
--服务器对话框

super_class.SysMsgDialog(Window)

local msg_data  = nil
local msg_timer = nil

function SysMsgDialog:show_dialog(data)
	msg_data = data
	UIManager:show_window("sysmsg_dialog")
end

function SysMsgDialog:destory_dialog()
    if msg_timer then 
        msg_timer:stop()
        msg_timer = nil
    end
    msg_data = nil
    UIManager:destroy_window("sysmsg_dialog")
end

function SysMsgDialog:__init()
    local view_size = self.view:getContentSize()
	local dialog_bg = CCBasePanel:panelWithFile(view_size.width/2, view_size.height*0.528, 438, 270, "sui/common/tipsPanel.png", 500, 500)
    dialog_bg:setAnchorPoint(0.5, 0.5)
    dialog_bg:setDefaultMessageReturn(true)
    self.view:addChild(dialog_bg)

    local title_bg = CCBasePanel:panelWithFile(219, 272, 484, -1, "sui/common/little_win_title_bg.png", 500, 500)
    title_bg:setAnchorPoint(0.5, 1)
    dialog_bg:addChild(title_bg, 1)

    local title_bg1 = CCBasePanel:panelWithFile(219, 264, 444, -1, "sui/common/title_panel.png", 500, 500)
    title_bg1:setAnchorPoint(0.5, 1)
    dialog_bg:addChild(title_bg1)

    ZLabel:create(title_bg1, "#cf3e2c5提示", 222, 12, 26, ALIGN_CENTER)

    local down_bg = CCBasePanel:panelWithFile(219, 0, 458, -1, "sui/common/win_down.png", 500, 500)
    down_bg:setAnchorPoint(0.5, 0)
    dialog_bg:addChild(down_bg, 1)

    if msg_data.has_close_btn == 1 then
        local function close_func()
            self:destory_dialog()
            SoundManager:play_ui_effect( 3 )
        end
        ZTextButton:create(dialog_bg, "", "sui/common/close.png", close_func, 370, 204, -1, -1, 99)
    end

    local text_label = SLabel:quick_create("#c4d2308"..msg_data.text, 219, 133, dialog_bg, 1, 18, ALIGN_CENTER)
    local label_size = text_label:getSize()
    if label_size.width > 360 then
        text_label:removeFromParentAndCleanup(true)
        local text_dialog = MUtils:create_ccdialogEx(dialog_bg, "#c4d2308"..msg_data.text, 219, 142, 360, 18, 60, 18)
        text_dialog:setAnchorPoint(0.5, 0.5)
    end

    local btn_count = #msg_data.btn_text_dict
    btn_count = btn_count > 2 and 2 or btn_count
    self.text_btn       = {}
    self.text_btn_lable = {}
    for i=1,btn_count do
        local function btn_call_func()
            if msg_data.npc_handle and msg_data.message_id and msg_data.unkown and msg_data.unkown ~= -1 then
                FubenCenterModel:req_message_dialog(msg_data.npc_handle, i-1, msg_data.message_id)
            end
            self:destory_dialog()
        end
        if msg_data.func_table and msg_data.func_table[i] then
            btn_call_func = msg_data.func_table[i]
        end
        local pos_x = 103
        if btn_count == 1 then
            pos_x = 219
        end
        pos_x = pos_x+(i-1)*232
        local btn = ZTextButton:create(dialog_bg, msg_data.btn_text_dict[i], "sui/common/btn_1.png", btn_call_func, pos_x, 22, -1, -1, 10+i)
        btn:setAnchorPoint(0.5, 0)
        btn:setFontSize(24)
        self.text_btn[i]       = btn
        self.text_btn_lable[i] = msg_data.btn_text_dict[i]
    end

    if msg_data and msg_data.alive_time and msg_data.alive_time > 0 then
        if not msg_timer then
            msg_timer = timer()
        end
        msg_timer:stop()
        local time_count = msg_data.alive_time
        if msg_data.unkown and msg_data.unkown ~= -1 and self.text_btn[msg_data.unkown+1] then
            self.text_btn[msg_data.unkown+1]:setText(self.text_btn_lable[msg_data.unkown+1].."("..time_count..")")
        end
        local function timer_call_func()
            time_count = time_count -1
            if msg_data.unkown and msg_data.unkown ~= -1 and self.text_btn[msg_data.unkown+1] then
                self.text_btn[msg_data.unkown+1]:setText(self.text_btn_lable[msg_data.unkown+1].."("..time_count..")")
            end
            if time_count <= 0 then
                if msg_data.npc_handle and msg_data.message_id and msg_data.unkown and msg_data.unkown ~= -1 then
                    if msg_data.func_table and msg_data.func_table[msg_data.unkown+1] then
                        msg_data.func_table[msg_data.unkown+1]()
                    else
                        FubenCenterModel:req_message_dialog(msg_data.npc_handle, msg_data.unkown, msg_data.message_id)
                    end
                end
                self:destory_dialog()
            end
        end
        msg_timer:start(1, timer_call_func)
    end
end