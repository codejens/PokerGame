
-- require "UI/commonwidge/base/ZAbstractNode"
-- require "UI/commonwidge/ZBasePanel"
-- require "UI/commonwidge/ZButton"
-- require "UI/commonwidge/ZNoticeButton"
-- require "UI/commonwidge/ZDialog"
-- require "UI/commonwidge/ZEditBox"
-- require "UI/commonwidge/ZImage"
-- require "UI/commonwidge/ZImageButton"
-- require "UI/commonwidge/ZImageImage"
-- require "UI/commonwidge/ZLabel"
-- require "UI/commonwidge/ZLayoutTools"
-- require "UI/commonwidge/ZRadioButtonGroup"
-- require "UI/commonwidge/ZScroll"
-- require "UI/commonwidge/ZTextButton"
-- require "UI/commonwidge/ZTextImage"
-- require "UI/commonwidge/ZCCSprite"
-- require "UI/commonwidge/ZCheckBox"
-- require "UI/commonwidge/ZTextCheckBox"
-- require "UI/commonwidge/ZList"
-- require "UI/commonwidge/ZListVertical"
-- require "UI/commonwidge/ZProgress"
-- require "UI/commonwidge/ZSlotItem"

-- ----------Editor-------------------
-- require "UI/ComponentCreator"
----------Editor-------------------


-- local _strlen = string.len
-- local _replace_str = 'resourceTree/'



-- UILoader(xxx.layout,XuYingWin)

-- UILoaderfromEditor(file)
-- 	UILoader(file,window,'aaaa',{})

function UILoader(file, creator, window_name, create_info)
	local win = creator(window_name, create_info.texture, create_info.grid, create_info.width, create_info.height, create_info.title_text)
	win.layout_file = file
	win.children = {};
	_UILoader(file,win,win.children)
	if win.onLoad then
		win:onLoad( true );
	end
	return win
end

function UIPageLoader( file,creator,rootComponent )
	local page = creator()
	page.children = {};
	_UILoader(file,rootComponent,page.children)
	if page.onLoad then
		page:onLoad( true );
	end
	return page
end

function _UILoader(file,rootComponent,children)
	-- file = string.format("../data/layouts/%s",file);
	local filetable = loadLayout(file)
	local dataSection = filetable
	----print("file",file,dataSection)
	createComponent( dataSection,rootComponent,file,children )
end

function UISave(comp,file)
	local o = comp.dataSection
	
	local f = io.open(file,'r')
	if f then
		local content = f:read('*a')
		f:close()
		f = io.open(file .. '.bak','w+')
		f:write(content)
		f:close()
	end
	
	--[[
	local textID = 0
	reload(langPath)
    for k,v in pairs(LangString) do
		if k > textID then
			textID = k
		end
	end
	
	function UpdateLangString(dataSection)
		if not dataSection.params.text or dataSection.params.text == '' then
			return
		end
		local ustr = dataSection.params.text
		for k,v in pairs(LangString) do
			if v == ustr then
				dataSection.params.textID = tonumber(k)
				----print(ustr,dataSection.params.textID)
				return 
			end
		end
		textID = textID + 1
		LangString[textID] = ustr
		----print(table.show(LangString,'LangString'),ustr,textID,dataSection.text)
		dataSection.params.textID = textID
	end

	
	for k,comp in pairs(componentMap) do
		UpdateLangString(comp.dataSection)
	end
	
	----print(table.show(LangString,'LangString'))
	local f = io.open(langSavePath,'wb+')
	f:write(table.show(LangString,'LangString'))
	f:close()  
	]]--
	UIOutputProcess(comp.dataSection)
	local f = io.open(file,'w+')
	local c = dump(o)
	--c = string.gsub(c,'[\n]','')
	f:write(c)
	f:close()
	--componentMap = {}
end


function createComponent( dataSection,rootComponent,file,children )
	assert(dataSection,'failed to create,dataSection为nil',file)
	assert(rootComponent,'root为nil',file)
	local childrenlist = {}
	for i,subSection in ipairs(dataSection) do
		local ccClass = subSection.class
		-- ----print("subSection.class",ccClass,subSection)
		assert( ComponentCreateTable[ccClass],string.format("创建%s第%d个控件失败,没有%s",file,i,ccClass) )
		local cc = ComponentCreateTable[ccClass](subSection)
		if cc then 
			
			local layout = subSection.layout
			local z = layout.z or 0
			local tag = subSection.tag;

			--children key parent value
			if childrenlist[tag] then
				-- ----print("childrenlist[tag].__classname",childrenlist[tag].__classname,ZRadioButtonGroup)
				if childrenlist[tag].__classname == "ZRadioButtonGroup" then
					childrenlist[tag]:addItem(cc);
				else
					childrenlist[tag].view:addChild(cc.view,z,tag);
				end
				childrenlist[tag] = nil
			else
				rootComponent.view:addChild(cc.view,z,tag)
			end
			local anchorPoint = layout.anchorPoint
			if anchorPoint then
				cc:setAnchorP(CCPoint(anchorPoint[1],anchorPoint[2]))
			end
			local name = subSection.name
			-- ----print("name = ",name)
			if name then
				cc.name = name;
				children[cc.name] = cc
			end
			children[tag] = cc

			-- 把自己的子类保存到列表中
			if subSection.children then
				local subSectionChilren = subSection.children
				for i2,v2 in ipairs(subSectionChilren) do
					childrenlist[v2] = cc;
				end
			end
		else
			----print("创建失败",subSection.class,file)
		end
	end	
end