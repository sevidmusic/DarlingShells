
function printfArrays() {
	local -n _arrayOne=$1
	local -n _arrayTwo=$2
	local _currentIndex
	for i in "${!_arrayOne[@]}";
	do
		printf "\n%s\n" "${_arrayOne[${i}]}"
		printf "\n%s\n" "${_arrayTwo[${i}]}"
	done
}

one=("Foo" "Baz" "FooBar")
two=("Foo1" "Baz1" "FooBar1")

printfArrays one two

