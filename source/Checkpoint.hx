package;

import flixel.FlxSprite;

/**
 * ...
 * @author Nico van Pelt
 */
class Checkpoint extends FlxSprite
{
	public var name:String;

	public function new(X:Float=0, Y:Float=0, Width:Float=0, Height:Float=0, name:String) 
	{
		super(X, Y, "assets/images/checkpoint1.png");
		this.name = name;
		
	}
	
	public function checkReached() {
		loadGraphic("assets/images/checkpoint2.png");
	}
}