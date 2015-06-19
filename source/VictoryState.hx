package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

/**
 * ...
 * @author Nico van Pelt
 */
class VictoryState extends FlxState
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
		if (!(frameIndex > 2)) {
			currentFrame.loadGraphic("assets/images/Good0" + frameIndex + ".png");
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