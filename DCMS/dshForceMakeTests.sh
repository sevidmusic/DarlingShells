#!/bin/bash


/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "FooEx" -c "Bar" -s "" -f &&
/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -t "CoreOutputComponent" -e "FooEx" -c "Foo" -s "" -x "Extension" -f &&
/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -e "FooEx" -c "Bazing" -s "BarBaz\\Bazzer" -x "Extension" -t "CoreComponent" -f &&
/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -c "Ifj" -s "a\\b\\c\\d" -x "Extension" -t "CoreSwitchableComponent" -e "FooEx" -f &&
/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -s "a\\b\\c\\Baz" -x "Extension" -t "CoreComponent" -e "FooEx" -c "Iue" -f &&

