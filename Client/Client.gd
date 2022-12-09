extends Entity

class_name Client

var peer : StreamPeerTCP
var received_data : String

enum Stages {
	Login,
	Login_Name,
	Login_Password,
	Play
}

var stage : int = 0

func _init(new_peer : StreamPeerTCP, hp = 3, mp = 3, xp = 0, lvl = 1, new_spells = [], inv = {}, new_description = {"name" : "", "class" : "", "background" : "", "appearance" : ""}):
	peer = new_peer
	
	status["HP"] = hp
	status["MP"] = mp
	status["XP"] = xp
	status["LVL"] = lvl
	
	inventory = inv
	spells = new_spells
	description = new_description
	pass

onready var root = get_tree().current_scene

var login_timer = Timer.new()
var returning_player : bool = false

func _ready():
	login_timer.wait_time = 1
	login_timer.autostart = true
	add_child(login_timer)
	login_timer.connect("timeout", self, "_login_timer_timeout")
	pass

func _login_timer_timeout() -> void:
	peer.put_data("Welcome to MUD\n\nWhat would you like to do?\n\n1. Login\n2. Create New Character\n3. Quit\n\n".to_utf8())
	
	if is_instance_valid(login_timer):
		login_timer.queue_free()
	pass

func _get_data() -> bool:
	if peer.is_connected_to_host() and peer.get_status() != StreamPeerTCP.STATUS_ERROR and peer.get_status() != StreamPeerTCP.STATUS_NONE:
		var b = peer.get_partial_data(1)
		
		if b[1].size() > 0:
			for c in b[1]:
				received_data += char(c)
			
			if received_data.ends_with("\n"):
				
				# remove carriage return and line feed characters from end of 'received_data'
				#print(received_data.length())
				received_data.erase(received_data.length() - 2, 2)
				#print(received_data.length())
				
				if stage == Stages.Login:
					if received_data.begins_with("1"):
						stage += 1
						returning_player = true
						message = "Please enter your character's name..."
					elif received_data.begins_with("2"):
						stage += 1
						returning_player = false
						message = "What should your character be called?"
					elif received_data.begins_with("3"):
						peer.disconnect_from_host()
					
					received_data = ""
				
				elif stage == Stages.Login_Name:
					description["name"] = received_data
					
					if returning_player == true:
						message = "Please enter your password..."
						stage += 1
					else:
						if root._is_name_available(description["name"]):
							message = "Enter a password for your profile.\nYou are responsible for remembering your password.\nYou cannot recover or reset your password if you forget it."
							stage += 1
						else:
							message = "Name is taken."
							stage = Stages.Login
					
					received_data = ""
				
				elif stage == Stages.Login_Password:
					stage += 1
					
					if returning_player == true:
						if root._verify_password(description["name"], received_data):
							message = "Welcome Back!"
						else:
							peer.put_data("Username or Password Incorrect...\nPlease try again.\n".to_utf8())
							stage = 0
							_login_timer_timeout()
					
					elif returning_player == false:
						message = "Welcome young mage."
						root._add_new_profile(description["name"], received_data)
						root._add_active_profile(description["name"])
					
					received_data = ""
				
				elif stage == Stages.Play:
					if received_data.to_lower() == "h" or received_data.to_lower() == "help":
						message = Data.help["General"]
					
					elif received_data.to_lower() in ["n", "s", "e", "w", "north", "south", "east", "west"]:
						if !_move(received_data.to_lower()):
							message = "There is no exit in that direction."
					
					elif received_data.matchn("i") or received_data.matchn("inventory"):
						if inventory.keys().size() > 0:
							for i in inventory.keys():
								message += i + " : " + str(inventory[i])
						else:
							message = "Your inventory is empty."
					
					elif received_data.to_lower().begins_with("take"):
						_take(received_data)
					
					elif received_data.to_lower().begins_with("use"):
						if !_use(received_data) and message == "":
							message = "You don't have that item."
					
					elif received_data.to_lower().begins_with("cast"):
						if !_cast(received_data) and message == "":
							message = "You don't know that spell."
					
					elif received_data.to_upper() in status.keys():
						message = received_data.to_upper() + " : " + str(status[received_data.to_upper()])
					
					elif received_data == "status":
						for i in status.keys():
							if i != "Buffs" and i != "Debuffs":
								message += i + " : " + str(status[i]) + "\n"
						
						if status["Buffs"].size() > 0:
							message += "\nBuffs:\n\n"
							for i in status["Buffs"]:
								message += i + "\n"
						
						if status["Debuffs"].size() > 0:
							message += "\nDebuffs:\n\n"
							for i in status["Debuffs"]:
								message += i + "\n"
					
					elif received_data.to_lower() == "who":
						for i in get_parent().get_children():
							if i is Entity:
								message += i.description["name"] + "\n"
					
					elif received_data.to_lower().begins_with("look"):
						if !_look(received_data.to_lower()):
							message = "That can't be found here."
					
					elif received_data.to_lower() == "quit" or received_data.to_lower() == "qq":
						peer.disconnect_from_host()
					
					received_data = ""
				
				if !message.empty():
					peer.put_data(str(message + "\n\n").to_utf8())
					message = ""
	else:
		return false
	
	return true
	pass
