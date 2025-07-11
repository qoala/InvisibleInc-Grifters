local function popUpAction(name, y)
    return {
        name = name,
        isVisible = true,
        noInput = false,
        anchor = 1,
        rotation = 0,
        x = 0,
        xpx = true,
        y = y or 0,
        ypx = true,
        w = 0,
        h = 0,
        sx = 1,
        sy = 1,
        ctor = [[group]],
        children = {
            {
                name = [[img]],
                isVisible = true,
                noInput = false,
                anchor = 1,
                rotation = 0,
                x = 0,
                xpx = true,
                y = 0,
                ypx = true,
                w = 36,
                wpx = true,
                h = 36,
                hpx = true,
                sx = 1,
                sy = 1,
                ctor = [[image]],
                color = {1, 1, 1, 1},
                images = {
                    { --
                        file = [[gui/hud3/hud_icon_button_BG.png]],
                        name = [[]],
                    },
                },
            },
            {
                name = [[btn]],
                isVisible = true,
                noInput = false,
                anchor = 1,
                rotation = 0,
                x = 0,
                xpx = true,
                y = 0,
                ypx = true,
                w = 36,
                wpx = true,
                h = 36,
                hpx = true,
                sx = 1,
                sy = 1,
                skin_properties = {
                    size = {
                        default = { --
                            w = 36,
                            wpx = true,
                            h = 36,
                            hpx = true,
                        },
                        Small = { --
                            w = 36,
                            wpx = true,
                            h = 36,
                            hpx = true,
                        },
                    },
                },
                ctor = [[button]],
                clickSound = [[SpySociety/HUD/menu/click]],
                hoverSound = [[SpySociety/HUD/menu/rollover]],
                hoverScale = 1,
                halign = MOAITextBox.CENTER_JUSTIFY,
                valign = MOAITextBox.CENTER_JUSTIFY,
                text_style = [[]],
                images = {
                    { --
                        file = [[gui/icons/item_icons/items_icon_small/icon-item_chip_hyper_buster_small.png]],
                        name = [[inactive]],
                        color = {1, 1, 1, 0.800000011920929},
                    },
                    { --
                        file = [[gui/icons/item_icons/items_icon_small/icon-item_chip_hyper_buster_small.png]],
                        name = [[hover]],
                        color = {1, 1, 1, 0.800000011920929},
                    },
                    { --
                        file = [[gui/icons/item_icons/items_icon_small/icon-item_chip_hyper_buster_small.png]],
                        name = [[active]],
                    },
                },
            },
            {
                name = [[label]],
                isVisible = true,
                noInput = true,
                anchor = 1,
                rotation = 0,
                x = 150,
                xpx = true,
                y = 0,
                ypx = true,
                w = 256,
                wpx = true,
                h = 36,
                hpx = true,
                sx = 1,
                sy = 1,
                ctor = [[label]],
                halign = MOAITextBox.LEFT_JUSTIFY,
                valign = MOAITextBox.CENTER_JUSTIFY,
                text_style = [[font1_16_r]],
            },
        },
    }
end

local inserts = {
    {
        "hud.lua",
        -- agentPanel > inventoryGroup > inventory >> popUp
        {"widgets", 5, "children", 4, "children", 2, "children", 1, "children"},
        popUpAction([[action5]], 152),
    },
    {
        "hud.lua",
        -- agentPanel > inventoryGroup > inventory >> popUp
        {"widgets", 5, "children", 4, "children", 2, "children", 1, "children"},
        popUpAction([[action6]], 190),
    },
}
return inserts
