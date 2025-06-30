class_name UnitCombatService
extends RefCounted
## Service class for managing combat actions of a unit

## Executes a basic attack from one pawn to another
##
## @param active_unit: the attacking DefaultUnit
## @param target_unit: the DefaultUnit being attacked
## @param delta: Time elapsed since last frame
## @return: Whether attack was completed
func basic_attack(attacking_unit: DefaultUnit, target_unit: DefaultUnit) -> bool:
	## Make the attacking unit face the target
	attacking_unit.serv.movement.look_at_direction(attacking_unit, target_unit.global_position - attacking_unit.global_position)
	
	## Check if unit can attack
	if attacking_unit.res.can_attack:
		## Apply damage to target unit
		target_unit.stats.apply_to_curr_health(-attacking_unit.stats.attack_power)
	
	# Print debug information if debug mode is enabled
	if DebugLog.debug_enabled:
		print_rich("[color=pink]Attacked ", target_unit, " for ", attacking_unit.stats.attack_power, " damage.[/color]")
		
	# Set the attacking state to false
	attacking_unit.res.set_attacking(false)
	return true
