extends Path2D

var soldier_creep = load("res://Scenes/SoldierCreep.tscn")
var instance

var creeps_spawned : int = 0
var creeps_alive : int = 0
var creeps_max : int
var creeps_per_wave = [10, 15, 20, 25, 30, 40]


func _ready():
	add_to_group("Spawner")


func start_wave():
	$WaveTimer.start()


func _on_WaveTimer_timeout():
	creeps_max = creeps_per_wave[Global.wave]
	$CreepTimer.start()
	$WaveTimer.stop()


func _on_CreepTimer_timeout():
	if creeps_spawned < creeps_max:
		creep_spawn()
	else:
		$CreepTimer.stop()


func creep_spawn():
	instance = soldier_creep.instance()
	add_child(instance)
	creeps_spawned += 1
	creeps_alive = get_tree().get_nodes_in_group("Enemy").size()


func creep_dead():
	creeps_alive -= 1
	if creeps_alive == 0:
		creeps_spawned = 0
		get_tree().call_group("Game", "advance_wave")
