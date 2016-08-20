-- PetWuXingPage.lua
-- create by hcl on 2012-12-10
-- refactored by guozhinan on 2014-10-28
-- 宠物信息

super_class.PetWuXingPage()


local node_wuxing_up;

local WX_TITLE_PATH = { UILH_PET.pet_jieji1,UILH_PET.pet_jieji2,UILH_PET.pet_jieji3,UILH_PET.pet_jieji4 }
-- 属性加成需要达到的悟性值
local ATTR_NEED_VALUE = { 10,20,30,40,50}

function PetWuXingPage:__init()
    -- 是否使用五行保护珠
    self._wx_isUseShield = false;
    -- 是否不再提示
    self._not_show_next = false;

    ------下面是保存了要更新信息的控件
    self.tab_wuxing_view = {};
    local tab_wuxing_view = self.tab_wuxing_view;

    node_wuxing_up= CCBasePanel:panelWithFile(250,8,630,508,nil,0,0);
    self.view = node_wuxing_up;

    -- 中部背景
    local mid_bg = CCZXImage:imageWithFile( 0, 7, 337, 497, UILH_COMMON.bottom_bg,500,500)
    self.view:addChild(mid_bg)
 
    -- -- 宠阶
    -- tab_wuxing_view[2] = ZImage:create(node_wuxing_up,UIResourcePath.FileLocate.pet .. "pet_jieji_1.png",230,320 );
    -- 说明按钮
    -- local function btn_explain_fun(eventType,x,y)
    --     HelpPanel:show(1);
    -- end
    -- self.shuoming = UIButton:create_switch_button(10,5, 100, 25, "ui/normal/common_question_mark.png","ui/normal/common_question_mark.png", "", 30, 18, nil, nil, nil, nil, btn_explain_fun ,{"nocolor"}) 
    -- node_wuxing_up:addChild(self.shuoming.view,100)

    -- -- 悟性图片
    -- ZImage:create(node_wuxing_up,"ui/pet/t_wx.png",313,323)
    -- 升级需要道具提示文字
    -- tab_wuxing_view[10] = ZLabel:create(node_wuxing_up,"",430,295,14,2);
    -- -- 成功率标题
    -- ZImage:create(node_wuxing_up,"ui/common/quan_bg.png",298,250,264,35,0,500,500);
    -- ZImage:create(node_wuxing_up,"ui/pet/t_cgl.png",313,258)
    
    -- 提升的说明文字
    -- tab_wuxing_view[23] = ZLabel:create(node_wuxing_up,"",425 ,260,14,1)

    self:create_pet_attr_panel(0,205,335,300,nil)
    self:create_description_panel(0,0,335,210,nil)
    self:create_right_panel(336, 7, 298, 497, UILH_COMMON.bottom_bg)

    -- 绑定所有的按钮方法
    self:on_band();
    -- 创建完成后更新数据
    self:update(1,{PetWin:get_current_pet_info()});

    return node_wuxing_up;
end

function PetWuXingPage:create_right_panel(x, y, width, height,texture_path)
    self.right_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
    self.view:addChild(self.right_panel,-1)

    --标题：悟性
    local title_panel = CCBasePanel:panelWithFile( 6, height-39, width-12, 35, UILH_NORMAL.title_bg4, 500, 500 )
    self.right_panel:addChild(title_panel)
    self.label_wuxing_value = MUtils:create_zxfont(title_panel,Lang.pet.pet_wuxin_page[27],(width-12)/2,12,2,15);

    -- 宠物当前悟性的阶级图片
    self.jieji_bg = ZImage:create(self.right_panel,UILH_PET.ball1,231,393)
    self.wx_spr = ZImage:create(self.jieji_bg,WX_TITLE_PATH[1],33,32)
    self.wx_spr.view:setAnchorPoint(0.5,0.5)

    -- 成功率
    self.label_success_rate = ZLabel:create(self.right_panel,"",(width-12)/2,425,18,2); -- [1663]="#cffff00成功率:"
    -- 失败提示语
    self.label_fail_tip = ZLabel:create(self.right_panel,"",(width-12)/2,395,16,2);

    -- 悟性丹slotitem
    local item_id = PetConfig:get_wxd_item_id(PetWin:get_current_pet_info().curr_wx +1)
    self.slot_item_wuxing = MUtils:create_slot_item2(self.right_panel,UILH_COMMON.slot_bg,120,300,68,68,item_id,nil,7.5);
    self.slot_item_wuxing:set_icon_dead_color(  );

    -- 悟性丹购买按钮 
    self.btn_buy1 = ZButton:create(self.right_panel,{UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s},nil,104,224,-1,-1);
    MUtils:create_zxfont(self.btn_buy1,Lang.pet.pet_wuxin_page[17],99/2,19,2,18);     -- [17]="购买"

    -- 悟性丹保护珠slotitem
    local item_id = PetConfig:get_wxbhd_item_id(PetWin:get_current_pet_info().curr_wx +1)
    self.slot_item_baohu = MUtils:create_slot_item2(self.right_panel,UILH_COMMON.slot_bg,180,300,68,68,item_id,nil,7.5);
    self.slot_item_baohu:set_icon_dead_color(  );

    -- 保护珠购买按钮
    self.btn_buy2 = ZButton:create(self.right_panel,{UILH_COMMON.lh_button2,UILH_COMMON.lh_button2_s},nil,168,224,-1,-1);
    MUtils:create_zxfont(self.btn_buy2,Lang.pet.pet_wuxin_page[17],99/2,19,2,18);     -- [17]="购买"

    -- 自动购买材料:"自动购买材料"
    self.switch_but = UIButton:create_switch_button2( 80, 170, 165, 40, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, Lang.pet.pet_wuxin_page[16], 45, 13, 16, nil, nil, nil, nil, nil )
    self.right_panel:addChild(self.switch_but.view)

    -- 是否使用保护果
    local function use_shield_fun()
        self._wx_isUseShield = not self._wx_isUseShield;
    end
    -- 使用保护珠的单选框
    self.tab_wuxing_view[16] = UIButton:create_switch_button2(80, 120, 165, 40, UILH_COMMON.dg_sel_1, UILH_COMMON.dg_sel_2, Lang.pet.pet_wuxin_page[18], 45, 13, 16, nil, nil, nil, nil, use_shield_fun ) -- [1665]="使用保证珠"
    self.right_panel:addChild(self.tab_wuxing_view[16].view,2);

    --提升按钮
    self.btn_tisheng = ZButton:create(self.right_panel,UILH_NORMAL.special_btn,nil,78,50,-1,-1);
    self.btn_tisheng.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_NORMAL.special_btn_d)
    -- MUtils:create_zxfont(self.btn_tisheng,Lang.pet.pet_wuxin_page[31],162/2,19,2,18);     -- [31]="提升"
    local img_tisheng = CCZXImage:imageWithFile( 162/2, 26, -1, -1, UILH_PET.tisheng)
    img_tisheng:setAnchorPoint(0.5,0.5)
    self.btn_tisheng:addChild(img_tisheng)

    -- 提升需要的铜币
    self.label_cost_tip = ZLabel:create(self.btn_tisheng,"",162/2,-20,15,2);
end

function PetWuXingPage:create_description_panel(x, y, width, height,texture_path)
    self.description_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
    self.view:addChild(self.description_panel)

    --标题：额外属性
    local title_panel = CCBasePanel:panelWithFile( 6, height-25, width-12, 35, UILH_NORMAL.title_bg4, 500, 500 )
    self.description_panel:addChild(title_panel)
    MUtils:create_zxfont(title_panel,Lang.pet.pet_wuxin_page[22],(width-12)/2,11,2,15);

    local x = 8
    local row_space = 88
    local column_space = 161
    -- 属性额外加X%
    local shuoming1 = {Lang.pet.pet_wuxin_page[1],Lang.pet.pet_wuxin_page[2],Lang.pet.pet_wuxin_page[3],Lang.pet.pet_wuxin_page[4] }
    -- (需悟性X以上)
    local shuoming2 = {Lang.pet.pet_wuxin_page[23],Lang.pet.pet_wuxin_page[24],Lang.pet.pet_wuxin_page[25],Lang.pet.pet_wuxin_page[26]}
    for i=1,4 do
        local img = ZImage:create(self.description_panel,"ui2/login/lh_ser_bg.png",x+(i-1)%2*column_space ,100-math.floor((i-1)/2)*row_space,160,85,0,500,500);
        ZImage:create(img.view,WX_TITLE_PATH[i],7,23);
        ZLabel:create(img.view,shuoming1[i],31,25,13,1)
        ZLabel:create(img.view,shuoming2[i],31,49,13,1)
    end
end

function PetWuXingPage:create_pet_attr_panel(x, y, width, height,texture_path)
    self.pet_attr_panel = CCBasePanel:panelWithFile( x, y, width, height,texture_path, 500, 500 )
    self.view:addChild(self.pet_attr_panel)

    --宠物名字的标题
    local title_panel = CCBasePanel:panelWithFile( -9, 256, 356, 49, UILH_NORMAL.title_bg3, 0, 0 )
    self.pet_attr_panel:addChild(title_panel)
    self.label_pet_name = MUtils:create_zxfont(title_panel,"",356/2,18,2,15);

    -- 文字背景
    local text_bg = CCZXImage:imageWithFile( 6, height-71, width-12, 35, UILH_NORMAL.title_bg4, 500, 500)
    self.pet_attr_panel:addChild(text_bg,-1)
    -- 属性标题文字
    ZLabel:create(self.pet_attr_panel,Lang.pet.pet_wuxin_page[5],50,height-60,15,1); -- [1657]="#cfff000资质       当前等级  下个等级"

    --{"攻    击:#cffff00","物理防御:#cffff00","法术防御:#cffff00","暴    击:#cffff00","命    中:#cffff00","闪    避:#cffff00","抗 暴 击:#cffff00","生    命:#cffff00"};
    local tab_text = {Lang.pet.pet_wuxin_page[6],Lang.pet.pet_wuxin_page[7],Lang.pet.pet_wuxin_page[8],Lang.pet.pet_wuxin_page[9],
                      Lang.pet.pet_wuxin_page[10],Lang.pet.pet_wuxin_page[11],Lang.pet.pet_wuxin_page[12],Lang.pet.pet_wuxin_page[13]}

    -- 创建8个属性
    self.label_attr_base = {}
    self.label_attr_wuxing_cur = {}
    self.label_attr_wuxing_next = {}
    local space = 27
    for i=1,8 do
        self.label_attr_base[i] = ZLabel:create(self.pet_attr_panel,tab_text[i],20,238 - i *space,15,1);
        self.label_attr_wuxing_cur[i] = ZLabel:create(self.pet_attr_panel,"",175,238 - i *space,15,1);
        self.label_attr_wuxing_next[i] = ZLabel:create(self.pet_attr_panel,"",255,238 - i *space,15,1);
    end
end

-- 所有按钮函数写在这里
function PetWuXingPage:on_band()
    ----------------------------------按钮函数-------------------------------------
    -- 提升按钮
    local function btn_tisheng_fun(eventType,x,y)
        Instruction:handleUIComponentClick(instruct_comps.ANY_BTN)
        local p_s = PetWin:get_current_pet_info();
        if ( p_s ) then
            local player = EntityManager:get_player_avatar();
            if ( player.bindYinliang < PetConfig:get_wxts_need_money( p_s.curr_wx + 1 ) )then
                -- NormalDialog:show(Lang.pet.pet_wuxin_page[19]); -- [462]="仙币不足"
            --天降雄狮修改  xiehande 如果是铜币不足/银两不足/经验不足 做我要变强处理
            ConfirmWin2:show( nil, 15, Lang.screen_notic[11],  need_money_callback, nil, nil )
                return;
            end 
            local isUseShield = 0;
            if ( self._wx_isUseShield ) then
                isUseShield = 1;
            end
            if ( p_s.curr_wx < 11 ) then
                isUseShield = 0;
            end
            -- print("isUseShield",isUseShield)

            -- 判断数量是否足够,并输出提示框
            -- if ( PetConfig:is_have_wuxing_item( p_s.curr_wx ,isUseShield) ) then
                -- 如果使用保护珠
                if ( self._wx_isUseShield ) then
                    self:add_wuxing( p_s,isUseShield,self.switch_but.if_selected )
                else
                    if ( _not_show_next or p_s.curr_wx<11) then
                        self:add_wuxing( p_s,isUseShield ,self.switch_but.if_selected)
                    else
                        local function swith_but_func( not_show_next)
                            _not_show_next = not_show_next;
                        end
                        local function cb()
                            self:add_wuxing(p_s,isUseShield ,self.switch_but.if_selected)
                        end
                        ConfirmWin2:show( 5, nil, Lang.pet.pet_wuxin_page[20], cb , swith_but_func ) -- [1664]="#cfff000本次提升未使用保护符，若提升失败，成长等级下降，确定强化吗？"
                    end
                end
            -- end
        end
    end
    self.btn_tisheng:setTouchClickFun( btn_tisheng_fun )

    -- 悟性丹 购买
    local function btn_buy1_fun(eventType,x,y)
        local p_s = PetWin:get_current_pet_info();
        local item_id = PetConfig:get_wxd_item_id(p_s.curr_wx + 1);
        -- print("======item_id: ", item_id)
        BuyKeyboardWin:show(item_id );
    end
    self.btn_buy1:setTouchClickFun(btn_buy1_fun)

    -- 保护珠购买2
    local function btn_buy2_fun(eventType,x,y)
        local p_s = PetWin:get_current_pet_info();
        if ( p_s ) then
            local item_id = PetConfig:get_wxbhd_item_id(p_s.curr_wx + 1);
            -- print("======item_id: ", item_id)
            BuyKeyboardWin:show(item_id );
        end
    end
    self.btn_buy2:setTouchClickFun(btn_buy2_fun)

    ----------------------------------按钮函数-------------------------------------
end


function PetWuXingPage:update(type,tab_arg)

	if ( type == 1 ) then
        self:update_all(tab_arg[1]);
    elseif ( type == 2 ) then
        self:on_wx_fail();
    elseif ( type == 3 ) then
    elseif ( type == 4 ) then
    elseif ( type == 5 ) then
    elseif ( type == 6 ) then
    elseif ( type == 7 ) then
    end

end

 local PROCESS_SPR_WIDTH = 244
 local PROCESS_SPR_HEIGHT = 128

function PetWuXingPage:update_all( p_s )

    if (p_s == nil) then
        return;
    end

    local tab_wuxing_view = self.tab_wuxing_view;

	local pet_attrs = p_s.tab_attr;
    -- 更新悟性提升界面
    -- 悟性提升相关的数据
    local tisheng_info = PetConfig:get_wxtisheng_info_by_level( p_s.curr_wx + 1  , p_s);
    -- 更新宠物名字
    self.label_pet_name:setText(p_s.pet_name);
    -- 更新宠阶图标
    -- if ( pet_attrs[15] ~= 0) then 
    --     tab_wuxing_view[2].view:setTexture(UIResourcePath.FileLocate.pet .. "pet_jieji_".. pet_attrs[15] ..".png")
    -- else
    --     tab_wuxing_view[2].view:setTexture("");
    -- end
    -- 更新提升数据
    --{"攻    击:#cffff00","物理防御:#cffff00","法术防御:#cffff00","暴    击:#cffff00","命    中:#cffff00","闪    避:#cffff00","抗 暴 击:#cffff00","生    命:#cffff00"};
    local tab_text = {Lang.pet.pet_wuxin_page[6],Lang.pet.pet_wuxin_page[7],Lang.pet.pet_wuxin_page[8],Lang.pet.pet_wuxin_page[9],
                      Lang.pet.pet_wuxin_page[10],Lang.pet.pet_wuxin_page[11],Lang.pet.pet_wuxin_page[12],Lang.pet.pet_wuxin_page[13]}
    for i=1,8 do
        self.label_attr_base[i]:setText(tab_text[i]..' '..tisheng_info.tab_attr[i]);
        self.label_attr_wuxing_cur[i]:setText(tisheng_info.tab_attr2[i]);
        self.label_attr_wuxing_next[i]:setText(tisheng_info.tab_attr3[i]);
    end

    -- 火影这种获取代码应该是错的
    -- local wx_stage = PetWuXingPage:get_curr_wx_stage( p_s.curr_wx )
    local wx_stage = pet_attrs[15]
    local need_value = 50;
    if wx_stage > 3 then
        need_value = 50
    else
        need_value = ATTR_NEED_VALUE[wx_stage+1]
    end
    -- 更新悟性值
    -- local text = string.format(Lang.pet.pet_wuxin_page[14],p_s.curr_wx,need_value)   -- "#c66ff66悟性:%d/%d"
    -- tab_wuxing_view[7]:setText( text ); -- [1759]="#c66ff66悟性:#cffffff"
    self.label_wuxing_value:setText(Lang.pet.pet_wuxin_page[27]..p_s.curr_wx)

    if wx_stage > 0 then 
        self.jieji_bg.view:setIsVisible(true)
        self.wx_spr.view:setTexture( WX_TITLE_PATH[wx_stage] )
    else
        self.wx_spr.view:setTexture( "" )
        self.jieji_bg.view:setIsVisible(false)
    end

    -- if ( tab_wuxing_view[8] ) then 
    --     tab_wuxing_view[8]:removeFromParentAndCleanup(true);
    --     tab_wuxing_view[8] = nil;
    -- end
    -- if ( tab_wuxing_view[9] ) then 
    --     tab_wuxing_view[9]:removeFromParentAndCleanup(true);
    --     tab_wuxing_view[9] = nil;
    -- end
    -- if ( p_s.curr_wx >= 12 ) then 
    --     tab_wuxing_view[8] = MUtils:create_sprite(node_wuxing_up,UIResourcePath.FileLocate.pet .. "pet_toggle_o.png",500,333);
    -- else
    --     tab_wuxing_view[8] = MUtils:create_sprite(node_wuxing_up,UIResourcePath.FileLocate.pet .. "pet_toggle_c.png",500,333);
    -- end
    -- if (p_s.curr_wx >= 24) then
    --     tab_wuxing_view[9] = MUtils:create_sprite(node_wuxing_up,UIResourcePath.FileLocate.pet .. "pet_toggle_o.png",540,333);
    -- else 
    --     tab_wuxing_view[9] = MUtils:create_sprite(node_wuxing_up,UIResourcePath.FileLocate.pet .. "pet_toggle_c.png",540,333);
    -- end
    -- 更新文字
    -- tab_wuxing_view[10]:setText("#c66ff66" ..tisheng_info.lv_need);

    self:succeess_buff_lab(tisheng_info.lv_rate)
    -- if ( tisheng_info.lv_rate ) then 
    --     self.label_success_rate:setText("#c66ff66成功率:#cffffff" .. tisheng_info.lv_rate .. "%");
    -- else
    --      self.label_success_rate:setText("#c66ff66成功率:");
    -- end
    if ( tisheng_info.money ) then
        local cost_text = string.format(Lang.pet.pet_wuxin_page[32],tisheng_info.money) -- [32] = "消耗%d铜币"
        self.label_cost_tip:setText(cost_text); 
    else
        self.label_cost_tip:setText("");
    end
    
    if ( tisheng_info.wxd_item_id ) then 
        -- 更新图片,数量
        self.slot_item_wuxing:update( tisheng_info.wxd_item_id ,tisheng_info.wxd_num,nil,-2,-2,72,72)

        self.btn_buy1.view:setIsVisible(true);
        self.slot_item_wuxing.view:setIsVisible(true);
    else
        self.btn_buy1.view:setIsVisible(false);
        self.slot_item_wuxing.view:setIsVisible(false);
    end

    if ( tisheng_info.bhd_item_id ) then 
        -- 更新图片,数量
        -- print("PetWuXingPage:update_all tisheng_info.bhd_num", tisheng_info.bhd_num)
        self.slot_item_baohu:update( tisheng_info.bhd_item_id ,tisheng_info.bhd_num,nil,-2,-2,72,72)

        self.btn_buy2.view:setIsVisible(true);
        tab_wuxing_view[16].view:setIsVisible(true);
        self.slot_item_baohu.view:setIsVisible(true);
        -- 调整位置slotitem位置
        self.slot_item_wuxing:setPosition(60,300)
        self.btn_buy1:setPosition(44,224)
    else
        self.btn_buy2.view:setIsVisible(false);
        tab_wuxing_view[16].view:setIsVisible(false);
        self.slot_item_baohu.view:setIsVisible(false);
        -- 调整位置slotitem位置
        self.slot_item_wuxing:setPosition(120,300)
        self.btn_buy1:setPosition(104,224)
    end
    
    self.btn_tisheng.view:setIsVisible(true);
    self.btn_tisheng.view:setCurState(CLICK_STATE_UP)
    if (p_s.curr_wx == 50) then
        self.label_fail_tip:setText(Lang.pet.pet_wuxin_page[28])    -- [1760]="#c66ff66悟性等级已满"
        -- self.btn_tisheng.view:setIsVisible(false);
        self.btn_tisheng.view:setCurState(CLICK_STATE_DISABLE)
    elseif( p_s.curr_wx > 10 ) then
        self.label_fail_tip:setText(Lang.pet.pet_wuxin_page[29]) -- [1761]="#c66ff66提升失败悟性等级-1#r#c66ff66使用悟性丹保证珠不下降"
    elseif ( p_s.curr_wx <= 10) then
        self.label_fail_tip:setText(Lang.pet.pet_wuxin_page[30])-- [1762]="#c66ff66提升失败悟性等级不变#r#c66ff66可以放心升级"
    end
end

-- 更新道具数量
function PetWuXingPage:update_item_count( item_id  )
    local tab_wuxing_view = self.tab_wuxing_view;
    local pet_struct = PetWin:get_current_pet_info();
    local wxd_count,bhd_count = PetConfig:get_wx_item_count_by_wx_lv( pet_struct.curr_wx + 1 )
    self.slot_item_wuxing:set_item_count( wxd_count )
    -- print("wxd_count,bhd_count",wxd_count,bhd_count);
    if wxd_count > 0 then
        self.slot_item_wuxing:set_icon_light_color( );
        self.slot_item_wuxing:set_color_frame(item_id,-2,-2,72,72)
    elseif wxd_count == 0 then
        self.slot_item_wuxing:set_icon_dead_color();
        self.slot_item_wuxing:set_color_frame( nil ); 
    end
    if bhd_count then
        self.slot_item_baohu:set_item_count( bhd_count )
        if bhd_count > 0 then
            self.slot_item_baohu:set_icon_light_color(  );
            self.slot_item_baohu:set_color_frame( item_id,-2,-2,72,72)
        elseif bhd_count == 0 then
            -- print("悟性保护珠变暗..............")
            self.slot_item_baohu:set_icon_dead_color(  );
            self.slot_item_baohu:set_color_frame( nil );
        end
    end
end

function PetWuXingPage:add_wuxing( p_s ,isUseShield,if_selected)
    -- print("444_if_selected=",if_selected)
    -- local tab_wuxing_view = self.tab_wuxing_view;
    -- -- 减少道具数量
    -- local num = self.slot_item_wuxing:get_count();
    -- self.slot_item_wuxing:set_item_count(num-1);
    -- -- 判断数量是否为0，为0就变暗
    -- if ( num-1 <= 0 ) then
    --     self.slot_item_wuxing:set_icon_dead_color();
    -- end
    -- if ( isUseShield == 1 ) then
    --     local num1 = self.slot_item_baohu:get_count();
    --     self.slot_item_baohu:set_item_count(num1-1);
    --     print("PetWuXingPage:add_wuxing num1-1",num1)
    --     -- 判断数量是否为0，为0就变暗
    --     if ( num1-1 <= 0 ) then
    --         self.slot_item_baohu:set_icon_dead_color();
    --     end 
    -- end
    local AutoBuy
    if if_selected then
        AutoBuy = 1
    else
        AutoBuy = 0
    end
    
    -- PetCC:req_add_wu(p_s.tab_attr[1],isUseShield,AutoBuy);
    PetModel:do_upgrade_wuxing( AutoBuy, isUseShield )
end

-- function PetWuXingPage:on_wx_fail()

--     if ( tisheng_info.wxd_item_id ) then 
--         -- 更新图片,数量
--         self.slot_item_wuxing:update( tisheng_info.wxd_item_id ,tisheng_info.wxd_num )

--         self.btn_buy1:setIsVisible(true);
--         self.slot_item_wuxing.view:setIsVisible(true);
--     else
--         self.btn_buy1:setIsVisible(false);
--         self.slot_item_wuxing.view:setIsVisible(false);
--     end

--     if ( tisheng_info.bhd_item_id ) then 
--         -- 更新图片,数量
--         print("PetWuXingPage:update_all tisheng_info.bhd_num", tisheng_info.bhd_num)
--         self.slot_item_baohu:update( tisheng_info.bhd_item_id ,tisheng_info.bhd_num )

--         self.btn_buy2:setIsVisible(true);
--         tab_wuxing_view[16].view:setIsVisible(true);
--         self.slot_item_baohu.view:setIsVisible(true);
--     else
--         self.btn_buy2:setIsVisible(false);
--         tab_wuxing_view[16].view:setIsVisible(false);
--         self.slot_item_baohu.view:setIsVisible(false);
--     end
-- end
--end

function PetWuXingPage:succeess_buff_lab(info)
    local base_str = Lang.pet.pet_wuxin_page[15] --"#c66ff66成功率:"
    local tab_wuxing_view = self.tab_wuxing_view
    local temp_info = ZhanBuModel:check_index_item_add_buff(ZhanBuModel.buff_type_index.pet_wuxin_add)
    if temp_info ~= nil then
        if ( info ) then 
            self.label_success_rate:setText(base_str..info .. "%" .. "#c00c0ff+" .. temp_info.add_rate .. Lang.pet.pet_wuxin_page[21]); -- [1675]="#c66ff66成功率:#cffffff" -- [1013]="%(卜)"
        else
            self.label_success_rate:setText(base_str.."#c00c0ff+" .. temp_info.add_rate .. Lang.pet.pet_wuxin_page[21]); -- [1675]="#c66ff66成功率:#cffffff" -- [1013]="%(卜)"
        end
    else
        if ( info ) then 
            self.label_success_rate:setText( base_str .. info .. "%"); -- [1675]="#c66ff66成功率:#cffffff"
        else
            self.label_success_rate:setText(base_str); -- [1763]="#c66ff66成功率:"
        end
    end
end

function PetWuXingPage:get_curr_wx_stage( wx )
    for i,v in ipairs(ATTR_NEED_VALUE) do
        if wx <= v then
            return i-1;
        end
    end
    return 0;
end