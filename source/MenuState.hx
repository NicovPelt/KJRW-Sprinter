package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxMath;
import flixel.plugin.MouseEventManager;
import openfl.Lib;
import openfl.net.URLRequest;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	var background:FlxSprite;
	var startButton:FlxSprite;
	var optionsButton:FlxSprite;
	var infoButton:FlxSprite;
	
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
		//optionsButton = new FlxSprite();
		//optionsButton.loadGraphic("assets/images/mainMenu/Instellingen.png");
		//add(optionsButton);
		//optionsButton.x = (FlxG.width / 2 - optionsButton.width) / 2;
		//optionsButton.y = 500;
		infoButton = new FlxSprite();
		infoButton.loadGraphic("assets/images/mainMenu/Info.png");
		add(infoButton);
		infoButton.x = (FlxG.width / 4) * 3 - infoButton.width / 2;
		infoButton.y = 300;
		
		FlxG.plugins.add(new MouseEventManager());
		MouseEventManager.add(startButton, startGame, null, mouseOverStart, mouseOutStart);
		//MouseEventManager.add(optionsButton, gotoOptions, null, mouseOver, mouseOut);
		MouseEventManager.add(infoButton, gotoInfoPage, null, mouseOverInfo, mouseOutInfo);
		
	}
	
	/**
	 * Called when the start button is clicked
	 * @param	sprite
	 */
	function startGame(sprite:FlxSprite) {
		sprite.loadGraphic("assets/images/mainMenu/Start Spel.png");
		FlxG.cameras.fade(0xff000000, 1, false, start);
	}
	
	/**
	 * Called when the options button is clicked
	 * @param	sprite
	 */
	function gotoOptions(sprite:FlxSprite) {
		
	}
	
	/**
	 * Called when the info button is clicked
	 * @param	sprite
	 */
	function gotoInfoPage(sprite:FlxSprite) {
		sprite.loadGraphic("assets/images/mainMenu/Info.png");
		Lib.getURL(new URLRequest("http://noord.kjrw.nl/info/"));
	}
	
	function start() {
		FlxG.switchState(new IntroState());
	}
	
	/**
	 * Called when the cursor is hovered over any of the buttons
	 * Change the button to it's hover-over sprite
	 * @param	sprite
	 */
	function mouseOverStart(sprite:FlxSprite) {
		sprite.loadGraphic("assets/images/mainMenu/Mouse_Start Spel.png");
	}
	
	/**
	 * Called when the cursor is removed from the button. 
	 * Change the button back to it's default sprite
	 * @param	sprite
	 */
	function mouseOutStart(sprite:FlxSprite) {
		sprite.loadGraphic("assets/images/mainMenu/Start Spel.png");
	}
	
	/**
	 * Called when the cursor is hovered over any of the buttons
	 * Change the button to it's hover-over sprite
	 * @param	sprite
	 */
	function mouseOverInfo(sprite:FlxSprite) {
		sprite.loadGraphic("assets/images/mainMenu/Mouse_Info.png");
	}
	
	/**
	 * Called when the cursor is removed from the button. 
	 * Change the button back to it's default sprite
	 * @param	sprite
	 */
	function mouseOutInfo(sprite:FlxSprite) {
		sprite.loadGraphic("assets/images/mainMenu/Info.png");
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