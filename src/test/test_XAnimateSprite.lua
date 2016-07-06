module(...,package.seeall)

function test_XAnimateSprite(root)

     --[[
      XAnimateSprite 动作定义
      
      actions 里面记录的每个动作的定义
      "restoreOriginalFrame" : false,    默认false，当动画播放完毕时，是否恢复到初始帧
      "loop" : 1,   循环次数默认 1
      "delay" : -1, 播放速度，如果是正数就是每帧间隔，如果是负数就是指动画时长
          比如说一个动画有5帧，希望1秒播完，[delay] 可以填写-1,或者1/5 = 0.2
      "frames" 有几种定义方法
        
        1. "frames" : { "start": 28, "end": 35 } 
            从第28帧播放到35帧
        
        2. "frames": [ [11,1.5,""], [12,0.5,"123"] ]  
            依次播放11,12帧，他们的[每帧间隔乘数],分别是1.5, 0.5, 第12帧有帧事件"1,2,3"
        
        3. "frames" : [ 1,2,3,4,5 ] 
            依次播放1,2,3,4,5  [每帧间隔乘数] 1.0, 
        
        解释 [每帧间隔乘数] 比如说上面[delay]是0.2也就是说每一帧播放时长是0.2秒
        最终帧的速度 = [每帧间隔乘数] X [delay]

    ]]

   ----------------------------------------------------------
    local sprite = ccsext.XAnimateSprite:create()
    --[[
    /**
    @brief 初始化精灵皮肤和动画配置
    @param skinName     皮肤文件，plist
    @param actionFile   动作文件
    @param actionID     动作ID
    @param repeatforever  永远执行
    @return bool
    */
    ]]
    sprite:initWithActionFile('animations/test',"animations/test/action.json")
    sprite:playAction(1,false)
    root:addChild(sprite,255)
    sprite:setPosition(100,450)
    ----------------------------------------------------------

    ----------------------------------------------------------
    --[[/**
    @brief 
    @param skinName     皮肤文件，plist
    @param actionFile   动作json
    @param actionID     动作ID
    @param repeatforever  永远执行
    @return bool
    */]]

    local sprite = ccsext.XAnimateSprite:create()
    --定义一个帧列表
    local _json = [[
    {
      "actions": {
          "0": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : -1,
              "frames": { "start": 28, "end": 35 }
          }
      }
    }
    ]]
    sprite:initWithActionJson('animations/test',_json)
    sprite:playAction(0,false)
    root:addChild(sprite,255)
    sprite:setPosition(200,450)

    ----------------------------------------------------------

    ----------------------------------------------------------
    local sprite = ccsext.XAnimateSprite:create()
    --定义一个帧列表
    local _json = [[
    {
      "actions": {
          "1": {
              "restoreOriginalFrame" : false,
              "loop" : 4,
              "delay" : 0.5,
              "frames": [ 0,2,4,6,8,10,12,14,16,18,20 ]
          }
      }
    }
    ]]
    sprite:initWithActionJson('animations/test',_json)
    sprite:playAction(1,false)
    root:addChild(sprite,255)
    sprite:setPosition(300,450)

    ----------------------------------------------------------
    --每帧定义
    local sprite = ccsext.XAnimateSprite:create()
    --监听帧事件
    cocosEventHelper.listenFrameEvent(sprite,
        function(id, event) 
          print(id) 
          if event then
            -- [i] = 第几帧
            -- [e] = 事件字符串
            -- [f] = 帧的名字 --只有在debug模式下才有
            -- [t] = 纹理名字 --只有在debug模式下才有
            for k,v in pairs(event) do
              print('    ',k,v)
            end
          end
        end)

    local _json = [[
    {
      "actions": {
          "255": {
              "restoreOriginalFrame" : false,
              "loop" : 4,
              "delay" : -1,
              "frames": [ [11,1.0,""],
                          [10,1.0,""],
                          [9,1.0,""],
                          [8,1.0,""],
                          [7,1.0,""],
                          [6,1.0,""],
                          [5,1.0,""],
                          [4,1.0,"12345"] ]
          }
      }
    }
    ]]
    sprite:initWithActionJson('animations/test',_json)
    sprite:playAction(255,false)
    root:addChild(sprite,255)
    sprite:setPosition(400,450)
end

function startTest(root)
  test_XAnimateSprite(root)
end