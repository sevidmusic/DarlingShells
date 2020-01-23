<?php

namespace UnitTests\classes\component\DS_COMPONENT_SUBTYPE;

use DarlingCms\classes\component\DS_COMPONENT_SUBTYPE\DS_COMPONENT_NAME;
use DarlingCms\classes\primary\Storable;
use UnitTests\abstractions\component\DS_COMPONENT_SUBTYPE\DS_COMPONENT_NAMETest as AbstractDS_COMPONENT_NAMETest;

class DS_COMPONENT_NAMETest extends AbstractDS_COMPONENT_NAMETest
{
    public function setUp(): void
    {
        $this->setDS_COMPONENT_NAME(
            new DS_COMPONENT_NAME(
                new Storable(
                    'DS_COMPONENT_NAMEName',
                    'DS_COMPONENT_NAMELocation',
                    'DS_COMPONENT_NAMEContainer'
                ),
            )
        );
        $this->setDS_COMPONENT_NAMEParentTestInstances();
    }
}