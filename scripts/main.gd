extends Node

const PORT = 8080
const MAX_PLAYERS = 32

onready var message = $ui/message
onready var world = $world

var spawn_points = []

func _ready():

	var server = NetworkedMultiplayerENet.new()
#	var server = WebSocketServer.new()

	server.set_bind_ip("::")
	server.create_server(PORT, MAX_PLAYERS)
#	server.listen(PORT,[],true)
	get_tree().set_network_peer(server)

	get_tree().connect("network_peer_connected", self, "_client_connected")
	get_tree().connect("network_peer_disconnected", self, "_client_disconnected")

	create_map()
	print("ready----_")

func _client_connected(id):
	message.text = "Client " + str(id) + " connected."
	print(message.text)
	var player = load("res://scenes/player/player.tscn").instance()
	player.set_name(str(id))
	world.get_node("players").add_child(player)
	player.global_transform.origin = spawn_points[randi() % spawn_points.size()].global_transform.origin

func _client_disconnected(id):
	message.text = "Client " + str(id) + " disconnected."
	print(message.text)
	for p in world.get_node("players").get_children():
		if int(p.name) == id:
			world.get_node("players").remove_child(p)
			p.queue_free()

func create_map():
	var map = load("res://scenes/map.tscn").instance()
	world.add_child(map)
	spawn_points = map.get_node("spawn_points").get_children()
