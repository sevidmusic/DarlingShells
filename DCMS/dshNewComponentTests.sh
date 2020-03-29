#!/bin/bash


./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" -s "a" &&
./newComponent.sh -x "Extension" -t "CoreSwitchableComponent" -e "Foo" -c "Bar" -s "a\\b" &&
./newComponent.sh -x "Extension" -t "CoreComponent" -e "Foo" -c "Bar" -s "a\\b\\c" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" -s "a\\b\\c\\d" &&
./newComponent.sh -x "Extension" -t "CoreSwitchableComponent" -e "Foo" -c "Bar" -s "a\\b\\c\\d\\e" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" -s "a\\b\\c\\d\\e\\f" &&
./newComponent.sh -x "Extension" -t "CoreComponent" -e "Foo" -c "Bar" -s "a\\b\\c\\d\\e\\f\\g"
