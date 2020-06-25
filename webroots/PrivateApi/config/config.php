<?php

declare(strict_types=1);

use Laminas\ConfigAggregator\ArrayProvider;
use Laminas\ConfigAggregator\ConfigAggregator;
use Laminas\ConfigAggregator\PhpFileProvider;
use Mezzio\ProblemDetails\ConfigProvider;
use BackendBase\Shared\DotEnvConfigProvider;

// To enable or disable caching, set the `ConfigAggregator::ENABLE_CACHE` boolean in
// `config/backendbase/local.php`.
$cacheConfig = ['config_cache_path' => 'data/cache/private-api-config-cache.php'];


$configList = [
    DotEnvConfigProvider::class,
    ConfigProvider::class,
    \Laminas\HttpHandlerRunner\ConfigProvider::class,
    \Mezzio\Router\FastRouteRouter\ConfigProvider::class,
    // Include cache configuration
    new ArrayProvider($cacheConfig),

    \Mezzio\Helper\ConfigProvider::class,
    \Mezzio\ConfigProvider::class,
    \Mezzio\Router\ConfigProvider::class,

    // Swoole config to overwrite some services (if installed)
    class_exists(\Mezzio\Swoole\ConfigProvider::class)
        ? \Mezzio\Swoole\ConfigProvider::class
        : static function () {
        return [];
    },

    // Default App module config
    BackendBase\PrivateApi\ConfigProvider::class,

    // Load application config in a pre-defined order in such a way that local settings
    // overwrite global settings. (Loaded as first to last):
    //   - `global.php`
    //   - `*.global.php`
    //   - `local.php`
    //   - `*.local.php`
    // Load backendbase config if it exists
    new PhpFileProvider('config/backendbase/{{,*.}global,{,*.}local}.php'),
    new PhpFileProvider('config/backendbase/private-api/{{,*.}global,{,*.}local}.php'),
    // Load application config if it exists
    new PhpFileProvider('config/autoload/{{,*.}global,{,*.}local}.php'),
    new PhpFileProvider('config/autoload/private-api/{{,*.}global,{,*.}local}.php'),
    // Load development config if it exists
    new PhpFileProvider('config/development.config.php'),
];
$appConfigList = require 'config/autoload/backendbase-application-configs.global.php';
$configList[] = $appConfigList['applicationPrivateApiConfigs'];

$aggregator  = new ConfigAggregator($configList, $cacheConfig['config_cache_path']);
return $aggregator->getMergedConfig();
