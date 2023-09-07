extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	($Music as AudioStreamPlayer2D).play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	($ScoreTimer as Timer).stop()
	($MobTimer as Timer).stop()
	($HUD as CanvasLayer).show_game_over()
	
	($DeathSound as AudioStreamPlayer2D).play()

func new_game():
	score = 0
	($Player as Area2D).start(($StartPosition as Marker2D).position)
	($StartTimer as Timer).start()

	($HUD as CanvasLayer).update_score(score)
	($HUD as CanvasLayer).show_message("Get Ready")
	
	get_tree().call_group("Mobs", "queue_free")


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene
	var mob := mob_scene.instantiate()
	
	# Choose a random location on Path2D
	var mob_spawn_location := get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2 # Not type-safe
	
	# Set the mob's position to a random location
	mob.position = mob_spawn_location.position
	
	# Add some randomness to the direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob
	var velocity := Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn the mob by adding it to the Main scene
	add_child(mob)


func _on_score_timer_timeout():
	score += 1
	($HUD as CanvasLayer).update_score(score)

func _on_start_timer_timeout():
	($MobTimer as Timer).start()
	($ScoreTimer as Timer).start()
