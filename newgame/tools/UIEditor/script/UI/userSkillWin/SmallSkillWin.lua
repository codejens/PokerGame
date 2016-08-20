--create by jiangjinhong
--小型技能学习界面
--SmallSkillWin.lua
super_class.SmallSkillWin(Window)
function SmallSkillWin:__init( window_name, texture_name )
    self.current_skill_id = 0
    --title 
    local title  = UILabel:create_lable_2("#c00ff00技能学习", 210, 295, 18, ALIGN_CENTER)
    self.view:addChild( title )

	--技能名
    local skill_bg = CCZXImage:imageWithFile( 63, 130, 110, -1, UIResourcePath.FileLocate.common .. "wzk-2.png", 500, 500)
    self.view:addChild(skill_bg)
    self.lab = UILabel:create_lable_2("技能名字", 55, 8, 16, ALIGN_CENTER)
    skill_bg:addChild(self.lab)

    --技能icon区域的背景
    local bgPanel_2 = CCZXImage:imageWithFile( 79, 174, -1, -1, UIResourcePath.FileLocate.renwu .. "jnk.png");  
    self.view:addChild( bgPanel_2 )

    --技能icon显示
    self.skill_icon = CCZXImage:imageWithFile( 39, 39, 65, 65, "", 500, 500)
    self.skill_icon:setAnchorPoint(0.5,0.5)
    bgPanel_2:addChild( self.skill_icon)

    --技能介绍
    self.skill_show = CCDialogEx:dialogWithFile(185, 250, 200, 140, 15, "" , TYPE_VERTICAL,ADD_LIST_DIR_UP);
    self.skill_show:setAnchorPoint(0, 1)
    self.skill_show:setFontSize(15);
    self.view:addChild(self.skill_show);
    self.skill_show:setText("");

    --学习并使用按钮
    local function btn_fun(  )
        if self.current_skill_id ~= 0 then 
            UserSkillModel:study_or_upgrade_a_skill( self.current_skill_id)
            --Instruction:handleUIComponentClick(instruct_comps.USER_SKILL_LEARN)
        end 
    end
    local learn_use_btn = ZButton:create( self.view, 
                                         UIResourcePath.FileLocate.common.."btn_other_red.png",
                                         btn_fun, 125,40,170,-1);
    local learn_use_btn_lab = CCZXLabel:labelWithText( 170/2, 23, "学习新技能", 18, ALIGN_CENTER)
    learn_use_btn:addChild( learn_use_btn_lab );

    --选中框
    self.zximg_corner = MUtils:create_zximg2(self.view,"nopack/ani_corner.png",210,68,175,62, 45,39,20,39,45,39,20,39,1);
    self.zximg_corner:setAnchorPoint(0.5,0.5);

    local _out = CCScaleTo:actionWithDuration(1.0,1.045)
    local _in = CCScaleTo:actionWithDuration(1.0,1.005)
    local array = CCArray:array();
    array:addObject(_out);
    array:addObject(_in);
    local seq = CCSequence:actionsWithArray(array);
    local action = CCRepeatForever:actionWithAction(seq);
    self.zximg_corner:runAction(action)


    --MUtils:create_sprite(self.zximg_jt,"nopack/xszy/"..img_id..".png",71,23);

end
function SmallSkillWin:update( skill_info  )
    self.current_skill_id = skill_info.skill_id
    local skill_base = SkillConfig:get_skill_by_id( skill_info.skill_id )
	local texture = SkillConfig:get_skill_icon(skill_info.skill_icon)
    self.skill_icon:setTexture( texture )
    self.lab:setText( skill_base.name)
    local current_level_config = skill_base.skillSubLevel[1];
    local text = current_level_config.desc
    self.skill_show:setText(text);
end
function SmallSkillWin:active(  )

end 
