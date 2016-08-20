--SendFollowQueuePage.lua
--内容：鲜花排行榜活动页面类(2015情人节活动)
--作者：guozhinan
--时间：2015.2.6

--加载排行榜活动页面基础类
require "UI/activity/Common/CQueuePage"

--创建鲜花排行榜活动页面类
super_class.SendFollowQueuePage(QueuePage)

--功能：定义鲜花排行榜活动页面的基础属性
--参数：self	页面对象
--返回：无
--作者：陈亮
--时间：2014.10.27
local function create_self_params(self)

end

--功能：创建鲜花排行榜活动页面的基础初始化函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function SendFollowQueuePage:__init()
	self._pageType = CommonActivityConfig.TypeSendFlowerQueue

	-- 创建送花数量标签：
	local send_flower_info = SendFlowerModel:get_send_flower_info()
	local text = Lang.qingrenjie[1]; -- [1] = "当前送花数量："
	if send_flower_info.myNum ~= nil then
		text = Lang.qingrenjie[1]..send_flower_info.myNum
	end
	self.flower_number = MUtils:create_zxfont(self._pageView,text,315,325,1,16)
end

function SendFollowQueuePage:refreshData()
	local send_flower_info = SendFlowerModel:get_send_flower_info()
	-- 刷新送花数量
	local text = Lang.qingrenjie[1]..send_flower_info.myNum
	self.flower_number:setText(text)

	-- 刷新排行榜页面
	local win = UIManager:find_visible_window("flower_rank_win")
	if win then
		win:update_ranking_scroll(send_flower_info)
	end
end

--功能：页面析构函数
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function SendFollowQueuePage:destroy()
	--获取父类
	local t_pageParent = SendFollowQueuePage.super
	--调用父类的析构函数
	t_pageParent.destroy(self)
end

----------------------------------------------------------------------
--重写父类函数
----------------------------------------------------------------------
--功能：显示页面的行为动作，每次切换到这个分页都会进入这里
function SendFollowQueuePage:showPageAction()
	ValentineDayModel:showSendFollowQueuePage(self._isInit)
	-- 请求新数据
	OnlineAwardCC:req_get_sendFlowerRanking()
end

--功能：查看排行榜的行为动作
--参数：无
--返回：无
--作者：陈亮
--时间：2014.10.27
function SendFollowQueuePage:gotoQueue()
	ValentineDayModel:gotoSendFollowQueueWin(9)
end