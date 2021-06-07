Config = {}

Config.ESX = true
Config.DropPlayer = false -- Drop player if they attempt to trigger an invalid event

-- Return an object in the format
-- {
--     name = job name
-- }

Config.NonEsxJob = function()
    local PlayerJob = {}

    return PlayerJob
end
