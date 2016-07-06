local info = {
    Name = 'Layer',
    ctype = 'GameLayerObjectData',
    Size = { X = 350.000000, Y = 80.000000},
    child = {
        {
            ctype = 'ImageViewObjectData',
            Name = 'I_Chat_Bg',
            Tag = 94 ,
            Position = { x = 175, y = 40},
            Scale = { x = 1.000000, y = 1.000000},
            AnchorPoint = { x = 0.500000, y = 0.500000},
            Size = { x = 350.000000, y = 80.000000},
            PrePosition = { x = 0.500000, y = 0.500000},
            PreSize = { x = 0.364600, y = 0.125000},
            FileData = {
                Type = 'Normal',
                Path = 'res/ui/main/bg.png',
                Plist = '',
            },
        },
    },
}
function info.create()
    return LayoutLoader:createLayout(info)
 end
return info
