<?php
declare(strict_types=1);

return [
    'http' => [
        'response' => [
            'custom-headers' => [
                'Access-Control-Expose-Headers' => 'Accept-Ranges, Content-Ranges, Access-Control-Allow-Origin, BackendBase-Cache BackendBase-Insert-Id',
                'Access-Control-Allow-Headers' => 'Accept, Authorization, BackendBaseFileUploadProcess, Content-Type, Content-Transfer-Encoding, BackendBase-Api-Key',
                'Access-Control-Allow-Methods' => 'POST, GET, DELETE, PUT, PATCH, OPTIONS',
                'X-Content-Type-Options' => 'nosniff',
                'X-XSS-Protection' => '1; mode=block'
            ],
            'allow-origins' => explode(',', getenv('VALID_ACCESS_CONTROL_ALLOW_ORIGINS_FOR_PRIVATE_API')),
        ]
    ]
];