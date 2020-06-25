<?php
declare(strict_types=1);

return [
    'http' => [
        'response' => [
            'custom-headers' => [
                'Access-Control-Expose-Headers' => 'Accept-Ranges, Content-Ranges, BackendBase-Insert-Id, Location, BackendBase-Cache',
                'Access-Control-Allow-Headers' => 'Accept, Authorization, BackendBaseFileUploadProcess, Content-Type, Content-Transfer-Encoding,  BackendBase-Api-Key, Cache-Control, Pragma',
                'Access-Control-Allow-Methods' => 'POST, GET, DELETE, PUT, PATCH, OPTIONS',
                'X-Content-Type-Options' => 'nosniff',
                'X-XSS-Protection' => '1; mode=block',
                'Strict-Transport-Security' => 'max-age=63072000',
                //'X‐Frame‐Options' => 'SAMEORIGIN'
            ],
            'allow-origins' => explode(',', getenv('VALID_ACCESS_CONTROL_ALLOW_ORIGINS_FOR_PUBLIC_API')),
        ]
    ]
];