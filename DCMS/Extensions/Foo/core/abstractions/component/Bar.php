<?php

namespace Extensions\Foo\core\abstractions\component;

use DarlingCms\interfaces\primary\Storable;
use DarlingCms\abstractions\component\Component;
use Extensions\Foo\core\interfaces\component\Bar as BarInterface;

abstract class Bar extends Component implements BarInterface
{

    public function __construct(Storable $storable)
    {
        parent::__construct($storable);
    }

}
