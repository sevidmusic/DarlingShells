<?php


namespace DarlingCms\classes\component\Bar\Baz;

use DarlingCms\abstractions\component\Bar\Baz\Foo as FooBase;
use DarlingCms\interfaces\component\Bar\Baz\Foo as FooInterface;

class Foo extends FooBase implements FooInterface
{
    /**
     * This is a generic implementation, it does not require
     * any additional logic, the FooBase class
     * fulfills the requirements of the FooInterface.
     */
}
