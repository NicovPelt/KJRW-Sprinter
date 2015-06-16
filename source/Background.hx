package;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;

/**
 * ...
 * @author Nico van Pelt
 */
class Background extends FlxTypedGroup<FlxSprite>
{
	
	private var background:FlxSprite;
	private var mountains:FlxSprite;
	private var buildings:FlxSprite;
	private var clouds:FlxSprite;
	
	private var counter:Int = 0;

	public function new(MaxSize:Int=0) 
	{
		super(MaxSize);
		
		//background, mountains, buildings, clouds
		background = new FlxSprite(0, -300);
		background.loadGraphic("assets/images/background/background.png");
		//background.scale.set(0.5, 0.5);
		background.scrollFactor.set();
		add(background);
		mountains = new FlxSprite(0, -200);
		mountains.loadGraphic("assets/images/background/mountains.png");
		//mountains.scale.set(0.5, 0.5);
		mountains.scrollFactor.set(0, 0);
		add(mountains);
		buildings = new FlxSprite(0, -900);
		buildings.loadGraphic("assets/images/background/Buildings.png");
		//buildings.scale.set(0.5, 0.5);
		buildings.scrollFactor.set(0, 0);
		add(buildings);
		clouds = new FlxSprite();
		clouds.loadGraphic("assets/images/background/Clouds.png");
		//clouds.scale.set(0.5, 0.5);
		clouds.scrollFactor.set();
		add(clouds);
	}
	
	public function move() {
		counter ++;
		if (counter % 3 == 0) {
			clouds.x --;
		}
		if (counter % 6 == 0) {
			buildings.x --;
		}
		if (counter % 9 == 0) {
			mountains.x --;
		}
		if (counter % 12 == 0) {
			counter = 0;
			background.x --;
		}
	}
	
}