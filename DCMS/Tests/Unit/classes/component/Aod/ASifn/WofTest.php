<?php

namespace UnitTests\classes\component\Aod\ASifn;

use DarlingCms\classes\primary\Storable;
use DarlingCms\classes\primary\Switchable;
use DarlingCms\classes\primary\Positionable;
use DarlingCms\classes\component\Aod\ASifn\Wof;
use UnitTests\abstractions\component\Aod\ASifn\WofTest as AbstractWofTest;

class WofTest extends AbstractWofTest
{
    public function setUp(): void
    {
        $this->setWof(
            new Wof(
                new Storable(
                    'WofName',
                    'WofLocation',
                    'WofContainer'
                ),
                new Switchable(),
                new Positionable()
            )
        );
        $this->setWofParentTestInstances();
    }
}