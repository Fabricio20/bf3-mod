require('WeaponsAPI')

Events:Subscribe('Level:Loaded', function()
    print('Detected level load.')
end)

Events:Subscribe('Extension:Loaded', function()
    print('Extension has loaded.')
end)

Events:Subscribe('Player:Reload', function(player)
    ChatManager:Yell(player.name .. ' Reloaded', 5.0)
    --print('Weapon: ' .. player.soldier.weaponsComponent.currentWeapon.name)
    --player.soldier.weaponsComponent.currentWeapon.primaryAmmo = 666

    -- Firing functions for UMP-45
    local firingFunctions = WeaponsAPI_getAllInstances('13D445F7-EBE3-11DF-91EC-895E59A6915B', 'FiringFunctionData')
    if #firingFunctions ~= 0 then
        for i = 1, #firingFunctions do
            local data = firingFunctions[i]
            data:MakeWritable()
            print('Found instance of a weapon ' .. data.instanceGuid:ToString('D'))
            WeaponsAPI_ChangeProjectile(data, '168F529C-17F6-11E0-8CD8-85483A75A7C5')
            print('Changed Projectile')
            data.ammo.magazineCapacity = 4000
            -- Slower RoF
            local fireLogic = data.fireLogic
            fireLogic.rateOfFire = 600
            print(fireLogic.rateOfFire)
        end
    end

    local firingsGlock18 = WeaponsAPI_getAllInstances('3B3F9879-EB4B-11DF-8AA6-AE0344995412', 'FiringFunctionData')
    if #firingsGlock18 ~= 0 then
        for i = 1, #firingsGlock18 do
            local data = firingsGlock18[i]
            data:MakeWritable()
            print('Found instance of a weapon ' .. data.instanceGuid:ToString('D'))
            WeaponsAPI_ChangeProjectile(data, 'CEC6D381-72DE-B7D4-E998-0D566E0575C6')
            print('Changed Projectile')
            data.ammo.magazineCapacity = 21
        end
    end
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
