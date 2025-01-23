--[[
Name: "sh_book_tfw.lua".
Product: "Infusion".
--]]

ITEM = openAura.item:New();

ITEM.base = "book_base";
ITEM.name = ":: Metro Communist Manifesto ::";
ITEM.model = "models/stalker/item/handhelds/files1.mdl";
ITEM.cost = 11;
ITEM.uniqueID = "book_mcm";
ITEM.description = "A book about communism.";
ITEM.bookInformation = [[
[CENTER][SIZE=6]:: [I][B][COLOR=#800000]Metro Communist Manifesto[/COLOR][/B][/I] ::[/SIZE][/CENTER]

Greetings Comrade! Let me first applaude you for choosing to read this book, either be it your own free time or if you are being required to read this due to a re-education course, you are sure to gain crucial knowledge about the Red Line! Our General Secratary would be proud! 

We will be touching upon three main points:
1. [B]Loyalty to the State[/B]
2. [B]Our Military[/B]
3. [B]Our Views on the Fascists[/B]

----------------------------------------------------------

:: [B](1)[/B] [I][B][COLOR=#800000]Loyalty to the State[/COLOR][/B][/I] ::

Each citizen of the Red Line should do everything in their power to protect their station and their comrades from any form of threat, even if that threat is their family. Report any Anti-Communist activity to a soldier as soon as you can, There are consequences for not reporting such activity! 

Disloyalty to the state can range from various forms of punishment, from spending time in the stocks to execution! Each and every report is sent to our Beloved Colonel Rurik or one of his officers for review.

As stated above, each member of the Red Line should be willing to do anything to protect their home, this includes fighting in the Military. Please navigate to the next section for more information on this topic.
----------------------------------------------------------
:: [B](2)[/B] [I][B][COLOR=#800000]Our Military [/COLOR][/B][/I]::

Each man or woman who signs onto the military gets a full magazine of ammunition for their weapon! [I]That is a whole magazine of ammunition to protect your station from harm with![/I]

We are in command of the largest fighting force in the metro! The mere mention of our name strikes fear into the hearts of those who oppose us, enlist and become part of the cause!

When there is a large fight ongoing, citizens of the Red Line should rise up to assist their comrades by instinct. In some cases however, there are people who need a nudge in the right direction, conscription is necessary when dealing with these kind of people. Do not let this be you!
----------------------------------------------------------
:: [B](3)[/B][I][B] [COLOR=#800000]Our Views on Fascism [/COLOR][/B][/I]::

There is no other words to describe these individuals except for "[I]Pigs[/I]". Filthy, dirty pigs who wish to do nothing more than cause havoc in our metro. They promise to bring peace and serenity, yet all they bring is war and death!

These monsters are responsible for the deaths of hundreds innocent civilians, then they have the nerve to say [I]we[/I] are what is causing problems in the metro! They lie just as easy as they breath, they are nothing more than dirt that must be cleaned from the tunnels of our fine metro. 

Do you wish to fight these pigs? These Rapists of our motherland? Find your local recruiting officer and join the ranks of the military! Let us put a stop to this plauge.

----------------------------------------------------------

----------------------------------------------------------
]];

openAura.item:Register(ITEM);