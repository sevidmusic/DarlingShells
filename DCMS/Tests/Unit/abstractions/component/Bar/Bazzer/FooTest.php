<?php

namespace UnitTests\abstractions\component\Bar\Bazzer;

use DarlingCms\classes\primary\Storable;
use UnitTests\interfaces\component\Bar\Bazzer\TestTraits\FooTestTrait;
use UnitTests\abstractions\component\ComponentTest;

class FooTest extends ComponentTest
{
    use FooTestTrait;

    public function setUp(): void
    {
        $this->setFoo(
            $this->getMockForAbstractClass(
                '\DarlingCms\abstractions\component\Bar\Bazzer\Foo',
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
