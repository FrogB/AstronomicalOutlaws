package;

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
import Shaders;
import Shaders.GlitchEffect;

class FreeplayCatState extends MusicBeatState
{
	public static var categorySelected:String;

	var bg:FlxSprite;
	var week1:FlxSprite;
	var o:FlxSprite;
	var lol:Bool = false;
	var sex:FlxSprite;
	var canExit:Bool = true;
	var week1text:FlxText;
	var week2text:FlxText;
	var week3text:FlxText;
	var week2:FlxSprite;
	var week3:FlxSprite;
	var arrowshit:FlxSprite;
	var menuItems:FlxTypedGroup<FlxSprite>;
	var text:FlxText;

	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();
	
	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Menu", null);
		#end

		#if android
		addVirtualPad(FULL, A_B_X_Y);
		addPadCamera();
		#end
		
		super.create();

		FlxG.mouse.visible = true;
		
		bg = new FlxSprite(-80).loadGraphic(Paths.image('storymenu/placeholder')); //it looked cool shut up
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		bg.color = 0xFFFDE871;
		add(bg);
		
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		//MIDPOINT = (500, 480, 320)
		
		week1 = new FlxSprite(100, 70).loadGraphic(Paths.image('weeks/blank'));
		week1.scale.set(0.8, 0.8);
		week1.updateHitbox();
		week1.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(week1);
		
		week1text = new FlxText(80, 480, 320, "Main\n" + "Songs\n");
		week1text.setFormat(Paths.font("comic-sans.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		week1text.scrollFactor.set();
		week1text.borderSize = 3.25;
		week1text.visible = true;
		menuItems.add(week1text);
		
		week2 = new FlxSprite(500, 70).loadGraphic(Paths.image('weeks/blank'));
		week2.scale.set(0.8, 0.8);
		week2.updateHitbox();
		week2.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(week2);
		
		week2text = new FlxText(480, 550, 320, "Extras\n");
		week2text.setFormat(Paths.font("comic-sans.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		week2text.scrollFactor.set();
		week2text.borderSize = 3.25;
		week2text.visible = true;
		menuItems.add(week2text);

		week3 = new FlxSprite(900, 70).loadGraphic(Paths.image('weeks/blank'));
		week3.scale.set(0.8, 0.8);
		week3.updateHitbox();
		week3.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(week3);
		
		week3text = new FlxText(880, 480, 320, "Joke\n" + "Songs\n");
		week3text.setFormat(Paths.font("comic-sans.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		week3text.scrollFactor.set();
		week3text.borderSize = 3.25;
		week3text.visible = true;
		menuItems.add(week3text);
		
		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 46).makeGraphic(FlxG.width, 56, 0xFF000000);
		textBG.alpha = 0.6;
		menuItems.add(textBG);
		#if PRELOAD_ALL
		var leText:String = "Use your mouse to select a category";
		#end
		text = new FlxText(textBG.x + -10, textBG.y + 3, FlxG.width, leText, 21);
		text.setFormat(Paths.font("comic-sans.ttf"), 18, FlxColor.WHITE, CENTER);
		text.scrollFactor.set();
		menuItems.add(text);
		
		/*arrowshit = new FlxSprite(-80).loadGraphic(Paths.image('stupidarrows'));
		arrowshit.setGraphicSize(Std.int(arrowshit.width * 1));
		arrowshit.updateHitbox();
		arrowshit.screenCenter();
		arrowshit.antialiasing = ClientPrefs.globalAntialiasing;
		menuItems.add(arrowshit);*/
		
	}
	override public function update(elapsed:Float)
	{
		
		if (FlxG.mouse.overlaps(week1) && FlxG.mouse.justPressed && !lol)
		{
			FlxG.mouse.visible = false;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			lol = true;
			//transitioning shit
			FlxTween.tween(FlxG.camera, {zoom: 1.35}, 1.45, {ease: FlxEase.expoIn});

			FlxTween.tween(week1, {x: 500}, 0.8, {ease: FlxEase.expoIn});
			FlxTween.tween(week1text, {x: 480}, 0.8, {ease: FlxEase.expoIn});

			//KILL WEEK2 & 3
			FlxTween.tween(week2, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    week2.kill();
		    }
	      });
	    	FlxTween.tween(week2text, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    week2text.kill();
		    }
	      });
		  FlxTween.tween(week3, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    week3.kill();
		    }
	      });
	    	FlxTween.tween(week3text, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    week3text.kill();
		    }
	      });
		  new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				MusicBeatState.switchState(new FreeplayState());
				categorySelected = 'main';
			});

		}

		if (FlxG.mouse.overlaps(week2) && FlxG.mouse.justPressed && !lol)
		{
			FlxG.mouse.visible = false;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			lol = true;
			//transitioning shit
			FlxTween.tween(FlxG.camera, {zoom: 1.35}, 1.45, {ease: FlxEase.expoIn});

			FlxTween.tween(week2, {x: 500}, 0.8, {ease: FlxEase.expoIn});
			FlxTween.tween(week2text, {x: 480}, 0.8, {ease: FlxEase.expoIn});

			//KILL WEEK1 & 3
			FlxTween.tween(week1, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    week1.kill();
		    }
	      });
	    	FlxTween.tween(week1text, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    week1text.kill();
		    }
	      });
		  //KILL WEEK1
			FlxTween.tween(week3, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    week3.kill();
		    }
	      });
	    	FlxTween.tween(week3text, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    week3text.kill();
		    }
	      });

		  	new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				MusicBeatState.switchState(new FreeplayState());
				categorySelected = 'extras';
			});
		}

		if (FlxG.mouse.overlaps(week3) && FlxG.mouse.justPressed && !lol)
		{
			FlxG.mouse.visible = false;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			lol = true;
			//transitioning shit
			FlxTween.tween(FlxG.camera, {zoom: 1.35}, 1.45, {ease: FlxEase.expoIn});

			FlxTween.tween(week3, {x: 500}, 0.8, {ease: FlxEase.expoIn});
			FlxTween.tween(week3text, {x: 480}, 0.8, {ease: FlxEase.expoIn});

			//KILL WEEK1 & 2
			FlxTween.tween(week1, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    week1.kill();
		    }
	      });
	    	FlxTween.tween(week1text, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    week1text.kill();
		    }
	      });
		  //KILL WEEK1
			FlxTween.tween(week2, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    week2.kill();
		    }
	      });
	    	FlxTween.tween(week2text, {alpha: 0}, 0.4, {
	  	    ease: FlxEase.quadOut,
		    onComplete: function(twn:FlxTween)
		    {
		  	    week2text.kill();
		    }
	      });

		  	new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				MusicBeatState.switchState(new FreeplayState());
				categorySelected = 'joke';
			});
		}
		  
		if(controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.mouse.visible = false;
			MusicBeatState.switchState(new MainMenuState());
		}
		
		super.update(elapsed);
	}

	function weekIsLocked(weekNum:Int) {
		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[weekNum]);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}
}
