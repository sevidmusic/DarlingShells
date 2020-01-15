<?php

namespace UnitTests\interfaces\component\Fo\BB\TestTraits;

use DarlingCms\interfaces\component\Fo\BB\Sevi;

// DS_USED_TEST_TRAIT_ALIASES;

trait SeviTestTrait
{

    // DS_USED_TEST_TRAITS

    private $sevi;

    public function getSevi(): Sevi
    {
        return $this->sevi;
    }

    public function setSevi(Sevi $sevi)
    {
        $this->sevi = $sevi;
    }

}