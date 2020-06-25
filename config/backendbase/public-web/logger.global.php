<?php
declare(strict_types=1);

use Monolog\Logger;

return [
    'logger' => [
        'name' => 'public-web',
        'StreamHandler' => [
            'file_path' => 'data/logs/public-web.log',
            'level' => Logger::ERROR
        ]
    ]
];