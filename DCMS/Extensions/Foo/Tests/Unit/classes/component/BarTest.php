<?php

namespace Extensions\Foo\Tests\Unit\classes\component;


use DarlingCms\classes\primary\Storable;
use Extensions\Foo\Tests\Unit\abstractions\component\BarTest as AbstractBarTest;
use Extensions\Foo\core\classes\component\Bar;

class BarTest extends AbstractBarTest
{
    public function setUp(): void
    {
        $this->setBar(
            new Bar(
                new Storable(
                    'BarName',
                    'BarLocation',
                    'BarContainer'
                ),
            )
        );
        $this->setBarParentTestInstances();
    }
}
