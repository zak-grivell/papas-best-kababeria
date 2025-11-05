class_name Order

enum CookedToppings {
	lamb,
	beef,
	chicken,
	pork,
	chips
}

var person: Node

func get_children_in_group(node: Node, group_name: String):
	var res = []
	
	for child in node.get_children():
		if child.is_in_group(group_name):
			res.append(child)
			
	return res

static func rand_from_enum(enum_dict, n: int):
	var keys = enum_dict.keys()
	keys.shuffle()

	var result: Array[int] = []
	for i in range(min(n, keys.size())):
		result.append(enum_dict[keys[i]])
	return result


static func get_enum_name(e, v):
	return e.keys()[v]

var cooked_topings: Array[CookedToppings] = []

func rank_cooked_toppings(wrap_node):
	if cooked_topings.size() == 0:
		return 1.0
	
	var used = {}

	for child in get_children_in_group(wrap_node, "cooked_topping"):
		used[child.get_meta("cooked_topping")] = true
			
	return (float(
		cooked_topings.reduce(func (acc, cooked_toping): 
			return acc + int(used.get(get_enum_name(CookedToppings, cooked_toping),0)), 
		0)) 
		/ float(cooked_topings.size())
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
	if toppings.size() == 0:
		return 1.0
	var used = {}
		
	for child in get_children_in_group(wrap_node, "topping"):
		used[child.get_meta("topping_type")] = true
								
	return (float(
		toppings.reduce(
			func (acc, topping): 
				return acc + int(used.get(get_enum_name(Toppings, topping), false)), 
		0)) 
		/ float(toppings.size())
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
	if sauces.size() == 0:
		return 1.0

	var used = {}
	
	for child in get_children_in_group(wrap_node, "sauce"):
		used[child.get_meta("sauce_name")] = true
			
	return (float(
		sauces.reduce(
			func (acc, sauce): 
				return acc + int(used.get(get_enum_name(Sauce, sauce), false)), 
			0)) 
		/ float(sauces.size())
	)



enum Pint {
	tenents,
	belhaven,
	west,
	bru
}

var pint: Pint
var head_wanted: float

func integer_linear_ranking(x: float, s:float, m:float,c: float,) -> float:
	if abs(x) < s:
		return 1.0
	else:
		return abs(m * (abs(x) -s) + c)

func rank_pint(pint_node: Node):
	var type = pint_node.get_meta("beer_type")
	
	if not type:
		return 1.0
		
	if type != get_enum_name(Pint, pint):
		return 0.0

				
	return (integer_linear_ranking(pint_node.head_portion - head_wanted, 0.2, -0.6, 1) + integer_linear_ranking(abs(pint_node.beer_procress), 0.2, -1, 1)) / 2



func _init(new_cooked_topings, new_toppings, new_sauces, new_pint, new_head, new_person: Node):
	cooked_topings = new_cooked_topings
	toppings = new_toppings
	sauces = new_sauces
	pint = new_pint
	head_wanted = new_head
	person = new_person

func rank(kebab:Node, beer:Node):
	var wrap_nodes = get_children_in_group(kebab, "spawned_wraps")
	
	if len(wrap_nodes) > 0:
		var wrap_node = wrap_nodes[0]

		var beer_rank = rank_pint(beer)

		print("Ranking order for beer: ", beer_rank)

		return {
			'kebab': (rank_toppings(wrap_node) + rank_sauces(wrap_node) + rank_cooked_toppings(wrap_node)) / 3.0,
			'beer': beer_rank
		}
	else:
		for child in kebab.get_children():
			print(child.name, ": ", child.get_groups())
