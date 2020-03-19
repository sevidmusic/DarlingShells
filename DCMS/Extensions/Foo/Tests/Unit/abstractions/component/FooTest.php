<?php

namespace Extensions\Foo\Tests\Unit\abstractions\component;

use DarlingCms\classes\primary\Storable;
use Extensions\Foo\Tests\Unit\interfaces\component\TestTraits\FooTestTrait;
use UnitTests\abstractions\component\DS_PARENTCOMPONENT_NAME as BaseComponentTest;

class FooTest extends BaseComponentTest
{
    use FooTestTrait;

    public function setUp(): void
    {
        $this->setFoo(
            $this->getMockForAbstractClass(
                '\Extensions\Foo\core\abstractions\component\Foo',
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
