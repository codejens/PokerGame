--LonelyDayConfig.lua
--内容：光棍节活动的配置单体对象
--作者：陈亮
--时间：2014.10.27

--加载通用活动配置类
require "config/activity/CBaseCommonConfig"

--创建光棍节活动的配置单体对象
LonelyDayConfig = BaseCommonConfig(nil)

----------------------------------------------------------------------
--可以增加活动的特殊处理参数文件的配置函数
----------------------------------------------------------------------

--功能：刷新配置活动参数，进行分服的通用活动配置对象都要重写refreshActivityParam这个函数
--参数：1、activityId	活动ID
--返回：无
--作者：陈亮
--时间：2014.10.31
function LonelyDayConfig:refreshActivityParam(activityId)
	local t_activityParam = nil

	if activityId == CommonActivityConfig.OldLonelyDay then
		--加载光棍节参数文件
		require "../data/activity_config/CommonActivity/OldLonelyDayParam"
		t_activityParam = LonelyDayParam
	elseif activityId == CommonActivityConfig.NewLonelyDay then
		--加载光棍节参数文件
		require "../data/activity_config/CommonActivity/NewLonelyDayParam"
		t_activityParam = LonelyDayParam
	end

	self:setActivityParam(t_activityParam)
end

function LonelyDayConfig:getDoubleExpDesc()
	require "../data/activity_config/CommonActivity/NewLonelyDayParam"
	if LonelyDayParam.pageDataGroup then
		return LonelyDayParam.pageDataGroup[7].desc_ex
	else
		return nil
	end
end