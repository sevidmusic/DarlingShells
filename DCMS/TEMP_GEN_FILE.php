<?php

namespace UnitTests\interfaces\component\ComponentType\TestTraits;

use DarlingCms\interfaces\component\ComponentType\ComponentName;

trait ComponentNameTestTrait
{

    private $componentName;

    public function getComponentName(): ComponentName
    {
        return $this->componentName;
    }

    public function setComponentName(ComponentName $componentName)
    {
        $this->componentName = $componentName;
    }

}