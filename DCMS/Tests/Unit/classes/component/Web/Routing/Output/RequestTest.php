<?php

namespace UnitTests\classes\component\Web\Routing\Output;

use DarlingCms\classes\component\Web\Routing\Output\Request;
use DarlingCms\classes\primary\Storable;
use UnitTests\abstractions\component\Web\Routing\Output\RequestTest as AbstractRequestTest;

class RequestTest extends AbstractRequestTest
{
    public function setUp(): void
    {
        $this->setRequest(
            new Request(
                new Storable(
                    'RequestName',
                    'RequestLocation',
                    'RequestContainer'
                ),
            )
        );
        $this->setRequestParentTestInstances();
    }
}
