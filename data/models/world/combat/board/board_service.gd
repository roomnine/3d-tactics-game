class_name BoardService
extends RefCounted
## Service class for TacticsBoard

## The service we inject into every tile
const TILE_SERVICE = preload("res://data/models/world/combat/board/tiles/tile_service.gd")

var res: BoardResource

## Initialize the service with a BoardResource
## [param _res] The BoardResource to use
func _init(_res: BoardResource) -> void:
	res = _res

## Set up the board by connecting signals
## [param board] The TacticsBoard to set up
func setup(board: TacticsBoard) -> void:
	if not res:
		push_error("Needs a BoardResource from /data/models/world/combat/board/board_res")
	else:
		res.connect("called_reset_all_tile_markers", board.reset_all_tile_markers)
		res.connect("called_get_pathfinding_tilestack", board.get_pathfinding_tilestack)
		res.connect("called_mark_hover_tile", board.mark_hover_tile)
		res.connect("called_mark_path_preview", board.mark_path_preview)

## Reset markers for all tiles in the board
## [param board] The TacticsBoard containing the tiles
func reset_all_tile_markers(board: TacticsBoard) -> void:
	for _t: Tile in board.get_node("Tiles").get_children():
		_t.reset_markers()

## Configure tiles in the board
## [param board] The TacticsBoard to configure
func configure_tiles(board: TacticsBoard, tile_layout: TileLayout) -> void:
	board.get_node("Tiles").visible = true
	var _tiles: Node3D = board.get_node("Tiles")
	TILE_SERVICE.tiles_into_static_bodies(_tiles, tile_layout)

## Process tiles surrounding a root tile
## [param root_tile] The starting tile
## [param height] The height to consider for neighbors
## [param allies_on_map] Array of allied units on the map
## [param enemies_on_map] Array of enemy units on the map
func process_surrounding_tiles(root_tile: Tile, height: float, allies_on_map: Array, enemies_on_map: Array) -> void:
	var _tiles_process_q: Array = [root_tile]
	root_tile.pf_distance = 0
	root_tile.pf_root = null

	while not _tiles_process_q.is_empty():
		var _curr_tile: Tile = _tiles_process_q.pop_front()

		# Check if current tile is adjacent to an enemy
		var is_adjacent = false
		for enemy in enemies_on_map:
			if not enemy.is_alive():
				continue
			var enemy_tile = enemy.get_tile()
			if enemy_tile and _curr_tile in enemy_tile.get_neighboring_tiles(enemy.stats.jump):
				is_adjacent = true
				break

		# If this tile is adjacent to an enemy and is not the root tile, stop propagating neighbors
		if is_adjacent and _curr_tile != root_tile:
			continue

		# Otherwise, enqueue neighbors
		for _neighbor in _curr_tile.get_neighboring_tiles(height):
			if _neighbor.pf_root != null or _neighbor == root_tile:
				continue
			
			# 🟢 Check if the tile has an OBSTRUCTIVE effect
			if _neighbor.effect and _neighbor.effect.effect_type == TileEffectResource.EffectType.OBSTRUCTIVE:
				# Skip this tile — can't move through it
				continue

			# Compute vertical movement cost
			var vertical_cost = max(0, _neighbor.global_position.y - _curr_tile.global_position.y)

			# If occupied, mark but don't propagate
			if _neighbor.is_tile_occupied():
				_neighbor.pf_root = _curr_tile
				_neighbor.pf_distance = _curr_tile.pf_distance + 1 + vertical_cost
				continue

			# Normal propagation
			_neighbor.pf_root = _curr_tile
			_neighbor.pf_distance = _curr_tile.pf_distance + 1 + vertical_cost
			_tiles_process_q.push_back(_neighbor)

## Get the pathfinding tilestack to a target tile
## [param to] The target tile
## [returns] Array of global positions forming the path
func get_pathfinding_tilestack(to: Tile) -> Array:
	var _path_tiles_stack: Array = []
	
	while to:
		to.is_hovered = true
		_path_tiles_stack.push_front(to.global_position)
		to = to.pf_root
		
	res.path_tiles_stack = _path_tiles_stack
	return _path_tiles_stack

## Get the nearest tile adjacent to a target unit
## [param unit] The unit seeking a target
## [param target_units] Array of potential target units
## [returns] The nearest adjacent tile or the unit's current tile if no target found

func get_nearest_target_adjacent_tile(unit: DefaultUnit, target_units: Array) -> Tile:
	var _nearest_target: Node3D = null
	
	for _unit: DefaultUnit in target_units:
		if _unit.stats.curr_health <= 0: continue
		for _n: Tile in _unit.get_tile().get_neighboring_tiles(unit.stats.jump):
			if not _nearest_target or _n.pf_distance < _nearest_target.pf_distance:
				if _n.pf_distance > 0 and not _n.is_tile_occupied():
					_nearest_target = _n
	
	while _nearest_target and not _nearest_target.is_reachable: 
		_nearest_target = _nearest_target.pf_root
	
	if _nearest_target:
		return _nearest_target 
	else:
		DebugLog.debug_nospam("nearest_target", unit)
		return unit.get_tile()

## Get the weakest targetable unit from an array of units
## [param unit_arr] Array of units to evaluate
## [returns] The weakest targetable unit or null if none found

func get_weakest_targetable_unit(unit_arr: Array) -> DefaultUnit:
	var _weakest: DefaultUnit = null
	
	for _unit: DefaultUnit in unit_arr:
		if not _weakest or _unit.stats.curr_health < _weakest.stats.curr_health:
			if _unit.stats.curr_health > 0 and _unit.get_tile().is_targetable:
				_weakest = _unit
	
	return _weakest


## Mark a tile as hovered and unmark others
## [param board] The TacticsBoard containing the tiles
## [param tile] The tile to mark as hovered
func mark_hover_tile(board: TacticsBoard, tile: Tile) -> void:
	for _t: Tile in board.get_node("Tiles").get_children():
		_t.is_hovered = false
	
	if tile:
		tile.is_hovered = true


## Mark reachable tiles within a certain distance from a root tile
## [param board] The TacticsBoard containing the tiles
## [param root] The starting tile
## [param distance] The maximum distance to consider
func mark_reachable_tiles(board: TacticsBoard, root: Tile, distance: float) -> void:
	for _t in board.get_node("Tiles").get_children():
		var _has_dist: bool = _t.pf_distance > 0
		var _is_not_occupied: bool = not _t.is_tile_occupied()
		var _is_root: bool = _t == root
		
		# 🟢 Skip if tile is OBSTRUCTIVE
		if _t.effect and _t.effect.effect_type == TileEffectResource.EffectType.OBSTRUCTIVE:
			_t.is_reachable = false
			continue
		
		_t.is_reachable = (_has_dist and _t.pf_distance <= distance and _is_not_occupied) or _is_root


## Highlights the path from the target tile back to the root
## [param board] The TacticsBoard containing tiles
## [param target_tile] The tile under the cursor
func mark_path_preview(board: TacticsBoard, target_tile: Tile) -> void:
	# First, clear any previous preview
	for _t in board.get_node("Tiles").get_children():
		_t.is_path_preview = false

	if not target_tile:
		return

	# Only preview if this tile is reachable
	if not target_tile.is_reachable:
		return

	# Walk back through pf_root and mark the path
	var current = target_tile
	while current:
		current.is_path_preview = true
		current = current.pf_root


## Marks preview of tiles being targeted
## [param board] The TacticsBoard containing the tiles
## [param root] The starting tile
## [param distance] The maximum attack distance
func mark_target_preview_tiles(board: TacticsBoard, root: Tile, distance: float) -> void:
	for _t: Tile in board.get_node("Tiles").get_children():
		var _has_dist: bool = _t.pf_distance > 0
		var _is_reachable: bool = _t.pf_distance <= distance
		var _is_root: bool = _t == root
		
		# 🟢 Skip if tile is OBSTRUCTIVE
		if _t.effect and _t.effect.effect_type == TileEffectResource.EffectType.OBSTRUCTIVE:
			_t.is_target_preview = false
			continue
		
		_t.is_target_preview = _has_dist and _is_reachable or _is_root


## Mark targetable tiles within a certain distance from a root tile
## [param board] The TacticsBoard containing the tiles
## [param root] The starting tile
## [param distance] The maximum attack distance
func mark_targetable_tiles(board: TacticsBoard, root: Tile, distance: float) -> void:
	for _t: Tile in board.get_node("Tiles").get_children():
		var _has_dist: bool = _t.pf_distance > 0
		var _is_reachable: bool = _t.pf_distance <= distance
		var _is_root: bool = _t == root
		
		# 🟢 Skip if tile is OBSTRUCTIVE
		if _t.effect and _t.effect.effect_type == TileEffectResource.EffectType.OBSTRUCTIVE:
			_t.is_targetable = false
			continue
		
		_t.is_targetable = _has_dist and _is_reachable or _is_root


## Checks if a tile is adjacent to any enemy unit
## [param tile] The tile to check
## [param enemy_units] Array of DefaultUnit enemies
## [returns] True if adjacent
func is_adjacent_to_enemy(tile: Tile, enemy_units: Array) -> bool:
	for enemy in enemy_units:
		if not enemy.is_alive():
			continue
		var enemy_tile = enemy.get_tile()
		if enemy_tile and tile in enemy_tile.get_neighboring_tiles(enemy.stats.jump):
			return true
	return false


## Checks if a unit is on a victory tile
func is_unit_on_victory_tile(unit: DefaultUnit) -> bool:
	return unit.get_tile().effect.is_victory_tile
