local const = require("constants")

local lfs = require("lfs")

local validate = require("validation")
local walker = require("walker")
local filter = require("filter")
local source = require("source")


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
category = {}
platform = {}


-- iterate over file list

for _, file in ipairs(clean_list) do
    -- read headers
    local headers = source.get_headers(file)
    local clean_headers = filter.md_chars(headers)

    -- append category
    -- append platform

    for _, header in ipairs(clean_headers) do
        print(header)
    end
    -- print(file)
end
