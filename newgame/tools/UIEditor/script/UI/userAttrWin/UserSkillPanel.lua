-- UserSkillPanel.lua
-- created by mwy on 2012-4-18
-- 人物属性窗口：技能标签页

super_class.UserSkillPanel()


--UserBookPanel
function UserSkillPanel:__init( fath_Panel )
    self.label_t = {}       --存储文字label的table，这样可以动态地获取修改文字内容

    --背景
    local background = CCBasePanel:panelWithFile( 40,11,339,383, UIResourcePath.FileLocate.renwu .. "2.jpg", 500, 500);  --方形区域
    fath_Panel:addChild( background )

    self.view = background

end

-- 刷新，重新同步装备数据
function UserSkillPanel:update()

end