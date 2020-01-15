#!/bin/sh

writeWordSleep() {
    printf "${1}";
    sleep "${2}";
}

sleepWriteWord() {
    sleep "${2}";
    printf "${1}";
}

sleepWriteWordSleep() {
    sleep "${2}";
    printf "${1}";
    sleep "${2}";
}

showLoadingBar() {
    sleepWriteWordSleep "Loading" .3;
    INC=0;
    while [ $INC -le 42 ]
    do
        sleepWriteWordSleep "." .05;
        INC=$(($INC + 1));
    done;
    clear;
}

showWelcomeMsg() {
    clear;
    sleepWriteWordSleep "\nHi\n" 1;
    sleepWriteWord "Here " .3;
    sleepWriteWord "Is " .3;
    sleepWriteWord "Today's " .3;
    sleepWriteWordSleep "Weather\n" .3;
}
while :
do
    showWelcomeMsg;
    showLoadingBar;
    curl wttr.in
    sleep 7;
    clear;
done;
