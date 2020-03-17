<?php

namespace DarlingCms\abstractions\component\Bazzer;

use DarlingCms\interfaces\primary\Storable;
use DarlingCms\interfaces\primary\Switchable;
use DarlingCms\interfaces\primary\Positionable;
use DarlingCms\interfaces\component\Bazzer\Baz as BazInterface;
use DarlingCms\abstractions\component\OutputComponent;

abstract class Baz extends OutputComponent implements BazInterface
{

    public function __construct(Storable $storable, Switchable $switchable, Positionable $positionable)
    {
        parent::__construct($storable, $switchable, $positionable);
    }

}
