<?php

namespace UnitTests\interfaces\component\BAR\BAZ\TestTraits;

use DarlingCms\interfaces\component\BAR\BAZ\FOO;

trait FOOTestTrait
{

    private $fOO;

    protected function setFOOParentTestInstances(): void
    {
        $this->setComponent($this->getFOO());
        $this->setComponentParentTestInstances();
    }

    public function getFOO(): FOO
    {
        return $this->fOO;
    }

    public function setFOO(FOO $fOO)
    {
        $this->fOO = $fOO;
    }

}
