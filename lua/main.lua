local lfs = require("lfs")

local const = require("const.constants")
local desc = require("const.description")

local validate = require("check.validation")
local walker = require("parse.walker")
local filter = require("parse.filter")
local source = require("parse.source")


-- start path
local start_path = lfs.currentdir()


-- working directory
lfs.chdir(start_path)
local repo_state = lfs.chdir(const.repo_directory_path)
if not repo_state then error("Incorrect repo path", 0) end

local repo_path = lfs.currentdir()


-- report file
lfs.chdir(start_path)
validate.readme_attr(const.readme_file_path)
lfs.chdir(const.readme_file_path:match("^(.*)/") or "")
local report_filename = const.readme_file_path:match("([^/]+)$")

local report_path = lfs.currentdir() .. "/" .. report_filename


-- get wanted .md files
local all_files = walker.get_to_list_all_files(repo_path)
local md_list = filter.by_extension(all_files, ".md")
local clean_list = filter.by_blacklist(md_list, const.black_list)


-- headers collection
local category = {}
local platform = {}
local difficulty = {}

local category_difficulty = {}
local platform_difficulty = {}

-- iterate over file list and collect data
for _, file in ipairs(clean_list) do
    -- read headers
    local headers = source.get_headers(file)
    local clean_headers = filter.md_chars(headers)

    -- append category
    local category_value = filter.get_type(clean_headers, 8, "Category")
    if category_value ~= "" then
        table.insert(category, category_value)
    end

    -- append platform
    local platform_value = filter.get_type(clean_headers, 8, "Platform")
    if platform_value ~= "" then
        table.insert(platform, platform_value)
    end

    -- append difficulty
    local difficulty_value = filter.get_type(clean_headers, 10, "Difficulty")
    if difficulty_value ~= "" then
        table.insert(difficulty, difficulty_value)
    end

    -- append tools
    -- append tags
    -- ...

    if difficulty_value ~= "" and category_value ~= "" then
        table.insert(category_difficulty, category_value .. "," .. difficulty_value)
    end

    if difficulty_value ~= "" and platform_value ~= "" then
        table.insert(platform_difficulty, platform_value .. "," .. difficulty_value)
    end

end


-- get unique values

local count_category = filter.count_unique(category)
local count_platform = filter.count_unique(platform)

local count_category_difficulty = filter.count_unique(category_difficulty)
local count_platform_difficulty = filter.count_unique(platform_difficulty)


-- for key, value in pairs(count_platform_difficulty) do
--     print(key .. " -> " .. value)
-- end
