package;

import flixel.FlxObject;

/**
 * ...
 * @author Nico van Pelt
 */
class Checkpoint extends FlxObject
{
	public var name:String;

	public function new(X:Float=0, Y:Float=0, Width:Float=0, Height:Float=0, name:String) 
	{
		super(X, Y, Width, Height);
		this.name = name;
	}
	
}