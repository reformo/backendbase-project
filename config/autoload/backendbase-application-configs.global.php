<?php
declare(strict_types=1);

use MissArapSabunu\PrivateApi\ConfigProvider as PrivateApiConfigProvider;
use MissArapSabunu\PublicWeb\ConfigProvider as PublicWebConfigProvider;

return [
    'applicationPrivateApiConfigs' => PrivateApiConfigProvider::class,
    'applicationPublicWebConfigs' => PublicWebConfigProvider::class

];