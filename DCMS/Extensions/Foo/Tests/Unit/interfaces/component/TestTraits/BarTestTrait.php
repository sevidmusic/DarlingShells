<?php

namespace Extensions\Foo\Tests\Unit\interfaces\component\TestTraits;

use Extensions\Foo\core\interfaces\component\Bar;

trait BarTestTrait
{

    private $bar;

    protected function setBarParentTestInstances(): void
    {
        $this->setComponent($this->getBar());
        $this->setComponentParentTestInstances();
    }

    public function getBar(): Bar
    {
        return $this->bar;
    }

    public function setBar(Bar $bar)
    {
        $this->bar = $bar;
    }

}
