<?php


namespace DarlingCms\classes\component\BAR\BAZ\BAZZER;

use DarlingCms\abstractions\component\BAR\BAZ\BAZZER\FOO as FOOBase;
use DarlingCms\interfaces\component\BAR\BAZ\BAZZER\FOO as FOOInterface;

class FOO extends FOOBase implements FOOInterface
{
    /**
     * This is a generic implementation, it does not require
     * any additional logic, the FOOBase class
     * fulfills the requirements of the FOOInterface.
     */
}
