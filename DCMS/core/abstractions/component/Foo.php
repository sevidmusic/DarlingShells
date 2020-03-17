<?php

namespace DarlingCms\abstractions\component;

use DarlingCms\interfaces\component\Foo as FooInterface;
use DarlingCms\interfaces\primary\Storable;
use DarlingCms\abstractions\component\Component;

abstract class Foo extends Component implements FooInterface
{

    public function __construct(Storable $storable)
    {
        parent::__construct($storable);
    }

}
