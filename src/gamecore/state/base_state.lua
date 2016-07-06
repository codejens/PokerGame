baseState = { id = 'baseState' }

--进入世界
--注册监听世界时间线推进
function baseState:enter(oldstate)
	--notifySystem:listenNotify(TIMELINE_EVENT,self,self.onTimeline)
end

--离开世界
--取消监听世界时间线推进
function baseState:leave()
	--notifySystem:listenNotify(TIMELINE_EVENT,self,nil)
end