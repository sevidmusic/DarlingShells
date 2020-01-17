<?php

namespace UnitTests\classes\component\Web\Routing;

use DarlingCms\classes\component\Web\Routing\Router;
use DarlingCms\classes\primary\Storable;
use UnitTests\abstractions\component\Web\Routing\RouterTest as AbstractRouterTest;

class RouterTest extends AbstractRouterTest
{
    public function setUp(): void
    {
        $this->setRouter(
            new Router(
                new Storable(
                    'RouterName',
                    'RouterLocation',
                    'RouterContainer'
                ),
            )
        );
        $this->setRouterParentTestInstances();
    }
}
