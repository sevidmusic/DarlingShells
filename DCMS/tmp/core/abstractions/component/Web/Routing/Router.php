<?php

namespace DarlingCms\abstractions\component\Web\Routing;

use DarlingCms\interfaces\component\Web\Routing\Router as RouterInterface;
use DarlingCms\interfaces\primary\Storable;

abstract class Router extends Component implements RouterInterface
{

    public function __construct(Storable $storable)
    {
        parent::__construct($storable);
    }

}
