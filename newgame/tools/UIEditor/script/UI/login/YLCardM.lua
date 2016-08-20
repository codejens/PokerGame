-- YLCardM.lua
-- created by lyl on 2013-7-15
-- 妖轮男 角色卡

super_class.YLCardM(SelectCard)

function YLCardM:__init( ... )
    local job_tips_image = CCZXImage:imageWithFile( 18, 220, -1, -1, "ui2/role/yuanyue_tips.png" )
    self.view:addChild( job_tips_image )
    ZImage:create( self.view, "ui2/role/yuanyue_tips_t.png", 100, 80)
    self.body_name = "frame/human/heiyan/23002"
    self.weapon_name = "frame/weapon/60/13231"
    self.wing_name = "frame/wing/4"
    self:create_center_avatar(  )

    self.body_photo_path = "nopack/half_body30.png"
    self:create_body_photo(  )
    
    self.discover_forward = -1 
    self.text0 = CCSprite:spriteWithFile('nopack/text_30_0.png')
    self.text1 = CCSprite:spriteWithFile('nopack/text_30_1.png')
    self.text0:setPosition(300-32,200)
    self.text1:setPosition(300-64,175) 
    self.view:addChild(self.text0)
    self.view:addChild(self.text1)
    self.text0:setIsVisible(false)
    self.text1:setIsVisible(false)

    self.text0_pos = {300-32,200}
    self.text1_pos = {300-64,175}

    self:setAttr(4,4,5,3)
end
