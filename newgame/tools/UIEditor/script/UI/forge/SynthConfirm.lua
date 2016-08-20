-- SynthConfirm.lua  "synth_confirm_win"
-- created by zyb on 2014-4-25
-- 炼器--物品合成面板--一键合成选项提示框

super_class.SynthConfirm(NormalStyleWindow)

function SynthConfirm:__init( )
	self.select_lv = 1 		--所选合成等级
	self.select_type = 0 	--所选宝石类型

    -- add after tjxs
    local bg_01 = CCBasePanel:panelWithFile(10, 30, 400, 510, UILH_COMMON.bg_grid, 500, 500 )
    self.view:addChild(item_btn)

    local function synth_btn( )
        if self.select_lv == nil or self.select_type == nil then
            GlobalFunc:create_screen_notic( Lang.forge.synth[25] );
        else
            ForgeModel:get_easy_synth_result(self.select_lv, self.select_type)
            UIManager:hide_window("synth_confirm_win")
        end
    end 
    synth_btn = ZImageButton:create(self.view, UILH_COMMON.btn4_nor,
    			"", synth_btn, (435-121)*0.5, 10, -1, -1, 1)

    local once_label = UILabel:create_lable_2( Lang.forge.synth[13], 121*0.5, 20, 17, ALIGN_CENTER )
    synth_btn:addChild(once_label)

    self:addStoneSldBtn( self.view );
end
-- 设置所选合成等级
function SynthConfirm:set_select_lv( index, param )
	self.select_lv = index
	self.type_name:setText(param)
end
-- 设置所选合成宝石类型
function SynthConfirm:set_select_type( index, param )
	self.select_type = index
	self.type_name2:setText(param)
end


function SynthConfirm:active( show )
	
end

-- add after tjxs
function SynthConfirm:addStoneSldBtn( panel )
    local item_t = {
        item_lv = Lang.forge.synth[20],
        item_name = Lang.forge.synth[21],
        -- 物品id
        item_id = {
            -- 攻击宝石
            [1] = {
                18510, 18511, 18512, 18513, 18514, 18515, 18516, 18517, 18518, 18519
            },
            -- 外放宝石
            [2] = {
                18520, 18521, 18522, 18523, 18524, 18525, 18526, 18527, 18528, 18529
            },
            -- 内防宝石
            [3] = {
                18530, 18531, 18532, 18533, 18534, 18535, 18536, 18537, 18538, 18539
            },
            -- 生命宝石
            [4] = {
                18540, 18541, 18542, 18543, 18544, 18545, 18546, 18547, 18548, 18549
            },
        }
    }
    local params = {
        btn_h = 45,
        btn_w = 396,
        item_h = 45,
        item_w = 396,
        title_x = 7
    }

    require "UI/forge/ZXSynthSpinner"
    local synthSpinner = ZXSynthSpinner:create( panel, item_t, params, 15, 70, 410, 500, UILH_COMMON.bg_grid, 500, 500 ) --UILH_COMMON.bg_grid

    -- 攻击宝石
    local btnAttackStone = CCBasePanel:panelWithFile( params.title_x, 455, params.btn_w, params.btn_h, UILH_COMMON.title_bg3, 500, 500 )
    synthSpinner:addTitle(btnAttackStone, 1 )

    -- 物攻宝石(P-physical)
    local btnDefendStone_P = CCBasePanel:panelWithFile( params.title_x, 410, params.btn_w, params.btn_h, UILH_COMMON.title_bg3, 500, 500 )
    synthSpinner:addTitle(btnDefendStone_P, 2 )

    -- 法防宝石(M-magic)
    local btnDefendSone_M = CCBasePanel:panelWithFile( params.title_x, 365, params.btn_w, params.btn_h, UILH_COMMON.title_bg3, 500, 500 )
    synthSpinner:addTitle(btnDefendSone_M, 3 )        

    -- 生命宝石
    local btnLifeStone = CCBasePanel:panelWithFile( params.title_x, 320, params.btn_w, params.btn_h, UILH_COMMON.title_bg3, 500, 500 )
    synthSpinner:addTitle(btnLifeStone, 4 )


    local function spinner_title_func( title_index, item_index )
        -- print( "------------spinner_title_func:", title_index, item_index )
        self.select_lv = item_index
        self.select_type = title_index
    end
    synthSpinner:registerScriptFunc_t( spinner_title_func )

    local function spinner_item_func( title_index, item_index )
        -- print( "------------spinner_item_func:", title_index, item_index )
        self.select_lv = item_index
        self.select_type = title_index
    end
    synthSpinner:registerScriptFunc_i( spinner_item_func )

    synthSpinner:init_slt()
end