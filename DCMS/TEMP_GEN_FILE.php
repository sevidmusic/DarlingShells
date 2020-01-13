<?php

namespace UnitTests\interfaces\component\Fii\TestTraits;

use DarlingCms\interfaces\component\Fii\SEvi;

trait SEviTestTrait
{

    private $SEvi;

    public function getSEvi(): SEvi
    {
        return $this->SEvi;
    }

    public function setSEvi(SEvi $SEvi)
    {
        $this->SEvi = $SEvi;
    }

}