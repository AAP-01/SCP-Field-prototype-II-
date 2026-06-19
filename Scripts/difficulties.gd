extends VBoxContainer

func _on_easy_pressed() -> void:
	SingletonPlayerStats.difficulty = SingletonPlayerStats.Difficulty.EASY
	get_tree().change_scene_to_file("res://Scenes/debriefing.tscn")

func _on_normal_pressed() -> void:
	SingletonPlayerStats.difficulty = SingletonPlayerStats.Difficulty.NORMAL
	get_tree().change_scene_to_file("res://Scenes/debriefing.tscn")

func _on_hard_pressed() -> void:
	SingletonPlayerStats.difficulty = SingletonPlayerStats.Difficulty.HARD
	get_tree().change_scene_to_file("res://Scenes/debriefing.tscn")
