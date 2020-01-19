<?php

namespace UnitTests\abstractions\component\Web\Routing\Output;

use DarlingCms\classes\primary\Storable;
use UnitTests\interfaces\component\Web\Routing\Output\TestTraits\ResponseTestTrait;

class ResponseTest extends ComponentTest
{
    use ResponseTestTrait;

    public function setUp(): void
    {
        $this->setResponse(
            $this->getMockForAbstractClass(
                '\DarlingCms\abstractions\component\Web\Routing\Output\Response',
                [
                    new Storable(
                        'MockResponseName',
                        'MockResponseLocation',
                        'MockResponseContainer'
                    ),
                ]
            )
        );
        $this->setResponseParentTestInstances();
    }

}
