extends Node

class_name Spell

var spell_name : String
var cast_message : String

var costs : Dictionary = {}

var effects : Dictionary = {
	"HP" : 0,
	"MP" : 0,
	"XP" : 0,
	"Buffs" : [],
	"Debuffs" : [],
	"Cure" : []
}

func _init(new_spell_name : String, cast : String, new_costs : Dictionary, new_effects : Dictionary):
	spell_name = new_spell_name
	cast_message = cast
	costs = new_costs
	effects = new_effects
	pass

func _cast(Client : Entity, Target : Entity) -> String:
	var can_cast : bool = true
	
	for i in costs.keys():
		if Client.status[i] < costs[i]:
			can_cast = false
			break
	
	if can_cast == true:
		for i in costs.keys():
			Client.status[i] -= costs[i]
		
		for i in effects.keys():
			Client.status[i] += effects[i]
	else:
		return "Can't cast yet"
	
	var msg : String = "You cast " + spell_name + " on "
	
	if Target == Client:
		msg += "yourself.\n"
	else:
		msg += Target.description["name"] + ".\n"
		cast_message = cast_message.replace(" your ", " their ").replace("Your ", "Their ").replace(" you ", " they ").replace("You ", "They ")
	
	msg += cast_message
	
	return msg
	pass
