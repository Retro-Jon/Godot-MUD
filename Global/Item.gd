extends Node

class_name Item

var use_message : String
var take_message : String
var consumable : bool = true

var effects : Dictionary = {
	"HP" : 0,
	"MP" : 0,
	"XP" : 0
}

var modifiers : Dictionary = {
	"Bonus" : 0,
	"Knowledge" : 0,
	"Wisdom" : 0,
	"Intelligence" : 0,
	"Will" : 0,
	"Rage" : 0
}

var information : Dictionary = {
	"Effects" : ""
}

func _init(new_effects : Dictionary, new_mods : Dictionary, use : String, take : String, is_consumable : bool):
	effects = new_effects
	modifiers = new_mods
	use_message = use
	take_message = take
	consumable = is_consumable
	pass

func _use(client : Node) -> String:
	for i in effects.keys():
		client.status[i] += effects[i]
	
	for i in modifiers.keys():
		pass
	
	return use_message
	pass

func _take() -> String:
	return take_message
	pass
