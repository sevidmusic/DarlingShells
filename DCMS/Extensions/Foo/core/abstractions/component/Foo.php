<?php

namespace Extensions\Foo\core\abstractions\component;

use DarlingCms\abstractions\component\Component as BaseComponent;
use DarlingCms\interfaces\primary\Storable;
use Extensions\Foo\core\interfaces\component\Foo as FooInterface;

abstract class Foo extends BaseComponent implements FooInterface
{

    public function __construct(Storable $storable)
    {
        parent::__construct($storable);
    }

}
