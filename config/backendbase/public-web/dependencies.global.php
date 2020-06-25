<?php
declare(strict_types=1);


use Mezzio\Helper;
use BackendBase\Shared\Factory\TwigExtensionFactory;
use BackendBase\Shared\Services\TwigExtension;
return [
    'dependencies' => [
        'aliases' => [],
        'invokables' => [
            Helper\ContentLengthMiddleware::class => Helper\ContentLengthMiddleware::class,
        ],
        'factories'  => [
            TwigExtension::class => TwigExtensionFactory::class,
        ],
    ],
];
