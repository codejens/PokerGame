
--add LuaScript to search path.
cc.FileUtils:getInstance():addSearchPath('LuaScript/')

-- used as metaTable
local luaExtend = {}

local function getChildInSubNodes(nodeTable, key)
    if #nodeTable == 0 then
        return nil
    end
    local child = nil
    local subNodeTable = {}
    for _, v in ipairs(nodeTable) do
        child = v:getChildByName(key)
        if (child) then
            return child
        end
    end
    for _, v in ipairs(nodeTable) do
        local subNodes = v:getChildren()
        if #subNodes ~= 0 then
            for _, v1 in ipairs(subNodes) do
                table.insert(subNodeTable, v1)
            end
        end
    end
    return getChildInSubNodes(subNodeTable, key)
end

luaExtend.__index = function(table, key)
local root = table.root
local child = root[key]
    if child then
        return child
    end

    child = root:getChildByName(key)
    if child then
        root[key] = child
        return child
    end

    child = getChildInSubNodes(root:getChildren(), key)
    if child then root[key] = child end
    return child
end
-- used as metaTable

-- PositionFrame create
luaExtend.CreatePositionFrame = function(frameIndex, tween, x, y, node)
    local frame = ccs.PositionFrame:create()
    frame:setFrameIndex(frameIndex)
    frame:setTween(tween)
    frame:setX(x)
    frame:setY(y)
    frame:setNode(node)
    return frame
end
-- PositionFrame create

-- VisibleFrame create
luaExtend.CreateVisibleFrame = function(frameIndex, tween, visible, node)
    local frame = ccs.VisibleFrame:create()
    frame:setFrameIndex(frameIndex)
    frame:setTween(tween)
    frame:setVisible(visible)
    frame:setNode(node)
    return frame
end
-- VisibleFrame create

-- ColorFrame create
luaExtend.CreateColorFrame = function(frameIndex, tween, color, node)
    local frame = ccs.ColorFrame:create()
    frame:setFrameIndex(frameIndex)
    frame:setTween(tween)
    frame:setColor(color)
    frame:setNode(node)
    return frame
end
-- ColorFrame create

-- EventFrame create
luaExtend.CreateEventFrame = function(frameIndex, tween, event, node)
    local frame = ccs.EventFrame:create()
    frame:setFrameIndex(frameIndex)
    frame:setTween(tween)
    frame:setEvent(event)
    frame:setNode(node)
    return frame
end
-- EventFrame create

-- InnerActionFrame create
luaExtend.CreateInnerActionFrame = function(frameIndex, tween, innerActionType, animationName,  singleFrameIndex, node)
    local frame = ccs.InnerActionFrame:create()
    frame:setFrameIndex(frameIndex)
    frame:setTween(tween)
    frame:setInnerActionType(innerActionType)
    if innerActionType == 2 then
    	frame:setSingleFrameIndex(singleFrameIndex)
    else
        frame:setEnterWithName(true)
        frame:setAnimationName(animationName)
    end

    frame:setNode(node)
    return frame
end
-- InnerActionFrame create

-- AlphaFrame create
luaExtend.CreateAlphaFrame = function(frameIndex, tween, alpha, node)
    local frame = ccs.AlphaFrame:create()
    frame:setFrameIndex(frameIndex)
    frame:setTween(tween)
    frame:setAlpha(alpha)
    frame:setNode(node)
    return frame
end
-- AlphaFrame create

-- ZOrderFrame create
luaExtend.CreateZOrderFrame = function(frameIndex, tween, zOrder, node)
    local frame = ccs.ZOrderFrame:create()
    frame:setFrameIndex(frameIndex)
    frame:setTween(tween)
    frame:setZOrder(zOrder)
    frame:setNode(node)
    return frame
end
-- ZOrderFrame create

-- ScaleFrame create
luaExtend.CreateScaleFrame = function(frameIndex, tween, scaleX, scaleY, node)
    local frame = ccs.ScaleFrame:create()
    frame:setFrameIndex(frameIndex)
    frame:setTween(tween)
    frame:setScaleX(scaleX)
    frame:setScaleY(scaleY)
    frame:setNode(node)
    return frame
end
-- ScaleFrame create

-- RotationSkewFrame create
luaExtend.CreateRotationSkewFrame = function(frameIndex, tween, skewX, skewY, node)
    local frame = ccs.RotationSkewFrame:create()
    frame:setFrameIndex(frameIndex)
    frame:setTween(tween)
    frame:setSkewX(skewX)
    frame:setSkewY(skewY)
    frame:setNode(node)
    return frame
end
-- RotationSkewFrame create

-- AnchorPointFrame create
luaExtend.CreateAnchorPointFrame = function(frameIndex, tween, anchorPoint, node)
    local frame = ccs.AnchorPointFrame:create()
    frame:setFrameIndex(frameIndex)
    frame:setTween(tween)
    frame:setAnchorPoint(anchorPoint)
    frame:setNode(node)
    return frame
end
-- AnchorPointFrame create

-- TextureFrame create
luaExtend.CreateTextureFrame = function(frameIndex, tween, textureFilePath, node)
    local frame = ccs.TextureFrame:create()
    frame:setFrameIndex(frameIndex)
    frame:setTween(tween)
    frame:setTextureName(textureFilePath)
    frame:setNode(node)
    return frame
end
-- TextureFrame create

return luaExtend
