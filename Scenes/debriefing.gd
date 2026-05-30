extends Control

func _on_button_pressed() -> void:
	print("Deploying...")
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")
