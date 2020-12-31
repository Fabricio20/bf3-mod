local WeaponsAPI = { }

function WeaponsAPI.getFiringFunctionData(weaponId, dataId)
    local fireData = FiringFunctionData(ResourceManager:FindInstanceByGuid(Guid(weaponId), Guid(dataId)))
    fireData:MakeWritable()
    return fireData
end

function WeaponsAPI.ChangeProjectile(fireData, projectileId)
	fireData.shot.projectileData:MakeWritable()
	local newProjectileData = ResourceManager:SearchForInstanceByGuid(Guid(projectileId))
	fireData.shot.projectileData = ProjectileEntityData(newProjectileData)
end

return WeaponsAPI
