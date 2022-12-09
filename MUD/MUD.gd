extends Node

class_name MUD

var client_scene = preload("res://Client/Client.tscn")

var IP : String
const PORT : int = 4000
var server : TCP_Server = TCP_Server.new()

var clients : Array = []

var logins : Dictionary = {} # name : {password : "", stats : {}}
var active_profiles : PoolStringArray = []

func _ready() -> void:
	server.listen(PORT)
	pass

func _process(delta) -> void:
	if server.is_connection_available():
		var new_client = Client.new(server.take_connection(), 3, 5, 0, 1, [], {})
		clients.append(new_client)
		$Room.add_child(new_client)
	
	for client in clients:
		if is_instance_valid(client):
			if !client._get_data():
				if client.description["name"] in active_profiles:
					active_profiles.remove(active_profiles.find(client.description["name"]))
					client.queue_free()
					clients.erase(client)
	pass

func _add_active_profile(Name : String) -> void:
	active_profiles.append(Name)
	pass

func _add_new_profile(Name : String, Pass : String) -> void:
	logins[Name] = {"Password" : Pass}
	pass

func _verify_password(Name : String, Pass : String) -> bool:
	if logins.keys().has(Name):
		if logins[Name]["Password"] == Pass:
			return true
	
	return false
	pass

func _is_name_available(Name : String) -> bool:
	if !Name in logins.keys():
		return true
	
	return false
	pass
