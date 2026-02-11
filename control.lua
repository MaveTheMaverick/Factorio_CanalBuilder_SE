-- CanalBuilderMAV
-- control

local isWaterTile = {
    ["water"] = true,
    ["deepwater"] = true,
    ["water-shallow"] = true
}

local isTrain = {
    ["locomotive"] = true,
    ["artillery-wagon"] = true,
    ["cargo-wagon"] = true,
    ["fluid-wagon"] = true
}

local placement = "waterfill-placer"


-- announce self to other mods
remote.add_interface("CanalBuilder", {
    exists = function() return true end
})

-- waterfill placer handler
local function replaceDummy(placed)

    local replacement = "water-shallow"
    if settings.global["canalbuilder-alternate-tile"].value then
        replacement = "water-mud"
    end

    -- the waterfill item is an offshore-pump so we can get the fluid it's technically trying to pull from
    -- local tile_to_replace = surface.get_tile(placed.get_fluid_source_tile())
    -- local tile_to_replace_fluid = tile_to_replace.prototype.fluid

    -- simple handling of Aquilo and Fulgora special ocean fluids - placement on lava is blocked by collision mask
    local target_fluid = placed.get_fluid_source_fluid()
    if target_fluid == "ammoniacal-solution" then
        replacement = "ammoniacal-ocean"
    elseif target_fluid == "heavy-oil" then
        replacement = "oil-ocean-shallow"
    elseif target_fluid == "lava" then -- By default this should be impossible but if the collision_mask on lava or something else was changed this is nice to have
        replacement = "lava"
    end

    local dir     = placed.direction
    local pos     = placed.position
    local surface = placed.surface

    placed.destroy()
    local tileArray = {}
    local i = 1

    if dir == defines.direction.north or dir == defines.direction.south then
        for x = -1, 1, 1 do
            tileArray[i] = {
                name = replacement,
                position = {pos.x + x, pos.y}
            }
            i = i + 1
        end
    elseif dir == defines.direction.east or dir == defines.direction.west then
        for y = -1, 1, 1 do
            tileArray[i] = {
                name = replacement,
                position = {pos.x, pos.y + y}
            }
            i = i + 1
        end
    end

    surface.set_tiles(tileArray)
end

-- when the waterfill placer is built
script.on_event(
    {defines.events.on_built_entity, defines.events.on_robot_built_entity},
    function(event)
        if event.entity.name == placement then replaceDummy(event.entity) end
    end
)
