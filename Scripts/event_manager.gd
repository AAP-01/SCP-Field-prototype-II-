extends Node
class_name EventManager

@onready var event_text: Label = $"../../Event/Event Text"
@onready var outcome_text: Label = $"../../Event/Outcome Text"
var event : Resource
var choice_buttons : Array[Button]
var sanity_modifier : String

signal choice_selected()	# Goes to Player Manager

# All to the admin panel
signal choice_selected_admin()
signal event_selected()
signal reset_info_admin()

# Set up the first event upon starting
func _ready() -> void:
	choice_buttons.append($"../../Event/Choice Buttons/Choice 1")	# 0
	choice_buttons.append($"../../Event/Choice Buttons/Choice 2")	# 1
	choice_buttons.append($"../../Event/Choice Buttons/Choice 3")	# 2
	choice_buttons.append($"../../Event/Choice Buttons/Choice 4")	# 3
	
	select_event()
	
func select_event() -> void:
	# Reroll if same event
	while event == SingletonEvent.event:
		print("Same event as the previous. Rerolling...")
		print("=====")
		SingletonEvent.event = SingletonEventList.events[randi_range(0, EventList.events.size() - 1)]
		
	event = SingletonEvent.event
	
	event_selected.emit()	# Goes directly to admin_event_information.gd in admin_panel.tscn
	
	# Set the set of choices and text for the event depending on sanity
	if event is MultipleChoiceEventData:
		if SingletonPlayerStats.sanity >= 30 or event.low_sanity_event_text == "":
			event.chosen_event_text = event.event_text
			event.chosen_choices = event.choices
			sanity_modifier = "Normal sanity modifier"
		else:
			event.chosen_event_text = event.low_sanity_event_text
			event.chosen_choices = event.low_sanity_choices
			sanity_modifier = "Low sanity modifier"
			
	# Set the selected choice information in the admin panel
	if event is OneChoiceEventData:
		SingletonEvent.choice_selected = event.choice
		choice_selected_admin.emit()
			
	display_event()
	
func display_event() -> void:
	# Set button 1's function back to the event's first option
	if choice_buttons[0].pressed.is_connected(_on_choice_1_alternate_pressed):
		choice_buttons[0].pressed.disconnect(_on_choice_1_alternate_pressed)
		choice_buttons[0].pressed.connect(_on_choice_1_pressed)
	
	# Reset visibility
	for button in choice_buttons:
		button.show()
		
	print("Event selected: " + event.resource_path.get_file())
	
	outcome_text.text = ""
	
	# Show event text
	if event is MultipleChoiceEventData:
		event_text.text = event.chosen_event_text
		print(sanity_modifier)
	elif event is OneChoiceEventData:
		event_text.text = event.event_text
	elif event is NarrativeEventData:
		event_text.text = event.narrative_text
		
	# Show the choices' text on the buttons
	if event is MultipleChoiceEventData:
		for i in range(event.chosen_choices.size()):	# Not a for-each loop. Goes from 0 to the choice's number of choices
			choice_buttons[i].text = event.chosen_choices[i].choice_text
		
		# Hide unused buttons
		for button in choice_buttons:
			if button.get_index() > event.chosen_choices.size() - 1:
				button.hide()
			
	elif event is OneChoiceEventData:
		choice_buttons[0].text = event.choice.outcome_text
		choice_buttons[1].hide()
		choice_buttons[2].hide()
		choice_buttons[3].hide()
	elif event is NarrativeEventData:
		for i in range(event.response_choices.size()):
			choice_buttons[i].text = event.response_choices[i].response_text
			
		for button in choice_buttons:
			if button.get_index() > event.response_choices.size() - 1:
				button.hide()
		
# _on_choice_1_pressed() has a unique function to serve event types that only have one option
func _on_choice_1_pressed() -> void:
	run_event(0)
	if event is MultipleChoiceEventData:
		show_outcome(0)
	elif event is OneChoiceEventData or event is NarrativeEventData:
		select_event()
	
func _on_choice_2_pressed() -> void:
	run_event(1)
	if event is MultipleChoiceEventData:
		show_outcome(1)
	elif event is NarrativeEventData:
		select_event()

func _on_choice_3_pressed() -> void:
	run_event(2)
	if event is MultipleChoiceEventData:
		show_outcome(2)
	elif event is NarrativeEventData:
		select_event()

func _on_choice_4_pressed() -> void:
	run_event(3)
	if event is MultipleChoiceEventData:
		show_outcome(3)
	elif event is NarrativeEventData:
		select_event()
	
func _on_choice_1_alternate_pressed() -> void:
	select_event()
	reset_info_admin.emit()	# Reset information in the admin panel for the next event

func run_event(index : int) -> void:
	if event is MultipleChoiceEventData:
		SingletonEvent.choice_selected = event.chosen_choices[index]
		
		print("Selected: " + event.chosen_choices[index].choice_text)
		
		# =================== Events with unconventional success rate ===================
		# Choices with 100% success immediately emit the signal
		if event.chosen_choices[index].success_rate == 100:
			SingletonEvent.outcome = event.chosen_choices[index].outcomes[0]
			choice_selected.emit()	# Sends to Player Manager
			
		# Skip calculating success rate if the choice is random
		elif event.chosen_choices[index].random:
			print("This is a random event")
			print("Success rate: " + str(event.chosen_choices[index].success_rate + (event.difficulty * SingletonPlayerStats.event_difficulty)))
			roll(index, event.chosen_choices[index].success_rate)
		# =================== Events with unconventional success rate ===================
		
		else:	# A typical event
			var missing_ammunition_penalty = missing_ammunition_penalty_calculation(index)	# Calculating missing ammunition penalty on the success rate
			var final_success_rate = final_success_rate_calculation(index, missing_ammunition_penalty)	# Calculating the success rate
			
			# Roll the final_success_rate
			roll(index, final_success_rate)
	elif event is OneChoiceEventData:
		SingletonEvent.outcome = event.choice
		SingletonEvent.choice_selected = event.choice
		print("Outcome: " + event.choice.outcome_text)
		choice_selected.emit()	# Sends to Player Manager
	elif event is NarrativeEventData:
		SingletonEvent.choice_selected = event.response_choices[index]
		print("Response: " + event.response_choices[index].response_text)
		print("=====")
		
	if event is MultipleChoiceEventData or event is NarrativeEventData:
		choice_selected_admin.emit()	# Send to admin_event_information.gd
		
func roll(index : int, final_success_rate : float) -> void:
	if randi_range(0, 100) <= final_success_rate:
		# Success. Outcome 0 is always the succesful outcome
		SingletonEvent.success = true
		print("Success")
		print("Outcome: " + event.chosen_choices[index].outcomes[0].outcome_text)
		SingletonEvent.outcome = event.chosen_choices[index].outcomes[0]
		choice_selected.emit()	# Sends to Player Manager
	else:
		# Failure. Outcome 1 is always the failed outcome
		SingletonEvent.success = false
		print("Fail")
		print("Outcome: " + event.chosen_choices[index].outcomes[1].outcome_text)
		SingletonEvent.outcome = event.chosen_choices[index].outcomes[1]
		choice_selected.emit()	# Sends to Player Manager
	
func missing_ammunition_penalty_calculation(index : int) -> float:
	# Calculating missing ammunition penalty on the success rate
	# Actual ammunition change is in Player Manager in check_ammo()
	var remaining_ammunition = SingletonPlayerStats.ammunition + event.chosen_choices[index].ammunition_change
	var missing_ammunition_penalty
	
	match remaining_ammunition:
		var r when r >= -5:
			missing_ammunition_penalty = 1.00
		var r when r <= -6 and r >= -10:
			missing_ammunition_penalty = 0.90
		var r when r <= -11 and r >= -15:
			missing_ammunition_penalty = 0.80
		var r when r <= -16 and r >= -20:
			missing_ammunition_penalty = 0.60
		var r when r <= -21:
			missing_ammunition_penalty = 0.00
			
	return missing_ammunition_penalty
		
func final_success_rate_calculation(index : int, missing_ammunition_penalty : float) -> float:
	# Calculating the success rate
	var success_rate = event.chosen_choices[index].success_rate + (event.difficulty * SingletonPlayerStats.event_difficulty)
	print("	Success rate minus difficulty: " + str(success_rate))
	
	var player_stats : float = ((SingletonPlayerStats.health * 50) + (SingletonPlayerStats.sanity * 15) + (SingletonPlayerStats.morale * 35)) / 100.00
	print("	Player stats average: " + str(player_stats))
	
	success_rate = (success_rate + player_stats) / 2.00
	print("	Success rate plus player stats average: " + str(success_rate))
	
	var final_success_rate = success_rate * missing_ammunition_penalty
	final_success_rate = clamp(final_success_rate, 0, 100)
	print("	Final success rate: " + str(final_success_rate))
	print("-----")
	
	return final_success_rate
	
func show_outcome(index : int) -> void:
	if event is MultipleChoiceEventData:
		if event.chosen_choices[index].success_rate == 100:
			outcome_text.text = event.chosen_choices[index].outcomes[0].outcome_text
		else:
			if SingletonEvent.success:
				outcome_text.text = event.chosen_choices[index].outcomes[0].outcome_text
			elif !SingletonEvent.success:
				outcome_text.text = event.chosen_choices[index].outcomes[1].outcome_text
	elif event is OneChoiceEventData:
		pass
		
	choice_buttons[0].text = "..."
	choice_buttons[1].hide()
	choice_buttons[2].hide()
	choice_buttons[3].hide()
	
	choice_buttons[0].pressed.disconnect(_on_choice_1_pressed)
	choice_buttons[0].pressed.connect(_on_choice_1_alternate_pressed)
