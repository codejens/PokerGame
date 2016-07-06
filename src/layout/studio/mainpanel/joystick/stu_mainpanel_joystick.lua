local info = {
    Name = 'Layer',
    ctype = 'GameLayerObjectData',
    Size = { X = 187.000000, Y = 187.000000},
    child = {
        {
            ctype = 'ButtonObjectData',
            Name = 'Button_2',
            Tag = 20 ,
            TouchEnable = true,
            LeftMargin = -0.000100,
            RightMargin = 0.000100,
            TopMargin = -0.909100,
            BottomMargin = 0.909100,
            Position = { x = 0, y = 0},
            Scale = { x = 1.000000, y = 1.000000},
            AnchorPoint = { x = 0, y = 0},
            Size = { x = 187.000000, y = 187.000000},
            PrePosition = { x = 0.000000, y = 0.004900},
            PreSize = { x = 1.438500, y = 1.438500},
            Scale9Enable = true,
            Scale9Width = 187.000000,
            Scale9Height = 187.000000,
            FontSize = 14 ,
            TextColor = {r = 65, g = 65, b = 70},
            DisabledFileData = {
                Type = 'Normal',
                Path = 'res/ui/main/joystick_bg.png',
                Plist = '',
            },
            PressedFileData = {
                Type = 'Normal',
                Path = 'res/ui/main/joystick_bg.png',
                Plist = '',
            },
            NormalFileData = {
                Type = 'Normal',
                Path = 'res/ui/main/joystick_bg.png',
                Plist = '',
            },
            OutlineColor = {r = 255, g = 0, b = 0},
            ShadowColor = {r = 255, g = 127, b = 80},
        },
        {
            ctype = 'ImageViewObjectData',
            Name = 'Image_1',
            Tag = 21 ,
            LeftMargin = 34.500000,
            RightMargin = 34.500000,
            TopMargin = 35.500000,
            BottomMargin = 35.500000,
            Position = { x = 93, y = 93},
            Scale = { x = 1.000000, y = 1.000000},
            AnchorPoint = { x = 0.500000, y = 0.500000},
            Size = { x = 118.000000, y = 116.000000},
            PrePosition = { x = 0.500000, y = 0.500000},
            PreSize = { x = 0.631000, y = 0.620300},
            FileData = {
                Type = 'Normal',
                Path = 'res/ui/main/joystick.png',
                Plist = '',
            },
        },
    },
}
function info.create()
    return LayoutLoader:createLayout(info)
 end
return info
