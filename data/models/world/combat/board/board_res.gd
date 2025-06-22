class_name BoardResource
extends Resource
## Attributes, controller & signals of the game board.

## Emitted when all tile markers need to be reset
signal called_reset_all_tile_markers
## Emitted when pathfinding tilestack is requested
## [param tile] The target tile for pathfinding
signal called_get_pathfinding_tilestack(tile: Tile)
## Emitted when a tile needs to be marked as hovered
## [param tile] The tile to be marked as hovered
signal called_mark_hover_tile(tile: Tile)

## Stores the current pathfinding tiles stack
var path_tiles_stack: Array = []

## Triggers the reset of all tile markers
func reset_all_tile_markers() -> void:
	called_reset_all_tile_markers.emit()
	
## Requests the pathfinding tilestack for a given tile
## [param tile] The target tile for pathfinding
## [returns] The array of tiles in the pathfinding stack
func get_pathfinding_tilestack(tile: Tile) -> Array:
	called_get_pathfinding_tilestack.emit(tile)
	return path_tiles_stack
	
## Marks a tile as hovered
## [param tile] The tile to be marked as hovered
func mark_hover_tile(tile: Tile) -> void:
	called_mark_hover_tile.emit(tile)
