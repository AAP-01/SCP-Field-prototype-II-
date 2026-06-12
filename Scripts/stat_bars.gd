extends VBoxContainer

@onready var health_amount: Label = $"Health/Health Amount"
@onready var sanity_amount: Label = $"Sanity/Sanity Amount"
@onready var ammunition_amount: Label = $"Ammunition/Ammunition Amount"
@onready var morale_amount: Label = $"Morale/Morale Amount"
@onready var admin_panel: Control = $"../Admin Panel"

func _ready() -> void:
	_on_player_manager_change_ui()

func _on_player_manager_change_ui() -> void:
	health_amount.text = str(SingletonPlayerStats.health) + "/" + str(SingletonPlayerStats.health_cap)
	sanity_amount.text = str(SingletonPlayerStats.sanity) + "/" + str(SingletonPlayerStats.sanity_cap)
	ammunition_amount.text = str(SingletonPlayerStats.ammunition) + "/" + str(SingletonPlayerStats.ammunition_cap)
	morale_amount.text = str(SingletonPlayerStats.morale) + "/" + str(SingletonPlayerStats.morale_cap)
