-- allows players to save and load NS2+ Cr4zyAV settings
-- each save becomes its own json file at %APPDATA%/Natural Selection 2/NS2Plus/AlienVision
-- no UI, only console commands at the moment

-- these are the console commands players will use
-- declaring these up here so it's easy to change and reference
local help_av_command = "plus_avhelp"
local save_av_command = "plus_avsave" -- avsave <name>
local load_av_command = "plus_avload" -- avload <name>
local list_av_command = "plus_avlist"

local function OnCommandPlusHelpAV()
	CHUDPrintConsoleText("-------------------------------------")
	CHUDPrintConsoleText("NS2+ Cr4zyAV Management Help")
	CHUDPrintConsoleText("-------------------------------------")
	
	CHUDPrintConsoleText(string.format("'%s' - Lists your AV configs", list_av_command))
	CHUDPrintConsoleText(string.format("'%s <config name>' - Saves your current Cr4zyAV settings to a file which you can later load or share with other people. Name can't have spaces, and will overwrite existing configs.", save_av_command))
	CHUDPrintConsoleText(string.format("'%s <config name>' - Loads Cr4zyAV settings from the config file.", load_av_command))
	CHUDPrintConsoleText("AV configs are stored at '%APPDATA%/Natural Selection 2/NS2Plus/AlienVision'")
	
	CHUDPrintConsoleText("-------------------------------------")
end
Event.Hook(string.format("Console_%s", help_av_command), OnCommandPlusHelpAV)

local function CHUDGetOptionsForCaregory(category)
	local options = {}

	for index, option in pairs(CHUDOptions) do
		if option.category == category then
			-- Print(CHUDOptions[index].name)
			-- save index into option for later lookup
			option.index = index
			table.insert(options, option)
		end
	end

	return options
end

local function GetAVSettings()
	local AVOptions = CHUDGetOptionsForCaregory("alienvision")
	local AVSettings = {}

	for i = 1, #AVOptions do
		local option = AVOptions[i]
		local currentValue = option.currentValue

		-- interprets the value of the given option according to its 'valueType' so it's safe for the config
		if option.valueType == "float" then
			currentValue = Round(currentValue * (option.multiplier or 1), 4)
		elseif option.valueType == "bool" then
			-- ignore booleans
			-- the only bool valuetype in the AV category is something that I don't think people want on a per-av basis,
			-- and probably not something they want changed to another persons preference when they download another AV config.
			-- what would need to be done: convert the Off and On values to ints here and the inverse in 'OnCommandPlusLoadAV'
		elseif option.valueType == "int" then
			-- Print("optionIdx: %s | optionIdxName: %s | currentValue = %s", optionIdx, optionIdx.name, optionIdx.currentValue)
			currentValue = option.values[currentValue + 1]
			for index, value in ipairs(option.values) do
				if value == currentValue then
					currentValue = index - 1
				end
			end
		end

		AVSettings[option.name] = currentValue
	end

	return AVSettings
end

-- save current Cr4zyAV settings to json file
local function OnCommandPlusSaveAV(name)
	if name == nil then
		Print("You must include a name for this AV. Type '%s' for help.", help_av_command)
		return
	end
	
	local settingsFileName = string.format("config://NS2Plus/AlienVision/%s.json", name)
	local settingsFile = io.open(settingsFileName, "w+")
	if settingsFile then
		local AVOptionsJson = {
			details = {  -- stores things like author name, original AV name, date created, etc
				av_name = name,
				date_created = CHUDFormatDateTimeString(Shared.GetSystemTime())
			},
			settings = GetAVSettings() -- stores each individual AV setting
		}
		settingsFile:write(json.encode(AVOptionsJson, { indent = true }))
		
		CHUDPrintConsoleText(string.format("Saved AV config as '%s'. You can find it in %%APPDATA%%\\Natural Selection 2\\NS2Plus\\AlienVision\\", name))
		settingsFile:close()
	else
		Print("Error creating the AV config file. '%s'", settingsFileName)
	end
end
Event.Hook(string.format("Console_%s", save_av_command), OnCommandPlusSaveAV)

-- load desired Cr4zyAV settings
local function OnCommandPlusLoadAV(name)
	if name == nil then
		Print("You must include the name of the config you want to load. Type '%s' for help.", help_av_command)
		return
	end
	
	-- make sure the file exists
	local settingsFileName = string.format("config://NS2Plus/AlienVision/%s.json", name)
	if not GetFileExists(settingsFileName) then 
		Print("Could not find the AV config '%s'.", name)
		return
	end
	
	-- retrieve settings from json file
	local settingsFile = io.open(settingsFileName, "r")
	if settingsFile then
		local parsedFile, _, errStr = json.decode(settingsFile:read("*all"))
		if not errStr then
			local AVSettings = CHUDGetOptionsForCaregory("alienvision")
			for _, option in ipairs(AVSettings) do
				local savedValue = parsedFile.settings[option.name]
				if savedValue then
					CHUDSetOption(option.index, savedValue, true)
					--Print("(LoadAV) Set '%s' (key '%s') to '%s'", option.name, option.index, savedValue)
				end
			end
			
			Print("Loaded AV config '%s'", name)
		end
		settingsFile:close()
	end
end
Event.Hook(string.format("Console_%s", load_av_command), OnCommandPlusLoadAV)

local function AVCountPrint(numConfigs) -- print the total number of AV config files to console
	if not numConfigs then
		local settingsFileDirectory = "config://NS2Plus/AlienVision/*.json"
		local AVConfigs = {}
		Shared.GetMatchingFileNames(settingsFileDirectory, false, AVConfigs)

		numConfigs = #AVConfigs
	end

	Print("You have '%s' NS2+ AV configs saved. Type '%s' for help.", numConfigs, help_av_command)
end

do
	AVCountPrint() -- gets called once as the file gets loaded that way it pops up in logs.
end

-- lists saved AV config names to console
local function OnCommandPlusListAV()
	local settingsFileDirectory = "config://NS2Plus/AlienVision/*.json"
	local AVConfigs = {}
	Shared.GetMatchingFileNames(settingsFileDirectory, false, AVConfigs)

	local numConfigs = #AVConfigs
	if numConfigs == 0 then
		Print("You don't have any AV configs saved. Type '%s' for help.", help_av_command)
		return
	end
	
	AVCountPrint(numConfigs)

	for i = 1, numConfigs do
		Print(AVConfigs[i])
	end
end
Event.Hook(string.format("Console_%s", list_av_command), OnCommandPlusListAV)

