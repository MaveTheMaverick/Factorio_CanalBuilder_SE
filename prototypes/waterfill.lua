-- CanalBuilderMAV
-- prototypes.waterfill

local function emptyPic()
    return {
        filename = "__core__/graphics/empty.png",
        priority = "high",
        width = 1,
        height = 1,
        shift = {0, 0}
    }
end

local function emptySprites()
    return {
        north = emptyPic(),
        east = emptyPic(),
        south = emptyPic(),
        west = emptyPic()
    }
end

-- technology
local waterfill_tech = {
    type = "technology",
    name = "waterfill-tech",
    icon = "__CanalBuilderMAV__/graphics/icons/waterfill_large.png",
    icon_size = 128,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "waterfill-recipe"
        }
    },
    prerequisites = {
        "landfill",
        "explosives"
    },
    unit = {
        count = 100,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        },
        time = 30
    },
    order = "a"
}

-- recipe
local waterfill_recipe = {
    type = "recipe",
    name = "waterfill-recipe",
    energy_required = 0.5,
    enabled = false,
    category = "crafting",
    ingredients = {
        {
            type = "item",
            name = "explosives",
            amount = settings.startup["canalbuilder-explosives-cost"].value
        },
        {
            type = "item",
            name = "water-barrel",
            amount = settings.startup["canalbuilder-water-barrel-cost"].value
        },
    },
    results = {{type="item", name="waterfill-item", amount=1}}
}

-- item
local waterfill_item = {
    type = "item",
    name = "waterfill-item",
    icon = "__CanalBuilderMAV__/graphics/icons/waterfill_small.png",
    icon_size = 32,
    flags = {},
    subgroup = data.raw["item"]["landfill"].subgroup,
    order = data.raw["item"]["landfill"].order .. "a",
    stack_size = 100,
    place_result = "waterfill-placer"
}

-- entity (placer)
local waterfill_placer = {
    type = "offshore-pump",
    name = "waterfill-placer",
    icon = "__CanalBuilderMAV__/graphics/icons/waterfill_small.png",
    icon_size = 32,
    picture = emptyPic(),
    collision_mask = data.raw["offshore-pump"]["offshore-pump"].collision_mask,
    tile_buildability_rules =
    {
      {area = {{-0.4, -0.4}, {0.4, 0.4}}, required_tiles = {layers={ground_tile=true}}, colliding_tiles = {layers={water_tile=true}}, remove_on_collision = true},
      {area = {{-0.4, -0.6}, {0.4, -1.4}}, required_tiles = {layers={water_tile=true}}, colliding_tiles = {layers={lava_tile=true}}},
    },
    fluid_source_offset = {0, -1},
    collision_box = {{-1.4, -0.6}, {1.4, 0.4}},
    flags = data.raw["offshore-pump"]["offshore-pump"].flags,
    fluid_box = {
        volume = 100,
        production_type = "none",
        -- filter = "water",
        pipe_connections =
        {
            {
                position = {0, 0},
                direction = defines.direction.south,
                flow_direction = "output"
            }
        }
    },
    energy_source =
    {
      type = "void"
    },
    energy_usage = "1W",
    placeable_position_visualization = {
        priority = "extra-high-no-scale",
        filename = "__core__/graphics/cursor-boxes-32x32.png",
        x = 192,
        height = 64,
        width = 64,
        scale = 0.5
    },
    pumping_speed = 1,
}

data:extend({
    waterfill_tech,
    waterfill_recipe,
    waterfill_item,
    waterfill_placer
})

for i = #waterfill_recipe.ingredients,1,-1 do
    if waterfill_recipe.ingredients[i].amount == 0 then
        table.remove(waterfill_recipe.ingredients, i)
    end
end
