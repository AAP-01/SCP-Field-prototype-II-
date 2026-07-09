extends VBoxContainer

@onready var resource_name: Label = $"Resource name"
@onready var resource_type: Label = $"Resource type"
@onready var sanity_modifier: Label = $"Sanity Modifier"
@onready var choice_selected: Label = $"Choice Selected"
@onready var success: Label = $Success

@onready var event_manager: EventManager = $"../../../../../../Managers/Event Manager"

func _ready() -> void:
	event_manager.event_selected.connect(update_event_properties)
	event_manager.choice_selected_admin.connect(update_event_properties)
	
	event_manager.choice_selected_admin.connect(update_choice_properies)
	
	event_manager.reset_info_admin.connect(reset_info)
	
	# For resource_name
	resource_name.text = "Resource name: " + SingletonEvent.event.resource_path.get_file()
	
	# For resource_name
	if SingletonEvent.event is MultipleChoiceEventData:
		resource_type.text = "Resource type: MultipleChoiceEventData"
	elif SingletonEvent.event is OneChoiceEventData:
		resource_type.text = "Resource type: OneChoiceEventData"
	elif SingletonEvent.event is NarrativeEventData:
		resource_type.text = "Resource type: NarrativeEventData"
		
	# For sanity_modifer
	if SingletonEvent.event is MultipleChoiceEventData:
		if SingletonPlayerStats.sanity >= 30:
			sanity_modifier.text = "Sanity modifier: normal"
		else:
			sanity_modifier.text = "Sanity modifier: low"
	elif SingletonEvent.event is OneChoiceEventData or SingletonEvent.event is NarrativeEventData:
		sanity_modifier.text = "Sanity modifier: N/A"
		
	# For choice_selected
	choice_selected.text = "Choice selected: N/A"
	
	# For success
	success.text = "Success: N/A"
	
# Runs when event_selected or choice_selected_admin from Event Manager emits
func update_event_properties() -> void:
	resource_name.text = "Resource name: " + SingletonEvent.event.resource_path.get_file()
	
	# For sanity_modifier
	if SingletonEvent.event is MultipleChoiceEventData:
		if SingletonPlayerStats.sanity >= SingletonPlayerStats.low_sanity_threshold:
			sanity_modifier.text = "Sanity modifier: normal"
		else:
			sanity_modifier.text = "Sanity modifier: low"
	elif SingletonEvent.event is OneChoiceEventData or SingletonEvent.event is NarrativeEventData:
		sanity_modifier.text = "Sanity modifier: N/A"
		
	# For resource_type
	if SingletonEvent.event is MultipleChoiceEventData:
		resource_type.text = "Resource type: MultipleChoiceEventData"
	elif SingletonEvent.event is OneChoiceEventData:
		resource_type.text = "Resource type: OneChoiceEventData"
	elif SingletonEvent.event is NarrativeEventData:
		resource_type.text = "Resource type: NarrativeEventData"
	
func update_choice_properies() -> void:
	# For choice_selected
	if SingletonEvent.choice_selected is MultipleChoiceData:
		choice_selected.text = "Choice selected: " + SingletonEvent.choice_selected.choice_text
	#elif SingletonEvent.choice_selected is OneChoiceData:
		#choice_selected.text = "Choice selected: " + SingletonEvent.choice_selected.outcome_text
	elif SingletonEvent.choice_selected is NarrativeData:
		choice_selected.text = "Choice selected: " + SingletonEvent.choice_selected.response_text
		
	# For success
	if SingletonEvent.choice_selected is MultipleChoiceData:
		if SingletonEvent.choice_selected.success_rate == 100:
			success.text = "Success: N/A"
		elif SingletonEvent.success:
			success.text = "Success: true"
		else:
			success.text = "Success: false"
	elif SingletonEvent.choice_selected is OneChoiceData or SingletonEvent.choice_selected is NarrativeData:
		success.text = "Success: N/A"

func reset_info() -> void:
	choice_selected.text = "Choice selected: TBD"
	success.text = "Success: TBD"
