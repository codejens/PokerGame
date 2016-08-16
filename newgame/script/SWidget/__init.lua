--__init.lua

__init_swidget={}
--分批加载 加载界面动画才能动起来
--新加的也加个函数
__init_swidget[1] = function ()
require "SWidget/SWidgetConfig"
require "SWidget/base/SWidgetBase"
require "SWidget/base/STouchBase"
end
__init_swidget[2] = function ()
require "SWidget/SButton"
require "SWidget/SLabel"
require "SWidget/SPanel"
end

__init_swidget[3] = function ()
require "SWidget/SRadioButtonGroup"
require "SWidget/SImage"
require "SWidget/STextButton"
require "SWidget/SEditBox"
require "SWidget/SDropdownbox"
end

__init_swidget[4] = function ()
require "SWidget/SRadioButton"
require "SWidget/SImageButton"
require "SWidget/SScroll"
require "SWidget/STextArea"
end

__init_swidget[5] = function ()
require "SWidget/SSlotItem"
require "SWidget/SProgress"
require "SWidget/SSwitchBtn"
end

__init_swidget[6] = function ()
require "SWidget/SSwitchBtnNew"
require "SWidget/SDragBar"
require "SWidget/STouchPanel"
end

-- 实现能动态改变panel大小的scroll  By FJH

__init_swidget[7] = function ()
require "SWidget/SScrollCell"
require "SWidget/bossHPBar"
require "SWidget/VipWidget"
require "SWidget/FightWidget"
end