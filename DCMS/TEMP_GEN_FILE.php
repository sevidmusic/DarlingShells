<?php

namespace UnitTests\interfaces\component\EEE\TTTT\GGGG\TestTraits;

use DarlingCms\interfaces\component\EEE\TTTT\GGGG\Sec;

trait SecTestTrait
{

    private $Sec;

    public function getSec(): Sec
    {
        return $this->Sec;
    }

    public function setSec(Sec $Sec)
    {
        $this->Sec = $Sec;
    }

}