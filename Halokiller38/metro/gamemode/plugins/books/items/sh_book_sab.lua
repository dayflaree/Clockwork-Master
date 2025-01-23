--[[
Name: "sh_book_tfw.lua".
Product: "Infusion".
--]]

ITEM = openAura.item:New();

ITEM.base = "book_base";
ITEM.name = "Russian Federation Small Arms Booklet";
ITEM.model = "models/props_lab/bindergraylabel01b.mdl";
ITEM.cost = 14;
ITEM.uniqueID = "book_sab";
ITEM.description = "A book about weapons.";
ITEM.bookInformation = [[

:: Russian Federation Small Arms Booklet ::

Our Armed Forces are some of the most well trained and discplined fighting forces on the face of the planet, willing to lay down their lives to protect the lives of their friends, family and neighbours. How do these brave souls do it? With some of finest pieces of military equipment ever created! Within this booklet you will be see the genius of Russian engineering and raw Russian power!

..:: Page One ::..
-- The Kalashnikov --

The most common rifle to be seen in service by ground units are members of the AK family. "A", meaning Avtomat. "K" Meaning Kalashnikov. This style of rifle is renound for its durability and reliability, having only 8 moving parts and very high tolerance levels, there is slim to no chance this weapon will ever go down on its operator. Let us cover some of the AK variants.
// ------- Part 1 -------
Key:
[Caliber]
(Rounds per Minute)
{Overall Length, Fully Extended}

:: AK-47 ::
[7.62 x 39mm]
(600 r/m)
{870mm}
The "Classic" AK, this rifle has been with our military since 1947, when Mikhail Kalashnikov invented it! It is no longer in field use, but is still used in ceremonial activities.

:: AKS-74M ::
[5.45 x 39mm]
(650 r/m)
{943mm}
Our current and most common rifle, used by almost all our of ground forces, this rifle is almost identicle to it's counterpart, the AK-47, except it has been modernized by improving aspects such as the stock, pistol grip, fore-grip, sighting aperture and other small elements.

// --------- Part 2 ---------

:: AKS-74u ::
[5.45 x 39mm]
(700 r/m)
{735mm}
This is a short barreled version of the AKS-74M, it also comes with a collapsable stock by manufacture. It has a heightened rate of fire due to a smaller length gas tube, however, having a short barrel and small gas tube make this weapon less accurate than it's counterparts.

:: AN-94 ::
[5.45 x 39mm]
(600 r/m)
{943mm}
A "Space Age" rifle, this new member of the Kalashnikov family was not make by Mikhail, but a man called Gennadiy Nikonov. Unlike prior Kalashnikov models, this rifle has a 2 round burst function. The most interesting part about this aspect is that when using the burst function, the first and second shots are both fired and clear the internals of the weapon before the operator even feels the first rounds recoil! This rifle is currently being used by Special Forces units.

// --------Page 3--------
..:: Page Two ::..
-- Attachments --

Sometimes our brave soldiers need more than a plain rifle to complete their job, that is why our military has created items that can be attached to a soldiers weapon to assist them in the completion of their task.

:: Suppressor ::

An attachment designed to hide the flash and report of the users rifle. Though not eliminating the weapons noise completely, the tool lowers it significantly.
:: GP-30 ::
[40mm]
(N/A)
{275mm}

A caseless stand alone or weapon mountable grenade launcher, this tool of destruction can obliterate cover and send those on the recieving end running.
]];

openAura.item:Register(ITEM);