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


## Executes a skill
##
## @param unit: The unit using the skill
## @param skill: The skill resource to use
## @param target_unit: The unit being targeted if exists
## @param target_tile: The unit being targeted if exists
## @return: Whether the skill was successfully used
func use_skill(user: DefaultUnit, skill: SkillResource, targetable_units: Array = [], targetable_tiles: Array = []) -> bool:
	match skill.skill_type:
		SkillResource.SkillType.NO_TARGET:
			_execute_no_target_skill(user, skill, targetable_units, targetable_tiles)
			return true
		SkillResource.SkillType.TARGET_UNIT:
			_execute_target_unit_skill(user, skill, targetable_units, targetable_tiles)
			return true
		SkillResource.SkillType.TARGET_TILE:
			_execute_target_tile_skill(user, skill, targetable_units, targetable_tiles)
			return true
	return false


func _execute_no_target_skill(user: DefaultUnit, skill: SkillResource, targetable_units: Array[DefaultUnit] = [], targetable_tiles: Array[Tile] = []) -> void:
	print("%s uses %s!" % [user.name, skill.name])
	
	# Remove the user itself from the target list if needed
	if not skill.self_inflicting and user in targetable_units:
		targetable_units.erase(user)
		
	# 🟢 Apply primary effect to all targetable units
	if skill.primary_effect == skill.PrimaryEffect.DAMAGE:
		for target in targetable_units:
			if not target or not target.is_alive():
				continue
			target.stats.apply_to_curr_health(-skill.primary_effect_amount)
			print("Dealt %d damage to %s" % [skill.primary_effect_amount, target.name])
			
	
	#TODO: apply secondary effect in a radius from unit's root tile
	#match skill.secondary_effect:
		#skill.SecondaryEffect.KNOCKBACK:
			#user.serv.movement.knockback_target(user, target, skill.secondary_effect_amount)


func _execute_target_unit_skill(user: DefaultUnit, skill: SkillResource, targetable_units: Array[DefaultUnit] = [], targetable_tiles: Array[Tile] = []) -> void:
	if not targetable_units:
		push_warning("No targetable units!")
		return

	#TODO: Apply primary effect
	#match skill.primary_effect:
		#skill.PrimaryEffect.DAMAGE:
			#target.stats.apply_to_curr_health(-skill.primary_effect_amount)
		#TODO: Add HEAL or other effects later

	#TODO: Apply secondary effect
	#match skill.secondary_effect:
		#skill.SecondaryEffect.KNOCKBACK:
			#user.serv.movement.knockback_target(user, target, skill.secondary_effect_amount)
		#TODO: Add other secondary effects later


func _execute_target_tile_skill(user: DefaultUnit, skill: SkillResource, targetable_units: Array[DefaultUnit] = [], targetable_tiles: Array[Tile] = []) -> void:
	if not targetable_tiles:
		push_warning("No targetable tiles!")
		return

	#TODO: Example: damage all units within area_radius
	#for unit in get_tree().get_nodes_in_group("Units"):
		#if unit.global_position.distance_to(tile.global_position) <= skill.area_radius:
			#if skill.primary_effect == skill.PrimaryEffect.DAMAGE:
				#unit.stats.apply_to_curr_health(-skill.primary_effect_amount)
