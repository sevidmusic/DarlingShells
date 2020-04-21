<?php

/*
foreach($byteArray as $lrBytes) {
    $xor = $lrBytes['right'] ^ $lrBytes['left'][$index];
    $limitString = sprintf('(%1$2d = %1$04b)', $xor);
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

function performFeistelRound(array $byteArray): array
{
    $encryptedRightBytes = array();
    if(is_array($byteArray['left']) === false || is_array($byteArray['right']) === false)
    {
        return $byteArray;
    }
    $difference = (count($byteArray['left']) - count($byteArray['right']));
    $randChar = $difference ^ $difference;
    $byteFormat = 'Byte: %1$2d | Bits:  %1$04b';
    foreach($byteArray['left'] as $index => $leftByte)
    {
            $xor =  (isset($byteArray['right'][$index]) === true ? $byteArray['right'][$index] ^ $leftByte : $randChar ^ $leftByte);
            $devOutput = [
                'leftData' => 'Char: "' . chr($leftByte) .  '" | ' . sprintf($byteFormat, $leftByte),
                'rightData' => 'Char "' . (isset($byteArray['right'][$index]) === true ? chr($byteArray['right'][$index]) : chr($randChar)) . '" | ' . (
                    isset($byteArray['right'][$index]) === true
                        ? sprintf($byteFormat, $byteArray['right'][$index])
                        : sprintf($byteFormat, $randChar)
                ),
                'XOR Result' => sprintf($byteFormat, $xor) . ' | Char: ' . chr($xor)
            ];
            //devOutput($devOutput);
            $encryptedRightBytes[$index] = $xor;
    }
    $newByteArray = [];
    $newByteArray['left'] = $encryptedRightBytes;
    $newByteArray['right'] = $byteArray['left'];
    return $newByteArray;
}

function devOutput(array $devArray) {
    foreach($devArray as $devKey => $devValue)
    {
        $color1 = sprintf("\e[%sm \e[%sm ", "30", "45");
        $color2 = sprintf("\e[%sm", "35");
        $resetColor = sprintf("\e[%sm", "0");
        printf('%s%s%s%s%s : %s%s%s%s', PHP_EOL, $resetColor, $color1, $devKey, $resetColor, $color2, strval($devValue), $resetColor, PHP_EOL . PHP_EOL);
    }
}
function printByteCharValues(array $byteArray)
{
    foreach($byteArray as $byte)
    {
        printf('%s', chr($byte));
    }
}

function prepareForDecryption(array $encrypted): array
{
    $preparedData = [];
    $preparedData['left'] = $encrypted['right'];
    $preparedData['right'] = $encrypted['left'];
    return $preparedData;
}

$plainText = file_get_contents(__DIR__ . '/plainText.txt');
$byteArray = convertToByteArray($plainText);

$encrypted = performFeistelRound($byteArray);

$dbyteArray = prepareForDecryption($encrypted);
$decrypted = performFeistelRound($dbyteArray);
printByteCharValues($decrypted['left']);



