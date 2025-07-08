class_name LevelService
extends RefCounted
## Service class for Level

var res: LevelResource

## Initialize the service with a LevelResource
## [param _res] The LevelResource to use
func _init(_res: LevelResource) -> void:
	res = _res

## Set up the level by connecting signals
## [param level] The Level to set up
func setup(level: Level) -> void:
	if not res:
		push_error("Needs a BoardResource from /data/models/world/level/level_res")
	else:
		res.connect("called_reset_all_tile_markers", level.increment_victory_points)
