note
	description: "A Dictionary ADT mapping from keys to values"
	author: "Jackie and You"
	date: "$Date$"
	revision: "$Revision$"

class
	-- Constrained genericity because V and K will be used
	-- in the math model class FUN, which require both to be always
	-- attached for void safety.
	DICTIONARY[V -> attached ANY, K -> attached ANY]
inherit
	ITERABLE[TUPLE[V, K]];	--FUN[V -> attached ANY, K -> attached ANY]

create
	make

feature {NONE} -- Do not modify this export status!
	values: ARRAY[V]
	keys: LINKED_LIST[K]

feature -- Abstraction function
	model: FUN[K, V] -- Do not modify the type of this query.
			-- Abstract the dictionary ADT as a mathematical function.
	local
		i: INTEGER
	do
		create Result.make_empty
		from
			i := 1
		until
			i = keys.count + 1
		loop
			Result.extend (create {PAIR[K,V]}.make(keys[i],values[i]))
			i:= i + 1
		end
		ensure
			consistent_model_imp_counts: model.count = count
				-- Your Task: sizes of model and implementations the same
			consistent_model_imp_contents:
				across
					1 |..| Result.count as j
				all
					Result.has(create {PAIR[K,V]}.make(keys[j.item],values[j.item]))
				end
				-- Your Task: applying the model function on each key gives back the corresponding value
		end

feature -- feature required by ITERABLE
	new_cursor: ITERATION_CURSOR[TUPLE[V, K]]
	local
		cursor: TUPLE_ITERATION_CURSOR[V,K]
		do
			create cursor.make(values,keys)
			Result := cursor

			-- Your Task
		end

feature -- Constructor
	make
			-- Initialize an empty dictionary.
		do
			create keys.make
			create values.make_empty
			values.compare_objects
			keys.compare_objects

			-- Your Task: add more code here
		ensure
			empty_model: model.is_empty
				-- Your task
			object_equality_for_keys:
				keys.object_comparison
			object_equality_for_values:
				values.object_comparison
		end

feature -- Commands

	add_entry (v: V; k: K)
		require
			non_existing_in_model: not model.domain.has (k)
				-- Your Task
		do
			values.force (v,values.count+1)
			keys.extend (k)
			-- Your Task
		ensure
			entry_added_to_model:
			model.item (k) ~ v
				-- Your Task: Look at feature 'test_model' in class 'INSTRUCTOR_DICTIONARY_TESTS' for hints.
		end

	remove_entry (k: K)
		require
			existing_in_model: model.domain.has (k)
				-- Your Task
		local
			i,j,index: INTEGER

		do
			index := keys.index_of (k, 1)
			keys.go_i_th (index)
			keys.remove

			from
				j:= index
			until
				j = values.count
			loop
				values[j] := values[j+1]
				j:= j + 1
			end
			values.remove_tail (1)

			-- Your Task
		ensure
			entry_removed_from_model:
			model ~ (old model.deep_twin).domain_subtracted_by(k)
				-- Your Task: Same hint as for 'add_entry'
		end

feature -- Queries

	count: INTEGER
			-- Number of keys in BST.
		do
			Result:= model.count
			-- Your Task
		ensure
			correct_model_result: model.count = Result
				-- Your Task
		end

	get_keys (v: V): ITERABLE[K]
			-- Keys that are associated with value 'v'.
		local
			ln: LINKED_LIST[K]
			i: INTEGER
		do
			create ln.make
			from
				i := 1
			until
				i = values.count + 1
			loop
				if
					values[i] ~ v
				then
					ln.extend (keys[i])
				end
				i:= i + 1
			end
			Result:= ln
			-- Your Task
		ensure
			correct_model_result:
			across Result as j
			all
				model.range_restricted_by(v).domain.has(j.item)
			end

		end

	get_value (k: K): detachable V
			-- Assocated value of 'k' if it exists.
			-- Void if 'k' does not exist.
		local
			i: INTEGER
		do
			from
				i:= 1
			until
				i= values.count + 1
			loop
				if
					keys[i] ~ k
				then
					Result:= values[i]
				end
				i:= i + 1
			end
			-- Your Task
		ensure
			case_of_void_result:
			 not model.domain.has (k) implies (Result ~ Void)
			--
			-- Your Task: void result means the key does not exist in model
			case_of_non_void_result:
			model.domain.has (k) implies not (Result ~ Void)
				-- Your Task: void result means the key exists in model
		end
invariant
	consistent_keys_values_counts:
		keys.count = values.count
	consistent_imp_adt_counts:
		keys.count = count
end
