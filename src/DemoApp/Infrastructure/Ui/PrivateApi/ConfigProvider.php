<?php

declare(strict_types=1);

namespace DemoApp\PrivateApi;

use BackendBase\Shared\Interfaces\MezzioHandlerConfigProvider;
use DemoApp\PrivateApi\DemoModule\ConfigProvider as DemoModuleConfigProvider;
use Mezzio\Application;
use Mezzio\MiddlewareFactory;

use function array_merge_recursive;

class ConfigProvider
{
    /** @var MezzioHandlerConfigProvider[] */
    private array $modules = [];

    public function __construct()
    {
        $this->addConfigProviders(new DemoModuleConfigProvider());
    }

    private function addConfigProviders(MezzioHandlerConfigProvider $configProvider): void
    {
        $this->modules[] = $configProvider;
    }

    public function __invoke(): array
    {
        return [
            'dependencies' => $this->getDependencies(),
            'module-name'  => 'PrivateApi',
        ];
    }

    public function registerRoutes(Application $app, MiddlewareFactory $factory): void
    {
        foreach ($this->modules as $module) {
            $module->registerRoutes($app, $factory);
        }
    }

    /**
     * Returns the container dependencies
     */
    public function getDependencies(): array
    {
        $dependencies = [];
        foreach ($this->modules as $module) {
            $dependencies = array_merge_recursive($dependencies, $module->getDependencies());
        }

        return $dependencies;
    }
}
