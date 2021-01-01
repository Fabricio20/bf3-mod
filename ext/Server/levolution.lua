levolution_triggered = false
trigger_points = {}

--- Resets the internal tracking for levolution
function Levolution_Clear()
    levolution_triggered = false
    trigger_points = {}
    print('[Levolution] Cleared state.')
end

--- Starts the levolution event
function Levolution_Start()
    local tickets = TicketManager:GetTicketCount(1)
    if tickets == nil or tickets < 10 then
        print('[Levolution] Too little tickets')
        levolution_triggered = true
        return
    end
    TicketManager:SetTicketCount(1, 10)
    TicketManager:SetTicketCount(1, tickets)
    levolution_triggered = true
    print('[Levolution] Triggered!')
end

--- Attempts to trigger levolution
function Levolution_Trigger(entity, hit, giverInfo)
    -- Already triggered
    if levolution_triggered == true then
        return
    end
    -- Null checks
    if hit.rigidBody == nil or hit.material == nil then
        return
    end
    -- Material checks
    local material = hit.material
    if material.partition == nil or material.partition.guid == nil or material.instanceGuid == nil then
        return
    end
    -- Trigger on all maps
    Levolution_CaspianBorder(material, hit.rigidBody.instanceId)
end

--- Checks if levolution should be triggered on Caspian Border
function Levolution_CaspianBorder(material, instanceId)
    if material.partition.guid:ToString('D') ~= 'B50615C2-4743-4919-9A40-A738150DEBE9' then
        return
    end
    if material.instanceGuid:ToString('D') ~= '62FCABA4-73FF-4FBD-B873-E8CDFFB01EA1' then
        return
    end

    -- If this feet was already shot
    if has_value(trigger_points, tostring(instanceId)) then
        return
    end
    table.insert(trigger_points, tostring(instanceId));

    -- If all 6 tower feets were shot, start levolution
    if #trigger_points == 6 then
        Levolution_Start()
    end
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
