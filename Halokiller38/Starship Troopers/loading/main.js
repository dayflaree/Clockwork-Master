/*
// Begin Config
*/

/* Logo url duh */
var logo = "Your logo path here e.g themes/custom/logo/logo.png";

/* Content pack url */
var downloadURL = "http://earth-evasion.les-forums.com/forums/";

/* URLs to background images */
backgrounds = [];
backgrounds["earth"] = "bg/earth.jpg";
/* 
// Background music.
// Use the last part of a youtube URL. eg; http://www.youtube.com/watch?v=iy61r3Qkm6o = iy61r3Qkm6o
*/
music = [];
music["earth"] = "PcSrEwKenvY";

var volume = 100; /* Anything from 0 - 100. */

/*
// End of Config.
*/

var bCanChangeStatus = true;
var iFilesNeeded = 0;
var iFilesTotal = 0;
var bDownloadingFile = false;

function onYouTubePlayerReady( playerId ) {
	ytplayer = document.getElementById("youtube");
	ytplayer.setVolume(volume);
	ytplayer.playVideo();
}
swfobject.embedSWF("http://www.youtube.com/e/" + music[Server] + "?enablejsapi=1&playerapiid=ytplayer", "youtube", "1", "1", "8", null, null, { allowScriptAccess: "always" }, "youtube");

$(document).ready(function() {
	$('#logo').html("<img src='" + logo + "' alt=''/>");
	$('#background').html("<img src='" + backgrounds[Server] + "' style='position:absolute;top:0;z-index:-4999;width:100%;height:100%;' alt=''/>");
});

/* Unused background changer.
function Backgrounder() {
	var NumberOfImagages = 2;
	$('#background').fadeToggle('slow', function () {
		$(this).html("<img src='bg/bg_" + Math.floor(Math.random() * 3) + ".jpg' style='position:absolute;top:0;z-index:-4999;width:100%;height:100%;' alt=''/>");
		$(this).fadeToggle('slow');
	});
	setTimeout("Backgrounder()", 10000);
}
Backgrounder();
*/

function SetFilesNeeded(iNeeded) {
	iFilesNeeded = iNeeded;
	RefreshFileBox();
}
function SetFilesTotal(iTotal) {
	iFilesTotal = iTotal;
	RefreshFileBox();
}
function DownloadingFile(filename) {
	if (bDownloadingFile) {
		iFilesNeeded = iFilesNeeded - 1;
		$('#loadingtext').fadeToggle('slow', function () {
			$(this).fadeToggle('slow');
			$(this).html("Now Downloading: " + filename);
		});
		RefreshFileBox();
	}
	bCanChangeStatus = false;
	setTimeout("bCanChangeStatus = true;", 1000);
	bDownloadingFile = true;
}
function SetStatusChanged(status) {
	if (bDownloadingFile) {
		iFilesNeeded = iFilesNeeded - 1;
		bDownloadingFile = false;
		RefreshFileBox();
	}
	$('#loadingtext').html(status);
	bCanChangeStatus = false;
	setTimeout("bCanChangeStatus = true;", 1000);
}
function RefreshFileBox() {
	$('#files').html("<img src=\"loading.gif\" alt=\"\" style=\"margin-bottom:4px;\"/> " + iFilesNeeded + " Downloads Remaining.");
	if (iFilesTotal > 0) {
		$('#files').fadeIn('slow');
	} else {
		$('#files').html("Downloads Complete!");
	}
}
RefreshFileBox();

function DisplayPacks() {
	var DisplayingPacks = false;
	if (DisplayingPacks) {
		return false;
	} else {
		$('#contentpack').html("Community : " + downloadURL);
		$('#contentpack').fadeIn('fast');
	}
}
var PackTimer = 4 * 60 * 60; // 2 minutes
setTimeout("DisplayPacks()", PackTimer);



// hi im the end of the file