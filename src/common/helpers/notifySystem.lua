notifySystem = {}

local s_handle = 0
--通知系统
function notifySystem:init()
	print('notifySystem:init()')
	self._notify_listeners = {}
	self._notify_interal = {}
end

--注册内部通知，将不会被cleanup
function notifySystem:registerInternalNotify(notify_id)
	self._notify_interal[notify_id] = true
end

--发布一个通知
function notifySystem:postNotify(notify_id,...)
	local notify = self._notify_listeners[notify_id]
	if notify then
		for obj, func in pairs(notify) do
			func(obj,...)
		end
	else
		cclog('nobody listens %s',notify_id)
	end
end

--监听一个通知
function notifySystem:listenNotify(notify_id,obj,func)
	local notify = self._notify_listeners[notify_id]
	if not notify then
		notify = {}
		self._notify_listeners[notify_id] = notify
	end
	notify[obj] = func
end

function notifySystem.getNewHandler()
	s_handle = s_handle + 1
	return s_handle 
end

function notifySystem:cleanup()
	for notify_id, notify in pairs(self._notify_listeners) do
		if not self._notify_interal[notify_id] then
			self._notify_listeners[notify_id] = nil
		end
	end
end