<?php

namespace UnitTests\interfaces\component\Web\Routing\TestTraits;

use DarlingCms\interfaces\component\Web\Routing\Response;

trait ResponseTestTrait
{

    private $response;

    protected function setResponseParentTestInstances(): void
    {
        $this->setComponent($this->getResponse());
        $this->setComponentParentTestInstances();
    }

    public function getResponse(): Response
    {
        return $this->response;
    }

    public function setResponse(Response $response)
    {
        $this->response = $response;
    }

}
