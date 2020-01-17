<?php

namespace UnitTests\interfaces\component\Web\Routing\TestTraits;

use DarlingCms\interfaces\component\Web\Routing\Router;

trait RouterTestTrait
{

    private $router;

    protected function setRouterParentTestInstances(): void
    {
        $this->setComponent($this->getRouter());
        $this->setComponentParentTestInstances();
    }

    public function getRouter(): Router
    {
        return $this->router;
    }

    public function setRouter(Router $router)
    {
        $this->router = $router;
    }

}
