note
	description: "Summary description for {TUPLE_ITERATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TUPLE_ITERATION_CURSOR[V,K]
inherit
	ITERATION_CURSOR[TUPLE[V,K]]
create
	make
feature{NONE}
	array: ARRAY[V]
	ln: LINKED_LIST[K]

	index: INTEGER
feature
	make(values: ARRAY[V]; keys: LINKED_LIST[K])
		do
			array := values
			ln := keys
			index := values.lower
		end

feature -- Access

	item: TUPLE[V,K]
			-- Item at current cursor position.
	local
		value: V
		key: K
		do
			value:= array[index]
			key := ln[index]
			create Result
			Result:= [value,key]
		end

feature -- Status report	

	after: BOOLEAN
			-- Are there no more items to iterate over?
		do
			Result:= array.count < index
		end

feature -- Cursor movement

	forth
			-- Move to next position.
		do
			index:= index + 1
		end

end
