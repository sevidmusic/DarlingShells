<?php

namespace UnitTests\classes\component\Bar\Bazzer;

use DarlingCms\classes\component\Bar\Bazzer\Foo;
use DarlingCms\classes\primary\Storable;
use UnitTests\abstractions\component\Bar\Bazzer\FooTest as AbstractFooTest;

class FooTest extends AbstractFooTest
{
    public function setUp(): void
    {
        $this->setFoo(
            new Foo(
                new Storable(
                    'FooName',
                    'FooLocation',
                    'FooContainer'
                ),
            )
        );
        $this->setFooParentTestInstances();
    }
}
