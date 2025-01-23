local rpdmhints = {
"Want to create a faction? Press F2.",
"Don't RDM, you'll get banned... seriously.",
"Base with friends to create a more enjoyable experience!",
"Report hacking or abuse to an admin."
}

function giveHint()
	PrintMessageAll(rpdmhints[math.random(1,#rpdmhints)])
end

timer.Create( "hints", 120, 0, giveHint )