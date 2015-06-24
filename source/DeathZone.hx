package;

import flixel.FlxObject;

/**
 * ...
 * @author Nico van Pelt
 */
class DeathZone extends FlxObject
{

	public var name:String;
	
	public function new(name:String, X:Float=0, Y:Float=0, Width:Float=0, Height:Float=0) 
	{
		super(X, Y, Width, Height);
		this.name = name;
	}
	
}