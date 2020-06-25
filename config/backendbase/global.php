<?php
declare(strict_types=1);


return [
    'app' => [
        'base-url' => getenv('WEBSITE_BASE_URL'),
        'data_dir' => 'data',
        'storage-dir' => 'data/storage',
        'cdn-url' => getenv('BACKEND_CDN_URL'),
        'api-key' => getenv('PUBLIC_API_KEY'),
        'enable-api-key' => filter_var(getenv('ENABLE_PUBLIC_API_KEY'), FILTER_VALIDATE_BOOLEAN)
    ],
    'user-app' => 'miss-arap-sabunu'
];