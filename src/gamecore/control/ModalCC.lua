--ModalCC.lua
--created by liubo on 2015-05-15
--模态窗口控制器

ModalCC = {}

function ModalCC:init()

end

function ModalCC:finish( ... )
	
end

--显示模态窗口
--pos_x x轴坐标
--pos_y y轴坐标
--widget 要添加在模态窗口上面的控件 可选
function ModalCC:show_modal(widget)
	local win = GUIManager:show_window("modal")
    win:add_widget(widget)
end

--关闭模态窗口
function ModalCC:hide_modal()
	GUIManager:hide_window("modal")
end

--点击回调
function ModalCC:click_func()
	ModalCC:hide_modal()
end