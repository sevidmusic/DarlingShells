<?php

namespace UnitTests\interfaces\component\TestTraits;

use DarlingCms\interfaces\component\OutputComponent;

trait OutputComponentTestTrait
{

    private $OutputComponent;

    public function getOutputComponent(): OutputComponent
    {
        return $this->OutputComponent;
    }

    public function setOutputComponent(OutputComponent $OutputComponent)
    {
        $this->OutputComponent = $OutputComponent;
    }

}