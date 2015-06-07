package;

import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Nico van Pelt
 */
class HUD extends FlxTypedGroup<FlxSprite>
{
	
	public var lives:Array<FlxSprite>;

	public function new(MaxSize:Int=0, startingLives:Int) 
	{
		super(MaxSize);
		lives = new Array<FlxSprite>();
		var life:FlxSprite;
		for (i in 0...startingLives) {
			life = new FlxSprite((i * 80) + 20, 20, AssetPaths.pixelheart__png);
			life.scale.set(0.5, 0.5);
			life.scrollFactor.set(0, 0);
			lives.push(life);
			add(life);
		}
	}
	
	public function loseLife() {
		remove(lives.pop());
		return lives.length;
	}
	
}