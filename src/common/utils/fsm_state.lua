FSMState = simple_class()

function FSMState:__init()
end

--进入世界
--注册监听世界时间线推进
function FSMState:enter(FSM,oldstate,data)

end

--离开世界
function FSMState:leave(FSM,newState,data)
end

--ticking
function FSMState:tick(FSM,dt)
end
