<?php


namespace DarlingCms\classes\component\Bar\Bazzer;

use DarlingCms\abstractions\component\Bar\Bazzer\Foo as FooBase;
use DarlingCms\interfaces\component\Bar\Bazzer\Foo as FooInterface;

class Foo extends FooBase implements FooInterface
{
    /**
     * This is a generic implementation, it does not require
     * any additional logic, the FooBase class
     * fulfills the requirements of the FooInterface.
     */
}
