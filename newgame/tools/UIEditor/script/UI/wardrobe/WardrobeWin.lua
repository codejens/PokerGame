-- WardrobeWin.lua
-- created by liuguowang on 2013-12-23
-- 角色属性窗口  user_attr_win

require "UI/component/Window"
super_class.WardrobeWin(Window)

require "UI/wardrobe/TujianPage"
require "UI/wardrobe/StarPage"





function WardrobeWin:change_page_index( i )
    
end
--
function WardrobeWin:__init( window_name, texture_name )
    self.all_page_t = {}              -- 存储所有已经创建的页面

   
    self.bgPanel = ZBasePanel:create(self.view,nil,2, 2, 720,386, 500, 500)
    
    self.item = {}
    local _radio_info  = {x=8,y=220,width = 35, height = 83*2 ,addType = 1 } --, image ={UIResourcePath.FileLocate.common .. "xxk-1.png",UIResourcePath.FileLocate.common .. "xxk-2.png"}
    self.radio_button = ZRadioButtonGroup:create(self.bgPanel,_radio_info.x,_radio_info.y,_radio_info.width,_radio_info.height,_radio_info.addType)
    for i=1,2 do
        local function change_page( )
            self:change_page_index(i)
        end
        local _button_info  = {width = 35, height = 83, image_bg = { UIResourcePath.FileLocate.common .. "common_button_d.png",UIResourcePath.FileLocate.common .. "common_button.png"}, text_img = UIResourcePath.FileLocate.wardrobe .. "tab" .. i .. ".png" } 
        self.item[i] = ZImageButton:create( nil, _button_info.image_bg, _button_info.text_img, change_page, 0, 30, _button_info.width, _button_info.height, nil, 500, 500)

        self.radio_button:addItem(self.item[i],4)
    end
    self:change_page_index(1)

end


--切换功能窗口:   1:装备   2：信息  3:buff
function WardrobeWin:change_page_index( but_index )
   --先清除当前界面
    if self.current_panel then
        self.current_panel.view.view:setIsVisible(false)     -- 最终要使用这个来隐藏
        print("hide ni mei")
    end
    if but_index == 1 then
        if self.all_page_t[1] == nil then
            self.all_page_t[1] = TujianPage( self.bgPanel )
        end
        self.current_panel = self.all_page_t[1]

    elseif  but_index == 2 then
        if self.all_page_t[2] == nil then
            WardrobeModel:req_append_att() -- 申请时装槽数据
            self.all_page_t[2] = StarPage( self.bgPanel )
        end
        self.current_panel = self.all_page_t[2]
    end
    self.current_panel.view.view:setIsVisible(true)
    self.current_panel:active(true)
    -- buff
end

--
function WardrobeWin:create( texture_name )
  

end

-- 供外部调用，刷新所有数据
function WardrobeWin:update_win( update_type )

end

--刷新所有属性数据
function WardrobeWin:update(  )
     self.current_panel:update()
end



-- 打开或者关闭是调用. 参数：是否激活
function WardrobeWin:active( show )
    if show then
        self:update()
    end
    
    self.current_panel:active(show)
end



function WardrobeWin:destroy()
    Window.destroy(self)
    -- for key, page in pairs(self.all_page_t) do
    --     page:destroy()
    -- end
end

-- buff面板添加一个buff
function WardrobeWin:add_buff( buff )
  
end

-- buff面板删除一个buff
function WardrobeWin:remove_buff( buff_type ,buff_group)
   
end

function WardrobeWin:update_qqvip()
  
end