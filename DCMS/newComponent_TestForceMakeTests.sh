#!/bin/bash


/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bar" -s "" -f &&
/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -x "Extension" -t "CoreSwitchableComponent" -e "Foo" -c "Baz" -s "a" -f &&
/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "Bazzer" -s "a\\b" -f &&
/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -x "Extension" -t "CoreComponent" -e "Foo" -c "FooBar" -s "a\\b\\c" -f &&
/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "FooBaz" -s "a\\b\\c\\d" -f &&
/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -x "Extension" -t "CoreComponent" -e "Foo" -c "FooBazzer" -s "a\\b\\c\\d\\e" -f &&
/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -x "Extension" -t "CoreOutputComponent" -e "Foo" -c "BarBaz" -s "a\\b\\c\\e\\f" -f &&
/home/sevidmusic/Code/DarlingShells/DCMS/newComponent.sh -x "Extension" -t "CoreSwitchableComponent" -e "Foo" -c "BazBar" -s "baz\\bar\\foo" -f

