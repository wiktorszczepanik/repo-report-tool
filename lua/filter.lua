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
        clean_file = string.gsub(clean_file, "^%s*(.-)%s*$", "%1")
        table.insert(cleaned, clean_file)
    end
    return cleaned
end

return filter