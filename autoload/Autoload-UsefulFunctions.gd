extends Node

const CHARS: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
const CHARS_LEN: int = len(CHARS)

func random_string(length) -> String:
	var result: String = ""
	for i in range(length):
		result += CHARS[randi() % CHARS_LEN]
	return result
