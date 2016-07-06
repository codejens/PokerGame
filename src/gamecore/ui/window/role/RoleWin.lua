--RoleWin.lua
--角色窗口
--created by liubo on 2015-04-24

RoleWin = simple_class(GUIWindow)

---对外接口---

--进入游戏按钮回调
local function enter_btn_func(role_name)
    RoleCC:apply_create_role(role_name)
end

--选择性别按钮回调
local function select_sex_btn_func(type)
    RoleCC:select_sex(type)
end

--随机名字按钮回调
local function random_name_btn_func()
    RoleCC:random_name()
end

--请求进入游戏
local function apply_enter_game(role_id)
    RoleCC:enter_game_scene(role_id)
end

--------------

function RoleWin:__init( view )
	self:register_listener()
end

--显示页
function RoleWin:show_page(page_name)
    local page_dic = {"CreateRole","SelectRole"}
    for _,v in pairs(page_dic) do
        if self:findWidgetByName(v) then
            if v == page_name then
                self:findWidgetByName(v):setVisible(true)
            else
                self:findWidgetByName(v):setVisible(false)
            end
        end
    end
end

--更新角色列表
function RoleWin:update_role_list( data )
    if not data or type(data) ~= "table" then
        return
    end
    local role_list = self:findWidgetByName("LV_RoleList")
    role_list:removeAllItems()
    local bg_img,role_label
    for i,v in ipairs(data) do
        bg_img = GUIImg:create("res/ui/selectserve/right_btn_normal.png")
        local function touchfunc( sender,eventType )
            if eventType == ccui.TouchEventType.ended then
                apply_enter_game(v.id)
            end
        end 
        bg_img:addTouchEventListener(touchfunc)

        role_label = GUIText:create()
        role_label:setString(v.name .. "  " .. v.level .. "级")
        role_label.view:setPosition(200,25)
        bg_img.view:addChild(role_label.view)

        role_list:insertCustomItem(bg_img.view,i-1)
    end
end

--设置选中性别
function RoleWin:set_select_sex(stype)
    local man = self:findWidgetByName("I_Man")
    local woman = self:findWidgetByName("I_Woman")
    if stype == 0 then
        man:loadTexture("res/ui/role/man_s.jpg")
        woman:loadTexture("res/ui/role/woman.jpg")
    elseif stype == 1 then
        man:loadTexture("res/ui/role/man.jpg")
        woman:loadTexture("res/ui/role/woman_s.jpg")
    end
end

--设置名字
function RoleWin:set_role_name(name)
    local role_name = self:findWidgetByName("TF_RoleName")
    role_name:setString(name)
end

--设置监听
function RoleWin:register_listener( ... )
  	local function _cb_func_1(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            local role_name = self:findWidgetByName("TF_RoleName"):getString()
            enter_btn_func(role_name)
        end
    end    
	self:addTouchEventListener('Btn_EnterGame',_cb_func_1)

    local function _cb_func_2(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            random_name_btn_func()
        end
    end    
    self:addTouchEventListener('Btn_Random',_cb_func_2)

    local function _cb_func_3(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            RoleCC:select_sex(0)
        end
    end    
    self:addTouchEventListener('I_Man',_cb_func_3)

    local function _cb_func_4(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
            RoleCC:select_sex(1)
        end
    end    
    self:addTouchEventListener('I_Woman',_cb_func_4)
end