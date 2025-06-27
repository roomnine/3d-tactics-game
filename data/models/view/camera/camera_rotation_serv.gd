class_name CameraRotationService
extends RefCounted
## Service class for handling camera rotation

const DELTA_SMOOTHING: int = 10
const MAX_VERT_ROT: int = 20
const MIN_VERT_ROT: int = -45
const FREE_LOOK_ROT_FACTOR: int = 2


var res: CameraResource
var controls: ControlsResource


func _init(_res: CameraResource, _controls: ControlsResource):
	res = _res
	controls = _controls


## Rotates the camera to the target rotation
func rotate_camera(delta: float, t_pivot: Node3D, p_pivot: Node3D) -> void:
	var curr_quat_t: Quaternion = Quaternion.from_euler(t_pivot.rotation)
	var curr_quat_p: Quaternion = Quaternion.from_euler(p_pivot.rotation)
	var destination_t: Vector3 = Vector3(deg_to_rad(res.x_rot), deg_to_rad(res.y_rot), 0)
	var destination_p: Vector3 = Vector3(0, 0, res.z_rot)
	var target_quat_t: Quaternion = Quaternion.from_euler(destination_t)
	var target_quat_p: Quaternion = Quaternion.from_euler(destination_p)
	
	var new_quat_t: Quaternion = curr_quat_t.slerp(target_quat_t, (res.rot_speed * DELTA_SMOOTHING) * delta)
	var new_quat_p: Quaternion = curr_quat_p.slerp(target_quat_p, (res.rot_speed * DELTA_SMOOTHING) * delta)
	
	t_pivot.rotation = new_quat_t.get_euler()
	p_pivot.rotation = new_quat_p.get_euler()
	
	if is_equal_approx(t_pivot.rotation.y, deg_to_rad(res.y_rot)):
		res.is_rotating = false


## Free look camera rotation
func free_look(delta: float, t_pivot: Node3D, p_pivot: Node3D) -> void:
	controls.set_cursor_shape_to_move()
	
	var input: Vector2 = get_free_look_input()
	apply_free_look_rotation(input, delta, t_pivot, p_pivot)


## Gets mouse input for free look
func get_free_look_input() -> Vector2:
	return Vector2(res.twist_input, res.pitch_input)


## Applies free look rotation to the camera pivots
## Twist pivot: horizontal camera movement
## Pitch pivot: vertical camera movement
func apply_free_look_rotation(input: Vector2, delta: float, t_pivot: Node3D, p_pivot: Node3D) -> void:
	t_pivot.rotate_y((input.x * FREE_LOOK_ROT_FACTOR) * delta)
	p_pivot.rotate_x((input.y * FREE_LOOK_ROT_FACTOR) * delta)
	p_pivot.rotation.x = clamp(p_pivot.rotation.x, deg_to_rad(MIN_VERT_ROT), deg_to_rad(MAX_VERT_ROT))


## Checks and handles free look activation
func check_free_look_activation(delta: float, camera: TacticsCamera) -> void:
	if not InputCaptureResource.free_look_pressed and res.in_free_look:
		deactivate_free_look(camera)


## Deactivates free look mode
func deactivate_free_look(camera: TacticsCamera) -> void:
	res.in_free_look = false
	controls.set_cursor_shape_to_arrow()
	#snap_to_nearest_quadrant(camera)


## Snaps the camera to the nearest quadrant when free look is deactivated
func snap_to_nearest_quadrant(camera: TacticsCamera) -> void:
	res.is_snapping_to_quad = true
	var nearest_quadrant: Vector3 = calculate_nearest_quadrant(camera)
	
	var current_rotation: Vector3 = camera.t_pivot.rotation_degrees
	var target_rotation: Vector3 = nearest_quadrant
	
	var rotation_difference: float = target_rotation.y - current_rotation.y
	if abs(rotation_difference) > 180:
		if rotation_difference > 0:
			target_rotation.y -= 360
		else:
			target_rotation.y += 360
	
	var tween: Tween = camera.create_tween()
	tween.tween_property(camera.t_pivot, "rotation_degrees", target_rotation, res.quad_snap_duration).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(camera.p_pivot, "rotation_degrees:x", res.z_rot, res.quad_snap_duration).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(
		func() -> void:
		# Ensure final rotation is within 0-360 range
		camera.t_pivot.rotation_degrees.y = fmod(camera.t_pivot.rotation_degrees.y, 360)
		if camera.t_pivot.rotation_degrees.y < 0:
			camera.t_pivot.rotation_degrees.y += 360
		res.is_snapping_to_quad = false
	)

	# Update the target rotation values
	res.y_rot = int(fmod(target_rotation.y, 360))
	if res.y_rot < 0:
		res.y_rot += 360

## Calculates the nearest quadrant for camera snapping
func calculate_nearest_quadrant(camera: TacticsCamera) -> Vector3:
	var current_rotation: float = camera.t_pivot.rotation_degrees.y
	var quadrants: Array = [45, 135, 225, 315]
	
	# Normalize the current rotation to be between 0 and 360
	current_rotation = fmod(current_rotation, 360)
	if current_rotation < 0:
		current_rotation += 360
	
	var nearest_quadrant: int = 0
	var smallest_difference: int = 360
	
	for quadrant: int in quadrants:
		var difference: float = abs(current_rotation - quadrant)
		difference = min(difference, 360 - difference)  # Consider the smaller angle
		if difference < smallest_difference:
			smallest_difference = round(difference)
			nearest_quadrant = round(quadrant)
	
	return Vector3(res.x_rot, nearest_quadrant, 0)
