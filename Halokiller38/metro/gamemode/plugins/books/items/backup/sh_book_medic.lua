--[[
Name: "sh_book_tfw.lua".
Product: "Infusion".
--]]

ITEM = openAura.item:New();

ITEM.base = "book_base";
ITEM.name = "Guide on wounds and other Medical things.";
ITEM.model = "models/props_lab/bindergreenlabel.mdl";
ITEM.uniqueID = "book_medic";
ITEM.cost = 20;
ITEM.description = "A Pretty up to date book - got written up recently.";
ITEM.bookInformation = [[
Guide on wounds and other medical specific things.


Introduction:


[B]List of things:[/B]
0. Medical RP in general ((Both sides))
0.1 As soldier or wounded

1. Wounds
1.1 Cuts
1.2 Burns
1.3 Bullets
1.4 More to add?

2. How to treat them?
2.1 Cuts
2.2 Burns
2.3 Bullets

3.Medical Equiment
3.1 On Field
3.2 Medbay
3.3 Available if ordered
[COLOR="lime"][/COLOR]
[B]0.1 Bad example:[/B]
[COLOR="lime"]Survivor:[/COLOR] Fuck im wounded, can you help me?
[COLOR="navy"]Medic:[/COLOR] Sure! *Patches him up with morphine and adds a bandage*


[B]0.1 Good example[/B]
[COLOR="lime"]Survivor>:[I]*Comes in with a bleeding leg wound that is barely bandaged and a bloody bandage on his right side*[/I]
[COLOR="navy"]Medic[/COLOR] : [I]*Tells him to sit down and prepares medical equipment* So what do we have here?..[/I]
[COLOR="lime"]Survivor[/COLOR]: [I]Bullet shots in my side, and a cut on my left leg....how you can see..*Can barely stay awake*[/I]
[COLOR="navy"]Medic[/COLOR] :[I]I will give you some morphine first...*Prepares a needle and puts arround 30mg of morphine in it, injecting it to his arm* Well, we really cant do much about the leg right now, but applying a bandage and giving you some HRIM ((Health Regeneration Increasing Medicals)), about the bullets, we will get those out..[/I]
[COLOR="lime"]Survivor[/COLOR]: [I]Ngh...okay..*Watches what the medic does next*[/I]
[COLOR="navy"]Medic[/COLOR] : [I]*Prepares a forceps and removes his bandage at the side* This will still cause some pain though...*Uses a camera to locate the bullets and starts to pull one out slowly as he detects it.*[/I]
[COLOR="lime"]Survivor[/COLOR] :[I]*Tries to not start crying as it hurts when the medic pulls out the bullet.*
....Continue in your mind! You got my point! Remember that this is an example, in RP this will most likely be in a short form, but its still not like: Morphine + Bandage = Everything okay! It needs time to regenerate wounds, even with “HRIM".[/I]

[B]1. Wounds[/B]
Possibly the most important part of this guide, it explains to you, what wounds can occur on a battlefield or on the wastelands - or being attacked by zombies. How they look, and how you acquire them!
[B]1.1 Cuts:[/B]
Cuts are not often occuring on the modern wastelands, but there are still some situations where you can get them, if you are attacked by a knife wielding hostile or a zombie for example. I think you all know how a cut looks, even if it doesnt occur so often it can kill you. Places where cuts are deadly, are the throat, the head, the chest, and the thigh.


[B]1.2 Burns[/B]
Burns are actually classified into 4 “degrees”

[U]1st Degree:[/U]
First degree burns are the most common burns, (Redness of skin and such.)

[U]2nd Degree:[/U]
Second degree burns are the one's with blisters and such.
 
[U]3rd Degree:[/U]
Third degree burns are more whiter/redder and less painful than second degree burns.
 
[U]4th Degree:[/U]
Fourth degree burns are infact less painful and in some cases painless due to the nerves being burned and killed which stops pain messages being sent to the brain. 


[B]1.3 Bullets[/B]
The most likely wound on the modern wasteland. I hope not one of you have experienced this in real life, they are really, I mean; really painfull. Its not like: *Gets a bullet in his leg, falls down and stands up again*. I classify bullet wounds into 3 categories.
  1. Shots that go through the part where it entered ((Also called: Clear bullet wound))
  2. Shots that stick in your body so you can still see it (( Called: Stopped bullet wound))
  3. Shots that stick in your body that you cant see, and need to be pulled out as fast as they can. ((Called: Stuck bullet wounds))
The most painful of that is the 3rd one, cause it still causes pain even when you got the shot 1 hour ago but the bullet is still inside.
Medically seen better than the third is the 1st cause the wound can heal most likely in some days with HRIM. Its still a problem cause the progress takes longer than:
2nd. This is the best what could actually happen to a soldier or others: They could even pull the bullet out themselves, and it regenerates fast.

[B]2.How to treat them[/B]

2.1 You cant do much about cuts, you can bandage them, apply HRIM and a antiseptic so it doesn't gets even worse.

2.2 Possibly the most complicated. Leave it open, apply HRIM, NO ANTISEPTIC IF OVER 2nd degree! Also try to add medigel if you are on field, which will actually heal the wound in 5 minutes if it isn't a 4th degree.

2.3 The most easy wound you are able to treat if the bullet hasn't got into any organics like: Heart, Brain etc. if that happens you accidently need to call all available medics for a Surgical Operation. Its most likely complicated to get bullets out of organs, without hurting those even more, use KOP ((In common talk: Knockout Pills)) to make the wounded unconscinious while surgery.


[B]3. Medical Equipment[/B]
1. On the wastes...
1.Morphine: A Painkiller that is most likely used in 30 mg doses and will stop most of pain that can occur while getting out bullets etc.
2. Scalpel: Your best friends if it comes to get sharps or bullets out of not with a forceps acessable part of body
3. Forceps: Your equipment if it comes to pulling out bullets.
4.. Medical gloves: Put them on if you have the time! It will safe the wounded from unneeded infections!
5. Medical scissors: Used for bullets or other sharps that are located slightly in the body, not deep enough to use a forceps effectively.
6.. Opiatic+ Mark II: Antiseptic, allround used
7. MediGel: Used for 1st – 3rd degree burns on the field, also used for small-medium cuts.
8. ((If medical officer)): Defibrillators with a small energy cell.
9. Bandages bleeding, keeps organs in place and helps regenerating abit.

[B]3.2 Hospital Equiptment - Staff use only.[/B]
1. BHS 3: Used against 4th degree burns
10. Adrenaline
11. Biofoam: Used if there are no medics available, it stops
2. Opiatic++ Mark II: Antiseptic, stronger than the one used in field equipments
3. Small surgery laser: Used to burn out bullets that cant be removed with forceps, scalpel or medical scissors
4. Medical Mask: used in surgery, no more explanation needed i think?
5. HRIM ((Health Regeneration Increasing Medicals)) Basically the same as Biofoam but without the large pain that biofoam causes. It takes not as long time as biofoam does, and is a long time way to help wounds regnerating.
6. MediGel Mark II:Used for 4th degree burns, more effective than the normal MediGel.
]];

openAura.item:Register(ITEM);