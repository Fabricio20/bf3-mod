require('WeaponsAPI')
require('levolution')

Events:Subscribe('Level:Loaded', function()
    print('Detected level load.')
    Levolution_Clear()

    -- Firing functions for Glock-18
    local firingsGlock18 = WeaponsAPI_findAllFiringFunctionData('3B3F9879-EB4B-11DF-8AA6-AE0344995412')
    if #firingsGlock18 ~= 0 then
        for i = 1, #firingsGlock18 do
            local data = firingsGlock18[i]
            data:MakeWritable()
            WeaponsAPI_ChangeProjectile(data, 'CEC6D381-72DE-B7D4-E998-0D566E0575C6')
        end
    end
    print('Modified Glock-18 successfully.')

    -- Firing functions for UMP-45
    local firingFunctions = WeaponsAPI_findAllFiringFunctionData('13D445F7-EBE3-11DF-91EC-895E59A6915B')
    if #firingFunctions ~= 0 then
        for i = 1, #firingFunctions do
            local data = firingFunctions[i]
            data:MakeWritable()
            WeaponsAPI_ChangeProjectile(data, '168F529C-17F6-11E0-8CD8-85483A75A7C5')
            data.ammo.magazineCapacity = 100
        end
    end
    print('Modified UMP-45 successfully.')
end)

Hooks:Install('BulletEntity:Collision', 1, function(hook, entity, hit, giverInfo)
    Levolution_Trigger(entity, hit, giverInfo)
    -- Debugging data for finding what an object is in the map
    if false then
        print('----------------------------------------------')
        print('Instance: ' .. hit.rigidBody.instanceId)
        print('Map: ' .. hit.material.partition.guid:ToString('D'))
        print('Material: ' .. hit.material.instanceGuid:ToString('D'))
        print('RigidBody UID: ' .. tostring(hit.rigidBody.uniqueId))
        print('RigidBody IID: ' .. tostring(hit.rigidBody.instanceId))
        print('RigidBody DATA: ' .. tostring(hit.rigidBody.data ~= nil))
    end
end)

Events:Subscribe('Extension:Loaded', function()
    print('Extension has loaded.')
end)

Hooks:Install('Soldier:Damage', 1, function(hook, soldier, info, giverInfo)
    -- If normal damage (not suicide, vehicle, etc..)
    if (giverInfo.giver ~= nil) and (giverInfo.damageType == 0) then
        local giver = giverInfo.giver;
        -- If not by himself, and a shot by his team
        if (giver.guid ~= soldier.player.guid) and (giver.teamId == soldier.player.teamId) then
            -- Shots should heal!
            if soldier.health < 100 then
                if soldier.health + (info.damage * -1) > 100 then
                    info.damage = 0
                    soldier.health = 100
                else
                    info.damage = info.damage * -1
                end
            else
                info.damage = 0
            end
            hook:Pass(soldier, info, giverInfo)
        end
    end
end)

Events:Subscribe('Player:Reload', function(player)
    ChatManager:Yell(player.name .. ' Reloaded', 1.0, player)
    --print('Weapon: ' .. player.soldier.weaponsComponent.currentWeapon.name)
    --player.soldier.weaponsComponent.currentWeapon.primaryAmmo = 666
end)

Events:Subscribe('Player:Killed', function(player)
    print(player.name .. ' was Killed')
    ChatManager:Yell(player.name .. ' was Killed', 1.0)
end)

Events:Subscribe('Player:Destroy', function(player)
    print(player.name .. ' was Destroyed')
    ChatManager:Yell(player.name .. ' was Destroyed', 3.0)
end)

Events:Subscribe('Player:ReviveRefused', function(player)
    local players = PlayerManager:GetPlayersByTeam(player.teamId)
    if #players ~= 0 then
        for i = 1, #players do
            local target = players[i]
            if target.alive and target.guid ~= player.guid then
                print('Respawning on ' .. target.name)

                local transform = LinearTransform()

                transform.trans.x = player.soldier.transform.trans.x + 5
                transform.trans.y = player.soldier.transform.trans.y + 10
                transform.trans.z = player.soldier.transform.trans.z + 5

                player:SpawnSoldierAt(target.soldier, transform, 0)
            end
        end
    end
end)
