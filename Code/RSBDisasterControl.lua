DefineClass.RSBDisasterWorkshiftControl = {
    __parents =  {"ShiftsBuilding"}
}

DefineClass.RSBSolarPanel = {
    __parents = {"SolarPanel", "RSBDisasterWorkshiftControl"}
}

DefineClass.RSBSolarPanelBig = {
    __parents = {"SolarPanelBig", "RSBDisasterWorkshiftControl"}
}

DefineClass.RSBWindTurbine = {
    __parents = {"WindTurbine", "RSBDisasterWorkshiftControl"}
}

DefineClass.RSBStirlingGenerator = {
    __parents = {"StirlingGenerator", "RSBDisasterWorkshiftControl"}
}

DefineClass.RSBSubsurfaceHeater = {
    __parents = {"SubsurfaceHeater", "RSBDisasterWorkshiftControl"}
}

local oldUIWorkshiftUpdate = nil

function HideVanillaTech()
    LockBuilding("SolarPanel")
    LockBuilding("SolarPanelBig")
    LockBuilding("WindTurbine")
    LockBuilding("StirlingGenerator")
    LockBuilding("SubsurfaceHeater")
end

OnMsg.PostNewMapLoaded = function()
    HideVanillaTech()
    if oldUIWorkshiftUpdate == nil then
        oldUIWorkshiftUpdate = UIWorkshiftUpdate
    end

    UIWorkshiftUpdate = function(self, building, shift)
        oldUIWorkshiftUpdate(self, building, shift)
        if building:IsKindOf("RSBDisasterWorkshiftControl") then
            local shift_active = building:IsShiftUIActive(shift)
            local shift_closed = building:IsClosedShift(shift)
            if shift == 1 then
                local title = "Normal operation"
                if (shift_closed) then
                    title = "<red>" .. title .. "</red>"
                elseif (shift_active) then
                    title = "<green>" .. title .. "</green>"
                end
                self:SetTitle(T({title, UICity}))
                self:SetRolloverTitle("Normal operation")
            elseif shift == 2 then
                local title = "Dust storm shift"
                if (shift_closed) then
                    title = "<red>" .. title .. "</red>"
                elseif (shift_active) then
                    title = "<green>" .. title .. "</green>"
                end
                self:SetTitle(T({title, UICity}))
                self:SetRolloverTitle("Dust storm shift")
            elseif shift == 3 then
                local title = "Cold wave shift"
                if (shift_closed) then
                    title = "<red>" .. title .. "</red>"
                elseif (shift_active) then
                    title = "<green>" .. title .. "</green>"
                end
                self:SetTitle(T({title, UICity}))
                self:SetRolloverTitle("Cold wave shift")
            end
        end
    end
end

RSBDisasterWorkshiftControl.SetWorkshift = function(self, shift)
    if g_DustStorm then
        (ShiftsBuilding.SetWorkshift)(self, 2)
    elseif g_ColdWave then
        (ShiftsBuilding.SetWorkshift)(self, 3)
    else 
        (ShiftsBuilding.SetWorkshift)(self, 1)
    end
end



