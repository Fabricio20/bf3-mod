function WeaponsAPI_getFiringFunctionData(weaponId, dataId)
    local fireData = FiringFunctionData(ResourceManager:FindInstanceByGuid(Guid(weaponId), Guid(dataId)))
    fireData:MakeWritable()
    return fireData
end

function WeaponsAPI_ChangeProjectile(fireData, projectileId)
    fireData.shot.projectileData:MakeWritable()
    local newProjectileData = ResourceManager:SearchForInstanceByGuid(Guid(projectileId))
    fireData.shot.projectileData = ProjectileEntityData(newProjectileData)
end

--- Returns all instances from a GUID (Usually to get all weapon instances)
function WeaponsAPI_getAllInstances(partitionId, typeName)
    local partition = ResourceManager:FindDatabasePartition(Guid(partitionId))
    local items = {}
    for _, instance in pairs(partition.instances) do
        if instance ~= nil then
            if instance:Is(typeName) then
                table.insert(items, FiringFunctionData(instance))
            end
        end
    end
    print('Items found' .. #items)
    return items
end
