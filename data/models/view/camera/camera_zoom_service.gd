class_name CameraZoomService
extends RefCounted
## Service class for handling camera zoom

const DELTA_SMOOTHING: int = 10
const ZOOM_SENSITIVITY: int = 5

var res: CameraResource


func _init(_res: CameraResource):
	res = _res


func zoom_camera(zoom_increment: float) -> void:
	res.target_fov = clamp(res.target_fov + zoom_increment * ZOOM_SENSITIVITY, res.min_zoom, res.max_zoom)


func apply_zoom_smoothing(camera: TacticsCamera, delta: float) -> void:
	if res.current_fov != res.target_fov:
		res.current_fov = lerp(res.current_fov, res.target_fov, (res.zoom_smoothness * DELTA_SMOOTHING) * delta)
		camera.cam_node.fov = res.current_fov
