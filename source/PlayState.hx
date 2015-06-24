package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.FlxObject;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxPoint;
import haxe.Timer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var level:Level;
	public var player:FlxSprite;
	public var phantom:FlxSprite; //used for collision. not visible
	public var deathZone:Array<DeathZone>;
	private var currentDeathZone:DeathZone;
	public var endZone:FlxObject;
	private var hud:HUD;
	private var background:Background;
	
	private var paused:Bool = false;
	
	public var airtime:Float = 0;
	private var MAX_AIRTIME:Float = 0.2;
	private var jumpReleased:Bool = true;
	private var lives:Int = 3;
	public var currentCheckpoint:FlxPoint;
	public var checkpoints:Array<Checkpoint>;
	public var coins:FlxGroup;
	
	public var haveCoin:Bool = false;
	public var atQuestion:Int;
	
	private var jumpSound:FlxSound;
	private var walkSound:FlxSound;
	private var defeatSound:FlxSound;
	private var pickupSound:FlxSound;
	
	public static var music:Bool = true;
	public static var sound:Bool = true;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		background = new Background();
		add(background);
		
		checkpoints = new Array<Checkpoint>();
		deathZone = new Array<DeathZone>();
		coins = new FlxGroup();
		
		level = new Level("assets/data/level1.tmx");
		
		//adding non-collidable background layer.
		add(level.background);
		
		//adding the solid platforms to the stage. When adding background, add before this!
		add(level.platforms);
		
		level.loadObjects(this);
		
		add(coins);
		
		jumpSound = FlxG.sound.load(AssetPaths.jump_sound__mp3);
		walkSound = FlxG.sound.load(AssetPaths.step_sound__mp3);
		defeatSound = FlxG.sound.load(AssetPaths.deafeat_tune1__mp3);
		pickupSound = FlxG.sound.load(AssetPaths.Pickup2__mp3);
		
		player.animation.play("walk");
		
		FlxG.sound.playMusic(AssetPaths._12_Through_the_Forest__mp3, 0.5);
		
		hud = new HUD(0, lives);
		add(hud);
		MouseEventManager.add(hud.pauseButton, pause, null, null, null);
		MouseEventManager.add(hud.muteSound, muteSound, null, null, null);
		MouseEventManager.add(hud.muteMusic, muteMusic, null, null, null);
	}
	
	/**
	 * Function that is called when this state is destroyed 
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
	
	private function pause(sprite:FlxSprite) {
		paused = !paused;
		hud.pause(paused);
		if (paused) {
			FlxG.sound.pause();
		} else if(music) {
			FlxG.sound.resume();
		}
	}
	
	private function muteSound(sprite:FlxSprite) {
		if (sound) {
			sound = false;
			hud.muteSound.loadGraphic("assets/images/sound_off.png");
		} else {
			sound = true;
			hud.muteSound.loadGraphic("assets/images/sound_on.png");
		}
	}
	
	private function muteMusic(sprite:FlxSprite) {
		if (music) {
			music = false;
			FlxG.sound.pause();
			hud.muteMusic.loadGraphic("assets/images/music_off.png");
		} else {
			music = true;
			FlxG.sound.resume();
			hud.muteMusic.loadGraphic("assets/images/music_on.png");
		}
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (FlxG.keys.justPressed.P || FlxG.keys.justPressed.ESCAPE) {
			pause(hud.pauseButton);
		}
		
		if (!paused) {
			
			background.move();
			
			if (FlxG.keys.pressed.SPACE && airtime >= 0 && jumpReleased)//char jumps
			{
				player.animation.play ( "jump up" );
				
				if(sound) jumpSound.play();
				
				airtime += FlxG.elapsed;
				phantom.velocity.y = -phantom.maxVelocity.y - 100;
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
			
			if (haveCoin && atQuestion > 0 && FlxG.keys.justPressed.ENTER) {
				haveCoin = false;
				hud.KJRWHulp(atQuestion);
				hud.removeCoin();
			}
			
			if (phantom.velocity.x < phantom.maxVelocity.x) {//character moves forward
				phantom.acceleration.x = phantom.maxVelocity.x * 4;
			}
			
			super.update();
			
			if (level.collideWithPlatforms(phantom)) {//char touches platform
				airtime = 0;
				if(sound) walkSound.play();
				player.animation.play ( "walk" );
			} else if (!FlxG.keys.pressed.SPACE) {//player walks off of the platform
				player.animation.play ( "jump down" );
			}
			
			for(zone in deathZone){
				if (FlxG.overlap(phantom, zone))//player has fallen outside of the level, dies
				{
					paused = !paused;
					FlxG.sound.pause();
					if(sound) defeatSound.play();
					currentDeathZone = zone;
					Timer.delay(death, 3000);
				}
			}
			
			if (FlxG.overlap(phantom, endZone)) {
				FlxG.sound.pause();
				Main.victoryState = new VictoryState();
				FlxG.switchState(Main.victoryState);
			}
			
			FlxG.overlap(coins, phantom, getCoin);
			
			for (checkpoint in checkpoints) {
				if (FlxG.overlap(phantom, checkpoint)) {
					switch(checkpoint.name) {
						case "checkpoint1":
							atQuestion = 1;
						case "checkpoint2":
							atQuestion = 2;
						case "checkpoint3":
							atQuestion = 3;
						default:
							atQuestion = 0;
					}
					checkpoints.remove(checkpoint); 
					checkpoint.checkReached();
					currentCheckpoint = new FlxPoint(checkpoint.x, checkpoint.y);
					hud.checkpointReached(checkpoint.name, haveCoin);
					break;
				}
			}
			player.x = phantom.x - 20;
			player.y = phantom.y;
		} else if(FlxG.keys.justPressed.SPACE) {
			paused = !paused;
			hud.removePause();
			FlxG.sound.resume();
		}
	}
	
	public function death() {
		if (hud.loseLife() == 0) {
			//game over
			Main.gameOverState = new GameOverState();
			FlxG.switchState(Main.gameOverState);
		} else {
			phantom.x = currentCheckpoint.x;
			phantom.y = currentCheckpoint.y;
			hud.whyDeath(currentDeathZone.name);
		}
	}
	
	public function getCoin(coin:FlxObject, player:FlxObject) {
		pickupSound.play();
		coin.kill();
		hud.getCoin();
		haveCoin = true;
	}
}