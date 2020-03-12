<?php

namespace UnitTests\interfaces\component\Bazzer\Baz\TestTraits;

use DarlingCms\interfaces\component\Bazzer\Baz\FooBar;

trait FooBarTestTrait
{

    private $fooBar;

    protected function setFooBarParentTestInstances(): void
    {
        $this->setFooBarBaz($this->getFooBar());
        $this->setFooBarBazParentTestInstances();
    }

    public function getFooBar(): FooBar
    {
        return $this->fooBar;
    }

    public function setFooBar(FooBar $fooBar): void
    {
        $this->fooBar = $fooBar;
    }

}
