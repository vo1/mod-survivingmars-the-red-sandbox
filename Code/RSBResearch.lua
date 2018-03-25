const.mediumGameSpeed = 5
const.fastGameSpeed = 10
function OnMsg.TechResearched(tech_id, city, first_time)
    if RSBResearchMap[tech_id] ~= nil then 
        local RSBTech = TechDef[tech_id]
        local tech = RollTech(tech_id)
        local functionName = (string.gsub)(tech_id, "RSBBreakthrough", "RSBGrant")
        if IsTechDiscovered(tech) then
            pcall(_G[functionName], RSBTech)
        else
            AddCustomOnScreenNotification("Discovery", "Breakthrough", "Discovered " .. tech)
            DiscoverTech(tech)
        end
    end
end

-- Rolls tech from RSBResearchMap
function RollTech(tech_id)
    return (table.rand)(RSBResearchMap[tech_id])
end

-- Social increases funding by tech.param5
function RSBGrantSocial(tech)
    RSBIncreaseFunding(tech)
end

-- Increases research per electricity unit gain by tech.param1 up to tech.param2
function RSBGrantPhysics(tech)
    if not IsTechDiscovered("SuperconductingComputing") then
        DiscoverTech("SuperconductingComputing")
    end
    if not IsTechResearched("SuperconductingComputing") then 
        GrantTech("SuperconductingComputing")
        g_Consts.ElectricityForResearchPoint = tech.param3
    end
    if (g_Consts.ElectricityForResearchPoint > tech.param2) then
        g_Consts.ElectricityForResearchPoint = g_Consts.ElectricityForResearchPoint - tech.param1
        AddCustomOnScreenNotification("RSB","Advanced research", "We get more research points per electricity unit.")
    else
        RSBIncreaseFunding(tech)
    end
end

-- Robotics increases auto_pefrormance by tech.param1 up to tech.param2
function RSBGrantRobotics(tech)
    if g_Consts.RSBRoboticsPerformanceBonus == nil then
        g_Consts.RSBRoboticsPerformanceBonus = 0
    end
    
    if g_Consts.RSBRoboticsPerformanceBonus < tech.param2 then
        g_Consts.RSBRoboticsPerformanceBonus = g_Consts.RSBRoboticsPerformanceBonus + tech.param1
        AddCustomOnScreenNotification("RSB", "Advanced research", "Granted " .. tech.param1 .. "% to automated performance (now " .. g_Consts.RSBRoboticsPerformanceBonus .. "%)")
    else
        RSBIncreaseFunding(tech)
    end
end

-- Decreases food consumption by tech.param1 down to tech.param2, grants funding on limit
function RSBGrantBiotech(tech)
    if (g_Consts.eat_food_per_visit / 2) < tech.param2 then
        g_Consts.eat_food_per_visit = g_Consts.eat_food_per_visit - tech.param1 * 2
        AddCustomOnScreenNotification("RSB", "Advanced research", "Our colonists consume " .. tech.param1 .. "% less food from now.")
    else
        RSBIncreaseFunding(tech)
    end
end

-- Engineering so far grants funding
function RSBGrantEngineering(tech)
    RSBIncreaseFunding(tech)
end

-- Increases funding from tech.param5
function RSBIncreaseFunding(tech)
    AddCustomOnScreenNotification("RSB","Advanced research", "Granted " .. tech.param5 .. "% to all fundings (now " .. g_Consts.FundingGainsModifier .. "%)")
    g_Consts.FundingGainsModifier = g_Consts.FundingGainsModifier + tech.param5
end

function OnMsg.NewHour()
    for _, workplace in ipairs(UICity.labels.Workplace or empty_table) do
        if workplace.auto_performance ~= nil then
            if workplace.default_auto_performance == nil then
                workplace.default_auto_performance = workplace.auto_performance
            end
            workplace.auto_performance = workplace.default_auto_performance + g_Consts.RSBRoboticsPerformanceBonus
            workplace.UpdatePerformance()
        end
    end
end