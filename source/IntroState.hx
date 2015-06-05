package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;

/**
 * ...
 * @author Nico van Pelt
 */
class IntroState extends FlxState
{
	
	private var currentFrame:FlxSprite;
	private var frameIndex:Int = 0;

	public function new() 
	{
		super();
		currentFrame = new FlxSprite();
		add(currentFrame);
		nextFrame();
	}
	
	private function nextFrame() {
		frameIndex ++;
		if (!(frameIndex > 7)) {
			currentFrame.loadGraphic("assets/images/introComic/0" + frameIndex + ".png");
		} else {
			Main.playState = new PlayState();
			FlxG.switchState(Main.playState);
		}
	}
	
	override public function update() {
		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE ) 
			nextFrame();
	}
	
}