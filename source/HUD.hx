package;

import flixel.group.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.FlxG;
import flixel.text.FlxText;

/**
 * ...
 * @author Nico van Pelt
 */
class HUD extends FlxTypedGroup<FlxSprite>
{
	
	public var lives:Array<FlxSprite>;
	public var pauseButton:FlxSprite;
	private var pauseScreen:FlxSprite;
	private var tipScreen:FlxSprite;
	public var questionText:FlxText;
	public var helpText:FlxText;
	public var coin:FlxSprite;

	public function new(MaxSize:Int=0, startingLives:Int) 
	{
		super(MaxSize);
		lives = new Array<FlxSprite>();
		var life:FlxSprite;
		for (i in 0...startingLives) {
			life = new FlxSprite((i * 80) + 20, 20, AssetPaths.pixelheart__png);
			life.scale.set(0.5, 0.5);
			life.scrollFactor.set(0, 0);
			lives.push(life);
			add(life);
		}
		
		coin = new FlxSprite(400, 20);
		coin.loadGraphic(AssetPaths.KJRW_coin__png);
		coin.scale.set(1.5, 1.5);
		coin.scrollFactor.set(0, 0);
		
		pauseButton = new FlxSprite();
		pauseButton.loadGraphic("assets/images/Pauze.png");
		pauseButton.x = FlxG.width - pauseButton.width - 20;
		pauseButton.y = 10;
		pauseButton.scale.set(0.5, 0.5);
		pauseButton.scrollFactor.set(0, 0);
		add(pauseButton);
		pauseScreen = new FlxSprite(0, 0, "assets/images/Pauze_scherm.png");
		pauseScreen.scrollFactor.set(0, 0);
		
		questionText = new FlxText(300, 100, 720);
		questionText.setFormat(null, 32, 0xffffff, "center", FlxText.BORDER_OUTLINE);
		questionText.scrollFactor.set(0, 0);
		add(questionText);	
		
		tipScreen = new FlxSprite(-150, 180, "assets/images/clue_menu.png");
		tipScreen.scale.set(0.4, 0.4);
		tipScreen.scrollFactor.set(0, 0);
		add(tipScreen);
		
		helpText = new FlxText(300, 600, 720);
		helpText.setFormat(null, 20, 0xffffff, "center", FlxText.BORDER_OUTLINE);
		helpText.scrollFactor.set(0, 0);
		helpText.text += "Druk op 'Enter' voor hulp van de KJRW.";
	}
	
	public function loseLife() {
		remove(lives.pop());
		return lives.length;
	}
	
	public function getCoin() {
		add(coin);
	}
	
	public function removeCoin() {
		remove(coin);
	}
	
	public function pause(paused:Bool) {
		if (paused) {
			add(pauseScreen);
		} else {
			remove(pauseScreen);
		}
	}
	
	public function removePause() {
		remove(pauseScreen);
	}
	
	/**
	 * called when a player reaches a checkpoint. Asks the player the right question or removes the question from the screen.
	 * @param	name
	 */
	public function checkpointReached(name:String, hasCoin:Bool) {
		switch(name) {
			case "checkpoint1":
				questionText.text = "Ik moet eigenlijk naar school gaan.";
				if (hasCoin)
					add(helpText);
			case "checkpoint2":
				questionText.text = "Er zijn op school regels die ik moet volgen.";
				if (hasCoin)
					add(helpText);
			case "checkpoint3":
				questionText.text = "Ik moet wel mijn best blijven doen, anders moet ik een groep blijven zitten.";
				if (hasCoin)
					add(helpText);
			default:
				questionText.text = "Ja! Dat was de juiste keuze.";
				remove(helpText);
			
		}
		
		questionText.x = (FlxG.stage.stageWidth - questionText.width) / 2;
	}
	
	public function whyDeath(reason:String) {
		//Show text on screen that explains the mistake if the cause of death was a wrongly answered question
		if (reason == "wrong1") {
			questionText.text = "Nee, ik kan toch beter naar school gaan.";
		} else if (reason == "wrong2") {
			questionText.text = "Oh nee! Zo kom ik in de problemen.";
		} else if (reason == "wrong3") {
			questionText.text = "Oh nee! Ik laat me te veel afleiden.";
		}
	}
}