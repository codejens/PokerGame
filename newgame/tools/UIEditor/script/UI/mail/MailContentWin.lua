-- MailContentWin.lua  
-- created by lyl on 2013-3-12
-- 邮件内容窗口  mail_content_win

super_class.MailContentWin(Window)


function MailContentWin:__init( window_name, texture_name, is_grid, width, height,title_text )
	self.slot_t  = {}            -- 记录所有创建slot
    local bgPanel = self.view

    -- 大背景
    -- local bg = ZImage:create( self.view, UIPIC_COMMOM_style_bg, 0, 0, width, height - 25, -1 )
    local out_grid = ZImage:create( self.view, UILH_COMMON.style_bg, 0, 0, width, height - 25, nil, 600, 600 )

    --关闭按钮
    local function _close_btn_fun()
        UIManager:hide_window(window_name)
    end
    local _exit_btn_info = { img = UIPIC_COMMOM_008, z = 1000, width = 60, height = 60 }
    self._exit_btn = ZButton:create(self.view, _exit_btn_info.img, _close_btn_fun,0,0,_exit_btn_info.width,_exit_btn_info.height,_exit_btn_info.z);
    local exit_btn_size = self._exit_btn:getSize()
    -- 微调一下关闭按钮位置，使关闭按钮位置和NormalStyleWindow的关闭按钮位置大致相近
    self._exit_btn:setPosition( width - exit_btn_size.width+5, height - exit_btn_size.height-15)

    -- 添加九宫格背景框
    local panel = CCBasePanel:panelWithFile( 8, 8, 420, 577, UILH_COMMON.normal_bg_v2, 500, 500 )
    bgPanel:addChild( panel )

    -- 发件人
    self.addressor_name_lable = UILabel:create_lable_2( Lang.mail[16], 28, 537, 18, ALIGN_LEFT ) -- [1430]="#c66ff66发件人:#cffff00" -- [1193]="名称"
    bgPanel:addChild( self.addressor_name_lable )

    -- 分割线
    -- local line = CCZXImage:imageWithFile( 9, 452, 400, 3, UILH_COMMON.split_line)
    -- panel:addChild(line)

    -- 文字：附加物品
    MUtils:create_zxfont(panel,Lang.mail[17],21,428+67,1,16);

    -- 做三个道具背景当装饰
    for i=1,3 do
        local item_bg = CCZXImage:imageWithFile(27+(i-1)*90, 408, 80, 80, UILH_COMMON.slot_bg,0,0)
        self.view:addChild(item_bg)
    end
    -- 创建所有附加道具
    self:create_all_item(  )

    -- 提取按钮
    local function get_but_CB()
        MailModel:request_get_current_mail_attachment(  )
    end
    self.get_but = ZTextButton:create(panel,LangGameString[1255],{UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s}, get_but_CB, 302, 351+62,-1,-1, 1)

    -- -- 分割线
    -- local line = CCZXImage:imageWithFile( 9, 326, 400, 3, UILH_COMMON.split_line)
    -- panel:addChild(line)

    -- 内容区域的背景
    local content_dialog_bg = CCZXImage:imageWithFile( 13, 13+62, 394, 320, UILH_COMMON.bottom_bg, 500, 500 )
    panel:addChild(content_dialog_bg)

    -- 内容文字dialog
    self.content_dialog = CCDialogEx:dialogWithFile( 20, 19+62, 380, 305, 1000, "", 1, ADD_LIST_DIR_UP)
    panel:addChild( self.content_dialog )

    -- 删除按钮
    local function delete_but_CB()
        MailModel:request_delete_current_mail( )
    end
    local delete_btn = ZButton:create(bgPanel,{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel}, delete_but_CB, 61, 25,-1,-1, 1)
    MUtils:create_zxfont(delete_btn,Lang.mail[18],121/2,20,2,16);     --Lang.mail[18]= 删除

    -- 回复按钮
    local function reply_but_CB()
        MailModel:replay_mail(  )
    end
    local reply_btn = ZButton:create(bgPanel,{UILH_COMMON.btn4_nor,UILH_COMMON.btn4_sel}, reply_but_CB, 251, 25,-1,-1, 1)
    MUtils:create_zxfont(reply_btn,Lang.mail[19],121/2,20,2,16);     --Lang.mail[19]= 回复

--    MUtils:create_common_btn( bgPanel, LangGameString[1433], reply_but_CB, 310 , 22 ) -- [1433]="回复"
    -- local reply_but = UIButton:create_button_with_name( 290 , 22, 73, 35, "ui/common/button2_bg.png", "ui/common/button2_bg.png", nil, "", reply_but_CB )
    -- reply_but:addChild( UILabel:create_lable_2( "回复", 36, 12, 16, ALIGN_CENTER ) )
    -- bgPanel:addChild( reply_but )

    -- 关闭按钮
    -- local function close_but_CB( )
	   --  require "UI/UIManager"
    --     UIManager:hide_window( "mail_content_win" )
    -- end
    -- local close_but = UIButton:create_button_with_name( 340 , 377, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_n.png", UIResourcePath.FileLocate.common .. "close_btn_s.png", nil, "", close_but_CB )
    -- local exit_btn_size = close_but:getSize()
    -- local spr_bg_size = bgPanel:getSize()
    -- close_but:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    -- bgPanel:addChild( close_but )
end

-- 创建附加物品
function MailContentWin:create_all_item(  )
    -- 先清空所有slot
    for key, slot in pairs(self.slot_t) do
        self.view:removeChild( slot.view, true )
    end
    self.slot_t = {}

	local current_mail = MailModel:get_current_mail(  )
	local attachment_infos = current_mail.attachment_info

    local begin_x    = 100
    local begin_y    = 278
    local interval_x = 90
    for i = 1, #attachment_infos do
    	local slot = self:create_one_item( 20 + interval_x * (i - 1) + 15, 416, attachment_infos[i] )
        self.view:addChild( slot.view )
    end
end

-- 创建一个物品
function MailContentWin:create_one_item( x, y, attachment_info )
	local slot = SlotItem( 64, 64 )
	slot:set_icon_bg_texture( UILH_COMMON.slot_bg, -8, -8, 80, 80 )   -- 背框
    slot:setPosition( x, y )
    
    if attachment_info.attachment_type == 2 then           -- 如果是钱
        slot:set_money_icon( attachment_info.item_id )
    else
        slot:set_icon( attachment_info.item_id )
        slot:set_gem_level( attachment_info.item_id ) 
        slot:set_item_count( attachment_info.item_count )
    end

    -- 单击 回调函数
    local function item_click_fun ( ... )
        local x, y, arg = ...
        local position = Utils:Split(arg,":");
        -- 将相对坐标转化成屏幕坐标(即OpenGL坐标 800x480)
        local pos = slot.view:getParent():convertToWorldSpace( CCPointMake(position[1],position[2]) );
        
        MailModel:show_item_tips( attachment_info.item_id, pos.x, pos.y, attachment_info )
    end
    slot:set_click_event(item_click_fun)

    table.insert( self.slot_t , slot)
    return slot
end

-- 提供外部静态调用的更新窗口方法
function MailContentWin:update_win( update_type )
    require "UI/UIManager"
    local win = UIManager:find_visible_window("mail_content_win")
    if win then
        -- 把数据交给背包窗口显示
        win:update( update_type )
    end
end

-- 更新邮件信息
function MailContentWin:update_mail_content(  )
    -- 附件
    self:create_all_item(  )
    local current_mail = MailModel:get_current_mail(  )
    -- 发件人
    if current_mail then
        self.addressor_name_lable:setString( Lang.mail[16]..current_mail.addressor_name ) -- [1430]="#c66ff66发件人:#cffff00"
    end
    -- 内容
    -- self.content_dialog:setText("")
    self.content_dialog:setText( current_mail.mail_content )

    -- 根据当前邮件是否有附件，设置提取按钮变暗或者亮
    if MailModel:check_if_exist_attachment( current_mail ) then
        self.get_but:setCurState( CLICK_STATE_UP )
    else
        self.get_but:setCurState( CLICK_STATE_DISABLE )
    end
end

function MailContentWin:update( update_type )
    if update_type == "mail_content" then
    	self:update_mail_content(  )
    elseif update_type == "all" then
        self:update_mail_content(  )
    end
end

function MailContentWin:active( )
    self:update("all")
end

function MailContentWin:destroy()
    Window.destroy(self)
end
