extends Node2D

# Onready node reference for Player Token
@onready var player_token = $PlayerToken

# Board settings
const BOARD_SIZE = 10  # 10x10 grid
const CELL_SIZE = Vector2(80, 80)  # Cell dimensions
var cell_positions = {}  # Dictionary to store the positions of cells
var player_position = 1  # Player's current position on the board
var has_started = false  # Guard for starting after rolling a 6

# Snakes and Ladders mappings
var snakes_and_ladders = {
	3: 24,  # Snake: Cell 16 to 6
	37: 5,  # Snake: Cell 48 to 26
	7: 15,  # Ladder: Cell 2 to 38
	12: 31,  # Ladder: Cell 21 to 82
	22: 41,
	70: 27,
	96: 34,
	35: 84,
	57: 39,
	48: 74,
	79: 58,
	71: 92,
	80: 98,
}

# Function to create the board and calculate positions
func create_board():
	var start_x = 50  # Starting x position
	var start_y = (BOARD_SIZE - 1) * CELL_SIZE.y + 50  # Starting y position at the bottom
	var direction = 1  # Start with left-to-right direction

	var cell_number = 1  # Start from cell 1

	for row in range(BOARD_SIZE):
		for col in range(BOARD_SIZE):
			# Calculate position for each cell
			var x = start_x + col * CELL_SIZE.x
			var y = start_y - row * CELL_SIZE.y  # Move upwards for each row

			# Adjust x for right-to-left rows
			if direction == -1:
				x = start_x + (BOARD_SIZE - 1 - col) * CELL_SIZE.x

			# Store cell position in dictionary
			cell_positions[cell_number] = Vector2(x, y)

			# Increment cell number for the next cell
			cell_number += 1

		# Flip direction for the next row (Zig-Zag pattern)
		direction *= -1

# Function to roll the dice
func roll_dice():
	var dice_value = randi() % 6 + 1  # Generate a random number between 1 and 6
	print("Rolled:", dice_value)

	if not has_started:
		# Guard: Start only after rolling a 6
		if dice_value == 6:
			print("Game started! You rolled a 6!")
			has_started = true
		else:
			print("Roll a 6 to start!")
		return

	# Move the player
	move_player(dice_value)

# Function to move the player token based on the dice roll
func move_player(steps):
	# Check if exact roll is required to win
	if player_position + steps > BOARD_SIZE * BOARD_SIZE:
		print("You need exactly", BOARD_SIZE * BOARD_SIZE - player_position, "to win!")
		return

	player_position += steps

	# Check for snakes or ladders
	if player_position in snakes_and_ladders:
		print("Snake/Ladder! Moving from ", player_position, " to ", snakes_and_ladders[player_position])
		player_position = snakes_and_ladders[player_position]

	# Update the player token position
	player_token.position = cell_positions[player_position]
	print("Player position:", player_position)
	print("Player x,y:", cell_positions[player_position])

	# Check for winning condition
	if player_position == BOARD_SIZE * BOARD_SIZE:
		print("Congratulations! You won!")

# Function to handle the dice roll button press
func _on_roll_dice_button_pressed() -> void:
	roll_dice()  # Trigger the dice roll when button is pressed

func _ready():
	create_board()
