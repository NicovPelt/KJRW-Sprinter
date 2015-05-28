package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxMath;
import flixel.plugin.MouseEventManager;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	var background:FlxSprite;
	var startButton:FlxSprite;
	var optionsButton:FlxSprite;
	var infoButton:FlxSprite;
	var quitButton:FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		background = new FlxSprite();
		background.loadGraphic("assets/images/mainMenu/Main Menu.png");
		add(background);
		
		startButton = new FlxSprite();
		startButton.loadGraphic("assets/images/mainMenu/Start Spel.png");
		add(startButton);
		startButton.x = (FlxG.width / 2 - startButton.width) / 2;
		startButton.y = 300;
		optionsButton = new FlxSprite();
		optionsButton.loadGraphic("assets/images/mainMenu/Instellingen.png");
		add(optionsButton);
		optionsButton.x = (FlxG.width / 2 - optionsButton.width) / 2;
		optionsButton.y = 500;
		infoButton = new FlxSprite();
		infoButton.loadGraphic("assets/images/mainMenu/Info.png");
		add(infoButton);
		infoButton.x = (FlxG.width / 4) * 3 - infoButton.width / 2;
		infoButton.y = 300;
		quitButton = new FlxSprite();
		quitButton.loadGraphic("assets/images/mainMenu/Stop.png");
		add(quitButton);
		quitButton.x = (FlxG.width / 4) * 3 - quitButton.width / 2;
		quitButton.y = 500;
		
		FlxG.plugins.add(new MouseEventManager());
		MouseEventManager.add(startButton, startGame, null, mouseOver, mouseOut);
		MouseEventManager.add(optionsButton, gotoOptions, null, mouseOver, mouseOut);
		MouseEventManager.add(infoButton, gotoInfoPage, null, mouseOver, mouseOut);
		MouseEventManager.add(quitButton, quit, null, mouseOver, mouseOut);
		
	}
	
	function startGame(sprite:FlxSprite) {
		FlxG.cameras.fade(0xff000000, 1, false, start);
	}
	
	function gotoOptions(sprite:FlxSprite) {
		
	}
	
	function gotoInfoPage(sprite:FlxSprite) {
		
	}
	
	function quit(sprite:FlxSprite) {
		
	}
	
	function start() {
		FlxG.switchState(new PlayState());
	}
	
	function mouseOver(sprite:FlxSprite) {
		
	}
	
	function mouseOut(sprite:FlxSprite) {
		
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
		super.update();
	}	
}