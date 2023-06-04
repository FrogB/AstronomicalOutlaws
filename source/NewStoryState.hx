package; //credit to barrierfalki used his code as refference

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import flixel.group.FlxSpriteGroup;
import openfl.Lib;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import MainMenuState;
import WeekData;

class NewStoryState extends MusicBeatState
{
	//i honestly dont give a fuck if it gives me a null in terms of images theres will be NO BURGAMBI STUFF IN HERE UNTIL V1. -frogb
	var background1:FlxSprite;
	var background2:FlxSprite;
	var arrowUp:FlxSprite;
	var arrowDown:FlxSprite;
	var weekText1:FlxSprite;
	var weekText2:FlxSprite;
	var weekText3:FlxSprite;
	var weekText4:FlxSprite;
	var background3:FlxSprite;
	var background4:FlxSprite;
	public var pcman:FlxSprite;
	var whichWeek = 1;
	public var burgambi:FlxSprite;
	var text:FlxText;
	public var camHUD:FlxCamera;
	// public var duo:FlxSprite; <-- replaced by finale week
	public var pizzambi:FlxSprite;
	public var finale:FlxSprite; // <-- i shat my pants
	var menuItems:FlxTypedGroup<FlxSprite>;

	var txtTracklist:FlxText;
	var txtTrack:FlxText;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In Story Menu", null);
		#end

		super.create();

		FlxG.mouse.visible = false;

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD);

		background1 = new FlxSprite(-80).loadGraphic(Paths.image('storymenu/pcman'));
		background1.alpha = 0.75;
		background1.scrollFactor.set();
		background1.updateHitbox();
		background1.screenCenter();
		background1.antialiasing = ClientPrefs.globalAntialiasing;
		add(background1);

		background2 = new FlxSprite(-80).loadGraphic(Paths.image('storymenu/placeholder'));
		background2.alpha = 0.75;
		background2.scrollFactor.set();
		background2.updateHitbox();
		background2.screenCenter();
		background2.antialiasing = ClientPrefs.globalAntialiasing;
		add(background2);

		background3 = new FlxSprite(-80).loadGraphic(Paths.image('storymenu/placeholder'));
		background3.alpha = 0.75;
		background3.scrollFactor.set();
		background3.updateHitbox();
		background3.screenCenter();
		background3.antialiasing = ClientPrefs.globalAntialiasing;
		add(background3);

		background4 = new FlxSprite(-80).loadGraphic(Paths.image('storymenu/placeholder'));
		background4.alpha = 0.75;
		background4.scrollFactor.set();
		background4.updateHitbox();
		background4.screenCenter();
		background4.antialiasing = ClientPrefs.globalAntialiasing;
		add(background4);

		var shadowBG:FlxSprite = new FlxSprite(690, FlxG.height - 750).makeGraphic(FlxG.width, 1000, 0xFF000000);
		shadowBG.alpha = 0.7;
		add(shadowBG);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		pcman = new FlxSprite(835, 200).loadGraphic(Paths.image('weekcovers/pcman'));
		pcman.updateHitbox();
		pcman.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(pcman);

		burgambi = new FlxSprite(835, 200).loadGraphic(Paths.image('weekcovers/burgambi'));
		burgambi.updateHitbox();
		burgambi.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(burgambi);

		pizzambi = new FlxSprite(835, 200).loadGraphic(Paths.image('weekcovers/finale'));
		pizzambi.updateHitbox();
		pizzambi.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(pizzambi);

		finale = new FlxSprite(835, 200).loadGraphic(Paths.image('weekcovers/finale'));
		finale.updateHitbox();
		finale.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(finale);

		//weektexts 2 3 and 4 are so damn small i had to reset their scale damn it.
		weekText1 = new FlxSprite(-850, -200).loadGraphic(Paths.image('storymenu/weektitle1'));
		weekText1.updateHitbox();
		weekText1.antialiasing = ClientPrefs.globalAntialiasing;
		weekText1.scale.set(0.65, 0.65);
		weekText1.visible = true;
		menuItems.add(weekText1);

		weekText2 = new FlxSprite(-150, -200).loadGraphic(Paths.image('storymenu/weektitle2'));
		weekText2.updateHitbox();
		weekText2.antialiasing = ClientPrefs.globalAntialiasing;
		weekText2.scale.set(5, 5);
		weekText2.visible = false;
		menuItems.add(weekText2);

		weekText3 = new FlxSprite(-150, -200).loadGraphic(Paths.image('storymenu/weektitle3'));
		weekText3.updateHitbox();
		weekText3.antialiasing = ClientPrefs.globalAntialiasing;
		weekText3.scale.set(5, 5);
		weekText3.visible = false;
		menuItems.add(weekText3);

		weekText4 = new FlxSprite(-150, -200).loadGraphic(Paths.image('storymenu/weektitle4'));
		weekText4.updateHitbox();
		weekText4.antialiasing = ClientPrefs.globalAntialiasing;
		weekText4.scale.set(5, 5);
		weekText4.visible = false;
		menuItems.add(weekText4);

		//intro
		FlxTween.tween(weekText1, { x: -150, y: -200 }, 0.2);

		//replaced by finale week
		/*duo = new FlxSprite(835, 200).loadGraphic(Paths.image('weekcovers/finale'));
		duo.updateHitbox();
		duo.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(duo);*/

		var txtBackground:FlxSprite = new FlxSprite(0, FlxG.height - 46).makeGraphic(FlxG.width, 56, 0xFF000000);
		txtBackground.alpha = 0.95;
		menuItems.add(txtBackground);
		#if PRELOAD_ALL
		var leText:String = "Use UP and DOWN keys to navigate weeks. Press the ACCEPT key to enter selected week.";
		#end
		text = new FlxText(txtBackground.x + -10, txtBackground.y + 3, FlxG.width, leText, 21);
		text.setFormat(Paths.font("comic-sans.ttf"), 18, FlxColor.WHITE, CENTER);
		text.scrollFactor.set();
		menuItems.add(text);

		arrowUp = new FlxSprite(900, 50).loadGraphic(Paths.image('storymenu/arrowUp'));
		arrowUp.scale.set(0.5, 0.5);
		arrowUp.updateHitbox();
		arrowUp.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(arrowUp);

		arrowDown = new FlxSprite(835, 450).loadGraphic(Paths.image('storymenu/arrowDown'));
		arrowDown.updateHitbox();
		arrowDown.scale.set(0.5, 0.5);
		arrowDown.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(arrowDown);

		txtTrack = new FlxText(FlxG.width * 0.05, 200, 0, "TRACKS:\n\n", 50);
		txtTrack.alignment = CENTER;
		txtTrack.font = "Comic Sans MS Bold";
		txtTrack.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		txtTrack.color = 0xFFFCB697;
		txtTrack.y = 396;
		add(txtTrack);


		txtTracklist = new FlxText(FlxG.width * 0.05, 200, 0, "N/A", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = "Comic Sans MS Bold";
		txtTracklist.setBorderStyle(OUTLINE, 0xFF000000, 5, 1);
		txtTracklist.color = 0xFFFCB697;
		txtTracklist.y = txtTrack.y + 60;
		add(txtTracklist);

		background1.cameras = [camHUD];
		background2.cameras = [camHUD];
		background3.cameras = [camHUD];
		background4.cameras = [camHUD];
	}

	var curWeek:WeekData;
	
	override public function update(elapsed:Float)
	{
		if (whichWeek == 1)
		{
			weekText1.visible = true;
			weekText2.visible = false;
			weekText3.visible = false;
			weekText4.visible = false;
		}
		else if (whichWeek == 2) {
			weekText1.visible = false;
			weekText2.visible = true;
			weekText3.visible = false;
			weekText4.visible = false;
		}
		else if (whichWeek == 3) {
			weekText1.visible = false;
			weekText2.visible = false;
			weekText3.visible = true;
			weekText4.visible = false;
		}
		else if (whichWeek == 4) {
			weekText1.visible = false;
			weekText2.visible = false;
			weekText3.visible = false;
			weekText4.visible = true;
		}

		if(controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.mouse.visible = false;
			MusicBeatState.switchState(new MainMenuState());
		}
		if (controls.UI_UP_P) { 
			FlxG.sound.play(Paths.sound('scrollMenu'));
			FlxTween.angle(arrowUp, 90, 360, 0.5, {ease : FlxEase.quadInOut});
			if (whichWeek == 1)
			{
				whichWeek = 4;
			}
			else if (whichWeek == 4) {
				whichWeek--;
			}
			else 
			{
				whichWeek--;
			}
		}

		if (controls.UI_DOWN_P) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
			FlxTween.angle(arrowDown, 90, -360, 0.5, {ease : FlxEase.quadInOut});
			if (whichWeek == 4)
			{
				whichWeek = 1;
			}
			else if (whichWeek < 4) {
				whichWeek++; // same thing as `whichWeek = whichWeek + 1;
			}
		}
		if (controls.ACCEPT)
		{
			if (whichWeek == 1)
			{
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.sound('storyMenu'));
				FlxTween.angle(pcman, 90, 360, 1.2, {ease : FlxEase.quadInOut});
				camHUD.flash(FlxColor.WHITE, 1.5);
				startSong('wiring/wiring-hard', 'capacitor', 'voltage');
				trace('WEEK 1: Wiring, Capacitor, Voltage');
			}
			/**if (whichWeek == 2)
			{
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.sound('storyMenu'));
				FlxTween.angle(burgambi, 90, 360, 1.2, {ease : FlxEase.quadInOut});
				camHUD.flash(FlxColor.WHITE, 1.5);
				startSong('wiring/wiring-hard', 'capacitor', 'voltage');
				trace('WEEK 2: Beefsteak, Leftover, Takeout');
			}
			if (whichWeek == 3)
			{
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.sound('storyMenu'));
				FlxTween.angle(pizzambi, 90, 360, 1.2, {ease : FlxEase.quadInOut});
				camHUD.flash(FlxColor.WHITE, 1.5);
				startSong('wiring/wiring-hard', 'capacitor', 'voltage');
				trace('WEEK 3: Topping, Dish-Up, Pre-Heat');
			}
			if (whichWeek == 4)
			{
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.sound('storyMenu'));
				FlxTween.angle(finale, 90, 360, 1.2, {ease : FlxEase.quadInOut});
				camHUD.flash(FlxColor.WHITE, 1.5);
				startSong('wiring/wiring-hard', 'capacitor', 'voltage');
				trace('WEEK 4: Robotics, Epicurean, Revolution');
			}
			**/
			else
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}
		}

		if (whichWeek == 1)
		{
			pcman.visible = true;
			background1.visible = true;
			updateText();
		}
		else
		{
			pcman.visible = false;
			background1.visible = false;
		}

		if (whichWeek == 2)
		{
			burgambi.visible = true;
			background2.visible = true;
			updateText();
		}
		else
		{
			burgambi.visible = false;
			background2.visible = false;
		}
		if (whichWeek == 3)
		{
			pizzambi.visible = true;
			background3.visible = true;
			updateText();
		}
		else
		{
			pizzambi.visible = false;
			background3.visible = false;
		}
		if (whichWeek == 4)
		{
			finale.visible = true;
			background4.visible = true;
			updateText();
		}
		else
		{
		    finale.visible = false;
			background4.visible = false;
		}
		super.update(elapsed);
		}
	function startSong(songName1:String, songName2:String, songName3:String)
    {
	   FlxFlicker.flicker(pcman, 1, 0.06, false, false, function(flick:FlxFlicker)
	   {
	    PlayState.storyPlaylist = [songName1, songName2, songName3];
		PlayState.isStoryMode = true;
	    PlayState.storyWeek = 0;
		var curWeekInt = PlayState.storyWeek;
		curWeek = WeekData.weeksLoaded.get(WeekData.weeksList[curWeekInt]);
		trace(curWeekInt);
	    PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0], '');
	    PlayState.campaignScore = 0;
	    PlayState.campaignMisses = 0;
		FreeplayState.destroyFreeplayVocals();
		new FlxTimer().start(1, function(tmr:FlxTimer)
	    {
		    LoadingState.loadAndSwitchState(new PlayState());
	    });
	   });
	}

	function updateText()
	{
		txtTrack.text = "TRACKS:\n\n";
		txtTracklist.text = "N/A";

		if (whichWeek == 1)
		{
			txtTracklist.text = "WIRING\nCAPACITOR\nVOLTAGE";
		}
		else if (whichWeek == 2)
		{
			txtTracklist.text = "LEFTOVER\nBEEFSTEAK\nTAKEOUT";
		}
		else if (whichWeek == 3)
		{
			txtTracklist.text = "TOPPING\nDISH-UP\nPRE-HEAT";
		}
		else if (whichWeek == 4)
		{
			txtTracklist.text = "ROBOTICS\nEPICUREAN\nREVOLUTION";
		}
		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.2;

		txtTrack.screenCenter(X);
		txtTrack.x -= FlxG.width * 0.2;
	}
}
	