function OnMsg.ClassesBuilt()
    XTemplates.customRSBMarketplace = PlaceObj(
        "XTemplate", 
        {
            PlaceObj(
                "XTemplateTemplate",
                {"__context_of_kind", "RSBMarketplace", "__template", "InfopanelSection", "RolloverText", T({535, "Progress creating the next clone."}), "RolloverTitle", T({534, "Cloning progress"}), "Icon", "UI/Icons/Sections/colonist.tga"},
                {PlaceObj("XTemplateTemplate", {"__template", "InfopanelProgress", "BindTo", "CloningProgress"})}
            );
            group = "Infopanel Sections",
            id = "customRSBMarketplace"
        }
    )
end