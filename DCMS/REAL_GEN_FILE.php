<?php

namespace UnitTests\classes\component\BAR\BAZ;

use DarlingCms\classes\component\BAR\BAZ\FOO;
use DarlingCms\classes\primary\Storable;
use UnitTests\abstractions\component\BAR\BAZ\FOOTest as AbstractFOOTest;

class FOOTest extends AbstractFOOTest
{
    public function setUp(): void
    {
        $this->setFOO(
            new FOO(
                new Storable(
                    'FOOName',
                    'FOOLocation',
                    'FOOContainer'
                ),
            )
        );
        $this->setFOOParentTestInstances();
    }
}
