<?php

namespace UnitTests\abstractions\component\Web\Routing\Output;

use DarlingCms\classes\primary\Storable;
use UnitTests\interfaces\component\Web\Routing\Output\TestTraits\RequestTestTrait;

class RequestTest extends ComponentTest
{
    use RequestTestTrait;

    public function setUp(): void
    {
        $this->setRequest(
            $this->getMockForAbstractClass(
                '\DarlingCms\abstractions\component\Web\Routing\Output\Request',
                [
                    new Storable(
                        'MockRequestName',
                        'MockRequestLocation',
                        'MockRequestContainer'
                    ),
                ]
            )
        );
        $this->setRequestParentTestInstances();
    }

}
