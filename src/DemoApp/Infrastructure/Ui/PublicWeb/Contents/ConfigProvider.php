<?php

declare(strict_types=1);

namespace DemoApp\PublicWeb\Contents;

use BackendBase\Shared\Factory\RequestHandlerFactory;
use BackendBase\Shared\Interfaces\MezzioHandlerConfigProvider;
use Mezzio\Application;
use Mezzio\MiddlewareFactory;
use BackendBase\PublicWeb\Contents\PageHandler;
/**
 * The configuration provider for the App module
 *
 * @see https://docs.zendframework.com/zend-component-installer/
 */
class ConfigProvider implements MezzioHandlerConfigProvider
{
    /**
     * Returns the configuration array
     *
     * To add a bit of a structure, each section is defined in a separate
     * method which returns an array with its configuration.
     */
    public function __invoke() : array
    {
        return [
            'dependencies' => $this->getDependencies(),
        ];
    }

    public function registerRoutes(Application $app, MiddlewareFactory $factory) : void
    {
        $app->get('/', Handler\HomePageHandler::class, 'home');
        $app->get('/{pageSlug:.+}', PageHandler::class, 'page'); // catch all
    }

    /**
     * Returns the container dependencies
     */
    public function getDependencies() : array
    {
        return [
            'invokables' => [],
            'factories'  => [
                Handler\HomePageHandler::class => RequestHandlerFactory::class,
                PageHandler::class => RequestHandlerFactory::class,
            ],
        ];
    }
}
