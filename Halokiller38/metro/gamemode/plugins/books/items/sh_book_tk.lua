--[[
Name: "sh_book_tfw.lua".
Product: "Infusion".
--]]

ITEM = openAura.item:New();

ITEM.base = "book_base";
ITEM.name = "Keeper's Journal.";
ITEM.model = "models/props_lab/bindergraylabel01b.mdl";
ITEM.cost = 11;
ITEM.uniqueID = "book_kj";
ITEM.description = "A blood-stained gray book.";
ITEM.bookInformation = [[
<font color='red' size='4'>Written by The Keeper's.</font>

May 9, 1998 

    At night, we played poker with 
    Scott the guard, Alias and Steve 
    the research. 

    Steve was the big winner, but I 
    think he was cheating. 
    What a scumbag. 


    May 10th 1998 

    Today, a high ranking researcher 
    asked me to take care of a new 
    monster. 
    It looks like a gorilla without 
    any skin. They told me to feed 
    them live food. When I threw in 
    a pig, they were playing with 
    it... tearing off the pig's legs 
    and pulling out the guts before 
    they actually ate it. 


    May 11th 1998 

    Around 5 o'clock this morning, 
    Scott came in and woke me up 
    suddenly. He was wearing a 
    protective suit that looks like 
    a space suit. He told me to put 
    one on as well. 
    I heard there was an accident in 
    the basement lab. 
    It's no wonder, those researchers 
    never rest, even at night. 


    May 12th 1998 

    I've been wearing this annoying 
    space suit since yesterday, my 
    skin grows musty and feels very 
    itchy. 
    By way of revenge, I didn't feed 
    those dogs today. 
    Now I feel better. 


    May 13th 1998 

    I went to the medical room 
    because my back is all swollen 
    and feels itchy. 
    They put a big bandage on my 
    back and the doctor told me I 
    did not need to wear the space 
    suit any more. 
    I guess I can sleep well tonight. 


    May 14th 1998 

    When I woke up this morning, I 
    found another blister on my foot. 
    It was annoying and I ended up 
    dragging my foot as I went to 
    the dog's pen. They have been 
    quiet since morning, which is 
    unusual. I found that some 
    of them had escaped. 
    I'll be in real trouble if the 
    higher-ups find out. 


    May 15th 1998 

    Even though I didn't feel well, 
    I decided to go see Nancy. 
    It's my first day off in a long 
    time but I was stopped by the 
    guard on the way out.

	 May 16th 1998 

    I heard a researcher who tried 
    to escape from this mansion was 
    shot last night. 
    My entire body feels burning and 
    itchy at night. 
    When I was scratching the 
    swelling on my arms, a lump of 
    rotten flesh dropped off. 
    What the hell is happening to me? 


    May 19, 1998 

    Fever gone but itchy. 
    Hungry and eat doggy food. 
    Itchy Itchy Scott came. 
    Ugly face so killed him. 
    Tasty. 

                4. 

            Itchy. 
            Tasty.
]];

openAura.item:Register(ITEM);