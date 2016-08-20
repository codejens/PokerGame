-- JiuGongRightWin.lua
-- created by lxm on 2014-7-17
-- 九宫神藏 右边边窗口

require "UI/component/Window"
super_class.JiuGongRightWin(NormalStyleWindow)

--构造函数
function JiuGongRightWin:__init( window_name, window_info )
	self.exit_btn.view:setIsVisible(false)
end

--当界面通过UILoader读取时会回调的函数,只会在布局文件读取完成时调用一次
function JiuGongRightWin:onLoad(  )
	self:onBound()
end

--当界面被UIManager:show_window, hide_window的时候调用
function JiuGongRightWin:active(show)
	if show then

	end
end

--当界面被UIManager:destory_window的时候调用
--销毁的时候必须调用，清理比如retain分页，要在这里通知分页release
function JiuGongRightWin:destroy()
	Window.destroy(self);
end

--在onload的时候调用,主要是绑定事件
function JiuGongRightWin:onBound()
	local children = self.children
    self.preview_scroll = children[6]
    self:create_preview_scroll()

    local close_btn = children[4] 
    function close_btn_fun( )
        UIManager:hide_window("jiu_gong_left_win");
        UIManager:hide_window("jiu_gong_right_win");
    end
     close_btn:setTouchClickFun(close_btn_fun)
end

-- 创建预览
function JiuGongRightWin:create_preview_scroll()
    
    local function scrollfun( _self, row )
        row = row + 1;
        print("row = ",row)
        local panel = CCBasePanel:panelWithFile(0,0,360,180,nil);
        self:create_one_group( panel,row)    
        return panel;
    end
    
    
    self.preview_scroll:setScrollCreatFunction(scrollfun)
    local num  = #_right_show_list
    self.preview_scroll:setMaxNum(num)  
    --self.preview_scroll:setScrollLump( 20, 20, 90 )
    self.preview_scroll.view:setScrollLump( UIResourcePath.FileLocate.jubaobag .. "down_progress.png", UIResourcePath.FileLocate.jubaobag .. "up_progress.png", 5, 10, 90 )
    self.preview_scroll:setScrollLumpPos( 349 )
    self.preview_scroll:refresh()
end

function JiuGongRightWin:create_one_group( panel,row)

    local panel_bg = ZBasePanel:create( panel, UIResourcePath.FileLocate.jiugong .. "x_bg.png", 0, 0, 360, 176, 600, 600)
    ZImage:create(panel, UIResourcePath.FileLocate.jiugong .. "label_bg.png", 0, 132, 360, 44, 5)
    if _right_show_list[row].type == 3 then
        ZImage:create(panel, UIResourcePath.FileLocate.jiugong .. "right_title".._right_show_list[row].type..".png", 125, 145, 100, 28, 10)
    else
        ZImage:create(panel, UIResourcePath.FileLocate.jiugong .. "right_title".._right_show_list[row].type..".png", 100, 142, 165, 28, 10)
    end
    local item_bg = ZBasePanel:create(panel, UIResourcePath.FileLocate.jiugong .. "item_bg.png", 65, 2, 222, 99, 20)
    local item_id  = _right_show_list[row].item_id
    local function check_guize( ... )
    	ActivityModel:show_mall_tips(item_id )
    end

    ZTextButton:create(panel, "#cd5c241#u1点击查看#u0", nil, check_guize, 20, 120, 65, 30, 1)--“点击查看”
    local str = string.format("--左侧累计刷新%d次必出",_right_show_list[row].shuaxin_count)
    ZLabel:create(panel, str, 250, 120, 14, 2, 1)
    

    if _right_show_list[row].type == 1 then
        self:create_user_model_show( item_bg ,item_id)
    elseif _right_show_list[row].type == 2 then
        self:create_pet_model_show( item_bg ,item_id )
    elseif _right_show_list[row].type == 3 then
        self:create_icon_show( item_bg ,item_id )
    end
    

end

-- 创建一个人物模型显示
function JiuGongRightWin:create_user_model_show( item_bg ,item_id)
    local player = EntityManager:get_player_avatar()
    local equip_info = UserInfoModel:get_equi_info();
    self.showAvatar = ShowAvatar:create_user_panel_avatar( 110, 10,equip_info )
    self.showAvatar:update_zhenlong( UserInfoModel:check_if_equip_zhenlong(  ) )
    self.showAvatar.avatar:setScale( 1.2 )
    print("item_id",item_id)
    self.showAvatar:update_weapon( item_id )
    item_bg.view:addChild( self.showAvatar.avatar, 999 )
end

function JiuGongRightWin:create_pet_model_show( item_bg ,item_id )
    local item_config = ItemConfig:get_item_by_id(item_id);
    local file_name = "scene/monster/"..item_config.suitId;
    local action = {0,0,9,0.2};
    local pet_sprite = MUtils:create_animation(110,10,file_name,action );
    item_bg.view:addChild(pet_sprite);
end

function JiuGongRightWin:create_icon_show( item_bg ,item_id )
    local n_bg = ItemConfig:get_item_icon( item_id )
    --ZImage:create(item_bg.view, n_bg, 80, 10, 60, 60, 5)
    local temp =ZBasePanel:create(item_bg.view, n_bg, 80, 10, 60, 60)
    local function check_guize( ... )
        ActivityModel:show_mall_tips(item_id )
    end
    temp:setTouchClickFun(check_guize)
end