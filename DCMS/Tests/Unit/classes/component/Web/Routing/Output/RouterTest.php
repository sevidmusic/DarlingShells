<?php

namespace UnitTests\classes\component\Web\Routing\Output;

use DarlingCms\classes\component\Web\Routing\Output\Router;
use DarlingCms\classes\primary\Storable;
use UnitTests\abstractions\component\Web\Routing\Output\RouterTest as AbstractRouterTest;

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
