module(...,package.seeall)


function test_richTextCreator( root )
	--获取富文本单例
	local instance = guiex.RichTextCreator:getInstance()
	--设置默认参数，每次解析文本时，会将默认参数指定到当前参数上
	instance:setDefaultFontSize(40)
	instance:setDefaultFontColor(cc.c3b(255,0,0))
	--instance:setDefautFontName()
	instance:setDefaultFontOpacity(255)


	local visibleSize = cc.Director:getInstance():getVisibleSize()
	--[[local strText = 'this is a string ,use default parameter!'
    local text = instance:Parser(strText)
    text:setPosition(visibleSize.width/2, visibleSize.height-20)
    root:addChild(text)
]]
 	--在属性对中，若没有属性值type,则用于刷新当前文本的格式参数值
 	--type
 	--	label	字符串 指定类型为label,当前设置的参数，只对当前生效
 	--		参数未指定时，使用字体格式当前正在使用的参数值
 	--		color 		颜色
 	--		opacity 	透明度
 	--		fontsize 	字体大小
 	--		fontname 	字体

 	-- image 图片
 	-- 	color 	 	颜色 默认为白色
 	--  opacity 	透明度，默认255,不透明
 	-- 	file		图片资源路径，若为空或者找不到相应的资源，则创建空白图片

 	-- button 按钮，可以响应触摸事件，发送事件
 	--	normal 		正常显示的图片，若不指定，则不显示
 	-- 	press 		按下状态的图片，若不指定，则不显示
 	--  event		触摸事件，发送的事件名称,默认customMSG
 	--  user		触摸事件发送的自定义数据,默认userData
 	--	title		按钮上面的文本,规则与普通文本格式参数指定的规则一致

 	--ccsanim	动画，使用cocostudio编辑的帧动画 
 	--  path    ArmatureFileInfo所在的路径
 	--	data 	ArmatureFileInfo 文件名不需要后缀名 csb文件需要与它同名（name.ExportJson, name.csb)
 	--  anim    将要播放的动画名称

 	--frame 	斩仙中的帧动画，由于富文本对象锚点在左下角，若图片中存在大范围空白区域，则会导致显示位置异常
 	-- skin   	使用的纹理，可重用（下一次若为指定该参数，则使用当前指定的参数）
 	-- actjson	动作定义文件，可重用
 	-- actID	将要播放的动画
 	-- width  	动画宽，可重用
 	-- height 	动画高，可重用

    --RichTestCreator::ParserWithSize(text, size)
    --若size的高度为0，则为默认为自动匹配高度
   	strText = '{type=ccsanim,path=test,data=100,anim=Animation1}'

    local ListTable = cocosUIHelper.creatUI_lua('layout/studio/selectserver/stu_select_server.lua')
    root:addChild(ListTable.root)
    local list = ListTable.server_list

    --strText = '{type=frame,skin=animations/test,actjson=animations/test/action.json,actID=1,width=64,height=64}{type=frame,actID=2}'
    strText = '哈哈啊哈哈啊哈哈\n哈\n哈哈\n哈哈哈哈 哈哈啊\n啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊\n哈哈\n呵呵'
	text = instance:ParserWithSize(strText, cc.size(200,0))
    list:pushBackCustomItem(text)

    strText = '第二个Item\n哈'
    text = instance:ParserWithSize(strText, cc.size(200,0))
    list:pushBackCustomItem(text)

    strText = '{type=ccsanim,path=test,data=100,anim=Animation1}{color=ff00ff,opacity=125}第一三是行{type=label,text=Game,color=ffff00}马上回车\n{opacity=255}Game{type=button,normal=test/item_bg01.png,title=btn}{type=button,normal=test/item_bg01.png,title=btn}{type=button,normal=test/item_bg01.png,title=btn}和bnt同行\n又回车了'
    text = instance:ParserWithSize(strText, cc.size(200,0))
    text:setPosition(visibleSize.width/2+300, visibleSize.height-200)
    root:addChild(text)
    local textSize = text:getVirtualRendererSize()
    print(textSize.width, textSize.height)

    text = instance:ParserWithSize(strText, cc.size(200,0))
    list:pushBackCustomItem(text)

	strText = '哈哈啊哈哈啊哈哈\n哈\n哈哈\n哈哈哈哈 哈哈啊\n啊哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈啊\n哈哈\n呵呵'
    local label = cc.Label:create()
    label:setString(strText)
    label:setSystemFontSize(40)
    label:setDimensions(200,200)
    label:setPosition(visibleSize.width/2-300, visibleSize.height-400)
    root:addChild(label)

    strText = 'Label'
	text = instance:ParserWithSize(strText, cc.size(200,0))
    text:setPosition(visibleSize.width/2-300, visibleSize.height-360)


    root:addChild(text)

end



function startTest(root)
  test_richTextCreator(root)
end