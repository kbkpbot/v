fn test_main() {
	mut b := [2]i32{}
	b[0] = 1
	b[1] = 2
	mut a := unsafe { memdup(b, 8) }
	x := &i32(a)
	unsafe {
		assert x[0] == 1
		assert x[1] == 2
	}
}
