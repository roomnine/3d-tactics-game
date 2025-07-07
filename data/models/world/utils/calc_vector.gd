class_name CalcVector
extends Node
## Utility methods for Vector-based calculations


## Removes the Y value for a Vector3
static func remove_y(vector: Vector3) -> Vector3:
	return vector * Vector3(1,0,1)


## Calculates a Vector3 distance, removing the Y value from the result
static func distance_without_y(b: Vector3, a: Vector3) -> float:
	return remove_y(b).distance_to(remove_y(a))
