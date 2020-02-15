Changelog
============
- 14/02/2020
    - Fixed various issues with the hive skill graph of the match report (Thanks to pebl)
    - Added the player's observatory.morrolan.ch profile link to context menu of the match report.
    - Added the player's skill tier number to the context menu of the match report.
    - Fixed the positioning of the old team ressource display HUD element.

- 27/01/2020
    - Added an option to hide the "new" (ns2 build 331) team info top bar
    - Re-/Added an option to enable the "old" (ns2 build <= 330) resource tower counter next/below to the personal resources counter.
    - Fixed that embryos were exposed at the minimap via the alien minimap color option.

- 28/11/2019
    - Added new console commands to import/export and share Alien Vison (AV) configurations. Enter `plus_avhelp` into the console for more details (contributed by turtsmcgurts)
    - Fixed Cr4zy's AV "no fill" edges issue (contributed by Cr4zy)
    - Fixed Cr4zy's AV depth blending issue  (contributed by Cr4zy)

- 27/11/2019
    - Added a confirmation message for reseting all ns2plus options (contributed by Cr4zy)
    - Greatly improved the customizable AV options (contributed by Cr4zy):        
        - Added the ability to individually colour; Marines, Aliens, Gorges, Marine Structures and Alien Structures.
        - Added a Nanoshield AV highlight option, for those people who like darker AV's that cant see the Nanoshield vfx this will enable an recolour within the AV itself.
        - Code updated, some improvements with inline functions and removal of old depreciated code.
        - Close and Distant colours now apply to depth fog too allowing for more interesting setups.
        - Ability to toggle off any of the individually colourable elements.
        - A new edge option which doesnt add colour fill to entities allowing for more of an outline only style.
        - Toggle a new edge math that greatly improves the rendering of edge detection in the distance, removing the "highlighted" floors and walls effect of the previous detection.
        - Cleaned up parameters being sent to shader, many values no in single integers for bitshifting, also allows for the increased colour option count.
        - *Watch https://www.youtube.com/watch?v=sWnyY7-nLdI for an walkthrough though the available new options.*
    - Fixed that the time displays overlapped with each other and the hive status HUD for aliens.
    - The "Minimal GUI" option does no longer hide the status effect icons. Please use the vanilla "Minimal HUD Mode" option if you want to hide those.
   
- 19/09/2019
    - Added options menu to the mods options menu of the new main menu
    - Enabled stats tracking for cysts and alien tunnels. So they are listed in the end-game report. (Thanks to turtsmcgurts)

- 14/07/2019
    - Fixed invalid export format for weapons stats.
    - Fixed that not all player team changes were tracked.
    - Added a ns2plus dev mode. You can enable it via the plus_dev console command.
    - Only show the average hive skill graph with ns2plus dev mode enabled. Need to confirm it's accurate before displaying it to everybody again.
    
- 12/07/2019
   - Fixed incorrect calculation of average team skill for the end game hive skill graph (Thanks to Glitch)
   - Removed link to player's observatory profile at scoreboard
   
- 20/06/2019
    - Removed server options to display numeric skill values directly at the scoreboard GUI
    - Fixed that the team hive skill graph at the end game stats GUI wasn't tracking changes correctly
    - Fixed that the commander visibility value of map cinematics and props wasn't applied properly.
    - Fixed that player and structure damage values for each weapon weren't displayed at the end game stats GUI
    - Added a console command to export available ns2plus options and their descriptions to a csv table
- 20/12/2018
    - Fixed compatibility issues with ns2 build 326
    - Optimized server stats code
    
- 12/11/2018
    - Fixed that the separate team color option for the cr4zy alien vision didn't work anymore (Thanks to Handschuh)
    - Fixed that the low lights for ns2_descent were too dark in many areas (Thanks Zavaro)
    
- 29/10/2018
    - Optimized the reload indicator code (Thanks Handschuh)
    - Refactored the map particles option code. The option now takes effect immediably.
    - Optimized the usage of certain event hooks to avoid causing engine crashes.
    - Fixed and optimized the low lights for ns2_descent (Thanks Zavaro)
    
- 5/9/2018
    - Fixed script error introduced from Skill Tier icon tooltips

- 13/7/2018
    - Fixed that the used team victory probability formula was incorrect. (Thanks Las)
    - Fixed that the team victory probability was displayed even if one team doesn't have any players yet.
    - Fixed that the observatory scoreboard link wasn’t using https. (Thanks Morrolan)
    - Reset the hive skill related server options. Server operators can re-enable them via sv_plus.

- 7/4/2018
    - Fixed a script error that could occur opening the ns2+options in-game
    - Fixed that predict conflicted with the weapon slot mode of the alien ability select option.
    
- 6/4/2018
    - Replaced all Elixer methods with the new DebugUltility methods
    - Added an option to choose how to select alien abilities. This allows to select metabolize to be selected as weapon once again.
      - Todo:
        - I'm planning to expand this feature to support all abilities and  pure key bound ability activation.
        - Additionally currently selecting metabolize has a short delay due to the way the weapon select is handled at the server side.
      
- 28/3/2018
    - Fixed that the hive skill graph uses the skill maximum as initial minimum
    - Fixed that spectators were considered as alien players at the beginning of a round by the hive skill graph
 
- 27/3/2018
    - Fixed a script error that caused the end stats GUI to fail initializing causing the client's UI to become unresponsive.
    - Made sure that the end stats GUI initializes completely even if it fails to load the LastRoundStats.json due to a script error.
    - Improved how the hiveskillgraph records players joining teams to fix issues with failed team join attempts and players moving to the spectator team
    - Improved the y axis scaling of the hive skill graph to not start at negative values and use a more useful grid resolution.

- 26/3/2018
    - Added an indicator icon for being on fire for everybody using the hidden viewmodel option
    - Added an option to configurate the color of marines when using Cr4zy's Alienvision
    - Added a graph displaying each team's avg. hive skill over the time of the round to the end round stats view.
    - Added an option to display the current time below the minimap
    - Added an option to display the probability of victory for each team at the scoreboard (needs to be enabled by the server admin)
    - Fixed a comaptibility issue with some mods caused by a missing argument in GetEnergyCost
    - Fixed that the custom alien minimap color was not applied to embyros (evolving players)
    - Fixed that the current round time was not displayed for the commander when the given option is enabled
    - Fixed a rare script error occurring while spectating a dying enemy.
    - Fixed that the information (e.g. hp percentage) of the custom nameplates did not update instantly.
    - Fixed that the research progress tooltip started fading out at creation of the tooltip. This caused the tooltip often to not even show up.
    - Fixed that the exo's left minigun's cinematics did not get hidden with minimal particles or hidden viewmodel options enabled.

- 26/12/2017
	- Fixed compatibility problem with b320 emissive-toggle change (power-state changes)
	- Fixed that the custom nameplate style options did not work. Please note that the displayed information of the custom nameplate styles may only update every 200 ms.
	
- 6/12/2017
    - Fixed that the end stats hover menu consumed the player's input after initialization without being visible.
    
- 4/12/2017
    - Added Observatory (https://observatory.morrolan.ch) profile links to the scoreboard and end stats
    - Fixed that the player entry hover menu of the end stats was hidden instantly
    - Fixed that the overhead research tooltips displayed a negative research time after completion
    
- 27/10/2017
    - Fixed compatibility issues with ns2 build 319
    - Added per-lifeform sensitivity for aliens
    - Added some screen-occluding effects of gorge tunnels and embryos to be disabled when minimal particles is enabled

- 6/10/2017
    - Fixed that you couldn't pickup weapons with autopickup disabled with build 318
        

- 30/08/2017
    - Fixed that the hivestatus UI was hidden by default.
    - Fixed that the hide friends at the minimap option still had no effect.
    - Fixed that the minimap location name alpha option did not work and caused script errors.
    - Fixed a script error occurring for commanders caused by the research time tool tips trying to update before the Commander has been fully initialized
    
- 28/08/2017
    - Fixed that the research time tooltips did not work for Commanders
    - Fixed that the mingui option did not effect some minimap and gorge build menu backgrounds
    - Fixed that the custom minimap color options (including hidding friends) had no effect.
    - Fixed a script error occurring while spectating a marine reloading their shotgun.
    - Fixed a script error occurring while spectating a gorge placing structures.
    - Changed the hivestatus option entry to behave like the other option toogles.

- 24/08/2017
	- Refactored the way GUI modifications are loaded to fix and avoid load order issues with new ns2 updates.
	- Fixed the critical performance issues caused by various GUI modifications.
	- Removed the death message icon scaling option because it wasn't working in all situations.
	- Removed the remote config trolling system.
	- Removed the remote config badge system.
	- Updated or removed all outdated web references.
	- Added reload indicators around the crosshair. Also displays ability cool downs for aliens.
	- Made exo overheat UI display proper values to show when we are able to fire again.
	- Added a new option to completely disable the hive status UI.
    - The existing minimal GUI option now removes some background elements from the hive status UI.
    - Added research times to overhead view tech tool tips
      
- 26/05/2017
    - Fixed compatibility issues with the new ns2 help screen	

- 05/03/2017
    - Removed the wc badges as those are part of vanilla ns2 now
    - Refactored the way the gamemode is set in the serverbrowser to avoid conflicts with future ns2 updates
	
- 09/02/2017
    - Improved the stats tracking to work better with recent ns2 changes.

- 28/09/2016
	- Fixed Server Browser ranked filter not working correctly
	- Fix End game stats issue with warmup mode
    
- 15/07/2016
	- Fix enemy health bars showing up while spawning in
    
- 22/06/2016
	- Fixed compatibility issue between feedback GUI and NS2+ end stats
    
- 10/06/2016
	- Take warmup mode into account when checking for game start
    
- 03/06/2016
	- Fixed server browser tabs not showing correct player counts
    
- 31/05/32016
	- Reset options that have been integreated to vanilla
	- Fixed resetting non-slider options in NS2+

- 20/05/2015
	- Autopickup integrated into vanilla
	- Colored wrench integrated to vanilla
	- Khamm range circles integrated to vanilla
	- AV state default to ON integrated to vanilla

    
- 30/04/2016
	- Added High Visibility Gorge spit option, available in Graphics tab (Thanks turtsmcgurts!).

- 23/03/2016
	- Fixed End Stats UI not resizing properly on resolution change sometimes.
	- Fixed options menu displaying reset option button for hidden options in certain circumstances.

- 22/02/2016
	- Added doerLocation and doerPosition to certain kills in the KillFeed table for exported stats to support proper positions for turrets, whips, hydras, etc.

- 10/02/2016
	- Excluded bots from the average skill calculation.
	- Fixed hallucinations not using their own color if the player was using a custom alien minimap color.
	
- 30/01/2011
	- Added shown/total server count to server browser.
	- Added NSL info to scoreboard hover menu for NSL servers.
	- Adjusted server tagging for NSL servers.

- 29/01/2016
	- Added Cr4zy's configurable Alien Vision (Thanks Cr4zy!).
	- Added checkbox in the Server Browser to hide Rookie Only servers.
	- Added button to filter for Hive Whitelisted servers in the Server Browser. The button will only display if the client is able to successfully download the list of whitelisted servers.
	- Moved all weapon pickup options out of "HUD" and into "MISC".
	- Moved weapon tracers from "HUD" into "GRAPHICS".

- 26/01/2016
	- Changed rookieFriendly to rookieOnly for the exported stats as the rookieFriendly tag is now deprecated in Build 282.

- 25/01/2016
	- Added NSL server highlighting, they will show up in blue and will append "NSL" to the gamemode for easy filtering.
	- Excluded team specific FOV and sensitivities from caster mode.
	- Fixed missing percentage sign for exo weapons on classic ammo.
	- Added NSL lights json files to consistency check.
	- Fixed exos not showing proper outline color in overhead spectator.
	
- 13/01/2016
	- Fixed unbuilt RT deaths showing up in the RT graph (allowed for negative RT counts).
	- Stats format changes:
		- Renamed pdmg and sdmg fields to playerDamage and structureDamage.
		- Removed "last" table from player stats which was only meant for internal use.
		- Renamed KillGraph to KillFeed.
		- Renamed ClientStats to PlayerStats.
		- Renamed "weapon" field to "killerWeapon" and "teamNumber" to "killerTeamNumber" in the KillFeed table.
		- Changed "gameMinute" field in KillFeed table to "gameTime", which now returns the time in seconds.
		- Renamed "roundTime" field in RoundInfo table to "roundLength".
		- Fixed kills not showing the killer weapon in the KillFeed table if the player had left the server.

- 12/01/2016
	- Updated exported stats data format.
	- Fixed bug with Marine Commander Medpack accuracy being calculated wrong.

- 10/01/2016
	- RT graph table now contains if the node was recycled.
	- Tech table now contains if (in case of buildings) it was finished and if it was recycled.

- 09/01/2016
	- Fixed bug that wouldn't ignore maxPlayers for each team while the game wasn't live.
	- Removed server option for disabling Hive HTTP connections.
	- New data points for the exported stats:
		- Minimap extents for mapping coordinates to the overview graphic.
		- Destroyed tech in Tech Log, also shows Biomass level on Hive death. If the last Hive was killed it will show as Biomass 1 being "destroyed".
		- Killer/victim class in the kills table.
	- End game stats now shows the loss of important buildings in the Tech Log and Biomass level on Hive death.

- 06/01/2016
	- Added "savestats" option to the server settings (default off). This option allows servers to save the round stats info in a json file located at (CONFIGFOLDER)\NS2Plus\Stats\. Each round will generate a separate file. Mods can also access this info directly by calling CHUDGetLastRoundStats().