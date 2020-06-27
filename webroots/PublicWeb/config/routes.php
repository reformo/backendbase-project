<?php

declare(strict_types=1);

use Psr\Container\ContainerInterface;
use BackendBase\PublicWeb\ConfigProvider as PublicWebConfigProvider;
use Mezzio\Application;
use Mezzio\MiddlewareFactory;

/**
 * @var Application $app
 * @var MiddlewareFactory $factory
 * @var ContainerInterface $container
 */
return static function (Application $app, MiddlewareFactory $factory, ContainerInterface $container) : void {
    (new PublicWebConfigProvider())->registerRoutes($app, $factory);
    $config = $container->get('config');
    (new $config['applicationPublicWebConfigs']())->registerRoutes($app, $factory);
};
