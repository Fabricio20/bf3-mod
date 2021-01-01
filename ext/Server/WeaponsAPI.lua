function WeaponsAPI_ChangeProjectile(fireData, projectileId)
    fireData.shot.projectileData:MakeWritable()
    local newProjectileData = ResourceManager:SearchForInstanceByGuid(Guid(projectileId))
    fireData.shot.projectileData = ProjectileEntityData(newProjectileData)
end

--- Returns all FiringFunctionData instances from a weapon GUID
function WeaponsAPI_findAllFiringFunctionData(partitionId)
    local partition = ResourceManager:FindDatabasePartition(Guid(partitionId))
    local items = {}
    for _, instance in pairs(partition.instances) do
        if instance ~= nil then
            if instance:Is('FiringFunctionData') then
                table.insert(items, FiringFunctionData(instance))
            end
        end
    end
    return items
end
