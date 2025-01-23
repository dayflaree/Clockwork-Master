PLUGIN.Name = "Player Voices"; -- What is the plugin name
PLUGIN.Author = "Digital Soul RP"; -- Author of the plugin
PLUGIN.Description = "A set of voices"; -- The description or purpose of the plugin

function PLUGIN.Init( ) -- We run this in init, because this is called after the entire gamemode has been loaded.

	-- Human Voices
	
	--Questions
	LEMON.AddVoice("question01", "vo/npc/male01/question01.wav", 1, "I don't think this war is ever gonna end.", "vo/npc/female01/question01.wav");
	LEMON.AddVoice("question02", "vo/npc/male01/question02.wav", 1, "To think! All I wanted to do was sell insurance.", "vo/npc/female01/question02.wav");
	LEMON.AddVoice("question03", "vo/npc/male01/question03.wav", 1, "I don't dream anymore.", "vo/npc/female01/question03.wav");
	LEMON.AddVoice("question04", "vo/npc/male01/question04.wav", 1, "When this is all over I'm... nah, who am I kidding.", "vo/npc/female01/question04.wav");
	LEMON.AddVoice("question05", "vo/npc/male01/question05.wav", 1, "Woah. Dejavu.", "vo/npc/female01/question05.wav");
	LEMON.AddVoice("question06", "vo/npc/male01/question06.wav", 1, "Sometimes.. I dream about cheese.", "vo/npc/female01/question06.wav");
	LEMON.AddVoice("question07", "vo/npc/male01/question07.wav", 1, "You smell that? It's freedom.", "vo/npc/female01/question07.wav");
	LEMON.AddVoice("question08", "vo/npc/male01/question08.wav", 1, "If I ever get my hands on Doctor Breen..", "vo/npc/female01/question08.wav");
	LEMON.AddVoice("question09", "vo/npc/male01/question09.wav", 1, "I could eat a horse! Hooves and all..", "vo/npc/female01/question09.wav");
	LEMON.AddVoice("question10", "vo/npc/male01/question10.wav", 1, "I can't believe this day has finally come!", "vo/npc/female01/question10.wav");
	LEMON.AddVoice("question11", "vo/npc/male01/question11.wav", 1, "I'm pretty sure this isn't part of the plan.", "vo/npc/female01/question11.wav");
	LEMON.AddVoice("question12", "vo/npc/male01/question12.wav", 1, "Looks to me like things are getting worse, not better.", "vo/npc/female01/question12.wav");
	LEMON.AddVoice("question13", "vo/npc/male01/question13.wav", 1, "If I could live my life over again..", "vo/npc/female01/question13.wav");
	LEMON.AddVoice("question14", "vo/npc/male01/question14.wav", 1, "I'm not even gonna tell you what that reminds me of.", "vo/npc/female01/question14.wav");
	LEMON.AddVoice("question15", "vo/npc/male01/question15.wav", 1, "They're never gonna make a stalker out of me!", "vo/npc/female01/question15.wav");
	LEMON.AddVoice("question16", "vo/npc/male01/question16.wav", 1, "Finally! Change is in the air!", "vo/npc/female01/question16.wav");
	LEMON.AddVoice("question17", "vo/npc/male01/question17.wav", 1, "You feel it? I feel it.", "vo/npc/female01/question17.wav");
	LEMON.AddVoice("question18", "vo/npc/male01/question18.wav", 1, "I don't feel anything anymore.", "vo/npc/female01/question18.wav");
	LEMON.AddVoice("question19", "vo/npc/male01/question19.wav", 1, "I can't remember the last time I had a shower.", "vo/npc/female01/question19.wav");
	LEMON.AddVoice("question20", "vo/npc/male01/question20.wav", 1, "Some day.. this'll all be a bad memory.", "vo/npc/female01/question20.wav");
	LEMON.AddVoice("question21", "vo/npc/male01/question21.wav", 1, "I'm not a betting man, but the odds are not good.", "vo/npc/female01/question21.wav");
	LEMON.AddVoice("question22", "vo/npc/male01/question22.wav", 1, "Doesn't anyone care what I think?", "vo/npc/female01/question22.wav");
	LEMON.AddVoice("question23", "vo/npc/male01/question23.wav", 1, "I can't get this tune out of my head! *whistles*", "vo/npc/female01/question23.wav");
	LEMON.AddVoice("question25", "vo/npc/male01/question25.wav", 1, "I just knew it was gonna be one of those days.", "vo/npc/female01/question25.wav");
	LEMON.AddVoice("question26", "vo/npc/male01/question26.wav", 1, "This is bullshit!", "vo/npc/female01/question26.wav");
	LEMON.AddVoice("question27", "vo/npc/male01/question27.wav", 1, "I think I ate something bad..", "vo/npc/female01/question27.wav");
	LEMON.AddVoice("question28", "vo/npc/male01/question28.wav", 1, "God I'm hungry!", "vo/npc/female01/question28.wav");
	LEMON.AddVoice("question29", "vo/npc/male01/question29.wav", 1, "When this is all over, I'm gonna mate.", "vo/npc/female01/question29.wav");
	LEMON.AddVoice("question30", "vo/npc/male01/question30.wav", 1, "I'm glad there's no kids around to see this.", "vo/npc/female01/question30.wav");
	
	-- Answers
	LEMON.AddVoice("answer01", "vo/npc/male01/answer01.wav", 1, "That's you all over.", "vo/npc/female01/answer01.wav");
	LEMON.AddVoice("answer02", "vo/npc/male01/answer02.wav", 1, "I won't hold it against you.", "vo/npc/female01/answer02.wav");
	LEMON.AddVoice("answer03", "vo/npc/male01/answer03.wav", 1, "Figures.", "vo/npc/female01/answer03.wav");
	LEMON.AddVoice("answer04", "vo/npc/male01/answer04.wav", 1, "Try not to dwell on it.", "vo/npc/female01/answer04.wav");
	LEMON.AddVoice("answer05", "vo/npc/male01/answer05.wav", 1, "Can we talk about this later?", "vo/npc/female01/answer05.wav");
	LEMON.AddVoice("answer07", "vo/npc/male01/answer07.wav", 1, "Same here.", "vo/npc/female01/answer07.wav");
	LEMON.AddVoice("answer08", "vo/npc/male01/answer08.wav", 1, "I know what you mean.", "vo/npc/female01/answer08.wav");
	LEMON.AddVoice("answer09", "vo/npc/male01/answer09.wav", 1, "You're talking to yourself again.", "vo/npc/female01/answer09.wav");
	LEMON.AddVoice("answer10", "vo/npc/male01/answer10.wav", 1, "I wouldn't say that too loud.", "vo/npc/female01/answer10.wav");
	LEMON.AddVoice("answer11", "vo/npc/male01/answer11.wav", 1, "I'll put it on your tombstone!", "vo/npc/female01/answer11.wav");
	LEMON.AddVoice("answer12", "vo/npc/male01/answer12.wav", 1, "It doesn't bear thinking about.", "vo/npc/female01/answer12.wav");
	LEMON.AddVoice("answer13", "vo/npc/male01/answer13.wav", 1, "I'm with you.", "vo/npc/female01/answer13.wav");
	LEMON.AddVoice("answer14", "vo/npc/male01/answer14.wav", 1, "Heh! You and me both.", "vo/npc/female01/answer14.wav");
	LEMON.AddVoice("answer15", "vo/npc/male01/answer15.wav", 1, "Thaaats... one way of looking at it.", "vo/npc/female01/answer15.wav");
	LEMON.AddVoice("answer16", "vo/npc/male01/answer16.wav", 1, "Have you ever had an original thought?", "vo/npc/female01/answer16.wav");
	LEMON.AddVoice("answer17", "vo/npc/male01/answer17.wav", 1, "I'm not even gonna tell you to shut up.", "vo/npc/female01/answer17.wav");
	LEMON.AddVoice("answer18", "vo/npc/male01/answer18.wav", 1, "Let's concentrate on the task at hand!", "vo/npc/female01/answer18.wav");
	LEMON.AddVoice("answer19", "vo/npc/male01/answer19.wav", 1, "Keep your mind on your work!", "vo/npc/female01/answer19.wav");
	LEMON.AddVoice("answer20", "vo/npc/male01/answer20.wav", 1, "Your mind is in the gutter.", "vo/npc/female01/answer20.wav");
	LEMON.AddVoice("answer21", "vo/npc/male01/answer21.wav", 1, "Don't be so sure of that.", "vo/npc/female01/answer21.wav");
	LEMON.AddVoice("answer22", "vo/npc/male01/answer22.wav", 1, "You never know.", "vo/npc/female01/answer22.wav");
	LEMON.AddVoice("answer23", "vo/npc/male01/answer23.wav", 1, "You never can tell.", "vo/npc/female01/answer23.wav");
	LEMON.AddVoice("answer24", "vo/npc/male01/answer24.wav", 1, "Why are you telling ME?", "vo/npc/female01/answer24.wav");
	LEMON.AddVoice("answer25", "vo/npc/male01/answer25.wav", 1, "How about that?", "vo/npc/female01/answer25.wav");
	LEMON.AddVoice("answer26", "vo/npc/male01/answer26.wav", 1, "That's more information than I require.", "vo/npc/female01/answer26.wav");
	LEMON.AddVoice("answer27", "vo/npc/male01/answer27.wav", 1, "Heheh, wanna bet?", "vo/npc/female01/answer27.wav");
	LEMON.AddVoice("answer28", "vo/npc/male01/answer28.wav", 1, "I wish I had a dime for every time somebody said that.", "vo/npc/female01/answer28.wav");
	LEMON.AddVoice("answer29", "vo/npc/male01/answer29.wav", 1, "What am I supposed to do about it?", "vo/npc/female01/answer29.wav");
	LEMON.AddVoice("answer30", "vo/npc/male01/answer30.wav", 1, "You talkin to me?", "vo/npc/female01/answer30.wav");
	LEMON.AddVoice("answer31", "vo/npc/male01/answer31.wav", 1, "You should nip that kind of talk in the butt.", "vo/npc/female01/answer31.wav");
	LEMON.AddVoice("answer32", "vo/npc/male01/answer32.wav", 1, "Right on!", "vo/npc/female01/answer32.wav");
	LEMON.AddVoice("answer33", "vo/npc/male01/answer33.wav", 1, "No argument there.", "vo/npc/female01/answer33.wav");
	LEMON.AddVoice("answer34", "vo/npc/male01/answer34.wav", 1, "Don't forget Hawaii!", "vo/npc/female01/answer34.wav");
	LEMON.AddVoice("answer35", "vo/npc/male01/answer35.wav", 1, "Try not to let it get to you.", "vo/npc/female01/answer35.wav");
	LEMON.AddVoice("answer36", "vo/npc/male01/answer36.wav", 1, "Wouldn't be the first time.", "vo/npc/female01/answer36.wav");
	LEMON.AddVoice("answer37", "vo/npc/male01/answer37.wav", 1, "You sure about that?", "vo/npc/female01/answer37.wav");
	LEMON.AddVoice("answer38", "vo/npc/male01/answer38.wav", 1, "Leave it alone.", "vo/npc/female01/answer38.wav");
	LEMON.AddVoice("answer39", "vo/npc/male01/answer39.wav", 1, "That's enough out of you.", "vo/npc/female01/answer39.wav");
	LEMON.AddVoice("answer40", "vo/npc/male01/answer40.wav", 1, "There's a first time for everything.", "vo/npc/female01/answer40.wav");
	
	-- Other Stuff
	LEMON.AddVoice("doingsomething", "vo/npc/male01/doingsomething.wav", 1, "Shouldn't we.. uhh.. be doing something?", "vo/npc/female01/doingsomething.wav");
	LEMON.AddVoice("excuseme", "vo/npc/male01/excuseme01.wav", 1, "Excuse me.", "vo/npc/female01/excuseme01.wav");
	LEMON.AddVoice("fantastic", "vo/npc/male01/fantastic01.wav", 1, "Fantastic!", "vo/npc/female01/fantastic.wav");
	LEMON.AddVoice("finally", "vo/npc/male01/finally.wav", 1, "Finally.", "vo/npc/female01/finally.wav");
	LEMON.AddVoice("gethellout", "vo/npc/male01/gethellout.wav", 1, "/y Get the hell out of here!", "vo/npc/female01/gethellout.wav");
	LEMON.AddVoice("goodgod", "vo/npc/male01/goodgod.wav", 1, "Good god!", "vo/npc/female01/goodgod.wav");
	LEMON.AddVoice("gotone1", "vo/npc/male01/gotone01.wav", 1, "Got one!", "vo/npc/female01/gotone01.wav");
	LEMON.AddVoice("gotone2", "vo/npc/male01/gotone02.wav", 1, "Hahah! I got one!", "vo/npc/female01/.wav");
	LEMON.AddVoice("help", "vo/npc/male01/help01.wav", 1, "/y HELP!", "vo/npc/female01/help01.wav");
	LEMON.AddVoice("hi", "vo/npc/male01/hi01.wav", 1, "Hi.", "vo/npc/female01/hi01.wav");
	LEMON.AddVoice("illstayhere", "vo/npc/male01/illstayhere01.wav", 1, "I'll stay here.", "vo/npc/female01/illstayhere01.wav");
	LEMON.AddVoice("leadtheway", "vo/npc/male01/leadtheway01.wav", 1, "You lead the way!", "vo/npc/female01/leadtheway01.wav");
	LEMON.AddVoice("letsgo", "vo/npc/male01/letsgo01.wav", 1, "/y Let's go!", "vo/npc/female01/letsgo01.wav");
	LEMON.AddVoice("noscream1", "vo/npc/male01/no01.wav", 1, "No! NO!", "vo/npc/female01/no01.wav");
	LEMON.AddVoice("noscream2", "vo/npc/male01/no02.wav", 1, "/y Noooooo!", "vo/npc/female01/no02.wav");
	LEMON.AddVoice("imready", "vo/npc/male01/okimready01.wav", 1, "Ok, I'm ready.", "vo/npc/female01/okimready01.wav");
	LEMON.AddVoice("oneforme", "vo/npc/male01/oneforme.wav", 1, "One for me and one... for me.", "vo/npc/female01/oneforme.wav");
	LEMON.AddVoice("overhere", "vo/npc/male01/overhere01.wav", 1, "/y Hey, over here!", "vo/npc/female01/overhere01.wav");
	LEMON.AddVoice("runforyourlife", "vo/npc/male01/runforyourlife01.wav", 1, "/y Run for your life!", "vo/npc/female01/runforyourlife.wav");
	LEMON.AddVoice("sorry", "vo/npc/male01/sorry01.wav", 1, "Sorry.", "vo/npc/female01/sorry01.wav");
	LEMON.AddVoice("heregoesnothing", "vo/npc/male01/squad_affirm06.wav", 1, "Here goes nothing.", "vo/npc/female01/squad_affirm06.wav");
	LEMON.AddVoice("run", "vo/npc/male01/strider_run.wav", 1, "/y Ruuuuun!", "vo/npc/female01/strider_run.wav");
	LEMON.AddVoice("donicely", "vo/npc/male01/thislldonicely01.wav", 1, "This'll do nicely!", "vo/npc/female01/thislldonicely01.wav");
	LEMON.AddVoice("waitingsomebody", "vo/npc/male01/waitingsomebody.wav", 1, "You waiting for somebody?", "vo/npc/female01/waitingsomebody.wav");
	LEMON.AddVoice("whoops", "vo/npc/male01/whoops01.wav", 1, "Whoops.", "vo/npc/female01/whoops01.wav");
	LEMON.AddVoice("yeah", "vo/npc/male01/yeah02.wav", 1, "Yeah!", "vo/npc/female01/yeah02.wav");
	LEMON.AddVoice("yougotit", "vo/npc/male01/yougotit02.wav", 1, "You got it!", "vo/npc/female01/yougotit.wav");

	
	-- Combine
	LEMON.AddVoice("1199", "npc/metropolice/vo/11-99officerneedsassistance.wav", 2, "/radio 11-99, officer needs assistance!");
	LEMON.AddVoice("administer", "npc/metropolice/vo/administer.wav", 2, "Administer.");
	LEMON.AddVoice("affirmative", "npc/metropolice/vo/affirmative.wav", 2, "/radio Affirmative.");
	LEMON.AddVoice("youcango", "npc/metropolice/vo/allrightyoucango.wav", 2, "All right. You can go.");
	LEMON.AddVoice("movein", "npc/metropolice/vo/allunitsmovein.wav", 2, "/radio All units, move in.");
	LEMON.AddVoice("amputate", "npc/metropolice/vo/amputate.wav", 2, "Amputate.");
	LEMON.AddVoice("anticitizen", "npc/metropolice/vo/anticitizen.wav", 2, "Anticitizen.");
	LEMON.AddVoice("apply", "npc/metropolice/vo/apply.wav", 2, "Apply.");
	LEMON.AddVoice("cauterize", "npc/metropolice/vo/cauterize.wav", 2, "Cauterize.");
	LEMON.AddVoice("miscount", "npc/metropolice/vo/checkformiscount.wav", 2, "/radio Check for miscount.");
	LEMON.AddVoice("chuckle", "npc/metropolice/vo/chuckle.wav", 2, "/me chuckles");
	LEMON.AddVoice("citizen", "npc/metropolice/vo/citizen.wav", 2, "Citizen.");
	LEMON.AddVoice("control100percent", "npc/metropolice/vo/control100percent.wav", 2, "/radio Control is 100 percent at this location. No sign of that 647-E.");
	LEMON.AddVoice("controlsection", "npc/metropolice/vo/controlsection.wav", 2, "Control section.");
	LEMON.AddVoice("converging", "npc/metropolice/vo/converging.wav", 2, "Converging.");
	LEMON.AddVoice("copy", "npc/metropolice/vo/copy.wav", 2, "/radio Copy.");
	LEMON.AddVoice("coverme", "npc/metropolice/vo/covermegoingin.wav", 2, "Cover me, I'm going in!");
	LEMON.AddVoice("trespass", "npc/metropolice/vo/criminaltrespass63.wav", 2, "/radio 6-3 Criminal Trespass.");
	LEMON.AddVoice("destroythatcover", "npc/metropolice/vo/destroythatcover.wav", 2, "Destroy that cover!");
	LEMON.AddVoice("introuble", "npc/metropolice/vo/dispatchineed10-78.wav", 2, "/radio Dispatch, I need 10-78. Officer in trouble!");
	LEMON.AddVoice("document", "npc/metropolice/vo/document.wav", 2, "Document.");
	LEMON.AddVoice("dontmove", "npc/metropolice/vo/dontmove.wav", 2, "Don't move!");
	LEMON.AddVoice("verdictadministered", "npc/metropolice/vo/finalverdictadministered.wav", 2, "/radio Final verdict administered.");
	LEMON.AddVoice("finalwarning", "npc/metropolice/vo/finalwarning.wav", 2, "Final warning.");
	LEMON.AddVoice("firstwarningmove", "npc/metropolice/vo/firstwarningmove.wav", 2, "First warning. Move away.");
	LEMON.AddVoice("getdown", "npc/metropolice/vo/getdown.wav", 2, "/y Get down!");
	LEMON.AddVoice("getoutofhere", "npc/metropolice/vo/getoutofhere.wav", 2, "Get out of here.");
	LEMON.AddVoice("grenade", "npc/metropolice/vo/grenade.wav", 2, "/y Grenade!");
	LEMON.AddVoice("help", "npc/metropolice/vo/help.wav", 2, "/y Help!");
	LEMON.AddVoice("hesrunning", "npc/metropolice/vo/hesrunning.wav", 2, "/radio He's running!");
	LEMON.AddVoice("holdit", "npc/metropolice/vo/holdit.wav", 2, "/y Hold it!");
	LEMON.AddVoice("investigate", "npc/metropolice/vo/investigate.wav", 2, "/radio Investigate.");
	LEMON.AddVoice("investigating", "npc/metropolice/vo/investigating10-103.wav", 2, "/radio Investigating 10-103.");
	LEMON.AddVoice("movealong", "npc/metropolice/vo/isaidmovealong.wav", 2, "I said move along.");
	LEMON.AddVoice("isolate", "npc/metropolice/vo/isolate.wav", 2, "Isolate.");
	LEMON.AddVoice("keepmoving", "npc/metropolice/vo/keepmoving.wav", 2, "Keep moving.");
	LEMON.AddVoice("location", "npc/metropolice/vo/location.wav", 2, "/radio Location.");
	LEMON.AddVoice("nowgetoutofhere", "npc/metropolice/vo/nowgetoutofhere.wav", 2, "Now get out of here.");
	LEMON.AddVoice("officerneedshelp", "npc/metropolice/vo/officerneedshelp.wav", 2, "/radio Officer needs help!");
	LEMON.AddVoice("prosecute", "npc/metropolice/vo/prosecute.wav", 2, "Prosecute.");
	LEMON.AddVoice("residentialblock", "npc/metropolice/vo/residentialblock.wav", 2, "/radio Residential block.");
	LEMON.AddVoice("responding", "npc/metropolice/vo/responding.wav", 2, "/radio Responding.");
	LEMON.AddVoice("rodgerthat", "npc/metropolice/vo/rodgerthat.wav", 2, "/radio Rodger that.");
	LEMON.AddVoice("searchingforsuspect", "npc/metropolice/vo/searchingforsuspect.wav", 2, "/radio Searching for suspect, no status.");
	LEMON.AddVoice("shit", "npc/metropolice/vo/shit.wav", 2, "/y Shit!");
	LEMON.AddVoice("sweepingforsuspect", "npc/metropolice/vo/sweepingforsuspect.wav", 2, "/radio Sweeping for suspect.");
	LEMON.AddVoice("thereheis", "npc/metropolice/vo/thereheis.wav", 2, "/y There he is!");
	LEMON.AddVoice("unlawfulentry", "npc/metropolice/vo/unlawfulentry603.wav", 2, "/radio 603, unlawful entry.");
	LEMON.AddVoice("vacatecitizen", "npc/metropolice/vo/vacatecitizen.wav", 2, "Vacate, citizen.");
	LEMON.AddVoice("malcompliance", "npc/metropolice/vo/youwantamalcomplianceverdict.wav", 2, "You want a malcompliance verdict?");
	
	-- Vortigaunt
	LEMON.AddVoice("accompany", "vo/npc/vortigaunt/accompany.wav", 3, "Gladly we accompany.");
	LEMON.AddVoice("allowme", "vo/npc/vortigaunt/allowme.wav", 3, "Allow me.");
	LEMON.AddVoice("asyouwish", "vo/npc/vortigaunt/asyouwish.wav", 3, "As you wish.");
	LEMON.AddVoice("beofservice", "vo/npc/vortigaunt/beofservice.wav", 3, "Can we be of service?");
	LEMON.AddVoice("calm", "vo/npc/vortigaunt/calm.wav", 3, "Calm yourself.");
	LEMON.AddVoice("canconvice", "vo/npc/vortigaunt/canconvice.wav", 3, "Can we not convince you otherwise?");
	LEMON.AddVoice("caution", "vo/npc/vortigaunt/caution.wav", 3, "Caution!");
	LEMON.AddVoice("certainly", "vo/npc/vortigaunt/certainly.wav", 3, "Certainly.");
	LEMON.AddVoice("done", "vo/npc/vortigaunt/done.wav", 3, "Done.");
	LEMON.AddVoice("forfreedom", "vo/npc/vortigaunt/forfreedom.wav", 3, "/y For freedom!");
	LEMON.AddVoice("forward", "vo/npc/vortigaunt/forward.wav", 3, "Forward.");
	LEMON.AddVoice("halt", "vo/npc/vortigaunt/halt.wav", 3, "Halt.");
	LEMON.AddVoice("hopeless", "vo/npc/vortigaunt/hopeless.wav", 3, "Our cause seems hopeless.");
	LEMON.AddVoice("livetoserve", "vo/npc/vortigaunt/livetoserve.wav", 3, "We live to serve.");
	LEMON.AddVoice("persevere", "vo/npc/vortigaunt/persevere.wav", 3, "This is more than anyone can bear. But we will persevere.");
	LEMON.AddVoice("poet", "vo/npc/vortigaunt/poet.wav", 3, "Our finest poet describes it thus. Galum bala gilamar!");
	LEMON.AddVoice("prevail", "vo/npc/vortigaunt/prevail.wav", 3, "We shall prevail.");
	LEMON.AddVoice("whereto", "vo/npc/vortigaunt/whereto.wav", 3, "Where to now, and to what end?");
	LEMON.AddVoice("yes", "vo/npc/vortigaunt/yes.wav", 3, "Yes!");
	
end
	