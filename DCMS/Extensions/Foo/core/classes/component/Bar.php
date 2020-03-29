<?php


namespace Extensions\Foo\core\classes\component;

use Extensions\Foo\core\interfaces\component\Bar as BarInterface;
use Extensions\Foo\core\abstractions\component\Bar as BarBase;

class Bar extends BarBase implements BarInterface
{
    /**
     * This is a generic implementation, it does not require
     * any additional logic, the BarBase class
     * fulfills the requirements of the BarInterface.
     */
}
