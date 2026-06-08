extends Node
class_name EventManager

@onready var event_text: Label = $"../../Event/Event Text"
var event : Resource
var choice_buttons : Array[Button]

signal choice_selected(outcome : Resource)

# Set up the first event upon starting
func _ready() -> void:
	choice_buttons.append($"../../Event/VBoxContainer/Choice 1")	# 0
	choice_buttons.append($"../../Event/VBoxContainer/Choice 2")	# 1
	choice_buttons.append($"../../Event/VBoxContainer/Choice 3")	# 2
	choice_buttons.append($"../../Event/VBoxContainer/Choice 4")	# 3
	
	select_event()
	
func select_event() -> void:
	event = EventList.events[randi_range(0, EventList.events.size() - 1)]
	
	# Set the set of choices for the event depending on sanity
	if event is MultipleChoiceEventData:
		if PlayerManager.sanity >= 30:
			event.chosen_choices = event.choices
		else:
			event.chosen_choices = event.low_sanity_choices
			
	display_event()
	
func display_event() -> void:
	# Reset visibility
	for button in choice_buttons:
		button.show()
		
	print("Event selected: " + event.resource_path.get_file())
	
	# Show event text
	if PlayerManager.sanity >= 30:
		event_text.text = event.event_text
		print("Normal sanity modifier")
	else:
		event_text.text = event.low_sanity_event_text
		print("Low sanity modifier")
		
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
		
func _on_choice_1_pressed() -> void:
	run_success_rate(0)
	
func _on_choice_2_pressed() -> void:
	run_success_rate(1)

func _on_choice_3_pressed() -> void:
	run_success_rate(2)

func _on_choice_4_pressed() -> void:
	run_success_rate(3)

func run_success_rate(index : int) -> void:
	if event is MultipleChoiceEventData:
		print("Selected: " + event.chosen_choices[index].choice_text)
		
		# Choices with 100% success immediately emit the signal
		if event.chosen_choices[index].success_rate == 100:
			choice_selected.emit(event.chosen_choices[index].outcomes[0])
			return	# End prematurely since everything below would be useless
			
		# Skip calculating success rate if the choice is random
		if event.chosen_choices[index].random:
			print("This is a random event")
			print("Success rate: " + str(event.chosen_choices[index].success_rate))
			
			var roll = randi_range(0, 100)
			if roll <= event.chosen_choices[index].success_rate:
				print("Outcome: " + event.chosen_choices[index].outcomes[0].outcome_text)
				choice_selected.emit(event.chosen_choices[index].outcomes[0])
				return
			else:
				# Failure. Outcome 1 is always the failed outcome
				print("Outcome: " + event.chosen_choices[index].outcomes[1].outcome_text)
				choice_selected.emit(event.chosen_choices[index].outcomes[1])
				return
				
		# Calculating missing ammunition penalty on the success rate
		# Actual ammunition change is in Player Manager in check_ammo()
		var remaining_ammunition = PlayerManager.ammunition + event.chosen_choices[index].ammunition_change
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
				
		# Calculating the success rate
		var success_rate = event.choices[index].success_rate - event.difficulty
		var player_stats = ((PlayerManager.health * 50) + (PlayerManager.sanity * 15) + (PlayerManager.morale * 35)) / 100
		success_rate = (success_rate + player_stats) / 2.00
		var final_success_rate = success_rate * missing_ammunition_penalty
		final_success_rate = clamp(final_success_rate, 0, 100)
		
		# For console
		print("	Missing ammunition penalty: " + str(missing_ammunition_penalty))
		print("	Initial success rate: " + str(event.choices[index].success_rate))
		print("	After subtracting with difficulty: " + str(success_rate))
		print("	Player stat average: " + str(player_stats))
		print("	Final success rate: " + str(final_success_rate))
		print("-----")
		
		# Roll
		var roll = randi_range(0, 100)
		if roll <= final_success_rate:
			# Success. Outcome 0 is always the succesful outcome
			print("Outcome: " + event.choices[index].outcomes[0].outcome_text)
			choice_selected.emit(event.choices[index].outcomes[0])
		else:
			# Failure. Outcome 1 is always the failed outcome
			print("Outcome: " + event.choices[index].outcomes[1].outcome_text)
			choice_selected.emit(event.choices[index].outcomes[1])
	elif event is OneChoiceEventData:
		print("Outcome: " + event.choice.outcome_text)
		choice_selected.emit(event.choice)
		
# This runs when PlayerManager to indicate the stats have been changed and can rerun an event
func _on_player_manager_stats_changed() -> void:
	select_event()
