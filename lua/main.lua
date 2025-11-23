local lfs = require("lfs") -- external libray
local const = require("const.constants")
local desc = require("const.description")
local validate = require("check.validation")
local walker = require("parse.walker")
local filter = require("parse.filter")
local source = require("parse.source")
local assemble = require("parse.assemble")


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
