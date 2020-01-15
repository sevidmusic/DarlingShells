<?php

namespace UnitTests\interfaces\component\DS_COMPONENT_SUBTYPE\TestTraits;

use DarlingCms\interfaces\component\DS_COMPONENT_SUBTYPE\DS_COMPONENT_NAME;

// DS_USED_TEST_TRAIT_ALIASES;

trait DS_COMPONENT_NAMETestTrait
{

    // DS_USED_TEST_TRAITS

    private $DS_COMPONENT_NAME;

    public function getDS_COMPONENT_NAME(): DS_COMPONENT_NAME
    {
        return $this->DS_COMPONENT_NAME;
    }

    public function setDS_COMPONENT_NAME(DS_COMPONENT_NAME $DS_COMPONENT_NAME)
    {
        $this->DS_COMPONENT_NAME = $DS_COMPONENT_NAME;
    }

}
