<?php
declare(strict_types=1);

use DemoApp\PrivateApi\ConfigProvider as PrivateApiConfigProvider;
use DemoApp\PublicWeb\ConfigProvider as PublicWebConfigProvider;

return [
    'applicationPrivateApiConfigs' => PrivateApiConfigProvider::class,
    'applicationPublicWebConfigs' => PublicWebConfigProvider::class,
    'jwt' => [
        'key' => getenv('BACKENDBASE_JWT_KEY'),
        'issuer' => getenv('BACKENDBASE_JWT_ISSUER'),
        'identifier' => getenv('BACKENDBASE_JWT_IDENTIFIER'),
    ]
];