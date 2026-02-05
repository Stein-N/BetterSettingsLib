local _, addon = ...
BetterSettingUtils = {}

-- Register the default Settings Table, if the AddOn has provides
-- a addon.Settings table this function isn't needed.
function BetterSettingUtils.RegisterDefaultSettings(table)
    if table ~= nil and addon.Settings == nil then
        addon.Settings = table
    end
end

-- Register the global SavedVariables for the AddOn
---@param table table
function BetterSettingUtils.RegisterSettingsDatabase(table)
    if table ~= nil then
        addon.SettingsDatabase = table
    end
end

-- Register character specific SavedVariables for the AddOn
---@param table table
function BetterSettingUtils.RegisterCharacterSettingsDatabase(table)
    if table ~= nil then
        addon.CharacterSettingsDatabase = table
    end
end

-- Returns the Settings database
---@param character boolean
function BetterSettingUtils.GetSettingsDatabase(character)
    if character == true and addon.CharacterSettingsDatabase then
        return addon.CharacterSettingsDatabase
    elseif character == false and addon.SettingsDatabase then
        return addon.SettingsDatabase
    end
end

-- Read a specific Setting from the settings database
---@param key string
---@param character boolean
function BetterSettingUtils.GetSettingValue(key, character)
    if not key or key == "" then
        return nil
    end

    local db = BetterSettingUtils.GetSettingsDatabase(character)

    return db[key]
end

-- Create a new AddOn Setting and returning the setting.
-- Can be a global or character setting.
---@param category unknown
---@param key string
---@param lang { label: string, tooltip: string }
---@param character boolean?
function BetterSettingUtils.CreateAddonSetting(category, key, lang, character)
    local option = addon.Settings[key]
    local settingDB = BetterSettingUtils.GetSettingsDatabase(character)

    if option ~= nil then
        local setting = Settings.RegisterAddOnSetting(category, option.key, option.key,
            settingDB, type(option.default), lang.label, option.default)
        setting:SetValueChangedCallback(function(s, v) settingDB[s:GetVariable()] = v end)

        return setting
    end
end

-- Create the main category and layout for the AddOn
---@param name string
function BetterSettingUtils.CreateMainCategoryAndLayout(name)
    if addon.SettingCategories == nil then
        addon.SettingCategories = {}
    end

    if name ~= nil and name ~= "" then
        local category, layout = Settings.RegisterVerticalLayoutCategory(name)
        addon.SettingCategories["main"] = {
            category = category,
            layout = layout
        }

        return category, layout
    end
end

function BetterSettingUtils.CreateSubCategoryAndLayout(category, name)
    if category ~= nil and name ~= nil and name ~= "" then
        local subcategory, layout = Settings.RegisterVerticalLayoutSubcategory(category, name)
        addon.SettingCategories[name] = {
            parent = category,
            category = subcategory,
            layout = layout
        }

        return subcategory, layout
    end
end