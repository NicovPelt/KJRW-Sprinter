package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;

/**
 * ...
 * @author Nico van Pelt
 */
class IntroState extends FlxState
{
	
	private var currentFrame:FlxSprite;
	private var frameIndex:Int = 0;
	private var textField:FlxText;

	public function new() 
	{
		super();
		currentFrame = new FlxSprite();
		add(currentFrame);
		textField = new FlxText(0, 600, 720);
		textField.setFormat(null, 20, 0xffffff, "center", FlxText.BORDER_OUTLINE);
		textField.text = "Hallo daar, ik probeer het eerst eens met deze teks om te zien of het werkt";
		add(textField);
		nextFrame();
	}
	
	private function nextFrame() {
		frameIndex ++;
		if (!(frameIndex > 7)) {
			currentFrame.loadGraphic("assets/images/introComic/0" + frameIndex + ".png");
			currentFrame.x = (FlxG.stage.width - currentFrame.width) / 2;
		} else {
			Main.playState = new PlayState();
			FlxG.switchState(Main.playState);
		}
		switch(frameIndex) {
			case 1:
				textField.text = "Hallo daar, ik probeer het eerst eens met deze teks om te zien of het werkt";
				
			case 2:
				textField.text = "En hoe ziet het er dan uit als ik verder zou gaan?";
		}
	}
	
	override public function update() {
		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE ) 
			nextFrame();
	}
	
}