
function createZBasePanel(dataSection)
	local layout = dataSection.layout
	local style = dataSection.style
	local nine_grid_arg = 0;
	if layout.isNineGrid then
		nine_grid_arg = 500
	end
	local cc = ZBasePanel:create(nil, layout.image, layout.posX, layout.posY, layout.width,
		 layout.height, nine_grid_arg, nine_grid_arg);
	return cc
end


--创建ZSprite
function CreateZCCSprite(dataSection)
	local layout = dataSection.layout
	local cc = ZCCSprite:create( nil,layout.image , layout.posX, layout.posY );
	return cc
end

--创建ZImage
function CreateZImage(dataSection)
	local cc = ZImage:createByStyle( dataSection )
	return cc
end

--创建ZImage
function CreateZImageImage(dataSection)
	local cc = ZImageImage:createByStyle( dataSection )
	return cc
end

function CreateZButton(dataSection)
	local layout = dataSection.layout
	local cc = ZButton:create(nil, layout.image, nil, layout.posX, layout.posY, layout.width, layout.height)
	return cc
end

function CreateZTextCheckBox(dataSection)
	local layout = dataSection.layout
	local cc = ZTextCheckBox:createByStyle( dataSection.style,layout )
	return cc
end

function CreateZLabel(dataSection)
	local layout = dataSection.layout
	local cc = ZLabel:create(nil, layout.text,layout.posX, layout.posY, layout.fontSize, layout.align)
	return cc
end

function CreateZDialog(dataSection)
	local layout = dataSection.layout
	local cc = ZDialog:create(nil, layout.text, layout.posX, layout.posY,
	 layout.width, layout.height, layout.fontSize)
	return cc
end

function CreateZEditBox(dataSection)
	local layout = dataSection.layout
	local style = dataSection.style
	local width,height
	if layout.isNineGrid then
		width = layout.width;
		height = layout.height;
	end

	local cc = ZEditBox:create(nil, layout.posX, layout.posY, layout.width, layout.height,
	 layout.maxnum, layout.fontSize, layout.image,width,height)
	return cc
end

function CreateZScroll(dataSection)
	local layout = dataSection.layout
	local cc = ZScroll:create(nil, nil, layout.posX, layout.posY, layout.width, layout.height, layout.maxnum,nil,layout.z,layout.image)
	return cc
end

function CreateZProgress(dataSection)
	local layout = dataSection.layout
	local cc = ZProgress:createByStyle( dataSection.style,layout )
	return cc
end

function CreateZImageButton(dataSection)
	local layout = dataSection.layout
	local cc = ZImageButton:createByStyle( dataSection.style,layout )
	return cc
end

function CreateZTextButton(dataSection)
	local layout = dataSection.layout
	local cc = ZTextButton:createByStyle( dataSection.style ,layout)
	return cc
end

function CreateZTextImage(dataSection)
	local layout = dataSection.layout
	local nine_grid_arg = 0
	if layout.isNineGrid then
		nine_grid_arg = 500
	end
	local cc = ZTextImage:create(nil, layout.text, layout.image, layout.fontSize, 
		layout.posX, layout.posY, layout.width, layout.height,nine_grid_arg,nine_grid_arg);
	return cc	
end

function CreateZSlotItem(dataSection)
	local layout  = dataSection.layout
	local item_id = dataSection.item_id
	local bg_path = dataSection.bg_path
	local cc = ZSlotItem:create( nil,bg_path , layout.posX, layout.posY,layout.width,layout.height,item_id);
	return cc.view
end

function CreateZRadioButtonGroup(dataSection)
	local layout  = dataSection.layout
	local cc = ZRadioButtonGroup:create(nil, layout.posX, layout.posY,layout.width,layout.height,layout.addType ,layout.image)
	if layout.grap then
		cc:setGrap(layout.grap)
	end
	return cc;
end

ComponentCreateTable = 
{
	['ZBasePanel']     	= createZBasePanel,
	['ZCCSprite']    	= CreateZCCSprite,
	['ZImage'] 			= CreateZImage,
	['ZImageImage'] 	= CreateZImageImage,
	['ZButton']    		= CreateZButton,
	['ZTextCheckBox']  	= CreateZTextCheckBox,
	['ZLabel']     		= CreateZLabel,
	['ZDialog']  		= CreateZDialog,
	['ZEditBox']   		= CreateZEditBox,
	['ZScroll'] 		= CreateZScroll,
	['ZProgress'] 		= CreateZProgress,
	['ZImageButton'] 	= CreateZImageButton,
	['ZTextButton'] 	= CreateZTextButton,
	['ZTextImage'] 		= CreateZTextImage,
	['ZSlotItem'] 	    = CreateZSlotItem,
	['ZRadioButtonGroup'] = CreateZRadioButtonGroup,
}