package;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxSound;

/**
 * the game state that is used when a player reaches the end of the level.
 * @author Nico van Pelt
 */
class VictoryState extends FlxState
{

	private var currentFrame:FlxSprite;
	private var frameIndex:Int = 0;
	private var victorySound:FlxSound;

	override public function create():Void
	{
		currentFrame = new FlxSprite();
		add(currentFrame);
		
		victorySound = FlxG.sound.load(AssetPaths.victory_tune1__mp3);
		
		nextFrame();
		
		victorySound.play();
	}
	
	private function nextFrame() {
		frameIndex ++;
		if (frameIndex <= 2) {
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