<?php
declare(strict_types=1);

use BackendBase\Shared\Middleware\CustomResponseHeadersMiddleware;
use BackendBase\Shared\Middleware\CustomResponseHeadersMiddlewareFactory;
use Mezzio\Helper;

return [
    'dependencies' => [
        'aliases' => [],
        'invokables' => [
            Helper\ContentLengthMiddleware::class => Helper\ContentLengthMiddleware::class,
        ],
        'factories'  => [
        ],
    ],
];
