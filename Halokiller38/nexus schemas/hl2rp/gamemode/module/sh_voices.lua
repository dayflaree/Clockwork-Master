--[[
Name: "sh_voices.lua".
Product: "Half-Life 2".
--]]

-- A function to add a voice.
function MODULE:AddVoice(faction, command, phrase, sound, female, menu)
	self.voices[#MODULE.voices + 1] = {
		command = command,
		faction = faction,
		phrase = phrase,
		female = female,
		sound = sound,
		menu = menu
	};
end;

-- A function to add a dispatch voice.
function MODULE:AddDispatchVoice(command, phrase, sound)
	self.dispatchVoices[#MODULE.dispatchVoices + 1] = {
		command = command,
		phrase = phrase,
		sound = sound
	};
end;

MODULE.voices = {};
MODULE.menuVoices = {};
MODULE.dispatchVoices = {};

MODULE:AddDispatchVoice("Anti-Citizen", "Attention ground units. Anti-citizen reported in this community. Code: LOCK, CAUTERIZE, STABILIZE.", "npc/overwatch/cityvoice/f_anticitizenreport_spkr.wav");
MODULE:AddDispatchVoice("Anti-Civil", "Protection team alert. Evidence of anti-civil activity in this community. Code: ASSEMBLE, PLAN, CONTAIN.", "npc/overwatch/cityvoice/f_anticivilevidence_3_spkr.wav");
MODULE:AddDispatchVoice("Person Interest", "Attention please. Unidentified person of interest confirm your civil status with local protection team immediately.", "npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav");
MODULE:AddDispatchVoice("Citizen Inaction", "Citizen reminder. Inaction is conspiracy. Report counter behaviour to a Civil Protection team immediately.", "npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav");
MODULE:AddDispatchVoice("Unrest Structure", "Alert community ground protection units, local unrest structure detected. ASSEMBLE, ADMINISTER, PACIFY.", "npc/overwatch/cityvoice/f_localunrest_spkr.wav");
MODULE:AddDispatchVoice("Status Evasion", "Attention protection team. Status evasion in progress in this community. RESPOND, ISOLATE, ENQUIRE.", "npc/overwatch/cityvoice/f_protectionresponse_1_spkr.wav");
MODULE:AddDispatchVoice("Lockdown", "Attention all ground protection teams. Judgment waiver now in effect. Capital prosecution is discretionary.", "npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav");
MODULE:AddDispatchVoice("Rations Deducted", "Attention occupants. Your block is now charged with permissive inactive cohesion. Five ration units deducted.", "npc/overwatch/cityvoice/f_rationunitsdeduct_3_spkr.wav");
MODULE:AddDispatchVoice("Inspection", "Citizen notice. Priority identification check in progress. Please assemble in your designated inspection positions.", "npc/overwatch/cityvoice/f_trainstation_assemble_spkr.wav");
MODULE:AddDispatchVoice("Inspection 2", "Attention please. All citizens in local residential block, assume your inspection positions.", "npc/overwatch/cityvoice/f_trainstation_assumepositions_spkr.wav");
MODULE:AddDispatchVoice("Miscount Detected", "Attention resident. Miscount detected in your block. Co-operation with your Civil Protection team permit full ration reward.", "npc/overwatch/cityvoice/f_trainstation_cooperation_spkr.wav");
MODULE:AddDispatchVoice("Infection", "Attention resident. This block contains potential civil infection. INFORM, CO-OPERATE, ASSEMBLE.", "npc/overwatch/cityvoice/f_trainstation_inform_spkr.wav");
MODULE:AddDispatchVoice("Relocation", "Citizen notice. Failure to co-operate will result in permanent off-world relocation.", "npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav");
MODULE:AddDispatchVoice("Unrest Code", "Attention community. Unrest procedure code is now in effect. INOCULATE, SHIELD, PACIFY. Code: PRESSURE, SWORD, STERILIZE.", "npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav");
MODULE:AddDispatchVoice("Evasion", "Attention please. Evasion behaviour consistent with mal-compliant defendant. Ground protection team, alert. Code: ISOLATE, EXPOSE, ADMINISTER.", "npc/overwatch/cityvoice/f_evasionbehavior_2_spkr.wav");
MODULE:AddDispatchVoice("Individual", "Individual. You are charged with social endangerment, level one. Protection unit, prosecution code: DUTY, SWORD, MIDNIGHT.", "npc/overwatch/cityvoice/f_sociolevel1_4_spkr.wav");
MODULE:AddDispatchVoice("Autonomous", "Attention all ground protection teams. Autonomous judgement is now in effect, sentencing is now discretionary. Code: AMPUTATE, ZERO, CONFIRM.", "npc/overwatch/cityvoice/f_protectionresponse_4_spkr.wav");
MODULE:AddDispatchVoice("Citizenship", "Individual. You are convicted of multi anti-civil violations. Implicit citizenship revoked. Status: MALIGNANT.", "npc/overwatch/cityvoice/f_citizenshiprevoked_6_spkr.wav");
MODULE:AddDispatchVoice("Malcompliance", "Individual. You are charged with capital malcompliance, anti-citizen status approved.", "npc/overwatch/cityvoice/f_capitalmalcompliance_spkr.wav");
MODULE:AddDispatchVoice("Exogen", "Overwatch acknowledges critical exogen breach, AirWatch augmentation force dispatched and inbound. Hold for reinforcements.", "npc/overwatch/cityvoice/fprison_airwatchdispatched.wav");
MODULE:AddDispatchVoice("Failure", "Attention ground units. Mission failure will result in permanent off-world assignment. Code reminder: SACRIFICE, COAGULATE, PLAN.", "npc/overwatch/cityvoice/fprison_missionfailurereminder.wav");

MODULE:AddVoice("Combine", "Sweeping", "Sweeping for suspect.", "npc/metropolice/hiding02.wav");
MODULE:AddVoice("Combine", "Isolate", "Isolate!", "npc/metropolice/hiding05.wav");
MODULE:AddVoice("Combine", "You Can Go", "Alright, you can go.", "npc/metropolice/vo/allrightyoucango.wav");
MODULE:AddVoice("Combine", "Need Assistance", "Eleven-ninety-nine, officer needs assistance!", "npc/metropolice/vo/11-99officerneedsassistance.wav");
MODULE:AddVoice("Combine", "Administer", "Administer.", "npc/metropolice/vo/administer.wav");
MODULE:AddVoice("Combine", "Affirmative", "Affirmative.", "npc/metropolice/vo/affirmative.wav");
MODULE:AddVoice("Combine", "All Units Move In", "All units move in!", "npc/metropolice/vo/allunitsmovein.wav");
MODULE:AddVoice("Combine", "Amputate", "Amputate.", "npc/metropolice/vo/amputate.wav");
MODULE:AddVoice("Combine", "Anti-Citizen", "Anti-citizen.", "npc/metropolice/vo/anticitizen.wav");
MODULE:AddVoice("Combine", "Citizen", "Citizen.", "npc/metropolice/vo/citizen.wav");
MODULE:AddVoice("Combine", "Copy", "Copy.", "npc/metropolice/vo/copy.wav");
MODULE:AddVoice("Combine", "Cover Me", "Cover me, I'm going in!", "npc/metropolice/vo/covermegoingin.wav");
MODULE:AddVoice("Combine", "Assist Trespass", "Assist for a criminal trespass!", "npc/metropolice/vo/criminaltrespass63.wav");
MODULE:AddVoice("Combine", "Destroy Cover", "Destroy that cover!", "npc/metropolice/vo/destroythatcover.wav");
MODULE:AddVoice("Combine", "Don't Move", "Don't move!", "npc/metropolice/vo/dontmove.wav");
MODULE:AddVoice("Combine", "Final Verdict", "Final verdict administered.", "npc/metropolice/vo/finalverdictadministered.wav");
MODULE:AddVoice("Combine", "Final Warning", "Final warning!", "npc/metropolice/vo/finalwarning.wav");
MODULE:AddVoice("Combine", "First Warning", "First warning, move away!", "npc/metropolice/vo/firstwarningmove.wav");
MODULE:AddVoice("Combine", "Get Down", "Get down!", "npc/metropolice/vo/getdown.wav");
MODULE:AddVoice("Combine", "Get Out", "Get out of here!", "npc/metropolice/vo/getoutofhere.wav");
MODULE:AddVoice("Combine", "Suspect One", "I got suspect one here.", "npc/metropolice/vo/gotsuspect1here.wav");
MODULE:AddVoice("Combine", "Help", "Help!", "npc/metropolice/vo/help.wav");
MODULE:AddVoice("Combine", "Running", "He's running!", "npc/metropolice/vo/hesrunning.wav");
MODULE:AddVoice("Combine", "Hold It", "Hold it right there!", "npc/metropolice/vo/holditrightthere.wav");
MODULE:AddVoice("Combine", "Move Along Repeat", "I said move along.", "npc/metropolice/vo/isaidmovealong.wav");
MODULE:AddVoice("Combine", "Malcompliance", "Issuing malcompliance citation.", "npc/metropolice/vo/issuingmalcompliantcitation.wav");
MODULE:AddVoice("Combine", "Keep Moving", "Keep moving!", "npc/metropolice/vo/keepmoving.wav");
MODULE:AddVoice("Combine", "Lock Position", "All units, lock your position!", "npc/metropolice/vo/lockyourposition.wav");
MODULE:AddVoice("Combine", "Trouble", "Lookin' for trouble?", "npc/metropolice/vo/lookingfortrouble.wav");
MODULE:AddVoice("Combine", "Look Out", "Look out!", "npc/metropolice/vo/lookout.wav");
MODULE:AddVoice("Combine", "Minor Hits", "Minor hits, continuing prosecution.", "npc/metropolice/vo/minorhitscontinuing.wav");
MODULE:AddVoice("Combine", "Move", "Move!", "npc/metropolice/vo/move.wav");
MODULE:AddVoice("Combine", "Move Along", "Move along!", "npc/metropolice/vo/movealong3.wav");
MODULE:AddVoice("Combine", "Move Back", "Move back, right now!", "npc/metropolice/vo/movebackrightnow.wav");
MODULE:AddVoice("Combine", "Move It", "Move it!", "npc/metropolice/vo/moveit2.wav");
MODULE:AddVoice("Combine", "Hardpoint", "Moving to hardpoint.", "npc/metropolice/vo/movingtohardpoint.wav");
MODULE:AddVoice("Combine", "Officer Help", "Officer needs help!", "npc/metropolice/vo/officerneedshelp.wav");
MODULE:AddVoice("Combine", "Privacy", "Possible level three civil privacy violator here!", "npc/metropolice/vo/possiblelevel3civilprivacyviolator.wav");
MODULE:AddVoice("Combine", "Judgement", "Suspect prepare to receive civil judgement!", "npc/metropolice/vo/prepareforjudgement.wav");
MODULE:AddVoice("Combine", "Priority Two", "I have a priority two anti-citizen here!", "npc/metropolice/vo/priority2anticitizenhere.wav");
MODULE:AddVoice("Combine", "Prosecute", "Prosecute!", "npc/metropolice/vo/prosecute.wav");
MODULE:AddVoice("Combine", "Amputate Ready", "Ready to amputate!", "npc/metropolice/vo/readytoamputate.wav");
MODULE:AddVoice("Combine", "Rodger That", "Rodger that!", "npc/metropolice/vo/rodgerthat.wav");
MODULE:AddVoice("Combine", "Search", "Search!", "npc/metropolice/vo/search.wav");
MODULE:AddVoice("Combine", "Shit", "Shit!", "npc/metropolice/vo/shit.wav");
MODULE:AddVoice("Combine", "Sentence Delivered", "Sentence delivered.", "npc/metropolice/vo/sentencedelivered.wav");
MODULE:AddVoice("Combine", "Sterilize", "Sterilize!", "npc/metropolice/vo/sterilize.wav");
MODULE:AddVoice("Combine", "Take Cover", "Take cover!", "npc/metropolice/vo/takecover.wav");
MODULE:AddVoice("Combine", "Restrict", "Restrict!", "npc/metropolice/vo/restrict.wav");
MODULE:AddVoice("Combine", "Restricted", "Restricted block.", "npc/metropolice/vo/restrictedblock.wav");
MODULE:AddVoice("Combine", "Second Warning", "This is your second warning!", "npc/metropolice/vo/thisisyoursecondwarning.wav");
MODULE:AddVoice("Combine", "Verdict", "You want a non-compliance verdict?", "npc/metropolice/vo/youwantamalcomplianceverdict.wav");
MODULE:AddVoice("Combine", "Backup", "Backup!", "npc/metropolice/vo/backup.wav");
MODULE:AddVoice("Combine", "Apply", "Apply.", "npc/metropolice/vo/apply.wav");
MODULE:AddVoice("Combine", "Restriction", "Terminal restriction zone.", "npc/metropolice/vo/terminalrestrictionzone.wav");
MODULE:AddVoice("Combine", "Complete", "Protection complete.", "npc/metropolice/vo/protectioncomplete.wav");
MODULE:AddVoice("Combine", "Location Unknown", "Suspect location unknown.", "npc/metropolice/vo/suspectlocationunknown.wav");
MODULE:AddVoice("Combine", "Can 1", "Pick up that can.", "npc/metropolice/vo/pickupthecan1.wav");
MODULE:AddVoice("Combine", "Can 2", "Pick... up... the can.", "npc/metropolice/vo/pickupthecan2.wav");
MODULE:AddVoice("Combine", "Wrap It", "That's it, wrap it up.", "npc/combine_soldier/vo/thatsitwrapitup.wav");
MODULE:AddVoice("Combine", "Can 3", "I said pickup the can!", "npc/metropolice/vo/pickupthecan3.wav");
MODULE:AddVoice("Combine", "Can 4", "Now, put it in the trash can.", "npc/metropolice/vo/putitinthetrash1.wav");
MODULE:AddVoice("Combine", "Can 5", "I said put it in the trash can!", "npc/metropolice/vo/putitinthetrash2.wav");
MODULE:AddVoice("Combine", "Now Get Out", "Now get out of here!", "npc/metropolice/vo/nowgetoutofhere.wav");
MODULE:AddVoice("Combine", "Haha", "Haha.", "npc/metropolice/vo/chuckle.wav");
MODULE:AddVoice("Combine", "X-Ray", "X-Ray!", "npc/metropolice/vo/xray.wav");
MODULE:AddVoice("Combine", "Patrol", "Patrol!", "npc/metropolice/vo/patrol.wav");
MODULE:AddVoice("Combine", "Serve", "Serve.", "npc/metropolice/vo/serve.wav");
MODULE:AddVoice("Combine", "Knocked Over", "You knocked it over, pick it up!", "npc/metropolice/vo/youknockeditover.wav");
MODULE:AddVoice("Combine", "Watch It", "Watch it!", "npc/metropolice/vo/watchit.wav");
MODULE:AddVoice("Combine", "Restricted Canals", "Suspect is using restricted canals at...", "npc/metropolice/vo/suspectusingrestrictedcanals.wav");
MODULE:AddVoice("Combine", "505", "Subject is five-oh-five!", "npc/metropolice/vo/subjectis505.wav");
MODULE:AddVoice("Combine", "404", "Possible four-zero-oh here!", "npc/metropolice/vo/possible404here.wav");
MODULE:AddVoice("Combine", "Vacate", "Vacate citizen!", "npc/metropolice/vo/vacatecitizen.wav");
MODULE:AddVoice("Combine", "Escapee", "Priority two escapee.", "npc/combine_soldier/vo/prioritytwoescapee.wav");
MODULE:AddVoice("Combine", "Objective", "Priority one objective.", "npc/combine_soldier/vo/priority1objective.wav");
MODULE:AddVoice("Combine", "Payback", "Payback.", "npc/combine_soldier/vo/payback.wav");
MODULE:AddVoice("Combine", "Got Him Now", "Affirmative, we got him now.", "npc/combine_soldier/vo/affirmativewegothimnow.wav");
MODULE:AddVoice("Combine", "Antiseptic", "Antiseptic.", "npc/combine_soldier/vo/antiseptic.wav");
MODULE:AddVoice("Combine", "Cleaned", "Cleaned.", "npc/combine_soldier/vo/cleaned.wav");
MODULE:AddVoice("Combine", "Engaged Cleanup", "Engaged in cleanup.", "npc/combine_soldier/vo/engagedincleanup.wav");
MODULE:AddVoice("Combine", "Engaging", "Engaging.", "npc/combine_soldier/vo/engaging.wav");
MODULE:AddVoice("Combine", "Full Response", "Executing full response.", "npc/combine_soldier/vo/executingfullresponse.wav");
MODULE:AddVoice("Combine", "Heavy Resistance", "Overwatch advise, we have heavy resistance.", "npc/combine_soldier/vo/heavyresistance.wav");
MODULE:AddVoice("Combine", "Inbound", "Inbound.", "npc/combine_soldier/vo/inbound.wav");
MODULE:AddVoice("Combine", "Lost Contact", "Lost contact!", "npc/combine_soldier/vo/lostcontact.wav");
MODULE:AddVoice("Combine", "Move In", "Move in!", "npc/combine_soldier/vo/movein.wav");
MODULE:AddVoice("Combine", "Harden Position", "Harden that position!", "npc/combine_soldier/vo/hardenthatposition.wav");
MODULE:AddVoice("Combine", "Go Sharp", "Go sharp, go sharp!", "npc/combine_soldier/vo/gosharpgosharp.wav");
MODULE:AddVoice("Combine", "Delivered", "Delivered.", "npc/combine_soldier/vo/delivered.wav");
MODULE:AddVoice("Combine", "Necrotics Inbound", "Necrotics, inbound!", "npc/combine_soldier/vo/necroticsinbound.wav");
MODULE:AddVoice("Combine", "Necrotics", "Necrotics.", "npc/combine_soldier/vo/necrotics.wav");
MODULE:AddVoice("Combine", "Outbreak", "Outbreak!", "npc/combine_soldier/vo/outbreak.wav");
MODULE:AddVoice("Combine", "Copy That", "Copy that.", "npc/combine_soldier/vo/copythat.wav");
MODULE:AddVoice("Combine", "Outbreak Status", "Outbreak status is code.", "npc/combine_soldier/vo/outbreakstatusiscode.wav");
MODULE:AddVoice("Combine", "Overwatch", "Overwatch!", "npc/combine_soldier/vo/overwatch.wav");
MODULE:AddVoice("Combine", "Preserve", "Preserve!", "npc/metropolice/vo/preserve.wav");
MODULE:AddVoice("Combine", "Pressure", "Pressure!", "npc/metropolice/vo/pressure.wav");
MODULE:AddVoice("Combine", "Phantom", "Phantom!", "npc/combine_soldier/vo/phantom.wav");
MODULE:AddVoice("Combine", "Stinger", "Stinger!", "npc/combine_soldier/vo/stinger.wav");
MODULE:AddVoice("Combine", "Shadow", "Shadow!", "npc/combine_soldier/vo/shadow.wav");
MODULE:AddVoice("Combine", "Savage", "Savage!", "npc/combine_soldier/vo/savage.wav");
MODULE:AddVoice("Combine", "Reaper", "Reaper!", "npc/combine_soldier/vo/reaper.wav");
MODULE:AddVoice("Combine", "Victor", "Victor!", "npc/metropolice/vo/victor.wav");
MODULE:AddVoice("Combine", "Sector", "Sector!", "npc/metropolice/vo/sector.wav");
MODULE:AddVoice("Combine", "Inject", "Inject!", "npc/metropolice/vo/inject.wav");
MODULE:AddVoice("Combine", "Dagger", "Dagger!", "npc/combine_soldier/vo/dagger.wav");
MODULE:AddVoice("Combine", "Blade", "Blade!", "npc/combine_soldier/vo/blade.wav");
MODULE:AddVoice("Combine", "Razor", "Razor!", "npc/combine_soldier/vo/razor.wav");
MODULE:AddVoice("Combine", "Nomad", "Nomad!", "npc/combine_soldier/vo/nomad.wav");
MODULE:AddVoice("Combine", "Judge", "Judge!", "npc/combine_soldier/vo/judge.wav");
MODULE:AddVoice("Combine", "Ghost", "Ghost!", "npc/combine_soldier/vo/ghost.wav");
MODULE:AddVoice("Combine", "Sword", "Sword!", "npc/combine_soldier/vo/sword.wav");
MODULE:AddVoice("Combine", "Union", "Union!", "npc/metropolice/vo/union.wav");
MODULE:AddVoice("Combine", "Helix", "Helix!", "npc/combine_soldier/vo/helix.wav");
MODULE:AddVoice("Combine", "Storm", "Storm!", "npc/combine_soldier/vo/storm.wav");
MODULE:AddVoice("Combine", "Spear", "Spear!", "npc/combine_soldier/vo/spear.wav");
MODULE:AddVoice("Combine", "Vamp", "Vamp!", "npc/combine_soldier/vo/vamp.wav");
MODULE:AddVoice("Combine", "Nova", "Nova!", "npc/combine_soldier/vo/nova.wav");
MODULE:AddVoice("Combine", "Mace", "Mace!", "npc/combine_soldier/vo/mace.wav");
MODULE:AddVoice("Combine", "Grid", "Grid!", "npc/combine_soldier/vo/grid.wav");
MODULE:AddVoice("Combine", "Kilo", "Kilo!", "npc/combine_soldier/vo/kilo.wav");
MODULE:AddVoice("Combine", "Echo", "Echo!", "npc/combine_soldier/vo/echo.wav");
MODULE:AddVoice("Combine", "Dash", "Dash!", "npc/combine_soldier/vo/dash.wav");
MODULE:AddVoice("Combine", "Apex", "Apex!", "npc/combine_soldier/vo/apex.wav");
MODULE:AddVoice("Combine", "Jury", "Jury!", "npc/metropolice/vo/jury.wav");
MODULE:AddVoice("Combine", "King", "King!", "npc/metropolice/vo/king.wav");
MODULE:AddVoice("Combine", "Lock", "Lock!", "npc/metropolice/vo/lock.wav");
MODULE:AddVoice("Combine", "Vice", "Vice!", "npc/metropolice/vo/vice.wav");
MODULE:AddVoice("Combine", "Zero", "Zero!", "npc/metropolice/vo/zero.wav");
MODULE:AddVoice("Combine", "Zone", "Zone!", "npc/metropolice/vo/zone.wav");