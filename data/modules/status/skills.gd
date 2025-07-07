class_name Skills
extends Node

var skill_paths: Dictionary = {
	"ground_slam": "res://data/models/world/skills/resources/ground_slam.tres",
}

## Array of loaded Skill resources
var skills: Array[SkillResource] = []

## Loads skills by name using the dictionary
## @param skill_names: Array[String] of skill names
func import_skills(skill_names: Array[String]) -> void:
	skills.clear()
	for skill_name in skill_names:
		if not skill_paths.has(skill_name):
			push_error("[Skills] No path defined for skill: %s" % skill_name)
			continue
		var path = skill_paths[skill_name]
		var skill_res = load(path)
		if skill_res and skill_res is SkillResource:
			skills.append(skill_res)
			print("[Skills] Loaded skill:", skill_res.name)
		else:
			push_error("[Skills] Failed to load skill resource at: %s" % path)

## Returns all skills
func get_all_skills() -> Array[SkillResource]:
	return skills
