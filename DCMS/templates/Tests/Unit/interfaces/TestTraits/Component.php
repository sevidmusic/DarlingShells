<?php

namespace UnitTests\interfaces\component\DS_COMPONENT_SUBTYPE\TestTraits;

use DarlingCms\interfaces\component\DS_COMPONENT_SUBTYPE\DS_COMPONENT_NAME;
// DS_INJECTED_TEST_TRAIT_ALIASES;

trait DS_COMPONENT_NAMETestTrait
{

    // DS_INJECTED_TEST_TRAITS;

    private $DS_COMPONENT_NAME;

    protected function setDS_COMPONENT_NAMEParentTestInstances(): void
    {
        $this->setDS_COMPONENT_PARENT_NAME($this->getSwitchableComponent());
        $this->DS_COMPONENT_NAMEParentTestInstances();
        // DS_INJECTED_TEST_TRAIT_SETTERS
    }

    public function getDS_COMPONENT_NAME(): DS_COMPONENT_NAME
    {
        return $this->DS_COMPONENT_NAME;
    }

    public function setDS_COMPONENT_NAME(DS_COMPONENT_NAME $DS_COMPONENT_NAME)
    {
        $this->DS_COMPONENT_NAME = $DS_COMPONENT_NAME;
    }

}


