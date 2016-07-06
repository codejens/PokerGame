local info = {
    Name = 'Layer',
    ctype = 'GameLayerObjectData',
    Size = { X = 66.000000, Y = 66.000000},
    child = {
        {
            ctype = 'ImageViewObjectData',
            Name = 'I_Bag_Bg',
            Tag = 91 ,
            Position = { x = 33, y = 33},
            Scale = { x = 1.000000, y = 1.000000},
            AnchorPoint = { x = 0.500000, y = 0.500000},
            Size = { x = 66.000000, y = 66.000000},
            PrePosition = { x = 0.500000, y = 0.500000},
            PreSize = { x = 0.068800, y = 0.103100},
            FileData = {
                Type = 'Normal',
                Path = 'res/ui/main/icon_bg.png',
                Plist = '',
            },
            child = {
                {
                    ctype = 'ButtonObjectData',
                    Name = 'B_Bag',
                    Tag = 92 ,
                    TouchEnable = true,
                    LeftMargin = 7.652300,
                    RightMargin = 9.347700,
                    TopMargin = -1.708300,
                    BottomMargin = 0.708300,
                    Position = { x = 32, y = 34},
                    Scale = { x = 1.000000, y = 1.000000},
                    AnchorPoint = { x = 0.500000, y = 0.500000},
                    Size = { x = 49.000000, y = 67.000000},
                    PrePosition = { x = 0.487200, y = 0.518300},
                    PreSize = { x = 0.742400, y = 1.015200},
                    Scale9Enable = true,
                    Scale9Width = 49.000000,
                    Scale9Height = 67.000000,
                    FontSize = 14 ,
                    TextColor = {r = 65, g = 65, b = 70},
                    DisabledFileData = {
                        Type = 'Normal',
                        Path = 'res/ui/main/bag.png',
                        Plist = '',
                    },
                    PressedFileData = {
                        Type = 'Normal',
                        Path = 'res/ui/main/bag.png',
                        Plist = '',
                    },
                    NormalFileData = {
                        Type = 'Normal',
                        Path = 'res/ui/main/bag.png',
                        Plist = '',
                    },
                },
            },
        },
    },
}
function info.create()
    return LayoutLoader:createLayout(info)
 end
return info
