<?php

declare (strict_types=1);

namespace UppsalaUniversity\MiddleTurkicProject\Routing\Aspects;

use TYPO3\CMS\Core\Routing\Aspect\StaticMappableAspectInterface;

class StaticSameCaseMapper implements StaticMappableAspectInterface, \Countable
{
    public function count(): int
    {
        return 1;
    }

    public function generate(string $value): ?string
    {
        return $value;
    }

    public function resolve(string $value): ?string
    {
        return $value;
    }
}