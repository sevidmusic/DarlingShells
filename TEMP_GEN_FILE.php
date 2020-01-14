<?php

namespace UnitTests\interfaces\component\Web\Output\Html\Resource\TestTraits;

use DarlingCms\interfaces\component\Web\Output\Html\Resource\JavaScriptImport;

trait JavaScriptImportTestTrait
{

    private $javaScriptImport;

    public function getJavaScriptImport(): JavaScriptImport
    {
        return $this->javaScriptImport;
    }

    public function setJavaScriptImport(JavaScriptImport $javaScriptImport)
    {
        $this->javaScriptImport = $javaScriptImport;
    }

}