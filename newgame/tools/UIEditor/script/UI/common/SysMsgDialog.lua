-- SysMsgDialog.lua
-- created by fjh on 2013-3-12
-- 通用服务器下发对话框

super_class.SysMsgDialog(Window)

function SysMsgDialog:show_dialog( data )
    
	self.data = data;
    
	UIManager:show_window("sysmsg_dialog");
end
function SysMsgDialog:destory_dialog( )
    if self.timer ~=nil then 
        self.timer:stop()
        self.timer = nil
    end

    self.data = nil;

    UIManager:destroy_window("sysmsg_dialog")
    UIManager:destroy_window("count_down_view")
end

function SysMsgDialog:__init( window_name, texture_name, pos_x, pos_y, width, height )
	
    panel=self.view;

	local dialog_bg = CCBasePanel:panelWithFile( 0, 0, 416, 331, UILH_COMMON.dialog_bg,500,500 );
    dialog_bg:setDefaultMessageReturn(true)
    panel:addChild( dialog_bg,-1 );

    local bg_1 = CCBasePanel:panelWithFile(13, 71, 390, 205,UILH_COMMON.bottom_bg, 500, 500)
    panel:addChild(bg_1)

    -- 标题背景
    local bg_size = self.view:getSize()
    self.title_bg = ZImage:create( self.view, UILH_COMMON.title_bg, 0, 0, -1, -1 )
    local title_bg_size = self.title_bg:getSize()
    self.title_bg:setPosition( ( bg_size.width - title_bg_size.width ) / 2, 294 )
    self.title = ZImage:create( self.title_bg, UILH_NORMAL.title_tips, 0, 0, -1, -1 )
    local title_size = self.title.view:getSize()
    self.title.view:setPosition(title_bg_size.width/2-title_size.width/2,title_bg_size.height/2-title_size.height/2 )

    -- local title_bg = MUtils:create_zximg( dialog_bg, UIResourcePath.FileLocate.common .. "dialog_title_bg.png", 330/2-172/2,163,172,46);
    -- local title = MUtils:create_zximg( title_bg, UIResourcePath.FileLocate.normal .. "dialog_title_t.png", 172/2-102/2,46/2-27/2+2,102,27);

    --文本--self.data.text
    local text_dialog = MUtils:create_ccdialogEx(self.view, self.data.text , 30+14, 244, 340, 150, 10, 14);
    text_dialog:setAnchorPoint(0,1);
    local num = #self.data.btn_text_dict;
    local width = 330/(num+1);
    local begin_pos_x = 0
    for i=1,num do
    	local function btn_click( )
            -- 传送前要停止玩家所有动作
            local player = EntityManager:get_player_avatar()
    		player:stop_all_action()
            -- print("SysMsgDialog:__init(self.data.text)",self.data)
            -- for key,value in pairs(self.data) do
            --     print(key,value)
            -- end

            if ( self.data.npc_handle ) then 
                FubenCenterModel:req_message_dialog(self.data.npc_handle,i-1,self.data.message_id);
                if self.timer then
                    self.timer:stop()
                    self.timer = nil
                end 
            elseif ( self.data.npc_name and self.data.scene_id ) then 
                if ( self.data.btn_text_dict[i] == Lang.common.confirm[14]) then -- [445]="再来一次"
                    -- 欢乐护送再次护送仙女
                    GlobalFunc:ask_npc( self.data.scene_id,self.data.npc_name  )
                    self:destory_dialog(  )
                elseif ( self.data.btn_text_dict[i] == Lang.common.confirm[5]) then -- [446]="立即传送"                    
                    GlobalFunc:teleport( self.data.scene_id,self.data.npc_name )
                    self:destory_dialog(  )
                end
            end
    	end
        local w = 40;
        if self.data.btn_text_dict[i] == LangGameString[445] then -- [445]="再来一次"
            w = w-21;
        elseif self.data.btn_text_dict[i] == LangGameString[446] then -- [446]="立即传送"
            w = w-21;
        elseif self.data.btn_text_dict[i] == Lang.common.confirm[21] then -- [21] = "取消"
            -- 如果有取消按钮，则超时后发给服务器的默认按钮序号改为取消按钮的序号
            -- 目前是为了组队副本时，队友没有点击同意进入而超时的情况下队长可以收到通知。  modified by gzn
            self.data.unkown = i-1; 
        end
        if num <= 1 then
            begin_pos_x = ( 331 - 126 ) / 2 - 20
        end
    	-- local btn = ZImageButton:create(self.view,"ui/common/btn_hong.png",SysMsgDialog:get_btn_str( self.data.btn_text_dict[i] ),btn_click, begin_pos_x + ( i - 1 ) * 170 + 20, 35);
        -- local btn = MUtils:create_btn_and_lab(self.view,
        --     "ui/common/btn_lv.png",
        --     "ui/common/btn_lv.png",
        --     btn_click,
        --     52, 238, 126, 43,
        --     self.data.btn_text_dict[i], 16)
        -- local btn = MUtils:create_btn(self.view,"ui/common/btn_lv.png","ui/common/btn_lv.png",btn_click,begin_pos_x + ( i - 1 ) * 170 + 20,35,-1,-1);
        --xiehande 通用按钮修改 btn_lv->button3
        local btn = ZButton:create(self.view,{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel},btn_click,begin_pos_x + ( i - 1 ) * 170 + 65,10, -1, -1)
        MUtils:create_zxfont(btn,self.data.btn_text_dict[i], 126/2,15+5,2,16);
    end

    local function auto_call_func()
        -- print("auto_call_func(self.data.npc_handle,self.data.unkown,self.data.message_id)",self.data.npc_handle,self.data.unkown,self.data.message_id)

        -- print("auto_call_func(self.timer)",self.timer)
        if not self.timer then
            return
        end 
        if(self.data.npc_handle and self.data.unkown~=-1) then
            FubenCenterModel:req_message_dialog(self.data.npc_handle,self.data.unkown,self.data.message_id);
            self.timer:stop()
            self.timer = nil
        end 
    end

    --自动计时发送协议
    if self.data then
        if self.data.alive_time and self.data.alive_time>0 then
            self.timer = timer()
            -- print("self.timer",self.timer)
            self.timer:start(self.data.alive_time,auto_call_func)
        end
    end

    --关闭按钮
    local function btn_close_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            self:destory_dialog(  )
        end
        return true
    end

    -- local spr_bg_size = self.view:getSize()
    -- local exit_btn = MUtils:create_btn(self.view,UIResourcePath.FileLocate.common .. "close_btn_n.png",UIResourcePath.FileLocate.common .. "close_btn_s.png",btn_close_fun,0,0,-1,-1);
    -- local exit_btn_size = exit_btn:getSize()
    
    -- exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
end

function SysMsgDialog:get_btn_str( str )
    if str == "确定" then
        return "ui/normal/queding.png"
    elseif str == "再来一次" then
        return "ui/other/zailaiyici.png";
    elseif str == "立即传送" then
        return "ui/other/lijichuansong.png";
    elseif str == "取消" then
        return "ui/normal/quxiao.png";
    end
end

function SysMsgDialog:active(show)
    if self.exit_btn then
        self.exit_btn:setPosition(363,278)
    end 
end

function SysMsgDialog:on_exit_btn_create_finish()
    if self.exit_btn then
        self.exit_btn.view:setIsVisible(false)
    end 
end