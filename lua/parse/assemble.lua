local assemble = {}


function assemble.readme_table(count_category, count_category_difficulty, connector_char, difficulty_levels, split_l, split_m, split_r, sep)
    local category_table = {}
    for category, counted in pairs(count_category) do
        local line = split_l .. category .. split_m
        local diff_list = assemble.get_difficulty(count_category_difficulty, category, connector_char, difficulty_levels)
        line = line .. diff_list[1] .. split_m .. diff_list[2] .. split_m .. diff_list[3] .. split_m .. counted .. split_r
        table.insert(category_table, line)
    end
    return category_table
end


function assemble.get_difficulty(difficulty_map, type, connector, levels)
    local difficulty_values = {}
    for _, value in ipairs(levels) do
        local key = type .. connector .. value
        if difficulty_map[key] == nil then
            table.insert(difficulty_values, 0)
        else
            table.insert(difficulty_values, difficulty_map[key])
        end
    end
    return difficulty_values
end


return assemble