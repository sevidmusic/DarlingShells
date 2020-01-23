<?php

namespace DarlingCms\abstractions\component\Bar\Baz;

use DarlingCms\interfaces\component\Bar\Baz\Foo as FooInterface;
use DarlingCms\interfaces\primary\Storable;
use DarlingCms\abstractions\component\Component;

abstract class Foo extends Component implements FooInterface
{

    public function __construct(Storable $storable)
    {
        parent::__construct($storable);
    }

}
