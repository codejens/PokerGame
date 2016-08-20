-- LQCardM.lua
-- created by lyl on 2013-7-15
-- 烈枪男 角色卡

super_class.LQCardM(SelectCard)

function LQCardM:__init( ... )
    local job_tips_image = CCZXImage:imageWithFile( 18, 250, -1, -1, "ui2/role/tianlei_tip.png" )
    self.view:addChild( job_tips_image )

    self.body_name = "frame/human/heiyan/21002"
    self.weapon_name = "frame/weapon/60/11231"
    self.wing_name = "frame/wing/4"
    self:create_center_avatar( "nopack/half_body10.png" )

    self.body_photo_path = "nopack/half_body10.png"
    self:create_body_photo(  )
    self.discover_forward = -1 
    self.text0 = CCSprite:spriteWithFile('nopack/text_10_0.png')
    self.text1 = CCSprite:spriteWithFile('nopack/text_10_1.png')
    self.text0:setPosition(300-32,200)
    self.text1:setPosition(300-64,175) 
    self.view:addChild(self.text0)
    self.view:addChild(self.text1)
    self.text0:setIsVisible(false)
    self.text1:setIsVisible(false)

    self.text0_pos = {300-32,200}
    self.text1_pos = {300-64,175}

    self:setAttr(4,5,3,4)
end
