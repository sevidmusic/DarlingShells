<?php

namespace UnitTests\abstractions\component\Bazzer;

use DarlingCms\classes\primary\Storable;
use DarlingCms\classes\primary\Switchable;
use DarlingCms\classes\primary\Positionable;
use UnitTests\interfaces\component\Bazzer\TestTraits\BazTestTrait;
use UnitTests\abstractions\component\OutputComponentTest;

class BazTest extends OutputComponentTest
{
    use BazTestTrait;

    public function setUp(): void
    {
        $this->setBaz(
            $this->getMockForAbstractClass(
                '\DarlingCms\abstractions\component\Bazzer\Baz',
                [
                    new Storable(
                        'MockBazName',
                        'MockBazLocation',
                        'MockBazContainer'
                    ),
                    new Switchable(),
                    new Positionable()
                ]
            )
        );
        $this->setBazParentTestInstances();
    }

}
