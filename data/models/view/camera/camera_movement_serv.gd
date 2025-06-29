class_name CameraMovementService
extends RefCounted
## Service class for handling camera movement in tactical view

const DELTA_SMOOTHING: int = 8
const VELOCITY_SMOOTHING: int = 8
const MIN_THRESHOLD: float = 0.1

var res: CameraResource
var controls: ControlsResource


func _init(_res: CameraResource, _controls: ControlsResource):
	res = _res
	controls = _controls


## Move the camera based on input and apply boundary constraints
func move_camera(h: float, v: float, delta: float, camera: TacticsCamera) -> void:
	if h == 0 and v == 0:
		return
	
	# Calculate local direction relative to camera
	var angle: float = (atan2(-h, v)) + camera.t_pivot.get_rotation().y
	var dir: Vector3 = Vector3.FORWARD.rotated(Vector3.UP, angle)
	var local_velocity = res.move_speed * dir
	camera.velocity = local_velocity.lerp((local_velocity * VELOCITY_SMOOTHING), (res.smoothing * DELTA_SMOOTHING) * delta)
	
	if camera.velocity.length() > MIN_THRESHOLD:
		var new_position: Vector3 = camera.global_position + camera.velocity * delta
		var distance_from_center: Vector3 = new_position - res.boundary_center
		
		if distance_from_center.length() > res.boundary_radius:
			var clamped_position: Vector3 = res.boundary_center + distance_from_center.normalized() * res.boundary_radius
			camera.global_position = clamped_position
			camera.velocity = Vector3.ZERO
		else:
			camera.move_and_slide()

## TODO: Move the camera to focus on a target

## TODO: Camera velocity stabilization function
