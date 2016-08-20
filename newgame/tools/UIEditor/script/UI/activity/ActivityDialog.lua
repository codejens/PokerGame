-- ActivityDialog.lua
-- created by hcl on 2013/1/8
-- 通用的提示框

require "UI/component/Window"
require "utils/MUtils"
super_class.ActivityDialog(Window)

-- 颜色定义
local color_yellow = '#cfff200'
local color_blue = '#c3BB3E8'
-- 道具最大长度
local award_max = 6
-- 道具网格尺寸间距
local slot_item_width = 48
local slot_item_height = 48
local slot_item_space = 13
-- 是否是从活动界面打开的
local is_show_from_activityWin = false

-- ptype  1=副本 3=boss 只有2个有效值
-- data  为配表活动数据
function ActivityDialog:show(ptype, data)
    local win = UIManager:show_window("activity_dialog",true);
    win:update(ptype,data);
end
function ActivityDialog:set_is_show_from_activityWin( boo )
    is_show_from_activityWin = boo
end
function ActivityDialog:__init(window_name, texture_name)
    -- 关闭按钮
    local function close_but_CB( )
        self:close()
        if is_show_from_activityWin == true then
            UIManager:show_window("activity_Win")
            is_show_from_activityWin = false
        end
    end
    -- self.exit_btn:setTouchClickFun(close_but_CB)

    local img_bg = ZImage:create(self, UIPIC_GRID_nine_grid_bg3, 11, 202, 368, 192, 0, 15, 15)

    self.bg_img = CCZXImage:imageWithFile(15,206,360,184, "")
    self:addChild(self.bg_img)

    self.desc_bg = CCZXImage:imageWithFile(20,205,349,67,UIResourcePath.FileLocate.common .. "bg_06.png",500,500)
    self:addChild( self.desc_bg )

    self.desc_lab = MUtils:create_ccdialogEx(self.desc_bg,"",14, 7, 323, 25, 5, 13)

    -- 副本次数
    self.fuben_times_txt = ZLabel:create(self, color_yellow..LangGameString[2307], 68, 176, 16, ALIGN_CENTER, 1)--“副本次数”
    self.fuben_times_cont = ZLabel:create(self, "0/3", 132, 176, 16, ALIGN_CENTER, 1)
    local function add_times_btn_fun()
        --添加次数
        -- print("请求增加副本次数")
        ActivityModel:apply_add_enter_fuben_count( self.data.FBID  )
    end
    self.add_times_btn = ZTextButton:create(self, LangGameString[2308], UIResourcePath.FileLocate.common .. "button2_bg.png", add_times_btn_fun, 164+85, 171, 65, 30, 1)--“增 加”
    -- 击杀者
    self.killer_name_txt = ZLabel:create(self, color_yellow..LangGameString[2309], 60, 176, 16, ALIGN_CENTER, 1)--“击杀者”
    self.killer_name_cont = ZLabel:create(self, "", 132, 176, 16, ALIGN_CENTER, 1)

    -- 收益星级
    self.exp_stars_txt = ZLabel:create(self, color_yellow..LangGameString[2310], 59, 149, 16, ALIGN_CENTER, 1)--“经 验：”
    self.exp_stars_cont = MUtils:create_star_range( self, 99, 150, 16, 16, 4 )
    self.exp_stars_cont.change_star_interval( 2 )
    
    self.goods_stars_txt = ZLabel:create(self, color_blue..LangGameString[2311], 59+172, 149, 16, ALIGN_CENTER, 1)--“道 具：”
    self.goods_stars_cont = MUtils:create_star_range( self, 99+170, 150, 16, 16, 4 ) 
    self.goods_stars_cont.change_star_interval( 2 )

    -- 奖励道具网格
    self.line1 = ZImage:create(self, UIResourcePath.FileLocate.common .. "fenge_bg.png", 13, 142, 360, 1, 1)
    self.line2 = ZImage:create(self, UIResourcePath.FileLocate.common .. "fenge_bg.png", 13, 142-55, 360, 1, 1)
    self.award_tab = {}
    
    for i=1,award_max do
        self.award_tab[i] = MUtils:create_slot_item(self, UIPIC_ITEMSLOT,17 + (i-1)*(slot_item_space + slot_item_width),95,62,62)
        self.award_tab[i].view:setScale(slot_item_width/62)
    end

    -- 前往 和  传送  按钮
    local round_btn_url = UIResourcePath.FileLocate.common.."button_bg3_s.png"
    local function go_btn_fun()
        -- print("前往.....")
        if self.ptype == 1 then
            ActivityModel:go_to_activity( self.data.location.sceneid, self.data.location.entityName, false )
        elseif self.ptype == 3 then
            ActivityModel:go_to_scene( self.data.sceneId, self.data.teleportX, self.data.teleportY, false )
        end
    end
    self.go_btn = ZImageButton:create(self, round_btn_url, 
                                        UIResourcePath.FileLocate.dailyActivity.."character_go.png", go_btn_fun, 94, 10, 77, 78, 1)
    local function fly_btn_fun()
        -- print("速传.....")
        if self.ptype == 1 then
            ActivityModel:go_to_activity( self.data.location.sceneid, self.data.location.entityName, true )
        elseif self.ptype == 3 then
            ActivityModel:go_to_scene( self.data.sceneId, self.data.teleportX, self.data.teleportY, true )
        end
    end
    self.fly_btn = ZImageButton:create(self, round_btn_url, 
                                        UIResourcePath.FileLocate.dailyActivity.."character_fly.png", fly_btn_fun, 221, 10, 77, 78, 1)
end

function ActivityDialog:update_fuben_times()
    local enter_times, max_tiems = ActivityModel:get_enter_fuben_count( self.data.FBID )
    self.fuben_times_cont:setText( enter_times.."/"..max_tiems )
end

function ActivityDialog:update_boss_killer( )
    local killer_name = ActivityModel:get_world_boss_killer_name(self.data.id)
    self.killer_name_cont:setText( killer_name )
end
-- ptype 活动类型 1=副本 3=Boss 只有这两个有效值
-- data 活动配置数据
function ActivityDialog:update(ptype,data)
    self.ptype = ptype
    self.data = data
    -- 场景缩略图
    self.bg_img:setTexture( string.format("%s%s%s%s",UIResourcePath.FileLocate.dailyActivity,"scene/",data.sceneImg,".jpg") )
    --不同活动类型的显示区别
    if ptype == 1 then
        --显示副本次数 隐藏击杀者
        self.fuben_times_txt.view:setIsVisible(true)
        self.fuben_times_cont.view:setIsVisible(true)
        self.killer_name_txt.view:setIsVisible(false)
        self.killer_name_cont.view:setIsVisible(false)
        self.add_times_btn.view:setIsVisible(true)
        self:update_fuben_times()
    elseif ptype == 3 then
        self.fuben_times_txt.view:setIsVisible(false)
        self.fuben_times_cont.view:setIsVisible(false)
        self.killer_name_txt.view:setIsVisible(true)
        self.killer_name_cont.view:setIsVisible(true)
        self.add_times_btn.view:setIsVisible(false)
        -- self:update_boss_killer()
        OthersCC:request_world_boss_killer( self.data.id )
    end
    --活动描述
    self.desc_lab:setText( data.desc )
    --奖励道具的显示
    if #data.awards <= 0 then
        for i=1,award_max do
            self.award_tab[i].view:setIsVisible( false )
        end
    else
        for i=1,award_max do
            self.award_tab[i].view:setIsVisible( true )
        end
        for i=1,award_max do  --清空道具网格
            self.award_tab[i]:set_icon_ex( nil )
        end
        local used_slot_count = 1  --当前要填充的道具网格序号，不得超过award_max=6
        local player_data = EntityManager:get_player_avatar()
        if data.awards ~= nil and #data.awards>0 then
            for i=1,#data.awards do
                --匹配自身职业和
                if (data.awards[i].sex == -1 or data.awards[i].sex == nil or data.awards[i].sex == player_data.sex) and (data.awards[i].job == -1 or data.awards[i].job == nil or data.awards[i].job == player_data.job) then
                    -- print(i.."  添加图标   id="..data.awards[i].id.."  性别需求"..data.awards[i].sex.."职业需求"..data.awards[i].job.."........................")
                    -- self.award_tab[used_slot_count]:set_icon( data.awards[i].id )
                    -- self.award_tab[used_slot_count]:set_color_frame( data.awards[i].id )
                    -- self.award_tab[used_slot_count]:set_item_count(data.awards[i].count);
                    self.award_tab[used_slot_count]:update( data.awards[i].id, data.awards[i].count )
                    used_slot_count = used_slot_count + 1
                else
                    -- print(i.."  条件不符  id="..data.awards[i].id.."  性别需求"..data.awards[i].sex.."职业需求"..data.awards[i].job)
                end
                if used_slot_count > award_max then
                    break
                end
            end
        end
    end
    -- 奖励星级
    local stars_info_ret_t = ActivityModel:get_activity_star( data.id )
    if stars_info_ret_t[1] then
        self.exp_stars_txt:setText(color_yellow..LangGameString[2310])
        self.exp_stars_cont.change_star_num  (stars_info_ret_t[1].num)
    else
        self.exp_stars_txt:setText("")
        self.exp_stars_cont.change_star_num  (0)
    end
    if stars_info_ret_t[2] then
        self.goods_stars_txt:setText(color_blue..LangGameString[2311])
        self.goods_stars_cont.change_star_num  (stars_info_ret_t[2].num)
    else
        self.goods_stars_txt:setText("")
        self.goods_stars_cont.change_star_num  (0)
    end
end



