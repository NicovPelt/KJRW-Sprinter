package;

import flixel.FlxSprite;

/**
 * A simple extention of the default sprite class in order to give it a name that can be referenced.
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
	
	/**
	 * Changes the graphic of the checkpoint to indicate that the player has reached it.
	 */
	public function checkReached() {
		loadGraphic("assets/images/checkpoint2.png");
	}
}