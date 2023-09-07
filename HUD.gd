extends CanvasLayer

## Notifies `Main` node that the button has been pressed
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_message(text):
	($Message as Label).text = text
	($Message as Label).show()
	($MessageTimer as Timer).start()


func show_game_over():
	show_message("Game Over!")
	# Wait until the MessageTimer has counted down
	await ($MessageTimer as Timer).timeout
	
	($Message as Label).text = "Dodge the Creeps!"
	($Message as Label).show()
	# Make a one-shot timer and wait for it to finish
	await get_tree().create_timer(1.0).timeout
	($StartButton as Button).show()


func update_score(score):
	($ScoreLabel as Label).text = "%d" % score


func _on_message_timer_timeout():
	($Message as Label).hide()


func _on_start_button_pressed():
	($StartButton as Button).hide()
	start_game.emit()
