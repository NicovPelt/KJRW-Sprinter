package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;

/**
 * ...
 * @author Nico van Pelt
 */
class PauseState extends FlxState
{
	
	private var pauseScreen:FlxSprite;
	private var pReleased:Bool = false;

	override public function create():Void
	{
		pauseScreen = new FlxSprite(0, 0, AssetPaths.Pauze_scherm__png);
		add(pauseScreen);
	}
	
	override public function update():Void
	{
		if (FlxG.keys.pressed.P && pReleased) {
			FlxG.switchState(Main.playState);
		}
		if (FlxG.keys.justReleased.P) {
			pReleased = true;
		}
	}
}