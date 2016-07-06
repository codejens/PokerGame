-----------------------------------------------------------------------------
-- 富文本控件类
-- @author tjh
-- 
-----------------------------------------------------------------------------
--富文本创建类单例
local _instance = guiex.RichTextCreator:getInstance()

--!class GUIRichText

GUIRichText = simple_class(GUITouchBase) 

--- 构造函数
-- @param view ccui.richtext控件对象
-- @see GUITouchBase
-- @see members
function GUIRichText:__init(view)

end

--创建富文本控件函数
--@param strText 字符串参考test_richtextcreator
--@size 固定宽高，如果size.height==0 则自动适应高度 可选参数默认nill
function GUIRichText:create(strText,size)
	local text = nil
	if size then
		text = _instance:ParserWithSize(strText, size)
	else
		text = _instance:Parser(strText)
	end

	return self(text)
end

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
--	data 	ArmatureFileInfo
--  csb		创建Armature .csb文件
--  anim    将要播放的动画名称

--frame 	斩仙中的帧动画，由于富文本对象锚点在左下角，若图片中存在大范围空白区域，则会导致显示位置异常
-- skin   	使用的纹理，可重用（下一次若为指定该参数，则使用当前指定的参数）
-- actjson	动作定义文件，可重用
-- actID	将要播放的动画
-- width  	动画宽，可重用
-- height 	动画高，可重用

