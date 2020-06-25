<?php
declare(strict_types=1);

return [
    'mezzio-swoole' => [
        'swoole-http-server' => [
            'port' => 8080,
            'options' => [
                'pid_file' => sys_get_temp_dir() . '/zend-swoole-public-web.pid'
            ]
        ]
    ]
];