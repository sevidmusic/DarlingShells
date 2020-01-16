<?php

namespace UnitTests\interfaces\componentsdf\TestTraits;

use DarlingCms\interfaces\componentsdfsdfY;

trait asdfYTestTrait
{

    private $asdfY;

    protected function setasdfYParentTestInstances(): void
    {
        $this->setComponent($this->getasdfY());
        $this->setComponentParentTestInstances();
    }

    public function getasdfY(): asdfY
    {
        return $this->asdfY;
    }

    public function setasdfY(asdfY $asdfY)
    {
        $this->asdfY = $asdfY;
    }

}