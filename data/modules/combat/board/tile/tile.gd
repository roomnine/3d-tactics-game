class_name Tile
extends StaticBody3D
## Handles tiles, hover colors, tile state, pathfinding.
## 
## This is ultimately a module, as it is programatically appended onto every tile by way of the TileService.
## Dependencies: [TileService] [br]
## Used by: [GameBoard]

#region: --- Props ---
## Resource for tile raycasting
var tile_raycast: Resource = load("res://data/modules/combat/board/tile/tile_raycasting.tscn")

## Whether the tile is reachable
var is_reachable: bool = false
## Whether the tile is attackable
var is_attackable: bool = false
## Whether the tile is being hovered over
var is_hovered: bool = false

## Pathfinding starting point.[br]Used by [TacticsBoard]
var pf_root: Tile
## The distance to cover.[br]Used by [TacticsBoard]
var pf_distance: float

## Material for hover state
var hover_mat: StandardMaterial3D = TacticsConfig.mat_color.hover
## Material for reachable state
var reachable_mat: StandardMaterial3D = TacticsConfig.mat_color.reachable
## Material for hover and reachable state
var hover_reachable_mat: StandardMaterial3D = TacticsConfig.mat_color.reachable_hover
## Material for attackable state
var attackable_mat: StandardMaterial3D = TacticsConfig.mat_color.attackable
## Material for hover and attackable state
var hover_attackable_mat: StandardMaterial3D = TacticsConfig.mat_color.hover_attackable
#endregion

#region: --- Processing ---
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Get child node named "Tile" and cast it to a MeshInstance3D.
	# If the node doesn't exist, it will be null.
	var tile: MeshInstance3D = get_node_or_null("Tile") as MeshInstance3D
	if not tile:
		return
	
	# Set visibility of the tile to visible if attackable, reachable, or hover are true.
	tile.visible = is_attackable or is_reachable or is_hovered # Set visibility based on tile state
	
	match is_hovered:
		true: # If hover is true, decide which material to use based on the tile's state
			if is_reachable:
				tile.material_override = hover_reachable_mat
			elif is_attackable:
				tile.material_override = hover_attackable_mat
			else:
				tile.material_override = hover_mat
		false: # If hover is false, this block decides between two materials
			if is_reachable:
				tile.material_override = hover_reachable_mat
			elif is_attackable:
				tile.material_override = hover_attackable_mat
#endregion

#region: --- Methods ---
# Getters
## Returns all 4 directly adjacent tiles
func get_neighboring_tiles(height: float):
	return $TileRaycasting.get_neighboring_tiles(height)

## Returns any collider directly (<=1m) above
func get_tile_occupier() -> Object:
	return $TileRaycasting.get_object_above()

## Returns whether target tile is occupied
func is_tile_occupied() -> bool:
	return get_tile_occupier() != null

#Setters
## Resets tile markers
func reset_markers() -> void:
	pf_root = null
	pf_distance = 0
	is_reachable = false
	is_attackable = false

## Initializes tile (disable hover, instantiate raycast & reset state)
func configure_tile() -> void:
	is_hovered = false
	var instance: Node = tile_raycast.instantiate() # Instantiate Raycast
	add_child(instance) # Add raycast as child
	reset_markers() # Reset tile markers
#endregion
