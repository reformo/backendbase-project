<?php
declare(strict_types=1);

use Monolog\Logger;

return [
    'logger' => [
        'name' => 'private-api',
        'StreamHandler' => [
            'file_path' => 'data/logs/private-api.log',
            'level' => Logger::ERROR
        ]
    ]
];