class_name PlayerCompany extends Node
## This class defines the player's company.

enum Difficulty {EASY, NORMAL, HARD, VERY_HARD}

@export var new_company: bool = false ## If true, sets initial values to game variables based on difficulty

# values provied by the player
@export var company_name: String = "" ## The company's Name
@export var player_first_name: String = "" ## The company founder's first name
@export var player_last_name: String = "" ## The company founder's last name
@export var difficulty: Difficulty = Difficulty.EASY ## The game's difficulty

# values generated on new game
@export var popularity: float = 1.0 ## The company's reputation in the form 5.0%. Shouldn't exceed 100.0%
@export var starting_date_time: Dictionary = {day = 1, month = 1, year = 1970} ## The game's starting day, month and year. Each value must be >= 1. NOTE: Probably wants to be set by some new game setting.
@export var days_elapsed: float = 0 ## The total days elapsed. D0/M0/Y0000 == 0 days.
@export var monthly_rent: float = 450 ## Monthly rent of $450.

# values generated on new game and affected by difficulty
@export var profit: float ## The company's cash in the form $10
@export var sale_multiplier: float
@export var cpu_score_multiplier: float
@export var research_cost_multiplier: float
@export var competitor_sale_multiplier: float
@export var tax_rate: float
@export var yearly_loan_increase: int
@export var high_score_multiplier: float

func _ready():
	# Set initial values for game variables
	if (new_company):
		match difficulty: # NOTE: Should this be read from a file?
			Difficulty.EASY:
				profit = 200000
				sale_multiplier = 1.0
				cpu_score_multiplier = 1.05
				research_cost_multiplier = 1.0
				competitor_sale_multiplier = 0.94
				tax_rate = 0.25
				yearly_loan_increase = 400000
				high_score_multiplier = 0.38
				
			Difficulty.NORMAL:
				profit = 100000
				sale_multiplier = 0.8
				cpu_score_multiplier = 1.0
				research_cost_multiplier = 1.0
				competitor_sale_multiplier = 1.0
				tax_rate = 0.30
				yearly_loan_increase = 160000
				high_score_multiplier = 1.0
				
			Difficulty.HARD:
				profit = 50000
				sale_multiplier = 0.735
				cpu_score_multiplier = 0.95
				research_cost_multiplier = 1.2
				competitor_sale_multiplier = 1.06
				tax_rate = 0.32
				yearly_loan_increase = 150000
				high_score_multiplier = 1.62
				
			Difficulty.VERY_HARD:
				profit = 10000
				sale_multiplier = 0.696
				cpu_score_multiplier = 0.9
				research_cost_multiplier = 1.3
				competitor_sale_multiplier = 1.1
				tax_rate = 0.34
				yearly_loan_increase = 135000
				high_score_multiplier = 2.33
				
		new_company = false # Set new_company to false after initialization
	print("PlayerCompany initialized")
