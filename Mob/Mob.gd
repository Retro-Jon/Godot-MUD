extends Entity

class_name Enemy

export var hostile : bool = false

var timer = Timer.new()

func _ready() -> void:
	timer.connect("timeout", self, "_action")
	timer.wait_time = 3
	timer.autostart = true
	add_child(timer)
	pass

func _action() -> void:
	if hostile == false:
		var decision = int(round(rand_range(0, 1)))
		
		if decision > 0:
			if decision == 1:
				var dir : int = int(round(rand_range(0, 3)))
				
				_move(["North", "South", "East", "West"][dir])
			elif decision == 2:
				var spell : int = int(round(rand_range(0, spells.size() - 1)))
				var target_other : bool = false
				var target_name : String = ""
				
				if Data.spells[spells[spell]].effects["HP"] < 0:
					if get_parent().get_child_count() > 1 and int(round(rand_range(0, 1))) == 1:
						target_other = true
				
				if target_other:
					while target_name == description["name"]:
						target_name = get_parent().get_child(rand_range(0, get_parent().get_child_count() - 1)).description["name"]
					
					_cast("cast " + spells[spell] + " on " + target_name)
				else:
					_cast("cast " + spells[spell])
	pass
