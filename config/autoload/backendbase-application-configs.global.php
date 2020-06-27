<?php
declare(strict_types=1);

use DemoApp\PrivateApi\ConfigProvider as PrivateApiConfigProvider;
use DemoApp\PublicWeb\ConfigProvider as PublicWebConfigProvider;

return [
    'applicationPrivateApiConfigs' => PrivateApiConfigProvider::class,
    'applicationPublicWebConfigs' => PublicWebConfigProvider::class

];