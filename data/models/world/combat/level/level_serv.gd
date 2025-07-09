class_name LevelService
extends RefCounted
## Service class for Level

var res: LevelResource

## Initialize the service with a LevelResource
## [param _res] The LevelResource to use
func _init(_res: LevelResource) -> void:
	res = _res


func _is_all_dead(unit_group: Participants) -> bool:
	for unit in unit_group.get_children():
		if unit.stats.curr_health > 0: # Or however you track if a unit is alive
			return false
	return true


## Checks how many victory tiles are occupied by player vs enemy.
## Increments player victory points by 1 if player controls more tiles and vice versa.
func _check_victory_tile_ownership() -> void:
	var player_count := 0
	var enemy_count := 0
	
	for unit in res.player.get_children():
		#print("unit is on tile ", unit.get_tile(), " and its victory tile status is: ", unit.get_tile().effect.is_victory_tile)
		if res.board.is_unit_on_victory_tile(unit):
			player_count += 1
			#print("DEBUG: Player Count: ", player_count)
	
	for unit in res.enemy.get_children():
		if res.board.is_unit_on_victory_tile(unit):
			enemy_count += 1
			#print("DEBUG: Enemy Count: ", enemy_count)

	if player_count > enemy_count:
		increment_victory_points(true) # +1
	elif enemy_count > player_count:
		increment_victory_points(false) # -1


## Increments victory points for a player
func increment_victory_points(is_player: bool) -> void:
	if is_player:
		res.player_score += 1
		print_rich("[color=green]Player gains 1 VP. [/color]", "Player Score: ", res.player_score)
	else:
		res.player_score -= 1
		print_rich("[color=red]Player loses 1 VP. Player Score: [/color]", res.player_score)


## Checks whether player or enemy has 3 points or no longer has any units left and ends the game if so
func _check_level_end() -> void:
	if res.player_score >= 3:
		print_rich("[color=green]You win![/color]")
		res.turn_stage = 2
	elif res.player_score <= -3:
		print_rich("[color=red]You lose![/color]")
		res.turn_stage = 2
	elif _is_all_dead(res.player):
		res.player_score -= 1
		_check_level_end()
	elif _is_all_dead(res.enemy):
		res.player_score += 3
		_check_level_end()
