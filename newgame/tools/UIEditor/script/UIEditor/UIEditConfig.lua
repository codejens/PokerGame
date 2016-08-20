--UIEditConfig.lua

UIEditConfig = {}

--按钮默认配置
UIEditConfig[INDEX_BTN] = {
	class = "SButton", name = "btn_", parent = "", pos = {0,0}, size = {139,57}, img_n = "sui/common/btn_1.png",
}
UIEditConfig[INDEX_PANEL] = {
	class = "SPanel", name = "panel_", parent = "", pos = {0,0}, size = {100,100}, img_n = "sui/common/panel11.png", is_nine = true, flip = {false, false},
}
UIEditConfig[INDEX_LABEL] = {
	class = "SLabel", name = "label_", parent = "", pos = {0,0}, str = "文字控件", fontsize = 16, align = 1,
}
UIEditConfig[INDEX_IMG] = {
	class = "SImage", name = "img_", parent = "", pos = {0,0}, size = {78,15}, img_n = "sui/common/division_06.png", is_nine = false, flip = {false,false},
}
UIEditConfig[INDEX_EDITEBOX] = {
	class = "SEditBox", name = "editbox_", parent = "", pos = {0,0}, size = {70,35}, maxnum = 15, img_n = "sui/common/input_frame.png", fontsize = 16, align = 1,
}
UIEditConfig[INDEX_TEXBTN] = {
	class = "STextButton", name = "textbtn_", parent = "", pos = {0,0}, str = "按钮名", size = {139,57}, img_n = "sui/common/btn_1.png", fontsize = 24,align = 1,
}
UIEditConfig[INDEX_TEXT] = {
	class = "STextArea", name = "text_", parent = "", pos = {0,0}, str = "文字太多,用区域文本", size = {200,150}, img_n = "nopack/item_cd.png", is_nine = true,
}
UIEditConfig[INDEX_SCROLL] = {
	class = "SScroll", name = "scroll_", parent = "", pos = {0,0}, size = {300,200}, img_n = "nopack/item_cd.png", scroll_type = 2, is_nine = true
}
UIEditConfig[INDEX_GROUPBTN] = {
	class = "SRadioButtonGroup", name = "groupbtn_", parent = "", pos = {0,0}, size = {300,80}, img_n = "nopack/item_cd.png", is_nine = true
}
UIEditConfig[INDEX_RADIOBTN] = {
	class = "SRadioButton", name = "radiobtn_", parent = "", pos = {0,0}, size = {122,50}, img_n = "sui/common/btn12.png", img_s = "sui/common/btn11.png",
}
UIEditConfig[INDEX_SLOTITEM] = {
	class = "SSlotItem", name = "slotitem_", parent = "", pos = {0,0}, size = {78,78}, img_n = "sui/common/slot_bg.png",
}
UIEditConfig[INDEX_PROGRESS] = {
	class = "SProgress", name = "progress_", parent = "", pos = {0,0}, size = {200,25}, img_s = "sui/common/progressBg.png", img_n = "sui/common/progress1.png",
}
UIEditConfig[INDEX_SWITCHBTN] = {
	class = "SSwitchBtn", name = "swithbtn_", parent = "", str = "勾选按钮文本", pos = {0,0}, size = {140,40}, img_s = "sui/common/swith_btn_s.png", img_n = "sui/common/swith_btn_n.png",
}
UIEditConfig[INDEX_SWITCHBTN_NEW] = {
	class = "SSwitchBtnNew", name = "newswithbtn_", parent = "", str = "开关按钮文本", pos = {0,0}, size = {160,40}, img_s = "sui/common/select.png", img_n = "sui/common/select_bg.png",
}
UIEditConfig[INDEX_DRAGBAR] = {
	class = "SDragBar", name = "dragbar_", parent = "", str = "100", pos = {0,0}, size = {200,25}, img_n = "sui/common/blood.png", img_s = "sui/common/progressBg.png",
}
UIEditConfig[INDEX_TOUCHPANEL] = {
	class = "STouchPanel", name = "touchpanel_", parent = "", pos = {0,0}, size = {200,200}, img_n = "nopack/item_cd.png",
}