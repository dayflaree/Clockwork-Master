RP.vote = {};
RP.vote.current = nil;

if (SERVER) then

	function RP.vote:StartVote(voteQuestion, Callback, callbackArg) 
		if (RP.vote.current) then
			Callback(false, "A vote is already in progress!", callbackArg);
		else
			RP.vote.current = {
				endTime = CurTime() + 15,
				question = voteQuestion,
				Callback = Callback,
				callbackArg = callbackArg or nil,
				upVotes = 0,
				voters = {}
			}
			self:NetworkVote()
			self:Announce({"A new vote has been started!"});
		end;
		//Will eventually add a think hook to check this shit.. but for now just timer it :/
		timer.Simple(15, self.EndVote, self);
	end;
	
	function RP.vote:EndVote()
		if (self.current.upVotes >= #self.current.voters/2) then
			self.current.Callback(true, "The vote was successful.", self.current.callbackArg);
		else
			self.current.Callback(false, "The vote was not successful!", self.current.callbackArg);
		end;
		self.current = nil;
	end;
	
	function RP.vote:NetworkVote()
		RP:DataStream(_player.GetAll(), "NetworkVote", self.current);
	end;

	function RP.vote:Announce(data)
		RP.chat:Add(_player.GetAll(), table.Add({Color(255, 255, 150)}, data), "gui/silkicons/add", "weapons/fx/nearmiss/bulletLtoR13.wav");
	end;
else

	RP.vote.popup = false;
	
	RP:DataHook("NetworkVote", function(data)
		if (RP.vote.popup) then
			RP.vote.popup:Remove();
			RP.vote.popup = nil;
		end;
		
		RP.vote.popup = vgui.Create("rpVote");
		RP.vote.popup:SetInfo(data);
	end);

end;