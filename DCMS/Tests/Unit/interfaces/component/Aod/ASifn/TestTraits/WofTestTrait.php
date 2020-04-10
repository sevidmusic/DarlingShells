<?php

namespace UnitTests\interfaces\component\Aod\ASifn\TestTraits;

use DarlingCms\interfaces\component\Aod\ASifn\Wof;

trait WofTestTrait
{

    private $wof;

    protected function setWofParentTestInstances(): void
    {
        $this->setOutputComponent($this->getWof());
        $this->setOutputComponentParentTestInstances();
    }

    public function getWof(): Wof
    {
        return $this->wof;
    }

    public function setWof(Wof $wof): void
    {
        $this->wof = $wof;
    }

}