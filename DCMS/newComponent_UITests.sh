#!/bin/bash


./newComponent.sh &&
./newComponent.sh -x "Extension" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" &&
./newComponent.sh -x "Extension" -t "CoreComponent" -e "Foo" &&
./newComponent.sh -x "Extension" -t "CoreSwitchableComponent" -e "Foo" -c "Bar" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Baz" -s "" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bazzer" -s "a" &&
./newComponent.sh -x "Extension" -t "CoreComponent" -e "Foo" -c "Bar" -s "a\\b" &&
./newComponent.sh -x "Extension" -t "CoreComponent" -e "Foo" -c "FooBar" -s "a\\b\\c" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Baz" -s "a\\b\\c\\d" &&
./newComponent.sh -x "Extension" -t "CoreSwitchableComponent" -e "Foo" -c "BarBaz" -s "a\\b\\c\\d\\e" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" -s "a\\b\\c\\d\\e\\f" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Baz" -s "a\\b\\c\\d\\e\\f\\g"
