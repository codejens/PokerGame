-- ToolTipMgr.lua
-- created by lyl on 2012-12-13
-- ToolTipMgr面板

super_class.ToolTipMgr()

local is_showing = false         -- 只能显示一个.暂时在这里控制只能显示一个。
local toolTipMgr = nil            -- 记录tips。当已经显示一个，有新的tips显示，就要删除。

local tips_x = 0                 -- 坐标
local tips_y = 0

-- 参数：type 类型：item, skill     
--       id  ， 附加数据，  坐标（可以不提供）
function ToolTipMgr:__init( type, id, extend_date , po_x, po_y)
    if id == nil then
    	return 
    end
    -- 如果已经显示过，就把当前的内容给去掉。重建
    if is_showing and toolTipMgr.view then
    	UIManager:get_main_panel():removeChild(toolTipMgr.view, true) 
    end
    is_showing = true       -- 标记已经显示

    tips_x = po_x or 350
    tips_y = po_y or 200
    local panel = CCBasePanel:panelWithFile( tips_x, tips_y, 200, 200, UIPIC_GRID_nine_grid_bg3, 500, 500 )
    if "item_bag" == type then
        self:show_bag_item_tips(panel, id, extend_date)
    elseif "item_depot" == type then
        self:show_depot_item_tips( panel, id, extend_date )
    elseif "skill" == type then
        self:show_skill_tips( panel, id, extend_date )
    end

     -- 关闭按钮
    local but_close = CCNGBtnMulTex:buttonWithFile( 0, 0, -1, -1, UIResourcePath.FileLocate.common .. "close_btn_z.png")
    local exit_btn_size = but_close:getSize()
    local spr_bg_size = panel:getSize()
    but_close:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    -- but_close:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "close_btn_s.png")
    --but_close:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/close_btn_s.png")
	local function but_close_fun(eventType,x,y)
		if eventType == TOUCH_CLICK then 
			is_showing = false
			UIManager:get_main_panel():removeChild(self.view, true)
		end
        return true
	end
    but_close:registerScriptHandler(but_close_fun)    --注册
    panel:addChild(but_close)
    
    UIManager:get_main_panel():addChild(panel)

    -- 设置不可击穿
    local function view_fun(eventType,x,y)
        if eventType then 
            return true    
        end
    end
    panel:registerScriptHandler(view_fun)                  --注册
     
    self.view = panel
    toolTipMgr = self
end


function ToolTipMgr:close(  )
    is_showing = false
    UIManager:get_main_panel():removeChild(self.view, true)
end


-- 参数：用来确定调用什么方法
function ToolTipMgr:create_but( panel,  but_name, index, extend_date, x, y)
    local but_1 = CCNGBtnMulTex:buttonWithFile( x, y, 60, 31, UIResourcePath.FileLocate.common .. "button2_bg.png", 500, 500)
    but_1:addTexWithFile(CLICK_STATE_DOWN, UIResourcePath.FileLocate.common .. "button2_bg.png")
    local function but_1_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then 
            self:all_but_fun( index, extend_date )
        end
        return true
    end
    but_1:registerScriptHandler(but_1_fun)                  --注册
    panel:addChild(but_1)
    local label_but_1 = UILabel:create_label_1(but_name, CCSize(100,15), 64 , 18, 14, CCTextAlignmentLeft, 255, 255, 0)
    but_1:addChild( label_but_1 )

    return but_1
end

function ToolTipMgr:all_but_fun( index, extend_date )
    if index == "item_use" then
        self:use_one_item( extend_date )
    elseif index == "item_destroy" then

    elseif index == "store" then
        self:put_one_item_to_depot( extend_date )
    elseif index == "get_out" then
        self:put_one_item_to_bag( extend_date )
    elseif index == "bag_split" then
        -- todo
        print( "  背包拆分 " )
        self:split_bag_item( extend_date )
    elseif index == "store_split" then
        -- todo
        print( "  仓库拆分 " )
        self:split_depot_item( extend_date )
    elseif index == "skill_study" then
        self:study_skill( extend_date )
    elseif index == "skill_upgrade" then
        self:upgrade_skill( extend_date )
    end
    self:close()
end

-- ====================****************** 显示 背包 物品类型的tips ******************====================
-- extend_date ：table第一个值时 item的动态数据 UserItem 结构
function ToolTipMgr:show_bag_item_tips( panel, item_id, extend_date )
	require "config/ItemConfig"
    local item = ItemConfig:get_item_by_id( item_id )
    if item == nil then
    	return 
    end

    -- 名称
    local label_temp = UILabel:create_label_1(item.name, CCSize(100,15), 100, 180, 15, CCTextAlignmentCenter, 255, 255, 255)
    panel:addChild( label_temp )

    local label_temp = UILabel:create_label_1_old(item.desc, CCSize(200,100), 100, 100, 15, CCTextAlignmentCenter, 255, 255, 255)
    panel:addChild( label_temp )
    
    local win = UIManager:find_visible_window("cangku_win")
    if win then
        self:create_but( panel,  LangGameString[832] , "store", extend_date, 10, 10) -- [832]="存入"
        self:create_but( panel,  LangGameString[833] , "bag_split", extend_date, 150, 10) -- [833]="拆分"
    else
        self:create_but( panel,  LangGameString[834] , "item_use", extend_date, 10, 10) -- [834]="使用"
        self:create_but( panel,  LangGameString[833] , "bag_split", extend_date, 150, 10) -- [833]="拆分"
    end
end


-- 使用物品
function ToolTipMgr:use_one_item( extend_date )
    local item_date = extend_date[1]
    if item_date then
        require "model/ItemModel"
        ItemModel:use_one_item( item_date )
        self:close()    
    end
end

-- 放一个物品到仓库
function ToolTipMgr:put_one_item_to_depot( extend_date )
    local item_date = extend_date[1]
    if item_date then 
        require "control/CangKuCC"
        require "model/CangKuItemModel"
        if CangKuItemModel:check_bag_if_full() then
            local notice_content = LangGameString[835] -- [835]="仓库已经满了！"
            require "UI/common/ConfirmWin"
            local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 450, nil)
        else
            CangKuCC:req_bag_to_cangku( item_date.series, 0 )
        end 
    end
end

-- 背包拆分
function ToolTipMgr:split_bag_item( extend_date )
    local item_date = extend_date[1]
    if (not item_date) or (not item_date.series) then
        print("date为空！！！")
        return 
    end

    -- 先判断背包是否已经满了，如果已经满了就要提示
    require "entity/EntityManager";
    local player = EntityManager:get_player_avatar()
    require "model/ItemModel"
    local bag_item_count = ItemModel:get_item_count_without_null()
    

    if player.bagVolumn <= bag_item_count then
        local notice_words = LangGameString[836] -- [836]="背包已经满了，不能拆分！"
        require "UI/common/ConfirmWin"
        ConfirmWin( "notice_confirm", nil, notice_words, nil, nil, 450, nil)
    else
        print("拆分   ", item_date.count)
        require "UI/common/BuyKeyboardWin"
        local function split_item_fun( num )
            print("拆分  ~~~   ", item_date.series, num )
            require "control/ItemCC"
            ItemCC:request_split_item( item_date.series, num )
        end
        if item_date.count > 1 then
            BuyKeyboardWin:show(item_date.item_id, split_item_fun, 2, item_date.count - 1 )
        end
        -- require "control/ItemCC"
        -- ItemCC:request_split_item( item_date.series, 1 )
    end
end

-- ====================****************** 显示 仓库 物品类型的tips ******************====================
-- extend_date ：table第一个值时 item的动态数据 UserItem 结构
function ToolTipMgr:show_depot_item_tips( panel, item_id, extend_date )
    require "config/ItemConfig"
    local item = ItemConfig:get_item_by_id( item_id )
    if item == nil then
        return 
    end

    -- 名称
    local label_temp = UILabel:create_label_1(item.name, CCSize(100,15), 100, 180, 15, CCTextAlignmentCenter, 255, 255, 255)
    panel:addChild( label_temp )

    local label_temp = UILabel:create_label_1_old(item.desc, CCSize(200,100), 100, 100, 15, CCTextAlignmentCenter, 255, 255, 255)
    panel:addChild( label_temp )
    
    self:create_but( panel,  LangGameString[837] , "get_out", extend_date, 10, 10) -- [837]="取出"
    self:create_but( panel,  LangGameString[833] , "store_split", extend_date, 150, 10) -- [833]="拆分"
end


-- 使用物品
function ToolTipMgr:use_one_item( extend_date )
    local item_date = extend_date[1]
    if item_date then
        require "model/ItemModel"
        local use_result, false_type = ItemModel:use_one_item( item_date )
        if not use_result then
            ItemModel:show_use_item_result( false_type , "bag_win")
        end
        self:close()    
    end
end

-- 放一个物品到仓库
function ToolTipMgr:put_one_item_to_bag( extend_date )
    local item_date = extend_date[1]
    if item_date then 
        require "control/CangKuCC"
        require "model/ItemModel"
        if ItemModel:check_bag_if_full() then
            local notice_content = LangGameString[838] -- [838]="背包已经满了！"
            require "UI/common/ConfirmWin"
            local confirmWin = ConfirmWin( "notice_confirm", nil, notice_content, nil, nil, 50, nil)
        else
            CangKuCC:req_cangku_to_bag( item_date.series, 0 )
        end
    end
end

-- 仓库拆分
function ToolTipMgr:split_depot_item( extend_date )
    local item_date = extend_date[1]
    if (not item_date) or (not item_date.series) then
        print("date为空！！！")
        return 
    end

    -- 先判断背包是否已经满了，如果已经满了就要提示
    require "entity/EntityManager";
    local player = EntityManager:get_player_avatar()
    require "model/CangKuItemModel"
    local item_count = CangKuItemModel:get_item_count_without_null(  )
    

    if player.storeVolumn <= item_count then
        local notice_words = LangGameString[839] -- [839]="仓库已经满了，不能拆分！"
        require "UI/common/ConfirmWin"
        ConfirmWin( "notice_confirm", nil, notice_words, nil, nil, 50, nil)
    else
        print("拆分   ", item_date.count)
        require "UI/common/BuyKeyboardWin"
        local function split_item_fun( num )
            print("拆分  ~~~   ", item_date.series, num )
            require "control/CangKuCC"
            CangKuCC:req_seperate_cangku_item( item_date.series, num )
        end
        if item_date.count > 1 then
            BuyKeyboardWin:show(item_date.item_id, split_item_fun, 2, item_date.count - 1 )
        end
        -- require "control/ItemCC"
        -- ItemCC:request_split_item( item_date.series, 1 )
    end
end


-- ====================****************** 显示技能类型的tips ******************====================
-- extend_date ：在技能中没有用
function ToolTipMgr:show_skill_tips( panel, skill_id, extend_date )
    require "config/SkillConfig"
    local skill_base = SkillConfig:get_skill_by_id( skill_id ) 
    if skill_base == nil then
        return 
    end

    require "model/UserSkillModel"
    -- 名称
    local label_temp = UILabel:create_label_1(skill_base.name, CCSize(100,15), 100, 180, 15, CCTextAlignmentCenter, 255, 255, 255)
    panel:addChild( label_temp )
    local desc = UserSkillModel:get_skill_attr_by_id( skill_id, "desc" )
    local label_temp = UILabel:create_label_1_old(desc, CCSize(200,100), 100, 100, 15, CCTextAlignmentCenter, 255, 255, 255)
    panel:addChild( label_temp )

    -- 检查是否已经学习. 如果在人物信息数据中获取不到，说明还没有学习
    
    local skill_player = UserSkillModel:get_a_skill_by_id( skill_id )
    if skill_player == nil then
        self.but_1 = self:create_but( panel,  LangGameString[840] , "skill_study", skill_id, 85, 10) -- [840]="学习"
    else
        self.but_1 = self:create_but( panel,  LangGameString[841] , "skill_upgrade", skill_id, 85, 10) -- [841]="升级"
    end

    -- 如果当前是不可学习状态，就设置按钮为disable状态
    if not UserSkillModel:check_skill_if_can_upgrade( skill_id ) then
        self.but_1:setCurState( CLICK_STATE_DISABLE ) 
    end
end

-- 学习或者升级技能
function ToolTipMgr:study_skill( skill_id )
    print("   学习技能  ", tostring(skill_id) )
    require "model/UserSkillModel"
    UserSkillModel:study_or_upgrade_a_skill( skill_id )
    self:close()
end

-- 升级技能
function ToolTipMgr:upgrade_skill( skill_id )
    print("   升级技能  ", tostring(skill_id) ) 
    require "model/UserSkillModel"
    UserSkillModel:study_or_upgrade_a_skill( skill_id )
    self:close()
end
