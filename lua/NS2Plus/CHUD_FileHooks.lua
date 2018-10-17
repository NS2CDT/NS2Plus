ModLoader.SetupFileHook( "lua/MainMenu.lua", "lua/NS2Plus/Client/CHUD_MainMenuHooks.lua", "post" )

if Client then
	Script.Load("lua/NS2Plus/CHUD_GUIScripts.lua")
end