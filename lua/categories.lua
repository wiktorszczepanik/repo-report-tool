local categories = {}

function categories.get_to_list()

    dir_categories = {}
    current = lfs.currentdir()

    for entry in lfs.dir(current) do
        attr = lfs.attributes(entry)
        if attr.mode == "directory" and entry:sub(1,1) ~= "." then
            table.insert(dir_categories, entry)
        end
    end

    return dir_categories

end


function prettify(dirs)

    for index, dir in ipairs(dirs) do
        for i = 1, dir do
            --
        end
    end
end

return categories