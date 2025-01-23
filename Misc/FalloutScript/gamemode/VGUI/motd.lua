--Thanks Ulysses

local HTML = {}

function HTML:StatusChanged( text )
end

function HTML:ProgressChanged( progress )
end

function HTML:FinishedURL( url )
end

function HTML:OpeningURL( url, target )
end

vgui.Register( "Motd", HTML, "HTML" )