<?php

namespace UnitTests\abstractions\component;

use DarlingCms\classes\primary\Storable;
use UnitTests\interfaces\component\TestTraits\FooTestTrait;
use UnitTests\abstractions\component\ComponentTest;

class FooTest extends ComponentTest
{
    use FooTestTrait;

    public function setUp(): void
    {
        $this->setFoo(
            $this->getMockForAbstractClass(
                '\DarlingCms\abstractions\component\Foo',
                [
                    new Storable(
                        'MockFooName',
                        'MockFooLocation',
                        'MockFooContainer'
                    ),
                ]
            )
        );
        $this->setFooParentTestInstances();
    }

}
