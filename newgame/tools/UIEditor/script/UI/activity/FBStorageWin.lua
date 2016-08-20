-- FBStorageWin.lua 
-- createed by Little White on 2014-8-22
-- 副本扫荡仓库窗口

super_class.FBStorageWin(Window)

local per_page_count = 25
local font_size = 18

function FBStorageWin:__init(window_name, texture_name)
	-- 物品背景九宫格底图
	local panel = self.view

    self.cangku_item_t = {}   -- 保存slot列表
    self.depot_item_list = {} -- 保存服务器下发item数据

	local window_bg = CCZXImage:imageWithFile( 0, 0, 457,638, UILH_COMMON.bg_01,500,500)
    panel:addChild( window_bg )

    local grid_bg = CCBasePanel:panelWithFile(31, 20, 387, 580, UIPIC_GRID_nine_grid_bg3, 500, 500)
    panel:addChild(grid_bg)

    local point = {}
    local x = 16
    point.x = x
    point.y = 550
    local i_distance = 1

    local size = {width=72, height=72}
    local slot_width = 64
    local slot_height = 64
    point.y = point.y - size.height - 5

    for i=1, per_page_count do
        --每个物品格子的tag从1到25
        local item_icon = ""
        local count = 1
        local lock_flag = nil
         
        self.cangku_item_t[i] = self:create_item_obj(i, point.x, point.y, slot_width, slot_height, item_icon, count, lock_flag);
        grid_bg:addChild(self.cangku_item_t[i].view)
        
        --坐标排列
        point.x = point.x + size.width + i_distance;
        if (i%5==0) then  -- 每5列换行
            point.x = x;
            if (i/5 ~= 5) then --最后一行Y坐标不再下移
                point.y = point.y - size.height - i_distance;
            end
        end
    end

    -- [880]="#c00c0ff仓库空间"
    local cangku_lab = CCZXLabel:labelWithTextS(CCPointMake(195, 170),"仓库空间", font_size + FontPerAddNum,ALIGN_CENTER)
    panel:addChild(cangku_lab)

    local grid_count_str = string.format("%d/%d",0,per_page_count)
    self.cangku_grid_lab = CCZXLabel:labelWithTextS(CCPointMake(263, 170),grid_count_str, font_size + FontPerAddNum,ALIGN_CENTER)
    panel:addChild(self.cangku_grid_lab)

    -- 全部取出按钮
    local function btn_get_all_out_fun()
        EntrustCC:request_depot_item_move_to_bag(0)
    end
    --LangGameString[2478]="全部取出"
    self.btn_get_all_out = ZTextButton:create(panel,LangGameString[2478],UIPIC_COMMOM_002,btn_get_all_out_fun, 165, 100, -1, -1)
    self.btn_get_all_out.view:addTexWithFile(CLICK_STATE_DISABLE, UIPIC_COMMOM_004)

end

--创建物品项
function FBStorageWin:create_item_obj(tag,x, y, width, height,icon,count,lock_flag)
    local item_obj = MUtils:create_one_slotItem( nil, x , y, width, height )
    -- item_obj:setPosition (x, y)
    item_obj:set_icon_texture(icon)
    item_obj:set_tag(tag)
    item_obj:set_count(count)
    -- item_obj:set_icon_size(width, height)
    item_obj:set_icon_bg_texture(UIPIC_ITEMSLOT, -4, -4, 72, 72)

    -- 道具双击事件回调,从仓库里取出单个物品
    local function item_double_clicked ()
       if self.depot_item_list[item_obj:get_tag()] then
            local series = self.depot_item_list[item_obj:get_tag()].series
            EntrustCC:request_depot_item_move_to_bag(series)
        end 
    end

    item_obj:set_double_click_event(item_double_clicked)

    --道具单击事件回调
    local function tip_func( slot_obj,eventType, args, msgid )
        local click_pos = Utils:Split(args, ":")
        local world_pos = self.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2])))
        if self.depot_item_list[item_obj:get_tag()] then
            TipsModel:show_shop_tip( world_pos.x,world_pos.y, self.depot_item_list[item_obj:get_tag()].item_id)
        end 
    end
    item_obj:set_click_event(tip_func)

    return item_obj;
end

--更新物品栏
function FBStorageWin:update(depot_item_list)
    print("FBStorageWin:update(depot_item_list)",#depot_item_list)
    self.depot_item_list = depot_item_list

    local str = string.format("%d/%d",#depot_item_list,per_page_count)
    self.cangku_grid_lab:setText(str)

    for i = 1,per_page_count do
        if depot_item_list[i] then
            self.cangku_item_t[i].set_date( depot_item_list[i] )
        else
            self.cangku_item_t[i].init()
        end
    end

end


