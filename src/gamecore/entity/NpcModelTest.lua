--NpcModelTest.lua

NpcModelTest = simple_class(MonsterModelTest)

--动作config = {}
local _json = [[
    {
      "actions": {
          "0": {
              "restoreOriginalFrame" : false,
              "loop" : 3,
              "delay" : 0.75,
              "frames": { "start": 0, "end": 2 }
          }
        }
    }
]]

function NpcModelTest:__init( handle )

end

function NpcModelTest:createBody(  )
	self.body = ccsext.XAnimateSprite:create()
	self.body:initWithActionJson('animations/npc',_json)
  self.body:playAction(0,true)
	self.body:setPosition(0,0)
	self.model_root:addChild( self.body )
end