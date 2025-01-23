local capture = false
local scale = 15

local template = [[<html>
	<head>
		<title>HTML image test</title>
		<style type="text/css">
			table { border: 1px solid #000; border-spacing: 0; }
			td { width: 1px; height: 1px }
		</style>
	</head>
	<body>
		<table>
			[PIXELS]
		</table>
	</body>
</html>]]

hook.Add( "HUDPaint", "HTMLCaptureHook", function()
	if ( capture ) then
		local t = os.clock()
		capture = false
		
		render.CapturePixels()
		
		local pixelData = {}
		
		for x = 0, ScrW() - 1, scale do
			pixelData = {}
			for y = 0, ScrH() - 1, scale do
				local r, g, b = render.ReadPixel( x, y )
				pixelData[x] = { r, g, b }
			end
		end
		print( os.clock() - t )
	end
end )

concommand.Add( "html", function()
	capture = true
end )