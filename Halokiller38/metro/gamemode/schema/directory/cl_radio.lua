--[[
Name: "cl_guidelines.lua".
Product: "Severance".
--]]

openAura.directory:AddCategoryPage( "A Unit's Radio", "Metro 2033", [[
	<p>
When we are On-Duty, the radio should not be used as a way to talk to your friend. It is there so that the Section/Squad Leader(e.g COM rank) can relay information and orders back and forth between COM.Unitmmand and his or her Section/Squad.<br>
But, if you feel like you've seen or heard something that you feel like the Section/Squad Leader should know, your first plan of action should be to...<br>
1. Try to get his or her attention via a hand signal.<br>
2. Pass a message down through the Section/Squad to get the Leader.<br>
3. Or if you’re close enough, whisper to him or her.<br>
<br>
If none of the above are directly available to you, then and only then may you use the radio. But there is a system on how you reach your Leader. This is how it is done.<br>
<br>
RCT.Unit: COM/*Callsign* message, over.<br>

The word over at the end of that means that you have finished what you've got to say for now, and you’re waiting for a response from the COMer. The COMer then has two was of replying.<br>
1. COM: This is COM, go ahead, over.<br>
-OR-<br>
2. COM: This is COM, stand by. Out.<br>
Out means I've said what I've got to say, COM.Unitnvocation over, do not/i do not expect a reply.<br>
If the COMer says no. 2 no matter how important you think the message is, he/she probably already knows or is busy.<br>
If on the other hand, he/she says no. 1 you may reply as such...<br>
<br>
RCT.Unit: Sighted Infecteds, 300 meters and closing, over.<br>

Always remember to keep it short, sharp and to the point. Do NOT clutter up the net with useless information for example<br>
RCT.Unit: Leader I've seen like a 10000 infecteds I think around 300 meters, Fuck me there getting closer!! What do we dooooo!!!?!??!?!?!?!!?!?!!?<img src="images/smilies/biggrin.png" alt="" title="Big Grin" class="inlineimg" border="0">!?!?!?!<br>
<br>
To which the Leader may reply as such.<br>
COM: Roger, hold fire, await orders. Out.<br>
<br>
The same applies for almost everything that you may need to use the radio for, I.e. you need a medic to your location or a CASEVAC, air support and anything else you can think of.<br>
<br>
Remember S.S.P.<br>
Short<br>

Sharp<br>
to the Point<br>
<br>
Here are a list of radio voice procedure and there meanings with an example.<br>
Affirmative — Yes<br>
COM.Unit: "Alpha two niner, is your squad okay."<br>
RCT.Unit: "Affirmative."<br>
<br>
Negative — No<br>
COM.Unit: "Alpha two niner, is your squad okay."<br>

RCT.Unit: "Negative."<br>
<br>
Over — I have finished talking and I am listening for your reply. Always finish your message with over, so that the person you are talking to knows your done talking.<br>
COM.Unit: ".... That is your objective, acknowledge? Over."<br>
<br>
Out — I have finished talking to you and do not expect a reply. Don't forget to end the COM.Unitnvocation with Out.<br>
COM.Unit: "Alpha two niner, relocate, rally point. Out."<br>
<br>
Roger — Information received. Make sure your clear that you got the Information you need.<br>
COM.Unit: ".... That is your objective."<br>

RCT.Unit: "Roger."<br>
<br>
COM.Unitpy — I understand what you just said. Drup.<br>
COM.Unit: ".... Do you understand?"<br>
RCT.Unit: "COM.Unitpy."<br>
<br>
WilCOM.Unit — Will COM.Unitmply. you'll do the task you've been set.<br>
COM.Unit: ".... Two of your team are being reassigned to sentry duty, pick two, send them our way."<br>
RCT.Unit: "WilCOM.Unit."<br>
<br>

Go ahead — Send your radio message. Let them know your ready to accept there message.<br>
RCT.Unit: "Message for COM.Unit."<br>
COM.Unit: "Go ahead."<br>
<br>
Say again — Please repeat your last message. Static in the way? Try to piece bits together, it's better than nothing.<br>
COM.Unit: ".... Thi.... Take them.... Infan..... Pul... Ack.<br>
RCT.Unit: "Say again."<br>
<br>
Break — Signals a pause during a long transmission to open the channel for other transmissions, especially for allowing any potential emergency traffic to get through. STFU and GTFO from the net!!<br>
RCT.Unit: "... Blah blah blah erelervent raido chatter."<br>

B12: "... Blah blah blah erelervent raido chatter."<br>
COM.Unit: "Break."<br>
<br>
Break-Break — Signals to all listeners on the frequency, the message to follow is priority. STFU and GTFO from the net!! Man down!!<br>
RCT.Unit: "... Blah blah blah erelervent raido chatter."<br>
B12: "... Blah blah blah erelervent raido chatter."<br>
COM.Unit: "Break-Break."<br>
COM.Unit: "Fleet, need casevac, ASAP, my location."<br>
<br>
Standby — Pause for the next transmission. This usually entails staying off the radio until the message sender speaks again over the radio. Give yourself some breathing space to get the information you need, and give them peace of mind that you got there orignal message.<br>

RCT.Unit: "Say again, main objective."<br>
COM.Unit: "Standby."<br>
COM.Unit: "Your main objective is..."<br>
<br>
Sunray — A global callsign for a COM.Unitmmanding Officer who is in charge of an operation/mission.<br>
RCT.Unit: "Need to speak with Sunray."<br>
COM.Unit: "Sunray here, go ahead."
						
	</p>
]] );