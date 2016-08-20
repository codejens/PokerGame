-- Test.lua
-- created by aXing on 2012-11-14
-- 这是一个提供大家测试的模块
-- 提供大家运行各种模块的函数
Test = {}

-- 当且仅当 IS_TEST 标签为true的时候，主函数会运行test这个方法，而且仅会生成游戏根节点，并跳过游戏过程
Test.IS_TEST = false

-- require 'lfs'
-- require 'strbuf'
-- require 'xml'
-- require 'io'
-- require 'math'
-- require 'os'

function widgettest(uimain)

	-- require "UI/component/BasePanel"
	-- require "UI/component/Dialog"
	-- require "UI/component/Label"
	require "ResourceManager"
    -- require "XWidget/__init"
	local __resmgr =  ZXResMgr:sharedManager()
    -- __resmgr:loadUI("ui/common/ui_common1.imageset")
    -- __resmgr:loadUI("ui/common/ui_common2.imageset")
    -- __resmgr:loadUI("ui/common/ui_common3.imageset")
    -- __resmgr:loadUI("ui/main/ui_main1.imageset")
    --__resmgr:loadUI("ui/font_effect/ui_font_effect1.imageset")

    local path = "K:/test_image/*.png"

    -- for file in lfs.dir(path) do
    --     print("file",file)
    --     if file ~= "." and file ~= ".." and file ~= '.svn' then
    --         local f = path..sep..file
    --         local attr = lfs.attributes (f)
    --         assert (type(attr) == "table")
    --         if attr.mode == "directory" then
    --             self:TravelPath (f)
    --         else
    --             local k = string.find(file, ".png")
    --             if k then
    --                 fn = string.sub(file,0,5)
    --                 --print("fn",fn)
    --                 if tonumber(fn) then
    --                     print("f",f);
    --                     print("path",path)
    --                     print("sep",sep)
    --                     print("file",file)
    ZXResMgr:resizeOutPutImage( path, 48, 48 )
        --             end
        --         end
        --     end
        -- end
    -- end
    
end


-- 主程序调用的test方法
function Test:test(root)

	-- --控件测试
	local uimain = CCMainPanel:initPanel()
	root:addChild(uimain)
	uimain:setIsTouchEnabled(true)
	widgettest(uimain)
	local function uimainmsgfun(eventType,x,y)
		if eventType == CCTOUCHBEGAN then 
			return true
		elseif eventType == CCTOUCHMOVED then 
			return
		elseif eventType == CCTOUCHENDED then
			return
		end
	end
	uimain:registerScriptTouchHandler(uimainmsgfun, false, 0, true)

end