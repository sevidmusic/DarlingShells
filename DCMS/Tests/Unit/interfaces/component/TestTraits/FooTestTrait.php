<?php

namespace UnitTests\interfaces\component\TestTraits;

use DarlingCms\interfaces\component\Foo;

trait FooTestTrait
{

    private $foo;

    protected function setFooParentTestInstances(): void
    {
        $this->setComponent($this->getFoo());
        $this->setComponentParentTestInstances();
    }

    public function getFoo(): Foo
    {
        return $this->foo;
    }

    public function setFoo(Foo $foo)
    {
        $this->foo = $foo;
    }

}
