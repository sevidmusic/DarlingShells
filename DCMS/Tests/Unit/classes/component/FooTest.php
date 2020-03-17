<?php

namespace UnitTests\classes\component;

use DarlingCms\classes\component\Foo;
use DarlingCms\classes\primary\Storable;
use UnitTests\abstractions\component\FooTest as AbstractFooTest;

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
