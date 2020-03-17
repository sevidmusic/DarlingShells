<?php

namespace UnitTests\interfaces\component\Bazzer\TestTraits;

use DarlingCms\interfaces\component\Bazzer\Baz;

trait BazTestTrait
{

    private $baz;

    protected function setBazParentTestInstances(): void
    {
        $this->setOutputComponent($this->getBaz());
        $this->setOutputComponentParentTestInstances();
    }

    public function getBaz(): Baz
    {
        return $this->baz;
    }

    public function setBaz(Baz $baz): void
    {
        $this->baz = $baz;
    }

}
