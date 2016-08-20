-- SysTipDialog.lua
-- create by hcl on 2013-10-22
-- 系统开启提示对话框

super_class.SysTipDialog(Window)

function SysTipDialog:show( sys_index )
	local win = UIManager:show_window("sys_tip_dialog");
	if win then
		win:update_all(sys_index);
	end
end
 
function SysTipDialog:__init(window_name, texture_name, is_grid, width, height )

    panel = self.view

    local bg_1 = CCZXImage:imageWithFile(28, 82, 373, 217,UILH_COMMON.bg_10, 500, 500)
    panel:addChild(bg_1)

    -- local bg_2 = CCZXImage:imageWithFile(28, 163, -1, -1,UIPIC_OpenSys_003, 500, 500)
    -- panel:addChild(bg_2)

    -- local bg_3 = CCZXImage:imageWithFile(25, 90, -1, -1,UIPIC_OpenSys_004, 500, 500)
    -- panel:addChild(bg_3)

    -- 提示一
    self.title1 = MUtils:create_zxfont( self.view, "测试1",218,140,2,16 )
    -- 提示二
    self.title2 = MUtils:create_zxfont(self.view,"测试2",218,115,2,16)
    -- 提示三
    self.title3 = MUtils:create_zxfont(self.view,"测试3",218,90,2,16)

    -- 图标
    self.sys_icon = MUtils:create_sprite(self.view,self:get_default_icon_path(),221,218)

    -- 我知道了按钮
    local function btn_fun( eventType,msg_id,args)
        UIManager:hide_window("sys_tip_dialog");
    end

    local ok_btn = ZTextButton:create(panel,"我知道了",UIPIC_COMMOM_002, btn_fun, 153,17,-1,-1, 1)

end

local title_path = {
    -- {"ui/sysopen/i1.png","ui/pet/pet_title.png"},                   --宠物
    -- {"ui/sysopen/i2.png","ui/sysopen/t2.png"},                      --必杀技
    -- {"ui/sysopen/i3.png","ui/mount/mounts_title.png"},        --坐骑
    -- {"ui/mainmenu/qiandao.png","ui/qiandao/win_title.png"},
    -- {"ui/mainmenu/zhaocai.png","ui/zhaocai/zhaocai_title.png"},     --招财进宝
    -- {"ui/mainmenu/dujie.png","ui/sysopen/t6.png"},                  --渡劫
    -- {"ui/sysopen/i7.png","ui/forge/lianqi.png"},                      --炼器
    -- {"ui/sysopen/i8.png","ui/guild/xianzong.png"},                      --仙宗
    -- {"ui/sysopen/i9.png","ui/dreamland/dream_title.png"},               --梦境
    -- {"ui/sysopen/i10.png","ui/task/zycm_title.png"},                 --斩妖除魔
    -- {"ui/mainmenu/doufatai.png","ui/doufatai/dou_t_title.png"},     --斗法台
    -- {"ui/mainmenu/linggen.png","ui2/linggen/linggen.png"},          --灵根
    -- {"ui/mainactivity/10.png","ui/ph/t_mzph.png"},                  --每周跑环
    -- {"ui/sysopen/i14.png","ui/sysopen/t14.png"},                    --深海之恋
    -- {"ui/sysopen/i15.png","ui/sysopen/t15.png"},                    --心魔幻境
    -- {"ui/sysopen/i16.png","ui/sysopen/t16.png"},                    --40级装备升级
    -- {"ui/sysopen/i17.png","ui/sysopen/t17.png"},                    --魔界入口
    -- {"ui/mainmenu/fabao.png","ui/fabao/title.png"},                 --法宝                  
    -- {"ui/sysopen/i9.png","ui/sysopen/t19.png"},                     --月华梦境
    -- {"ui/sysopen/i20.png","ui/sysopen/t20.png"},                    --装备洗练
    -- {"ui/sysopen/i21.png","ui/sysopen/t21.png"},                    --天魔塔副本
    -- {"ui/sysopen/i22.png","ui/sysopen/t16.png"},                    --60级装备升级
}

function SysTipDialog:get_icon_path( sys_index )
    require "../data/client_global_config"
    if sys_index == 0 then
        return nil
    else
        return client_global_config.functionOpenLevel[sys_index].icon
    end
end

function SysTipDialog:get_default_icon_path()
    require "../data/client_global_config"
    local array_length = #client_global_config.functionOpenLevel
    return client_global_config.functionOpenLevel[array_length].icon
end

function SysTipDialog:get_max_level()
    require "../data/client_global_config"
    local array_length = #client_global_config.functionOpenLevel
    return client_global_config.functionOpenLevel[array_length].level
end

function SysTipDialog:update_all( curr_sys_index )
    require "../data/client_global_config"
    local info = client_global_config.functionOpenLevel
	local show_info = info[curr_sys_index]
    self.title1:setText(string.format("%s%s#c35C3F7", LangGameString[831], show_info.info))
    self.title2:setText(string.format("#cFF49F4%s#c35C3F7",show_info.desc))
    -- self.title1:setText(string.format("#cFF49F4%s#c35C3F7(%s%s#c35C3F7)", show_info.desc, LangGameString[831], show_info.info));
    self.title3:setText("#cfff000"..show_info.hint)

    if ( self.sys_icon ) then
        self.sys_icon:removeFromParentAndCleanup(true);
    end

    local icon_path = self:get_icon_path(curr_sys_index)

    if icon_path then
        self.sys_icon = MUtils:create_sprite(self.view,icon_path,221,218)
    else
        self.sys_icon = MUtils:create_sprite(self.view,self:get_default_icon_path(),221,218)
    end 
end

function SysTipDialog:active(show)
    if self.exit_btn then
        self.exit_btn:setPosition(383,283)
    end 
end