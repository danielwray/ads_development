extends VBoxContainer

# local variables
var item_list   = self
var high_score_list

func _ready():
	high_score_list = get_node("highest_score")
	var high_scores = init.get_player_high_score()
	set_highest_score(high_scores)


func set_highest_score(scores):
	if scores.size() > 0:
		var highest_score = high_score_sort(scores)
		if highest_score:
			high_score_list.set_text("Guitar Dude " + str(highest_score))
	else:
		high_score_list.set_text("No high score")

func high_score_sort(score_array):
    var max_val = score_array[0]
    for i in range(1, score_array.size()):
        max_val = max(max_val, score_array[i])
    return max_val