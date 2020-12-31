Events:Subscribe('Player:Reload', function(player)
    ChatManager:Yell(player.name .. ' Reloaded', 5.0)
    --print('Weapon: ' .. player.soldier.weaponsComponent.currentWeapon.name)
    --player.soldier.weaponsComponent.currentWeapon.primaryAmmo = 666

    local projectile = '168F529C-17F6-11E0-8CD8-85483A75A7C5';

    local firingFunctionData_1 = getFiringFunctionData('13D445F7-EBE3-11DF-91EC-895E59A6915B', '4506ABFE-4F34-48BE-A724-C97DA9BA46B4')
    local firingFunctionData_2 = getFiringFunctionData('13D445F7-EBE3-11DF-91EC-895E59A6915B', 'F25DA02A-4197-4FAF-8503-9E05C705E653')

    local fireLogic_1 = firingFunctionData_1.fireLogic
    --fireLogic_1.rateOfFire:MakeWritable()
    fireLogic_1.rateOfFire = 10000

    local fireLogic_2 = firingFunctionData_2.fireLogic
    --fireLogic_2.rateOfFire:MakeWritable()
    fireLogic_2.rateOfFire = 10000
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
                print('Respawning on '..target.name)

                local transform = LinearTransform()

                transform.trans.x = player.soldier.transform.trans.x + 5
                transform.trans.y = player.soldier.transform.trans.y + 10
                transform.trans.z = player.soldier.transform.trans.z + 5

                player:SpawnSoldierAt(target.soldier, transform, 0)
            end
        end
    end
end)

function getFiringFunctionData(weaponId, dataId)
    local fireData = FiringFunctionData(ResourceManager:FindInstanceByGuid(Guid(weaponId), Guid(dataId)))
    fireData:MakeWritable()
    return fireData
end

function ChangeWeaponProjectile(fireData, newProjectilePartition)
	fireData.shot.projectileData:MakeWritable()
	local newProjectileData = ResourceManager:SearchForInstanceByGuid(Guid(newProjectilePartition))
	fireData.shot.projectileData = ProjectileEntityData(newProjectileData)
end