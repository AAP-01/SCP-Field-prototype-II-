extends Button

func _on_pressed() -> void:
	print("Leaving game...")
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
