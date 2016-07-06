module(...,package.seeall)


function text_layoutcreator( root )

	local instance = guiex.RichTextCreator:getInstance()
	instance:setDefaultFontSize(20)
	instance:setDefaultFontColor(cc.c3b(255,0,0))
	instance:setDefaultFontOpacity(255)

	local visibleSize = cc.Director:getInstance():getVisibleSize()

  	local retCSB = resourceHelper.loadCSB('test/LayoutCreatorCase.csb',false,nil)
   	local nodeCSB = retCSB:getNode()
	root:addChild(nodeCSB)
	nodeCSB:setScaleX(0.5)
	

	strText = 'csb创建'
	text = instance:ParserWithSize(strText, cc.size(200,30))
    text:setPosition(100, visibleSize.height-30)
    root:addChild(text)

    --自定义布局文件的导入
	local csdTable = cocosUIHelper.creatUI_lua('test.LayoutCreatorCase')
	root:addChild(csdTable.root) 
	csdTable.root:setScaleX(0.5)
	csdTable.root:setPosition(visibleSize.width/2, 0)
	local strText = 'luaTabel创建'
	local text = instance:ParserWithSize(strText, cc.size(200,30))
    text:setPosition(visibleSize.width/2+100, visibleSize.height-30)
    root:addChild(text)




    --[[local text = ccui.Text:create("自定义布局文件的加载", "test/FZZYJW.TTF", 50)
    root:addChild(text)
    text:setPosition(visibleSize.width/2, 50)
    text:enableShadow(cc.c4b(0,255,0,255), cc.size(3, 3), 0)
    text:enableOutline(cc.c4b(255,0,0,255),8)]]
end

function startTest(root)
  	text_layoutcreator(root)
end