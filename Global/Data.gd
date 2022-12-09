extends Node

var items : Dictionary = {
	"Bonus Shard" : Item.new({"HP" : 0, "MP" : 0, "XP" : 0}, {"BONUS" : 3}, "You break the Bonus Shard.\nYou feel a sudden boost in your abilities.", "As you hold the Bonus Shard, you feel powerful energy radiating from its core\nas the sharp edges dig into your palms.", true),
	"Potion" : Item.new({"HP" : 3, "MP" : 0, "XP" : 0}, {"" : ""}, "You drink the Potion and recover 3 HP", "You hold the colorless potion vial that fits snugly in the palm of your hand.\nHopefuly you won't need it.", true)
}

var spells : Dictionary = {
	"Heal" : Spell.new("Heal", "You feel the ailments leave your body.", {"MP" : 4}, {"HP" : 2})
}

var help : Dictionary = {
	"General" : """
Movement

	north (n)                : Move north.
	south (s)                : Move south.
	east  (e)                : Move east.
	west  (w)                : Move west.

Exploring

	who                      : See who's in the same area.
	look (l)                 : Get full environment description.
	look at <object>         : Get full object description.
	look at <character>      : Get full character description.

Inventory

	inventory (i)            : See how much of each item is in your inventory.
	take                     : Add an item to your inventory.
	use                      : Use 1 item from your inventory.

Combat

	cast <spell>             : Cast a spell for a cost.
	cast <spell> on <target> : Cast a spell on a target for a cost.

Server Access

	quit (qq)                : Logout.
	"""
}

func _ready():
	pass
