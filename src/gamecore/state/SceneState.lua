------------------------------
-- !class SceneState
-- @author lyl
-- @release 1
-- @gameStateManager
-- 进入场景（游戏中）状态
--
------------------------------
SceneState = { id = 'SceneState' }

function SceneState:enter(oldstate)
    --print('loginState:enter')
    baseState.enter(self)

    -- 初始化场景管理器
    require 'gamecore.scene.SceneManager'
    SceneManager:init()
    EntityManager:init()
    -- 通知中心初始化
    notifySystem:init()
    -- 测试
    --SceneManager:enter_scene( 0, 11, 0, 0, 0, "天元城", "tyc" )

    SceneState:init_system_control(  )
    
end

function SceneState:leave()
    --print('loginState:leave')
    baseState.leave(self)
end

function SceneState:onTimeline()
    print('SceneState:onTimeline')
end

function SceneState:startGame(sid)
    -- gameStateManager:setState(newScenarioState, { scenario_id = 1, save_id = 255 } )
end

-- 初始化
function SceneState:init_system_control(  )
    BagCC:init(  )
    DefaultSystemCC:init( )
    SkillSystemCC:init(  )
    TaskCC:init(  )
end
