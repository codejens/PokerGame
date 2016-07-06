local info = {
    Name = 'Layer',
    ctype = 'GameLayerObjectData',
    Size = { X = 200.000000, Y = 150.000000},
    child = {
        {
            ctype = 'ListViewObjectData',
            Name = 'LV_Task',
            Tag = 180 ,
            TouchEnable = true,
            Scale = { x = 1.000000, y = 1.000000},
            AnchorPoint = { x = 0, y = 0},
            Size = { x = 200.000000, y = 150.000000},
            PreSize = { x = 0.208300, y = 0.234400},
            ClipAble = true,
            ComboBoxIndex = 1 ,
            BackColorAlpha = 0 ,
            Scale9Width = 1.000000,
            Scale9Height = 1.000000,
            SingleColor = {r = 150, g = 150, b = 255},
            FirstColor = {r = 150, g = 150, b = 255},
            ColorVector = { x = 0.000000, y = 1.000000},
            DirectionType = 1,
            VerticalType = 0,
        },
    },
}
function info.create()
    return LayoutLoader:createLayout(info)
 end
return info
