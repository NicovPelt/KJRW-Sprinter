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

/**
 * ...
 * @author Nico van Pelt
 */
class Level extends TiledMap
{
	// points to the folder where all the tilesets should be stored
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/images/";
	
	//groups to contain different tile layers. Remember to add when foreground and/or background is added
	public var platforms:FlxGroup;
	public var background:FlxGroup;
	private var collidableTileLayers:Array<FlxTilemap>;
	
	public function new(level:Dynamic) 
	{
		super(level);
		
		platforms = new FlxGroup();
		background = new FlxGroup();
		
		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);
		
		for (tileLayer in layers) {
			var tileSheetName:String = tileLayer.properties.get("tileset");
			if (tileSheetName == null)
				trace ("'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.");
				
			var tileSet:TiledTileSet = null;
			for (ts in tilesets) { //loop to find the right tileset
				if (ts.name == tileSheetName) {
					tileSet = ts;
					break;
				}
			}
			if (tileSet == null)
				throw "Tileset '" + tileSheetName + " not found. Did you mispell the 'tilesheet' property in " + tileLayer.name + "' layer?";
				
			//puts together the imagepath for the tilesheet
			var imagePath = new Path(tileSet.imageSource);
			var proccessedPath = c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, proccessedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);
			
			//check what kind of layer it is
			if (tileLayer.properties.contains("solid")) {
				if (collidableTileLayers == null)
					collidableTileLayers = new Array<FlxTilemap>();
				
				platforms.add(tilemap);
				collidableTileLayers.push(tilemap);
			}else {
				//add code when non-solid layers are added
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
	
	private function loadObject(object:TiledObject, group:TiledObjectGroup, state:PlayState) {
		var x:Int = object.x;
		var y:Int = object.y;
		
		if (object.gid != -1)
			y -= group.map.getGidOwner(object.gid).tileHeight;
			
		switch(object.type.toLowerCase()) {
			case "player_start":
				var player = new FlxSprite(x, y);
				player.loadGraphic( "assets/images/runner.png", true, 128, 128);
				player.animation.add( "walk", [0, 1, 2, 3, 4, 5, 6, 7], 12, true);
				player.animation.add( "jump up", [ 8 ], 12, true);
				player.animation.add( "jump down", [ 9 ], 12, true);
				player.maxVelocity.x = 550;
				player.maxVelocity.y = 750;
				player.acceleration.y = 6400; 
				player.drag.x = player.maxVelocity.x * 4;
				FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER, new FlxPoint(-800,0), 3.5);
				state.player = player;
				state.add(player);
				
			case "death_zone":
				var floor = new FlxObject(x, y, object.width, object.height);
				state.deathZone = floor;
		}
	}
	
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