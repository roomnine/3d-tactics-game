class_name TileService
extends Node3D
## Helper for everything Tile related

## The [TacticsTile] script we append to each tile after conversion
const TILE_SRC: String = "res://data/modules/combat/board/tile/tile.gd"

## Converts child MeshInstance3D nodes into StaticBody3D nodes with TacticsTile script
## [param tiles_obj] The Node3D containing tile MeshInstance3D children to convert
static func tiles_into_static_bodies(tiles_obj: Node3D, tile_layout: TileLayout) -> void:
	# This function transforms 'Tiles' into the following structure:
	#	> Tiles:                          > Tiles:
	#		> Tile1                           > StaticBody3D (tile.gd):
	#		> Tile2                               > Tile1
	#		...                                   > CollisionShape3D
	#		> TileN   -- TRANSFORM INTO ->    > StaticBody2 (tile.gd):
	#											  > Tile2
	#											  > CollisionShape3D
	#												...
	# Useful for configuring walkable tiles as efficiently as possible
	var children = tiles_obj.get_children()
	
	for i in children.size():
		var _t: MeshInstance3D = children[i]
		_t.create_trimesh_collision() # Create StaticBody3D child with CollisionShape3D
		var _static_body: StaticBody3D = _t.get_child(0) # Get the created StaticBody3D
		_static_body.set_position(_t.get_position()) # Set StaticBody3D position
		
		_t.set_position(Vector3.ZERO) # Reset MeshInstance3D position
		_t.set_name("Tile") # Rename MeshInstance3D to "Tile"
		_t.remove_child(_static_body) # Remove StaticBody3D from MeshInstance3D
		tiles_obj.remove_child(_t) # Remove MeshInstance3D from tiles_obj
		
		_static_body.add_child(_t) # Add MeshInstance3D as a child of StaticBody3D
		_static_body.set_script(load(TILE_SRC)) # Attach TacticsTile script to StaticBody3D
		
		var tile_name := _static_body.name.replace("_col", "")
		var index := GetTileIndexFromName.get_tile_index_from_name(tile_name)

		if index != -1:
			_static_body.name = "Tile%d_col" % index
			if tile_layout.tile_layout.has(index):
				_static_body.effect = tile_layout.tile_layout[index]
				#if _static_body.effect and _static_body.effect.is_victory_tile:
					#print("✅ Tile ", index, " marked as a VICTORY TILE")
					#print("This tile's name is: ", _static_body.name)
			else:
				print("Tile%d => NO EFFECT" % index)
		else:
			print("⚠️ Could not determine index from: ", _static_body.name)
		
		_static_body.configure_tile() # Initialize tile (raycast, hover, state)
		
		_static_body.set_process(true) # Enable _process for the tile
		tiles_obj.add_child(_static_body) # Add configured StaticBody3D back to tiles_obj
#endregion
