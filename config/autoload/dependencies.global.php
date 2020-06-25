<?php

declare(strict_types=1);


use BackendBase\Shared\Factory\DoctrineRepositoryFactory;

return [
    'dependencies' => [
        'aliases' => [],
        'factories'  => [

        ],
        'lazy_services' => [
            // Mapping services to their class names is required
            // since the ServiceManager is not a declarative DIC.
            'class_map' => [

            ],
        ],
        'delegators' => [
        ],
    ],
];
