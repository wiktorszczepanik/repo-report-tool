local const = require("constants")

local validate = require("validation")
local categories = require("categories")

local lfs = require("lfs")

-- change working directory
local repo_state = lfs.chdir(const.repo_directory)
if not repo_state then
    error("Incorrect repo path", 0)
end

-- check report file
validate.readme_attr(const.readme_file)


-- get categories names
dirs = categories.get_to_list()

for i, d in ipairs(dirs) do
    print(i, d)
end



-- local categories = io.popen("ls")

-- for dir in categories:lines() do
--     print(dir)
-- end

-- categories:close()


-- print(categories)