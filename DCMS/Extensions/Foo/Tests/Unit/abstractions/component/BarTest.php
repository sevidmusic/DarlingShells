<?php

namespace Extensions\Foo\Tests\Unit\abstractions\component;

use DarlingCms\classes\primary\Storable;
use UnitTests\abstractions\component\ComponentTest;
use Extensions\Foo\Tests\Unit\interfaces\component\TestTraits\BarTestTrait;

class BarTest extends ComponentTest
{
    use BarTestTrait;

    public function setUp(): void
    {
        $this->setBar(
            $this->getMockForAbstractClass(
                '\Extensions\Foo\core\abstractions\component\Bar',
                [
                    new Storable(
                        'MockBarName',
                        'MockBarLocation',
                        'MockBarContainer'
                    ),
                ]
            )
        );
        $this->setBarParentTestInstances();
    }

}
