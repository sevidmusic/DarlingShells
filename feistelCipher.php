<?php
// Rough overview
// get byte array
//
// split array in two | i.e. Left and Right
//
// Swap Left and Right
//
// XOR
//
// Repeat as many times as you wish
//


$plainText = 'Hello Dad';

// WARNING: unpack() returns an array with of-1 based indexes, i.e. indexes start at 1, not 0
// list() is used below, and expects array indexes to start at 0, so $byteArray indexes will have to be adjusted
$byteArray = unpack('C*', $plainText);

$byteArrayCorrectedIndexes = [];
foreach($byteArray as $byte) {
    array_push($byteArrayCorrectedIndexes, $byte);
}

list($left, $right) = array_chunk($byteArrayCorrectedIndexes, ceil(count($byteArrayCorrectedIndexes) / 2));



/// dev
// fiestel works as follows
// plainText / 2 =  Left | Right
// Right xor Left
// Repeat
$limitString = '(EBYTE - BITS)';
$keyFormat = '(EBYTE = BITS)%s=    (RIGHTBYTE = BITS)    ^    (LEFTBYTE = BITS)' . PHP_EOL;
$byteFormat = '(%1$2d = %1$04b)%2$s=    (%3$2d = %3$04b)    %4$s    (%5$2d = %5$04b)' . PHP_EOL . PHP_EOL;

foreach($right as $index => $rightByte) {
    $xor = $rightByte ^ $left[$index];
    $limitString = sprintf('(%1$2d = %1$04b)', $xor);
    printf($keyFormat, '    ');
    printf($byteFormat,$xor, getSpaceing($limitString), $rightByte, '^', $left[$index]);
}

function getSpaceing(string $xor): string
{
    $spaces = '';
    $spaceCount = (4 + (14 - strlen($xor))); // ( strlen($xor) < 14 ?  (14 - strlen($xor)) : 0 ));
    /*var_dump(
        [
            'xor' => $xor,
            'logic' =>  '(4 + ( ' . strlen($xor) . ' < 14 ?  (14 - ' . strlen($xor) . ') : 0 ))',
            'SpaceCount' => $spaceCount
        ]
    );*/
    for($i=0; $i<$spaceCount;$i++) {
        $spaces .= ' ';
    }
    return $spaces;
}



// dev
/*
var_dump(
    [
        'plainText' => $plainText,
        'bytesArray' =>$byteArray,
        'correctedBytesArray' => $byteArrayCorrectedIndexes,
        'left' => $left,
        'right' => $right
    ]
);
 */

