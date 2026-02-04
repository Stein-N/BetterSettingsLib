local _, addon = ...
SettingUtils = {}

-- Register the global SavedVariables for the AddOn
function SettingUtils.RegisterSettingsDatabase(table)
    if table ~= nil then
        addon.SettingsDatabase = table
    end
end

-- Register character specific SavedVariables for the AddOn
function SettingUtils.RegisterCharacterSettingsDatabase(table)
    if table ~= nil then
        addon.CharacterSettingsDatabase = table
    end
end

-- Read a specific Setting from the settings database
function SettingUtils.GetSettingValue(key, character)
    if not key or key == "" then
        return nil
    end

    local db
    if character then
        db = addon.CharacterSettingsDatabase
    else
        db = addon.SettingsDatabase
    end

    return db[key]
end