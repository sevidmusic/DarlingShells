<?php

namespace UnitTests\classes\component\Web\Routing\Output;

use DarlingCms\classes\component\Web\Routing\Output\Response;
use DarlingCms\classes\primary\Storable;
use UnitTests\abstractions\component\Web\Routing\Output\ResponseTest as AbstractResponseTest;

class ResponseTest extends AbstractResponseTest
{
    public function setUp(): void
    {
        $this->setResponse(
            new Response(
                new Storable(
                    'ResponseName',
                    'ResponseLocation',
                    'ResponseContainer'
                ),
            )
        );
        $this->setResponseParentTestInstances();
    }
}
