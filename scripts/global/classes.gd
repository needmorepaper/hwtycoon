## Various primitive classes
## TODO: Split up once it gets too big?
class_name Classes extends Node

## This class describes all gameplay screens
class Screen:
	var button_text: String
	var dropdown_able: bool
	var unlocked: bool ## If an unlocked Screen is dropdown_able it will be shown in the dropdown menu.
	
	func _init(_button_text: String = "Unnamed Button", _dropdown_able: bool = false, _unlocked: bool = false):
		button_text = _button_text
		dropdown_able = _dropdown_able
		unlocked = _unlocked

## This class describes all types of hardware
class Hardware:
	var button_text: String
	var button_texture_normal: Texture2D
	var button_texture_hover: Texture2D
	var unlocked: bool
	
	# calculated during gameplay
	var level: int = 0
	var level_progress: float = 0.0
	
	func _init(_button_text: String = "Unnamed Hardware", _button_texture_normal: Texture2D = Texture2D.new(), _button_texture_hover: Texture2D = Texture2D.new(), _unlocked: bool = false):
		button_text = _button_text
		button_texture_normal = _button_texture_normal
		button_texture_hover = _button_texture_hover
		unlocked = _unlocked

## This class manages the flow of time in Gameplay,
class DateTime:
	const days_in_year: float = 360  # NOTE: original game's year only had 360 days
	const months_in_year: float = 12
	const days_in_month: float = days_in_year / months_in_year
	
	signal changed  ## This signal is called when the day count is changed.
	signal day_incremented ## This signal is called when the day increases by 1.
	signal month_incremented ## This signal is called when the month increases by 1.
	signal year_incremented ## This signal is called when the year increases by 1.
	
	var count: float = 1: ## Total days elapsed. D1/M1/Y0001 == 0 days.
		set(value):
			var old_day = day
			var old_month = month
			var old_year = year
			count = value
			changed.emit(count)
			if (day == old_day + 1):
				day_incremented.emit(day)
			if (month == old_month + 1):
				month_incremented.emit(month)
			if (year == old_year + 1):
				year_incremented.emit(year)
	
	var day: float: ## The current day of the month
		set(value):
			count = (count - (count - (year * days_in_year) - (month * days_in_month)) + value) - 1 # Subtract 1 to account for the Fencepost problem.
		get:
			return count - (year * days_in_year) - (month * days_in_month) + 1
	
	var month: float: ## The current month of the year
		set(value):
			count = (count - (floor((count - (year * days_in_year)) / (days_in_month)) * days_in_month) + (value * days_in_month)) - 1 # count - current month as days + new month as days # Subtract 1 to account for the Fencepost problem.
		get:
			return floor((count - (year * days_in_year)) / (days_in_month)) + 1 # remainder of (count / days_in_year) / days in month
	
	var year: float: ## The current year
		set(value):
			count = (count - (floor(count / days_in_year) * days_in_year) + (value * days_in_year)) - 1 # count - current year as days + new year as days # Subtract 1 to account for the Fencepost problem.
		get:
			return floor(count / days_in_year)
	
	func increment(_amount_days: int = 1): ## Increment DateTime by amount_days
		count += _amount_days
	
	func dict_to_day_count(dict: Dictionary): ## Converts a Day Month Year dict to a count of days.
		var value: float = 0
		value += dict["year"] * days_in_year
		value += dict["month"] * days_in_month - days_in_month
		value += dict["day"] - 1
		return value
	
	func count_to_string():
		return ("D%d/M%d/Y%d" % [day+30, month, year])
	
	func print_to_console(string: String):
		print("%d %s %s" % [count, count_to_string(), string])

## This class manages the player's finances.
class Finances:
	signal changed
	
	var profit: float = 0: ## The total profit for the company. (profit = income - expenses)
		set(value):
			profit = value
			Global.player_company.profit = profit
			changed.emit()
	
	var annual_profit: float = 0 ## Totals the profit for the year. Resets to 0 each year.
	
	var income: float = Global.player_company.profit: ## The total income for the company. Inital value set by PlayerCompany.
		set(value):
			print("Income changed by $%sk" % [snapped((value/1000.0),0.01)]) # TODO: 
			var old_income = income
			income = value
			annual_income += income - old_income
			profit = income - expenses
	
	var annual_income: float = 0: ## Totals the income for the year. Resets to 0 each year.
		set(value):
			annual_income = value
			annual_profit = annual_income - annual_expenses
	
	var expenses: float = 0: ## The total expenses for the company.
		set(value):
			print("Expenses changed by $%sk" % [snapped((value/1000.0),0.01)])
			var old_expenses = expenses
			expenses = value
			annual_expenses += expenses - old_expenses
			profit = income - expenses
	
	var annual_expenses: float = 0: ## Totals the expenses for the year. Resets to 0 each year.
		set(value):
			annual_expenses = value
			annual_profit = annual_income - annual_expenses

## This class defines a product
## INFO: Currently Product is Product.CPU
## TODO: Convert to Product.CPU
## NOTE: Should probably be moved to script defining all types of product.
## TODO: Move all gameplay code out of Product.
class Product:
	# configurable
	var retail_price: float = 50.00 ## The retail price for the product in the form $50.00
	var brand_name: String = "brand_name" ## The name of the CPU brand. e.g. 'Core I7' NOTE: WIP TODO: Set by Screen.NEW_HARDWARE
	var design_name: String = "design_name" ## The name of thi CPU design. e.g. '13000k' NOTE: WIP TODO: Set by Screen.NEW_HARDWARE
	#var build_quality: float = 75.0 ## The build quality of the product ranging from 50% - 100%. NOTE: WIP
	#var package ## The package in which to house the CPU die. INFO: Affects design_cost, production_cost and design_time NOTE: WIP
	#var core_count ## The number of processing cores intergrated into the CPU die. INFO: Was unimplemented in the original game. NOTE: WIP
	
	# stats
	#var performance: float # NOTE: WIP
	#var stability: float # NOTE: WIP
	#var build: float # NOTE: WIP
	
	# calculated
	## TODO: calculate values
	var on_sale: bool = false
	var product_release_day: float ## The DateTime.count the product was released. Sales will start that day.
	var production_cost: float = 30.74 ## The cost to produce the product in the form $30.74
	var design_cost: float = 94120 ## The cost to design the product. TODO: design_cost is logged in the finance screen as a total at the start of design, but is taken from balance monthly.
	var design_time: float = 160 ## The amount of days it will take to design the CPU. TODO: calculate release day
	
	# system
	var weeks_on_sale: int = 0
	var total_sales: int = 0
	var weekly_sales: int = 0
	
	func _init(date_time: DateTime):
		product_release_day = date_time.dict_to_day_count({day = 1, month = 1, year = 1970}) # TEST: Used to force product_release_day to specific day month year.
		#product_release_day = date_time.count + design_time
	
	func _on_product_release_day(date_time: DateTime):
		date_time.print_to_console("Product Released: %s %s" % [brand_name, design_name])

	## TODO: add finance screen log_income or log_expenses
	## BUG: if (product_release_day == Global.player_company.starting_date_time): The first report will happen one day after it should. I think this is because the first day doesn't get a .changed,.day_incremented,.month_incremented,.year_incremented This should probably be handeled in DateTime._init()
	func _on_weeks_since_product_release(date_time: DateTime):
		date_time.print_to_console("$%sk CPU Sales" % [snapped((((retail_price - production_cost)*weekly_sales)/1000.0),0.01)])
		weekly_sales = 0
