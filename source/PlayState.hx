package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.FlxObject;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var level:Level;
	public var player:FlxSprite;
	public var deathZone:FlxObject;
	
	public var airtime:Float = 0;
	private var MAX_AIRTIME:Float = 0.2;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.mouse.visible = false;
		
		bgColor = 0xffaaaaaa;
		
		level = new Level("assets/data/level1.tmx");
		
		//adding the solid platforms to the stage. When adding background, add before this!
		add(level.platforms);
		
		level.loadObjects(this);
		
		player.animation.play("test");
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (FlxG.keys.pressed.SPACE && airtime >= 0)
		{
			player.animation.play ( "jump up" );
			
			airtime += FlxG.elapsed;
			player.velocity.y += -player.maxVelocity.y;
			if(airtime >= MAX_AIRTIME){
				airtime = -1;
				player.animation.play ( "jump down" );
			}
		} else if (airtime != 0)
		{
			
			airtime = -1;
			player.animation.play ( "jump down" );
		}
		
		if (player.velocity.x < player.maxVelocity.x) {
			player.acceleration.x = player.maxVelocity.x * 4;
		}
		
		super.update();
		
		if (level.collideWithPlatforms(player)) {
			airtime = 0;
			
			player.animation.play ( "test" );
		} 
		
		if (FlxG.overlap(player, deathZone))
		{
			FlxG.resetState();
		}
	}	
}