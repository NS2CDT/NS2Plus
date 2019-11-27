-- allows players to save and load NS2+ Cr4zyAV settings
-- each save becomes its own json file at %APPDATA%/Natural Selection 2/NS2Plus/AlienVision
-- no UI, only console commands at the moment


-- these are the console commands players will use
-- declaring these up here so it's easy to change and reference
local help_av_command = "avhelp"
local save_av_command = "avsave" -- avsave <name>
local load_av_command = "avload" -- avload <name>
local list_av_command = "avlist"


-- couldn't seem to reference this font by normal means (like Fonts.kArial_15) so i'm just gonna precache it here
-- by eyeballing, the Hack font at size 13 looks like what is used for the console
Font_kHack_13 = PrecacheAsset("fonts/Hack_13.fnt")
-- Wrap the text so it fits on screen
local function PrintConsoleText(text)
	local item = GetGUIManager():CreateTextItem()
	item:SetFontName(Font_kHack_13)
	
	Shared.Message(WordWrap(item, text, 0, Client.GetScreenWidth()-10))
	
	GUI.DestroyItem(item)
end

local function OnCommandPlusHelpAV()
	PrintConsoleText("-------------------------------------")
	PrintConsoleText("NS2+ Cr4zyAV Management Help")
	PrintConsoleText("-------------------------------------")
	
	PrintConsoleText(string.format("'%s' - Lists your AV configs", list_av_command))
	PrintConsoleText(string.format("'%s <config name>' - Saves your current Cr4zyAV settings to a file which you can later load or share with other people. Name can't have spaces, and will overwrite existing configs.", save_av_command))
	PrintConsoleText(string.format("'%s <config name>' - Loads Cr4zyAV settings from the config file.", load_av_command))
	PrintConsoleText("AV configs are stored at '%APPDATA%/Natural Selection 2/NS2Plus/AlienVision'")
	
	PrintConsoleText("-------------------------------------")
end
Event.Hook(string.format("Console_%s", help_av_command), OnCommandPlusHelpAV)

-- save current Cr4zyAV settings to json file
local function OnCommandPlusSaveAV(name)
	if name == nil then
		Print(string.format("You must include a name for this AV. Type '%s' for help.", help_av_command))
		return
	end
	
	local settingsFileName = string.format("config://NS2Plus/AlienVision/%s.json", name)
	local settingsFile = io.open(settingsFileName, "w+")
	if settingsFile then
		local AlienVisionSettings = {}

		-- create a list of all the settings in the 'alienvision' category
		for index, option in pairs(CHUDOptions) do
			if option.category == "alienvision" then
				--Print(CHUDOptions[index].name)
				table.insert(AlienVisionSettings, CHUDOptions[index])
			end
		end
		
		AVSettingsJson = {}
		AVSettingsJson["details"] = {} --stores things like author name, original AV name, date created, etc
		AVSettingsJson["settings"] = {} -- stores each individual AV setting
		
		-- interprets the value of the given option according to its 'valueType' so it's safe for the config
		local function PrintSetting(optionIdx)
			local currentValue = optionIdx.currentValue
			if optionIdx.valueType == "float" then
				currentValue = Round(currentValue * (optionIdx.multiplier or 1), 4)
			elseif optionIdx.valueType == "bool" then
				-- ignore booleans
				-- the only bool valuetype in the AV category is something that I don't think people want on a per-av basis,
				-- and probably not something they want changed to another persons preference when they download another AV config.
				-- what would need to be done: convert the Off and On values to ints here and the inverse in 'OnCommandPlusLoadAV'
				return
			elseif optionIdx.valueType == "int" then
				--Print("optionIdx: %s | optionIdxName: %s | currentValue = %s", optionIdx, optionIdx.name, optionIdx.currentValue)
				currentValue = optionIdx.values[currentValue+1]
				for index, option in ipairs(optionIdx.values) do
					if option == currentValue then 
						currentValue = index-1
					end
				end
			end
			
			AVSettingsJson["settings"][optionIdx.name] = currentValue
		end
		
		AVSettingsJson["details"]["av_name"] = name
		AVSettingsJson["details"]["date_created"] = CHUDFormatDateTimeString(Shared.GetSystemTime())
		
		--loop through all the settings and save them
		for i = 1, #AlienVisionSettings do
			--Print(AlienVisionSettings[i].name)
			PrintSetting(AlienVisionSettings[i])
		end
		
		settingsFile:write(json.encode(AVSettingsJson, { indent = true }))
		
		PrintConsoleText(string.format("Saved AV config as '%s'. You can find it in %%APPDATA%%\\Natural Selection 2\\NS2Plus\\AlienVision\\", name))
	else
		Print("Error creating the AV config file. '%s'", settingsFileName)
	end
	io.close(settingsFile)
end
Event.Hook(string.format("Console_%s", save_av_command), OnCommandPlusSaveAV)

-- load desired Cr4zyAV settings
local function OnCommandPlusLoadAV(name)
	if name == nil then
		Print(string.format("You must include the name of the config you want to load. Type '%s' for help.", help_av_command))
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
			for setting, value in pairs(parsedFile.settings) do --loop through json settings
				for index, option in pairs(CHUDOptions) do --loop through ns2+ option list
					if option.name == setting then
						CHUDSetOption(index, value, true)
						
						--Print("(turts) Set '%s' (key '%s') to '%s'", setting, index, value)
					end
				end
			end
			
			Print("Loaded AV config '%s'", name)
		end
	end
	io.close(settingsFile)
end
Event.Hook(string.format("Console_%s", load_av_command), OnCommandPlusLoadAV)

-- lists saved AV config names to console
local function OnCommandPlusListAV()
	local settingsFileDirectory = "config://NS2Plus/AlienVision/*.json"
	
	local AVConfigs = {}
	Shared.GetMatchingFileNames(settingsFileDirectory, false, AVConfigs)
	
	if AVConfigs[1] == nil then
		Print(string.format("You don't have any AV configs saved. Type '%s' for help.", help_av_command))
		return
	end
	
	AVCountPrint()
	
	for i = 1, #AVConfigs do
		Print(AVConfigs[i])
	end
end
Event.Hook(string.format("Console_%s", list_av_command), OnCommandPlusListAV)

-- print the total number of AV config files to console
function AVCountPrint()
	local settingsFileDirectory = "config://NS2Plus/AlienVision/*.json"
	
	local AVConfigs = {}
	Shared.GetMatchingFileNames(settingsFileDirectory, false, AVConfigs)
	
	local count = 0
	
	for i = 1, #AVConfigs do
		count = count + 1
	end
	
	Print(string.format("You have '%s' NS2+ AV configs saved. Type '%s' for help.", count, help_av_command))
end
	
AVCountPrint() -- gets called once as the file gets loaded that way it pops up in logs.

