class_name UnitMovementService
extends RefCounted
## Service class for handling unit movement in the tactics game


## Rotates the unit to face the given direction
##
## @param unit: The unit to rotate
## @param dir: The direction vector to face
func look_at_direction(unit: DefaultUnit, dir: Vector3) -> void:
	var _fixed_dir: Vector3 = dir * (Vector3(1, 0, 0) if abs(dir.x) > abs(dir.z) else Vector3(0, 0, 1))
	var _angle: float = Vector3.FORWARD.signed_angle_to(_fixed_dir.normalized(), Vector3.UP) + PI
	var _new_rot: Vector3 = Vector3.UP * _angle
	unit.set_rotation(_new_rot)


## Moves the unit along its pathfinding stack
##
## @param unit: The unit to move
## @param delta: Time elapsed since the last frame
func move_along_path(unit: DefaultUnit, delta: float) -> void:
	if unit.res.pathfinding_tilestack.is_empty() or not unit.res.can_move:
		return
	
	start_movement(unit)
	
	if unit.res.move_direction.length() > 0.5:
		perform_movement(unit, delta)
		
		var _first_tile_in_stack: Vector3 = unit.res.pathfinding_tilestack.front()
		if unit.global_position.distance_to(_first_tile_in_stack) >= 0.15:
			return
	
	unit.res.pathfinding_tilestack.pop_front()
	reset_movement_state(unit)
	check_movement_completion(unit)


## Initiates the unit's movement
##
## @param unit: The unit to start moving
func start_movement(unit: DefaultUnit) -> void:
	unit.res.set_moving(true)
	if unit.res.move_direction == Vector3.ZERO:
		unit.res.move_direction = unit.res.pathfinding_tilestack.front() - unit.global_position


## Performs the actual movement of the unit
##
## @param unit: The unit to move
## @param delta: Time elapsed since the last frame
func perform_movement(unit: DefaultUnit, delta: float) -> void:
	look_at_direction(unit, unit.res.move_direction)
	var _p_velocity: Vector3 = calculate_velocity(unit, delta)
	var _curr_speed: float = calculate_speed(unit)
	
	unit.set_velocity(_p_velocity * _curr_speed)
	unit.set_up_direction(Vector3.UP)
	unit.move_and_slide()


## Calculates the velocity vector for the unit's movement
##
## @param unit: The unit to calculate velocity for
## @param delta: Time elapsed since the last frame
## @return: The calculated velocity vector
func calculate_velocity(unit: DefaultUnit, delta: float) -> Vector3:
	var _p_velocity: Vector3 = unit.res.move_direction.normalized()
	
	if unit.res.move_direction.y < -DefaultUnitResource.MIN_HEIGHT_TO_JUMP:
		var _first_tile_in_stack : Vector3 = unit.res.pathfinding_tilestack.front()
		if CalcVector.distance_without_y(_first_tile_in_stack, unit.global_position) <= 0.2:
			unit.res.gravity += Vector3.DOWN * delta * DefaultUnitResource.GRAVITY_STRENGTH
			_p_velocity = (unit.res.pathfinding_tilestack.front() - unit.global_position).normalized() + unit.res.gravity
		else:
			_p_velocity = CalcVector.remove_y(unit.res.move_direction).normalized()
	
	return _p_velocity


## Calculates the current speed of the unit
##
## @param unit: The unit to calculate speed for
## @return: The calculated speed
func calculate_speed(unit: DefaultUnit) -> float:
	var _curr_speed: float = unit.res.walk_speed
	
	if unit.res.move_direction.y > DefaultUnitResource.MIN_HEIGHT_TO_JUMP:
		_curr_speed = clamp(abs(unit.res.move_direction.y) * 2.3, 3, INF)
		unit.res.is_jumping = true
	
	return _curr_speed


## Resets the movement state of the unit
##
## @param unit: The unit to reset
func reset_movement_state(unit: DefaultUnit) -> void:
	unit.res.move_direction = Vector3.ZERO
	unit.res.is_jumping = false
	unit.res.gravity = Vector3.ZERO
	unit.res.can_move = unit.res.pathfinding_tilestack.size() > 0


## Checks if the unit has completed its movement and adjusts accordingly
##
## @param unit: The unit to check
func check_movement_completion(unit: DefaultUnit) -> void:
	if not unit.res.can_move:
		unit.res.set_moving(false)
		unit.character.adjust_to_center(unit)
