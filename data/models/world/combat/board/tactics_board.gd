class_name TacticsBoard
extends Node3D
## Tile config & sorting, neighbours, hover & reach UI overlay, pathfinding and targeting utilities.
## 
## Resource Interface: [BoardResource] -- Service: [BoardService]
## Dependency: [Tile] -- Service: [TileService]


## Resource containing board-related data and configurations
@export var res: BoardResource = load("res://data/models/world/combat/board/board.tres")

## Reference to the TileLayout node, handling tile layout
@onready var tile_layout: TileLayout
## Service handling board-related operations
var serv: BoardService


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	serv = BoardService.new(res)
	serv.setup(self)


## Resets all tile markers in the board
func reset_all_tile_markers() -> void:
	serv.reset_all_tile_markers(self)


## Configures all tiles in the arena
func configure_tiles(tile_layout: TileLayout) -> void:
	serv.configure_tiles(self, tile_layout)


## Processes tiles surrounding a given root tile
## [param root_tile] The central tile to process around
## [param height] The height to consider for processing
## [param allies_on_map] Array of allied units on the map (optional)
func process_surrounding_tiles(root_tile: Tile, height: float, allies_on_map: Array, enemies_on_map: Array) -> void:
	serv.process_surrounding_tiles(root_tile, height, allies_on_map, enemies_on_map)


## Returns an array of tiles representing the pathfinding stack to a given tile
## [param to] The destination tile
## [returns] Array of tiles forming the path
func get_pathfinding_tilestack(to: Tile) -> Array:
	return serv.get_pathfinding_tilestack(to)


## Finds the nearest tile adjacent to any target unit
## [param unit] The unit seeking a target
## [param target_units] Array of potential target units
## [returns] The nearest adjacent tile to a target
func get_nearest_target_adjacent_tile(unit: DefaultUnit, target_units: Array) -> Tile:
	return serv.get_nearest_target_adjacent_tile(unit, target_units)


## Identifies the weakest targetable unit from an array of units
## [param unit_arr] Array of units to evaluate
## [returns] The weakest targetable unit
func get_weakest_targetable_unit(unit_arr: Array) -> DefaultUnit:
	return serv.get_weakest_targetable_unit(unit_arr)


## Marks a tile as hovered
## [param tile] The tile to mark as hovered
func mark_hover_tile(tile: Tile) -> void:
	serv.mark_hover_tile(self, tile)


## Marks a tile as being part of a path
## [param tile] The tile to mark as being part of a path
func mark_path_preview(tile: Tile) -> void:
	serv.mark_path_preview(self, tile)


## Marks tiles reachable within a certain distance from a root tile
## [param root] The starting tile
## [param distance] The maximum distance to consider
func mark_reachable_tiles(root: Tile, distance: float) -> void:
	serv.mark_reachable_tiles(self, root, distance)


## Marks tiles targetable within a certain distance from a root tile
## [param root] The starting tile
## [param distance] The maximum attack distance
func mark_targetable_tiles(root: Tile, distance: float) -> void:
	serv.mark_targetable_tiles(self, root, distance)


## Marks tiles being targeted by a skill within a certain distance from a root tile
## [param root] The starting tile
## [param distance] The maximum attack distance
func mark_target_preview_tiles(root: Tile, distance: float) -> void:
	serv.mark_target_preview_tiles(self, root, distance)


## Determines whether a unit is on a victory tile
func is_unit_on_victory_tile(unit: DefaultUnit) -> bool:
	return serv.is_unit_on_victory_tile(unit)
