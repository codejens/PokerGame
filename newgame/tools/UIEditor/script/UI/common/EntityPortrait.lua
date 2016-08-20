EntityPortrait = simple_class()

local function _getNPCHalfPath(npc_info)
    local sid = npc_info
    return entity_portrait_half_body_path[sid]
end
function EntityPortrait:__init()
    self.view = CCNode:node()
    self.half_body = CCSprite:spriteWithFile('')
    self.half_body:setAnchorPoint(CCPointMake(0.5,0.0))
    self.half_body:setScale(2.0)
    self.texture_name = ''
    self.offset = nil
    self.onLoadCallback = nil
    self.default_view = CCSprite:spriteWithFile('ui/npc_dialog/default_npc_half.png')
    self.view:addChild(self.default_view,-1)
    self.view:addChild(self.half_body,1)
    self.default_view:setAnchorPoint(CCPointMake(0.5,0.0))
    self.default_view:setPosition(CCPointMake(130,0))
end

function EntityPortrait:setPortrait(npc_id, acceptOffset,_loadCallback)
    require "../data/npc"
    local res_id = npc_dialog_config[npc_id];
    if not res_id then
    	--print('>>>>>>>>>>>>>>>>>>>', npc_id)
        return
    end
    
    local tab_npc_info = _getNPCHalfPath(res_id)

    self.onLoadCallback = _loadCallback
    if npc_id > 0 then
        local texture_name   = tab_npc_info[1]
        self.texture_name = texture_name
        if acceptOffset then
            self.offset = tab_npc_info.offset
        else
            self.offset = nil
        end
        LoadImageUnitTextureAsync(texture_name, 
            function(_filename)
                if not _filename then
                    return
                else
                    self:onLoadPortrait(texture_name)
                end
            end)

    elseif npc_id == 0 then
        self.half_body:replaceTexture('')
        self.texture_name = ''
        self.offset = nil
    else
        local texture_name = tab_npc_info[1]
        self.offset = nil
        self.texture_name = texture_name
        LoadImageUnitTextureAsync(self.texture_name, 
            function(_filename)
                if not _filename then
                    return
                else
                    self:onLoadPortrait(texture_name)
                end
            end)
    end
end

function EntityPortrait:onLoadPortrait(loadedTextureName)
    --print(self.texture_name, loadedTextureName)
    if self.half_body then
        if self.texture_name == loadedTextureName then
            self.half_body:setDisplayWithFrameName(self.texture_name)
            if self.offset then
                self.half_body:setPosition(CCPointMake(self.offset[1],self.offset[2]))
            end
            self.default_view:setIsVisible(false)
            if self.onLoadCallback then
           		self.onLoadCallback()
           	end
        end
    end
end

function EntityPortrait:setIsVisible( state )
    self.view:setIsVisible(state)
end

function EntityPortrait:destroy()
    self.view = nil
    self.half_body = nil
end

function EntityPortrait:rightBottomPos(x,y)
    self.half_body:setAnchorPoint(CCPointMake(0.5,0.0))
    self.default_view:setAnchorPoint(CCPointMake(0.5,0.0))
    self.default_view:setPosition(CCPointMake(x,y))
end