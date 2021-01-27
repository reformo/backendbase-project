<?php

declare(strict_types=1);

namespace DemoApp\PrivateApi\DemoModule;

use BackendBase\Shared\Factory\RequestHandlerFactory;
use BackendBase\Shared\Interfaces\MezzioHandlerConfigProvider;
use Mezzio\Application;
use Mezzio\MiddlewareFactory;

/**
 * The configuration provider for the App module
 *
 * @see https://docs.zendframework.com/zend-component-installer/
 */
class ConfigProvider implements MezzioHandlerConfigProvider
{
    public function __invoke(): array
    {
        return [
            'dependencies'  => $this->getDependencies(),
        ];
    }

    public function registerRoutes(Application $app, MiddlewareFactory $factory): void
    {
        $app->get('/items', Handler\ItemsList::class, 'demo_module.list');
        $app->post('/items', Handler\AddItem::class, 'demo_module.new');
        $app->patch('/items/{itemId}', Handler\ChangeItem::class, 'demo_module.update');
    }

    /**
     * Returns the container dependencies
     */
    public function getDependencies(): array
    {
        return [
            'invokables' => [],
            'factories'  => [
                Handler\ItemsList::class => RequestHandlerFactory::class,
                Handler\AddItem::class => RequestHandlerFactory::class,
                Handler\ChangeItem::class => RequestHandlerFactory::class,
            ],
        ];
    }
}
