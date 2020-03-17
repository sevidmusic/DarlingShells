<?php


namespace DarlingCms\classes\component;

use DarlingCms\abstractions\component\Foo as FooBase;
use DarlingCms\interfaces\component\Foo as FooInterface;

class Foo extends FooBase implements FooInterface
{
    /**
     * This is a generic implementation, it does not require
     * any additional logic, the FooBase class
     * fulfills the requirements of the FooInterface.
     */
}
