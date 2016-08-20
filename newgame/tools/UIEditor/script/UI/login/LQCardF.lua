-- LQCardF.lua
-- created by aXing on 2013-7-11
-- 烈枪女 角色卡

super_class.LQCardF(SelectCard)

function LQCardF:__init( ... )
    local job_tips_image = CCZXImage:imageWithFile( 220, 200, -1, -1, "ui2/role/tianlei_tip.png" )
    self.view:addChild( job_tips_image )
    ZImage:create( self.view, "ui2/role/tianlei_tip_t.png", 100, 85)
    self.body_name = "frame/human/heiyan/21102"
    self.weapon_name = "frame/weapon/60/11231"
    self.wing_name = "frame/wing/5"
    self:create_center_avatar(  )

    self.body_photo_path = "nopack/half_body11.png"
    self:create_body_photo(  )
    self.discover_forward = 1 
    self.text0 = CCSprite:spriteWithFile('nopack/text_11_0.png')
    self.text1 = CCSprite:spriteWithFile('nopack/text_11_1.png')
    self.text0:setPosition(32 + 20,200 + 20)
    self.text1:setPosition(64 + 20,175 + 20) 
    self.view:addChild(self.text0)
    self.view:addChild(self.text1)
    self.text0:setIsVisible(false)
    self.text1:setIsVisible(false)

    self.text0_pos = {32,200}
    self.text1_pos = {64,175}

    self:setAttr(4,5,3,4)
end

