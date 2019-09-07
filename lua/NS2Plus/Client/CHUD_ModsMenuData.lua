CHUDMainMenu = decoda_name == "Main"

Script.Load("lua/NS2Plus/Client/CHUD_Options.lua")
Script.Load("lua/NS2Plus/CHUD_Shared.lua")
Script.Load("lua/NS2Plus/Shared/CHUD_Utility.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Settings.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Options.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Hitsounds.lua")

Script.Load("lua/menu2/widgets/GUIMenuColorPickerWidget.lua") -- doesn't get loaded by vanilla menu

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
	if parent.valueType == "bool" then
		return function(self)
			self:HookEvent(GetOptionsMenu():GetOptionWidget(parent.name), "OnValueChanged",
					function(self, value)
						self:SetExpanded(value ~= parent.hideValues[1])
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
					function(self, value)
						self:SetExpanded(not hideMap[value])
					end)

			local currentValue = GetOptionsMenu():GetOptionWidget(parent.name):GetValue()
			self:SetExpanded(not hideMap[currentValue])
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

OP_TT_Expandable_ColorPicker  = GetMultiWrappedClass(GUIMenuColorPickerWidget, {"Option", "Tooltip", "Expandable"})
OP_TT_ColorPicker  = GetMultiWrappedClass(GUIMenuColorPickerWidget, {"Option", "Tooltip"})

local function CreateNS2PlusColorOptionMenuEntry(option, parent)
	option.sort = option.sort or string.format("Z%s", option.name)
	local entry = {
		name = option.name,
		sort = option.sort,
		class = parent and OP_TT_Expandable_ColorPicker or OP_TT_ColorPicker,
		params =
		{
			optionPath = option.name,
			optionType = "color",
			default = option.defaultValue,

			tooltip = option.tooltip,
			tooltipIcon = option.helpImage
		}
	}

	if not CHUDMainMenu and option.applyFunction then
		entry.params.immediateUpdate = option.applyFunction
	end

	entry.properties =
	{
		{"Label", string.upper(option.label)},
	}

	if parent then
		entry.postInit = CreateNS2PlusOptionMenuEntryPostInit(parent)
	end

	return CreateNS2PlusOptionChildrenMenuEntries(option, entry)
end

local function CreateNS2PlusSelectOptionMenuEntry(option, parent)
	option.sort = option.sort or string.format("Z%s", option.name)
	local entry = {
		name = option.name,
		sort = option.sort,
		class = parent and OP_TT_Expandable_Choice or OP_TT_Choice,
		params =
		{
			optionPath = option.name,
			optionType = option.valueType,
			default = option.defaultValue,

			tooltip = option.tooltip,
			tooltipIcon = option.helpImage
		}
	}

	if not CHUDMainMenu and option.applyFunction then
		entry.params.immediateUpdate = option.applyFunction
	end

	-- Todo: Label default value as default
	local choices = {}
	if option.valueType == "int" then
		for i, v in ipairs(option.values) do
			table.insert(choices, {value = i - 1, displayString = string.upper(v)})
		end
	end

	if option.valueType == "bool" then
		for i, v in ipairs(option.values) do
			table.insert(choices, {value = i == 2, displayString = string.upper(v)})
		end
	end

	entry.properties =
	{
		{"Label", string.upper(option.label)},
		{"Choices",
		 choices
		}
	}

	if parent then
		entry.postInit = CreateNS2PlusOptionMenuEntryPostInit(parent)
	end

	return CreateNS2PlusOptionChildrenMenuEntries(option, entry)
end

local function CreateNS2PlusSliderOptionMenuEntry(option, parent)
	local entry = {
		name = option.name,
		sort = option.sort or string.format("Z%s", option.name),
		class = parent and OP_TT_Expandable_Number or OP_TT_Number,
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

	if option.applyFunction then
		entry.params.immediateUpdate = option.applyFunction
	end

	if parent then
		entry.postInit = CreateNS2PlusOptionMenuEntryPostInit(parent)
	end

	return CreateNS2PlusOptionChildrenMenuEntries(option, entry)
end

local factories = {
	select = CreateNS2PlusSelectOptionMenuEntry,
	slider = CreateNS2PlusSliderOptionMenuEntry,
	color = CreateNS2PlusColorOptionMenuEntry
}

function CreateNS2PlusOptionMenuEntry(option, parent)
	local type = option.type or option.valueType -- color option have no type declared
	local factory = factories[type]
	if factory then
		return factory(option, parent)
	end

	Print("NS2Plus option entry %s (%s) is not yet supported!", option.name, type)
end

function CreateNS2PlusOptionsMenu()
	local options = {}
	local menu = {}

	for _, v in pairs(CHUDOptions) do
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
		},

		children =
		{
			{
				name = "filler",
				class = GUIFillLayout,
				params = {
					orientation = "horizontal",
					frontPadding = 64
				},
				postInit =
				{
					SyncToParentSize,
				},
				children = {
					MenuData.CreateVerticalListLayout
					{
						children = paramsTable.children,
					}
				}
			}
		},
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
					label = "NS2PLUS OPTIONS",
				},
			},
			contentsConfig = CreateDefaultOptionsLayout
			{
				children = CreateNS2PlusOptionsMenu()
			}
		})