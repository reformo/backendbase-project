<?php

declare(strict_types=1);

use BackendBase\PrivateApi\ConfigProvider as PrivateApiConfigProvider;
use Mezzio\Application;
use Mezzio\MiddlewareFactory;
use Psr\Container\ContainerInterface;

/**
 * @var Application $app
 * @var MiddlewareFactory $factory
 * @var ContainerInterface $container
 */
return static function (Application $app, MiddlewareFactory $factory, ContainerInterface $container) : void {
    (new PrivateApiConfigProvider())->registerRoutes($app, $factory);
    $config = $container->get('config');
    (new $config['applicationPrivateApiConfigs']())->registerRoutes($app, $factory);
};
