local lfs = require("lfs")
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

return validate