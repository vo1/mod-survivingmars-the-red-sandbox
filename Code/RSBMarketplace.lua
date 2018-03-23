DefineClass.RSBMarketplace = {
    __parents = {"SpaceElevator"}
}

function RSBMarketplace.GetData()
    local err, response = AsyncWebRequest({
        url = "http://127.0.0.1:9999/rsb/marketplace/stock",
        method = "GET"
    })
    if not err then
        local data = JSONToLua(response)
        return data
    end
    return {}
end

function RSBMarketplace.UIModifyItem(counter, cnt)
    counter.value = counter.value + cnt
    if counter.max ~= nil and counter.value > counter.max then 
        counter.value = counter.max
    elseif counter.min ~= nil and counter.value < counter.min then
        counter.value = counter.min
    end
    counter:SetText(Untranslated(tostring(counter.value)))
end

function RSBMarketplace.UIRenderListItem(child, context, item, i, n)
    local counter = child:ResolveId("idAmount")
    counter.resourceIdentifier = item.id
    counter.value = 0
    counter.max = 9
    counter.min = -3
    child:ResolveId("idTitle"):SetText(Untranslated(item.title))
    child:ResolveId("idPrice"):SetText(Untranslated(item.price))
    child:ResolveId("idPrice"):SetTextColor(RGBA(200, 0, 0, 255))
    if item.price_type == "deficite" then
        child:ResolveId("idPrice"):SetTextColor(RGBA(0, 255, 0, 255))
    end
    child:ResolveId("idAdd").OnPress = function(self, gamepad)
        RSBMarketplace.UIModifyItem(counter, 1)
    end
    child:ResolveId("idRemove").OnPress = function(self, gamepad)
        RSBMarketplace.UIModifyItem(counter, -1)
    end
end

function OnMsg.ClassesBuilt()
    XTemplates.customRSBMarketplace = PlaceObj("XTemplate", {
        PlaceObj("XTemplateTemplate",
            { "__template", "InfopanelSection", "Title", Untranslated("Request resources"), "Icon", "UI/Icons/Sections/deposit.tga" },
            {
                PlaceObj("XTemplateWindow",
                    {"__class", "XList",
                    "Id", "idList",
--                    "Margins", box(-60, 10, 0, 10),
                    "BorderWidth", 0,
                    "LayoutVSpacing", 10,
                    "UniformRowHeight", true,
                    "Clip", false,
                    "Background", RGBA(0, 0, 0, 0),
                    "FocusedBackground", RGBA(0, 0, 0, 0),
                    "VScroll", "idScroll",
                    "ShowPartialItems", false,
                    "MouseScroll", false
                    },
                    {
                        PlaceObj("XTemplateForEach",
                            { 
                                "array", function(parent, context) 
                                    return context:GetData()
                                end,
                                "run_after", RSBMarketplace.UIRenderListItem
                            },
                            {
                                PlaceObj(
                                    "XTemplateWindow",
                                    {"LayoutMethod", "HList", "Id", "idCnt"},
                                    {
                                        PlaceObj("XTemplateTemplate", {"__template", "InfopanelText", "Id", "idTitle", "TextFont", "PGResource"}),
                                        PlaceObj(
                                            "XTemplateWindow",
                                            {"Dock", "right", "LayoutMethod", "HList", "Margins", box(20, 10, 0, 0)},
                                            {
                                                PlaceObj("XTemplateTemplate", {"__template", "InfopanelText", "Id", "idPrice", "TextFont", "PGResource"}),
                                                PlaceObj("XTemplateWindow", {"__class", "XTextButton", "Id", "idRemove", "HAlign", "left", "VAlign", "center", "MouseCursor", "UI/Cursors/Rollover.tga", "FXMouseIn", "RocketRemoveCargoHover", "FXPress", "RocketRemoveCargoClick", "RepeatStart", 300, "RepeatInterval", 300, "OnPress", RSBMarketplace.UIRemoveItem, "Image", "UI/Infopanel/arrow_remove.tga", "ColumnsUse", "abcc"}),
                                                PlaceObj("XTemplateWindow", {"__class", "XText", "Id", "idAmount", "Text", Untranslated("0"), "Padding", box(2, 2, 5, 2), "HAlign", "right", "VAlign", "center", "MinWidth", 30, "MaxWidth", 50, "TextFont", "PGResource", "TextColor", RGBA(255, 248, 233, 255), "RolloverTextColor", RGBA(255, 255, 255, 255), "WordWrap", false, "TextHAlign", "right", "TextVAlign", "center"}),
                                                PlaceObj("XTemplateWindow", {"__class", "XTextButton", "Id", "idAdd", "HAlign", "right", "VAlign", "center", "MouseCursor", "UI/Cursors/Rollover.tga", "FXMouseIn", "RocketRemoveCargoHover", "FXPress", "RocketRemoveCargoClick", "RepeatStart", 300, "RepeatInterval", 300, "Image", "UI/Infopanel/arrow_add.tga", "ColumnsUse", "abcc"})
                                            }
                                        )
                                    }
                                )
                            }
                        )
                    }
                )
            }
        ),
        group = "Infopanel Sections",
        id = "customRSBMarketplace"
    })
end
