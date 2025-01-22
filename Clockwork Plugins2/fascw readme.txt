It uses 3 Firearms Source plugins, I spent time to create these with customizable damage and such but we came to a conclusion that they wouldn't be needed.

Go to the entities\weapons folder and choose the weapon you want to edit the damage of before accessing the shared.lua file to edit the damage, this package uses the Firearms Source addon, the firearms source insurgency weapons addon and one other addon I can't remember.

Edit this line to change the damage it does: SWEP.Primary.Damage = 25

Overall 57 new weapons are in this package, there's a bug with Firearms Source that sometimes they lose their sounds and shit but I can't do anything about that so deal with it.

Also every weapon is an attachment to the body and the weights are configured so that the pistols are always secondary weapons and rifles/smg's are primary weapons.

You may need to download this and upload it manually to addons folder:
http://gmod.gamebanana.com/skins/122672
1: Go to server.cfg and add these two lines there: sim_manualholster_t 0 sim_crosshair_t 0
2: Copy the facw folder over to gamemodeschema\plugins
3: Done.

If you want to edit weapon damages go over to plugins\facw\entities\weapons\weaponname and open the shared.lua, find the SWEP.primaryDamage line and edit the damage there, same with recoil.

There are around 50+ weapons, I made them so they won?t show up in business menu, if you want to edit the description/name go to sh_weapon_weaponname.lua and do it there.

To edit ammo names/descriptions/amounts/models go to sh_ammo_fasammo_ammoname.lua and edit them there.

Thanks for the help to scrubmcnoob and Bork, love ya.
Readme^^

Think it uses these addons:

http://steamcommunity.com/sharedfiles/filedetails/?id=104700241
http://steamcommunity.com/sharedfiles/filedetails/?id=104495009
http://steamcommunity.com/sharedfiles/filedetails/?id=104502728

You may have to manually download them and upload on the server.