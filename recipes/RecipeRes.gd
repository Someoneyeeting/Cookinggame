extends Resource
class_name RecipeRes


@export var items : Array[ItemRes]


func get_as_ids():
	var ids = []
	for i in items:
		ids.append(i.id)
	
	return ids

func is_matching(ids : Array):
	return ids == get_as_ids()

func matching_so_far(ids : Array):
	var cids = get_as_ids()
	for i in range(ids.size()):
		if(ids[i] != cids[i]):
			return false
	
	return true
