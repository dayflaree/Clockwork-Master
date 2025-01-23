//taken from my Berserker Pack, which was taken from GMDM

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/

	
function EFFECT:Init(data)
	
	self.LifeTime = 5

	local emitter = ParticleEmitter( data:GetOrigin() )
	
		local particle = emitter:Add( "effects/blood_core", data:GetOrigin() )
			particle:SetVelocity( data:GetNormal() * math.Rand( 5, 20 ) )
			particle:SetDieTime( math.Rand( 1.0, 2.0 ) )
			particle:SetStartAlpha( 255 )
			particle:SetStartSize( math.Rand( 16, 32 ) )
			particle:SetEndSize( math.Rand( 8, 16 ) )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetColor( 40, 0, 0 )
				
	emitter:Finish()

end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )
	
	self.LifeTime = self.LifeTime - .01
	return (self.LifeTime > 0)
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render() end



