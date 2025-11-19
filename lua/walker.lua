local walker = {}

function walker.get_to_list_all_files(repo_path)
    local all = {}

    local function req_walk(path)
        for file in lfs.dir(path) do
            if file ~= "." and file ~= ".." then
                local global_file = path .. '/' .. file
                attr = lfs.attributes(global_file)
                if attr.mode == "directory" then
                    req_walk(global_file)
                else
                    table.insert(all, global_file)
                end
            end
        end
    end

    req_walk(repo_path)
    return all
end

return walker