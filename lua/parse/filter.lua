local filter = {}

function filter.by_extension(unfiltered_list, ext)
    local filtered = {}
    for _, path in ipairs(unfiltered_list) do
        if path:sub(-#ext) == ext then
            table.insert(filtered, path)
        end
    end
    return filtered
end


function filter.by_blacklist(unfiltered_list, black_list)
    local filtered = {}
    for _, path in ipairs(unfiltered_list) do
        local file = path:match("([^/]+)$")
        local found = false
        for _, item in ipairs(black_list) do
            if file == item then
                found = true
            end
        end
        if found == false then
            table.insert(filtered, path)
        end
    end
    return filtered
end


function filter.md_chars(headers)
    local cleaned = {}
    for _, header in ipairs(headers) do
        local clean_file = string.gsub(header, "[#%*]", "")
        clean_file = clean_file:match("^%s*(.-)%s*$") -- trim
        table.insert(cleaned, clean_file)
    end
    return cleaned
end


function filter.get_type(headers, max_sub_key, type)
    local category = ""
    for _, header in ipairs(headers) do
        if header:sub(1, max_sub_key) == type then
            local value = header:sub(max_sub_key + 3, -1)
            category = value:match("^%s*(.-)%s*$") -- trim
        end
    end
    return category
end


function filter.count_unique(values)
    local map = {}
    for _, value in ipairs(values) do
        if map[value] == nil then
            map[value] = 1
        else
            map[value] = map[value] + 1
        end
    end
    return map
end


return filter