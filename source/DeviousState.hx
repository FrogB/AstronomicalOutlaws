package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.*;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

/**
 * ...
 * sorry bbpanzu
 */
class DeviousState extends MusicBeatState
{

	public function new() 
	{
		super();
	}
	override function create() 
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("DEVIOUS.", null);
		#end

		super.create();
		
		var bg:FlxSprite = new FlxSprite();
		
		bg.loadGraphic(Paths.image("secrets/aodevious", "preload"));
		add(bg);
		
		#if mobileC
		addVirtualPad(NONE, A_B);
		#end

		Conductor.changeBPM(1);
		FlxG.sound.playMusic(Paths.music('void'), 0.25, true);
		trace('WE DO NOT CONDONE ANY DEVIOUS ACTS COMMITED IN ASTRONOMICAL OUTLAWS.');

		FlxG.mouse.visible = true; //to make it feel not so empty lol
	}
	
	
	override function update(elapsed:Float) 
	{
		super.update(elapsed);
	}
}
