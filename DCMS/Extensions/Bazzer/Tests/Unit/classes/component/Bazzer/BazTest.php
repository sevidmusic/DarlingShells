<?php

namespace UnitTests\classes\component\Bazzer;

use DarlingCms\classes\primary\Storable;
use DarlingCms\classes\primary\Switchable;
use DarlingCms\classes\primary\Positionable;
use DarlingCms\classes\component\Bazzer\Baz;
use UnitTests\abstractions\component\Bazzer\BazTest as AbstractBazTest;

class BazTest extends AbstractBazTest
{
    public function setUp(): void
    {
        $this->setBaz(
            new Baz(
                new Storable(
                    'BazName',
                    'BazLocation',
                    'BazContainer'
                ),
                new Switchable(),
                new Positionable()
            )
        );
        $this->setBazParentTestInstances();
    }
}
