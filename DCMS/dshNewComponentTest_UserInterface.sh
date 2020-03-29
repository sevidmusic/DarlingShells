#!/bin/bash


./newComponent.sh &&
./newComponent.sh -x "Extension" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" -s "" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" -s "a" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" -s "a\\b" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" -s "a\\b\\c" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" -s "a\\b\\c\\d" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" -s "a\\b\\c\\d\\e" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" -s "a\\b\\c\\d\\e\\f" &&
./newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" -s "a\\b\\c\\d\\e\\f\\g"
