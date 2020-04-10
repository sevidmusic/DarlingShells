<?php

namespace UnitTests\abstractions\component\Aod\ASifn;

use DarlingCms\classes\primary\Storable;
use DarlingCms\classes\primary\Switchable;
use DarlingCms\classes\primary\Positionable;
use UnitTests\abstractions\component\OutputComponentTest as CoreOutputComponentTest;
use DarlingCms\abstractions\component\Aod\ASifn\Wof;
use UnitTests\interfaces\component\Aod\ASifn\TestTraits\WofTestTrait;

class WofTest extends CoreOutputComponentTest
{
    use WofTestTrait;

    public function setUp(): void
    {
        $this->setWof(
            $this->getMockForAbstractClass(
                '\DarlingCms\abstractions\component\Aod\ASifn\Wof',
                [
                    new Storable(
                        'MockWofName',
                        'MockWofLocation',
                        'MockWofContainer'
                    ),
                    new Switchable(),
                    new Positionable()
                ]
            )
        );
        $this->setWofParentTestInstances();
    }

}