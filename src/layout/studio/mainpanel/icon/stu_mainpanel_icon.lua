local info = {
    Name = 'Layer',
    ctype = 'GameLayerObjectData',
    Size = { X = 300.000000, Y = 150.000000},
    child = {
        {
            ctype = 'PanelObjectData',
            Name = 'P_Icon_Bg',
            Tag = 148 ,
            Scale = { x = 1.000000, y = 1.000000},
            AnchorPoint = { x = 0, y = 0},
            Size = { x = 300.000000, y = 150.000000},
            PreSize = { x = 0.312500, y = 0.234400},
            ComboBoxIndex = 1 ,
            BackColorAlpha = 0 ,
            Scale9Width = 50.000000,
            Scale9Height = 50.000000,
            SingleColor = {r = 150, g = 200, b = 255},
            FirstColor = {r = 150, g = 200, b = 255},
            ColorVector = { x = 0.000000, y = 1.000000},
            FileData = {
                Type = 'Normal',
                Path = 'res/ui/main/blank.png',
                Plist = '',
            },
        },
    },
}
function info.create()
    return LayoutLoader:createLayout(info)
 end
return info
