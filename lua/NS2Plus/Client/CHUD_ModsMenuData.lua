CHUDMainMenu = decoda_name == "Main"

Script.Load("lua/NS2Plus/Client/CHUD_Options.lua")
Script.Load("lua/NS2Plus/CHUD_Shared.lua")
Script.Load("lua/NS2Plus/Shared/CHUD_Utility.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Settings.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Options.lua")
Script.Load("lua/NS2Plus/Client/CHUD_Hitsounds.lua")

local function SyncContentsSize(self, size)

	self:SetContentsSize(size)

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

local function CreateNS2PlusSelectOptionMenuEntry(option)
	local entry = {
		name = option.name,
		sort = option.sort or string.format("Z%s", option.name),
		class = OP_TT_Choice,
		params =
		{
			optionPath = option.name,
			optionType = option.valueType,
			default = option.defaultValue,

			tooltip = option.tooltip,
		}
	}

	if option.applyFunction then
		entry.params.immediateUpdate = option.applyFunction
	end

	-- Todo: Label default value as default
	local choices = {}
	if option.valueType == "int" then
		for i, v in ipairs(option.values) do
			table.insert(choices, {value = i - 1, displayString = string.upper(v)})
		end
	end

	-- Todo: Bool should just use a checkbox
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

	return entry
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
		},
		properties =
		{
			{"Label", string.upper(option.label)},
		}
	}

	if option.applyFunction then
		entry.params.immediateUpdate = option.applyFunction
	end

	return entry
end

local factories = {
	select = CreateNS2PlusSelectOptionMenuEntry,
	slider = CreateNS2PlusSliderOptionMenuEntry
}

local function CreateNS2PlusOptionMenuEntry(option)
	local factory = factories[option.type]
	if factory then
		return factory(option)
	end

	Print("NS2Plus option entry %s is not yet supported!", option.name)

end

local function sortOptionEntries(a, b)
	return a.sort > b.sort
end
local function CreateNS2PlusOptionsMenu()
	local options = {}
	local menu = {}

	for _, v in pairs(CHUDOptions) do
		local category = v.category
		local entry = CreateNS2PlusOptionMenuEntry(v)

		if entry then
			if not options[category] then options[category] = {} end
			table.insert(options[category], entry)
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

local function SyncToParentSize(self)
	local parentObject = self:GetParent()
	assert(parentObject)
	self:HookEvent(parentObject, "OnSizeChanged", self.SetSize)
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
			MenuData.CreateVerticalListLayout
			{
				children = paramsTable.children,
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