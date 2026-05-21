extends Node
class_name EventList

static var events = [
	preload("res://Events/event_go_to_tunnel.tres"),
	preload("res://Events/event_cognitohazard_discovered.tres"),
	preload("res://Events/event_sign_of_survivor.tres"),
	preload("res://Events/event_investigate_figure.tres"),
	preload("res://Events/event_locked_armoury_found.tres"),
	preload("res://Events/event_found_supplies.tres")
]
