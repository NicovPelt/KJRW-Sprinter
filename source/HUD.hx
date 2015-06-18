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
	public var questionText:FlxText;

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
		
		pauseButton = new FlxSprite();
		pauseButton.loadGraphic("assets/images/Pauze.png");
		pauseButton.x = FlxG.stage.width - pauseButton.width - 10;
		pauseButton.y = 10;
		pauseButton.scale.set(0.5, 0.5);
		pauseButton.scrollFactor.set(0, 0);
		add(pauseButton);
		pauseScreen = new FlxSprite(0, 0, "assets/images/Pauze_scherm.png");
		pauseScreen.scrollFactor.set(0, 0);
		
		questionText = new FlxText(300, 100, 720);
		questionText.setFormat(null, 40, 0xffffff, "center", FlxText.BORDER_OUTLINE);
		//questionText.wordWrap = false;
		//questionText.autoSize = true;
		questionText.scrollFactor.set(0, 0);
		add(questionText);
		//questionText.text = "we doen wel een lange zin om te kijken wat er dan gebeurt";
		
	}
	
	public function loseLife() {
		remove(lives.pop());
		return lives.length;
	}
	
	public function pause(paused:Bool) {
		if (paused) {
			add(pauseScreen);
		} else {
			remove(pauseScreen);
		}
	}
	
	/**
	 * called when a player reaches a checkpoint. Asks the player the right question or removes the question from the screen.
	 * @param	name
	 */
	public function checkpointReached(name:String) {
		switch(name) {
			case "checkpoint1":
				questionText.text = "Ik moet eigenlijk naar school gaan.";//whatever text belongs to this question
			case "checkpoint2":
				questionText.text = "Er zijn op school regels die ik moet volgen";
			case "checkpoint3":
				questionText.text = "Ik moet wel mijn best blijven doen, ander moet ik een groep blijven zitten.";
			default:
				questionText.text = "Ja! Dat was de juiste keuze.";
			
		}
		
		questionText.x = (FlxG.stage.stageWidth - questionText.width) / 2;
	}
	
	public function whyDeath() {
		//Show text on screen that explains the mistake if the cause of death was a wrongly answered question
	}
}