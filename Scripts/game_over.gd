extends Control
class_name GameOver

@onready var restart: Button = $Restart
@onready var game_over_text: Label = $"Game Over Text"

func _ready() -> void:
	if PlayerManager.health == 0:
		game_over_text.text = "You died"
	elif PlayerManager.advancement >= 20:
		game_over_text.text = "Mission success"
		
func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")
	
func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
