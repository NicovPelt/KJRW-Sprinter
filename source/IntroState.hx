package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;

/**
 * The game state that shows the comic before the game starts.
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
	
	/**
	 * Puts the next frame of the comic on screen. If the last frame is reached, switches to the game.
	 */
	private function nextFrame() {
		frameIndex ++;
		if (!(frameIndex > 7)) {
			currentFrame.loadGraphic("assets/images/introComic/0" + frameIndex + ".png");
		} else {
			currentFrame.loadGraphic("assets/images/introComic/Loading.png");
			FlxG.sound.pause();
			//Main.playState = new PlayState();
			FlxG.switchState(Main.playState);
		}
	}
	
	override public function update() {
		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE ) 
			nextFrame();
	}
	
}