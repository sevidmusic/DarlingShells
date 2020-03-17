<?php


namespace DarlingCms\classes\component\Bazzer;

use DarlingCms\abstractions\component\Bazzer\Baz as BazBase;
use DarlingCms\interfaces\component\Bazzer\Baz as BazInterface;

class Baz extends BazBase implements BazInterface
{
    /**
     * This is a generic implementation, it does not require
     * any additional logic, the BazBase class
     * fulfills the requirements of the BazInterface.
     */
}
