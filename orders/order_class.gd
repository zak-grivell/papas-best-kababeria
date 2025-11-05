class_name Order

enum CookedToppings {
	lamb,
	beef,
	chicken,
	turkey,
	chips
}

func get_children_in_group(node: Node, group_name: String):
	var res = []
	
	for child in node.get_children():
		if child.is_in_group(group_name):
			res.append(child)
			
	return res

func get_name(e, v):
	return e.keys()[v]

var cooked_topings: Array[CookedToppings] = []

func rank_cooked_toppings(wrap_node):
	var used = {}

	for child in get_children_in_group(wrap_node, "cooked_topping"):
		used[child.get_meta("cooked_topping")] = true
			
	return (float(
		cooked_topings.reduce(func (acc, cooked_toping): return acc + int(used[get_name(CookedToppings, cooked_toping)]), 0)) 
		/ float(used.size())
	)

enum Toppings {
	tomato,
	lettuce,
	onion,
	cabbage,
	chili,
	cucumber
}

var toppings: Array[Toppings] = []

func rank_toppings(wrap_node):
	var used = {}
	
	for child in get_children_in_group(wrap_node, "topping"):
		used[child.get_meta("topping_type")] = true
								
	return (float(
		toppings.reduce(func (acc, topping): return acc + int(used[get_name(Toppings, topping)]), 0)) 
		/ float(used.size())
	)



enum Sauce {
	chili,
	ketchup,
	mayo,
	yogurt,
	bbq,
}

var sauces: Array[Sauce] = []

func rank_sauces(wrap_node:Node) -> float:
	var used = {}
	
	for child in get_children_in_group(wrap_node, "sauce"):
		used[child.get_meta("sauce_name")] = true
			
	print(used)

	return (float(
		sauces.reduce(func (acc, sauce): return acc + int(used[get_name(Sauce, sauce)]), 0)) 
		/ float(used.size())
	)



enum Pint {
	tenents,
	belhaven,
	west,
	bru
}

var pint: Pint
var head_wanted: float

func integer_linear_ranking(x: float, s:float, m:float,c: float,):
	if abs(x) < s:
		return 1
	else:
		return abs(m * (abs(x) -s) + c)

func rank_pint(pint_node: Node):
	var type = pint_node.get_meta("beer_type")
	
	if not type:
		print("beer without type")
		return 1
		
	if type != get_name(Pint, pint):
		return 0
				
	return integer_linear_ranking(pint_node.head_portion - head_wanted, 0.1, -0.6, 1) * integer_linear_ranking(abs(pint_node.beer_procress), 0.2, -1, 1)



func _init(new_cooked_topings: Array[CookedToppings], new_toppings: Array[Toppings], new_sauces: Array[Sauce], new_pint: Pint, new_head: float):
	cooked_topings = new_cooked_topings
	toppings = new_toppings
	sauces = new_sauces
	pint = new_pint
	head_wanted = new_head

func rank(kebab:Node, beer:Node):
	var wrap_nodes = get_children_in_group(kebab, "spawned_wraps")
	
	if len(wrap_nodes) > 0:
		var wrap_node = wrap_nodes[0]

		return {
			'cooked': rank_cooked_toppings(wrap_node),
			'toppings': rank_toppings(wrap_node),
			'sauce': rank_sauces(wrap_node),
			'beer': rank_pint(beer)
		}
	else:
		for child in kebab.get_children():
			print(child.name, ": ", child.get_groups())
