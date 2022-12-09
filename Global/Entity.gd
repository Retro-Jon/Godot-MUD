extends Node

class_name Entity

var message : String = ""

export var status : Dictionary = {
	"HP" : 3,
	"MP" : 3,
	"XP" : 0,
	"LVL" : 1,
	"Debuffs" : [],
	"Buffs" : []
}

export var modifiers : Dictionary = {
	"Bonus" : 0,
	"Knowledge" : 0,
	"Wisdom" : 0,
	"Intelligence" : 0,
	"Will" : 0,
	"Rage" : 0
}

export var inventory : Dictionary = {}
export var spells : Array = []

export var description : Dictionary = {
	"name" : "",
	"class" : "",
	"background" : "",
	"appearance" : ""
}

func _move(dir : String) -> bool:
	var room = get_parent()
	var root = get_tree().current_scene.get_child(0)
	var found : bool = false
	
	for d in room.exits.keys():
		if str(d).begins_with(dir.to_lower()):
			room._reparent(self, root.get_node(room.exits[d]))
			found = true
			return true
	
	return false
	pass

func _cast(spell : String) -> bool:
	var i : PoolStringArray = spell.split(" ", false, 1)
	
	if i.size() > 1:
		var target : Node = self
		var target_found : bool = false
		
		var target_half : PoolStringArray = i[1].split(" on ", false, 1)
		
		if target_half.size() > 1:
			for c in get_parent().get_children():
				if c.description["name"].to_lower() == target_half[1].to_lower():
					target = c
					target_found = true
					break
		else:
			target_found = true
		
		if target_found:
			for si in Data.spells.keys():
				if str(si).to_lower() == i[1].to_lower() or str(si).to_lower() == target_half[0].to_lower():
					message = Data.spells[si]._cast(self, target)
					return true
		else:
			message = "Your target must be at the same location as you."
	else:
		message = "Say what spell you want to cast next time."
	
	return false
	pass

func _use(item : String) -> bool:
	var i : PoolStringArray = item.split(" ", false, 1)

	if i.size() > 1:
		for ci in Data.items.keys():
			if inventory.keys().has(ci):
				if i[1].to_lower() == ci.to_lower():
					if inventory[ci] >= 1:
						message = Data.items[ci]._use(self)
						
						if Data.items[ci].consumable == true:
							inventory[ci] -= 1
						
						if inventory[ci] <= 0:
							inventory.erase(ci)
						return true
					else:
						return false
	elif i.size() == 1:
		message = "Say what item you want to use."
	
	return false
	pass

func _take(item : String) -> bool:
	var room = get_parent()
	
	var i : PoolStringArray = item.split(" ", false, 1)
	
	if i.size() > 1:
		var index = 0
		
		for ci in room.items:
			if str(ci).to_lower() == i[1]:
				if inventory.has(ci):
					inventory[ci] += 1
				else:
					inventory[ci] = 1
				
				message = Data.items[ci]._take()
				room._remove_item(ci)
				
				return true
			
			index += 1
	
	message = "That item is not in this room."
	return false
	pass

func _look(target : String) -> bool:
	var room = get_parent()
	
	var t : PoolStringArray = target.replace("at", "").split(" ", false, 1)
	
	if t.size() == 1:
		message = room.description + "\n"
		
		if room.items.size() > 0:
			message += "\nItems:\n"
			
			for i in room.items:
				message += "\t" + str(i) + "\n"
		
		if room.objects.keys().size() > 0:
			message += "\nObjects:\n"
			
			for o in room.objects.keys():
				message += '\t' + str(o) + "\n"
		
		return true
	else:
		var found : bool = false
		
		var tc : Node
		for c in room.get_children():
			if str(c.description["name"]).to_lower() == t[1]:
				tc = c
				found = true
				break
		
		if found == false:
			for o in room.objects.keys():
				if str(o).to_lower() == t[1]:
					message = room.objects[o]
					found = true
					break
		
		return found
	
	return false
	pass
