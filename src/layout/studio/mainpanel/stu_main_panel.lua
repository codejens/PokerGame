local info = {
    Name = 'Layer',
    ctype = 'GameLayerObjectData',
    Size = { X = 960.000000, Y = 640.000000},
}
function info.create()
    return LayoutLoader:createLayout(info)
 end
return info
