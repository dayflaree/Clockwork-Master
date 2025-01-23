--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.base = "book_base";
ITEM.name = "The Artifact Book";
ITEM.model = "models/props_lab/bindergraylabel01b.mdl";
ITEM.uniqueID = "book_art";
ITEM.description = "A Book with a artifact logo on it usefull for artifact hunting.";
ITEM.bookInformation = [[
<font color='red' size='4'>Written by The Artifact Hunter.</font>

This book is written by the artifact hunter Donski, it will teach you about the artifacts that is around The zone.

Blood Stone: 
An artifact formed in the "Whirligig" anomaly.
A deformed, reddish object made of compressed, oddly twisted, 
polymerized scraps of plants, soil and bones.
A popular superstition among stalkers is that the strength of people perished in the anomaly is contained in the artifact.
Quite common, hence not very valuable. The artifact is of primary interest to scientific, primarily medical,
organizations and various cult members.

Crystal: 
This artifact is formed in anomalous zones with intense thermal activity.
Actively consumes excessive heat, remaining cool to the touch throughout. Emits radiation. 
It is created when heavy metals fall into the Burner anomaly. This artifact eliminates radiation wonderfully.
It is highly valued by stalkers and hard to find.

Crystal Thorn:
Crystallizes in the anomaly Burnt Fuzz.
Naturally takes out the radiation from the organism. That is, through the ears along with some amount of blood. Blood loss is possible also through other openings.
Widespread and quite effective, which is the cause for the stable price in the artifact market.

Droplet:
Formed in the Burner anomaly at high temperatures. From the exterior looks like a tear-like shade compound with a glossy surface, covered in cracks.
It got a common price on the market.

Electro Battery:
The origin of this object is shrouded in scientific mystery. It's clear that it's made in part by di-electric elements, but science does not know the physical conditions in which it is formed.
The Artifact got a good price on the market.

Fireball:
Crystallizes in the anomaly Burner. Fights well with radioactivity, though the heightened rate of energy exchange wears out the muscles of the moving apparatus. Won't be able to run for long. Artifact emits heat.
The price in the market for this is good.

Flash:
"Electro" sometimes births this artifact. Stalkers readily use it because of its good qualities. Not a bad price and a good external look make this artifact appealing to collectors.

Goldfish:
An artifact formed in the Vortex anomaly. Is activated by the heat of the body. Decide what's worse: radiation or knife wounds, and chose the lesser of the two evils. In any case you can sell the artifact for good profit.

Gravi:
The artifact is a brownish, twisted lump, created when metallic substances are exposed to strong gravitational fields for extended periods of time. It creates a weak antigravitational field, often used by stalkers to increase their carrying capacity.
Or sold by a good amount of money.

Jellyfish:
Is formed in the Springboard. Forms a weak protective field whose side effect is a slight radiation. The artifact is widespread and not very valuable.

Mama’s Bead:
Shaped like a DNA helix, the beads are created in the Burner anomaly and pulsate, generating emissions beneficial to the human body. These emissions increase the metabolism of any living creature, accelerating clotting and healing of open wounds. The exact mechanism behind this artifact continues to puzzle scientists. Emits radiation and also sold for a good price.

Meat Chunk:
It causes increased cell growth. On the other hand, the newly formed cells are much more receptive to the effects of physical uranium. The artifact doesn't show up very often, but it's hard to call it rare.

Mica:
Anomaly "Fruit Punch" is able to create such an artifact at the rarest, most extreme collection of physical conditions. The result is a semi-transparent, hard object. A rare and expensive artifact.

Moonlight:
This artifact is formed in Electro anomalies on rare occasions. It has the most powerful restorative abilities, at the cost of resistance to electricity. Rare and expensive artifact.

Night Star:
This wonderful artifact is formed by the Springboard anomaly. The use of the artifact demands the neutralization of deadly radiation. Expensive and rare, this artifact is extremely interesting for scientific expeditions and other research activity in the Zone.

Slime:
It is certain that this artifact is created by the anomaly called "Fruit Punch". When carried on the belt, the wounds bleed less, although the body of its owner becomes vulnerable to various burns.
This artifact got a good price on the market.

Slug: 
Formed by the "Fruit Punch" anomaly. The negative qualities of this artifact are compensated by the fact that it heightens the coagulation quality of blood. It's not often that one runs into such an artifact, and they pay well for it too.

Soul: 
Very rarely found artifact, located near the Whirligig anomaly. Only a very few manage to find this artifact, and few have even seen it. It has a nice shape and an equally nice price.

Spring:
According to the opinion of some researchers-theorists, this artifact is a hybrid between Batteries and Shell.
It also got an common price on the market.

Stone Flower:
Born in the Springboard anomaly. This artifact is found in only a few areas of the Zone. The bits of metallic compounds create a beautiful light play. It is very calming to study this artifact at night by the fire.
It got a good price on the market.

Thorn:
The result of the interaction between the anomaly Burnt Fuzz and the body of a careless stalker. The Thorn artifact pikes the body of its owner, no matter what. But it also helps clean the body of radionucliodes. Quite widespread and cheap.

Urchin:
The anomaly Burnt Fuzz very rarely gives rise to this artifact. Blood pressure rises, the body gets rid of a large amount of red blood cells. But along with them the stored radiation leaves the body as well. In his fundamental work titled "Ionization and polarization of the components of rare artifacts", Sakharov noted that the content of this formation has a critical stability, and it's not realistic to create such an artifact in lab conditions in the next ten years.

]];

openAura.item:Register(ITEM);