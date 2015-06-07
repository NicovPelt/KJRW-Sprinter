package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.FlxObject;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxPoint;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var level:Level;
	public var player:FlxSprite;
	public var deathZone:FlxObject;
	private var pauseButton:FlxSprite;
	private var pauseScreen:FlxSprite;
	private var hud:HUD;
	
	private var paused:Bool = false;
	
	public var airtime:Float = 0;
	private var MAX_AIRTIME:Float = 0.2;
	private var jumpReleased:Bool = true;
	private var lives:Int = 3;
	public var currentCheckpoint:FlxPoint;
	
	private var jumpSound:FlxSound;
	private var walkSound:FlxSound;	
	
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
		
		pauseButton = new FlxSprite();
		pauseButton.loadGraphic("assets/images/Pauze.png");
		add(pauseButton);
		
		jumpSound = FlxG.sound.load(AssetPaths.jump_sound__mp3);
		walkSound = FlxG.sound.load(AssetPaths.step_sound__mp3);
		
		player.animation.play("walk");
		
		FlxG.sound.playMusic(AssetPaths._12_Through_the_Forest__mp3);
		
		hud = new HUD(0, lives);
		add(hud);
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
		if (FlxG.keys.justPressed.P) {
			paused = !paused;
			
		}
		
		if (!paused) {
			
			if (FlxG.keys.pressed.SPACE && airtime >= 0 && jumpReleased)//char jumps
			{
				player.animation.play ( "jump up" );
				
				jumpSound.play();
				
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
				walkSound.play();
				player.animation.play ( "walk" );
			} else if (!FlxG.keys.pressed.SPACE) {//player walks off of the platform
				player.animation.play ( "jump down" );
			}
			
			if (FlxG.overlap(player, deathZone))//player has fallen outside of the level, dies
			{
				//FlxG.resetState();
				player.x = currentCheckpoint.x;
				player.y = currentCheckpoint.y;
				if (hud.loseLife() == 0) {
					//game over
				}
			}
		}
	}	
}