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
	private var jumpReleased:Bool = true;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		FlxG.mouse.visible = false;
		
		bgColor = 0xffaaaaaa;
		
		level = new Level("assets/data/level1.tmx");
		
		//adding non-collidable background layer.
		add(level.background);
		
		//adding the solid platforms to the stage. When adding background, add before this!
		add(level.platforms);
		
		level.loadObjects(this);
		
		
		
		player.animation.play("walk");
	}
	
	/**
	 * Function that is called when this state is destroyed 
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
		if (FlxG.keys.pressed.SPACE && airtime >= 0 && jumpReleased)//char jumps
		{
			player.animation.play ( "jump up" );
			
			airtime += FlxG.elapsed;
			player.velocity.y += -player.maxVelocity.y;
			if(airtime >= MAX_AIRTIME){
				airtime = -1;
				player.animation.play ( "jump down" );
			}
		} else if (airtime != 0)//spacebar is released or reached max jump height
		{
			jumpReleased = false;
			airtime = -1;
			player.animation.play ( "jump down" );
		}
		
		if (!FlxG.keys.pressed.SPACE) {//player released spacebar, so can jump again
			jumpReleased = true;
		}
		
		if (player.velocity.x < player.maxVelocity.x) {//character moves forward
			player.acceleration.x = player.maxVelocity.x * 4;
		}
		
		super.update();
		
		if (level.collideWithPlatforms(player)) {//char touches platform
			airtime = 0;
			
			player.animation.play ( "walk" );
		} else if (!FlxG.keys.pressed.SPACE) {//player walks off of the platform
			player.animation.play ( "jump down" );
		}
		
		if (FlxG.overlap(player, deathZone))//player has fallen outside of the level, dies
		{
			FlxG.resetState();
		}
	}	
}