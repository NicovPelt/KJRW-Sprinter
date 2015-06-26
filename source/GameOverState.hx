package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

/**
 * The game state that is used when the player has lost all of their lives. Shows a short commic.
 * @author Nico van Pelt
 */
class GameOverState extends FlxState
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
	 * Puts the next frame of the comic on screen. If the last frame is reached, switches back to the main menu.
	 */
	private function nextFrame() {
		frameIndex ++;
		if (!(frameIndex > 2)) {
			currentFrame.loadGraphic("assets/images/Bad0" + frameIndex + ".png");
		} else {
			Main.menuState = new MenuState();
			FlxG.switchState(Main.menuState);
		}
	}
	
	override public function update() {
		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE ) 
			nextFrame();
	}
	
}