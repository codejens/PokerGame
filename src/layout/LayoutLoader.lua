-----------------------------------------------------------------------------
-- UI布局文件加载器
-- @author zengahaiming
-----------------------------------------------------------------------------

--!class LayoutLoader


LayoutLoader = {}

-------------------------------------------------------
--直接拷贝luaExtend.lua实现用点号检索节点树
local luaExtend = {}
local function getChildInSubNodes(nodeTable, key)
    if #nodeTable == 0 then
        return nil
    end
    local child = nil
    local subNodeTable = {}
    for _, v in ipairs(nodeTable) do
        child = v:getChildByName(key)
        if (child) then
            return child
        end
    end
    for _, v in ipairs(nodeTable) do
        local subNodes = v:getChildren()
        if #subNodes ~= 0 then
            for _, v1 in ipairs(subNodes) do
                table.insert(subNodeTable, v1)
            end
        end
    end
    return getChildInSubNodes(subNodeTable, key)
end

luaExtend.__index = function(table, key)
local root = table.root
local child = root[key]
    if child then
        return child
    end

    child = root:getChildByName(key)
    if child then
        root[key] = child
        return child
    end

    child = getChildInSubNodes(root:getChildren(), key)
    if child then root[key] = child end
    return child
end
------------------------------------------------------


--加载布局文件，返回包含UI根节点的一个table
--@param info  布局table
function LayoutLoader:createLayout(info)
	local result = {}
	setmetatable(result, luaExtend)	
	local gameNode = cc.Node:create()
	gameNode:setName(info.Name)
	local layout = ccui.LayoutComponent:bindLayoutComponent( gameNode )
	self:createChild(gameNode, info.child)
	result['root'] = gameNode
	return result
end

--设置节点公共属性
--@node  node  节点
--@param info  节点属性表
function LayoutLoader:setCommon(node, info)
	node:setName(info.Name)

	if info.Position ~= nil then
		node:setPosition(info.Position.x, info.Position.y)
	end

	if info.Scale ~= nil then
		node:setScaleX(info.Scale.x)
		node:setScaleY(info.Scale.y)
	end

	if info.Rotation ~= nil then
		node:setRotation(info.Rotation)
	end

	if info.RotationSkewX ~= nil then
		node:setRotationSkewX(info.RotationSkewX)
	end

	if info.RotationSkewY ~= nil  then 
		node:setRotationSkewY(info.RotationSkewY)
	end

	if info.AnchorPoint ~= nil then
		node:setAnchorPoint(info.AnchorPoint.x, info.AnchorPoint.y)
	end

	if info.Visible ~= nil then
		node:setVisible(info.Visible)
	end

	if info.size ~= nil then
		node:setContentSize(cc.size(info.size.x, info.size.y))
	end

	if info.Alpha ~= nil then
		node:setOpacity(info.Alpha)
	end

	if info.CColor ~= nil then
		node:setColor(info.CColor)
	end

	if info.Tag ~= nil then
		node:setTag(info.Tag)
	end

	node:setCascadeColorEnabled(true)
	node:setCascadeOpacityEnabled(true)
end

--创建layout
--@node  node  节点
--@param info  layout属性表
function LayoutLoader:createbindLayout( node , info)
	local layout = ccui.LayoutComponent:bindLayoutComponent( node )

	if info.PrePosition ~= nil then
		layout:setPositionPercentX(info.PrePosition.x)
		layout:setPositionPercentY(info.PrePosition.y)
	end

	if info.PreSize ~= nil then
		layout:setPercentWidth(info.PreSize.x)
		layout:setPercentHeight(info.PreSize.y)
	end

	if info.LeftMargin ~= nil then
		layout:setLeftMargin(info.LeftMargin)
	end
	
	if info.RightMargin ~= nil then
		layout:setRightMargin(info.RightMargin)
	end

	if info.TopMargin ~= nil then
		layout:setTopMargin(info.TopMargin)
	end

	if info.BottomMargin ~= nil then
		layout:setBottomMargin(info.BottomMargin)
	end

	return layout
end

--创建子节点
--@node  parent  父节点
--@param info    属性表
function LayoutLoader:createChild(parent, info)
	if info ~= nil then
		for _, kid in ipairs(info) do
			local createFunc = LayoutLoader.createTable[kid.ctype]
			if createFunc ~= nil then
				local kidObj = createFunc(self, kid)
				if kidObj ~= nil then
					parent:addChild(kidObj)
				else
					print('create failed:', kid.ctype)
				end
			else
				print('not exit ctype:', kid.ctype)
			end
			
		end
	end
end


function LayoutLoader:createSpriteObject( info )
	local spriteNode = cc.Sprite:create(info.FileData.Path)
	
	if info.BlendFunc ~= nil then
		spriteNode:setBlendFunc(cc.blendFunc(info.BlendFunc.Src , info.BlendFunc.Dst))
	end

	self:setCommon(spriteNode, info)

	if info.FlipX ~= nil then
		node:setFlippedX(FlipX)
	end

	if info.FlipY then
		node:setFlippedY(FlipY)
	end
   
	self:createbindLayout(spriteNode, info)
	self:createChild(spriteNode, info.child)

	return spriteNode
end

function LayoutLoader:createSingleNodeObject(info)
	local node = cc.Node:create()

	self:setCommon(node, info)
	self:createButtonObject(node, info)

	self:createChild(node, info.child) 
	return node 
end

function LayoutLoader:createSimpleAudioObject( info )
	local AudioNode = cc.Node:create()
	local audio = ccs.ComAudio:create()
	AudioNode:addComponent(audio)

	if info.FileData ~= nil then
		audio:playEffect(info.FileData.Path)
	end

	if info.Volume ~= nil then
		audio:setEffectsVolume(info.Volume)
	end

	if info.Loop ~= nil then
		audio:setLoop(info.Loop)
	end

	return AudioNode
end


function LayoutLoader:createParticleObject( info )
	if info.FileData == nil then
		return nil
	end
	local Particle = cc.ParticleSystemQuad:create(info.FileData.Path)

	self:setCommon(Particle, info)
	self:createbindLayout(Particle, info)
	self:createChild(Particle, info.child) 

	return Particle
end


function LayoutLoader:createGameMapObject( info )
	if info.FileData == nil then
		return nil
	end

	local Map = cc.TMXTiledMap:create(info.FileData.Path)
	self:setCommon(Map, info)
	self:createbindLayout(Map, info)
	self:createChild(Map, info.child) 
	return Map
end

function LayoutLoader:setPropsWidget( widget, info )
	widget:ignoreContentAdaptWithSize(false)
	widget:setCascadeColorEnabled(true)
    widget:setCascadeOpacityEnabled(true)
    widget:setLayoutComponentEnabled(true)

    if info.Size ~= nil then
    	widget:setContentSize(cc.size(info.Size.x, info.Size.y))
	end

	if info.Tag ~= nil then
    	widget:setTag(info.Tag)
	end

	if info.TouchEnable ~= nil then
		widget:setTouchEnabled(info.TouchEnable)
	end

	if info.Name ~= nil then
		widget:setName(info.Name)
	end

	if info.Position ~= nil then
		widget:setPosition(info.Position)
	end

	if info.Scale ~= nil then
		widget:setScaleX(info.Scale.x)
   	 	widget:setScaleY(info.Scale.y)
	end

	if info.RotationSkewX ~= nil then
		widget:setRotationSkewX(info.RotationSkewX)
	end

	if info.RotationSkewY ~= nil then
		widget:setRotationSkewY(info.RotationSkewY)
	end

	if info.Visible ~= nil then
		widget:setVisible(info.Visible)
	end

	if info.CColor ~= nil then
		widget:setColor(info.CColor)
	end

	if info.Alpha ~= nil then
		widget:setOpacity(info.Alpha)
	end

	if info.AnchorPoint ~= nil then
		widget:setAnchorPoint(info.AnchorPoint.x,info.AnchorPoint.y)
	end

	if info.FlipX ~= nil then
		widget:setFlippedX(info.FlipX)
	end

	if info.Tag ~= nil then
		widget:setFlippedY(info.FlipY)
	end    
    
    self:createLayout(widget, info)
end


function LayoutLoader:createButtonObject( info )
	local Button = ccui.Button:create()

	if info.NormalFileData ~= nil then
		Button:loadTextureNormal(info.NormalFileData.Path,0)
	end

	if info.PressedFileData ~= nil then
		Button:loadTexturePressed(info.PressedFileData.Path,0)
	end

	if info.DisabledFileData ~= nil then
		Button:loadTextureDisabled( info.DisabledFileData.Path,0)
	end

	if info.ButtonText ~= nil then
		Button:setTitleText(info.ButtonText)
	end

	if info.TextColor ~= nil then
		Button:setTitleColor(info.TextColor)
	end

	if info.FontSize ~= nil then
		Button:setTitleFontSize(info.FontSize)
	end
	
	if info.FontName ~= nil then
		Button:setTitleFontName(info.FontName)
	end

	if info.FontResource ~= nil then
		Button:setTitleFontName(info.FontResource.Path)
	end
	
	if info.DisplayState ~= nil then
        Button:setBright(info.DisplayState)
        Button:setEnabled(info.DisplayState)
	end

	self:setPropsWidget( Button, info )


	if info.Scale9Enable ~= nil then
		Button:setUnifySizeEnabled(false)
        Button:ignoreContentAdaptWithSize(false)
		Button:setScale9Enabled(info.Scale9Enable)
		Button:setCapInsets(cc.rect(info.Scale9OriginX, info.Scale9OriginY, info.Scale9Width,info.Scale9Height))
	end

	self:createChild(Button, info.child) 
	return Button
end


function LayoutLoader:createCheckBoxObject( info )
	local CheckBox = ccui.CheckBox:create()

	

	if info.NormalBackFileData ~= nil then
		CheckBox:loadTextureBackGround(info.NormalBackFileData.Path,0)
	end

	if info.PressedBackFileData ~= nil then
		CheckBox:loadTextureBackGroundSelected(info.PressedBackFileData.Path,0)
	end

	if info.DisableBackFileData ~= nil then
		CheckBox:loadTextureBackGroundDisabled(info.DisableBackFileData.Path,0)
	end

	if info.NodeNormalFileData ~= nil then
		CheckBox:loadTextureFrontCross(info.NodeNormalFileData.Path,0)
	end

	if info.NodeDisableFileData ~= nil then
		CheckBox:loadTextureFrontCrossDisabled(info.NodeDisableFileData.Path,0)
	end


	if info.CheckedState ~= nil then
		CheckBox:setSelected(info.CheckedState)
	end

	
	if info.DisplayState ~= nil then
		CheckBox:setBright(displaystate)
        CheckBox:setEnabled(displaystate)
	end

	self:setPropsWidget( CheckBox, info )

	self:createChild(CheckBox, info.child) 
	return CheckBox
end


function LayoutLoader:createImageViewObject( info )
	local Image = ccui.ImageView:create()
	if info.FileData ~= nil then
		Image:loadTexture(info.FileData.Path,0)
	end

	self:setPropsWidget( Image, info )

	if info.Scale9Enable ~= nil then
		Image:setScale9Enabled(info.Scale9Enable)
		if info.Scale9Enable then
			Image:setUnifySizeEnabled(false)
       	 	Image:ignoreContentAdaptWithSize(false)
			Image:setCapInsets(cc.rect(info.Scale9OriginX, info.Scale9OriginY, info.Scale9Width,info.Scale9Height))
		end
	end

	self:createChild(Image, info.child)

	return Image
end


function LayoutLoader:createTextObject( info )
	local text = ccui.Text:create()

	if info.TouchScaleChangeAble ~= nil then
		text:setTouchScaleChangeEnabled(info.TouchScaleChangeAble)
	end

	if info.LabelText ~= nil then
		text:setString(info.LabelText)
	end

	if info.FontSize ~= nil then
		text:setFontSize(info.FontSize)
	end

	if info.FontName ~= nil then
		text:setFontName(info.FontName)
	end

	if info.AreaWidth ~= nil or info.AreaHeight ~= nil then
		text:setTextAreaSize(cc.size(info.AreaWidth or 0, info.AreaHeight or 0))
	end

	if info.HorizontalAlignmentType ~= nil then
		text:setTextHorizontalAlignment(info.HorizontalAlignmentType)
	end

	if info.VerticalAlignmentType ~= nil then
		text:setTextVerticalAlignment(info.VerticalAlignmentType)
	end

	if info.FontResource ~= nil then
		text:setFontName(info.FontResource.Path)
	end

	if info.OutlineEnabled ~= nil and info.OutlineEnabled then
		local outColor = cc.c4b(255, 255, 255, 255)
		if info.OutlineColor ~= nil then
			outColor.r = info.OutlineColor.r
			outColor.g = info.OutlineColor.g 
			outColor.b = info.OutlineColor.b
			text:enableOutline(outColor, info.OutlineSize)
		end
	end

	if info.ShadowEnabled ~= nil and info.ShadowEnabled then
		local shadowC = cc.c4b(255, 255, 255,255)
		if info.ShadowColor ~= nil then
			shadowC.r = info.ShadowColor.r
			shadowC.g = info.ShadowColor.g
			shadowC.b = info.ShadowColor.b
			text:enableShadow(shadowC, cc.size(info.ShadowOffsetX, info.ShadowOffsetY), 0)
		end
	end


	self:setPropsWidget( text, info )
--[[	text:setColor(cc.c3b(255,255,255))
	if info.CColor ~= nil then
		text:setTextColor(cc.c4b(info.CColor.r, info.CColor.g, info.CColor.b, 255))
	end
]]

	if not (info.IsCustomSize ~= nil and info.IsCustomSize )then
		text:ignoreContentAdaptWithSize(true)
		if info.Size ~= nil then
			text:setContentSize(cc.size(info.Size.x, info.Size.y))
		end
	end

	self:createChild(text, info.child)

	return text
end


function LayoutLoader:createTextBMFontObject( info )
	local labelBMFont = ccui.TextBMFont:create()

	if info.LabelBMFontFile_CNB ~= nil then
		labelBMFont:setFntFile(info.LabelBMFontFile_CNB.Path)
	end

	if info.LabelText ~= nil then
		labelBMFont:setString(info.LabelText)
	end

	self:setPropsWidget( labelBMFont, info )

	self:createChild(labelBMFont, info.child)
	return labelBMFont
end


function LayoutLoader:createLoadingBarObject( info )
	local LoadingBar = ccui.LoadingBar:create()

	if info.ImageFileData ~= nil then
		LoadingBar:loadTexture(info.ImageFileData.Path,0)
	end

    if info.ProgressType ~= nil then
    	LoadingBar:setDirection(info.ProgressType)
    end
	
	if info.ProgressInfo ~= nil then
		LoadingBar:setPercent(info.ProgressInfo)
	end
	
	self:setPropsWidget( LoadingBar, info )

	self:createChild(LoadingBar, info.child)

	return LoadingBar
end

function LayoutLoader:createSliderObject( info )
	local Slider = ccui.Slider:create()

	if info.BackGroundData ~= nil then
		Slider:loadBarTexture(info.BackGroundData.Path,0)
	end

	if info.ProgressBarData ~= nil then
		Slider:loadProgressBarTexture(info.ProgressBarData.Path,0)
	end

	if info.BallNormalData ~= nil then
		Slider:loadSlidBallTextureNormal(info.BallNormalData.Path,0)
	end

	if info.BallPressedData ~= nil then
		Slider:loadSlidBallTexturePressed(info.BallPressedData.Path,0)
	end

	if info.BallDisabledData ~= nil then
		Slider:loadSlidBallTextureDisabled(info.BallDisabledData.Path,0)
	end

    if info.PercentInfo ~= nil then
		Slider:setPercent(info.PercentInfo)
	end
	
	if info.DisplayState ~= nil then
		Slider:setEnabled(info.DisplayState)
		Slider:setBright(info.DisplayState )
	end

	self:setPropsWidget( Slider, info )

	self:createChild(Slider, info.child)

	return Slider
end

function  LayoutLoader:createTextFieldObject( info )
    local textField = ccui.TextField:create()

    if info.PlaceHolderText ~= nil then
    	textField:setPlaceHolder(info.PlaceHolderText)
    end

    if info.LabelText ~= nil then
    	textField:setString(info.LabelText)
    end

    if info.FontSize ~= nil then
    	textField:setFontSize(info.FontSize)
    end

    if info.FontName ~= nil  then
    	textField:setFontName(info.FontName)
    end
   
    if info.MaxLengthEnable ~= nil then
    	textField:setMaxLengthEnabled(info.MaxLengthEnable)
    	
    	if info.MaxLengthText ~= nil then
    		textField:setMaxLength(10)
    	end
    end

    if info.FontResource ~= nil then
		textField:setFontName(info.FontResource.Path)
	end

	if info.PasswordEnable ~= nil and info.PasswordEnable then
   		textField:setPasswordEnabled(info.PasswordEnable )
   		if info.PasswordStyleText ~= nil then
    		textField:setPasswordStyleText(info.PasswordStyleText)
    	else
    		textField:setPasswordStyleText('*')
		end
	end

	self:setPropsWidget( textField, info )

	if not (info.IsCustomSize ~= nil and info.IsCustomSize )then
		textField:ignoreContentAdaptWithSize(not info.IsCustomSize)
	end

	self:createChild(textField, info.child)
	return textField
end

function LayoutLoader:PanelCommom( panel, info )

	if info.ClipAble ~= nil then
		panel:setClippingEnabled(info.ClipAble)
	end

	if info.Scale9Enable ~= nil then
		panel:setBackGroundImageScale9Enabled(info.Scale9Enable)
	end

	if info.ColorVector ~= nil then
		panel:setBackGroundColorVector(cc.p(info.ColorVector.x, info.ColorVector.y))
	end

	
	if info.ComboBoxIndex ~= nil then
		panel:setBackGroundColorType(info.ComboBoxIndex)
	end

	if info.SingleColor ~= nil  then
		panel:setBackGroundColor(info.SingleColor)
	end

	if info.FirstColor ~= nil or info.EndColor ~= nil then
		local startColor = info.FirstColor or cc.c3b(255, 255, 255) 
		local endColor = info.EndColor or cc.c3b(255, 255, 255)
		panel:setBackGroundColor(startColor,endColor)
	end

	if info.BackColorAlpha ~= nil then
		panel:setBackGroundColorOpacity(info.BackColorAlpha)
	end

	if info.FileData ~= nil then
		panel:setBackGroundImage(info.FileData.Path)
	end
end


function LayoutLoader:createPanelObject( info )
	local Panel = ccui.Layout:create()
	
	self:PanelCommom(Panel, info)
	self:setPropsWidget( Panel, info )

	if info.Scale9Enable ~= nil and info.Scale9Enable then
		Panel:setBackGroundImageCapInsets(cc.rect(info.Scale9OriginX, info.Scale9OriginY, info.Scale9Width, info.Scale9Height))
	end	

	self:createChild(Panel, info.child)

	return Panel

end

function LayoutLoader:createListViewObject ( info )
	local ListView = ccui.ListView:create()

	self:PanelCommom(ListView, info)

	if info.InnerNodeSize ~= nil then
		ListView:setInnerContainerSize(cc.size(info.InnerNodeSize.w, info.InnerNodeSize.h))
	end

    if info.IsBounceEnabled ~= nil then
    	ListView:setBounceEnabled(info.IsBounceEnabled)
    end

    if info.DirectionType ~= nil then
    	ListView:setDirection(info.DirectionType)
    end

    if info.ItemMargin ~= nil then
    	ListView:setItemsMargin(info.ItemMargin)
    end

	self:setPropsWidget( ListView, info )

	if info.Scale9Enable ~= nil and info.Scale9Enable then
		ListView:setBackGroundImageCapInsets(cc.rect(info.Scale9OriginX, info.Scale9OriginY, info.Scale9Width, info.Scale9Height))
	end	

	self:createChild(ListView, info.child)

	return ListView
end


function LayoutLoader:createPageViewObject( info )
	local PageView = ccui.Layout:create()
	
	self:PanelCommom(PageView, info)
	self:setPropsWidget( PageView, info )

	if info.Scale9Enable ~= nil and info.Scale9Enable then
		PageView:setBackGroundImageCapInsets(cc.rect(info.Scale9OriginX, info.Scale9OriginY, info.Scale9Width, info.Scale9Height))
	end	

	self:createChild(PageView, info.child)

	return PageView
end


function LayoutLoader:createScrollViewObject( info )
	local ScrollView = ccui.ScrollView:create()
	self:PanelCommom(ScrollView, info)

	if info.InnerNodeSize ~= nil then
		ScrollView:setInnerContainerSize(cc.size(info.InnerNodeSize.x, info.InnerNodeSize.y))
	end

	if info.ScrollDirectionType ~= nil then
		ScrollView:setDirection(info.ScrollDirectionType)
	end

	if info.IsBounceEnabled ~= nil then
		ScrollView:setBounceEnabled(info.IsBounceEnabled)
	end
	
	self:setPropsWidget( ScrollView, info )

	if info.Scale9Enable ~= nil and info.Scale9Enable then
		ScrollView:setBackGroundImageCapInsets(cc.rect(info.Scale9OriginX, info.Scale9OriginY, info.Scale9Width, info.Scale9Height))
	end	

	self:createChild(PageView, info.child)

	return ScrollView
end


function LayoutLoader:createNodeObject( info )
	if info.ScriptData ~= nil then
		local container = require(info.ScriptData.RelativeScriptFile)
		if container ~= nil then
			local node = container.CreateCustomNode()
			self:setCommon(node, info)
			self:createbindLayout(node, info)
			self:createChild(node, info.child)
			return node
		end
	end
	return nil
end


function LayoutLoader:createProjectNodeObject( info )
	local projectNode = require(info.FileData.Path).create().root
	if projectNode ~= nil then
		self:setCommon(projectNode, info)
		self:createbindLayout(projectNode, info)
		self:createChild(projectNode, info.child)
		return projectNode
	end

	return nil
end


function LayoutLoader:createArmatureNodeObject( info )
	local  node = ccs.Armature:create()
	if info.FileData ~= nil then
		local fullpath = cc.FileUtils:getInstance():fullPathForFilename(info.FileData.Path)  
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fullpath)
		node:init(info.FileData.ArmatureName)

		local IsAutoPlay =  true
		if info.IsAutoPlay ~= nil then
			IsAutoPlay = info.IsAutoPlay
		end
		
		if IsAutoPlay  then
			local loop = 0
			if info.IsLoop ~= nil and info.IsLoop then
				loop = 1
			end

			node:getAnimation():play(info.CurrentAnimationName, -1, loop)
		else
			node:getAnimation():play(info.CurrentAnimationName)
            node:getAnimation():gotoAndPause(0)
		end
	end

	self:setCommon(node, info)
	self:createbindLayout(node, info)
	self:createChild(node, info.child)
	return node
end

LayoutLoader.createTable = 
{
	SingleNodeObjectData 	= LayoutLoader.createSingleNodeObject,
	SpriteObjectData 		= LayoutLoader.createSpriteObject,
	SimpleAudioObjectData	= LayoutLoader.createSimpleAudioObject,
	ParticleObjectData 		= LayoutLoader.createParticleObject,
	GameMapObjectData		= LayoutLoader.createGameMapObject,
	ButtonObjectData		= LayoutLoader.createButtonObject,
	CheckBoxObjectData		= LayoutLoader.createCheckBoxObject,
	ImageViewObjectData		= LayoutLoader.createImageViewObject,
	TextObjectData			= LayoutLoader.createTextObject,
	TextBMFontObjectData	= LayoutLoader.createTextBMFontObject,
	LoadingBarObjectData	= LayoutLoader.createLoadingBarObject,
	SliderObjectData		= LayoutLoader.createSliderObject,
	TextFieldObjectData		= LayoutLoader.createTextFieldObject,
	PanelObjectData			= LayoutLoader.createPanelObject,
	ListViewObjectData		= LayoutLoader.createListViewObject,
	PageViewObjectData		= LayoutLoader.createPageViewObject,
	ScrollViewObjectData	= LayoutLoader.createScrollViewObject,
	NodeObjectData 			= LayoutLoader.createNodeObject,
	ProjectNodeObjectData	= LayoutLoader.createProjectNodeObject,
	ArmatureNodeObjectData  = LayoutLoader.createArmatureNodeObject,
}

