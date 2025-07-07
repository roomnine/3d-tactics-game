class_name Tile
extends StaticBody3D
## Handles tiles, hover colors, tile state, pathfinding.
## 
## This is ultimately a module, as it is programatically appended onto every tile by way of the TileService.
## Dependencies: [TileService] [br]
## Used by: [GameBoard]

#region: --- Props ---
## Resource for tile raycasting
var tile_raycast: Resource = load("res://data/modules/combat/board/tile/raycasting/tile_raycasting.tscn")
## The terrain/effect associated with this tile
@export var effect: TileEffectResource

## Whether the tile is reachable by movement
var is_reachable: bool = false
## Whether the tile is targetable by attack or skill
var is_targetable: bool = false
## Whether the tile is being hovered over
var is_hovered: bool = false
## Whether the tile is used in the path when hovering over a target while selecting movement
var is_path_preview: bool = false
## Whether the tile is targetable by skill without a target selection mechanism
var is_target_preview: bool = false

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
## Material for targetable state
var targetable_mat: StandardMaterial3D = TacticsConfig.mat_color.targetable
## Material for hover and targetable state
var hover_targetable_mat: StandardMaterial3D = TacticsConfig.mat_color.hover_targetable
#endregion

#region: --- Processing ---
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Get child node named "Tile" and cast it to a MeshInstance3D.
	# If the node doesn't exist, it will be null.
	var tile: MeshInstance3D = get_node_or_null("Tile") as MeshInstance3D
	if not tile:
		return
	
	# Set visibility of the tile to visible if targetable, reachable, or hover are true.
	tile.visible = is_targetable or is_reachable or is_hovered or is_path_preview or is_target_preview # Set visibility based on tile state
	
	match is_hovered:
		true: # If hover is true, decide which material to use based on the tile's state
			tile.material_override = hover_mat
		false: # If hover is false, this block decides between two materials
			if is_path_preview:
				tile.material_override = hover_mat
			elif is_target_preview:
				tile.material_override = hover_mat
			else:
				if is_reachable:
					tile.material_override = hover_reachable_mat
				elif is_targetable:
					tile.material_override = hover_targetable_mat
#endregion

#region: --- Methods ---
# Getters
## Returns all 4 directly adjacent tiles
func get_neighboring_tiles(height: float):
	return $TileRaycasting.get_neighboring_tiles(height)

## Returns all tiles within the specified radius
## [param radius] Number of steps outward
func get_tiles_in_radius(radius: int) -> Array[Tile]:
	var visited: Dictionary = {}  # Tracks visited tiles
	var to_visit: Array = [self]  # Start from self
	visited[self] = true

	var current_radius = 0

	while current_radius < radius:
		var next_layer: Array = []
		for tile in to_visit:
			for neighbor in tile.get_neighboring_tiles(10):  # Use your neighbor height threshold
				if not visited.has(neighbor):
					visited[neighbor] = true
					next_layer.append(neighbor)
		to_visit = next_layer
		current_radius += 1

	# Return all collected tiles, excluding the center tile if you want
	var result: Array[Tile] = []
	for tile in visited.keys():
		result.append(tile)
	return result

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
	is_targetable = false
	is_path_preview = false

## Initializes tile (disable hover, instantiate raycast & reset state)
func configure_tile() -> void:
	is_hovered = false
	var instance: Node = tile_raycast.instantiate() # Instantiate Raycast
	add_child(instance) # Add raycast as child
	reset_markers() # Reset tile markers
#endregion
