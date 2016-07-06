local info = {
    Name = 'Layer',
    ctype = 'GameLayerObjectData',
    Size = { X = 960.000000, Y = 8.000000},
    child = {
        {
            ctype = 'ImageViewObjectData',
            Name = 'I_Exp_Bg',
            Tag = 96 ,
            Position = { x = 480, y = 4},
            Scale = { x = 1.000000, y = 1.000000},
            AnchorPoint = { x = 0.500000, y = 0.500000},
            Size = { x = 960.000000, y = 8.000000},
            PrePosition = { x = 0.500000, y = 0.500000},
            PreSize = { x = 1.000000, y = 0.012500},
            FileData = {
                Type = 'Normal',
                Path = 'res/ui/main/exp_bg.png',
                Plist = '',
            },
            child = {
                {
                    ctype = 'LoadingBarObjectData',
                    Name = 'LB_Exp',
                    Tag = 97 ,
                    TopMargin = 2.000000,
                    Position = { x = 480, y = 3},
                    Scale = { x = 1.000000, y = 1.000000},
                    AnchorPoint = { x = 0.500000, y = 0.500000},
                    Size = { x = 960.000000, y = 6.000000},
                    PrePosition = { x = 0.500000, y = 0.375000},
                    PreSize = { x = 1.000000, y = 0.750000},
                    ImageFileData = {
                        Type = 'Normal',
                        Path = 'res/ui/main/exp.png',
                        Plist = '',
                    },
                },
                {
                    ctype = 'ImageViewObjectData',
                    Name = 'I_Exp_Text',
                    Tag = 98 ,
                    LeftMargin = -0.500200,
                    RightMargin = 933.500200,
                    TopMargin = -1.500000,
                    BottomMargin = 0.500000,
                    Position = { x = 12, y = 5},
                    Scale = { x = 1.000000, y = 1.000000},
                    AnchorPoint = { x = 0.500000, y = 0.500000},
                    Size = { x = 27.000000, y = 9.000000},
                    PrePosition = { x = 0.013500, y = 0.625000},
                    PreSize = { x = 0.028100, y = 1.125000},
                    FileData = {
                        Type = 'Normal',
                        Path = 'res/ui/main/exp_string.png',
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
