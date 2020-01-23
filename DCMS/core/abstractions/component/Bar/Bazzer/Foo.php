<?php

namespace DarlingCms\abstractions\component\Bar\Bazzer;

use DarlingCms\interfaces\component\Bar\Bazzer\Foo as FooInterface;
use DarlingCms\interfaces\primary\Storable;
use DarlingCms\abstractions\component\Component;

abstract class Foo extends Component implements FooInterface
{

    public function __construct(Storable $storable)
    {
        parent::__construct($storable);
    }

}
