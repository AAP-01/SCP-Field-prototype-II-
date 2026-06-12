extends Control

# All of these are from Player Stats in admin_panel.tscn
@onready var health: Label = $"Panel/TabContainer/Player/ScrollContainer/Player stats/Health"
@onready var sanity: Label = $"Panel/TabContainer/Player/ScrollContainer/Player stats/Sanity"
@onready var advancement: Label = $"Panel/TabContainer/Player/ScrollContainer/Player stats/Advancement"
@onready var ammunition: Label = $"Panel/TabContainer/Player/ScrollContainer/Player stats/Ammunition"
@onready var morale: Label = $"Panel/TabContainer/Player/ScrollContainer/Player stats/Morale"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Open admin panel"):
		if visible == true:
			visible = false
			print("Closed admin panel")
		else:
			visible = true
			print("Opened admin panel")

func _on_player_manager_change_ui() -> void:
	health.text = "Health: " + str(SingletonPlayerStats.health)
	sanity.text = "Sanity: " + str(SingletonPlayerStats.sanity)
	advancement.text = "Advancement: " + str(SingletonPlayerStats.advancement)
	ammunition.text = "Ammunition: " + str(SingletonPlayerStats.ammunition)
	morale.text = "Morale: " + str(SingletonPlayerStats.morale)
