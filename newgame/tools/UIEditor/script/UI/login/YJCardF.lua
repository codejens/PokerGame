-- YJCardF.lua
-- created by lyl on 2013-7-11
-- 逸剑 女 角色卡

super_class.YJCardF(SelectCard)

function YJCardF:__init( ... )
    local job_tips_image = CCZXImage:imageWithFile( 18 + 170, 250, -1, -1, "ui2/role/shushan_tip.png" )
    self.view:addChild( job_tips_image )

    self.body_name = "frame/human/heiyan/22102"
    self.weapon_name = "frame/weapon/60/12231"
    self.wing_name = "frame/wing/5"
    self:create_center_avatar(  )

    self.body_photo_path = "nopack/half_body21.png"
    self:create_body_photo(  )
    self.discover_forward = 1 
    self.text0 = CCSprite:spriteWithFile('nopack/text_21_0.png')
    self.text1 = CCSprite:spriteWithFile('nopack/text_21_1.png')
    self.text0:setPosition(32,200)
    self.text1:setPosition(64,175) 
    self.view:addChild(self.text0)
    self.view:addChild(self.text1)
    self.text0:setIsVisible(false)
    self.text1:setIsVisible(false)

    self.text0_pos = {32,200}
    self.text1_pos = {64,175}
    self:setAttr(4,3,4,5)
        --self.show_words = { "绝","世","逸","剑","滴","水","不","漏" }
end
