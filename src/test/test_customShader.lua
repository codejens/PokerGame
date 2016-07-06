module(...,package.seeall)

local _priority = ASYNC_PRIORITY.ANIMATION

function test_WarterShader(root)
	print('water shader!')
	local visibleSize = cc.Director:getInstance():getVisibleSize()
	local back = cc.Sprite:create("test/HelloWorld.png")
	root:addChild(back)
	back:setPosition(visibleSize.width/2, visibleSize.height/2)

	local function createSprite(x, y, title, shaderFunc, ...)

		local ImagePath = 'test/Lightning_icon.png'
		local sprite = cc.Sprite:create(ImagePath)
		local ImageSize = sprite:getContentSize()
		local scaleFactor = visibleSize.width/(ImageSize.width*5)
		local realWidth = ImageSize.width*scaleFactor
		local realHeight = ImageSize.height*scaleFactor
		root:addChild(sprite)
		sprite:setScale(scaleFactor*0.8)
		sprite:setPosition(realWidth*(0.5+x), realHeight*(0.5+y))
		sprite:setGLProgramState(shaderFunc(...))
		print(sprite:getContentSize())

		local label = cc.Label:create()
		label:setString(title)
		label:setSystemFontSize(12)
		label:setColor(cc.c3b(255,0,0))
		local labelSize = label:getContentSize()
		label:setPosition(realWidth*x + labelSize.width/2, realHeight*(1+y) - labelSize.height/2)
		root:addChild(label)

	end
	--[[uniform sampler2D u_normalMap;					\
	uniform float u_kBump;							\
	uniform vec4  u_lightPosInLocalSpace;			\
	uniform vec2  u_contentSize;					\
	uniform vec3  u_diffuseL;						\]]
	createSprite(0,0, "原图", shader_helper.HighLightAdd, cc.vec4(0.0,0.0,0.0,0.0))
	--高亮shader 叠加一个color
	createSprite(1,0, "高亮 在原有基础上上叠加一个颜色\ncc.vec4(0.2, 0.2, 0.2, 0)", shader_helper.HighLightAdd, cc.vec4(0.2, 0.2, 0.2, 0.0))
	--高亮shader 这个不一定能变亮，对每一个通道的每一个值，进行指数运算，即pow(srcColor, Argument）
	createSprite(2,0, "高亮 对每一个通道指数运算\ncc.vec4(0.6, 0.6, 0.6, 1.0)", shader_helper.HighLightPow, cc.vec4(0.6, 0.6, 0.6, 1.0))
	--高亮shader dstColor = srcClor*Argument
	createSprite(3,0, "高亮 对每一个通道乘以一个值\ncc.vec4(2.0, 2.0, 2.0, 2.0)", shader_helper.HighLightMult, cc.vec4(3.0, 3.0, 3.0, 0.2))
	--反色shader
	createSprite(4,0, "反色", shader_helper.Inverse)
	createSprite(0,1, "使用法线贴图", shader_helper.Normal, "test/Lightning_icon_n.png", cc.vec4(0,0,4, 1), cc.p(62,62), cc.vec3(1,1,1))
	createSprite(1,1, "发光", shader_helper.Bloom)
	createSprite(2,1, "模糊", shader_helper.Blur, cc.p(166, 166), 20, 20)
	createSprite(3,1, "边缘检测", shader_helper.EdgeDetection, cc.p(166, 166))
	createSprite(4,1, "轮廓", shader_helper.OutLine, cc.vec3(1, 0,0), 6, 1/166.0)
	createSprite(0,2, "调整色域 偏转30度", shader_helper.AdjustHSV, 30,0.0,0.0)
	createSprite(1,2, "调整饱和度 增加100%", shader_helper.AdjustHSV, 0,1.0,0.0)
	createSprite(2,2, "调整亮度 增加100%", shader_helper.AdjustHSV, 0,0.0,1.0)
	createSprite(3,2, "调整色域 偏转130度", shader_helper.AdjustHSV, 130,0.0,0.0)
	createSprite(4,2, "色域偏转130 饱和度亮度+100%", shader_helper.AdjustHSV, 130,1.0,1.0)
end

function startTest(root)
  test_WarterShader(root)
end