extends Node

export var description : String = "An empty room..."
export var exits : Dictionary = {}
export var items : PoolStringArray = []
export var objects : Dictionary = {} # name description

func _reparent(child : Node, new_parent : Node) -> void:
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)
	
	if "peer" in child:
		new_parent._send_description(child)
	pass

func _send_description(client : Node) -> void:
	client.peer.put_string(description + "\n\n")
	pass

func _remove_item(item : String) -> void:
	items.remove(items.find(item))
	pass
