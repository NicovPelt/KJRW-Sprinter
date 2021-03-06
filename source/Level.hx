package ;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.util.FlxPoint;
import haxe.io.Path;
import flixel.system.debug.Log;

/**
 * This class prepairs the level using the .tmx file outputed by Tiled.
 * @author Nico van Pelt
 */
class Level extends TiledMap
{
	// points to the folder where all the tilesets should be stored
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/images/";
	
	//groups to contain different tile layers. Remember to add when foreground and/or background is added
	public var platforms:FlxGroup;
	public var background:FlxGroup;
	//public var secondBackground:FlxGroup;
	private var collidableTileLayers:Array<FlxTilemap>;
	
	public function new(level:Dynamic) 
	{
		super(level);
		
		platforms = new FlxGroup();
		background = new FlxGroup();
		
		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);
		
		for (tileLayer in layers) {//setting up the layers of the level
			var tileSheetName:String = tileLayer.properties.get("tileset");
			if (tileSheetName == null)
				FlxG.log.add("'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.");
			
			var tileSet:TiledTileSet = null;
			for (ts in tilesets) { //loop to find the right tileset
				if (ts.name == tileSheetName) {
					tileSet = ts;
					break;
				}
			}
			if (tileSet == null)
				FlxG.log.add( "Tileset '" + tileSheetName + " not found. Did you mispell the 'tilesheet' property in " + tileLayer.name + "' layer?");
				
			//puts together the imagepath for the tilesheet
			var imagePath = new Path(tileSet.imageSource);
			var proccessedPath = c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			FlxG.log.add(proccessedPath);
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, proccessedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);
			FlxG.log.add(tileLayer.name);
			//check what kind of layer it is
			if (tileLayer.properties.contains("solid")) {
				if (collidableTileLayers == null)
					collidableTileLayers = new Array<FlxTilemap>();
				platforms.add(tilemap);
				collidableTileLayers.push(tilemap);
			} else {
				//non solid layers
				FlxG.log.add(tilemap);
				background.add(tilemap);
			}
		}
	}
	
	public function loadObjects(state:PlayState) {
		//run for every object layer in the level.tmx file and for every object in those layers
		for (group in objectGroups) {
			for (object in group.objects) {
				loadObject(object, group, state);
			}
		}
	}
	
	/**
	 * Called by loadObjects to prepair the single objects for the level.
	 * @param	object
	 * @param	group
	 * @param	state
	 */
	private function loadObject(object:TiledObject, group:TiledObjectGroup, state:PlayState) {
		var x:Int = object.x;
		var y:Int = object.y;
		
		if (object.gid != -1)
			y -= group.map.getGidOwner(object.gid).tileHeight;
			
		switch(object.type.toLowerCase()) {
			case "player_start":
				var player = new FlxSprite(x, y);
				state.currentCheckpoint = new FlxPoint(x, y);
				player.loadGraphic( "assets/images/runner.png", true, 128, 128);
				player.animation.add( "walk", [0, 1, 2, 3, 4, 5, 6, 7], 12, true);
				player.animation.add( "jump up", [ 8 ], 12, true);
				player.animation.add( "jump down", [ 9 ], 12, true);
				state.player = player;
				var phantom:FlxSprite;
				phantom = new FlxSprite(x + 30, y);
				phantom.loadGraphic("assets/images/phantom.png");
				phantom.maxVelocity.x = 550;
				phantom.maxVelocity.y = 1000;
				phantom.acceleration.y = 5200; 
				phantom.drag.x = phantom.maxVelocity.x * 4;
				phantom.alpha = 0;
				state.phantom = phantom;
				state.add(phantom);
				state.add(player);
				FlxG.camera.follow(phantom, FlxCamera.STYLE_PLATFORMER, new FlxPoint(-800,0), 3.5);
				
			case "death_zone":
				var floor;
				if(object.name == "deathZone"){
					floor = new DeathZone(object.name, x, y + 400, object.width, object.height);
				}
				else{
					floor = new DeathZone(object.name, x, y, object.width, object.height);
				}
				state.deathZone.push(floor);
				
			case "victory":
				var end = new FlxObject(x, y, object.width, object.height);
				state.endZone = end;
				
			case "checkpoint":
				var checkpoint = new Checkpoint(x, y, object.width, object.height, object.name);
				state.checkpoints.push(checkpoint);
				state.add(checkpoint);
				//checkpoint.loadGraphic("assets/images/checkpoint1");
				
			case "coin":
				var tileset = group.map.getGidOwner(object.gid);
				var coin = new FlxSprite(x, y, "assets/images/KJRW-coin.png");//c_PATH_LEVEL_TILESHEETS + tileset.imageSource);
				state.coins.add(coin);
				//state.coins.push(coin);
		}
	}
	
	/**
	 * Checks whether the player is standing on a platform and makes sure they colide so it doesn't fall through.
	 * @param	obj
	 * @param	notifyCallback
	 * @param	processCallback
	 * @return
	 */
	public function collideWithPlatforms(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		if (collidableTileLayers != null)
		{
			for (map in collidableTileLayers)
			{
				// IMPORTANT: Always collide the map with objects, not the other way around. 
				//			  This prevents odd collision errors (collision separation code off by 1 px)
				if (!(obj.velocity.y < 0))
					return FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separateY);
			}
		}
		return false;
	}
}