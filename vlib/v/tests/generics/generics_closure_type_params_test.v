// Test for issue #26629: C compilation error using type parameters in function fields on structs
// This test verifies that generic closures with type parameters work correctly

// Test that a generic closure can be created and called with correct type substitution
fn make_adder[T](x T) fn (T) T {
	return fn [x] [T](y T) T {
		return x + y
	}
}

fn test_generic_closure_basic() {
	adder := make_adder(5)
	assert adder(3) == 8

	adder2 := make_adder(10.5)
	assert adder2(2.5) == 13.0
}

// Test generic closure with struct field
struct Transformer[T] {
	transform fn (T) T @[required]
}

fn create_transformer[T](initial T) Transformer[T] {
	return Transformer[T]{
		transform: fn [initial] [T](v T) T {
			return initial
		}
	}
}

fn test_generic_closure_in_struct() {
	t1 := create_transformer(42)
	assert t1.transform(100) == 42

	t2 := create_transformer('hello')
	assert t2.transform('world') == 'hello'
}

// Test generic closure with different generic parameter count than parent
fn wrapper[T](val T) fn () T {
	return fn [val] [T]() T {
		return val
	}
}

fn test_generic_closure_different_param_count() {
	w1 := wrapper(123)
	assert w1() == 123

	w2 := wrapper('test')
	assert w2() == 'test'
}

// Test case from issue #26629: parent function has multiple generic parameters,
// but the closure only uses one of them
struct ResultHolder[T] {
	get fn () T @[required]
}

// This function has TWO generic parameters (T, U), but the closure only uses U
fn create_result[T, U](_input T, output U) ResultHolder[U] {
	return ResultHolder[U]{
		get: fn [output] [U]() U {
			return output
		}
	}
}

fn test_generic_closure_subset_of_parent_generics() {
	r1 := create_result(42, 'hello')
	assert r1.get() == 'hello'

	r2 := create_result('ignored', 3.14)
	assert r2.get() == 3.14
}
