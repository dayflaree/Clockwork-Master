function dosend(itemid)

	if(itemid == 1)then
	addItem({1,"ent","prop_phys","models/smile/smile.mdl","Lawd",200})
	
	
	doHtml([[ 
	
	<html>
	<body>
		<body bgcolor= rgb(155,155,155)>

		<p>This NPC sells Stuff....</p> 
		
	</html>
	</body>
	
	]])
	
	
	end
	
end