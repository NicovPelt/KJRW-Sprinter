package;

import flixel.FlxObject;

/**
 * A simple extention of the default object class in order to give it a name that can be referenced.
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