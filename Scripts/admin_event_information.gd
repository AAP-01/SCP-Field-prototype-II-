extends VBoxContainer

@onready var resource_name: Label = $"Resource name"
@onready var resource_type: Label = $"Resource type"
@onready var sanity_modifier: Label = $"Sanity Modifier"

@onready var event_manager: EventManager = $"../../../../../../Managers/Event Manager"

func _ready() -> void:
	event_manager.event_selected.connect(_on_admin_panel_event_selected)
	
func _on_admin_panel_event_selected(event : Resource) -> void:
	resource_name.text = "Resource name: " + event.resource_path.get_file()
	
	if event is MultipleChoiceEventData:
		if SingletonPlayerStats.sanity >= 30:
			sanity_modifier.text = "Sanity modifier: normal"
		else:
			sanity_modifier.text = "Sanity modifier: low"
	elif event is OneChoiceEventData:
		sanity_modifier.text = "Sanity modifier: null"
		
	if event is MultipleChoiceEventData:
		resource_type.text = "Resource type: MultipleChoiceEventData"
	elif event is OneChoiceEventData:
		resource_type.text = "Resource type: OneChoiceEventData"
