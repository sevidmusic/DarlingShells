<?php

namespace UnitTests\interfaces\component\Web\Routing\Output\TestTraits;

use DarlingCms\interfaces\component\Web\Routing\Output\Request;

trait RequestTestTrait
{

    private $request;

    protected function setRequestParentTestInstances(): void
    {
        $this->setComponent($this->getRequest());
        $this->setComponentParentTestInstances();
    }

    public function getRequest(): Request
    {
        return $this->request;
    }

    public function setRequest(Request $request)
    {
        $this->request = $request;
    }

}
