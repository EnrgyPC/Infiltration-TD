extends PathFollow2D

var dead = false
var speed : float
var hitpoints : float
var max_hitpoints : float
var value

signal hurt


func _ready():
	yield(get_tree(), "idle_frame")
	get_node("HealthBar").set_max_health(max_hitpoints)
	connect("hurt", get_node("HealthBar"), "_on_creep_hurt")
	hitpoints = max_hitpoints


func _physics_process(delta):
	creep_move(delta)
	check_unit_offset()


func creep_move(delta):
	offset += speed * delta


func check_unit_offset():
	if unit_offset >= 1:
		if not dead:
			dead = true
			get_tree().call_group("Game", "lose_live")
			get_parent().creep_dead()
			queue_free()


func check_hitpoints():
	if hitpoints <= 0:
		dead = true
		get_parent().creep_dead()
		get_tree().call_group("Game", "add_cash", value)
		queue_free()


func _on_Area2D_area_entered(area: Area2D):
	if area.is_in_group("TurretProjectile"):
		hitpoints -= area.damage
		emit_signal("hurt", hitpoints)
		check_hitpoints()
	
	elif area.is_in_group("BomberProjectile"):
		hitpoints -= area.damage
		area.explode(get_global_transform().origin)
		emit_signal("hurt", hitpoints)
		check_hitpoints()
