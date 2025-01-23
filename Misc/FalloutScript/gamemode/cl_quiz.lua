function RPQuizVGUI()

	QuizFrame = vgui.Create( "DFrame" )
	QuizFrame:SetTitle( "Fallout Role-Play Quiz" ) 
	QuizFrame:SetSize( ScrW(), ScrH() )
	QuizFrame:Center()
	QuizFrame:SetVisable( true )
	QuizFrame:SetDraggable( false )
	QuizFrame:ShowCloseButton( false )
	QuizFrame:MakePopup()
	
		QuizLabel = vgui.Create( "DLabel" )
		QuizLabel:SetParent( QuizFrame )
		QuizLabel:SetPos( QuizFrame:GetWide() - 50, QuizFrame:GetTall() - 20 )
		QuizLabel:SetText( "Fallout Role-Play Quiz n/ If you fail this quiz, or fail to answer all the question n/ you'll be kicked and banned for 10 minutes." )
		
		QuizQuestion1 = vgui.Create( "DLabel" )
		QuizQuestion1:SetParent( QuizFrame )
		QuizQuestion1:SetPos( QuizFrame:GetWide() - 50, QuizFrame:GetTall() - 40 )
		QuizQuestion1:SetText( "Question 1 - What is Deathmatching?" )
		
		--QuizAnswer1Q1 = vgui.Create( "DCheckBox" )
		
	

end
concommand.Add( "rp_quiz", RPQuizVGUI )	