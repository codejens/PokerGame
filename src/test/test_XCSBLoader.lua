module(...,package.seeall)

local _priority = ASYNC_PRIORITY.ANIMATION

function test_XCSBLoader(view)
	local filename = 'cocos/animation/slots/body/b0000/Node.csb'
	--异步加载,图片资源
	resourceHelper.loadCSBTextureAsync(filename,filename,_priority,
	function(res, customID, skinname)
		if res == 0 then
			local data = resourceHelper.loadCSB(filename,true,false)
			local node = data:getNode()
			local timeline = data:getTimeline()
			timeline:play('attack1',true)
			node:runAction(timeline)
			view:addChild(node)
		end
	end)
end

function startTest(root)
  	test_XCSBLoader(root)
end