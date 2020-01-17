<?php

namespace UnitTests\abstractions\component\Web\Routing;

use DarlingCms\classes\primary\Storable;
use UnitTests\interfaces\component\Web\Routing\TestTraits\RouterTestTrait;

class RouterTest extends ComponentTest
{
    use RouterTestTrait;

    public function setUp(): void
    {
        $this->setRouter(
            $this->getMockForAbstractClass(
                '\DarlingCms\abstractions\component\Web\Routing\Router',
                [
                    new Storable(
                        'MockRouterName',
                        'MockRouterLocation',
                        'MockRouterContainer'
                    ),
                ]
            )
        );
        $this->setRouterParentTestInstances();
    }

}
