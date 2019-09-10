CHUDMainMenu = decoda_name == "Main"

Script.Load("lua/NS2Plus/Client/CHUD_Options.lua")
Script.Load("lua/NS2Plus/Shared/CHUD_Utility.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Settings.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Options.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Hitsounds.lua")

-- Main Menu VM
if CHUDMainMenu then
	Script.Load("lua/NS2Plus/CHUD_Shared.lua")

	local oldInitialize = GUIMenuModScreen.Initialize
	function GUIMenuModScreen:Initialize(a, b, c, d, e)
		oldInitialize(self, a, b, c, d, e)

		GetCHUDSettings()
		Log("NS2+ Main Menu mods loaded. Build %s.", kCHUDVersion)
	end
end

Script.Load("lua/menu2/widgets/GUIMenuColorPickerWidget.lua") -- doesn't get loaded by vanilla menu

local kResetButtonTexture = PrecacheAsset("ui/newMenu/resetToDefaultIcon.dds")

local function SyncContentsSize(self, size)

	self:SetContentsSize(size)

end

local function SyncToParentSize(self)
	local parentObject = self:GetParent()
	assert(parentObject)
	self:HookEvent(parentObject, "OnSizeChanged", self.SetSize)
end


local function SyncParentContentsSizeToLayout(self)
	local parent = self:GetParent():GetParent():GetParent()
	assert(parent)

	parent:HookEvent(self, "OnSizeChanged", SyncContentsSize)
end

local function CreateExpandablGroup(paramsTable)

	RequireType({"table", "nil"}, paramsTable.params, "paramsTable.params", errorDepth)

	return
	{
		name = paramsTable.name,
		class = GUIMenuExpandableGroup,
		params = CombineParams(paramsTable.params or {},
		{
			expansionMargin = 4, -- prevent outer stroke effect from being cropped away.
		}),
		properties =
		{
			{"Label", paramsTable.label},
		},
		children =
		{
			{
				name = "layout",
				class = GUIListLayout,
				params =
				{
					orientation = "vertical",
				},
				properties =
				{
					{"FrontPadding", 32},
					{"BackPadding", 32},
					{"Spacing", 5},
				},
				postInit =
				{
					SyncParentContentsSizeToLayout,
				},
				children = paramsTable.children
			},
		},
	}
end

local function sortOptionEntries(a, b)
	return a.sort < b.sort
end

-- Yeah this is aweful but no way around it
local function CreateNS2PlusOptionMenuEntryPostInit(parent)
	if not parent then return end

	if parent.valueType == "bool" then
		return function(self)
			self:HookEvent(GetOptionsMenu():GetOptionWidget(parent.name), "OnValueChanged",
					function(this, value)
						this:SetExpanded(value ~= parent.hideValues[1])
					end)

			local currentValue = GetOptionsMenu():GetOptionWidget(parent.name):GetValue()
			self:SetExpanded(currentValue ~= parent.hideValues[1])
		end
	else
		local hideMap = {}
		for _, v in ipairs(parent.hideValues) do
			hideMap[v] = true
		end

		return function(self)
			self:HookEvent(GetOptionsMenu():GetOptionWidget(parent.name), "OnValueChanged",
					function(this, value)
						this:SetExpanded(hideMap[value] == nil)
					end)

			local currentValue = GetOptionsMenu():GetOptionWidget(parent.name):GetValue()
			self:SetExpanded(hideMap[currentValue] == nil)
		end
	end
end

local function CreateNS2PlusOptionChildrenMenuEntries(option, entry)
	if not option.children then
		return entry
	end

	local children = {}
	for _, v in ipairs(option.children) do
		local childEntry = CHUDOptions[v]

		if childEntry then
			local childOptionEntry = CreateNS2PlusOptionMenuEntry(childEntry, option)
			table.insert(children, childOptionEntry)
		end
	end
	table.sort(children, sortOptionEntries)

	table.insert(children, 1, entry)
	entry = {
		name = string.format("%sGroup", option.name),
		class = GUIListLayout,

		params =
		{
			orientation = "vertical",
		},

		properties =
		{
			{"FrontPadding", 0},
			{"BackPadding", 0},
			{"Spacing", 15},
		},

		children = children,

		sort = option.sort

	}

	return entry
end
OP_TT_ColorPicker = GetMultiWrappedClass(GUIMenuColorPickerWidget, {"Option", "Tooltip"})

local function CreateNS2PlusColorOptionMenuEntry(option)
	option.sort = option.sort or string.format("Z%s", option.name)
	local entry = {
		name = option.name,
		sort = option.sort,
		class = OP_TT_ColorPicker,
		params =
		{
			optionPath = option.name,
			optionType = "color",
			default = option.defaultValue,

			tooltip = option.tooltip,
			tooltipIcon = option.helpImage
		}
	}

	entry.properties =
	{
		{"Label", string.upper(option.label)},
	}

	return CreateNS2PlusOptionChildrenMenuEntries(option, entry)
end

local function CreateNS2PlusSelectOptionMenuEntry(option)
	option.sort = option.sort or string.format("Z%s", option.name)
	local entry = {
		name = option.name,
		sort = option.sort,
		class = OP_TT_Choice,
		params =
		{
			optionPath = option.name,
			optionType = option.valueType,
			default = option.defaultValue,

			tooltip = option.tooltip,
			tooltipIcon = option.helpImage
		}
	}

	local choices = {}
	for i, v in ipairs(option.values) do
		table.insert(choices, {value = i - 1, displayString = string.upper(v)})
	end

	entry.properties =
	{
		{"Label", string.upper(option.label)},
		{"Choices",
		 choices
		}
	}

	return CreateNS2PlusOptionChildrenMenuEntries(option, entry)
end

local function CreateNS2PlusSelectBoolOptionMenuEntry(option)
	local entry =
	{
		name = option.name,
		sort = option.sort or string.format("Z%s", option.name),
		class = OP_TT_Checkbox,
		params =
		{
			optionPath = option.name,
			optionType = option.valueType,
			default = option.defaultValue,
			
			tooltip = option.tooltip,
			tooltipIcon = option.tooltipIcon,
		}
	}

	entry.properties =
	{
		{"Label", string.upper(option.label)},
	}
	
	return CreateNS2PlusOptionChildrenMenuEntries(option, entry)
	
end

local function CreateNS2PlusSliderOptionMenuEntry(option)
	local entry = {
		name = option.name,
		sort = option.sort or string.format("Z%s", option.name),
		class = OP_TT_Number,
		params =
		{
			optionPath = option.name,
			optionType = option.valueType,
			default = option.defaultValue,

			minValue = option.minValue,
			maxValue = option.maxValue,
			decimalPlaces = option.valueType == "int" and 0 or 2,

			tooltip = option.tooltip,
			tooltipIcon = option.helpImage
		},
		properties =
		{
			{"Label", string.upper(option.label)},
		}
	}

	return CreateNS2PlusOptionChildrenMenuEntries(option, entry)
end

local factories = {
	select = CreateNS2PlusSelectOptionMenuEntry,
	selectBool = CreateNS2PlusSelectBoolOptionMenuEntry,
	slider = CreateNS2PlusSliderOptionMenuEntry,
	color = CreateNS2PlusColorOptionMenuEntry
}

local optionDefaults = {}
local function ResetAllOptions()
	local optionMenu = GetOptionsMenu()
	assert(optionMenu)

	for i = 1, #optionDefaults do
		local optionParams = optionDefaults[i]
		local name = optionParams[1]
		local widget = optionMenu:GetOptionWidget(name)
		assert(widget)

		local defaultValue = optionParams[2]
		if widget:isa("GUIMenuColorPickerWidget") then
			defaultValue = ColorIntToColor(defaultValue)
		end

		widget:SetValue(defaultValue)
	end
end

-- Config is a GUIObject config.  postInit is either a function, or a list of functions.
-- config.postInit can be either nil, function, or list of functions.
-- Returns a copy of the config with the new postInit function(s) added.
local function AddPostInits(config, postInit)
	RequireType({"function", "table"}, postInit, "postInit", 2)

	-- Input table doesn't have postInit field, simple assignment.
	if config.postInit == nil then
		config.postInit = postInit
		return config
	end

	local newPostInit = {}
	-- Ensure result.postInit is a table, so we can hold multiple postInit functions.
	if type(config.postInit) == "function" then
		table.insert(newPostInit, config.postInit)
	else
		newPostInit = config.postInit
	end

	if type(postInit) == "function" then
		table.insert(newPostInit, postInit)
	else
		-- Append the postInit list to the result.postInit list.
		for i = 1, #postInit do
			table.insert(newPostInit, postInit[i])
		end
	end

	config.postInit = newPostInit

	return config
end

-- DEBUG
local function DebugPrintValue(name, val, indent)

	indent = indent or 0
	local indentStr = string.rep("    ", indent)

	if type(val) == "table" and not val.classname then
		Log("%s%s =", indentStr, name)
		Log("%s{", indentStr)
		for key, value in pairs(val) do
			DebugPrintValue(key, value, indent+1)
		end
		Log("%s}", indentStr)
	else
		Log("%s%s = %s", indentStr, name, val)
	end

end

local function ResetOptionValue(option)
	local default = option.default
	option:SetValue(default)
end

local function SetupResetButton(option)
	local resetButton = option.resetButton
	assert(resetButton ~= nil)

	option:HookEvent(resetButton, "OnPressed", ResetOptionValue)
end

local function UpdateResetButtonOpacity(option)
	local resetButton = option.resetButton
	assert(resetButton ~= nil)

	local value = option:GetValue()
	local visible = not GetAreValuesTheSame(value, option.default)
	local opacityGoal = visible and 1.0 or 0.0

	-- DEBUG
	--Log("UpdateResetButtonOpacity()")
	--Log("    option = %s", option)
	--Log("    value = %s", value)
	--Log("    visible = %s", visible)
	--Log("    defaultValue = %s", option.default)

	resetButton:AnimateProperty("Opacity", opacityGoal, MenuAnimations.Fade)
end

local ResetButtonClass = GetMultiWrappedClass(GUIButton, {"MenuFX", "Tooltip"})
local GUIListLayout_Expandable = GetMultiWrappedClass(GUIListLayout, {"Expandable"})

local function AddResetButtonToOption(config, parent)
	-- DEBUG
	-- DebugPrintValue("config", config)
	
	if config.class == GUIListLayout then
		config = config.children[1]
	end

	local resetButtonClass = ResetButtonClass
	
	local wrappedOption =
	{
		sort = config.sort,
		name = string.format("%s_wrapped", config.name),
		class = parent and GUIListLayout_Expandable or GUIListLayout,
		params =
		{
			orientation = "horizontal",
			spacing = 16,
		},
		children =
		{
			-- Reset Button
			{
				name = "resetButton",
				class = resetButtonClass,
				params =
				{
					defaultColor = HexToColor("971e1e"),
					highlightColor = HexToColor("ff4141"),
				},
				postInit = function(self)
					self:SetTexture(kResetButtonTexture)
					self:SetSizeFromTexture()
					self:AlignLeft()
					self:SetTooltip(Locale.ResolveString("OPTION_RESET"))
				end,
			},
			
			-- Include original widget here.
			AddPostInits(config,
			{
				function(self)
					local list = self:GetParent()
					local resetButton = list:GetChild("resetButton")
					assert(resetButton ~= nil)

					self.resetButton = resetButton

					-- Post init to adjust the resetButton's opacity based on whether or not the
					-- value selected is the default value.
					self:HookEvent(self, "OnValueChanged", UpdateResetButtonOpacity)
					UpdateResetButtonOpacity(self)

					-- Setup function for reset button
					SetupResetButton(self)
				end
			}),
		},
	}

	if parent then
		AddPostInits(wrappedOption, CreateNS2PlusOptionMenuEntryPostInit(parent))
		wrappedOption.params.expansionMargin = 4.0
	end
	
	return wrappedOption
end

function CreateNS2PlusOptionMenuEntry(option, parent)
	local optionType = option.type or option.valueType -- color option have no type declared

	-- use checkbox type wherever possible
	if optionType == "select" and option.valueType == "bool" then
		optionType = "selectBool"
	end

	local factory = factories[optionType]
	if not factory then
		Print("NS2Plus option entry %s (%s) is not yet supported!", option.name, optionType)
		return
	end
	
	local result = factory(option)

	AddPostInits(result, function(self)
		local function ApplyOptions(this)
			local value = this:GetValue()
			local key = option.key
			CHUDSetOption(key, value)

			local immediateUpdate = option.immediateUpdate
			if immediateUpdate then
				immediateUpdate(this)
			end
		end
		self:HookEvent(self, "OnValueChanged", ApplyOptions)
	end)

	-- Add a "reset to default" button to the left of the option that will appear if the option is a
	-- non-default value.
	local wrappedOption = AddResetButtonToOption(result, parent)

	-- DEBUG
	--DebugPrintValue("wrappedOption", wrappedOption)
	
	return wrappedOption
	
end

function CreateNS2PlusOptionsMenu()
	local options = {}
	local menu = {}

	optionDefaults = {}

	for k, v in pairs(CHUDOptions) do
		v.key = k

		if v.defaultValue then
			table.insert(optionDefaults, {v.name, v.defaultValue})
		end

		if not v.parent then
			local category = v.category
			local entry = CreateNS2PlusOptionMenuEntry(v)
			
			if entry then
				if not options[category] then options[category] = {} end
				table.insert(options[category], entry)
			end

		end
	end
	
	for category, v in pairs(options) do
		if #v > 0 then
			table.sort(v, sortOptionEntries)

			category = string.upper(category)
			local entry = CreateExpandablGroup {
				name = string.format("NS2Plus%sOptions", category),
				label = category,
				children = v
			}

			table.insert(menu, entry)
		end
	end
	
	local resetButton = {
		name = "CHUD_ResetAll",
		class = GUIMenuButton,
		properties = {
			{"Label", "RESET NS2+ OPTIONS"}
		},
		postInit = {
			function(self)
				self:HookEvent(self, "OnPressed", ResetAllOptions)
			end
		}
	}

	table.insert(menu, resetButton)

	return menu
end

local function CreateDefaultOptionsLayout(paramsTable)
	return
	{
		name = "scrollPane",
		class = GUIMenuScrollPane,
		params =
		{
			horizontalScrollBarEnabled = false,
		},
		postInit =
		{
			SyncToParentSize,
			function(self) self:HookEvent(self, "OnSizeChanged", self.SetPaneWidth) end,
		},
		children =
		{
			MenuData.CreateVerticalListLayout
			{
				children = paramsTable.children,
				fixedSize = false,
				position = Vector(100, 0, 0),
				
			}
		}
	}
end

table.insert(gModsCategories,
{
	categoryName = "ns2Plus",
	entryConfig =
	{
		name = "ns2PlusOptions",
		class = GUIMenuCategoryDisplayBoxEntry,
		params =
		{
			label = Locale.ResolveString("NS2PLUS_OPTIONS"),
		},
	},
	contentsConfig = CreateDefaultOptionsLayout
	{
		children = CreateNS2PlusOptionsMenu(),
	}
})