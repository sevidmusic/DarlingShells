<?php

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
	    var_dump(
		    [
			    $index,
			    (count($byteArray['right']) - 1),
			    $difference,
			    $index < (count($byteArray['right']) - 1)
		    ]
	    );
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

function writeByteCharValues(array $byteArray, string $file = 'file.txt')
{
    $output = '';
    foreach($byteArray as $byte)
    {
        $output .= sprintf('%s', chr($byte));
    }
    file_put_contents(__DIR__ . '/' . $file, $output, FILE_APPEND | LOCK_EX);
}

function prepareForDecryption(array $encrypted): array
{
    $preparedData = [];
    $preparedData['left'] = $encrypted['right'];
    $preparedData['right'] = $encrypted['left'];
    return $preparedData;
}

function encrypt(array $byteArray): array
{
    $encrypted = performFeistelRound($byteArray);
    writeByteCharValues($encrypted['right'], 'encryptedBytes.txt');
    writeByteCharValues($encrypted['left'], 'encryptedBytes.txt');
    return $encrypted;
}

$plainText = file_get_contents(__DIR__ . '/plainText.txt');
$byteArray = convertToByteArray($plainText);
$encrypted = encrypt($byteArray);
$dbyteArray = prepareForDecryption($encrypted);
$decrypted = performFeistelRound($dbyteArray);
writeByteCharValues($decrypted['right'], 'decryptedBytes.txt');
writeByteCharValues($decrypted['left'], 'decryptedBytes.txt');


