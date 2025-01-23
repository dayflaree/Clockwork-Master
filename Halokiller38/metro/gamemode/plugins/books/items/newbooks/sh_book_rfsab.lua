--[[
Name: "sh_book_tfw.lua".
Product: "Infusion".
--]]

ITEM = openAura.item:New();

ITEM.base = "book_base";
ITEM.name = ":: Russian Federation Small Arms Booklet ::";
ITEM.model = "models/props_lab/bindergraylabel01b.mdl";
ITEM.cost = 14;
ITEM.uniqueID = "book_rfsab";
ITEM.description = "A book about weapons.";
ITEM.bookInformation = [[
[CENTER][COLOR=#800000][SIZE=5][COLOR=#808080]::[/COLOR] [U]Russian Federation Small Arms Booklet [/U][COLOR=#808080]::[/COLOR][/SIZE][/COLOR][/CENTER]

[SIZE=5]Our Armed Forces are some of the most well trained and discplined fighting forces on the face of the planet, willing to lay down their lives to protect the lives of their friends, family and neighbours. How do these brave souls do it? With some of finest pieces of military equipment ever created! Within this booklet you will be see the genius of Russian engineering and raw Russian power![/SIZE]

[B][SIZE=5]..:: [U]Page One[/U] ::..[/SIZE][/B]
[COLOR=#800000][B][SIZE=5]-- The Kalashnikov --[/SIZE][/B][/COLOR]

[COLOR=#808080][B]The most common rifle to be seen in service by ground units are members of the [I]AK[/I] family. "[I]A[/I]", meaning Avtomat. "[I]K[/I]" Meaning Kalashnikov. This style of rifle is renound for its durability and reliability, having only 8 moving parts and very high tolerance levels, there is slim to no chance this weapon will ever go down on its operator. Let us cover some of the [I]AK[/I] variants.[/B][/COLOR]
[COLOR=#ff00ff][B]// ------- Part 1 -------[/B][/COLOR]
[SIZE=5][COLOR=#808080][B][U][COLOR=#800000][I]Key[/I][/COLOR][/U]:[/B][/COLOR]
[SIZE=5][COLOR=#808080][B][Caliber][/B][/COLOR]
[SIZE=5][COLOR=#808080][B](Rounds per Minute)[/B][/COLOR]
[SIZE=5][COLOR=#808080][B]{Overall Length, Fully Extended}[/B][/COLOR]

[B][COLOR=#808080]:: [U][SIZE=5][COLOR=#800000]AK-47[/COLOR][/U] ::[/COLOR][/B]
[B][COLOR=#808080][[I]7.62 x 39mm[/I]][/COLOR][/B]
[B][COLOR=#808080]([I]600 r/m[/I])[/COLOR][/B]
[B][COLOR=#808080]{870mm}[/COLOR][/B]
[B][COLOR=#808080]The "Classic" AK, this rifle has been with our military since 1947, when Mikhail Kalashnikov invented it! It is no longer in field use, but is still used in ceremonial activities.[/COLOR][/B]

[B][COLOR=#808080]:: [U][SIZE=5][COLOR=#800000]AKS-74M[/COLOR][/U] ::[/COLOR][/B]
[B][COLOR=#808080][[I]5.45 x 39mm[/I]][/COLOR][/B]
[B][COLOR=#808080](650 r/m)[/COLOR][/B]
[B][COLOR=#808080]{943mm}[/COLOR][/B]
[B][COLOR=#808080]Our current and most common rifle, used by almost all our of ground forces, this rifle is almost identicle to it's counterpart, the AK-47, except it has been modernized by improving aspects such as the stock, pistol grip, fore-grip, sighting aperture and other small elements.[/COLOR][/B]

[COLOR=#ff00ff][B]// --------- Part 2 ---------[/B][/COLOR]

[B][COLOR=#808080][COLOR=#808080]:: [U][SIZE=5][COLOR=#800000]AKS-74u[/COLOR][/U] ::[/COLOR][/COLOR][/B]
[B][COLOR=#808080][COLOR=#808080][[I]5.45 x 39mm[/I]][/COLOR][/COLOR][/B]
[B][COLOR=#808080][COLOR=#808080](700 r/m)[/COLOR][/COLOR][/B]
[B][COLOR=#808080][COLOR=#808080]{735mm}[/COLOR][/COLOR][/B]
[B][COLOR=#808080][COLOR=#808080]This is a short barreled version of the AKS-74M, it also comes with a collapsable stock by manufacture. It has a heightened rate of fire due to a smaller length gas tube, however, having a short barrel and small gas tube make this weapon less accurate than it's counterparts.[/COLOR][/COLOR][/B]

[B][COLOR=#808080][COLOR=#808080]:: [U][SIZE=5][COLOR=#800000]AN-94 [/COLOR][/U]::[/COLOR][/COLOR][/B]
[B][COLOR=#808080][COLOR=#808080][[I]5.45 x 39mm[/I]][/COLOR][/COLOR][/B]
[B][COLOR=#808080][COLOR=#808080](600 r/m)[/COLOR][/COLOR][/B]
[B][COLOR=#808080][COLOR=#808080]{943mm}[/COLOR][/COLOR][/B]
[COLOR=#808080][B]A "Space Age" rifle, this new member of the Kalashnikov family was not make by Mikhail, but a man called Gennadiy Nikonov. Unlike prior Kalashnikov models, this rifle has a 2 round burst function. The most interesting part about this aspect is that when using the burst function, the first and second shots are both fired and clear the internals of the weapon before the operator even feels the first rounds recoil! This rifle is currently being used by Special Forces units.[/B][/COLOR]

[COLOR=#ff00ff][B]// --------Page 3--------[/B][/COLOR]
[COLOR=#808080][B]..:: [U]Page Two [/U]::..[/B][/COLOR]
[COLOR=#800000][B]-- Attachments --[/B][/COLOR]

[COLOR=#808080][B]Sometimes our brave soldiers need more than a plain rifle to complete their job, that is why our military has created items that can be attached to a soldiers weapon to assist them in the completion of their task.[/B][/COLOR]

[COLOR=#808080][B]:: [U][U][COLOR=#800000]Suppressor[/COLOR][/U][/U] ::[/B][/COLOR]

[COLOR=#808080][B]An attachment designed to hide the flash and report of the users rifle. Though not eliminating the weapons noise completely, the tool lowers it significantly.[/B][/COLOR]
[COLOR=#808080][B]:: [U][U][COLOR=#800000]GP-30[/COLOR][/U][/U] ::[/B][/COLOR]
[COLOR=#808080][B][[I]40mm[/I]][/B][/COLOR]
[COLOR=#808080][B](N/A)[/B][/COLOR]
[COLOR=#808080][B]{275mm}[/B][/COLOR]

[COLOR=#808080][B]A caseless stand alone or weapon mountable grenade launcher, this tool of destruction can obliterate cover and send those on the recieving end running.[/B][/COLOR]
]];

openAura.item:Register(ITEM);