<?php

/*
foreach($byteArray as $lrBytes) {
    $xor = $lrBytes['right'] ^ $lrBytes['left'][$index];
    $limitString = sprintf('(%1$2d = %1$04b)', $xor);
    printf($keyFormat, '    ');
    printf($byteFormat,$xor, getSpaceing($limitString), $lrBytes['right'], '^', $lrBytes['left'][$index]);
}
*/
function getSpaceing(string $string): string
{
    $spaces = '';
    $spaceCount = (4 + (14 - strlen($string)));
    for($i=0; $i<$spaceCount;$i++) {
        $spaces .= ' ';
    }
    return $spaces;
}

function convertToByteArray(string $plainText): array
{
    // WARNING: unpack() returns an array with of-1 based indexes, i.e. indexes start at 1, not 0
    // list() is used below, and expects array indexes to start at 0, so $byteArray indexes will have to be adjusted
    $byteArray = unpack('C*', $plainText);
    $byteArrayCorrectedIndexes = [];
    foreach($byteArray as $byte) {
        array_push($byteArrayCorrectedIndexes, $byte);
    }
    list($left, $right) = array_chunk($byteArrayCorrectedIndexes, ceil(count($byteArrayCorrectedIndexes) / 2));
    $lrBytes = ['left' => $left, 'right' => $right];
    return $lrBytes;
}

$plainText = file_get_contents(__DIR__ . '/plainText.txt');
$byteArray = convertToByteArray($plainText);
$limitString = '(EBYTE - BITS)';
$keyFormat = '(EBYTE = BITS)%s=    (RIGHTBYTE = BITS)    ^    (LEFTBYTE = BITS)' . PHP_EOL;
$byteFormat = '(%1$2d = %1$04b)%2$s=    (%3$2d = %3$04b)    %4$s    (%5$2d = %5$04b)' . PHP_EOL . PHP_EOL;
$difference = (count($byteArray['left']) - count($byteArray['right']));
$randChar = $difference ^ $difference;

foreach($byteArray['left'] as $index => $leftByte)
{
        $devOutput = [
            'leftByte' => $leftByte,
            'leftChar' => chr($leftByte),
            'rightByte' => (isset($byteArray['right'][$index]) === true ? $byteArray['right'][$index] : $randChar),
            'rightChar' => (isset($byteArray['right'][$index]) === true ? chr($byteArray['right'][$index]) : chr($randChar)),
        ];
        foreach($devOutput as $devKey => $devValue)
        {
            $color1 = sprintf("\e[%sm \e[%sm ", "34", "45");
            $color2 = sprintf("\e[%sm", "35");
            $resetColor = sprintf("\e[%sm", "0");
            printf('%s%s%s%s%s : %s%s%s%s', PHP_EOL, $resetColor, $color1, $devKey, $resetColor, $color2, $devValue, $resetColor, PHP_EOL);
        }
}

