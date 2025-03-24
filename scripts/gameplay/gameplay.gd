class_name Gameplay extends MarginContainer ## TODO: This script is getting long. Should probably be split into different scripts. Gameplay and Gameplay_UI?

const tick = 0.5 ## How long per day in seconds at game_speed 1

var timer: Timer = Timer.new() # BUG: Initial delay after first game_speed change.

var date_time: Classes.DateTime = Classes.DateTime.new()

var finances: Classes.Finances = Classes.Finances.new()

var product: Classes.Product

enum GameSpeed {PAUSED, NORMAL, FAST, FASTER}

var game_speed_previous: GameSpeed
var game_speed: GameSpeed:
	set(value):
		if (game_speed != null):
			game_speed_previous = game_speed
		match value:
			GameSpeed.PAUSED:
				timer.paused = true
			GameSpeed.NORMAL:
				timer.set_wait_time(tick / 1)
				timer.paused = false
			GameSpeed.FAST:
				timer.set_wait_time(tick / 2.5)
				timer.paused = false
			GameSpeed.FASTER:
				timer.set_wait_time(tick / 5)
				timer.paused = false

enum Screen {OFFICE, PAUSE_MENU, DROP_DOWN ,NEW_HARDWARE, RESEARCH, MARKET, BANK}

var active_screen: Screen:
	set(value):
		active_screen = value
		match value:
			Screen.OFFICE:
				%PauseMenuMarginContainer.visible = false
				%DropdownMarginContainer.visible = false
			Screen.PAUSE_MENU:
				%PauseMenuMarginContainer.visible = true
				%DropdownMarginContainer.visible = false
			Screen.DROP_DOWN:
				%PauseMenuMarginContainer.visible = false
				%DropdownMarginContainer.position = get_viewport().get_mouse_position()
				%DropdownMarginContainer.show_dropdown()
			Screen.NEW_HARDWARE: # TODO: Define Screen.NEW_HARDWARE
				pass
			Screen.RESEARCH: # TODO: Define Screen.RESEARCH
				pass
			Screen.MARKET: # TODO: Define Screen.MARKET
				pass
			Screen.BANK: # TODO: Define Screen.BANK
				pass

func _ready():
	date_time.count = date_time.dict_to_day_count(Global.player_company.starting_date_time)
	print(date_time.count)
	
	date_time.changed.connect(_on_date_time_changed)
	date_time.day_incremented.connect(_on_day_incremented)
	date_time.month_incremented.connect(_on_month_incremented)
	date_time.year_incremented.connect(_on_year_incremented)
	
	game_speed = GameSpeed.PAUSED
	
	active_screen = Screen.OFFICE
	
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
	
	product = Classes.Product.new(date_time)
	finances.expenses += product.design_cost # TODO: design_cost is logged in the finance screen as a total at the start of design, but is taken from balance monthly. design_cost_per_month = product.design_cost / (product.design_time / date_time.days_in_month)

func _process(_delta):
	%DateRichTextLabel.text = "%s" % [date_time.count_to_string()]
	%ProfitRichTextLabel.text = "$%sk" % snapped((Global.player_company.profit/1000.1),0.01)

func _on_date_time_changed(value):
	Global.player_company.days_elapsed = value

func _on_day_incremented(_day):
	var weeks_since_sale: int = floor((date_time.count / 7) - (product.product_release_day / 7) + 1) # Add 1 to account for the Fencepost problem.
	var profit_per_sale: float = product.retail_price - product.production_cost
	var number_of_sales: int = 2 ## Number of sales per day. TODO: Calculate the number of sales per day. Based off popularity and hype?
	
	if (date_time.count == product.product_release_day):
		product._on_product_release_day(date_time)
	
	if (date_time.count >= product.product_release_day):
		if (weeks_since_sale > product.weeks_on_sale): # INFO: The profit from the sales of a product show up in the finances log screen grouped by weeks, whereas the profit is added to the players account daily.
			product.weeks_on_sale = weeks_since_sale
			product._on_weeks_since_product_release(date_time)
		
		if (profit_per_sale > 0): # Update finances with sale profits.
			product.weekly_sales += number_of_sales
			finances.income += profit_per_sale * number_of_sales 
		elif (profit_per_sale < 0):
			product.weekly_sales += number_of_sales
			finances.expenses += profit_per_sale * number_of_sales

func _on_month_incremented(_month):
	finances.expenses += Global.player_company.monthly_rent # Charge rent each month. Value set by PlayerCompany.

func _on_year_incremented(_year):
	if (finances.annual_profit >= 1000):
		var tax_rate = Global.player_company.tax_rate # The yearly tax rate. Value set by PlayerCompany.
		var tax = finances.annual_profit * tax_rate
		finances.expenses += tax
		finances.annual_profit = 0 # Reset annual_profit each year.
		finances.annual_expenses = 0 # Reset annual_expenses each year.

func _on_timer_timeout():
	date_time.increment()

func _on_speed_0_texture_button_toggled(toggled_on):
	if (toggled_on):
		game_speed = GameSpeed.PAUSED

func _on_speed_1_texture_button_toggled(toggled_on):
	if (toggled_on):
		game_speed = GameSpeed.NORMAL

func _on_speed_2_texture_button_toggled(toggled_on):
	if (toggled_on):
		game_speed = GameSpeed.FAST

func _on_speed_3_texture_button_toggled(toggled_on):
	if (toggled_on):
		game_speed = GameSpeed.FASTER

func _on_office_texture_button_pressed():
	# Switch to Screen.DROP_DOWN
	if (active_screen == Screen.OFFICE):
		active_screen = Screen.DROP_DOWN
	elif (active_screen == Screen.DROP_DOWN):
		active_screen = Screen.OFFICE

func _on_background_button_pressed():
	if (active_screen == Screen.DROP_DOWN):
		active_screen = Screen.OFFICE

func _on_pause_menu_button_pressed():
	game_speed = GameSpeed.PAUSED
	active_screen = Screen.PAUSE_MENU
