<?php

namespace UnitTests\classes\component\Bar\Baz;

use DarlingCms\classes\component\Bar\Baz\Foo;
use DarlingCms\classes\primary\Storable;
use UnitTests\abstractions\component\Bar\Baz\FooTest as AbstractFooTest;

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
