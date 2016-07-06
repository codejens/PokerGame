local info = {
    Name = 'user_page',
    ctype = 'GameLayerObjectData',
    Size = { X = 810.000000, Y = 569.000000},
    child = {
        {
            ctype = 'ProjectNodeObjectData',
            Name = 'bag_block',
            Tag = 332 ,
            LeftMargin = 400.000000,
            TopMargin = 9.000000,
            Position = { x = 400, y = 0},
            Scale = { x = 1.000000, y = 1.000000},
            AnchorPoint = { x = 0, y = 0},
            Size = { x = 410.000000, y = 560.000000},
            PrePosition = { x = 0.493800, y = 0.000000},
            PreSize = { x = 0.506200, y = 0.984200},
            InnerActionSpeed = 1.000000,
            FileData = {
                Type = 'Normal',
                Path = 'layout/studio/common/user/stu_user_page_bag.lua',
                Plist = '',
            },
        },
        {
            ctype = 'ProjectNodeObjectData',
            Name = 'equip_block',
            Tag = 377 ,
            RightMargin = 410.000000,
            TopMargin = 9.000000,
            Scale = { x = 1.000000, y = 1.000000},
            AnchorPoint = { x = 0, y = 0},
            Size = { x = 400.000000, y = 560.000000},
            PreSize = { x = 0.493800, y = 0.984200},
            InnerActionSpeed = 1.000000,
            FileData = {
                Type = 'Normal',
                Path = 'layout/studio/common/user/stu_user_page_attr.lua',
                Plist = '',
            },
        },
    },
}
function info.create()
    return LayoutLoader:createLayout(info)
 end
return info
