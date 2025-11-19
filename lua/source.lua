local source = {}

function source.get_headers(path)
    local headers = {}
    local file = io.open(path, "r")
    local hash_counter = 0
    for line in file:lines() do
        if line:sub(1, 1) == "#" then
            hash_counter = hash_counter + 1
            if hash_counter >= 2 then
                break
            end
            table.insert(headers, line)
        elseif line:sub(1, 2) == "**" then
            table.insert(headers, line)
        end
    end
    file:close()
    return headers
end

return source