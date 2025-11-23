-- Merged version of repo-report-tool
local lfs = require(lfs)

local const = {}

const.repo_directory_path = "../../ctf-writeups"
const.readme_file_path = "../../ctf-writeups/README.md"
const.black_list = {"README.md"}
const.connector_char = ";"
const.difficulty_levels = {"Easy", "Medium", "Hard"}

local description = {}

description.title = "# CTF-writeups\n\n"
description.main_text = [[This repository contains write-ups for various Capture the Flag challenges.
All materials are organized in a clear directory structure for easy navigation.
Alongside the Markdown write-ups, you'll also find supporting scripts, payloads, notes, and other helpful resources used during the solving process.]] ..
"\n"
description.number_of_tasks_part_1 = "Currently, "
description.number_of_tasks_part_2 = " challenges have been completed.\n\n"
description.header_category = "## Categories\n\n"
description.category_text =
[[The tables below present various categories of challenges that have been solved as part of the Capture the Flag (CTF) project.
Each category contains different difficulty levels, illustrating how complex individual challenges can be.]] .. "\n\n"
description.table_category_r01 = "| category | easy | medium | hard | all |\n"
description.header_platforms = "## Platforms\n\n"
description.platforms_text =
[[The following table outlines the various platforms or environments where challenges have been solved.
The type called Other is a rather general label for uncategorized CTF challenges, such as tasks solved at university or similar environments.]] ..
"\n\n"
description.table_platform_r01 = "| platform | easy | medium | hard | all |\n"
description.table_separator = "|-|-|-|-|-|\n"
description.split_l = "| "
description.split_m = " | "
description.split_r = " |"


local walker = {}

function walker.get_to_list_all_files(repo_path)
    local all = {}
    local function req_walk(path)
        for file in lfs.dir(path) do
            if file ~= "." and file ~= ".." then
                local global_file = path .. '/' .. file
                local attr = lfs.attributes(global_file)
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

local source = {}

function source.get_headers(path)
    local headers = {}
    local file = io.open(path, "r")
    if file == nil then
        error("Trying to open incorrect file")
    end
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

local filter = {}

function filter.by_extension(unfiltered_list, ext)
    local filtered = {}
    for _, path in ipairs(unfiltered_list) do
        if path:sub(- #ext) == ext then
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

local validate = {}

function validate.readme_attr(filename)
    local readme = lfs.attributes(filename)
    if readme.mode ~= "file" then
        error("Provided report path is incorrect", 0)
    end
    local ext = filename:match("^.+%.(.+)$")
    if ext ~= "md" then
        error("Incorrect extension for report file")
    end
end


-- Flags collector
if #arg == 2 then
    const.repo_directory_path = arg[1]
    const.readme_file_path = arg[2]
else
    error("Incorrect number of flags", 0)
end


-- Start path
local start_path = lfs.currentdir()

-- Init working directory
lfs.chdir(start_path)
local repo_state = lfs.chdir(const.repo_directory_path)
if not repo_state then error("Incorrect repo path", 0) end
local repo_path = lfs.currentdir()

-- Init report file
lfs.chdir(start_path)
validate.readme_attr(const.readme_file_path)
lfs.chdir(const.readme_file_path:match("^(.*)/") or "")
local report_filename = const.readme_file_path:match("([^/]+)$")
local report_path = lfs.currentdir() .. "/" .. report_filename

-- Get wanted .md files
local all_files = walker.get_to_list_all_files(repo_path)
local md_list = filter.by_extension(all_files, ".md")
local clean_list = filter.by_blacklist(md_list, const.black_list)

-- Headers collection
local category = {}
local platform = {}
local difficulty = {}
local category_difficulty = {}
local platform_difficulty = {}
local ctf_counter = 0

-- Iterate over file list and collect data
for _, file in ipairs(clean_list) do
    -- read headers
    local headers = source.get_headers(file)
    local clean_headers = filter.md_chars(headers)
    -- append category
    local category_value = filter.get_type(clean_headers, 8, "Category")
    if category_value ~= "" then table.insert(category, category_value) end
    -- append platform
    local platform_value = filter.get_type(clean_headers, 8, "Platform")
    if platform_value ~= "" then table.insert(platform, platform_value) end
    -- append difficulty
    local difficulty_value = filter.get_type(clean_headers, 10, "Difficulty")
    if difficulty_value ~= "" then table.insert(difficulty, difficulty_value) end
    -- append tools
    -- append tags
    -- ...
    if difficulty_value ~= "" and category_value ~= "" then
        table.insert(category_difficulty, category_value .. const.connector_char .. difficulty_value)
    end
    if difficulty_value ~= "" and platform_value ~= "" then
        table.insert(platform_difficulty, platform_value .. const.connector_char .. difficulty_value)
    end
    ctf_counter = ctf_counter + 1
end

-- Get unique values
local count_category = filter.count_unique(category)
local count_platform = filter.count_unique(platform)
-- local count_difficulty = filter.count_unique(difficulty)
local count_category_difficulty = filter.count_unique(category_difficulty)
local count_platform_difficulty = filter.count_unique(platform_difficulty)

-- Create report file
local readme_file = io.open(report_filename, "w")
if readme_file == nil then
    error("Incorrect report readme file")
end


-- Write data to report

-- Start section
readme_file:write(desc.title)
readme_file:write(desc.main_text)
readme_file:write(desc.number_of_tasks_part_1)
readme_file:write(ctf_counter)
readme_file:write(desc.number_of_tasks_part_2)

-- Category section
readme_file:write(desc.header_category)
readme_file:write(desc.category_text)
readme_file:write(desc.table_category_r01)
readme_file:write(desc.table_separator)

-- Category table
local category_table = assemble.readme_table(
    count_category, count_category_difficulty,
    const.connector_char, const.difficulty_levels,
    desc.split_l, desc.split_m, desc.split_r, desc.table_separator
)
for _, line in ipairs(category_table) do
    readme_file:write(line .. "\n")
end
readme_file:write("\n")

-- Platform section
readme_file:write(desc.header_platforms)
readme_file:write(desc.platforms_text)
readme_file:write(desc.table_platform_r01)
readme_file:write(desc.table_separator)

-- Platform table
local platform_table = assemble.readme_table(
    count_platform, count_platform_difficulty,
    const.connector_char, const.difficulty_levels,
    desc.split_l, desc.split_m, desc.split_r, desc.table_separator
)
for _, line in ipairs(platform_table) do
    readme_file:write(line .. "\n")
end

-- End section
readme_file:write("\n")
readme_file:close()
